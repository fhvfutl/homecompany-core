# Agent tests

import pytest
from src.agent import Agent, AgentManager

def test_agent_init():
    """Тест инициализации агента"""
    agent = Agent("TestAgent")
    assert agent.name == "TestAgent"
    assert agent.running is False

def test_agent_run():
    """Тест запуска агента"""
    agent = Agent("TestAgent")
    agent.run()
    assert agent.running is True

def test_agent_stop():
    """Тест остановки агента"""
    agent = Agent("TestAgent")
    agent.run()
    agent.stop()
    assert agent.running is False

def test_agent_manager_init():
    """Тест инициализации менеджера агентов"""
    manager = AgentManager()
    assert len(manager.agents) == 0

def test_agent_manager_add_agent():
    """Тест добавления агента в менеджер"""
    manager = AgentManager()
    agent = Agent("TestAgent")
    manager.add_agent(agent)
    assert len(manager.agents) == 1
    assert manager.agents[0] == agent

def test_agent_manager_run():
    """Тест запуска менеджера агентов"""
    manager = AgentManager()
    agent1 = Agent("Agent1")
    agent2 = Agent("Agent2")
    manager.add_agent(agent1)
    manager.add_agent(agent2)
    manager.run()
    assert agent1.running is True
    assert agent2.running is True
