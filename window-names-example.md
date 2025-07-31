# Window Names Update Summary

## Changes Made

The orchestrator has been updated to use window names instead of numbers. This makes it work universally regardless of tmux's `base-index` setting.

### Key Changes:

1. **Window Creation**: All windows now have descriptive names:
   - `Orchestrator` - Main orchestrator window
   - `Shell` - Shell commands window
   - `Dev-Server` - Development server
   - `Tests` - Test runner
   - `Agent-PM` - Project Manager agent
   - `Agent-Dev` - Developer agent
   - `Agent-Lead` - Lead Developer agent
   - `Agent-QA` - QA Engineer agent
   - `Agent-DevOps` - DevOps Engineer agent

2. **Window Selection**: Instead of using numbers like `$SESSION_NAME:0`, we now use names like `$SESSION_NAME:Orchestrator`

3. **Benefits**:
   - Works with any tmux configuration (base-index 0 or 1)
   - More readable and maintainable
   - Self-documenting window purposes

### Example Usage:

```bash
# Start orchestrator with any project
./orchestrator.sh /path/to/project

# Windows are created with names:
# myproject:Orchestrator
# myproject:Shell
# myproject:Dev-Server
# myproject:Agent-PM
# myproject:Agent-Dev

# Send messages using window names:
tmux send-keys -t myproject:Agent-Dev "Hello Developer!"
```

### Updated Files:
- `orchestrator.sh` - Uses window names + flexible specs discovery
- `schedule_with_note.sh` - Default target is now `tmux-orc:Orchestrator`  
- `test_orchestrator.sh` - Tests updated to use window names

### Specs Discovery:
The orchestrator now automatically finds your existing project specs from:
`specs/`, `epics/`, `stories/`, `requirements/`, `docs/`, plus any root-level markdown files.

**No configuration needed - just works with your existing structure.**