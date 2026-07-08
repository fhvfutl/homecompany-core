"""
Main module tests
"""

import pytest
from src.main import main
from src.agent import AgentManager

def test_main_import():
    """Тест импорта модуля"""
    from src import main
    assert main is not None

def test_agent_manager_import():
    """Тест импорта AgentManager"""
    from src.agent import AgentManager
    manager = AgentManager()
    assert manager is not None
