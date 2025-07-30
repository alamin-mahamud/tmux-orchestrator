# 📚 Tmux Orchestrator Examples & Workflows

This document provides comprehensive examples, specs, prompts, and workflows for the Tmux Orchestrator system.

## 🚀 Quick Start Examples

### Example 1: New React Project
```bash
# Analyze existing React project
./analyze-brownfield-project.sh ~/projects/my-react-app

# Start orchestrator session
./start-project-enhanced.sh my-react-app

# Attach to session
tmux attach -t my-react-app
```

### Example 2: Brownfield Python/Django Project
```bash
# Force fresh analysis of Django project
./analyze-brownfield-project.sh /path/to/django-project

# Review generated action plan
cat /path/to/django-project/TMUX_ORCHESTRATOR_ACTION_PLAN.md

# Start with enhanced team
./start-project-enhanced.sh /path/to/django-project
```

### Example 3: Large Enterprise Project
```bash
# Analyze enterprise-scale project
./analyze-brownfield-project.sh ~/work/enterprise-api

# Review analysis results
jq '.' ~/work/enterprise-api/.tmux-orchestrator-analysis.json

# Deploy full team
./start-project-enhanced.sh enterprise-api
```

## 🎭 Agent Role Specifications

### Project Manager Agent Spec

**Primary Responsibilities:**
- Quality-focused team coordination
- Enforce coding standards and quality gates
- Track sprint velocity and technical debt
- Coordinate async standups and status reports

**Initialization Prompt:**
```
You are the Project Manager for this development project. Your role is critical for maintaining quality and coordination.

IMMEDIATE TASKS:
1. Review project action plan: ./TMUX_ORCHESTRATOR_ACTION_PLAN.md
2. Analyze current git status and recent commits
3. Assess code quality and test coverage
4. Create initial team standup

QUALITY GATES (NEVER COMPROMISE):
- Minimum 80% test coverage for all merges
- All linting and type checking must pass
- Security vulnerabilities must be addressed
- Documentation must be updated with code changes
- Conventional commit messages required

COMMUNICATION PROTOCOL:
- Send status updates to orchestrator every 2 hours
- Collect team status every 4 hours via hub-and-spoke pattern
- Escalate any blockers immediately
- Document all decisions and changes

DAILY WORKFLOW:
1. Morning: Review overnight commits and CI status
2. Standup: Collect status from all team members
3. Review: Check all PRs within 30 minutes
4. Planning: Adjust priorities based on blockers
5. Evening: Summarize progress and plan next day

Begin by analyzing the current project state and introducing yourself to the team.
```

### Lead Developer Agent Spec

**Initialization Prompt:**
```
You are the Lead Developer for this project. You balance technical leadership with hands-on development.

TECHNICAL RESPONSIBILITIES:
1. Make architectural decisions for the project
2. Review complex code changes and technical designs
3. Mentor other developers and establish best practices
4. Handle the most challenging technical implementations

IMMEDIATE TASKS:
1. Review current architecture and identify improvement opportunities
2. Analyze technical debt and create refactoring roadmap
3. Establish development standards and tooling
4. Set up code review process and guidelines

LEADERSHIP DUTIES:
- Guide technical discussions and resolve conflicts
- Establish coding standards and best practices
- Review all significant technical changes
- Coordinate with PM on technical timelines
- Mentor junior developers through code review

TECHNICAL FOCUS AREAS:
- System architecture and design patterns
- Performance optimization and scaling
- Code quality and maintainability
- Technology selection and upgrades
- Complex algorithm implementation

Start by conducting a comprehensive technical assessment of the current system.
```

### QA Engineer Agent Spec

**Initialization Prompt:**
```
You are the QA Engineer responsible for ensuring comprehensive testing and quality assurance.

TESTING RESPONSIBILITIES:
1. Develop and implement comprehensive test strategy
2. Ensure minimum 80% test coverage across all components
3. Set up test automation framework and CI integration
4. Perform regression testing for all changes

IMMEDIATE TASKS:
1. Assess current testing situation and coverage
2. Set up appropriate testing tools and frameworks
3. Create test plans for existing features
4. Implement missing critical test coverage

QUALITY ASSURANCE DUTIES:
- Unit testing strategy and implementation
- Integration testing across system components
- End-to-end testing for critical user workflows
- Performance testing and benchmarking
- Basic security testing and vulnerability assessment

TESTING TYPES TO IMPLEMENT:
- Unit Tests: Individual component testing
- Integration Tests: Component interaction testing
- E2E Tests: Full user workflow testing
- Performance Tests: Load and stress testing
- Security Tests: Basic vulnerability scanning

TOOLS & FRAMEWORKS (select based on project):
- JavaScript: Jest, Cypress, Playwright, Vitest
- Python: pytest, unittest, Selenium
- General: Docker for test environments

Never allow features to be merged without adequate test coverage. Begin by assessing current test status.
```

### DevOps Engineer Agent Spec

**Initialization Prompt:**
```
You are the DevOps Engineer responsible for infrastructure, deployment, and operational excellence.

INFRASTRUCTURE RESPONSIBILITIES:
1. Set up and maintain CI/CD pipelines
2. Manage development and production environments
3. Implement monitoring, logging, and alerting
4. Handle deployments, rollbacks, and releases

IMMEDIATE TASKS:
1. Assess current CI/CD setup and deployment process
2. Review infrastructure security and access controls
3. Set up comprehensive monitoring and alerting
4. Document deployment procedures and runbooks

OPERATIONAL DUTIES:
- Automated build, test, and deployment pipelines
- Environment configuration and management
- System monitoring and observability
- Backup and disaster recovery procedures
- Performance monitoring and optimization

SECURITY FOCUS:
- Vulnerability scanning in CI/CD pipeline
- Secret management and secure configuration
- Access control and permissions management
- Security monitoring and incident response

TOOLS & TECHNOLOGIES:
- Containerization: Docker, Kubernetes
- CI/CD: GitHub Actions, GitLab CI, Jenkins
- Cloud: AWS, GCP, Azure services
- Monitoring: Prometheus, Grafana, DataDog
- Infrastructure as Code: Terraform, CloudFormation

Start by assessing the current infrastructure and creating an improvement plan.
```

## 💬 Communication Templates

### Status Update Template
```
[STATUS_UPDATE] Agent Role - YYYY-MM-DD HH:MM

COMPLETED SINCE LAST UPDATE:
- Task 1: Brief description and outcome
- Task 2: Brief description and outcome
- Task 3: Brief description and outcome

CURRENTLY WORKING ON:
- Primary task: Description and expected completion time
- Secondary task: Description if applicable

BLOCKERS & ISSUES:
- Blocker 1: Description and assistance needed
- Issue 1: Description and proposed solution

NEXT PRIORITIES:
- Priority 1: Description and timeline
- Priority 2: Description and timeline

METRICS:
- Tests passing: XX/XX
- Coverage: XX%
- Commits today: XX
- PRs reviewed: XX

NOTES:
Any additional context, concerns, or observations.
```

### Task Assignment Template
```
[TASK_ASSIGNMENT] Task Title - Priority Level

ASSIGNEE: @agent-role
FROM: @assigning-agent
DUE DATE: YYYY-MM-DD

DESCRIPTION:
Clear, detailed description of what needs to be accomplished.

ACCEPTANCE CRITERIA:
- [ ] Specific measurable outcome 1
- [ ] Specific measurable outcome 2
- [ ] Specific measurable outcome 3

CONTEXT:
Background information, related issues, or dependencies.

RESOURCES:
- Documentation: Link or path
- Related code: File paths or PR references
- Dependencies: Other tasks or external requirements

DEFINITION OF DONE:
- [ ] Code implemented and tested
- [ ] Tests written and passing (80%+ coverage)
- [ ] Code reviewed and approved
- [ ] Documentation updated
- [ ] No linting errors
- [ ] Security scan passed

Please acknowledge receipt and provide estimated completion time.
```

### Blocker Alert Template
```
[BLOCKER_ALERT] Brief Description - SEVERITY LEVEL

BLOCKING: @affected-agents
REPORTED BY: @reporting-agent
SEVERITY: HIGH/CRITICAL
STARTED: YYYY-MM-DD HH:MM

PROBLEM DESCRIPTION:
Clear description of what is blocking progress.

IMPACT:
- Who is affected
- What work is stopped
- Estimated time impact

ATTEMPTED SOLUTIONS:
1. Solution attempt 1 - Result
2. Solution attempt 2 - Result
3. Solution attempt 3 - Result

ASSISTANCE NEEDED:
Specific type of help required to resolve the blocker.

WORKAROUNDS:
Temporary solutions being used, if any.

ESCALATION:
If not resolved in X hours, escalate to orchestrator.
```

## 🔄 Workflow Examples

### Daily Standup Workflow

**PM Initiated Standup (Every 4 hours):**

1. **PM sends status request to all team members:**
```bash
# Example command
for agent in Claude-Dev Claude-QA Claude-DevOps; do
    send_message "session:$agent" "[STATUS_REQUEST] Please provide current status update using the standard template"
done
```

2. **Each agent responds with status update**
3. **PM compiles team summary for orchestrator:**

```
[DAILY_SUMMARY] Team Status - 2024-XX-XX

TEAM VELOCITY:
- Sprint progress: XX% complete
- Stories completed: X/XX
- Blockers active: X
- Overall health: GREEN/YELLOW/RED

INDIVIDUAL STATUS:
Lead Developer:
- Working on: Architecture refactoring
- Completed: Database optimization
- Blockers: None
- Next: API endpoint updates

QA Engineer:
- Working on: Test automation setup
- Completed: Unit test coverage analysis
- Blockers: Waiting for test data
- Next: Integration test implementation

DevOps Engineer:
- Working on: CI/CD pipeline optimization
- Completed: Monitoring dashboard setup
- Blockers: None
- Next: Production deployment preparation

RISKS & CONCERNS:
- Issue 1: Description and mitigation
- Issue 2: Description and mitigation

NEXT 4 HOURS PRIORITIES:
1. High priority task
2. Medium priority task
3. Low priority task
```

### Code Review Workflow

**Developer Request:**
```
[CODE_REVIEW_REQUEST] Feature Name - Branch: feature/branch-name

REVIEWER: @lead-developer @project-manager
FILES CHANGED: XX files, +XXX -XXX lines
PR LINK: [if available]

CHANGES SUMMARY:
- Change 1: Description
- Change 2: Description
- Change 3: Description

TESTING:
- [ ] Unit tests added/updated
- [ ] Integration tests passing
- [ ] Manual testing completed
- [ ] Performance impact assessed

REVIEW CHECKLIST:
- [ ] Code follows project standards
- [ ] No security vulnerabilities
- [ ] Documentation updated
- [ ] Backward compatibility maintained
- [ ] Performance acceptable

DEPLOYMENT NOTES:
Any special considerations for deployment.

Ready for review - please prioritize if blocking other work.
```

**Reviewer Response:**
```
[CODE_REVIEW_RESPONSE] Feature Name - APPROVED/CHANGES_REQUESTED

REVIEWER: @lead-developer
REVIEW STATUS: APPROVED

SUMMARY:
Overall assessment of the code changes.

FEEDBACK:
+ Positive feedback 1
+ Positive feedback 2
- Improvement suggestion 1
- Improvement suggestion 2

REQUIRED CHANGES: (if CHANGES_REQUESTED)
1. Critical change required
2. Important improvement needed

OPTIONAL SUGGESTIONS:
1. Consider refactoring X for better maintainability
2. Future enhancement opportunity

APPROVED FOR MERGE: YES/NO
NEXT STEPS: Description of what should happen next
```

### Deployment Workflow

**Pre-Deployment Checklist (DevOps Engineer):**
```
[DEPLOYMENT_PREPARATION] Release Version X.X.X

TARGET ENVIRONMENT: Staging/Production
DEPLOYMENT DATE: YYYY-MM-DD HH:MM
DEPLOYMENT LEAD: @devops-engineer

PRE-DEPLOYMENT CHECKLIST:
- [ ] All tests passing in CI
- [ ] Code reviewed and approved
- [ ] Database migrations tested
- [ ] Environment variables updated
- [ ] Third-party service dependencies verified
- [ ] Rollback plan prepared
- [ ] Monitoring alerts configured
- [ ] Team notification sent

RELEASE NOTES:
- Feature 1: Description
- Bug fix 1: Description
- Breaking change 1: Description (if any)

ROLLBACK PROCEDURE:
1. Step-by-step rollback instructions
2. Database rollback procedures
3. Configuration reversion steps

MONITORING PLAN:
- Key metrics to watch: X, Y, Z
- Alert thresholds: Values
- Success criteria: Definitions

Ready to proceed: YES/NO
```

### Incident Response Workflow

**Incident Alert:**
```
[PRODUCTION_INCIDENT] Brief Description - SEVERITY

SEVERITY: P1/P2/P3/P4
STARTED: YYYY-MM-DD HH:MM
INCIDENT COMMANDER: @devops-engineer
STATUS: INVESTIGATING/MITIGATING/RESOLVED

IMPACT:
- Users affected: Number or percentage
- Services affected: List of services
- Business impact: Revenue/functionality impact

SYMPTOMS:
- Error rates: X% increase
- Response times: X ms average
- Availability: X% uptime

TIMELINE:
HH:MM - Incident detected
HH:MM - Team notified
HH:MM - Investigation started
HH:MM - Root cause identified
HH:MM - Fix deployed
HH:MM - Incident resolved

ACTIONS TAKEN:
1. Immediate response action
2. Investigation step
3. Mitigation attempt
4. Final resolution

ROOT CAUSE:
Technical explanation of what caused the incident.

RESOLUTION:
Description of how the incident was resolved.

POST-INCIDENT ACTIONS:
- [ ] Post-mortem scheduled
- [ ] Monitoring improvements
- [ ] Code fixes required
- [ ] Process improvements
```

## 📊 Quality Gate Examples

### Pre-Commit Quality Gate
```yaml
# .pre-commit-config.yaml example
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files

  - repo: https://github.com/psf/black
    rev: 22.10.0
    hooks:
      - id: black

  - repo: https://github.com/pycqa/flake8
    rev: 6.0.0
    hooks:
      - id: flake8

  - repo: https://github.com/pycqa/isort
    rev: 5.12.0
    hooks:
      - id: isort

# Quality gate script
#!/bin/bash
# pre-commit-quality-gate.sh

echo "🔍 Running pre-commit quality gate..."

# 1. Linting
echo "📝 Checking code style..."
if ! flake8 .; then
    echo "❌ Linting failed"
    exit 1
fi

# 2. Type checking
echo "🔍 Type checking..."
if ! mypy .; then
    echo "❌ Type checking failed"
    exit 1
fi

# 3. Tests
echo "🧪 Running tests..."
if ! pytest --cov=. --cov-report=term-missing --cov-fail-under=80; then
    echo "❌ Tests failed or coverage below 80%"
    exit 1
fi

# 4. Security scan
echo "🔒 Security scanning..."
if ! bandit -r .; then
    echo "❌ Security issues found"
    exit 1
fi

echo "✅ All quality gates passed!"
```

### CI/CD Pipeline Example

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: [3.8, 3.9, 3.10]

    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v3
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
        pip install -r requirements-dev.txt
    
    - name: Lint with flake8
      run: |
        flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
        flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
    
    - name: Type check with mypy
      run: mypy .
    
    - name: Test with pytest
      run: |
        pytest --cov=. --cov-report=xml --cov-fail-under=80
    
    - name: Security scan with bandit
      run: bandit -r .
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage.xml

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Deploy to staging
      run: |
        echo "Deploying to staging environment"
        # Deployment commands here
    
    - name: Run smoke tests
      run: |
        echo "Running smoke tests"
        # Smoke test commands here
    
    - name: Deploy to production
      if: success()
      run: |
        echo "Deploying to production"
        # Production deployment commands here
```

## 🎯 Performance Monitoring Examples

### Health Check Script
```bash
#!/bin/bash
# health-check.sh - Comprehensive system health monitoring

check_system_health() {
    echo "🏥 SYSTEM HEALTH CHECK - $(date)"
    echo "================================"
    
    # Git repository health
    echo "📚 Git Repository Status:"
    echo "  Uncommitted files: $(git status --porcelain | wc -l)"
    echo "  Current branch: $(git branch --show-current)"
    echo "  Last commit: $(git log -1 --format='%cr')"
    echo "  Unpushed commits: $(git log origin/$(git branch --show-current)..HEAD --oneline | wc -l)"
    
    # Test status
    echo "🧪 Test Status:"
    if command -v pytest >/dev/null; then
        coverage=$(pytest --cov=. --cov-report=term | grep "TOTAL" | awk '{print $4}')
        echo "  Test coverage: $coverage"
    elif command -v npm >/dev/null; then
        echo "  Running npm test coverage..."
        npm test -- --coverage --watchAll=false | grep "All files"
    fi
    
    # Code quality
    echo "✨ Code Quality:"
    if command -v flake8 >/dev/null; then
        linting_errors=$(flake8 . | wc -l)
        echo "  Linting errors: $linting_errors"
    fi
    
    # Security
    echo "🔒 Security Status:"
    if command -v npm >/dev/null && [[ -f package.json ]]; then
        vulnerabilities=$(npm audit --json | jq '.metadata.vulnerabilities.total' 2>/dev/null || echo "unknown")
        echo "  Vulnerabilities: $vulnerabilities"
    fi
    
    # Performance metrics
    echo "⚡ Performance:"
    if command -v docker >/dev/null; then
        echo "  Docker containers: $(docker ps | wc -l)"
    fi
    echo "  CPU usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)"
    echo "  Memory usage: $(free | grep Mem | awk '{printf "%.1f%%", $3/$2 * 100.0}')"
    
    echo ""
    echo "✅ Health check complete"
}

# Generate alert if critical issues found
generate_alerts() {
    local alerts=()
    
    # Check for critical issues
    uncommitted=$(git status --porcelain | wc -l)
    if [[ $uncommitted -gt 10 ]]; then
        alerts+=("HIGH: $uncommitted uncommitted files")
    fi
    
    # Check last commit age
    last_commit_age=$(git log -1 --format='%ct')
    current_time=$(date +%s)
    hours_since_commit=$(( (current_time - last_commit_age) / 3600 ))
    
    if [[ $hours_since_commit -gt 4 ]]; then
        alerts+=("MEDIUM: $hours_since_commit hours since last commit")
    fi
    
    # Output alerts
    if [[ ${#alerts[@]} -gt 0 ]]; then
        echo "🚨 ALERTS:"
        for alert in "${alerts[@]}"; do
            echo "  $alert"
        done
    fi
}

# Main execution
check_system_health
generate_alerts
```

### Agent Performance Metrics
```python
# agent_metrics.py - Track agent performance and productivity

import json
import time
from datetime import datetime, timedelta
from typing import Dict, List, Optional

class AgentMetrics:
    def __init__(self, agent_id: str):
        self.agent_id = agent_id
        self.metrics_file = f"./.tmux-orchestrator-metrics-{agent_id}.json"
        self.load_metrics()
    
    def load_metrics(self):
        """Load existing metrics or initialize new ones."""
        try:
            with open(self.metrics_file, 'r') as f:
                self.data = json.load(f)
        except FileNotFoundError:
            self.data = {
                "agent_id": self.agent_id,
                "start_time": datetime.utcnow().isoformat(),
                "tasks_completed": 0,
                "commits_made": 0,
                "code_reviews_completed": 0,
                "tests_written": 0,
                "bugs_fixed": 0,
                "features_implemented": 0,
                "documentation_updated": 0,
                "daily_metrics": []
            }
    
    def save_metrics(self):
        """Save metrics to file."""
        with open(self.metrics_file, 'w') as f:
            json.dump(self.data, f, indent=2)
    
    def log_task_completion(self, task_type: str, duration_minutes: int):
        """Log completion of a task."""
        self.data["tasks_completed"] += 1
        
        # Update specific counters
        if task_type == "commit":
            self.data["commits_made"] += 1
        elif task_type == "code_review":
            self.data["code_reviews_completed"] += 1
        elif task_type == "test":
            self.data["tests_written"] += 1
        elif task_type == "bug_fix":
            self.data["bugs_fixed"] += 1
        elif task_type == "feature":
            self.data["features_implemented"] += 1
        elif task_type == "documentation":
            self.data["documentation_updated"] += 1
        
        # Log daily metric
        today = datetime.utcnow().date().isoformat()
        daily_entry = {
            "date": today,
            "task_type": task_type,
            "duration_minutes": duration_minutes,
            "timestamp": datetime.utcnow().isoformat()
        }
        
        self.data["daily_metrics"].append(daily_entry)
        self.save_metrics()
    
    def get_daily_summary(self, date: str = None) -> Dict:
        """Get summary of metrics for a specific date."""
        if date is None:
            date = datetime.utcnow().date().isoformat()
        
        daily_tasks = [m for m in self.data["daily_metrics"] if m["date"] == date]
        
        summary = {
            "date": date,
            "total_tasks": len(daily_tasks),
            "total_time_minutes": sum(t["duration_minutes"] for t in daily_tasks),
            "task_breakdown": {},
            "productivity_score": 0
        }
        
        # Task breakdown
        for task in daily_tasks:
            task_type = task["task_type"]
            if task_type not in summary["task_breakdown"]:
                summary["task_breakdown"][task_type] = {"count": 0, "time": 0}
            summary["task_breakdown"][task_type]["count"] += 1
            summary["task_breakdown"][task_type]["time"] += task["duration_minutes"]
        
        # Calculate productivity score (tasks completed per hour)
        if summary["total_time_minutes"] > 0:
            summary["productivity_score"] = (summary["total_tasks"] / summary["total_time_minutes"]) * 60
        
        return summary
    
    def generate_performance_report(self) -> str:
        """Generate a performance report for the agent."""
        today = datetime.utcnow().date().isoformat()
        daily_summary = self.get_daily_summary(today)
        
        report = f"""
AGENT PERFORMANCE REPORT
========================
Agent: {self.agent_id}
Date: {today}
Report Generated: {datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')}

DAILY METRICS:
- Tasks Completed: {daily_summary['total_tasks']}
- Time Worked: {daily_summary['total_time_minutes']} minutes
- Productivity Score: {daily_summary['productivity_score']:.2f} tasks/hour

TASK BREAKDOWN:
"""
        
        for task_type, data in daily_summary['task_breakdown'].items():
            report += f"- {task_type.title()}: {data['count']} tasks ({data['time']} minutes)\n"
        
        report += f"""
CUMULATIVE METRICS:
- Total Tasks: {self.data['tasks_completed']}
- Commits Made: {self.data['commits_made']}
- Code Reviews: {self.data['code_reviews_completed']}
- Tests Written: {self.data['tests_written']}
- Bugs Fixed: {self.data['bugs_fixed']}
- Features Implemented: {self.data['features_implemented']}
- Documentation Updates: {self.data['documentation_updated']}

PERFORMANCE INDICATORS:
- Average tasks per day: {self.calculate_average_daily_tasks():.1f}
- Most productive task type: {self.get_most_productive_task_type()}
- Commit frequency: {self.calculate_commit_frequency():.1f} commits/day
"""
        
        return report
    
    def calculate_average_daily_tasks(self) -> float:
        """Calculate average tasks completed per day."""
        if not self.data["daily_metrics"]:
            return 0.0
        
        dates = set(m["date"] for m in self.data["daily_metrics"])
        return len(self.data["daily_metrics"]) / len(dates) if dates else 0.0
    
    def get_most_productive_task_type(self) -> str:
        """Get the task type the agent completes most frequently."""
        task_counts = {}
        for metric in self.data["daily_metrics"]:
            task_type = metric["task_type"]
            task_counts[task_type] = task_counts.get(task_type, 0) + 1
        
        return max(task_counts, key=task_counts.get) if task_counts else "None"
    
    def calculate_commit_frequency(self) -> float:
        """Calculate average commits per day."""
        if not self.data["daily_metrics"]:
            return 0.0
        
        dates = set(m["date"] for m in self.data["daily_metrics"])
        return self.data["commits_made"] / len(dates) if dates else 0.0

# Usage example:
# metrics = AgentMetrics("claude-dev-1")
# metrics.log_task_completion("feature", 120)  # 2 hours
# print(metrics.generate_performance_report())
```

This comprehensive examples document provides:

1. **Quick Start Examples** - Real-world scenarios for different project types
2. **Agent Role Specifications** - Detailed initialization prompts for each agent type
3. **Communication Templates** - Standardized formats for team communication
4. **Workflow Examples** - Step-by-step processes for common scenarios
5. **Quality Gate Examples** - Automated quality control configurations
6. **Performance Monitoring** - Scripts and metrics for tracking system health

The examples are practical, actionable, and cover the full spectrum of orchestrator operations from simple project startup to complex enterprise deployments.

<function_calls>
<invoke name="TodoWrite">
<parameter name="todos">[{"id": "1", "content": "Analyze current CLAUDE.md size and structure", "status": "completed", "priority": "high"}, {"id": "2", "content": "Refine CLAUDE.md to keep under 40k character limit", "status": "completed", "priority": "high"}, {"id": "3", "content": "Add brownfield project parsing capabilities", "status": "completed", "priority": "high"}, {"id": "4", "content": "Update docs with example specs, prompts, and workflows", "status": "completed", "priority": "medium"}, {"id": "5", "content": "Commit and push changes to remote origin", "status": "in_progress", "priority": "low"}]