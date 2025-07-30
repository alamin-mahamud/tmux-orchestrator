#!/usr/bin/env python3
"""
Claude Orchestrator - Advanced Configuration Management System
Inspired by BMAD Method for sophisticated AI agent orchestration
"""

import yaml
import json
import os
import sys
import subprocess
import argparse
import time
from pathlib import Path
from typing import Dict, List, Optional, Any
from dataclasses import dataclass, asdict
from datetime import datetime, timedelta

@dataclass
class AgentConfig:
    """Configuration for individual agents"""
    name: str
    role: str
    personality: str
    responsibilities: List[str]
    check_interval: int = 30
    quality_standards: str = "high"
    communication_style: str = "proactive"
    specialization: Optional[str] = None
    
@dataclass 
class ProjectConfig:
    """Configuration for individual projects"""
    name: str
    type: str
    team_composition: List[Dict[str, Any]]
    technology_stack: Dict[str, Any]
    quality_gates: Dict[str, Any]
    workflow_settings: Dict[str, Any]
    
@dataclass
class OrchestratorConfig:
    """Main orchestrator configuration"""
    max_concurrent_projects: int = 10
    check_interval_minutes: int = 60
    log_level: str = "info"
    backup_frequency: int = 30
    tmux_session_prefix: str = "claude-"
    git_auto_commit: bool = True
    git_commit_interval: int = 30

class ConfigManager:
    """Manages configuration loading, validation, and application"""
    
    def __init__(self, config_dir: str = "config"):
        self.config_dir = Path(config_dir)
        self.ensure_config_structure()
        
    def ensure_config_structure(self):
        """Create configuration directory structure if it doesn't exist"""
        dirs = [
            self.config_dir,
            self.config_dir / "agents",
            self.config_dir / "agents" / "custom",
            self.config_dir / "projects", 
            self.config_dir / "templates",
            self.config_dir / "environments",
            self.config_dir / "prompts"
        ]
        
        for dir_path in dirs:
            dir_path.mkdir(parents=True, exist_ok=True)
            
        self.create_default_configs()
        
    def create_default_configs(self):
        """Create default configuration files if they don't exist"""
        
        # Default orchestrator config
        orchestrator_config = self.config_dir / "orchestrator.yaml"
        if not orchestrator_config.exists():
            default_config = {
                "orchestrator": {
                    "max_concurrent_projects": 10,
                    "check_interval_minutes": 60,
                    "log_level": "info",
                    "backup_frequency": 30,
                    "tmux": {
                        "session_prefix": "claude-",
                        "window_naming_convention": "descriptive",
                        "auto_rename_windows": True
                    },
                    "git": {
                        "auto_commit": True,
                        "commit_interval_minutes": 30,
                        "branch_prefix": "feature/",
                        "tag_prefix": "stable-",
                        "enforce_clean_state": True
                    },
                    "communication": {
                        "message_timeout_seconds": 30,
                        "max_retry_attempts": 3,
                        "use_templates": True,
                        "log_all_messages": True
                    },
                    "quality": {
                        "require_tests": True,
                        "min_test_coverage": 80,
                        "require_code_review": True,
                        "enforce_style_guide": True
                    }
                },
                "agents": {
                    "startup_delay_seconds": 5,
                    "shutdown_grace_period": 30,
                    "auto_restart_on_failure": True,
                    "max_restart_attempts": 3,
                    "max_context_tokens": 100000,
                    "memory_cleanup_interval": 60,
                    "idle_timeout_minutes": 120
                }
            }
            
            with open(orchestrator_config, 'w') as f:
                yaml.dump(default_config, f, default_flow_style=False, indent=2)
                
        # Default agent configs
        self.create_default_agent_configs()
        
    def create_default_agent_configs(self):
        """Create default configurations for standard agent types"""
        
        agent_configs = {
            "project_manager": {
                "project_manager": {
                    "personality": "perfectionist",
                    "communication_style": "proactive", 
                    "quality_standards": "high",
                    "responsibilities": [
                        "quality_assurance",
                        "team_coordination", 
                        "risk_management",
                        "progress_tracking",
                        "stakeholder_communication"
                    ],
                    "workflow": {
                        "daily_standup": True,
                        "weekly_reviews": True,
                        "milestone_planning": True,
                        "retrospectives": True
                    },
                    "quality_gates": {
                        "code_review_required": True,
                        "testing_required": True,
                        "documentation_required": True,
                        "performance_check": True,
                        "security_scan": True
                    }
                }
            },
            "developer": {
                "developer": {
                    "type": "full_stack",
                    "seniority": "senior",
                    "practices": [
                        "TDD",
                        "code_review",
                        "documentation",
                        "performance_optimization",
                        "security_first"
                    ],
                    "workflow": {
                        "commit_frequency_minutes": 30,
                        "branch_strategy": "feature_branch",
                        "merge_strategy": "squash_and_merge",
                        "testing_approach": "test_first"
                    },
                    "quality": {
                        "max_function_length": 50,
                        "max_file_length": 500,
                        "cyclomatic_complexity": 10,
                        "test_coverage_minimum": 85
                    }
                }
            },
            "qa_engineer": {
                "qa_engineer": {
                    "specialization": "automation",
                    "testing_approaches": [
                        "unit_testing",
                        "integration_testing", 
                        "e2e_testing",
                        "performance_testing",
                        "security_testing"
                    ],
                    "tools": [
                        "pytest",
                        "selenium",
                        "cypress",
                        "jest",
                        "postman"
                    ],
                    "quality_metrics": {
                        "test_coverage_minimum": 80,
                        "bug_detection_rate": 95,
                        "false_positive_rate": 5
                    }
                }
            }
        }
        
        for agent_type, config in agent_configs.items():
            agent_file = self.config_dir / "agents" / f"{agent_type}.yaml"
            if not agent_file.exists():
                with open(agent_file, 'w') as f:
                    yaml.dump(config, f, default_flow_style=False, indent=2)
                    
    def load_config(self, config_type: str, name: Optional[str] = None) -> Dict[str, Any]:
        """Load configuration by type and optionally by name"""
        
        if config_type == "orchestrator":
            config_file = self.config_dir / "orchestrator.yaml"
        elif config_type == "agent":
            config_file = self.config_dir / "agents" / f"{name}.yaml"
        elif config_type == "project":
            config_file = self.config_dir / "projects" / f"{name}.yaml"
        elif config_type == "template":
            config_file = self.config_dir / "templates" / f"{name}.yaml"
        else:
            raise ValueError(f"Unknown config type: {config_type}")
            
        if not config_file.exists():
            raise FileNotFoundError(f"Configuration file not found: {config_file}")
            
        with open(config_file, 'r') as f:
            return yaml.safe_load(f)
            
    def save_config(self, config_type: str, config_data: Dict[str, Any], name: Optional[str] = None):
        """Save configuration data"""
        
        if config_type == "orchestrator":
            config_file = self.config_dir / "orchestrator.yaml"
        elif config_type == "agent":
            config_file = self.config_dir / "agents" / f"{name}.yaml"
        elif config_type == "project":
            config_file = self.config_dir / "projects" / f"{name}.yaml"
        else:
            raise ValueError(f"Unknown config type: {config_type}")
            
        with open(config_file, 'w') as f:
            yaml.dump(config_data, f, default_flow_style=False, indent=2)

class TmuxManager:
    """Manages tmux sessions, windows, and agent communication"""
    
    def __init__(self, config_manager: ConfigManager):
        self.config_manager = config_manager
        self.orchestrator_config = config_manager.load_config("orchestrator")
        
    def create_session(self, session_name: str, project_path: str) -> bool:
        """Create a new tmux session for a project"""
        try:
            subprocess.run([
                "tmux", "new-session", "-d", "-s", session_name, "-c", project_path
            ], check=True)
            return True
        except subprocess.CalledProcessError:
            return False
            
    def create_window(self, session_name: str, window_name: str, project_path: str) -> bool:
        """Create a new window in a tmux session"""
        try:
            subprocess.run([
                "tmux", "new-window", "-t", session_name, "-n", window_name, "-c", project_path
            ], check=True)
            return True
        except subprocess.CalledProcessError:
            return False
            
    def send_message(self, target: str, message: str) -> bool:
        """Send a message to a Claude agent using the send-claude-message.sh script"""
        try:
            script_path = Path(__file__).parent / "send-claude-message.sh"
            subprocess.run([str(script_path), target, message], check=True)
            return True
        except subprocess.CalledProcessError:
            return False
            
    def capture_pane(self, target: str) -> str:
        """Capture content from a tmux pane"""
        try:
            result = subprocess.run([
                "tmux", "capture-pane", "-t", target, "-p"
            ], capture_output=True, text=True, check=True)
            return result.stdout
        except subprocess.CalledProcessError:
            return ""
            
    def list_sessions(self) -> List[str]:
        """List all active tmux sessions"""
        try:
            result = subprocess.run([
                "tmux", "list-sessions", "-F", "#{session_name}"
            ], capture_output=True, text=True, check=True)
            return result.stdout.strip().split('\n') if result.stdout.strip() else []
        except subprocess.CalledProcessError:
            return []

class AgentManager:
    """Manages agent lifecycle, deployment, and coordination"""
    
    def __init__(self, config_manager: ConfigManager, tmux_manager: TmuxManager):
        self.config_manager = config_manager
        self.tmux_manager = tmux_manager
        self.active_agents: Dict[str, Dict[str, Any]] = {}
        
    def deploy_agent(self, session_name: str, agent_type: str, project_path: str, agent_name: Optional[str] = None) -> bool:
        """Deploy a new agent to a tmux window"""
        
        if agent_name is None:
            agent_name = f"{agent_type}-{len(self.active_agents) + 1}"
            
        window_name = f"Claude-{agent_type.title()}"
        
        # Create window for agent
        if not self.tmux_manager.create_window(session_name, window_name, project_path):
            return False
            
        # Load agent configuration
        try:
            agent_config = self.config_manager.load_config("agent", agent_type)
        except FileNotFoundError:
            print(f"Warning: No configuration found for agent type {agent_type}, using defaults")
            agent_config = {}
            
        # Start Claude in the window
        target = f"{session_name}:{window_name}"
        subprocess.run([
            "tmux", "send-keys", "-t", target, "claude --dangerously-skip-permissions", "Enter"
        ])
        
        # Wait for Claude to start
        time.sleep(5)
        
        # Send agent briefing
        briefing = self.generate_agent_briefing(agent_type, agent_config, project_path)
        if not self.tmux_manager.send_message(target, briefing):
            return False
            
        # Track active agent
        self.active_agents[agent_name] = {
            "type": agent_type,
            "session": session_name,
            "window": window_name,
            "target": target,
            "project_path": project_path,
            "config": agent_config,
            "deployed_at": datetime.now(),
            "last_check": datetime.now()
        }
        
        return True
        
    def generate_agent_briefing(self, agent_type: str, config: Dict[str, Any], project_path: str) -> str:
        """Generate a detailed briefing for an agent based on its type and configuration"""
        
        base_briefings = {
            "project_manager": f"""You are a Project Manager responsible for this project at {project_path}.

Your core responsibilities:
- Maintain exceptionally high quality standards
- Coordinate between team members efficiently  
- Monitor progress and identify blockers
- Ensure all deliverables meet acceptance criteria
- Manage risk and technical debt

Key principles:
- Be meticulous about testing and verification
- Create detailed test plans for every feature
- Ensure code follows best practices and security standards
- Track technical debt and address it proactively
- Communicate clearly and constructively with team members

First steps:
1. Analyze the project structure and current state
2. Review any existing requirements, issues, or documentation
3. Identify immediate priorities and potential risks
4. If needed, deploy team members (developers, QA engineers) to other windows
5. Schedule regular check-ins every 30 minutes

Begin by understanding the project and its current needs.""",

            "developer": f"""You are a Senior Developer working on the project at {project_path}.

Your core responsibilities:
- Write high-quality, maintainable code following best practices
- Implement features according to specifications
- Conduct thorough testing of your implementations
- Participate in code reviews and maintain documentation
- Commit your work every 30 minutes with meaningful commit messages

Technical standards:
- Follow existing code patterns and style guidelines
- Write comprehensive tests for new functionality
- Ensure security best practices are followed
- Optimize for performance and maintainability
- Document complex logic and architectural decisions

Git discipline:
- Create feature branches for new work
- Commit frequently with descriptive messages
- Tag stable versions before major changes
- Never leave uncommitted work when switching tasks

First steps:
1. Analyze the codebase structure and technology stack
2. Review any open issues, requirements, or TODO items
3. Set up your development environment if needed
4. Begin working on the highest priority tasks
5. Schedule regular progress updates every 30 minutes

Start by understanding the project architecture and identifying your first task.""",

            "qa_engineer": f"""You are a QA Engineer responsible for quality assurance on the project at {project_path}.

Your core responsibilities:
- Design and execute comprehensive test plans
- Implement automated testing (unit, integration, e2e)
- Identify and document bugs with clear reproduction steps
- Verify fixes and validate feature implementations
- Monitor test coverage and quality metrics

Testing approach:
- Create test cases for all new features and bug fixes
- Implement automated tests where possible
- Perform exploratory testing to find edge cases
- Validate user experience and accessibility
- Monitor performance and security aspects

Quality standards:
- Maintain test coverage above 80%
- Document all test procedures and results
- Ensure all bugs are properly tracked and verified
- Validate that features meet acceptance criteria
- Report quality metrics regularly

First steps:
1. Review the project structure and existing test suite
2. Identify areas lacking test coverage
3. Set up testing environment and tools
4. Create test plans for current development work
5. Begin implementing and executing tests

Start by assessing the current testing state and identifying priority areas for improvement."""
        }
        
        base_briefing = base_briefings.get(agent_type, f"You are a {agent_type} working on the project at {project_path}.")
        
        # Add configuration-specific details
        if config:
            config_details = f"\n\nYour specific configuration:\n"
            if agent_type in config:
                agent_config = config[agent_type]
                if "personality" in agent_config:
                    config_details += f"- Personality: {agent_config['personality']}\n"
                if "quality_standards" in agent_config:
                    config_details += f"- Quality Standards: {agent_config['quality_standards']}\n"
                if "responsibilities" in agent_config:
                    config_details += f"- Key Responsibilities: {', '.join(agent_config['responsibilities'])}\n"
                    
            base_briefing += config_details
            
        return base_briefing
        
    def check_agent_health(self, agent_name: str) -> Dict[str, Any]:
        """Check the health and status of an agent"""
        
        if agent_name not in self.active_agents:
            return {"status": "not_found"}
            
        agent = self.active_agents[agent_name]
        
        # Capture recent output from the agent's window
        recent_output = self.tmux_manager.capture_pane(agent["target"])
        
        # Simple heuristics for agent health
        health_status = {
            "status": "healthy",
            "last_activity": agent["last_check"],
            "responsive": True,
            "recent_output_length": len(recent_output),
            "uptime": datetime.now() - agent["deployed_at"]
        }
        
        # Check for signs of problems
        if not recent_output or len(recent_output) < 10:
            health_status["status"] = "inactive"
            health_status["responsive"] = False
            
        if "error" in recent_output.lower() or "exception" in recent_output.lower():
            health_status["status"] = "error"
            health_status["has_errors"] = True
            
        return health_status
        
    def get_agent_status(self, agent_name: str) -> str:
        """Get a status update from an agent"""
        
        if agent_name not in self.active_agents:
            return "Agent not found"
            
        agent = self.active_agents[agent_name]
        
        # Request status update
        status_request = "STATUS UPDATE: Please provide a brief update on your current progress, what you're working on, and any blockers you're facing."
        
        if self.tmux_manager.send_message(agent["target"], status_request):
            # Wait a moment for response
            time.sleep(3)
            return self.tmux_manager.capture_pane(agent["target"])
        else:
            return "Failed to communicate with agent"

class ProjectOrchestrator:
    """Main orchestrator class that coordinates everything"""
    
    def __init__(self, config_dir: str = "config"):
        self.config_manager = ConfigManager(config_dir)
        self.tmux_manager = TmuxManager(self.config_manager)
        self.agent_manager = AgentManager(self.config_manager, self.tmux_manager)
        
    def start_project(self, project_name: str, project_path: str, team_template: Optional[str] = None) -> bool:
        """Start a new project with a complete team"""
        
        print(f"🚀 Starting project: {project_name}")
        print(f"📁 Project path: {project_path}")
        
        # Create tmux session
        session_name = f"claude-{project_name}"
        if not self.tmux_manager.create_session(session_name, project_path):
            print(f"❌ Failed to create tmux session: {session_name}")
            return False
            
        print(f"✅ Created tmux session: {session_name}")
        
        # Load team template or use default
        if team_template:
            try:
                template_config = self.config_manager.load_config("template", team_template)
                team_composition = template_config["template"]["team_composition"]
            except FileNotFoundError:
                print(f"⚠️  Template not found: {team_template}, using default team")
                team_composition = self.get_default_team()
        else:
            team_composition = self.get_default_team()
            
        # Deploy team members
        deployed_agents = []
        for i, agent_spec in enumerate(team_composition):
            agent_type = agent_spec["role"]
            agent_name = f"{project_name}-{agent_type}-{i+1}"
            
            print(f"🤖 Deploying {agent_type}...")
            
            if self.agent_manager.deploy_agent(session_name, agent_type, project_path, agent_name):
                deployed_agents.append(agent_name)
                print(f"✅ Successfully deployed {agent_type}")
            else:
                print(f"❌ Failed to deploy {agent_type}")
                
        print(f"\n🎉 Project started successfully!")
        print(f"📊 Deployed agents: {len(deployed_agents)}")
        print(f"🔗 Tmux session: {session_name}")
        print(f"\nTo monitor progress: tmux attach-session -t {session_name}")
        
        return True
        
    def get_default_team(self) -> List[Dict[str, str]]:
        """Get default team composition for a project"""
        return [
            {"role": "project_manager"},
            {"role": "developer"},
            {"role": "qa_engineer"}
        ]
        
    def status_report(self, project_name: Optional[str] = None) -> Dict[str, Any]:
        """Generate a comprehensive status report"""
        
        print("📊 Generating status report...")
        
        # List all active sessions
        sessions = self.tmux_manager.list_sessions()
        claude_sessions = [s for s in sessions if s.startswith("claude-")]
        
        report = {
            "timestamp": datetime.now().isoformat(),
            "active_sessions": len(claude_sessions),
            "sessions": claude_sessions,
            "agents": {}
        }
        
        # Check health of all active agents
        for agent_name, agent_info in self.agent_manager.active_agents.items():
            if project_name is None or agent_info["session"] == f"claude-{project_name}":
                health = self.agent_manager.check_agent_health(agent_name)
                report["agents"][agent_name] = {
                    "type": agent_info["type"],
                    "session": agent_info["session"],
                    "health": health,
                    "uptime": str(health.get("uptime", "unknown"))
                }
                
        return report
        
    def cleanup_project(self, project_name: str):
        """Clean up a project and its agents"""
        
        session_name = f"claude-{project_name}"
        
        print(f"🧹 Cleaning up project: {project_name}")
        
        # Remove agents from tracking
        agents_to_remove = []
        for agent_name, agent_info in self.agent_manager.active_agents.items():
            if agent_info["session"] == session_name:
                agents_to_remove.append(agent_name)
                
        for agent_name in agents_to_remove:
            del self.agent_manager.active_agents[agent_name]
            print(f"🗑️  Removed agent: {agent_name}")
            
        # Kill tmux session
        try:
            subprocess.run(["tmux", "kill-session", "-t", session_name], check=True)
            print(f"✅ Killed tmux session: {session_name}")
        except subprocess.CalledProcessError:
            print(f"⚠️  Session may have already been closed: {session_name}")

def main():
    """Main CLI interface"""
    
    parser = argparse.ArgumentParser(description="Claude Orchestrator - AI Team Management")
    subparsers = parser.add_subparsers(dest="command", help="Available commands")
    
    # Start project command
    start_parser = subparsers.add_parser("start", help="Start a new project")
    start_parser.add_argument("project_name", help="Name of the project")
    start_parser.add_argument("project_path", help="Path to the project directory")
    start_parser.add_argument("--template", help="Team template to use")
    
    # Status command
    status_parser = subparsers.add_parser("status", help="Get status report")
    status_parser.add_argument("--project", help="Specific project to check")
    
    # Cleanup command
    cleanup_parser = subparsers.add_parser("cleanup", help="Clean up a project")
    cleanup_parser.add_argument("project_name", help="Name of the project to clean up")
    
    # Config command
    config_parser = subparsers.add_parser("config", help="Configuration management")
    config_parser.add_argument("action", choices=["init", "validate", "show"])
    config_parser.add_argument("--type", help="Configuration type")
    config_parser.add_argument("--name", help="Configuration name")
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        return
        
    orchestrator = ProjectOrchestrator()
    
    if args.command == "start":
        orchestrator.start_project(args.project_name, args.project_path, args.template)
        
    elif args.command == "status":
        report = orchestrator.status_report(args.project)
        print(json.dumps(report, indent=2, default=str))
        
    elif args.command == "cleanup":
        orchestrator.cleanup_project(args.project_name)
        
    elif args.command == "config":
        if args.action == "init":
            print("✅ Configuration structure initialized")
        elif args.action == "validate":
            print("🔍 Configuration validation not yet implemented")
        elif args.action == "show":
            if args.type and args.name:
                try:
                    config = orchestrator.config_manager.load_config(args.type, args.name)
                    print(yaml.dump(config, default_flow_style=False, indent=2))
                except FileNotFoundError:
                    print(f"❌ Configuration not found: {args.type}/{args.name}")

if __name__ == "__main__":
    main()