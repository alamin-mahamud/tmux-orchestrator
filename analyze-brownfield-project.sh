#!/bin/bash
# analyze-brownfield-project.sh - Comprehensive brownfield project analysis
# Usage: ./analyze-brownfield-project.sh /path/to/project

set -e

PROJECT_PATH="$1"
PROJECT_TYPE=""
PROJECT_SIZE=""

if [[ -z "$PROJECT_PATH" ]]; then
    echo "Usage: $0 /path/to/project"
    exit 1
fi

if [[ ! -d "$PROJECT_PATH" ]]; then
    echo "❌ Project path does not exist: $PROJECT_PATH"
    exit 1
fi

# Convert to absolute path
PROJECT_PATH=$(realpath "$PROJECT_PATH")
PROJECT_NAME=$(basename "$PROJECT_PATH")

analyze_project() {
    local project_path="$1"
    local analysis_file="$project_path/.tmux-orchestrator-analysis.json"
    
    echo "🔍 ANALYZING BROWNFIELD PROJECT: $PROJECT_NAME"
    echo "=============================================="
    echo "📁 Path: $project_path"
    echo ""
    
    # 1. Project Type Detection
    PROJECT_TYPE=$(detect_project_type "$project_path")
    echo "📦 Project Type: $PROJECT_TYPE"
    echo ""
    
    # 2. Codebase Health Analysis
    analyze_codebase_health "$project_path"
    echo ""
    
    # 3. Git Repository Status
    analyze_git_status "$project_path"
    echo ""
    
    # 4. Dependencies & Security
    analyze_dependencies "$project_path"
    echo ""
    
    # 5. Test Coverage
    analyze_test_coverage "$project_path"
    echo ""
    
    # 6. Documentation Quality
    analyze_documentation "$project_path"
    echo ""
    
    # 7. Generate Improvement Recommendations
    generate_recommendations "$project_path"
    echo ""
    
    # 8. Create Action Plan
    create_action_plan "$project_path"
    echo ""
    
    # 9. Generate JSON Analysis File
    generate_analysis_json "$project_path" "$analysis_file"
    
    echo "✅ Analysis complete! Generated:"
    echo "   📋 Action Plan: $project_path/TMUX_ORCHESTRATOR_ACTION_PLAN.md"
    echo "   📊 Analysis Data: $analysis_file"
}

detect_project_type() {
    local project_path="$1"
    
    if [[ -f "$project_path/package.json" ]]; then
        # Analyze package.json for framework
        if grep -q "react" "$project_path/package.json" 2>/dev/null; then
            echo "react"
        elif grep -q "vue" "$project_path/package.json" 2>/dev/null; then
            echo "vue"
        elif grep -q "express" "$project_path/package.json" 2>/dev/null; then
            echo "nodejs-backend"
        elif grep -q "next" "$project_path/package.json" 2>/dev/null; then
            echo "nextjs"
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
    elif [[ -f "$project_path/pom.xml" ]]; then
        echo "java-maven"
    elif [[ -f "$project_path/build.gradle" ]]; then
        echo "java-gradle"
    else
        echo "unknown"
    fi
}

analyze_codebase_health() {
    local project_path="$1"
    
    echo "🏥 CODEBASE HEALTH ANALYSIS"
    echo "=========================="
    
    # File count and size analysis
    local total_files=$(find "$project_path" -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.go" -o -name "*.java" -o -name "*.rb" -o -name "*.rs" \) 2>/dev/null | wc -l)
    local lines_of_code=$(find "$project_path" \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.go" -o -name "*.java" -o -name "*.rb" -o -name "*.rs" \) -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
    
    echo "📊 Source Files: $total_files"
    echo "📊 Lines of Code: $lines_of_code"
    
    # Code complexity and project size classification
    local complexity_score="Medium"
    if [[ $lines_of_code -lt 1000 ]]; then
        complexity_score="Low"
        PROJECT_SIZE="small"
    elif [[ $lines_of_code -lt 10000 ]]; then
        complexity_score="Medium"
        PROJECT_SIZE="medium" 
    elif [[ $lines_of_code -lt 50000 ]]; then
        complexity_score="High"
        PROJECT_SIZE="large"
    else
        complexity_score="Very High"
        PROJECT_SIZE="enterprise"
    fi
    
    echo "🎯 Complexity: $complexity_score"
    echo "📏 Project Size: $PROJECT_SIZE"
    
    # TODO/FIXME analysis
    local todo_count=$(find "$project_path" \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.go" -o -name "*.java" -o -name "*.rb" -o -name "*.rs" \) -exec grep -i "TODO\|FIXME\|XXX\|HACK\|BUG" {} \; 2>/dev/null | wc -l)
    echo "⚠️  TODO/FIXME Count: $todo_count"
    
    # Configuration files
    local config_files=0
    [[ -f "$project_path/.env" ]] && ((config_files++))
    [[ -f "$project_path/.env.example" ]] && ((config_files++))
    [[ -f "$project_path/config.json" ]] && ((config_files++))
    [[ -f "$project_path/docker-compose.yml" ]] && ((config_files++))
    [[ -f "$project_path/Dockerfile" ]] && ((config_files++))
    echo "⚙️  Configuration Files: $config_files"
    
    # Code quality indicators
    local linter_configs=0
    [[ -f "$project_path/.eslintrc" ]] || [[ -f "$project_path/.eslintrc.js" ]] || [[ -f "$project_path/.eslintrc.json" ]] && ((linter_configs++))
    [[ -f "$project_path/.pylintrc" ]] || [[ -f "$project_path/pyproject.toml" ]] && ((linter_configs++))
    [[ -f "$project_path/.prettierrc" ]] && ((linter_configs++))
    echo "✨ Linter Configs: $linter_configs"
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
        local current_branch=$(git branch --show-current 2>/dev/null || echo "detached")
        local branch_count=$(git branch -a 2>/dev/null | wc -l)
        echo "🌳 Current Branch: $current_branch"
        echo "🌳 Total Branches: $branch_count"
        
        # Commit history
        local last_commit=$(git log -1 --format="%cr" 2>/dev/null || echo "Unknown")
        local commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
        local contributors=$(git log --format='%an' | sort | uniq | wc -l 2>/dev/null || echo "0")
        echo "⏰ Last Commit: $last_commit"
        echo "📝 Total Commits: $commit_count"
        echo "👥 Contributors: $contributors"
        
        # Uncommitted changes
        local uncommitted=$(git status --porcelain 2>/dev/null | wc -l)
        local untracked=$(git status --porcelain 2>/dev/null | grep "^??" | wc -l)
        echo "⚠️  Uncommitted Files: $uncommitted"
        echo "❓ Untracked Files: $untracked"
        
        # Remote status
        local remotes=$(git remote 2>/dev/null | wc -l)
        if [[ $remotes -gt 0 ]]; then
            echo "🌐 Remote Repositories: $remotes"
            local unpushed=$(git log --oneline origin/$(git branch --show-current)..HEAD 2>/dev/null | wc -l || echo "0")
            echo "📤 Unpushed Commits: $unpushed"
        else
            echo "🌐 Remote Repositories: 0 (local only)"
        fi
        
        # Stashes
        local stashes=$(git stash list 2>/dev/null | wc -l)
        echo "📦 Stashes: $stashes"
        
        # Git hooks
        local hooks=$(find .git/hooks -type f -executable 2>/dev/null | wc -l)
        echo "🪝 Active Git Hooks: $hooks"
        
    else
        echo "❌ No git repository found - recommend initializing git"
    fi
}

analyze_dependencies() {
    local project_path="$1"
    
    echo "📦 DEPENDENCIES & SECURITY ANALYSIS"
    echo "=================================="
    
    cd "$project_path" || return 1
    
    if [[ -f "package.json" ]]; then
        echo "📋 Node.js Dependencies:"
        if command -v jq >/dev/null 2>&1; then
            local total_deps=$(cat package.json | jq '.dependencies | length' 2>/dev/null || echo "0")
            local dev_deps=$(cat package.json | jq '.devDependencies | length' 2>/dev/null || echo "0")
            echo "   Production: $total_deps"
            echo "   Development: $dev_deps"
        else
            local total_deps=$(grep -c '"' package.json 2>/dev/null || echo "unknown")
            echo "   Dependencies: $total_deps (jq not available for exact count)"
        fi
        
        # Package manager detection
        if [[ -f "yarn.lock" ]]; then
            echo "   Package Manager: Yarn"
        elif [[ -f "pnpm-lock.yaml" ]]; then
            echo "   Package Manager: pnpm"
        elif [[ -f "package-lock.json" ]]; then
            echo "   Package Manager: npm"
        else
            echo "   Package Manager: Unknown (no lockfile)"
        fi
        
        # Security audit (if npm available)
        if command -v npm >/dev/null 2>&1; then
            echo "🔒 Running security audit..."
            local audit_output=$(npm audit --json 2>/dev/null || echo '{"metadata":{"vulnerabilities":{"total":"unknown"}}}')
            if command -v jq >/dev/null 2>&1; then
                local vulnerabilities=$(echo "$audit_output" | jq '.metadata.vulnerabilities.total' 2>/dev/null || echo "unknown")
                echo "   Vulnerabilities: $vulnerabilities"
            else
                echo "   Vulnerabilities: Check manually with 'npm audit'"
            fi
        fi
        
    elif [[ -f "requirements.txt" ]]; then
        echo "📋 Python Dependencies:"
        local total_deps=$(grep -v "^#" requirements.txt 2>/dev/null | grep -v "^$" | wc -l)
        echo "   Total: $total_deps"
        
        # Virtual environment detection
        if [[ -d "venv" ]] || [[ -d ".venv" ]] || [[ -d "env" ]]; then
            echo "   Virtual Environment: Detected"
        else
            echo "   Virtual Environment: Not found"
        fi
        
        # Check for pip-tools
        if [[ -f "requirements.in" ]]; then
            echo "   Using pip-tools: Yes"
        fi
        
    elif [[ -f "Gemfile" ]]; then
        echo "📋 Ruby Dependencies:"
        local total_deps=$(grep "^gem" Gemfile 2>/dev/null | wc -l)
        echo "   Total Gems: $total_deps"
        
        if [[ -f "Gemfile.lock" ]]; then
            echo "   Lockfile: Present"
        fi
        
    elif [[ -f "go.mod" ]]; then
        echo "📋 Go Dependencies:"
        local total_deps=$(grep "require" go.mod 2>/dev/null | wc -l)
        echo "   Total Modules: $total_deps"
        
    elif [[ -f "Cargo.toml" ]]; then
        echo "📋 Rust Dependencies:"
        local total_deps=$(grep -A 100 "\[dependencies\]" Cargo.toml 2>/dev/null | grep "=" | wc -l)
        echo "   Total Crates: $total_deps"
    fi
}

analyze_test_coverage() {
    local project_path="$1"
    
    echo "🧪 TEST COVERAGE ANALYSIS"
    echo "========================"
    
    cd "$project_path" || return 1
    
    # Find test files with various naming patterns
    local test_files=$(find . \( -name "*test*" -o -name "*spec*" -o -name "__tests__" \) -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.go" -o -name "*.java" -o -name "*.rb" -o -name "*.rs" \) 2>/dev/null | wc -l)
    echo "📝 Test Files: $test_files"
    
    # Test directories
    local test_dirs=$(find . -type d \( -name "*test*" -o -name "*spec*" -o -name "__tests__" \) 2>/dev/null | wc -l)
    echo "📁 Test Directories: $test_dirs"
    
    # Testing framework detection
    local test_frameworks=()
    if [[ -f "package.json" ]]; then
        grep -q "jest" package.json 2>/dev/null && test_frameworks+=("Jest")
        grep -q "mocha" package.json 2>/dev/null && test_frameworks+=("Mocha")
        grep -q "cypress" package.json 2>/dev/null && test_frameworks+=("Cypress")
        grep -q "playwright" package.json 2>/dev/null && test_frameworks+=("Playwright")
        grep -q "vitest" package.json 2>/dev/null && test_frameworks+=("Vitest")
    fi
    
    if [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]]; then
        grep -q "pytest" requirements.txt pyproject.toml 2>/dev/null && test_frameworks+=("pytest")
        grep -q "unittest" requirements.txt pyproject.toml 2>/dev/null && test_frameworks+=("unittest")
    fi
    
    if [[ ${#test_frameworks[@]} -gt 0 ]]; then
        echo "🔧 Test Frameworks: ${test_frameworks[*]}"
    else
        echo "🔧 Test Frameworks: None detected"
    fi
    
    # Estimate coverage (simplified heuristic)
    local source_files=$(find . \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.go" -o -name "*.java" -o -name "*.rb" -o -name "*.rs" \) ! -path "./node_modules/*" ! -path "./.git/*" ! -path "./venv/*" ! -path "./.venv/*" ! -name "*test*" ! -name "*spec*" 2>/dev/null | wc -l)
    
    if [[ $source_files -gt 0 && $test_files -gt 0 ]]; then
        local coverage_ratio=$((test_files * 100 / source_files))
        # Cap at 100% for the heuristic
        [[ $coverage_ratio -gt 100 ]] && coverage_ratio=100
        echo "📊 Estimated Coverage Ratio: ${coverage_ratio}%"
    else
        echo "📊 Estimated Coverage Ratio: 0%"
    fi
    
    # Coverage config files
    local coverage_configs=0
    [[ -f ".coveragerc" ]] && ((coverage_configs++))
    [[ -f "jest.config.js" ]] && ((coverage_configs++))
    [[ -f "coverage.py" ]] && ((coverage_configs++))
    echo "⚙️  Coverage Configs: $coverage_configs"
}

analyze_documentation() {
    local project_path="$1"
    
    echo "📚 DOCUMENTATION ANALYSIS"
    echo "========================"
    
    # Essential documentation files
    local readme_exists="No"
    [[ -f "$project_path/README.md" ]] && readme_exists="Yes"
    echo "📄 README.md: $readme_exists"
    
    local changelog_exists="No"
    [[ -f "$project_path/CHANGELOG.md" ]] && changelog_exists="Yes"
    echo "📄 CHANGELOG.md: $changelog_exists"
    
    local api_docs_exists="No"
    [[ -f "$project_path/API.md" ]] || [[ -d "$project_path/docs" ]] || [[ -d "$project_path/documentation" ]] && api_docs_exists="Yes"
    echo "📄 API Documentation: $api_docs_exists"
    
    local contributing_exists="No"
    [[ -f "$project_path/CONTRIBUTING.md" ]] && contributing_exists="Yes"
    echo "📄 Contributing Guide: $contributing_exists"
    
    local license_exists="No"
    [[ -f "$project_path/LICENSE" ]] || [[ -f "$project_path/LICENSE.md" ]] && license_exists="Yes"
    echo "📄 License: $license_exists"
    
    # Code documentation (docstrings/comments)
    local documented_functions=0
    if [[ "$PROJECT_TYPE" == "python"* ]] || [[ "$PROJECT_TYPE" == "django" ]] || [[ "$PROJECT_TYPE" == "flask" ]] || [[ "$PROJECT_TYPE" == "fastapi" ]]; then
        documented_functions=$(find "$project_path" -name "*.py" -exec grep -l '"""' {} \; 2>/dev/null | wc -l)
    elif [[ "$PROJECT_TYPE" == *"node"* ]] || [[ "$PROJECT_TYPE" == "react" ]] || [[ "$PROJECT_TYPE" == "vue" ]] || [[ "$PROJECT_TYPE" == "nextjs" ]]; then
        documented_functions=$(find "$project_path" \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) -exec grep -l '/\*\*' {} \; 2>/dev/null | wc -l)
    elif [[ "$PROJECT_TYPE" == "golang" ]]; then
        documented_functions=$(find "$project_path" -name "*.go" -exec grep -l '//' {} \; 2>/dev/null | wc -l)
    fi
    echo "📝 Files with Documentation: $documented_functions"
    
    # Documentation score (0-10)
    local doc_score=0
    [[ "$readme_exists" == "Yes" ]] && ((doc_score += 3))
    [[ "$api_docs_exists" == "Yes" ]] && ((doc_score += 2))
    [[ "$contributing_exists" == "Yes" ]] && ((doc_score += 2))
    [[ "$license_exists" == "Yes" ]] && ((doc_score += 1))
    [[ "$changelog_exists" == "Yes" ]] && ((doc_score += 1))
    [[ $documented_functions -gt 0 ]] && ((doc_score += 1))
    
    echo "📊 Documentation Score: $doc_score/10"
}

generate_recommendations() {
    local project_path="$1"
    
    echo "💡 IMPROVEMENT RECOMMENDATIONS"
    echo "============================="
    
    local recommendations=()
    local priority_recommendations=()
    
    # Git recommendations
    if [[ ! -d "$project_path/.git" ]]; then
        priority_recommendations+=("🔧 CRITICAL: Initialize git repository for version control")
    fi
    
    # Get uncommitted count from git analysis
    cd "$project_path" || return 1
    local uncommitted=0
    if [[ -d ".git" ]]; then
        uncommitted=$(git status --porcelain 2>/dev/null | wc -l)
    fi
    
    if [[ $uncommitted -gt 0 ]]; then
        priority_recommendations+=("🔧 HIGH: Commit $uncommitted uncommitted files")
    fi
    
    # Testing recommendations
    local test_files=$(find . \( -name "*test*" -o -name "*spec*" \) -name "*.py" -o -name "*.js" -o -name "*.ts" 2>/dev/null | wc -l)
    local source_files=$(find . \( -name "*.py" -o -name "*.js" -o -name "*.ts" \) ! -name "*test*" ! -name "*spec*" ! -path "./node_modules/*" ! -path "./.git/*" ! -path "./venv/*" 2>/dev/null | wc -l)
    
    if [[ $test_files -eq 0 ]]; then
        priority_recommendations+=("🧪 HIGH: Add test suite - no tests detected")
    elif [[ $source_files -gt 0 ]]; then
        local coverage_ratio=$((test_files * 100 / source_files))
        if [[ $coverage_ratio -lt 50 ]]; then
            recommendations+=("🧪 Improve test coverage (estimated: ${coverage_ratio}%, target: 80%)")
        fi
    fi
    
    # Documentation recommendations
    if [[ ! -f "$project_path/README.md" ]]; then
        priority_recommendations+=("📚 HIGH: Create README.md with project overview")
    fi
    
    if [[ ! -d "$project_path/docs" ]] && [[ ! -f "$project_path/API.md" ]]; then
        recommendations+=("📚 Add API documentation")
    fi
    
    # Security recommendations based on project type
    if [[ -f "$project_path/package.json" ]] && ! command -v npm >/dev/null; then
        recommendations+=("🔒 Install npm to run security audits")
    fi
    
    # Code quality recommendations
    local todo_count=$(find "$project_path" \( -name "*.py" -o -name "*.js" -o -name "*.ts" \) -exec grep -i "TODO\|FIXME\|XXX\|HACK" {} \; 2>/dev/null | wc -l)
    if [[ $todo_count -gt 20 ]]; then
        recommendations+=("🧹 Address $todo_count TODO/FIXME items")
    fi
    
    # Performance recommendations
    if [[ "$PROJECT_SIZE" == "large" ]] || [[ "$PROJECT_SIZE" == "enterprise" ]]; then
        recommendations+=("⚡ Consider code splitting and performance optimization")
        recommendations+=("📦 Consider microservices architecture for better scalability")
    fi
    
    # Development workflow recommendations
    if [[ ! -f "$project_path/.github/workflows" ]] && [[ ! -f "$project_path/.gitlab-ci.yml" ]]; then
        recommendations+=("🔄 Set up CI/CD pipeline")
    fi
    
    if [[ "$PROJECT_TYPE" == "nodejs" ]] || [[ "$PROJECT_TYPE" == "react" ]] || [[ "$PROJECT_TYPE" == "vue" ]]; then
        if [[ ! -f "$project_path/.eslintrc" ]] && [[ ! -f "$project_path/.eslintrc.js" ]] && [[ ! -f "$project_path/.eslintrc.json" ]]; then
            recommendations+=("✨ Set up ESLint for code quality")
        fi
        if [[ ! -f "$project_path/.prettierrc" ]]; then
            recommendations+=("💅 Set up Prettier for code formatting")
        fi
    fi
    
    # Output recommendations
    if [[ ${#priority_recommendations[@]} -gt 0 ]]; then
        echo "🚨 HIGH PRIORITY:"
        for rec in "${priority_recommendations[@]}"; do
            echo "  $rec"
        done
        echo ""
    fi
    
    if [[ ${#recommendations[@]} -gt 0 ]]; then
        echo "📝 MEDIUM PRIORITY:"
        for rec in "${recommendations[@]}"; do
            echo "  $rec"
        done
        echo ""
    fi
    
    if [[ ${#priority_recommendations[@]} -eq 0 && ${#recommendations[@]} -eq 0 ]]; then
        echo "  ✅ Project appears to be in excellent shape!"
    fi
}

create_action_plan() {
    local project_path="$1"
    local action_plan_file="$project_path/TMUX_ORCHESTRATOR_ACTION_PLAN.md"
    
    cat > "$action_plan_file" << EOF
# Tmux Orchestrator Action Plan

**Generated:** $(date)  
**Project:** $PROJECT_NAME  
**Type:** $PROJECT_TYPE  
**Size:** $PROJECT_SIZE  
**Path:** $project_path

## Project Overview

This action plan was automatically generated based on brownfield analysis of your existing project. Follow these steps to integrate with the Tmux Orchestrator system and improve project quality.

## Immediate Actions (High Priority)

- [ ] **Environment Setup**
  - [ ] Verify development environment is working
  - [ ] Install missing dependencies
  - [ ] Set up virtual environment (if applicable)
  - [ ] Test build process

- [ ] **Git Repository Health**
  - [ ] Review and commit any uncommitted changes
  - [ ] Push unpushed commits to remote
  - [ ] Clean up stashes if any
  - [ ] Verify branch strategy

- [ ] **Quality Assessment**
  - [ ] Run existing tests (if any)
  - [ ] Check for linting errors
  - [ ] Review security vulnerabilities
  - [ ] Assess code coverage

- [ ] **CI/CD Pipeline**
  - [ ] Check existing pipeline status
  - [ ] Fix any failing builds
  - [ ] Update deployment scripts if needed

## Quality Improvements (Medium Priority)

- [ ] **Testing Strategy**
  - [ ] Increase test coverage to minimum 80%
  - [ ] Set up automated testing in CI
  - [ ] Add integration tests for critical paths
  - [ ] Configure test coverage reporting

- [ ] **Code Quality**
  - [ ] Fix all linting errors and warnings
  - [ ] Address TODO/FIXME items
  - [ ] Refactor complex functions
  - [ ] Add type annotations (if applicable)

- [ ] **Documentation**
  - [ ] Update README.md with current information
  - [ ] Add API documentation
  - [ ] Create contributing guidelines
  - [ ] Document deployment process

- [ ] **Security & Dependencies**
  - [ ] Update outdated dependencies
  - [ ] Fix security vulnerabilities
  - [ ] Audit third-party packages
  - [ ] Set up dependency scanning

## Long-term Enhancements (Low Priority)

- [ ] **Performance Optimization**
  - [ ] Profile application performance
  - [ ] Optimize database queries
  - [ ] Implement caching where appropriate
  - [ ] Monitor and alert on performance metrics

- [ ] **Architecture Improvements**
  - [ ] Review and update system architecture
  - [ ] Consider microservices (for large projects)
  - [ ] Implement proper error handling
  - [ ] Add comprehensive logging

- [ ] **Developer Experience**
  - [ ] Set up development tools and linters
  - [ ] Create development environment setup scripts
  - [ ] Add debugging and profiling tools
  - [ ] Implement hot-reload for development

- [ ] **Monitoring & Observability**
  - [ ] Set up application monitoring
  - [ ] Implement health checks
  - [ ] Add metrics and analytics
  - [ ] Configure alerting for critical issues

## Team Composition Recommendation

Based on project size (**$PROJECT_SIZE**), recommended team composition:

EOF

    # Add team recommendations based on project size
    case "$PROJECT_SIZE" in
        "small")
            cat >> "$action_plan_file" << 'EOF'
### Small Project Team (2-3 members)
- **1x Developer** - Full-stack development, bug fixes, feature implementation
- **1x Project Manager** (part-time) - Quality assurance, progress tracking, orchestrator liaison

**Estimated Timeline:** 2-4 weeks for initial improvements
**Focus:** Code quality, testing, documentation
EOF
            ;;
        "medium")
            cat >> "$action_plan_file" << 'EOF'
### Medium Project Team (4-5 members)
- **1x Lead Developer** - Architecture decisions, code review, complex implementations
- **1x Developer** - Feature development, bug fixes, maintenance
- **1x QA Engineer** - Test automation, quality assurance, test strategy
- **1x Project Manager** - Team coordination, sprint planning, quality gates

**Estimated Timeline:** 4-8 weeks for comprehensive improvements
**Focus:** Testing strategy, CI/CD, performance optimization
EOF
            ;;
        "large")
            cat >> "$action_plan_file" << 'EOF'
### Large Project Team (6-8 members)
- **1x Tech Lead** - System architecture, technical decisions, cross-team coordination
- **2x Senior Developers** - Complex implementations, performance optimization, mentoring
- **1x Developer** - Feature development, bug fixes, documentation
- **1x QA Engineer** - Test strategy, automation, quality metrics
- **1x DevOps Engineer** - CI/CD pipeline, infrastructure, monitoring
- **1x Project Manager** - Program management, resource allocation, stakeholder communication

**Estimated Timeline:** 8-16 weeks for complete modernization
**Focus:** Architecture review, performance, scalability, monitoring
EOF
            ;;
        "enterprise")
            cat >> "$action_plan_file" << 'EOF'
### Enterprise Project Team (8-12 members)
- **1x System Architect** - High-level architecture, technology strategy
- **1x Tech Lead** - Implementation coordination, technical decisions
- **3x Senior Developers** - Complex features, performance optimization, system integration
- **2x Developers** - Feature development, maintenance, documentation
- **1x QA Lead** - Quality strategy, test architecture, team coordination
- **1x QA Engineer** - Test automation, regression testing
- **1x DevOps Engineer** - Infrastructure, deployment, monitoring
- **1x Security Engineer** - Security audit, compliance, vulnerability management
- **1x Project Manager** - Program coordination, timeline management, stakeholder communication

**Estimated Timeline:** 16-24 weeks for enterprise-grade improvements
**Focus:** Security, compliance, scalability, maintainability, monitoring
EOF
            ;;
    esac

    cat >> "$action_plan_file" << 'EOF'

## Success Metrics

### Code Quality Targets
- [ ] Test coverage ≥ 80%
- [ ] Zero critical security vulnerabilities
- [ ] All linting rules passing
- [ ] Documentation coverage ≥ 90%

### Team Performance Targets
- [ ] Sprint velocity consistency (±20%)
- [ ] Average task completion time < 3 days
- [ ] Code review turnaround < 4 hours
- [ ] Zero blocker incidents lasting > 2 hours

### System Health Targets
- [ ] Agent responsiveness ≥ 95%
- [ ] Commit frequency ≤ 2 hours
- [ ] Build success rate ≥ 98%
- [ ] Deployment frequency ≥ 1/week

## Getting Started

1. **Review this action plan** with your team
2. **Prioritize items** based on business needs
3. **Set up Tmux Orchestrator** session for this project
4. **Deploy recommended team** using the orchestrator
5. **Begin with immediate actions** while team gets familiar with the codebase

## Notes

- This plan is generated based on automated analysis and should be reviewed by a human
- Adjust timelines and priorities based on business requirements
- Consider breaking large projects into smaller, manageable phases
- Regular reviews and updates to this plan are recommended

---

**Generated by Tmux Orchestrator Brownfield Analysis**  
**For questions or updates, consult the project orchestrator**
EOF

    echo "📋 Action plan created: $action_plan_file"
}

generate_analysis_json() {
    local project_path="$1"
    local analysis_file="$2"
    
    # Get metrics for JSON
    cd "$project_path" || return 1
    
    local total_files=$(find "$project_path" -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.go" -o -name "*.java" -o -name "*.rb" -o -name "*.rs" \) 2>/dev/null | wc -l)
    local lines_of_code=$(find "$project_path" \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.go" -o -name "*.java" -o -name "*.rb" -o -name "*.rs" \) -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
    local test_files=$(find . \( -name "*test*" -o -name "*spec*" \) -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" \) 2>/dev/null | wc -l)
    local todo_count=$(find "$project_path" \( -name "*.py" -o -name "*.js" -o -name "*.ts" \) -exec grep -i "TODO\|FIXME\|XXX\|HACK" {} \; 2>/dev/null | wc -l)
    
    local git_status="unknown"
    local commit_count="0"
    local uncommitted="0"
    local contributors="0"
    
    if [[ -d ".git" ]]; then
        git_status="healthy"
        commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
        uncommitted=$(git status --porcelain 2>/dev/null | wc -l)
        contributors=$(git log --format='%an' | sort | uniq | wc -l 2>/dev/null || echo "0")
    fi
    
    # Generate JSON analysis file
    cat > "$analysis_file" << EOF
{
  "analysis": {
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "version": "1.0",
    "project": {
      "name": "$PROJECT_NAME",
      "path": "$project_path",
      "type": "$PROJECT_TYPE",
      "size": "$PROJECT_SIZE"
    },
    "codebase": {
      "total_files": $total_files,
      "lines_of_code": $lines_of_code,
      "test_files": $test_files,
      "todo_count": $todo_count,
      "estimated_coverage": $(( test_files > 0 && total_files > 0 ? test_files * 100 / total_files : 0 ))
    },
    "git": {
      "status": "$git_status",
      "commit_count": $commit_count,
      "uncommitted_files": $uncommitted,
      "contributors": $contributors
    },
    "documentation": {
      "readme_exists": $([ -f "$project_path/README.md" ] && echo "true" || echo "false"),
      "api_docs_exist": $([ -f "$project_path/API.md" ] || [ -d "$project_path/docs" ] && echo "true" || echo "false"),
      "contributing_guide_exists": $([ -f "$project_path/CONTRIBUTING.md" ] && echo "true" || echo "false")
    },
    "recommendations": {
      "priority_count": 0,
      "medium_count": 0,
      "estimated_improvement_weeks": $(case "$PROJECT_SIZE" in
        "small") echo "3" ;;
        "medium") echo "6" ;;
        "large") echo "12" ;;
        "enterprise") echo "20" ;;
        *) echo "4" ;;
      esac)
    }
  }
}
EOF

    echo "📊 Analysis data saved: $analysis_file"
}

# Main execution
main() {
    echo "🚀 TMUX ORCHESTRATOR BROWNFIELD ANALYSIS"
    echo "========================================"
    echo ""
    
    analyze_project "$PROJECT_PATH"
    
    echo ""
    echo "🎯 NEXT STEPS:"
    echo "1. Review the generated action plan"
    echo "2. Set up Tmux Orchestrator session for this project"
    echo "3. Deploy appropriate team based on project size ($PROJECT_SIZE)"
    echo "4. Begin with high-priority improvements"
    echo ""
    echo "📚 Use: ./start-project-enhanced.sh \"$PROJECT_PATH\" to begin orchestration"
}

# Run main function
main