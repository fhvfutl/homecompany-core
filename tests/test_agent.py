"""
Agent tests
"""

import pytest
from src.agent import Agent, AgentManager

def test_agent_initialization():
    """Тест инициализации агента"""
    agent = Agent("TestAgent")
    assert agent.name == "TestAgent"

def test_agent_manager():
    """Тест менеджера агентов"""
    manager = AgentManager()
    assert len(manager.agents) == 0
    
    agent = Agent("TestAgent")
    manager.add_agent(agent)
    assert len(manager.agents) == 1

def test_agent_manager_run():
    """Тест запуска менеджера агентов"""
    manager = AgentManager()
    agent = Agent("TestAgent")
    manager.add_agent(agent)
    
    # Проверяем, что агент не вызывает ошибку
    manager.run()
    manager.stop()
    assert True
