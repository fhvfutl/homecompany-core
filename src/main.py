#!/usr/bin/env python3
"""
HomeCompany Main Application
"""

import logging
from src.agent import AgentManager

# Настройка логирования
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/app.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

def main():
    """Основная функция приложения"""
    logger.info("Starting HomeCompany application...")
    
    # Инициализируем менеджер агентов
    agent_manager = AgentManager()
    
    # Запускаем систему
    agent_manager.run()
    
    logger.info("HomeCompany application stopped")

if __name__ == "__main__":
    main()
