# 📋 Claude.md - Tmux Orchestrator Project Knowledge Base

> **Comprehensive guide for Claude agents acting as orchestrators and team members in the AI-powered session management system**

## 🎯 Project Overview

The Tmux Orchestrator is an AI-powered session management system where Claude acts as the orchestrator for multiple Claude agents across tmux sessions, managing codebases and keeping development moving forward 24/7.

### Core Principles

- **Continuous Development**: Teams work autonomously without human intervention
- **Quality-First**: No shortcuts, comprehensive testing, proper documentation
- **Distributed Intelligence**: Each agent specializes, orchestrator coordinates
- **Resilient Architecture**: Automatic recovery, progress preservation, session management

## 🏗️ Agent System Architecture

### Orchestrator Role

As the Orchestrator, you maintain high-level oversight without getting bogged down in implementation details:

- **Deploy and coordinate agent teams** with optimal team composition
- **Monitor system health** through regular status checks
- **Resolve cross-project dependencies** and resource conflicts
- **Make architectural decisions** for system-wide improvements
- **Ensure quality standards** are maintained across all projects

### Agent Types & Responsibilities

#### 1. **Project Manager** (Quality Guardian)
```yaml
Primary Role: Quality-focused team coordination
Responsibilities:
  - Enforce coding standards (based on project's CODE_STANDARDS.md)
  - Coordinate daily standups and status reports
  - Track sprint velocity and technical debt
  - Ensure comprehensive test coverage (>80%)
  - Review all code before merging
  - Create and maintain project documentation
```

#### 2. **Developer** (Implementation Expert)
```yaml
Primary Role: Feature implementation and bug fixes
Responsibilities:
  - Write clean, tested, documented code
  - Follow project's architectural patterns
  - Implement features based on requirements
  - Fix bugs with proper root cause analysis
  - Optimize performance bottlenecks
  - Maintain backwards compatibility
```

#### 3. **QA Engineer** (Quality Assurance)
```yaml
Primary Role: Testing and verification
Responsibilities:
  - Write comprehensive test suites
  - Perform integration testing
  - Create test plans and test cases
  - Verify bug fixes with regression tests
  - Monitor test coverage metrics
  - Load testing and performance validation
```

#### 4. **DevOps** (Infrastructure & Deployment)
```yaml
Primary Role: Infrastructure and deployment
Responsibilities:
  - Manage CI/CD pipelines
  - Configure development environments
  - Monitor system performance
  - Handle deployments and rollbacks
  - Maintain Docker configurations
  - Database migrations and backups
```

## 🔐 Git Discipline - MANDATORY FOR ALL AGENTS

### Core Git Safety Rules

**CRITICAL**: Every agent MUST follow these git practices to prevent work loss:

#### 1. **Auto-Commit Every 30 Minutes**

```bash
# Manual commit with descriptive message
git add -A
git commit -m "Progress: Implement user authentication with JWT tokens"
```

#### 2. **Commit Before Task Switches**

```bash
# Before switching tasks
git add -A
git commit -m "WIP: Pause work on feature X to address critical bug Y"
git push origin feature/current-branch
```

#### 3. **Feature Branch Workflow**

```bash
# Before starting any new feature/task
git checkout main
git pull origin main
git checkout -b feature/descriptive-name-issue-123

# During development
git add -A
git commit -m "feat(auth): add password reset functionality"

# After completing feature
git add -A
git commit -m "feat(auth): complete password reset with email verification"
git push origin feature/descriptive-name-issue-123
```

#### 4. **Commit Message Standards (Conventional Commits)**

```bash
# ✅ Good commit messages:
git commit -m "feat(auth): add two-factor authentication support"
git commit -m "fix(orders): resolve race condition in order processing"
git commit -m "docs(api): update authentication endpoint documentation"
git commit -m "test(products): add unit tests for inventory management"
git commit -m "refactor(database): optimize query performance for large datasets"

# ❌ Bad commit messages:
git commit -m "fixes"
git commit -m "update code"
git commit -m "changes"
```

#### 5. **Never Work >1 Hour Without Committing**

```bash
# Emergency commit if needed
git add -A
git commit -m "WIP: Emergency commit - [describe current state]"
```

## 🚀 Development Standards & Best Practices

### Code Quality Requirements

#### Testing Standards
- **Unit Tests**: Minimum 80% coverage
- **Integration Tests**: All API endpoints tested
- **E2E Tests**: Critical user flows covered
- **Performance Tests**: Response times < 200ms

#### Code Review Checklist
- [ ] All tests passing
- [ ] No linting errors
- [ ] Security scan clean
- [ ] Documentation updated
- [ ] Commit message follows standards
- [ ] No commented code
- [ ] Proper error handling

### API Standards

```python
# ✅ Good: Clear, typed, documented
@router.get(
    "/orders",
    response_model=PaginatedResponse[OrderResponse],
    summary="List orders",
    description="Retrieve a paginated list of orders with optional filtering"
)
async def list_orders(
    page: int = Query(1, ge=1, description="Page number"),
    size: int = Query(20, ge=1, le=100, description="Items per page"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
) -> PaginatedResponse[OrderResponse]:
    """Retrieve orders with pagination and filtering."""
    # Implementation
```

## 🚨 Critical Self-Scheduling Protocol

### Mandatory Startup Verification

```bash
#!/bin/bash
# startup-verification.sh - MANDATORY orchestrator startup checks

perform_startup_checks() {
    echo "🔍 ORCHESTRATOR STARTUP VERIFICATION"
    echo "===================================="
    
    # 1. Verify tmux environment
    if [[ -n "$TMUX" ]]; then
        CURRENT_WINDOW=$(tmux display-message -p "#{session_name}:#{window_index}")
        echo "Current window: $CURRENT_WINDOW"
    else
        echo "❌ FAIL - Not in tmux!"
        return 1
    fi
    
    # 2. Verify scheduling script
    SCHEDULE_SCRIPT="$HOME/work/Tmux orchestrator/schedule_with_note.sh"
    if [[ -x "$SCHEDULE_SCRIPT" ]]; then
        echo "✅ Scheduling script ready"
    else
        echo "❌ FAIL - Script not found!"
        return 1
    fi
    
    # 3. Schedule first check
    "$SCHEDULE_SCRIPT" 15 "Regular orchestrator check - $CURRENT_WINDOW" "$CURRENT_WINDOW"
    echo "📅 Scheduled next check in 15 minutes"
    
    return 0
}
```

### Scheduling Best Practices

```yaml
orchestrator_schedules:
  self_maintenance:
    - task: "Self health check"
      interval: 15m
      priority: critical
    - task: "Memory and resource check"
      interval: 30m
      priority: high
  
  team_oversight:
    - task: "PM status collection"
      interval: 30m
      priority: high
    - task: "Developer progress check"
      interval: 1h
      priority: medium
    - task: "System-wide standup"
      interval: 4h
      priority: high
```

## 📋 Project Startup Sequence - ENHANCED FOR BROWNFIELD

### Brownfield Project Analysis

When adding an existing project, the orchestrator should automatically analyze:

```bash
#!/bin/bash
# analyze-brownfield-project.sh - Comprehensive project analysis

analyze_project() {
    local project_path="$1"
    local analysis_file="$project_path/.tmux-orchestrator-analysis.json"
    
    echo "🔍 ANALYZING BROWNFIELD PROJECT: $project_path"
    echo "=============================================="
    
    # 1. Project Type Detection
    PROJECT_TYPE=$(detect_project_type "$project_path")
    echo "📦 Project Type: $PROJECT_TYPE"
    
    # 2. Codebase Health Analysis
    analyze_codebase_health "$project_path"
    
    # 3. Git Repository Status
    analyze_git_status "$project_path"
    
    # 4. Dependencies & Security
    analyze_dependencies "$project_path"
    
    # 5. Test Coverage
    analyze_test_coverage "$project_path"
    
    # 6. Documentation Quality
    analyze_documentation "$project_path"
    
    # 7. Performance Bottlenecks
    analyze_performance "$project_path"
    
    # 8. Generate Improvement Recommendations
    generate_recommendations "$project_path"
    
    # 9. Create Action Plan
    create_action_plan "$project_path"
}

detect_project_type() {
    local project_path="$1"
    
    if [[ -f "$project_path/package.json" ]]; then
        # Analyze package.json for framework
        if grep -q "react" "$project_path/package.json"; then
            echo "react"
        elif grep -q "vue" "$project_path/package.json"; then
            echo "vue"
        elif grep -q "express" "$project_path/package.json"; then
            echo "nodejs-backend"
        else
            echo "nodejs"
        fi
    elif [[ -f "$project_path/requirements.txt" ]] || [[ -f "$project_path/pyproject.toml" ]]; then
        if [[ -f "$project_path/manage.py" ]]; then
            echo "django"
        elif grep -q "fastapi\|uvicorn" "$project_path/requirements.txt" 2>/dev/null; then
            echo "fastapi"
        elif grep -q "flask" "$project_path/requirements.txt" 2>/dev/null; then
            echo "flask"
        else
            echo "python"
        fi
    elif [[ -f "$project_path/Gemfile" ]]; then
        echo "ruby-rails"
    elif [[ -f "$project_path/go.mod" ]]; then
        echo "golang"
    elif [[ -f "$project_path/Cargo.toml" ]]; then
        echo "rust"
    else
        echo "unknown"
    fi
}

analyze_codebase_health() {
    local project_path="$1"
    
    echo "🏥 CODEBASE HEALTH ANALYSIS"
    echo "=========================="
    
    # File count and size analysis
    local total_files=$(find "$project_path" -type f -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" | wc -l)
    local lines_of_code=$(find "$project_path" -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
    
    echo "📊 Files: $total_files"
    echo "📊 Lines of Code: $lines_of_code"
    
    # Code complexity (simplified)
    local complexity_score="Medium"
    if [[ $lines_of_code -lt 1000 ]]; then
        complexity_score="Low"
        PROJECT_SIZE="small"
    elif [[ $lines_of_code -lt 10000 ]]; then
        complexity_score="Medium"
        PROJECT_SIZE="medium"
    else
        complexity_score="High"
        PROJECT_SIZE="large"
    fi
    
    echo "🎯 Complexity: $complexity_score"
    echo "📏 Project Size: $PROJECT_SIZE"
    
    # TODO/FIXME analysis
    local todo_count=$(find "$project_path" -name "*.py" -o -name "*.js" -o -name "*.ts" -exec grep -i "TODO\|FIXME\|XXX\|HACK" {} \; 2>/dev/null | wc -l)
    echo "⚠️  TODO/FIXME Count: $todo_count"
    
    # Dead code detection (simplified)
    local unused_imports=$(find "$project_path" -name "*.py" -exec grep -l "^import\|^from" {} \; 2>/dev/null | wc -l)
    echo "🧹 Files with imports: $unused_imports"
}

analyze_git_status() {
    local project_path="$1"
    
    echo "📚 GIT REPOSITORY ANALYSIS"
    echo "========================="
    
    cd "$project_path" || return 1
    
    # Repository health
    if [[ -d ".git" ]]; then
        echo "✅ Git repository detected"
        
        # Branch analysis
        local current_branch=$(git branch --show-current)
        local branch_count=$(git branch -a | wc -l)
        echo "🌳 Current Branch: $current_branch"
        echo "🌳 Total Branches: $branch_count"
        
        # Commit history
        local last_commit=$(git log -1 --format="%cr" 2>/dev/null || echo "Unknown")
        local commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
        echo "⏰ Last Commit: $last_commit"
        echo "📝 Total Commits: $commit_count"
        
        # Uncommitted changes
        local uncommitted=$(git status --porcelain | wc -l)
        echo "⚠️  Uncommitted Files: $uncommitted"
        
        # Remote status
        local remotes=$(git remote | wc -l)
        echo "🌐 Remote Repositories: $remotes"
        
        # Stashes
        local stashes=$(git stash list | wc -l)
        echo "📦 Stashes: $stashes"
    else
        echo "❌ No git repository found"
    fi
}

analyze_dependencies() {
    local project_path="$1"
    
    echo "📦 DEPENDENCIES & SECURITY ANALYSIS"
    echo "=================================="
    
    cd "$project_path" || return 1
    
    if [[ -f "package.json" ]]; then
        echo "📋 Node.js Dependencies:"
        local total_deps=$(cat package.json | jq '.dependencies | length' 2>/dev/null || echo "0")
        local dev_deps=$(cat package.json | jq '.devDependencies | length' 2>/dev/null || echo "0")
        echo "   Production: $total_deps"
        echo "   Development: $dev_deps"
        
        # Security audit (if npm available)
        if command -v npm >/dev/null; then
            echo "🔒 Running security audit..."
            npm audit --json > /tmp/audit.json 2>/dev/null || true
            local vulnerabilities=$(cat /tmp/audit.json | jq '.metadata.vulnerabilities | length' 2>/dev/null || echo "Unknown")
            echo "   Vulnerabilities: $vulnerabilities"
        fi
        
    elif [[ -f "requirements.txt" ]]; then
        echo "📋 Python Dependencies:"
        local total_deps=$(wc -l < requirements.txt)
        echo "   Total: $total_deps"
        
        # Check for outdated packages (if pip available)
        if command -v pip >/dev/null; then
            echo "🔒 Checking for outdated packages..."
            pip list --outdated 2>/dev/null | wc -l
        fi
    fi
}

analyze_test_coverage() {
    local project_path="$1"
    
    echo "🧪 TEST COVERAGE ANALYSIS"
    echo "========================"
    
    cd "$project_path" || return 1
    
    # Find test files
    local test_files=$(find . -name "*test*" -o -name "*spec*" | grep -E "\.(py|js|ts)$" | wc -l)
    echo "📝 Test Files: $test_files"
    
    # Test directories
    local test_dirs=$(find . -type d -name "*test*" -o -name "*spec*" | wc -l)
    echo "📁 Test Directories: $test_dirs"
    
    # Estimate coverage (simplified heuristic)
    local source_files=$(find . -name "*.py" -o -name "*.js" -o -name "*.ts" | grep -v test | grep -v spec | wc -l)
    if [[ $source_files -gt 0 && $test_files -gt 0 ]]; then
        local coverage_ratio=$((test_files * 100 / source_files))
        echo "📊 Estimated Coverage Ratio: ${coverage_ratio}%"
    else
        echo "📊 Estimated Coverage Ratio: 0%"
    fi
}

analyze_documentation() {
    local project_path="$1"
    
    echo "📚 DOCUMENTATION ANALYSIS"
    echo "========================"
    
    # Documentation files
    local readme_exists="No"
    [[ -f "$project_path/README.md" ]] && readme_exists="Yes"
    echo "📄 README.md: $readme_exists"
    
    local api_docs_exists="No"
    [[ -f "$project_path/API.md" ]] || [[ -d "$project_path/docs" ]] && api_docs_exists="Yes"
    echo "📄 API Documentation: $api_docs_exists"
    
    local contributing_exists="No"
    [[ -f "$project_path/CONTRIBUTING.md" ]] && contributing_exists="Yes"
    echo "📄 Contributing Guide: $contributing_exists"
    
    # Code documentation (docstrings/comments)
    local documented_functions=0
    if [[ "$PROJECT_TYPE" == "python"* ]]; then
        documented_functions=$(find "$project_path" -name "*.py" -exec grep -l '"""' {} \; 2>/dev/null | wc -l)
    elif [[ "$PROJECT_TYPE" == *"node"* ]] || [[ "$PROJECT_TYPE" == "react" ]]; then
        documented_functions=$(find "$project_path" -name "*.js" -o -name "*.ts" -exec grep -l '/\*\*' {} \; 2>/dev/null | wc -l)
    fi
    echo "📝 Files with Documentation: $documented_functions"
}

generate_recommendations() {
    local project_path="$1"
    
    echo "💡 IMPROVEMENT RECOMMENDATIONS"
    echo "============================="
    
    local recommendations=()
    
    # Git recommendations
    if [[ ! -d "$project_path/.git" ]]; then
        recommendations+=("🔧 Initialize git repository for version control")
    fi
    
    if [[ $uncommitted -gt 0 ]]; then
        recommendations+=("🔧 Commit $uncommitted uncommitted files")
    fi
    
    # Testing recommendations
    if [[ $test_files -eq 0 ]]; then
        recommendations+=("🧪 Add test suite - no tests detected")
    elif [[ $coverage_ratio -lt 80 ]]; then
        recommendations+=("🧪 Improve test coverage (current: ${coverage_ratio}%, target: 80%)")
    fi
    
    # Documentation recommendations
    if [[ "$readme_exists" == "No" ]]; then
        recommendations+=("📚 Create README.md with project overview")
    fi
    
    if [[ "$api_docs_exists" == "No" ]]; then
        recommendations+=("📚 Add API documentation")
    fi
    
    # Security recommendations
    if [[ "$vulnerabilities" != "0" && "$vulnerabilities" != "Unknown" ]]; then
        recommendations+=("🔒 Fix $vulnerabilities security vulnerabilities")
    fi
    
    # Code quality recommendations
    if [[ $todo_count -gt 20 ]]; then
        recommendations+=("🧹 Address $todo_count TODO/FIXME items")
    fi
    
    # Performance recommendations
    if [[ "$PROJECT_SIZE" == "large" ]]; then
        recommendations+=("⚡ Consider code splitting and performance optimization")
    fi
    
    # Output recommendations
    for rec in "${recommendations[@]}"; do
        echo "  $rec"
    done
    
    if [[ ${#recommendations[@]} -eq 0 ]]; then
        echo "  ✅ Project appears to be in good shape!"
    fi
}

create_action_plan() {
    local project_path="$1"
    local action_plan_file="$project_path/TMUX_ORCHESTRATOR_ACTION_PLAN.md"
    
    cat > "$action_plan_file" << EOF
# Tmux Orchestrator Action Plan
Generated: $(date)
Project: $(basename "$project_path")
Type: $PROJECT_TYPE
Size: $PROJECT_SIZE

## Immediate Actions (High Priority)
- [ ] Set up development environment
- [ ] Run existing tests
- [ ] Check CI/CD pipeline status
- [ ] Review recent commits and issues

## Quality Improvements (Medium Priority)
- [ ] Increase test coverage to 80%
- [ ] Fix linting errors
- [ ] Update documentation
- [ ] Address security vulnerabilities

## Long-term Enhancements (Low Priority)
- [ ] Performance optimization
- [ ] Code refactoring
- [ ] Architecture improvements
- [ ] Developer experience enhancements

## Team Composition Recommendation
Based on project size ($PROJECT_SIZE), recommended team:
EOF

    # Add team recommendations based on project size
    case "$PROJECT_SIZE" in
        "small")
            cat >> "$action_plan_file" << EOF
- 1x Developer
- 1x Project Manager (part-time)
EOF
            ;;
        "medium")
            cat >> "$action_plan_file" << EOF
- 2x Developers
- 1x QA Engineer
- 1x Project Manager
EOF
            ;;
        "large")
            cat >> "$action_plan_file" << EOF
- 3x Developers (1 Senior, 2 Regular)
- 1x QA Engineer
- 1x DevOps Engineer
- 1x Project Manager
EOF
            ;;
    esac
    
    echo "📋 Action plan created: $action_plan_file"
}
```

### Project Startup Script - Enhanced

```bash
#!/bin/bash
# start-project-enhanced.sh - Enhanced project startup with brownfield support

start_project() {
    local project_identifier="$1"  # Can be name or path
    local force_analysis="$2"      # Optional: force re-analysis
    
    echo "🚀 ENHANCED PROJECT STARTUP"
    echo "=========================="
    
    # Determine if identifier is path or name
    if [[ -d "$project_identifier" ]]; then
        PROJECT_PATH="$project_identifier"
        PROJECT_NAME=$(basename "$PROJECT_PATH")
    else
        PROJECT_PATH=$(find_project "$project_identifier")
        PROJECT_NAME="$project_identifier"
    fi
    
    if [[ -z "$PROJECT_PATH" ]]; then
        echo "❌ Project not found: $project_identifier"
        exit 1
    fi
    
    echo "✅ Found project: $PROJECT_PATH"
    
    # Check if analysis exists and is recent
    local analysis_file="$PROJECT_PATH/.tmux-orchestrator-analysis.json"
    local needs_analysis=true
    
    if [[ -f "$analysis_file" && "$force_analysis" != "true" ]]; then
        local analysis_age=$(( $(date +%s) - $(stat -c %Y "$analysis_file") ))
        if [[ $analysis_age -lt 86400 ]]; then  # Less than 24 hours old
            needs_analysis=false
            echo "📊 Using existing analysis ($(( analysis_age / 3600 )) hours old)"
        fi
    fi
    
    # Run analysis if needed
    if [[ "$needs_analysis" == "true" ]]; then
        echo "🔍 Running brownfield analysis..."
        analyze_project "$PROJECT_PATH"
    fi
    
    # Create tmux session
    SESSION_NAME=$(echo "$PROJECT_NAME" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
    create_enhanced_session "$SESSION_NAME" "$PROJECT_PATH"
    
    # Deploy appropriate team based on analysis
    deploy_team_based_on_analysis "$SESSION_NAME" "$PROJECT_PATH"
    
    echo "✨ Enhanced project startup complete!"
    echo "📌 Attach with: tmux attach -t $SESSION_NAME"
    echo "📋 Review action plan: $PROJECT_PATH/TMUX_ORCHESTRATOR_ACTION_PLAN.md"
}
```

## 📊 Communication Protocols

### Structured Messaging System

```python
# Message templates for consistent communication
class MessageTemplates:
    @staticmethod
    def status_update(from_agent: str, completed_tasks: List[str], current_task: str, blockers: List[str]) -> str:
        return f"""[STATUS_UPDATE] {from_agent}
Completed: {', '.join(completed_tasks) if completed_tasks else 'None'}
Current: {current_task}
Blockers: {', '.join(blockers) if blockers else 'None'}
"""
    
    @staticmethod
    def task_assignment(task_title: str, description: str, priority: str) -> str:
        return f"""[TASK_ASSIGNMENT] {task_title}
Priority: {priority}
Description: {description}
Please acknowledge and provide ETA.
"""
```

### Hub-and-Spoke Pattern

```bash
# PM collects status from all team members
collect_team_status() {
    local session="$1"
    local pm_window="$2"
    
    # Send status requests to all agents
    for window in $(tmux list-windows -t "$session" -F "#{window_index}:#{window_name}" | grep Claude | grep -v PM); do
        local agent_window=$(echo "$window" | cut -d: -f1)
        send_message "$session:$agent_window" "[STATUS_REQUEST] Please provide current status update"
    done
    
    # Compile and send summary to orchestrator
    sleep 30  # Wait for responses
    compile_team_summary "$session" "$pm_window"
}
```

## 🔧 Quality Assurance Framework

### Automated Quality Gates

```yaml
quality_gates:
  pre_commit:
    - linting_check: true
    - type_check: true
    - unit_tests: true
    - security_scan: true
  
  pre_merge:
    - code_review: required
    - integration_tests: true
    - coverage_threshold: 80%
    - documentation_updated: true
  
  pre_deploy:
    - e2e_tests: true
    - performance_tests: true
    - security_audit: true
    - rollback_plan: required
```

### PM Quality Verification Script

```bash
#!/bin/bash
# quality-check.sh - Comprehensive quality verification

run_quality_suite() {
    local project_path="$1"
    local results=()
    
    echo "🔍 QUALITY VERIFICATION SUITE"
    
    # Test Coverage
    coverage=$(run_coverage_check "$project_path")
    [[ ${coverage%\%} -ge 80 ]] && results+=("coverage:pass") || results+=("coverage:fail")
    
    # Linting
    npm run lint --silent && results+=("lint:pass") || results+=("lint:fail")
    
    # Type Checking
    npm run type-check --silent && results+=("types:pass") || results+=("types:fail")
    
    # Security
    npm audit --production | grep -q "0 vulnerabilities" && results+=("security:pass") || results+=("security:warning")
    
    # Generate report
    generate_quality_report "${results[@]}"
}
```

## 📋 Quick Reference Commands

```bash
# Project Management
./start-project-enhanced.sh "project-name"
./analyze-brownfield-project.sh "/path/to/project"
./deploy-team.sh session-name project-size

# Agent Communication  
send_message session:window "message"
collect_team_status session pm-window

# Quality Assurance
./quality-check.sh /path/to/project
./run-tests.sh project-type

# System Health
./health-check.sh
./startup-verification.sh

# Emergency Recovery
./disaster-recovery.sh
```

## 🎯 Success Metrics

- **Code Quality**: >80% test coverage, 0 critical vulnerabilities
- **Team Velocity**: Consistent sprint completion, minimal blockers
- **System Health**: >95% agent responsiveness, <2hr commit frequency
- **Documentation**: All APIs documented, up-to-date README

---

**Core Philosophy**: Automate everything, verify constantly, fail fast, recover faster.