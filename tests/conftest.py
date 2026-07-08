# Pytest configuration
import pytest

@pytest.fixture
def config():
    """Fixture for configuration"""
    from src.config import Config
    return Config()

@pytest.fixture
def agent_manager():
    """Fixture for agent manager"""
    from src.agent import AgentManager
    return AgentManager()
