""\`
Pytest configuration
"""

import pytest

@pytest.fixture
def config():
    """Фикстура для конфигурации"""
    from src.config import Config
    return Config()

@pytest.fixture
def agent_manager():
    """Фикстура для менеджера агентов"""
    from src.agent import AgentManager
    return AgentManager()
