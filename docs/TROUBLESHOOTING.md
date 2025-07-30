# 🛠️ Troubleshooting Guide

This guide helps you diagnose and resolve common issues with the Claude Orchestrator system.

## 🚨 Common Issues & Solutions

### Agent Communication Problems

#### Issue: "Agent not responding to messages"
**Symptoms:**
- Messages sent but no response from agent
- Agent appears frozen or inactive
- Health checks failing

**Diagnosis:**
```bash
# Check if tmux session exists
tmux list-sessions | grep claude-

# Check window contents
tmux capture-pane -t session:window -p | tail -50

# Test message sending
./send-claude-message.sh session:window "Test message"
```

**Solutions:**
1. **Claude Process Died:**
   ```bash
   # Restart Claude in the window
   tmux send-keys -t session:window C-c
   tmux send-keys -t session:window "claude --dangerously-skip-permissions" Enter
   ```

2. **Wrong Window Target:**
   ```bash
   # List all windows in session
   tmux list-windows -t session-name
   
   # Use correct window index or name
   ./send-claude-message.sh session:correct-window "Message"
   ```

3. **Tmux Permission Issues:**
   ```bash
   # Check tmux server status
   tmux info
   
   # Kill and restart tmux server if needed
   tmux kill-server
   tmux new-session -d -s test-session
   ```

#### Issue: "send-claude-message.sh not working"
**Symptoms:**
- Script returns errors
- Messages not delivered
- Permission denied errors

**Solutions:**
```bash
# Make script executable
chmod +x send-claude-message.sh

# Check script contents
cat send-claude-message.sh

# Test with simple message
./send-claude-message.sh session:0 "Hello"

# If script is missing, recreate it:
cat > send-claude-message.sh << 'EOF'
#!/bin/bash
TARGET=$1
MESSAGE=$2
tmux send-keys -t "$TARGET" "$MESSAGE"
sleep 0.5
tmux send-keys -t "$TARGET" Enter
EOF
chmod +x send-claude-message.sh
```

### Project Startup Issues

#### Issue: "orchestrator.py fails to start project"
**Symptoms:**
- Python errors when running orchestrator
- Missing dependencies
- Configuration errors

**Diagnosis:**
```bash
# Check Python version
python3 --version

# Test basic orchestrator functionality
python3 -c "from orchestrator import ProjectOrchestrator; print('Import successful')"

# Check for missing dependencies
python3 orchestrator.py config validate
```

**Solutions:**
1. **Missing Dependencies:**
   ```bash
   # Install required packages
   pip3 install pyyaml sqlite3
   
   # Or create virtual environment
   python3 -m venv venv
   source venv/bin/activate
   pip install pyyaml
   ```

2. **Configuration Issues:**
   ```bash
   # Initialize default configuration
   python3 orchestrator.py config init
   
   # Check configuration validity
   python3 orchestrator.py config validate
   ```

3. **Permission Errors:**
   ```bash
   # Make orchestrator executable
   chmod +x orchestrator.py
   
   # Check file permissions
   ls -la orchestrator.py
   ```

#### Issue: "Tmux session creation fails"
**Symptoms:**
- "session not found" errors
- Unable to create new sessions
- Permission denied when creating sessions

**Solutions:**
```bash
# Check tmux installation
which tmux
tmux -V

# Kill any hanging sessions
tmux kill-server

# Test session creation manually
tmux new-session -d -s test-session -c "$(pwd)"
tmux list-sessions

# If still failing, restart tmux server
pkill tmux
tmux new-session -d -s recovery-test
```

### Agent Deployment Problems

#### Issue: "Agents deployed but not working properly"
**Symptoms:**
- Agents created but don't follow instructions
- Inconsistent behavior across agents
- Agents seem confused about their roles

**Diagnosis:**
```bash
# Check agent window contents
for window in 0 1 2 3; do
    echo "=== Window $window ==="
    tmux capture-pane -t session:$window -p | tail -20
done

# Check if Claude is running in each window
tmux list-windows -t session -F "#{window_index}: #{window_name} - #{pane_current_command}"
```

**Solutions:**
1. **Improper Agent Briefing:**
   ```bash
   # Rebriefed agent with clear role
   ./send-claude-message.sh session:0 "You are a Project Manager. Your role is to coordinate the team and ensure quality. Start by reviewing the project requirements."
   ```

2. **Claude Not Started:**
   ```bash
   # Start Claude in each window
   tmux send-keys -t session:window "claude --dangerously-skip-permissions" Enter
   sleep 5
   # Then send briefing
   ```

3. **Configuration Conflicts:**
   ```bash
   # Clear any existing configuration
   tmux send-keys -t session:window C-c
   tmux send-keys -t session:window "clear" Enter
   # Restart with proper briefing
   ```

### Scheduling and Automation Issues

#### Issue: "schedule_with_note.sh not working"
**Symptoms:**
- Scheduled check-ins don't happen
- Script errors or not found
- Agents don't resume work automatically

**Diagnosis:**
```bash
# Check if script exists and is executable
ls -la schedule_with_note.sh

# Test the script manually
./schedule_with_note.sh 1 "Test schedule" "session:0"

# Check for at command availability
which at
at -l
```

**Solutions:**
1. **Missing 'at' Command:**
   ```bash
   # Install at daemon (Ubuntu/Debian)
   sudo apt update && sudo apt install at
   
   # Start at service
   sudo systemctl start atd
   sudo systemctl enable atd
   
   # macOS
   brew install at
   ```

2. **Script Not Executable:**
   ```bash
   chmod +x schedule_with_note.sh
   ```

3. **Wrong Window Target:**
   ```bash
   # Get current window info
   CURRENT_WINDOW=$(tmux display-message -p "#{session_name}:#{window_index}")
   echo "Current window: $CURRENT_WINDOW"
   
   # Use correct target in scheduling
   ./schedule_with_note.sh 30 "Regular check-in" "$CURRENT_WINDOW"
   ```

### Performance and Resource Issues

#### Issue: "System running slowly with many agents"
**Symptoms:**
- High CPU usage
- Slow response times
- Memory usage climbing
- Tmux becoming unresponsive

**Diagnosis:**
```bash
# Check system resources
top -p $(pgrep -d, tmux)
ps aux | grep claude

# Check tmux session count
tmux list-sessions | wc -l

# Monitor memory usage
free -h
```

**Solutions:**
1. **Too Many Concurrent Sessions:**
   ```bash
   # List all sessions
   tmux list-sessions
   
   # Kill unused sessions
   tmux kill-session -t unused-session-name
   
   # Clean up old sessions
   for session in $(tmux list-sessions -F "#{session_name}" | grep "old-"); do
       tmux kill-session -t "$session"
   done
   ```

2. **Memory Leaks in Claude:**
   ```bash
   # Restart agents periodically
   ./send-claude-message.sh session:window "Please restart yourself to clear memory: exit and restart Claude"
   
   # Or restart automatically
   tmux send-keys -t session:window C-c
   sleep 2
   tmux send-keys -t session:window "claude --dangerously-skip-permissions" Enter
   ```

3. **Optimize Agent Count:**
   ```bash
   # Use fewer, more capable agents
   # Instead of 5 specialists, use 2-3 generalists
   ./orchestrator.py start project /path --template minimal-team
   ```

## 🔧 Advanced Debugging

### Debug Mode Setup
```bash
# Enable verbose tmux logging
tmux set-option -g history-limit 10000

# Create debug session for monitoring
tmux new-session -d -s debug-monitor

# Monitor all sessions
watch -n 5 'tmux list-sessions -F "#{session_name}: #{session_windows} windows, #{session_attached} attached"'
```

### Log Analysis
```bash
# Create logs directory
mkdir -p logs

# Capture all agent conversations
for session in $(tmux list-sessions -F "#{session_name}" | grep claude-); do
    for window in $(tmux list-windows -t "$session" -F "#{window_index}"); do
        tmux capture-pane -t "$session:$window" -S -1000 -p > "logs/${session}_${window}_$(date +%Y%m%d_%H%M%S).log"
    done
done

# Analyze for common issues
grep -r "error\|Error\|ERROR" logs/
grep -r "failed\|Failed\|FAILED" logs/
```

### Health Check System
```bash
# Create comprehensive health check script
cat > health_check.sh << 'EOF'
#!/bin/bash

echo "=== Claude Orchestrator Health Check ==="
echo "Timestamp: $(date)"
echo

# Check tmux
echo "Tmux Status:"
tmux info | head -5
echo

# Check sessions
echo "Active Sessions:"
tmux list-sessions 2>/dev/null || echo "No active sessions"
echo

# Check Claude processes
echo "Claude Processes:"
pgrep -f claude | wc -l | xargs echo "Count:"
echo

# Check system resources
echo "System Resources:"
echo "Memory: $(free -h | grep Mem | awk '{print $3 "/" $2}')"
echo "CPU Load: $(uptime | awk -F'load average:' '{print $2}')"
echo

# Check recent errors
if [ -d logs ]; then
    echo "Recent Errors:"
    find logs -name "*.log" -mtime -1 -exec grep -l "error\|failed" {} \; | head -5
fi

echo "=== Health Check Complete ==="
EOF

chmod +x health_check.sh
./health_check.sh
```

## 🚨 Emergency Recovery Procedures

### Complete System Reset
```bash
#!/bin/bash
# emergency_reset.sh - Use only when system is completely broken

echo "WARNING: This will kill all tmux sessions and restart the orchestrator"
read -p "Are you sure? (yes/no): " confirm

if [ "$confirm" = "yes" ]; then
    # Kill all tmux sessions
    tmux kill-server 2>/dev/null
    
    # Clean up any hanging processes
    pkill -f claude 2>/dev/null
    
    # Wait for cleanup
    sleep 5
    
    # Restart tmux server
    tmux new-session -d -s recovery-session
    
    echo "System reset complete. You can now restart your projects."
else
    echo "Reset cancelled."
fi
```

### Project Recovery
```bash
#!/bin/bash
# recover_project.sh - Recover a specific project

PROJECT_NAME=$1
PROJECT_PATH=$2

if [ -z "$PROJECT_NAME" ] || [ -z "$PROJECT_PATH" ]; then
    echo "Usage: $0 <project-name> <project-path>"
    exit 1
fi

echo "Recovering project: $PROJECT_NAME"

# Kill existing session
tmux kill-session -t "claude-$PROJECT_NAME" 2>/dev/null

# Restart the project
./orchestrator.py start "$PROJECT_NAME" "$PROJECT_PATH"

echo "Project recovery initiated for $PROJECT_NAME"
```

## 📋 Preventive Maintenance

### Daily Maintenance Script
```bash
#!/bin/bash
# daily_maintenance.sh

# Clean up old log files
find logs -name "*.log" -mtime +7 -delete 2>/dev/null

# Check for hung sessions
for session in $(tmux list-sessions -F "#{session_name}" 2>/dev/null); do
    # Check if session is responsive
    tmux capture-pane -t "$session:0" -p | tail -1 | grep -q "."
    if [ $? -ne 0 ]; then
        echo "Warning: Session $session appears hung"
    fi
done

# Generate health report
./health_check.sh > "logs/health_$(date +%Y%m%d).log"

echo "Daily maintenance complete"
```

### Monitoring Script
```bash
#!/bin/bash
# monitor.sh - Continuous monitoring

while true; do
    # Check every 5 minutes
    sleep 300
    
    # Check if any Claude processes died
    if [ $(pgrep -f claude | wc -l) -lt 1 ]; then
        echo "$(date): WARNING - No Claude processes running"
        # Could trigger automatic recovery here
    fi
    
    # Check memory usage
    MEMORY_USAGE=$(free | awk '/^Mem:/{printf("%.1f", $3/$2*100)}')
    if (( $(echo "$MEMORY_USAGE > 85.0" | bc -l) )); then
        echo "$(date): WARNING - High memory usage: ${MEMORY_USAGE}%"
    fi
    
    # Log status
    echo "$(date): System OK - $(tmux list-sessions | wc -l) sessions active"
done
```

## 📞 Getting Help

### Self-Diagnosis Checklist
Before seeking help, run through this checklist:

```
□ Tmux is installed and running
□ Claude CLI is accessible
□ All scripts are executable (chmod +x)
□ No permission errors in logs
□ System has adequate memory and CPU
□ No conflicting tmux sessions
□ Agent briefings are clear and specific
□ Project paths exist and are accessible
□ Configuration files are valid YAML
□ Recent system updates haven't broken dependencies
```

### Collecting Debug Information
When reporting issues, include:

```bash
# System information
uname -a
tmux -V
python3 --version

# Orchestrator status
./orchestrator.py status --all

# Recent logs
tail -50 logs/*.log

# Health check results
./health_check.sh
```

### Common Error Patterns

| Error Pattern | Likely Cause | Quick Fix |
|---------------|--------------|-----------|
| "session not found" | Tmux session died | Restart session |
| "Permission denied" | Script not executable | `chmod +x script.sh` |
| "No such file" | Wrong path or missing file | Check paths and file existence |
| "command not found" | Missing dependency | Install required software |
| "Connection refused" | Service not running | Start required services |
| Agent not responding | Claude process crashed | Restart Claude in window |
| High memory usage | Too many agents | Reduce agent count |
| Slow performance | Resource constraints | Optimize or add resources |

This troubleshooting guide covers the most common issues you'll encounter. For complex problems, use the debug and monitoring tools to gather detailed information before attempting fixes.