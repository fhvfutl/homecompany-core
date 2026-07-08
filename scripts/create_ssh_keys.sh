#!/bin/bash
# HomeCompany — Пошаговое создание SSH ключей для GitLab и GitHub
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

# Шаг 1: Создание SSH ключа для GitLab
step1_create_gitlab_key() {
    print_header "Шаг 1: Создание SSH ключа для GitLab"
    
    log_info "Создание ключа для GitLab..."
    log_info "Файл ключа: ~/.ssh/id_ed25519_git"
    log_info "Комментарий: aicompany@homecompany.local"
    
    if [ -f ~/.ssh/id_ed25519_git ]; then
        log_warning "Ключ для GitLab уже существует!"
        log_info "Хотите удалить и создать новый? (y/n)"
        read -r answer
        if [ "$answer" = "y" ]; then
            rm -f ~/.ssh/id_ed25519_git ~/.ssh/id_ed25519_git.pub
            log_success "Старый ключ удален"
        else
            log_info "Пропускаем создание ключа для GitLab"
            return
        fi
    fi
    
    ssh-keygen -t ed25519 -C "aicompany@homecompany.local" -f ~/.ssh/id_ed25519_git -N ""
    
    log_success "SSH ключ для GitLab создан!"
    echo ""
    echo "========================================"
    echo "Ваш публичный ключ для GitLab:"
    echo "========================================"
    cat ~/.ssh/id_ed25519_git.pub
    echo ""
    echo "========================================"
}

# Шаг 2: Создание SSH ключа для GitHub
step2_create_github_key() {
    print_header "Шаг 2: Создание SSH ключа для GitHub"
    
    log_info "Создание ключа для GitHub..."
    log_info "Файл ключа: ~/.ssh/id_ed25519_github"
    log_info "Комментарий: d.sidorenko@gmail.com"
    
    if [ -f ~/.ssh/id_ed25519_github ]; then
        log_warning "Ключ для GitHub уже существует!"
        log_info "Хотите удалить и создать новый? (y/n)"
        read -r answer
        if [ "$answer" = "y" ]; then
            rm -f ~/.ssh/id_ed25519_github ~/.ssh/id_ed25519_github.pub
            log_success "Старый ключ удален"
        else
            log_info "Пропускаем создание ключа для GitHub"
            return
        fi
    fi
    
    ssh-keygen -t ed25519 -C "d.sidorenko@gmail.com" -f ~/.ssh/id_ed25519_github -N ""
    
    log_success "SSH ключ для GitHub создан!"
    echo ""
    echo "========================================"
    echo "Ваш публичный ключ для GitHub:"
    echo "========================================"
    cat ~/.ssh/id_ed25519_github.pub
    echo ""
    echo "========================================"
}

# Шаг 3: Добавление ключей в SSH agent
step3_add_to_agent() {
    print_header "Шаг 3: Добавление ключей в SSH agent"
    
    log_info "Запуск SSH agent..."
    eval $(ssh-agent -s)
    
    log_info "Добавление ключа для GitLab..."
    ssh-add ~/.ssh/id_ed25519_git
    
    log_info "Добавление ключа для GitHub..."
    ssh-add ~/.ssh/id_ed25519_github
    
    log_success "Ключи добавлены в SSH agent!"
    echo ""
    echo "========================================"
    echo "Список добавленных ключей:"
    echo "========================================"
    ssh-add -l
    echo ""
    echo "========================================"
}

# Шаг 4: Проверка ключей
step4_check_keys() {
    print_header "Шаг 4: Проверка ключей"
    
    log_info "Проверка файлов ключей..."
    
    if [ -f ~/.ssh/id_ed25519_git ]; then
        log_success "Файл ключа для GitLab существует"
    else
        log_error "Файл ключа для GitLab не найден"
    fi
    
    if [ -f ~/.ssh/id_ed25519_git.pub ]; then
        log_success "Файл публичного ключа для GitLab существует"
    else
        log_error "Файл публичного ключа для GitLab не найден"
    fi
    
    if [ -f ~/.ssh/id_ed25519_github ]; then
        log_success "Файл ключа для GitHub существует"
    else
        log_error "Файл ключа для GitHub не найден"
    fi
    
    if [ -f ~/.ssh/id_ed25519_github.pub ]; then
        log_success "Файл публичного ключа для GitHub существует"
    else
        log_error "Файл публичного ключа для GitHub не найден"
    fi
}

# Шаг 5: Инструкции по добавлению в сервисы
step5_instructions() {
    print_header "Шаг 5: Инструкции по добавлению в сервисы"
    
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}GitLab${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "1. Зайдите в GitLab: https://gitlab.homecompany.local"
    echo "2. Перейдите в Settings → SSH Keys"
    echo "3. Нажмите 'Add new key'"
    echo "4. Вставьте ключ из шага 1 (начиная с 'ssh-ed25519')"
    echo "5. Нажмите 'Add key'"
    echo ""
    
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}GitHub${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "1. Зайдите в GitHub: https://github.com"
    echo "2. Перейдите в Settings → SSH and GPG keys"
    echo "3. Нажмите 'New SSH key'"
    echo "4. Вставьте ключ из шага 2 (начиная с 'ssh-ed25519')"
    echo "5. Нажмите 'Add SSH key'"
    echo ""
}

# Основная функция
main() {
    echo ""
    log_info "========================================"
    log_info "Создание SSH ключей для GitLab и GitHub"
    log_info "========================================"
    echo ""
    
    step1_create_gitlab_key
    step2_create_github_key
    step3_add_to_agent
    step4_check_keys
    step5_instructions
    
    log_success "Создание SSH ключей завершено!"
    echo ""
    log_info "Следующие шаги:"
    echo "1. Добавьте публичный ключ для GitLab в GitLab (Шаг 5)"
    echo "2. Добавьте публичный ключ для GitHub в GitHub (Шаг 5)"
    echo "3. После добавления ключей запустите setup_repositories.sh"
    echo ""
}

main
