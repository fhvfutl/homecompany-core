# Config tests

import pytest
from src.config import Config, config

def test_config_init():
    """Тест инициализации конфигурации"""
    assert config is not None
    assert config.LOG_LEVEL == "INFO"
    assert config.API_HOST == "0.0.0.0"
    assert config.API_PORT == 5000
    assert config.REDIS_HOST == "localhost"
    assert config.REDIS_PORT == 6379
    assert config.REDIS_DB == 0

def test_config_paths():
    """Тест путей к директориям"""
    assert config.DATA_DIR.exists()
    assert config.LOGS_DIR.exists()
    assert config.CONFIG_DIR.exists()
    assert config.LOG_FILE.exists()
