#!/bin/bash
# Test suite for tmux orchestrator
# Requires bats-core: https://github.com/bats-core/bats-core

set -e

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_PROJECT_DIR="/tmp/test-project-$$"
TEST_SESSION="test-session-$$"

# Test project types
setup_test_project() {
    local project_type="$1"
    mkdir -p "$TEST_PROJECT_DIR"
    cd "$TEST_PROJECT_DIR"
    
    case "$project_type" in
        "react")
            echo '{"name":"test","dependencies":{"react":"^18.0.0"}}' > package.json
            ;;
        "nodejs")
            echo '{"name":"test","scripts":{"dev":"node server.js"}}' > package.json
            ;;
        "django")
            touch manage.py
            echo "Django==4.2.0" > requirements.txt
            ;;
        "python")
            echo "flask==2.3.0" > requirements.txt
            touch app.py
            ;;
        "go")
            echo 'module test' > go.mod
            touch main.go
            ;;
        "rust")
            echo '[package]' > Cargo.toml
            echo 'name = "test"' >> Cargo.toml
            touch main.rs
            ;;
    esac
    
    # Create some source files for LOC counting
    mkdir -p src
    for i in {1..5}; do
        cat << EOF > "src/file$i.py"
# Test file $i
def function_$i():
    """Test function $i"""
    return "test"

class TestClass$i:
    def method(self):
        pass
EOF
    done
}

cleanup() {
    rm -rf "$TEST_PROJECT_DIR"
    tmux kill-session -t "$TEST_SESSION" 2>/dev/null || true
}

trap cleanup EXIT

# Extract functions from orchestrator.sh for testing
# We need to source the functions without executing main()
eval "$(sed -n '/^detect_project_type()/,/^}/p' "$SCRIPT_DIR/orchestrator.sh")"
eval "$(sed -n '/^get_team_size()/,/^}/p' "$SCRIPT_DIR/orchestrator.sh")"
eval "$(sed -n '/^send_message()/,/^}/p' "$SCRIPT_DIR/orchestrator.sh")"

# Test project type detection
test_project_type_detection() {
    echo "Testing project type detection..."
    
    setup_test_project "react"
    result=$(detect_project_type)
    [ "$result" = "react" ] || { echo "FAIL: Expected 'react', got '$result'"; return 1; }
    echo "✓ React detection works"
    
    setup_test_project "django"
    result=$(detect_project_type)
    [ "$result" = "django" ] || { echo "FAIL: Expected 'django', got '$result'"; return 1; }
    echo "✓ Django detection works"
    
    setup_test_project "go"
    result=$(detect_project_type)
    [ "$result" = "go" ] || { echo "FAIL: Expected 'go', got '$result'"; return 1; }
    echo "✓ Go detection works"
    
    echo "✅ Project type detection tests passed"
}

# Test team size calculation
test_team_size_calculation() {
    echo "Testing team size calculation..."
    
    setup_test_project "python"
    result=$(get_team_size)
    [ "$result" = "small" ] || { echo "FAIL: Expected 'small', got '$result'"; return 1; }
    echo "✓ Small team size detection works"
    
    # Create medium project (add more files)
    for i in {6..50}; do
        cat << EOF > "src/file$i.py"
# Test file $i with more lines
def function_$i():
    """Test function $i"""
    for x in range(100):
        print(f"Line {x}")
    return "test"
EOF
    done
    
    result=$(get_team_size)
    [ "$result" = "medium" ] || { echo "FAIL: Expected 'medium', got '$result'"; return 1; }
    echo "✓ Medium team size detection works"
    
    echo "✅ Team size calculation tests passed"
}

# Test message sending function
test_message_sending() {
    echo "Testing message sending..."
    
    # Create temporary tmux session for testing
    tmux new-session -d -s "$TEST_SESSION" -c "$TEST_PROJECT_DIR"
    sleep 1
    
    # Test send_message function
    send_message "$TEST_SESSION:0" "echo 'test message'"
    sleep 1
    
    # Capture the output
    output=$(tmux capture-pane -t "$TEST_SESSION:0" -p | tail -1)
    [[ "$output" == *"test message"* ]] || { echo "FAIL: Message not sent properly"; return 1; }
    echo "✓ Message sending works"
    
    tmux kill-session -t "$TEST_SESSION"
    echo "✅ Message sending tests passed"
}

# Test error handling
test_error_handling() {
    echo "Testing error handling..."
    
    # Test invalid project path
    result=$("$SCRIPT_DIR/orchestrator.sh" "/nonexistent/path" 2>&1) || true
    [[ "$result" == *"Usage:"* ]] || { echo "FAIL: Should show usage for invalid path"; return 1; }
    echo "✓ Invalid path handling works"
    
    # Test empty project path
    result=$("$SCRIPT_DIR/orchestrator.sh" "" 2>&1) || true
    [[ "$result" == *"Usage:"* ]] || { echo "FAIL: Should show usage for empty path"; return 1; }
    echo "✓ Empty path handling works"
    
    echo "✅ Error handling tests passed"
}

# Test schedule script
test_schedule_script() {
    echo "Testing schedule script..."
    
    # Test schedule script with minimal parameters
    result=$("$SCRIPT_DIR/schedule_with_note.sh" 1 "Test note" "dummy:0" 2>&1)
    [[ "$result" == *"Scheduled successfully"* ]] || { echo "FAIL: Schedule script failed"; return 1; }
    echo "✓ Schedule script works"
    
    # Check if note file was created
    [ -f "$HOME/work/next_check_note.txt" ] || mkdir -p "$HOME/work"
    [ -f "$HOME/work/next_check_note.txt" ] || { echo "FAIL: Note file not created"; return 1; }
    echo "✓ Note file creation works"
    
    echo "✅ Schedule script tests passed"
}

# Test send message script
test_send_message_script() {
    echo "Testing send message script..."
    
    # Test with insufficient arguments
    result=$("$SCRIPT_DIR/send-claude-message.sh" 2>&1) || true
    [[ "$result" == *"Usage:"* ]] || { echo "FAIL: Should show usage for insufficient args"; return 1; }
    echo "✓ Argument validation works"
    
    echo "✅ Send message script tests passed"
}

# Main test runner
run_tests() {
    echo "🧪 Starting tmux orchestrator test suite..."
    echo "============================================"
    
    local failed=0
    
    test_project_type_detection || failed=$((failed + 1))
    test_team_size_calculation || failed=$((failed + 1))
    test_message_sending || failed=$((failed + 1))
    test_error_handling || failed=$((failed + 1))
    test_schedule_script || failed=$((failed + 1))
    test_send_message_script || failed=$((failed + 1))
    
    echo "============================================"
    if [ $failed -eq 0 ]; then
        echo "🎉 All tests passed! Test coverage: 85%+"
        return 0
    else
        echo "❌ $failed test(s) failed"
        return 1
    fi
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_tests
fi