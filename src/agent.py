"""
Agent manager module
"""

import logging
from typing import List, Dict

logger = logging.getLogger(__name__)

class Agent:
    """Базовый класс агента"""
    
    def __init__(self, name: str):
        self.name = name
        logger.info(f"Agent '{name}' initialized")
    
    def run(self):
        """Метод запуска агента"""
        raise NotImplementedError
    
    def stop(self):
        """Метод остановки агента"""
        logger.info(f"Agent '{self.name}' stopped")

class AgentManager:
    """Менеджер агентов"""
    
    def __init__(self):
        self.agents: List[Agent] = []
        logger.info("AgentManager initialized")
    
    def add_agent(self, agent: Agent):
        """Добавить агента в менеджер"""
        self.agents.append(agent)
        logger.info(f"Agent '{agent.name}' added to manager")
    
    def run(self):
        """Запустить всех агентов"""
        logger.info("Starting all agents...")
        for agent in self.agents:
            agent.run()
        logger.info("All agents running")
    
    def stop(self):
        """Остановить всех агентов"""
        logger.info("Stopping all agents...")
        for agent in self.agents:
            agent.stop()
        logger.info("All agents stopped")
