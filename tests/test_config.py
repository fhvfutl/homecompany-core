"""
Config tests
"""

import pytest
from src.config import Config

def test_config_initialization():
    """Тест инициализации конфигурации"""
    config = Config()
    assert config.API_HOST == "0.0.0.0"
    assert config.API_PORT == 5000

def test_config_paths():
    """Тест путей к директориям"""
    config = Config()
    assert config.DATA_DIR.exists()
    assert config.LOGS_DIR.exists()
