# 📚 Example Projects & Templates

This directory contains real-world examples of how to use the Claude Orchestrator for different types of projects. Each example includes complete configuration files, project specifications, and step-by-step setup instructions.

## 🎯 Quick Reference

| Project Type | Team Size | Complexity | Duration | Best For |
|--------------|-----------|------------|----------|----------|
| [Simple Web App](#simple-web-app) | 2-3 agents | Low | 1-2 weeks | Learning the system |
| [E-commerce Platform](#e-commerce-platform) | 4-5 agents | Medium | 1-3 months | Production applications |
| [Microservices API](#microservices-api) | 5-7 agents | High | 2-4 months | Scalable backends |
| [Mobile App](#mobile-app) | 4-6 agents | Medium-High | 2-3 months | Cross-platform apps |
| [Data Science Project](#data-science-project) | 3-4 agents | Medium | 3-6 weeks | ML/Analytics |
| [DevOps Pipeline](#devops-pipeline) | 3-4 agents | Medium | 2-4 weeks | Infrastructure automation |

## 🚀 Getting Started Examples

### Quick Start Commands

```bash
# Initialize a simple web app
./orchestrator.py start my-web-app /path/to/project --template startup-team

# Start an enterprise-grade e-commerce project  
./orchestrator.py start ecommerce-platform /path/to/project --template enterprise-team

# Launch a data science analysis project
./orchestrator.py start data-analysis /path/to/project --template data-science-team

# Check status of all projects
./orchestrator.py status

# Get detailed report for specific project
./orchestrator.py status --project my-web-app
```

## 📝 Example Project Specifications

Each example includes:
- **Project specification file** (`project_spec.md`)
- **Team configuration** (`team_config.yaml`)
- **Environment setup** (`setup.sh`)
- **Expected outcomes** and success metrics
- **Troubleshooting guide** for common issues

## 🎨 Template Categories

### 🏃‍♂️ Startup Templates
- **Lean MVP Team**: PM + Full-stack Dev + QA
- **Rapid Prototype**: PM + 2 Developers (Frontend/Backend)
- **Solo Plus**: Single developer with AI PM oversight

### 🏢 Enterprise Templates  
- **Full Stack Team**: PM + Lead Architect + Frontend + Backend + DevOps + QA + Security
- **Microservices Team**: PM + Service Architects + Multiple Backend Devs + Platform Engineer
- **Enterprise Integration**: PM + Integration Specialists + API Developers + QA Automation

### 🔬 Specialized Templates
- **Data Science Team**: PM + Data Scientist + ML Engineer + Data Engineer
- **Mobile Development**: PM + iOS Dev + Android Dev + Backend Dev + QA
- **DevOps/Platform**: PM + Platform Engineer + SRE + Security Engineer

## 🎓 Learning Path

### Beginner (Start Here)
1. **Simple Web App** - Learn basic orchestration
2. **Task Automation** - Understand agent communication
3. **Bug Fix Project** - Practice coordination patterns

### Intermediate
1. **E-commerce Platform** - Multi-agent coordination
2. **API Development** - Backend specialization
3. **Mobile App** - Cross-platform development

### Advanced
1. **Microservices Architecture** - Complex system design
2. **Enterprise Integration** - Large team management
3. **Custom Domain Project** - Create your own templates

## 🔧 Customization Examples

### Creating Custom Agent Types
```yaml
# Example: DevOps Specialist
devops_specialist:
  personality: "systematic"
  specialization: ["kubernetes", "terraform", "monitoring"]
  responsibilities:
    - infrastructure_automation
    - deployment_pipelines
    - system_monitoring
    - security_compliance
```

### Industry-Specific Configurations
```yaml
# Example: FinTech Project
fintech_overrides:
  quality:
    security_scan: "mandatory"
    compliance_check: "required"
    audit_trail: "complete"
  
  agents:
    compliance_officer:
      responsibilities: ["regulatory_compliance", "risk_assessment"]
```

## 📊 Success Metrics Examples

Each project template includes realistic success metrics:

- **Development Velocity**: Story points per sprint, feature completion rate
- **Quality Metrics**: Test coverage, bug density, performance benchmarks  
- **Team Efficiency**: Communication overhead, blocked time, rework rate
- **Business Outcomes**: User engagement, system reliability, cost efficiency

## 🆘 Common Scenarios & Solutions

### Scenario: "My agents keep getting stuck"
**Solution**: Use the `debugging/stuck-agents` example
- Shows how to implement auto-recovery
- Demonstrates proper error handling
- Includes agent health monitoring

### Scenario: "Too much communication overhead"
**Solution**: Use the `patterns/efficient-communication` example
- Implements hub-and-spoke patterns
- Shows asynchronous update protocols
- Reduces n² communication complexity

### Scenario: "Quality is inconsistent"
**Solution**: Use the `quality/high-standards` example
- Enforces automated quality gates
- Implements peer review workflows
- Shows continuous quality monitoring

## 🔄 Workflow Examples

### Daily Development Workflow
```bash
# Morning startup
./examples/workflows/daily-startup.sh my-project

# Midday progress check
./examples/workflows/progress-check.sh my-project

# End of day wrap-up
./examples/workflows/end-of-day.sh my-project
```

### Feature Development Workflow
```bash
# Start new feature
./examples/workflows/start-feature.sh my-project "user-authentication"

# Monitor feature progress
./examples/workflows/monitor-feature.sh my-project "user-authentication"

# Complete and deploy feature
./examples/workflows/complete-feature.sh my-project "user-authentication"
```

## 🎪 Interactive Demos

### Live Demo Sessions
Run interactive demos to see the orchestrator in action:

```bash
# 5-minute quick demo
./examples/demos/quick-demo.sh

# 15-minute comprehensive demo  
./examples/demos/full-demo.sh

# Specific scenario demo
./examples/demos/scenario-demo.sh ecommerce-checkout
```

Each demo includes:
- Real-time agent communication
- Live problem-solving scenarios
- Interactive decision points
- Performance metrics display

## 🎯 Next Steps

1. **Choose your starting example** based on your experience level
2. **Follow the setup instructions** in each example directory
3. **Customize the templates** for your specific needs
4. **Share your results** and contribute improvements back to the community

For detailed walkthroughs of each example, explore the subdirectories in this folder.