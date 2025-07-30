#!/bin/bash
# start-project-enhanced.sh - Enhanced project startup with brownfield support
# Usage: ./start-project-enhanced.sh <project-name-or-path> [force-analysis]

set -e

PROJECT_IDENTIFIER="$1"
FORCE_ANALYSIS="$2"

if [[ -z "$PROJECT_IDENTIFIER" ]]; then
    echo "Usage: $0 <project-name-or-path> [force-analysis]"
    echo ""
    echo "Examples:"
    echo "  $0 my-react-app                    # Find project by name"
    echo "  $0 /path/to/project                # Use specific path"
    echo "  $0 my-project force-analysis       # Force re-analysis"
    exit 1
fi

# Find project function
find_project() {
    local search_term="$1"
    local base_paths=(
        "$HOME/work"
        "$HOME/projects"
        "$HOME/src"
        "$HOME/code"
        "$HOME/dev"
        "$(pwd)"
    )
    
    for base in "${base_paths[@]}"; do
        if [[ -d "$base" ]]; then
            local found=$(find "$base" -maxdepth 3 -type d -iname "*$search_term*" 2>/dev/null | head -1)
            if [[ -n "$found" ]]; then
                echo "$found"
                return 0
            fi
        fi
    done
    
    return 1
}

# Create enhanced tmux session
create_enhanced_session() {
    local session_name="$1"
    local project_path="$2"
    local project_type="$3"
    
    echo "🖥️  Creating tmux session: $session_name"
    
    # Kill existing session if it exists
    tmux kill-session -t "$session_name" 2>/dev/null || true
    
    # Create session with orchestrator window
    tmux new-session -d -s "$session_name" -c "$project_path" -n "Orchestrator"
    
    # Window 1: Main shell
    tmux new-window -t "$session_name" -n "Shell" -c "$project_path"
    
    # Window 2: Development server (project-type specific)
    tmux new-window -t "$session_name" -n "Dev-Server" -c "$project_path"
    
    # Window 3: Tests
    tmux new-window -t "$session_name" -n "Tests" -c "$project_path"
    
    # Window 4: Logs/Monitoring
    tmux new-window -t "$session_name" -n "Logs" -c "$project_path"
    
    # Go back to orchestrator window
    tmux select-window -t "$session_name:0"
    
    echo "✅ Session created with 5 windows"
}

# Deploy team based on analysis
deploy_team_based_on_analysis() {
    local session_name="$1"
    local project_path="$2"
    local analysis_file="$project_path/.tmux-orchestrator-analysis.json"
    
    echo "👥 Deploying team based on project analysis..."
    
    # Read project size from analysis file if available
    local project_size="medium"  # default
    if [[ -f "$analysis_file" ]] && command -v jq >/dev/null 2>&1; then
        project_size=$(jq -r '.analysis.project.size' "$analysis_file" 2>/dev/null || echo "medium")
    fi
    
    echo "📏 Project size: $project_size"
    
    case "$project_size" in
        "small")
            deploy_small_team "$session_name" "$project_path"
            ;;
        "medium")
            deploy_medium_team "$session_name" "$project_path"
            ;;
        "large"|"enterprise")
            deploy_large_team "$session_name" "$project_path"
            ;;
        *)
            deploy_medium_team "$session_name" "$project_path"
            ;;
    esac
}

# Deploy small team (2-3 members)
deploy_small_team() {
    local session_name="$1"
    local project_path="$2"
    
    echo "🔧 Deploying small team configuration..."
    
    # Create PM window
    tmux new-window -t "$session_name" -n "Claude-PM" -c "$project_path"
    
    # Create Developer window
    tmux new-window -t "$session_name" -n "Claude-Dev" -c "$project_path"
    
    # Start Claude agents
    start_project_manager "$session_name" "$(tmux list-windows -t "$session_name" | grep Claude-PM | cut -d: -f1)" "$project_path"
    start_developer "$session_name" "$(tmux list-windows -t "$session_name" | grep Claude-Dev | cut -d: -f1)" "$project_path"
}

# Deploy medium team (4-5 members)
deploy_medium_team() {
    local session_name="$1" 
    local project_path="$2"
    
    echo "🔧 Deploying medium team configuration..."
    
    # Create team windows
    tmux new-window -t "$session_name" -n "Claude-PM" -c "$project_path"
    tmux new-window -t "$session_name" -n "Claude-Lead-Dev" -c "$project_path"
    tmux new-window -t "$session_name" -n "Claude-Dev" -c "$project_path"
    tmux new-window -t "$session_name" -n "Claude-QA" -c "$project_path"
    
    # Start Claude agents
    start_project_manager "$session_name" "$(tmux list-windows -t "$session_name" | grep Claude-PM | cut -d: -f1)" "$project_path"
    start_lead_developer "$session_name" "$(tmux list-windows -t "$session_name" | grep Claude-Lead-Dev | cut -d: -f1)" "$project_path"
    start_developer "$session_name" "$(tmux list-windows -t "$session_name" | grep Claude-Dev | cut -d: -f1)" "$project_path"
    start_qa_engineer "$session_name" "$(tmux list-windows -t "$session_name" | grep Claude-QA | cut -d: -f1)" "$project_path"
}

# Deploy large team (6-8 members)
deploy_large_team() {
    local session_name="$1"
    local project_path="$2"
    
    echo "🔧 Deploying large team configuration..."
    
    # Create team windows
    tmux new-window -t "$session_name" -n "Claude-PM" -c "$project_path"
    tmux new-window -t "$session_name" -n "Claude-Tech-Lead" -c "$project_path"
    tmux new-window -t "$session_name" -n "Claude-Senior-Dev" -c "$project_path"
    tmux new-window -t "$session_name" -n "Claude-Dev" -c "$project_path"
    tmux new-window -t "$session_name" -n "Claude-QA" -c "$project_path"
    tmux new-window -t "$session_name" -n "Claude-DevOps" -c "$project_path"
    
    # Start Claude agents
    start_project_manager "$session_name" "$(tmux list-windows -t "$session_name" | grep Claude-PM | cut -d: -f1)" "$project_path"
    start_tech_lead "$session_name" "$(tmux list-windows -t "$session_name" | grep Claude-Tech-Lead | cut -d: -f1)" "$project_path"
    start_senior_developer "$session_name" "$(tmux list-windows -t "$session_name" | grep Claude-Senior-Dev | cut -d: -f1)" "$project_path"  
    start_developer "$session_name" "$(tmux list-windows -t "$session_name" | grep Claude-Dev | cut -d: -f1)" "$project_path"
    start_qa_engineer "$session_name" "$(tmux list-windows -t "$session_name" | grep Claude-QA | cut -d: -f1)" "$project_path"
    start_devops_engineer "$session_name" "$(tmux list-windows -t "$session_name" | grep Claude-DevOps | cut -d: -f1)" "$project_path"
}

# Agent starter functions
start_project_manager() {
    local session="$1"
    local window="$2"
    local project_path="$3"
    
    echo "🎯 Starting Project Manager in $session:$window"
    
    tmux send-keys -t "$session:$window" "claude --dangerously-skip-permissions" Enter
    sleep 5
    
    # Send PM briefing
    local briefing="You are the Project Manager for this project. Your primary responsibilities:

**IMMEDIATE TASKS:**
1. Review the action plan: $project_path/TMUX_ORCHESTRATOR_ACTION_PLAN.md
2. Analyze the project structure and understand current state
3. Check git repository status and recent commits
4. Assess code quality and technical debt

**ONGOING RESPONSIBILITIES:**
- Enforce quality standards (80% test coverage minimum)
- Coordinate daily standups with team members
- Review all code before merging
- Track sprint velocity and technical debt
- Ensure comprehensive documentation

**COMMUNICATION:**
- Send status updates to orchestrator every 2 hours
- Coordinate with team members through hub-and-spoke pattern
- Escalate blockers immediately

**QUALITY GATES:**
Never allow merges without:
- All tests passing
- Code coverage ≥ 80%
- No linting errors
- Security scan clean
- Documentation updated

Begin by analyzing the current project state and creating your first team standup."

    send_message "$session:$window" "$briefing"
}

start_developer() {
    local session="$1"
    local window="$2"
    local project_path="$3"
    
    echo "💻 Starting Developer in $session:$window"
    
    tmux send-keys -t "$session:$window" "claude --dangerously-skip-permissions" Enter
    sleep 5
    
    local briefing="You are a Developer on this project. Your responsibilities:

**IMMEDIATE TASKS:**
1. Set up the development environment
2. Run existing tests and verify they pass
3. Review recent commits and understand codebase
4. Check for immediate issues or quick wins

**DEVELOPMENT STANDARDS:**
- Follow the project's coding standards
- Write tests for all new features (minimum 80% coverage)
- Commit every 30 minutes maximum
- Use conventional commit messages
- Always work on feature branches

**WORKFLOW:**
- Check in with PM every hour
- Report blockers immediately
- Review action plan for assigned tasks
- Focus on code quality over speed

**GIT DISCIPLINE:**
- Never work >1 hour without committing
- Always use feature branches
- Push to remote regularly
- Write descriptive commit messages

Start by setting up your development environment and reporting status to the PM."

    send_message "$session:$window" "$briefing"
}

start_lead_developer() {
    local session="$1"
    local window="$2"
    local project_path="$3"
    
    echo "👨‍💻 Starting Lead Developer in $session:$window"
    
    tmux send-keys -t "$session:$window" "claude --dangerously-skip-permissions" Enter
    sleep 5
    
    local briefing="You are the Lead Developer for this project. Your responsibilities:

**IMMEDIATE TASKS:**
1. Review project architecture and identify improvement opportunities
2. Analyze technical debt and create refactoring plan
3. Review action plan and prioritize technical tasks
4. Set up development standards and tooling

**LEADERSHIP RESPONSIBILITIES:**
- Make architectural decisions
- Review complex code changes
- Mentor other developers
- Establish development best practices
- Coordinate technical discussions

**TECHNICAL FOCUS:**
- System architecture and design patterns
- Performance optimization
- Code quality and maintainability
- Technology selection and upgrades
- Complex feature implementation

**COMMUNICATION:**
- Regular check-ins with PM and team
- Technical discussions with other developers
- Architecture decisions documentation
- Code review leadership

Begin by analyzing the current architecture and technical debt situation."

    send_message "$session:$window" "$briefing" 
}

start_tech_lead() {
    local session="$1"
    local window="$2"
    local project_path="$3"
    
    echo "🏗️ Starting Tech Lead in $session:$window"
    
    tmux send-keys -t "$session:$window" "claude --dangerously-skip-permissions" Enter
    sleep 5
    
    local briefing="You are the Tech Lead for this project. Your responsibilities:

**STRATEGIC OVERSIGHT:**
1. System architecture and high-level technical decisions
2. Cross-team coordination and dependency management
3. Technology roadmap and evolution planning
4. Technical risk assessment and mitigation

**IMMEDIATE TASKS:**
1. Comprehensive architecture review
2. Evaluate current technology stack
3. Identify system bottlenecks and scaling issues
4. Plan technical improvements and migrations

**LEADERSHIP DUTIES:**
- Guide technical discussions and decisions
- Resolve technical conflicts and disputes
- Establish coding standards and best practices
- Mentor senior and junior developers
- Interface with product and business stakeholders

**LONG-TERM PLANNING:**
- System scalability and performance
- Technology debt management
- Team technical growth and development
- Innovation and new technology adoption

Start with a comprehensive technical assessment of the current system."

    send_message "$session:$window" "$briefing"
}

start_senior_developer() {
    local session="$1"
    local window="$2"
    local project_path="$3"
    
    echo "🥇 Starting Senior Developer in $session:$window"
    
    tmux send-keys -t "$session:$window" "claude --dangerously-skip-permissions" Enter
    sleep 5
    
    local briefing="You are a Senior Developer on this project. Your responsibilities:

**TECHNICAL EXCELLENCE:**
1. Complex feature implementation
2. Performance optimization and profiling
3. Code review and mentoring
4. Technical problem solving

**IMMEDIATE TASKS:**
1. Review codebase for optimization opportunities
2. Identify performance bottlenecks
3. Assess testing strategy and coverage
4. Review and improve CI/CD pipeline

**MENTORING RESPONSIBILITIES:**
- Guide junior developers
- Share best practices and knowledge
- Review code for quality and maintainability
- Provide technical guidance and support

**DEVELOPMENT FOCUS:**
- Complex algorithms and data structures
- System integration challenges
- Performance-critical components
- Technical innovation and improvement

Work closely with the Tech Lead and other developers to deliver high-quality solutions."

    send_message "$session:$window" "$briefing"
}

start_qa_engineer() {
    local session="$1"
    local window="$2"
    local project_path="$3"
    
    echo "🧪 Starting QA Engineer in $session:$window"
    
    tmux send-keys -t "$session:$window" "claude --dangerously-skip-permissions" Enter
    sleep 5
    
    local briefing="You are the QA Engineer for this project. Your responsibilities:

**QUALITY ASSURANCE:**
1. Develop comprehensive test strategy
2. Implement test automation framework
3. Ensure minimum 80% test coverage
4. Perform regression testing

**IMMEDIATE TASKS:**
1. Assess current testing situation
2. Set up test automation tools
3. Create test plans for existing features
4. Implement missing test coverage

**TESTING RESPONSIBILITIES:**
- Unit test strategy and implementation
- Integration testing across components
- End-to-end testing for user workflows
- Performance testing and benchmarking
- Security testing basics

**QUALITY GATES:**
- All features must have tests before merge
- No regression in existing functionality
- Performance benchmarks must be met
- Security vulnerabilities must be addressed

**TOOLS & FRAMEWORKS:**
Set up appropriate testing tools based on project type (Jest, pytest, Cypress, etc.)

Begin by assessing the current test coverage and creating a comprehensive test plan."

    send_message "$session:$window" "$briefing"
}

start_devops_engineer() {
    local session="$1"
    local window="$2" 
    local project_path="$3"
    
    echo "🔧 Starting DevOps Engineer in $session:$window"
    
    tmux send-keys -t "$session:$window" "claude --dangerously-skip-permissions" Enter
    sleep 5
    
    local briefing="You are the DevOps Engineer for this project. Your responsibilities:

**INFRASTRUCTURE & DEPLOYMENT:**
1. Set up and maintain CI/CD pipelines
2. Manage development and production environments
3. Monitor system performance and reliability
4. Handle deployments and rollbacks

**IMMEDIATE TASKS:**
1. Review existing CI/CD setup
2. Assess deployment process and automation
3. Set up monitoring and alerting
4. Review infrastructure security

**OPERATIONAL RESPONSIBILITIES:**
- Automated testing in CI pipeline
- Deployment automation and strategies
- Environment configuration management
- System monitoring and observability
- Backup and disaster recovery

**TOOLS & TECHNOLOGIES:**
- Docker and containerization
- Cloud platforms (AWS, GCP, Azure)
- CI/CD tools (GitHub Actions, GitLab CI)
- Monitoring tools (Prometheus, Grafana)
- Infrastructure as Code

**SECURITY FOCUS:**
- Vulnerability scanning in pipeline
- Secret management
- Access control and permissions
- Security monitoring and alerting

Start by assessing the current infrastructure and deployment process."

    send_message "$session:$window" "$briefing"
}

# Send message function
send_message() {
    local target="$1"
    local message="$2"
    
    # Use the existing message script if available, otherwise direct tmux
    if [[ -f "$HOME/work/Tmux orchestrator/send-claude-message.sh" ]]; then
        "$HOME/work/Tmux orchestrator/send-claude-message.sh" "$target" "$message"
    else
        # Fallback to direct tmux
        echo "$message" | tmux load-buffer -
        tmux paste-buffer -t "$target"
        tmux send-keys -t "$target" Enter
    fi
}

# Setup development server based on project type
setup_development_server() {
    local session_name="$1"
    local project_path="$2"
    local project_type="$3"
    
    echo "🚀 Setting up development server for $project_type..."
    
    local dev_window=$(tmux list-windows -t "$session_name" | grep "Dev-Server" | cut -d: -f1)
    
    case "$project_type" in
        "react"|"vue"|"nextjs")
            if [[ -f "$project_path/yarn.lock" ]]; then
                tmux send-keys -t "$session_name:$dev_window" "yarn install && yarn dev" Enter
            elif [[ -f "$project_path/pnpm-lock.yaml" ]]; then
                tmux send-keys -t "$session_name:$dev_window" "pnpm install && pnpm dev" Enter
            else
                tmux send-keys -t "$session_name:$dev_window" "npm install && npm run dev" Enter
            fi
            ;;
        "nodejs"|"nodejs-backend")
            tmux send-keys -t "$session_name:$dev_window" "npm install && npm start" Enter
            ;;
        "python"|"django"|"flask"|"fastapi")
            if [[ -d "$project_path/venv" ]]; then
                tmux send-keys -t "$session_name:$dev_window" "source venv/bin/activate" Enter
            elif [[ -d "$project_path/.venv" ]]; then
                tmux send-keys -t "$session_name:$dev_window" "source .venv/bin/activate" Enter
            fi
            
            if [[ "$project_type" == "django" ]]; then
                tmux send-keys -t "$session_name:$dev_window" "python manage.py runserver" Enter
            elif [[ "$project_type" == "fastapi" ]]; then
                tmux send-keys -t "$session_name:$dev_window" "uvicorn app.main:app --reload" Enter
            else
                tmux send-keys -t "$session_name:$dev_window" "python app.py" Enter
            fi
            ;;
        "golang")
            tmux send-keys -t "$session_name:$dev_window" "go run main.go" Enter
            ;;
        "rust")
            tmux send-keys -t "$session_name:$dev_window" "cargo run" Enter
            ;;
        *)
            tmux send-keys -t "$session_name:$dev_window" "echo 'Manual setup required for project type: $project_type'" Enter
            ;;
    esac
}

# Main function
main() {
    echo "🚀 ENHANCED PROJECT STARTUP WITH BROWNFIELD SUPPORT"
    echo "=================================================="
    echo ""
    
    # Determine if identifier is path or name
    if [[ -d "$PROJECT_IDENTIFIER" ]]; then
        PROJECT_PATH=$(realpath "$PROJECT_IDENTIFIER")
        PROJECT_NAME=$(basename "$PROJECT_PATH")
        echo "✅ Using provided path: $PROJECT_PATH"
    else
        echo "🔍 Searching for project: $PROJECT_IDENTIFIER"
        PROJECT_PATH=$(find_project "$PROJECT_IDENTIFIER")
        PROJECT_NAME="$PROJECT_IDENTIFIER"
        
        if [[ -z "$PROJECT_PATH" ]]; then
            echo "❌ Project not found: $PROJECT_IDENTIFIER"
            echo ""
            echo "Searched in:"
            echo "  - $HOME/work"
            echo "  - $HOME/projects" 
            echo "  - $HOME/src"
            echo "  - $HOME/code"
            echo "  - $HOME/dev"
            echo "  - $(pwd)"
            echo ""
            echo "💡 Try using the full path: $0 /full/path/to/project"
            exit 1
        fi
        
        echo "✅ Found project: $PROJECT_PATH"
    fi
    
    # Check if analysis exists and is recent
    local analysis_file="$PROJECT_PATH/.tmux-orchestrator-analysis.json"
    local needs_analysis=true
    
    if [[ -f "$analysis_file" && "$FORCE_ANALYSIS" != "force-analysis" ]]; then
        local analysis_age=$(( $(date +%s) - $(stat -c %Y "$analysis_file") ))
        if [[ $analysis_age -lt 86400 ]]; then  # Less than 24 hours old
            needs_analysis=false
            echo "📊 Using existing analysis ($(( analysis_age / 3600 )) hours old)"
        fi
    fi
    
    # Run brownfield analysis if needed
    if [[ "$needs_analysis" == "true" ]]; then
        echo "🔍 Running brownfield analysis..."
        if [[ -f "./analyze-brownfield-project.sh" ]]; then
            ./analyze-brownfield-project.sh "$PROJECT_PATH"
        else
            echo "⚠️  Brownfield analysis script not found, continuing with basic setup"
        fi
        echo ""
    fi
    
    # Read project type from analysis or detect
    PROJECT_TYPE="unknown"
    if [[ -f "$analysis_file" ]] && command -v jq >/dev/null 2>&1; then
        PROJECT_TYPE=$(jq -r '.analysis.project.type' "$analysis_file" 2>/dev/null || echo "unknown")
    fi
    
    if [[ "$PROJECT_TYPE" == "unknown" ]]; then
        # Basic project type detection
        if [[ -f "$PROJECT_PATH/package.json" ]]; then
            PROJECT_TYPE="nodejs"
        elif [[ -f "$PROJECT_PATH/requirements.txt" ]]; then
            PROJECT_TYPE="python"
        fi
    fi
    
    echo "📦 Project Type: $PROJECT_TYPE"
    
    # Create tmux session
    SESSION_NAME=$(echo "$PROJECT_NAME" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
    create_enhanced_session "$SESSION_NAME" "$PROJECT_PATH" "$PROJECT_TYPE"
    
    # Set up development server
    setup_development_server "$SESSION_NAME" "$PROJECT_PATH" "$PROJECT_TYPE"
    
    # Deploy appropriate team based on analysis
    deploy_team_based_on_analysis "$SESSION_NAME" "$PROJECT_PATH"
    
    echo ""
    echo "✨ ENHANCED PROJECT STARTUP COMPLETE!"
    echo "====================================="
    echo "📌 Attach with: tmux attach -t $SESSION_NAME"
    echo "📋 Review action plan: $PROJECT_PATH/TMUX_ORCHESTRATOR_ACTION_PLAN.md"
    echo "📊 Analysis data: $PROJECT_PATH/.tmux-orchestrator-analysis.json"
    echo ""
    echo "🎯 Next steps:"
    echo "1. Attach to the session and review orchestrator window"
    echo "2. Check team status and progress"  
    echo "3. Monitor development server and tests"
    echo "4. Review and prioritize action plan items"
    echo ""
}

# Run main function
main