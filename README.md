# HomeCompany

Автономная мультиагентная система для разработки SaaS ERP.

## Архитектура

### 6 Агентов:
- **Leader** — Координация и принятие решений
- **BIM** — Архитектурные решения
- **Ubuntu** — Системные задачи
- **Developers** — Разработка
- **Secretary** — Организация коммуникации
- **KB Operator** — Управление базой знаний

## Технологии

- **Python 3.11**
- **Docker** — Контейнеризация
- **Redis** — Кэширование
- **GitHub Actions** — CI/CD

## Структура проекта

\`\`\`
homecompany/
├── src/              # Исходный код
│   ├── main.py       # Точка входа
│   ├── config.py     # Конфигурация
│   └── agent.py      # Менеджер агентов
├── tests/            # Тесты
├── config/           # Конфигурационные файлы
├── data/             # Данные
├── logs/             # Логи
├── Dockerfile        # Docker образ
├── docker-compose.yml # Docker Compose
└── .github/workflows/ # GitHub Actions
\`\`\`

## Запуск

### Локально с Docker Compose

\`\`\`bash
docker-compose up -d
\`\`\`

### Локально с Python

\`\`\`bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python -m src.main
\`\`\`

## Тесты

\`\`\`bash
pytest tests/
\`\`\`

## CI/CD

- **Lint**: flake8, black, pylint
- **Test**: pytest с покрытием
- **Deploy**: Docker Buildx и push

## Лицензия

MIT
