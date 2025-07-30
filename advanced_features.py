#!/usr/bin/env python3
"""
Advanced Features for Claude Orchestrator
Implements sophisticated team management, monitoring, and automation features
"""

import json
import time
import asyncio
import sqlite3
import threading
from datetime import datetime, timedelta
from pathlib import Path
from typing import Dict, List, Optional, Any, Callable
from dataclasses import dataclass, asdict
from collections import defaultdict
import subprocess
import yaml
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

@dataclass
class AgentMetrics:
    """Metrics tracking for individual agents"""
    agent_name: str
    response_time_avg: float
    task_completion_rate: float
    error_count: int
    uptime_minutes: int
    last_activity: datetime
    quality_score: float
    communication_frequency: int

@dataclass
class ProjectHealth:
    """Overall project health indicators"""
    project_name: str
    velocity: float  # Story points per day
    bug_density: float  # Bugs per feature
    test_coverage: float
    deployment_frequency: float  # Deployments per week
    lead_time_hours: float  # Feature conception to deployment
    team_satisfaction: float
    last_updated: datetime

class AdvancedMonitoring:
    """Advanced monitoring and metrics collection system"""
    
    def __init__(self, db_path: str = "orchestrator_metrics.db"):
        self.db_path = db_path
        self.init_database()
        self.metrics_collectors: Dict[str, Callable] = {}
        self.monitoring_active = False
        
    def init_database(self):
        """Initialize SQLite database for metrics storage"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        # Agent metrics table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS agent_metrics (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                agent_name TEXT NOT NULL,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
                response_time REAL,
                task_completion_rate REAL,
                error_count INTEGER,
                uptime_minutes INTEGER,
                quality_score REAL,
                communication_frequency INTEGER
            )
        ''')
        
        # Project health table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS project_health (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                project_name TEXT NOT NULL,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
                velocity REAL,
                bug_density REAL,
                test_coverage REAL,
                deployment_frequency REAL,
                lead_time_hours REAL,
                team_satisfaction REAL
            )
        ''')
        
        # Agent interactions table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS agent_interactions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
                from_agent TEXT NOT NULL,
                to_agent TEXT NOT NULL,
                interaction_type TEXT NOT NULL,
                content TEXT,
                response_time REAL,
                success BOOLEAN
            )
        ''')
        
        conn.commit()
        conn.close()
        
    def start_monitoring(self, interval_seconds: int = 60):
        """Start continuous monitoring of agents and projects"""
        self.monitoring_active = True
        
        def monitoring_loop():
            while self.monitoring_active:
                try:
                    self.collect_all_metrics()
                    time.sleep(interval_seconds)
                except Exception as e:
                    logger.error(f"Error in monitoring loop: {e}")
                    time.sleep(interval_seconds)
                    
        monitoring_thread = threading.Thread(target=monitoring_loop, daemon=True)
        monitoring_thread.start()
        logger.info(f"Advanced monitoring started with {interval_seconds}s interval")
        
    def collect_all_metrics(self):
        """Collect metrics from all active agents and projects"""
        # This would be called periodically to gather metrics
        for collector_name, collector_func in self.metrics_collectors.items():
            try:
                collector_func()
            except Exception as e:
                logger.error(f"Error in collector {collector_name}: {e}")
                
    def record_agent_metrics(self, metrics: AgentMetrics):
        """Record agent performance metrics"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            INSERT INTO agent_metrics 
            (agent_name, response_time, task_completion_rate, error_count, 
             uptime_minutes, quality_score, communication_frequency)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', (
            metrics.agent_name, metrics.response_time_avg, metrics.task_completion_rate,
            metrics.error_count, metrics.uptime_minutes, metrics.quality_score,
            metrics.communication_frequency
        ))
        
        conn.commit()
        conn.close()
        
    def get_agent_performance_trend(self, agent_name: str, days: int = 7) -> Dict[str, Any]:
        """Get performance trend for a specific agent"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            SELECT timestamp, response_time, task_completion_rate, quality_score
            FROM agent_metrics 
            WHERE agent_name = ? AND timestamp > datetime('now', '-{} days')
            ORDER BY timestamp
        '''.format(days), (agent_name,))
        
        results = cursor.fetchall()
        conn.close()
        
        if not results:
            return {"error": "No data found for agent"}
            
        # Calculate trends
        response_times = [r[1] for r in results if r[1] is not None]
        completion_rates = [r[2] for r in results if r[2] is not None]
        quality_scores = [r[3] for r in results if r[3] is not None]
        
        return {
            "agent_name": agent_name,
            "data_points": len(results),
            "avg_response_time": sum(response_times) / len(response_times) if response_times else 0,
            "avg_completion_rate": sum(completion_rates) / len(completion_rates) if completion_rates else 0,
            "avg_quality_score": sum(quality_scores) / len(quality_scores) if quality_scores else 0,
            "trend_improving": self._calculate_trend(quality_scores),
            "last_update": results[-1][0] if results else None
        }
        
    def _calculate_trend(self, values: List[float]) -> bool:
        """Calculate if trend is improving (simple linear regression)"""
        if len(values) < 2:
            return True
            
        # Simple trend calculation: compare first half with second half
        mid_point = len(values) // 2
        first_half_avg = sum(values[:mid_point]) / mid_point
        second_half_avg = sum(values[mid_point:]) / (len(values) - mid_point)
        
        return second_half_avg > first_half_avg

class IntelligentTaskAssignment:
    """AI-powered task assignment based on agent capabilities and workload"""
    
    def __init__(self, monitoring: AdvancedMonitoring):
        self.monitoring = monitoring
        self.agent_capabilities: Dict[str, Dict[str, float]] = {}
        self.workload_tracker: Dict[str, List[Dict]] = defaultdict(list)
        
    def register_agent_capabilities(self, agent_name: str, capabilities: Dict[str, float]):
        """Register agent capabilities with skill levels (0.0 to 1.0)"""
        self.agent_capabilities[agent_name] = capabilities
        logger.info(f"Registered capabilities for {agent_name}: {capabilities}")
        
    def assign_optimal_task(self, task: Dict[str, Any], available_agents: List[str]) -> Optional[str]:
        """Assign task to the most suitable available agent"""
        if not available_agents:
            return None
            
        task_requirements = task.get("required_skills", {})
        task_priority = task.get("priority", "medium")
        task_complexity = task.get("complexity", 0.5)
        
        best_agent = None
        best_score = 0.0
        
        for agent_name in available_agents:
            if agent_name not in self.agent_capabilities:
                continue
                
            # Calculate capability match score
            capability_score = self._calculate_capability_match(
                self.agent_capabilities[agent_name], 
                task_requirements
            )
            
            # Factor in current workload
            workload_factor = self._calculate_workload_factor(agent_name)
            
            # Factor in recent performance
            performance_factor = self._calculate_performance_factor(agent_name)
            
            # Combined score
            total_score = capability_score * performance_factor * workload_factor
            
            if total_score > best_score:
                best_score = total_score
                best_agent = agent_name
                
        if best_agent:
            # Record task assignment
            self.workload_tracker[best_agent].append({
                "task_id": task.get("id"),
                "assigned_at": datetime.now(),
                "complexity": task_complexity,
                "priority": task_priority
            })
            
            logger.info(f"Assigned task {task.get('id')} to {best_agent} (score: {best_score:.2f})")
            
        return best_agent
        
    def _calculate_capability_match(self, agent_caps: Dict[str, float], task_reqs: Dict[str, float]) -> float:
        """Calculate how well agent capabilities match task requirements"""
        if not task_reqs:
            return 1.0  # No specific requirements
            
        total_match = 0.0
        total_weight = 0.0
        
        for skill, required_level in task_reqs.items():
            agent_level = agent_caps.get(skill, 0.0)
            weight = required_level  # Higher requirements are weighted more
            
            # Match score: 1.0 if agent exceeds requirement, proportional if below
            match_score = min(1.0, agent_level / required_level) if required_level > 0 else 1.0
            
            total_match += match_score * weight
            total_weight += weight
            
        return total_match / total_weight if total_weight > 0 else 0.0
        
    def _calculate_workload_factor(self, agent_name: str) -> float:
        """Calculate workload factor (lower workload = higher factor)"""
        current_tasks = self.workload_tracker[agent_name]
        
        # Remove completed tasks (assume tasks older than 24 hours are complete)
        cutoff_time = datetime.now() - timedelta(hours=24)
        active_tasks = [task for task in current_tasks if task["assigned_at"] > cutoff_time]
        
        # Update tracker
        self.workload_tracker[agent_name] = active_tasks
        
        # Calculate workload factor (inverse of current load)
        workload_score = sum(task.get("complexity", 0.5) for task in active_tasks)
        return max(0.1, 1.0 / (1.0 + workload_score))
        
    def _calculate_performance_factor(self, agent_name: str) -> float:
        """Calculate recent performance factor"""
        try:
            trend_data = self.monitoring.get_agent_performance_trend(agent_name, days=3)
            if "avg_quality_score" in trend_data:
                return max(0.1, trend_data["avg_quality_score"])
        except Exception as e:
            logger.warning(f"Could not get performance data for {agent_name}: {e}")
            
        return 0.8  # Default moderate performance factor

class AutomatedQualityGates:
    """Automated quality checking and enforcement system"""
    
    def __init__(self):
        self.quality_rules: List[Dict[str, Any]] = []
        self.quality_history: Dict[str, List[Dict]] = defaultdict(list)
        
    def add_quality_rule(self, rule: Dict[str, Any]):
        """Add a quality rule to be enforced"""
        required_fields = ["name", "check_function", "severity", "threshold"]
        if not all(field in rule for field in required_fields):
            raise ValueError(f"Quality rule must have fields: {required_fields}")
            
        self.quality_rules.append(rule)
        logger.info(f"Added quality rule: {rule['name']}")
        
    def check_quality_gates(self, project_name: str, context: Dict[str, Any]) -> Dict[str, Any]:
        """Check all quality gates for a project"""
        results = {
            "project": project_name,
            "timestamp": datetime.now(),
            "passed": True,
            "checks": [],
            "warnings": [],
            "errors": []
        }
        
        for rule in self.quality_rules:
            try:
                check_result = self._execute_quality_check(rule, context)
                results["checks"].append(check_result)
                
                if check_result["status"] == "failed":
                    results["passed"] = False
                    if check_result["severity"] == "error":
                        results["errors"].append(check_result)
                    else:
                        results["warnings"].append(check_result)
                        
            except Exception as e:
                error_result = {
                    "rule_name": rule["name"],
                    "status": "error",
                    "message": f"Quality check failed to execute: {e}",
                    "severity": "error"
                }
                results["errors"].append(error_result)
                results["passed"] = False
                
        # Record quality check results
        self.quality_history[project_name].append(results)
        
        return results
        
    def _execute_quality_check(self, rule: Dict[str, Any], context: Dict[str, Any]) -> Dict[str, Any]:
        """Execute a single quality check"""
        check_function = rule["check_function"]
        threshold = rule["threshold"]
        
        # Execute the check function
        if callable(check_function):
            actual_value = check_function(context)
        else:
            # Assume it's a key to look up in context
            actual_value = context.get(check_function, 0)
            
        # Compare against threshold
        passed = self._evaluate_threshold(actual_value, threshold, rule.get("comparison", ">="))
        
        return {
            "rule_name": rule["name"],
            "status": "passed" if passed else "failed",
            "actual_value": actual_value,
            "threshold": threshold,
            "severity": rule["severity"],
            "message": rule.get("message", f"{rule['name']}: {actual_value} vs {threshold}")
        }
        
    def _evaluate_threshold(self, actual: float, threshold: float, comparison: str) -> bool:
        """Evaluate threshold comparison"""
        if comparison == ">=":
            return actual >= threshold
        elif comparison == "<=":
            return actual <= threshold
        elif comparison == ">":
            return actual > threshold
        elif comparison == "<":
            return actual < threshold
        elif comparison == "==":
            return actual == threshold
        else:
            return True

class AgentHealthMonitor:
    """Monitor agent health and automatically handle issues"""
    
    def __init__(self, tmux_manager):
        self.tmux_manager = tmux_manager
        self.health_checks: Dict[str, Dict] = {}
        self.recovery_strategies: Dict[str, Callable] = {}
        self.monitoring_active = False
        
    def register_agent(self, agent_name: str, session_target: str, health_config: Dict[str, Any]):
        """Register an agent for health monitoring"""
        self.health_checks[agent_name] = {
            "target": session_target,
            "last_response": datetime.now(),
            "consecutive_failures": 0,
            "config": health_config
        }
        logger.info(f"Registered {agent_name} for health monitoring")
        
    def start_health_monitoring(self, check_interval: int = 300):  # 5 minutes default
        """Start continuous health monitoring"""
        self.monitoring_active = True
        
        def health_check_loop():
            while self.monitoring_active:
                try:
                    self.check_all_agents()
                    time.sleep(check_interval)
                except Exception as e:
                    logger.error(f"Error in health check loop: {e}")
                    time.sleep(check_interval)
                    
        health_thread = threading.Thread(target=health_check_loop, daemon=True)
        health_thread.start()
        logger.info(f"Health monitoring started with {check_interval}s interval")
        
    def check_all_agents(self):
        """Check health of all registered agents"""
        for agent_name, health_info in self.health_checks.items():
            try:
                is_healthy = self.check_agent_health(agent_name)
                if not is_healthy:
                    self.handle_unhealthy_agent(agent_name)
            except Exception as e:
                logger.error(f"Error checking health of {agent_name}: {e}")
                
    def check_agent_health(self, agent_name: str) -> bool:
        """Check if a specific agent is healthy"""
        if agent_name not in self.health_checks:
            return False
            
        health_info = self.health_checks[agent_name]
        target = health_info["target"]
        config = health_info["config"]
        
        # Send health check message
        health_check_msg = "Health check: Please respond with 'HEALTHY' to confirm you're operating normally."
        
        try:
            # Send health check
            if not self.tmux_manager.send_message(target, health_check_msg):
                health_info["consecutive_failures"] += 1
                return False
                
            # Wait for response
            time.sleep(5)
            
            # Capture recent output
            recent_output = self.tmux_manager.capture_pane(target)
            
            # Check for health response
            if "HEALTHY" in recent_output[-500:]:  # Check last 500 chars
                health_info["last_response"] = datetime.now()
                health_info["consecutive_failures"] = 0
                return True
            else:
                health_info["consecutive_failures"] += 1
                return False
                
        except Exception as e:
            logger.error(f"Health check failed for {agent_name}: {e}")
            health_info["consecutive_failures"] += 1
            return False
            
    def handle_unhealthy_agent(self, agent_name: str):
        """Handle an unhealthy agent"""
        health_info = self.health_checks[agent_name]
        failures = health_info["consecutive_failures"]
        config = health_info["config"]
        
        max_failures = config.get("max_failures", 3)
        
        if failures >= max_failures:
            logger.warning(f"Agent {agent_name} has failed {failures} consecutive health checks")
            
            # Try recovery strategies
            recovery_strategy = config.get("recovery_strategy", "restart")
            
            if recovery_strategy == "restart":
                self.restart_agent(agent_name)
            elif recovery_strategy == "notify_only":
                self.notify_unhealthy_agent(agent_name)
            elif recovery_strategy in self.recovery_strategies:
                self.recovery_strategies[recovery_strategy](agent_name)
                
    def restart_agent(self, agent_name: str):
        """Restart an unhealthy agent"""
        logger.info(f"Attempting to restart unhealthy agent: {agent_name}")
        
        health_info = self.health_checks[agent_name]
        target = health_info["target"]
        
        try:
            # Kill existing Claude process
            subprocess.run(["tmux", "send-keys", "-t", target, "C-c"], check=True)
            time.sleep(2)
            
            # Restart Claude
            subprocess.run(["tmux", "send-keys", "-t", target, "claude --dangerously-skip-permissions", "Enter"], check=True)
            time.sleep(5)
            
            # Send reinitialization message
            reinit_msg = f"You are being restarted due to health check failure. Please resume your role as {agent_name} and continue your assigned tasks."
            self.tmux_manager.send_message(target, reinit_msg)
            
            # Reset failure count
            health_info["consecutive_failures"] = 0
            health_info["last_response"] = datetime.now()
            
            logger.info(f"Successfully restarted agent: {agent_name}")
            
        except Exception as e:
            logger.error(f"Failed to restart agent {agent_name}: {e}")
            
    def notify_unhealthy_agent(self, agent_name: str):
        """Notify about unhealthy agent without taking action"""
        logger.warning(f"Agent {agent_name} is unhealthy but configured for notification only")
        # Here you could integrate with external notification systems

class AdvancedOrchestrator:
    """Enhanced orchestrator with advanced features"""
    
    def __init__(self, config_dir: str = "config"):
        # Import base orchestrator functionality
        from orchestrator import ProjectOrchestrator
        self.base_orchestrator = ProjectOrchestrator(config_dir)
        
        # Advanced feature components
        self.monitoring = AdvancedMonitoring()
        self.task_assignment = IntelligentTaskAssignment(self.monitoring)
        self.quality_gates = AutomatedQualityGates()
        self.health_monitor = AgentHealthMonitor(self.base_orchestrator.tmux_manager)
        
        # Initialize advanced features
        self.setup_default_quality_rules()
        self.setup_default_capabilities()
        
    def setup_default_quality_rules(self):
        """Setup default quality rules"""
        
        # Test coverage rule
        self.quality_gates.add_quality_rule({
            "name": "Test Coverage",
            "check_function": "test_coverage",
            "threshold": 85.0,
            "comparison": ">=",
            "severity": "warning",
            "message": "Test coverage below minimum threshold"
        })
        
        # Performance rule
        self.quality_gates.add_quality_rule({
            "name": "API Response Time",
            "check_function": "avg_response_time",
            "threshold": 200.0,
            "comparison": "<=",
            "severity": "error",
            "message": "API response time exceeds acceptable limit"
        })
        
        # Security rule
        self.quality_gates.add_quality_rule({
            "name": "Security Vulnerabilities",
            "check_function": "security_vulnerabilities",
            "threshold": 0,
            "comparison": "==",
            "severity": "error",
            "message": "Security vulnerabilities detected"
        })
        
    def setup_default_capabilities(self):
        """Setup default agent capabilities"""
        
        # Example capability profiles
        default_capabilities = {
            "project_manager": {
                "project_coordination": 0.9,
                "quality_assurance": 0.8,
                "communication": 0.9,
                "risk_management": 0.7,
                "planning": 0.8
            },
            "full_stack_developer": {
                "frontend_development": 0.8,
                "backend_development": 0.8,
                "database_design": 0.7,
                "testing": 0.6,
                "performance_optimization": 0.7
            },
            "qa_engineer": {
                "test_automation": 0.9,
                "manual_testing": 0.8,
                "performance_testing": 0.7,
                "security_testing": 0.6,
                "user_acceptance_testing": 0.8
            }
        }
        
        for role, capabilities in default_capabilities.items():
            # This would be called when agents are actually deployed
            logger.info(f"Default capabilities defined for {role}")
            
    def start_advanced_project(self, project_name: str, project_path: str, 
                             advanced_config: Optional[Dict[str, Any]] = None) -> bool:
        """Start a project with advanced features enabled"""
        
        # Start base project
        success = self.base_orchestrator.start_project(project_name, project_path)
        
        if success and advanced_config:
            # Enable advanced features
            if advanced_config.get("enable_monitoring", True):
                self.monitoring.start_monitoring(
                    interval_seconds=advanced_config.get("monitoring_interval", 60)
                )
                
            if advanced_config.get("enable_health_monitoring", True):
                self.health_monitor.start_health_monitoring(
                    check_interval=advanced_config.get("health_check_interval", 300)
                )
                
            # Register agents for advanced features
            session_name = f"claude-{project_name}"
            for agent_name, agent_info in self.base_orchestrator.agent_manager.active_agents.items():
                if agent_info["session"] == session_name:
                    # Register for health monitoring
                    self.health_monitor.register_agent(
                        agent_name, 
                        agent_info["target"],
                        advanced_config.get("health_config", {})
                    )
                    
                    # Register capabilities for task assignment
                    agent_type = agent_info["type"]
                    if agent_type in self.get_default_capabilities():
                        self.task_assignment.register_agent_capabilities(
                            agent_name,
                            self.get_default_capabilities()[agent_type]
                        )
                        
            logger.info(f"Advanced features enabled for project: {project_name}")
            
        return success
        
    def get_default_capabilities(self) -> Dict[str, Dict[str, float]]:
        """Get default capability profiles"""
        return {
            "project_manager": {
                "project_coordination": 0.9,
                "quality_assurance": 0.8,
                "communication": 0.9,
                "risk_management": 0.7,
                "planning": 0.8
            },
            "full_stack_developer": {
                "frontend_development": 0.8,
                "backend_development": 0.8,
                "database_design": 0.7,
                "testing": 0.6,
                "performance_optimization": 0.7
            },
            "qa_engineer": {
                "test_automation": 0.9,
                "manual_testing": 0.8,
                "performance_testing": 0.7,
                "security_testing": 0.6,
                "user_acceptance_testing": 0.8
            }
        }
        
    def generate_intelligence_report(self, project_name: str) -> Dict[str, Any]:
        """Generate comprehensive intelligence report for a project"""
        
        report = {
            "project_name": project_name,
            "timestamp": datetime.now(),
            "agent_performance": {},
            "quality_status": {},
            "recommendations": [],
            "alerts": []
        }
        
        # Collect agent performance data
        session_name = f"claude-{project_name}"
        for agent_name, agent_info in self.base_orchestrator.agent_manager.active_agents.items():
            if agent_info["session"] == session_name:
                trend_data = self.monitoring.get_agent_performance_trend(agent_name)
                report["agent_performance"][agent_name] = trend_data
                
        # Check quality gates
        # This would need actual project metrics as context
        quality_context = {
            "test_coverage": 88.5,  # Example values
            "avg_response_time": 150.0,
            "security_vulnerabilities": 0
        }
        
        quality_results = self.quality_gates.check_quality_gates(project_name, quality_context)
        report["quality_status"] = quality_results
        
        # Generate recommendations based on data
        recommendations = self.generate_recommendations(report)
        report["recommendations"] = recommendations
        
        return report
        
    def generate_recommendations(self, report_data: Dict[str, Any]) -> List[str]:
        """Generate intelligent recommendations based on project data"""
        recommendations = []
        
        # Analyze agent performance
        for agent_name, performance in report_data["agent_performance"].items():
            if isinstance(performance, dict) and "avg_quality_score" in performance:
                if performance["avg_quality_score"] < 0.7:
                    recommendations.append(
                        f"Consider additional training or support for {agent_name} - quality score below threshold"
                    )
                    
        # Analyze quality status
        quality_status = report_data.get("quality_status", {})
        if not quality_status.get("passed", True):
            for error in quality_status.get("errors", []):
                recommendations.append(f"Address quality issue: {error['message']}")
                
        # Add general recommendations if no specific issues
        if not recommendations:
            recommendations.append("Project health looks good - continue current practices")
            
        return recommendations

def main():
    """Example usage of advanced features"""
    
    # Initialize advanced orchestrator
    advanced_orch = AdvancedOrchestrator()
    
    # Example: Start project with advanced features
    project_config = {
        "enable_monitoring": True,
        "enable_health_monitoring": True,
        "monitoring_interval": 30,  # 30 seconds for demo
        "health_check_interval": 120,  # 2 minutes for demo
        "health_config": {
            "max_failures": 2,
            "recovery_strategy": "restart"
        }
    }
    
    success = advanced_orch.start_advanced_project(
        "advanced-demo",
        "/tmp/advanced-demo-project",
        project_config
    )
    
    if success:
        print("Advanced project started successfully!")
        
        # Wait a bit then generate intelligence report
        time.sleep(10)
        
        report = advanced_orch.generate_intelligence_report("advanced-demo")
        print("\nIntelligence Report:")
        print(json.dumps(report, indent=2, default=str))
    else:
        print("Failed to start advanced project")

if __name__ == "__main__":
    main()