#!/bin/bash
# HomeCompany — Автоматическая настройка репозиториев
# Выполнять от имени пользователя aicompany

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Функция проверки SSH ключей
check_ssh_keys() {
    log_info "Проверка SSH ключей для Git..."
    
    if [ -f ~/.ssh/id_ed25519_git ]; then
        log_success "SSH ключ для Git уже существует"
        echo ""
        echo "Содержимое публичного ключа:"
        cat ~/.ssh/id_ed25519_git.pub
        echo ""
    else
        log_warning "SSH ключ для Git не найден"
        log_info "Создание нового SSH ключа..."
        
        ssh-keygen -t ed25519 -C "aicompany@homecompany.local" -f ~/.ssh/id_ed25519_git -N ""
        
        log_success "SSH ключ создан"
        echo ""
        echo "Скопируйте этот публичный ключ в GitLab:"
        cat ~/.ssh/id_ed25519_git.pub
        echo ""
        echo "После добавления ключа в GitLab выполните команду:"
        echo "eval \\$(ssh-agent -s)"
        echo "ssh-add ~/.ssh/id_ed25519_git"
    fi
}

# Функция создания локальной структуры
create_structure() {
    log_info "Создание локальной структуры репозиториев..."
    
    cd ~
    
    if [ -d "homecompany" ]; then
        log_warning "Директория homecompany уже существует"
        log_info "Переходим в homecompany..."
        cd homecompany
    else
        log_info "Создание директории homecompany..."
        mkdir -p homecompany
        cd homecompany
    fi
    
    # Создаем структуру
    mkdir -p core
    mkdir -p agents
    mkdir -p docs
    mkdir -p scripts
    mkdir -p config
    mkdir -p secrets
    mkdir -p logs
    
    log_success "Структура репозиториев создана"
}

# Функция создания .gitignore
create_gitignore() {
    log_info "Создание .gitignore..."
    
    cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
.venv

# Docker
.env
.env.local
docker-compose.override.yml

# Secrets
secrets/*.txt
secrets/*.key
secrets/*.pem

# Logs
logs/
*.log

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
EOF
    
    log_success ".gitignore создан"
}

# Функция создания README
create_readme() {
    log_info "Создание README.md..."
    
    cat > README.md << 'EOF'
# HomeCompany — Multi-Agent System

Автономная мультиагентная система для разработки SaaS ERP.

## Архитектура

### 6 Агентов:
- **Leader** — Координация и принятие решений
- **BIM** — Архитектурные решения
- **Ubuntu** — Системные задачи
- **Developers** — Разработка
- **Secretary** — Организация коммуникации
- **KB Operator** — Управление базой знаний

### Технологический стек:
- **Язык программирования**: Python 3.11+
- **Модели**: GLM-5.2, Claude Sonnet 5, GPT-5.5
- **Векторная база**: Qdrant
- **Кэш**: Redis
- **Мониторинг**: Prometheus + Grafana
- **GitLab**: Версионирование

## Установка

### 1. Клонирование репозитория
```bash
git clone git@gitlab.homecompany.local:homecompany/homecompany-core.git
cd homecompany-core
```

### 2. Настройка окружения
```bash
cp .env.example .env
nano .env
```

### 3. Запуск агентов
```bash
docker-compose up -d
```

## Документация

- [Документация агентов](docs/agents.md)
- [Инструкция по настройке](docs/setup.md)
- [Архитектура системы](docs/architecture.md)

## Лицензия

MIT
EOF
    
    log_success "README.md создан"
}

# Функция инициализации Git
init_git() {
    log_info "Инициализация Git репозитория..."
    
    git init
    
    log_success "Git репозиторий инициализирован"
}

# Функция создания структуры Python
create_python_structure() {
    log_info "Создание структуры Python модулей..."
    
    mkdir -p core/agents
    mkdir -p core/utils
    mkdir -p core/config
    
    touch core/__init__.py
    touch core/agents/__init__.py
    touch core/utils/__init__.py
    touch core/config/__init__.py
    
    log_success "Структура Python модулей создана"
}

# Функция создания первого коммита
create_first_commit() {
    log_info "Создание первого коммита..."
    
    git add .
    
    git commit -m "Initial commit: HomeCompany multi-agent system setup"
    
    log_success "Первый коммит создан"
}

# Функция проверки статуса
show_status() {
    echo ""
    log_info "========================================"
    log_info "Статус репозитория:"
    log_info "========================================"
    echo ""
    git status
    echo ""
    log_success "Настройка завершена успешно!"
}

# Основная функция
main() {
    echo ""
    log_info "========================================"
    log_info "Настройка репозиториев HomeCompany"
    log_info "========================================"
    echo ""
    
    # Проверка SSH ключей
    check_ssh_keys
    
    # Создание структуры
    create_structure
    
    # Создание .gitignore
    create_gitignore
    
    # Создание README
    create_readme
    
    # Инициализация Git
    init_git
    
    # Создание структуры Python
    create_python_structure
    
    # Создание первого коммита
    create_first_commit
    
    # Показать статус
    show_status
    
    echo ""
    log_info "Следующие шаги:"
    echo "1. Добавьте публичный SSH ключ в GitLab (если нужно)"
    echo "2. Настройте удаленный репозиторий:"
    echo "   git remote add origin git@gitlab.homecompany.local:homecompany/homecompany-core.git"
    echo "3. Проверьте статус:"
    echo "   git remote -v"
    echo ""
}

main
