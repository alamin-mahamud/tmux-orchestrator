# 🚀 Quick Start Guide

## Prerequisites

- Tmux installed and configured
- Claude CLI with `--dangerously-skip-permissions` access
- Git repository for your project
- Basic understanding of tmux sessions and windows

## 🎯 5-Minute Setup

### Option 1: Simple Single-Agent Setup
Perfect for small tasks or getting familiar with the system.

```bash
# 1. Create project session
tmux new-session -d -s my-project -c "/path/to/your/project"

# 2. Start Claude in window 0
tmux send-keys -t my-project:0 "claude --dangerously-skip-permissions" Enter
sleep 5

# 3. Brief the agent
./send-claude-message.sh my-project:0 "You are a senior developer working on this project. 
Start by analyzing the codebase structure and identifying the most important tasks. 
Check for any README, TODO files, or GitHub issues for guidance.
Schedule yourself to check in every 30 minutes using: ./schedule_with_note.sh 30 'Continue development work'"

# 4. Monitor progress
tmux attach-session -t my-project
```

### Option 2: Full Team Setup
For serious projects requiring coordination between multiple specialists.

```bash
# 1. Create orchestrator session
tmux new-session -d -s orchestrator
tmux send-keys -t orchestrator:0 "claude --dangerously-skip-permissions" Enter
sleep 5

# 2. Brief the orchestrator
./send-claude-message.sh orchestrator:0 "You are the Orchestrator managing multiple AI development teams.

Your first task: Set up a complete development team for the project at /path/to/your/project

Create:
- Project Manager (window 1)
- Senior Developer (window 2) 
- QA Engineer (window 3)

Each agent should:
1. Understand their role and responsibilities
2. Analyze the project requirements
3. Begin working on their assigned tasks
4. Schedule regular check-ins

Schedule yourself to monitor all teams every 60 minutes."

# 3. Monitor the orchestrator as it sets up the team
tmux attach-session -t orchestrator
```

## 📋 Project Specification Template

Create a clear specification file to guide your agents:

```bash
cat > project_spec.md << 'EOF'
# Project: [Your Project Name]

## 🎯 Objective
[Clear, specific goal - what should be accomplished?]

## 📋 Requirements
- [ ] Requirement 1 (with specific acceptance criteria)
- [ ] Requirement 2 (with measurable outcomes)
- [ ] Requirement 3 (with quality standards)

## 🚫 Constraints
- Use existing database schema (no migrations)
- Follow current code style and patterns
- Maximum 5 new dependencies
- Must be backwards compatible

## 🎁 Deliverables
1. **Feature A**: Detailed description with acceptance criteria
2. **Feature B**: Specific functionality requirements
3. **Documentation**: Updated README and API docs
4. **Tests**: Unit and integration test coverage >80%

## ✅ Definition of Done
- [ ] All features implemented and tested
- [ ] Code review completed
- [ ] Documentation updated
- [ ] Performance benchmarks met
- [ ] Security review passed
- [ ] Deployed to staging environment

## 📊 Success Metrics
- User engagement increases by 20%
- Page load time <2 seconds
- Zero critical bugs in first week
- 95% uptime in production

## ⏰ Timeline
- Phase 1 (Week 1): Core functionality
- Phase 2 (Week 2): Integration and testing  
- Phase 3 (Week 3): Polish and deployment

## 🔗 Resources
- Design mockups: [link]
- API documentation: [link]
- Database schema: docs/schema.md
- Style guide: docs/style-guide.md
EOF
```

## 🎨 Example Project Structures

### Web Application Project
```
web-app-project/
├── project_spec.md          # Project requirements
├── frontend/                # React/Vue/Angular app
├── backend/                 # API server
├── database/               # Schema and migrations
├── docs/                   # Documentation
└── tests/                  # Test suites
```

**Recommended Team**: PM + Frontend Dev + Backend Dev + QA

### API Development Project
```
api-project/
├── project_spec.md
├── src/                    # Source code
├── tests/                  # Unit and integration tests
├── docs/                   # API documentation
├── docker/                 # Containerization
└── deployment/             # Infrastructure code
```

**Recommended Team**: PM + Backend Dev + DevOps + QA

### Mobile App Project
```
mobile-project/
├── project_spec.md
├── ios/                    # iOS native code
├── android/                # Android native code
├── shared/                 # Shared business logic
├── api/                    # Backend services
└── design/                 # UI/UX assets
```

**Recommended Team**: PM + iOS Dev + Android Dev + Backend Dev + QA

## 🔧 Configuration Examples

### Basic Agent Configuration
```yaml
# config/agents.yaml
orchestrator:
  check_interval: 60
  max_concurrent_projects: 5
  escalation_timeout: 600

project_manager:
  check_interval: 30
  quality_standards: "high"
  communication_style: "proactive"

developer:
  commit_frequency: 30
  testing_required: true
  code_review_required: true

qa_engineer:
  test_coverage_minimum: 80
  automation_priority: "high"
  bug_severity_levels: ["critical", "high", "medium", "low"]
```

### Custom Prompts Configuration
```yaml
# config/prompts.yaml
roles:
  project_manager:
    base_prompt: "You are a meticulous Project Manager focused on quality and coordination."
    responsibilities:
      - "Quality assurance and standards enforcement"
      - "Team coordination and communication"
      - "Risk identification and mitigation"
    communication_style: "Clear, structured, proactive"
    
  senior_developer:
    base_prompt: "You are an experienced software developer with expertise in modern development practices."
    specializations: ["architecture", "performance", "security"]
    practices: ["TDD", "code_review", "documentation"]
```

## 📱 Common Workflows

### Daily Development Workflow
```bash
# Morning startup
./orchestrator.sh start --project myapp
./orchestrator.sh status --all

# Check progress throughout day
tmux list-sessions
tmux capture-pane -t project:pm -p | tail -20

# End of day
./orchestrator.sh report --project myapp
./orchestrator.sh pause --all
```

### Feature Development Workflow
```bash
# 1. Create feature specification
cat > features/user-auth.md << 'EOF'
# User Authentication Feature
[Detailed requirements...]
EOF

# 2. Assign to team
./send-claude-message.sh myapp:pm "New feature request: implement user authentication system. See features/user-auth.md for requirements."

# 3. Monitor progress
./orchestrator.sh monitor --feature user-auth

# 4. Review and deploy
./orchestrator.sh review --feature user-auth
./orchestrator.sh deploy --feature user-auth
```

### Bug Fix Workflow
```bash
# 1. Report bug to QA
./send-claude-message.sh myapp:qa "Bug report: Users cannot login with special characters in password. Priority: HIGH"

# 2. QA reproduces and assigns
# 3. Developer fixes and tests
# 4. QA verifies fix
# 5. PM approves deployment
```

## 🚨 Troubleshooting Quick Fixes

### Agent Not Responding
```bash
# Check if Claude is running
tmux capture-pane -t session:window -p | tail -10

# Restart if needed
tmux send-keys -t session:window C-c
tmux send-keys -t session:window "claude --dangerously-skip-permissions" Enter
```

### Scheduling Issues
```bash
# Verify orchestrator knows its window
echo "Current window: $(tmux display-message -p "#{session_name}:#{window_index}")"

# Test scheduling script
./schedule_with_note.sh 1 "Test schedule" "$(tmux display-message -p "#{session_name}:#{window_index}")"
```

### Communication Problems
```bash
# Test message sending
./send-claude-message.sh target:window "Test message"

# Check tmux session list
tmux list-sessions
tmux list-windows -t session-name
```

### Git Issues
```bash
# Check git status across all projects
for session in $(tmux list-sessions -F "#{session_name}"); do
    echo "=== $session ==="
    tmux send-keys -t $session:0 "git status" Enter
    sleep 2
    tmux capture-pane -t $session:0 -p | tail -10
done
```

## 📈 Next Steps

1. **Start Small**: Begin with a single-agent setup for a small task
2. **Learn by Observing**: Watch how agents communicate and coordinate
3. **Expand Gradually**: Add more agents as you understand the patterns
4. **Customize**: Adapt agent roles and behaviors to your specific needs
5. **Contribute**: Share your discoveries and improvements with the community

For more detailed information, see:
- [Agent Roles](AGENT_ROLES.md) - Detailed role descriptions and responsibilities
- [Configuration Guide](CONFIGURATION.md) - Advanced customization options
- [Example Projects](examples/) - Complete project setups and workflows
- [Troubleshooting](TROUBLESHOOTING.md) - Common issues and solutions