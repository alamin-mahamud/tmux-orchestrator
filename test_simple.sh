#!/bin/bash
# Simple test for orchestrator functionality

set -e

echo "🧪 Testing tmux orchestrator..."

PROJECT_PATH="/Users/alamin/work/tmux-orchestrator/test-project"
SESSION_NAME="test-tmux-orc"

# Clean up any existing session
tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true

echo "🚀 Starting orchestrator test..."
./orchestrator.sh "$PROJECT_PATH"

sleep 10

echo "📊 Checking created windows..."
tmux list-windows -t "$SESSION_NAME" -F '#{window_name}' || echo "Session not found"

echo "🔍 Checking agent windows for activity..."
for window in $(tmux list-windows -t "$SESSION_NAME" -F '#{window_name}' | grep 'Agent-' || true); do
    echo "Window: $window"
    # Check if Claude is running in the window
    if tmux capture-pane -t "$SESSION_NAME:$window" -p | grep -q "claude"; then
        echo "  ✅ Claude active in $window"
    else
        echo "  ❌ No Claude activity in $window"
    fi
done

echo "🏁 Test complete. Attach with: tmux attach -t $SESSION_NAME"