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
SESSION_NAME=$(echo "$PROJECT_NAME" | tr ' A-Z' '-a-z' | sed 's/^\.//g')

# Get the directory where this orchestrator script is located
ORCHESTRATOR_DIR=$(dirname "$(realpath "$0")")

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

    # Check if window exists before sending message
    # Support both window:name and session:window formats
    local session="${target%:*}"
    local window="${target#*:}"

    if ! tmux list-windows -t "$session" -F '#{window_name}' | grep -q "^${window}$"; then
        echo "Warning: Window $target not found, skipping message"
        return 1
    fi

    echo "$message" | tmux load-buffer -
    tmux paste-buffer -t "$target" 2>/dev/null || {
        echo "Warning: Failed to send message to $target"
        return 1
    }
    tmux send-keys -t "$target" Enter
}

# Load project specs - adapt to customer's existing structure
load_custom_requirements() {
    local project_path="$1"
    local requirements=""

    # Find customer's existing directories (don't force them to change)
    local common_dirs=(
        "specs" "epics" "stories" "requirements"
        "docs" ".claude" ".cursor" ".ai"
    )

    echo "🔍 Looking for your project specs..." >&2

    # Scan each directory if it exists
    for dir in "${common_dirs[@]}"; do
        local full_path="$project_path/$dir"

        if [[ -d "$full_path" ]]; then
            echo "📁 Found: $dir/" >&2

            # Read all markdown files in the directory
            while IFS= read -r -d '' file; do
                if [[ -f "$file" ]]; then
                    local filename=$(basename "$file")
                    echo "📄 Reading: $dir/$filename" >&2

                    if [[ -n "$requirements" ]]; then
                        requirements="$requirements

--- From $dir/$filename ---
$(cat "$file")"
                    else
                        requirements="$(cat "$file")"
                    fi
                fi
            done < <(find "$full_path" -name "*.md" -type f -print0 2>/dev/null)
        fi
    done

    # Also check root-level files (common patterns)
    local root_files=(
        "requirements.md" "REQUIREMENTS.md" "specs.md" "SPECS.md"
        "README.md" "CLAUDE.md" "project.md" "PROJECT.md"
    )

    for file in "${root_files[@]}"; do
        local full_file="$project_path/$file"
        if [[ -f "$full_file" ]]; then
            echo "📄 Found: $file" >&2

            if [[ -n "$requirements" ]]; then
                requirements="$requirements

--- From $file ---
$(cat "$full_file")"
            else
                requirements="$(cat "$full_file")"
            fi
        fi
    done

    if [[ -n "$requirements" ]]; then
        echo "$requirements"
        return 0
    else
        echo "ℹ️  No specs found - using standard workflow" >&2
        return 1
    fi
}

# Start agent with simple prompt
start_agent() {
    local window="$1"
    local role="$2"
    local project_type="$3"

    echo "Starting $role in window $window..."
    tmux send-keys -t "$SESSION_NAME:$window" "claude --dangerously-skip-permissions" Enter
    sleep 8  # Increased wait time for Claude to fully start

    # Load custom requirements
    local custom_req=$(load_custom_requirements "$PROJECT_PATH")

    # Base requirements message
    local base_msg=""
    local custom_suffix=""

    if [[ -n "$custom_req" ]]; then
        custom_suffix=" IMPORTANT: Follow these custom project requirements: $custom_req"
    fi

    case "$role" in
        "pm")
            base_msg="You are the Project Manager in $PROJECT_PATH. Your tools: send messages with '$ORCHESTRATOR_DIR/send-claude-message.sh <window> <message>', schedule checks with '$ORCHESTRATOR_DIR/schedule_with_note.sh <minutes> <note> <window>'. Collect team status every 5 minutes with 'STATUS?'. Enforce 80% test coverage. Block bad merges. Report to orchestrator. ACTION NOW: 1) Check git status 2) Send 'STATUS?' to all team members 3) Schedule your next check with: $ORCHESTRATOR_DIR/schedule_with_note.sh 5 'Team standup' '$SESSION_NAME:$window'"
            send_message "$SESSION_NAME:$window" "$base_msg$custom_suffix"
            ;;
        "dev")
            base_msg="You are a Developer in $PROJECT_PATH. Your tools: schedule self-checks with '$ORCHESTRATOR_DIR/schedule_with_note.sh <minutes> <note> <window>'. Commit every 5 minutes max. Use 'feat:', 'fix:', 'test:' in commits. Write tests for everything (80%+ coverage). Work on feature branches only. ACTION NOW: 1) Run 'git status' 2) Create feature branch 3) Start implementing and schedule check: $ORCHESTRATOR_DIR/schedule_with_note.sh 5 'Dev progress check' '$SESSION_NAME:$window'"
            send_message "$SESSION_NAME:$window" "$base_msg$custom_suffix"
            ;;
        "lead")
            base_msg="You are the Lead Developer in $PROJECT_PATH. Your tools: send messages with '$ORCHESTRATOR_DIR/send-claude-message.sh <window> <message>', schedule checks with '$ORCHESTRATOR_DIR/schedule_with_note.sh <minutes> <note> <window>'. Make architecture decisions. Review complex code. Handle difficult technical problems. Guide other developers. ACTION NOW: 1) Review project structure 2) Create technical roadmap 3) Schedule review: $ORCHESTRATOR_DIR/schedule_with_note.sh 5 'Architecture review' '$SESSION_NAME:$window'"
            send_message "$SESSION_NAME:$window" "$base_msg$custom_suffix"
            ;;
        "qa")
            base_msg="You are the QA Engineer in $PROJECT_PATH. Your tools: schedule self-checks with '$ORCHESTRATOR_DIR/schedule_with_note.sh <minutes> <note> <window>'. Ensure 80% test coverage minimum. Set up test automation. Write comprehensive test suites. Block releases that fail tests. ACTION NOW: 1) Check current test coverage 2) Create test plan 3) Schedule check: $ORCHESTRATOR_DIR/schedule_with_note.sh 5 'Test coverage update' '$SESSION_NAME:$window'"
            send_message "$SESSION_NAME:$window" "$base_msg$custom_suffix"
            ;;
        "devops")
            base_msg="You are the DevOps Engineer in $PROJECT_PATH. Your tools: schedule self-checks with '$ORCHESTRATOR_DIR/schedule_with_note.sh <minutes> <note> <window>'. Set up CI/CD pipelines. Manage deployments. Monitor system health. Handle infrastructure. ACTION NOW: 1) Review deployment process 2) Set up monitoring 3) Schedule check: $ORCHESTRATOR_DIR/schedule_with_note.sh 5 'Infrastructure health' '$SESSION_NAME:$window'"
            send_message "$SESSION_NAME:$window" "$base_msg$custom_suffix"
            ;;
    esac
}

# Create session and deploy team
main() {
    echo "🚀 Starting tmux orchestrator for $PROJECT_NAME"

    # Detect project
    PROJECT_TYPE=$(detect_project_type)
    TEAM_SIZE=$(get_team_size)

    echo "📦 Project: $PROJECT_TYPE ($TEAM_SIZE team), path: $PROJECT_PATH, session: $SESSION_NAME"

    # Kill existing session
    tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true

    # Create session
    tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_PATH" -n "Orchestrator"
    tmux new-window -t "$SESSION_NAME" -n "Shell" -c "$PROJECT_PATH"
    tmux new-window -t "$SESSION_NAME" -n "Dev-Server" -c "$PROJECT_PATH"
    tmux new-window -t "$SESSION_NAME" -n "Tests" -c "$PROJECT_PATH"

    # Start development server
    start_dev_server "$PROJECT_TYPE" "Dev-Server"

    # Deploy team based on size
    case "$TEAM_SIZE" in
        "small")
            tmux new-window -t "$SESSION_NAME" -n "Agent-PM" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Agent-Dev" -c "$PROJECT_PATH"
            start_agent "Agent-PM" "pm" "$PROJECT_TYPE"
            start_agent "Agent-Dev" "dev" "$PROJECT_TYPE"
            ;;
        "medium")
            tmux new-window -t "$SESSION_NAME" -n "Agent-PM" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Agent-Lead" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Agent-Dev" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Agent-QA" -c "$PROJECT_PATH"
            start_agent "Agent-PM" "pm" "$PROJECT_TYPE"
            start_agent "Agent-Lead" "lead" "$PROJECT_TYPE"
            start_agent "Agent-Dev" "dev" "$PROJECT_TYPE"
            start_agent "Agent-QA" "qa" "$PROJECT_TYPE"
            ;;
        "large")
            tmux new-window -t "$SESSION_NAME" -n "Agent-PM" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Agent-Tech-Lead" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Agent-Senior-Dev" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Agent-Dev" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Agent-QA" -c "$PROJECT_PATH"
            tmux new-window -t "$SESSION_NAME" -n "Agent-DevOps" -c "$PROJECT_PATH"
            start_agent "Agent-PM" "pm" "$PROJECT_TYPE"
            start_agent "Agent-Tech-Lead" "lead" "$PROJECT_TYPE"
            start_agent "Agent-Senior-Dev" "dev" "$PROJECT_TYPE"
            start_agent "Agent-Dev" "dev" "$PROJECT_TYPE"
            start_agent "Agent-QA" "qa" "$PROJECT_TYPE"
            start_agent "Agent-DevOps" "devops" "$PROJECT_TYPE"
            ;;
    esac

    # Start orchestrator
    echo "Starting orchestrator in Orchestrator window..."
    tmux select-window -t "$SESSION_NAME:Orchestrator"
    tmux send-keys -t "$SESSION_NAME:Orchestrator" "claude --dangerously-skip-permissions" Enter
    sleep 8

    # Load custom requirements for orchestrator
    local custom_req=$(load_custom_requirements "$PROJECT_PATH")
    local orchestrator_msg="You are the Orchestrator for this $PROJECT_TYPE project ($TEAM_SIZE team) in directory $PROJECT_PATH. Your team is deployed in these windows: $(tmux list-windows -t "$SESSION_NAME" -F '#{window_name}' | grep 'Agent-' | tr '\n' ', ' | sed 's/, $//').

YOUR TOOLS:
- Send messages: $ORCHESTRATOR_DIR/send-claude-message.sh <session:window> <message>
- Schedule checks: $ORCHESTRATOR_DIR/schedule_with_note.sh <minutes> <note> <window>

ACTION NOW:
1. Schedule your recurring health check: $ORCHESTRATOR_DIR/schedule_with_note.sh 15 'Health check all agents' '$SESSION_NAME:Orchestrator'
2. Send initial ping to all agents to verify they're active
3. Monitor for blockers and conflicts

Remember: Agents will self-schedule and report status. You coordinate and resolve issues."
    
    if [[ -n "$custom_req" ]]; then
        orchestrator_msg="$orchestrator_msg IMPORTANT: Follow these custom project requirements: $custom_req"
    fi
    
    # Brief orchestrator
    send_message "$SESSION_NAME:Orchestrator" "$orchestrator_msg"

    echo "✅ Orchestrator deployed!"
    echo "📌 Attach: tmux attach -t $SESSION_NAME"
    echo "🎯 Team: $TEAM_SIZE ($PROJECT_TYPE)"
}

main
