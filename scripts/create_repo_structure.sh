#!/bin/bash
# HomeCompany — Создание локальной структуры репозитория
# Выполнять от имени пользователя aicompany

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

# Создание локальной структуры
create_structure() {
    print_header "Создание локальной структуры репозитория"
    
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

# Создание .gitignore
create_gitignore() {
    print_header "Создание .gitignore"
    
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

# Создание README
create_readme() {
    print_header "Создание README.md"
    
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

## Лицензия

MIT
EOF
    
    log_success "README.md создан"
}

# Создание структуры Python
create_python_structure() {
    print_header "Создание структуры Python модулей"
    
    mkdir -p core/agents
    mkdir -p core/utils
    mkdir -p core/config
    
    touch core/__init__.py
    touch core/agents/__init__.py
    touch core/utils/__init__.py
    touch core/config/__init__.py
    
    log_success "Структура Python модулей создана"
}

# Инициализация Git
init_git() {
    print_header "Инициализация Git"
    
    git init
    
    log_success "Git репозиторий инициализирован"
}

# Создание первого коммита
create_first_commit() {
    print_header "Создание первого коммита"
    
    git add .
    
    git commit -m "Initial commit: HomeCompany multi-agent system setup"
    
    log_success "Первый коммит создан"
}

# Настройка удаленного репозитория
setup_remote() {
    print_header "Настройка удаленного репозитория"
    
    log_info "Добавление удаленного репозитория..."
    git remote add origin git@gitlab.com:sidorenko039/homecompany-core.git
    
    log_success "Удаленный репозиторий настроен"
}

# Показать статус
show_status() {
    echo ""
    print_header "Статус репозитория"
    
    echo "Структура директорий:"
    tree -L 2 -d || find . -type d -maxdepth 2 | sort
    
    echo ""
    echo "Статус Git:"
    git status
    
    echo ""
    log_success "Настройка завершена успешно!"
}

# Основная функция
main() {
    echo ""
    log_info "========================================"
    log_info "Создание локальной структуры репозитория"
    log_info "========================================"
    echo ""
    
    create_structure
    create_gitignore
    create_readme
    create_python_structure
    init_git
    create_first_commit
    setup_remote
    show_status
    
    echo ""
    log_info "Следующие шаги:"
    echo "1. Проверьте статус: git status"
    echo "2. Запушьте в удаленный репозиторий:"
    echo "   git push -u origin main"
    echo "   или"
    echo "   git push -u origin master"
    echo ""
}

main
