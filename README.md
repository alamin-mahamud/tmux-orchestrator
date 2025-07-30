# 🎯 Tmux Orchestrator

> **Simple. Lean. Efficient. One obvious way to do it.**

AI-powered development teams in tmux sessions. Deploy autonomous agents that write code, fix bugs, and ship quality software.

## ⚡ Quick Start

```bash
# Start any project (one command)
./orchestrator.sh /path/to/your/project

# Attach to session
tmux attach -t your-project-name
```

That's it. Everything else is automatic.

## 🎭 What It Does

**Automatically detects your project:**
- React/Vue → `npm install && npm start`  
- Python/Django → `pip install && python manage.py runserver`
- Go → `go run main.go`
- Rust → `cargo run`

**Deploys the right team:**
- Small (<1k LOC): 1 Developer + 1 PM
- Medium (<10k LOC): Lead Dev + Dev + QA + PM  
- Large (>10k LOC): Tech Lead + 2 Devs + QA + DevOps + PM

**Enforces quality:**
- 80% test coverage minimum
- Conventional commits required
- Code reviews mandatory
- Automated quality gates

## 🏗️ Architecture

```
┌─────────────────┐
│   Orchestrator  │ ← You (monitors, decides, resolves)
├─────────────────┤
│ Project Manager │ ← Enforces quality, coordinates team
├─────────────────┤
│   Developer(s)  │ ← Writes code, tests, commits
├─────────────────┤
│  QA Engineer    │ ← Tests, automation, coverage
├─────────────────┤
│   DevOps        │ ← CI/CD, deployment, monitoring
└─────────────────┘
```

## 📋 Agent Behavior

**✅ Good Developer:**
```bash
git checkout -b feature/user-auth
# write code with tests
git commit -m "feat(auth): add JWT token validation"
# status update every hour
```

**❌ Bad Developer:**
```bash
# edit files randomly
git commit -m "fix stuff"
git push -f origin main
# no tests, no status updates
```

**✅ Good Project Manager:**
```
PM: "STATUS?" (every 4 hours)
Dev1: "85% coverage, implementing user auth"
Dev2: "Blocked on API keys, need help"
PM: "Helping Dev2, summary sent to orchestrator"
```

## 🔐 Quality Gates

**Before every commit:**
- [ ] All tests pass
- [ ] Coverage ≥ 80%  
- [ ] No linting errors
- [ ] No security warnings

**Before every merge:**
- [ ] Code reviewed
- [ ] Documentation updated
- [ ] No conflicts with main

## 🚨 Emergency Protocols

**Production Down:**
```
DevOps: "INCIDENT: API 500s"
→ All agents drop work, help DevOps
→ PM tracks actions, orchestrator monitors
→ Escalate if not resolved in 30min
```

**Agent Unresponsive:**
```
PM: No commits for 2+ hours
→ "PING @agent"
→ Wait 5 minutes  
→ Report to orchestrator for replacement
```

## 📁 Files

- `CLAUDE.md` - Agent instructions and behavior patterns
- `orchestrator.sh` - Single entry point script
- `schedule_with_note.sh` - Self-scheduling utility
- `send-claude-message.sh` - Agent communication utility

## 🎮 For Orchestrators

**Critical: Self-Schedule at startup:**
```bash
./schedule_with_note.sh 15 "Health check" "$(tmux display-message -p '#{session_name}:#{window_index}')"
```

**Monitor agent health every 15 minutes**
**Resolve conflicts and blockers**  
**Make final decisions**

## 🎯 Success Metrics

- **Code Quality**: >80% coverage, 0 critical vulnerabilities
- **Team Velocity**: Commits every <2 hours, standups every 4 hours
- **System Health**: >95% agent responsiveness  
- **Delivery**: Features shipped, not just coded

## 🧠 Philosophy

- **Automate ruthlessly** - No manual toil
- **Communicate clearly** - No ambiguity
- **Ship quality code** - No shortcuts
- **Simple is better than complex**
- **There should be one obvious way to do it**

---

Built with ❤️ following Python Zen principles.