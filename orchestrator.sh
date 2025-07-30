#!/bin/bash
# orchestrator.sh - Single entry point for tmux orchestrator
# Usage: ./orchestrator.sh /path/to/project

set -e

PROJECT_PATH="$1"

if [[ -z "$PROJECT_PATH" || ! -d "$PROJECT_PATH" ]]; then
    echo "Usage: $0 /path/to/project"
    exit 1
fi

PROJECT_PATH=$(realpath "$PROJECT_PATH")
PROJECT_NAME=$(basename "$PROJECT_PATH")
SESSION_NAME=$(echo "$PROJECT_NAME" | tr ' A-Z' '-a-z')

# Simple project type detection
detect_project_type() {
    if [[ -f "$PROJECT_PATH/package.json" ]]; then
        if grep -q "react" "$PROJECT_PATH/package.json" 2>/dev/null; then
            echo "react"
        else
            echo "nodejs"
        fi
    elif [[ -f "$PROJECT_PATH/manage.py" ]]; then
        echo "django"
    elif [[ -f "$PROJECT_PATH/requirements.txt" ]]; then
        echo "python"
    elif [[ -f "$PROJECT_PATH/go.mod" ]]; then
        echo "go"
    elif [[ -f "$PROJECT_PATH/Cargo.toml" ]]; then
        echo "rust"
    else
        echo "unknown"
    fi
}

# Simple team size detection
get_team_size() {
    local loc=$(find "$PROJECT_PATH" -name "*.py" -o -name "*.js" -o -name "*.ts" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
    
    if [[ $loc -lt 1000 ]]; then
        echo "small"
    elif [[ $loc -lt 10000 ]]; then
        echo "medium" 
    else
        echo "large"
    fi
}

# Start development server
start_dev_server() {
    local project_type="$1"
    local dev_window="$2"
    
    case "$project_type" in
        "react")
            tmux send-keys -t "$SESSION_NAME:$dev_window" "npm install && npm start" Enter
            ;;
        "nodejs")
            tmux send-keys -t "$SESSION_NAME:$dev_window" "npm install && npm run dev" Enter
            ;;
        "django")
            tmux send-keys -t "$SESSION_NAME:$dev_window" "pip install -r requirements.txt && python manage.py runserver" Enter
            ;;
        "python")
            tmux send-keys -t "$SESSION_NAME:$dev_window" "pip install -r requirements.txt && python app.py" Enter
            ;;
        "go")
            tmux send-keys -t "$SESSION_NAME:$dev_window" "go run main.go" Enter
            ;;
        "rust")
            tmux send-keys -t "$SESSION_NAME:$dev_window" "cargo run" Enter
            ;;
    esac
}

# Send message to agent
send_message() {
    local target="$1"
    local message="$2"
    
    echo "$message" | tmux load-buffer -
    tmux paste-buffer -t "$target"
    tmux send-keys -t "$target" Enter
}

# Start agent with simple prompt
start_agent() {
    local window="$1"
    local role="$2"
    local project_type="$3"
    
    echo "Starting $role in window $window..."
    tmux send-keys -t "$SESSION_NAME:$window" "claude --dangerously-skip-permissions" Enter
    sleep 8  # Increased wait time for Claude to fully start
    
    case "$role" in
        "pm")
            send_message "$SESSION_NAME:$window" "You are the Project Manager. Collect team status every 4 hours with 'STATUS?'. Enforce 80% test coverage. Block bad merges. Report to orchestrator. Start by checking git status and setting up your first standup in 4 hours."
            ;;
        "dev")
            send_message "$SESSION_NAME:$window" "You are a Developer. Commit every 30 minutes max. Use 'feat:', 'fix:', 'test:' in commits. Write tests for everything (80%+ coverage). Work on feature branches only. Start by checking the codebase and creating your first feature branch."
            ;;
        "lead")
            send_message "$SESSION_NAME:$window" "You are the Lead Developer. Make architecture decisions. Review complex code. Handle difficult technical problems. Guide other developers. Start by reviewing the current architecture and creating a technical roadmap."
            ;;
        "qa")
            send_message "$SESSION_NAME:$window" "You are the QA Engineer. Ensure 80% test coverage minimum. Set up test automation. Write comprehensive test suites. Block releases that fail tests. Start by analyzing current test coverage and creating a test plan."
            ;;
        "devops")
            send_message "$SESSION_NAME:$window" "You are the DevOps Engineer. Set up CI/CD pipelines. Manage deployments. Monitor system health. Handle infrastructure. Start by reviewing the current deployment process and setting up monitoring."
            ;;
    esac
}

# Create session and deploy team
main() {
    echo "🚀 Starting tmux orchestrator for $PROJECT_NAME"
    
    # Detect project
    PROJECT_TYPE=$(detect_project_type)
    TEAM_SIZE=$(get_team_size)
    
    echo "📦 Project: $PROJECT_TYPE ($TEAM_SIZE team)"
    
    # Kill existing session
    tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true
    
    # Create session
    tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_PATH" -n "Orchestrator"
    tmux new-window -t "$SESSION_NAME" -n "Shell" -c "$PROJECT_PATH"
    tmux new-window -t "$SESSION_NAME" -n "Dev-Server" -c "$PROJECT_PATH"
    tmux new-window -t "$SESSION_NAME" -n "Tests" -c "$PROJECT_PATH"
    
    # Start development server
    start_dev_server "$PROJECT_TYPE" "2"
    
    # Deploy team based on size
    case "$TEAM_SIZE" in
        "small")
            tmux new-window -t "$SESSION_NAME" -n "Claude-PM" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Claude-Dev" -c "$PROJECT_PATH"
            start_agent "4" "pm" "$PROJECT_TYPE"
            start_agent "5" "dev" "$PROJECT_TYPE"
            ;;
        "medium")
            tmux new-window -t "$SESSION_NAME" -n "Claude-PM" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Claude-Lead" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Claude-Dev" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Claude-QA" -c "$PROJECT_PATH"
            start_agent "4" "pm" "$PROJECT_TYPE"
            start_agent "5" "lead" "$PROJECT_TYPE"
            start_agent "6" "dev" "$PROJECT_TYPE"
            start_agent "7" "qa" "$PROJECT_TYPE"
            ;;
        "large")
            tmux new-window -t "$SESSION_NAME" -n "Claude-PM" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Claude-Tech-Lead" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Claude-Senior-Dev" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Claude-Dev" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Claude-QA" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Claude-DevOps" -c "$PROJECT_PATH"
            start_agent "4" "pm" "$PROJECT_TYPE"
            start_agent "5" "lead" "$PROJECT_TYPE"
            start_agent "6" "dev" "$PROJECT_TYPE"
            start_agent "7" "dev" "$PROJECT_TYPE"
            start_agent "8" "qa" "$PROJECT_TYPE"
            start_agent "9" "devops" "$PROJECT_TYPE"
            ;;
    esac
    
    # Start orchestrator
    tmux select-window -t "$SESSION_NAME:0"
    tmux send-keys -t "$SESSION_NAME:0" "claude --dangerously-skip-permissions" Enter
    sleep 5
    
    # Brief orchestrator
    send_message "$SESSION_NAME:0" "You are the Orchestrator for this $PROJECT_TYPE project ($TEAM_SIZE team). Monitor agent health every 15 minutes. Schedule recurring checks with: ./schedule_with_note.sh 15 'Health check' '$SESSION_NAME:0'. Resolve conflicts and blockers. Make final decisions. Start by scheduling your first health check NOW."
    
    echo "✅ Orchestrator deployed!"
    echo "📌 Attach: tmux attach -t $SESSION_NAME"
    echo "🎯 Team: $TEAM_SIZE ($PROJECT_TYPE)"
}

main