#!/bin/bash
# HomeCompany — Автоматическая настройка Firewall на IBM
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

check_root() {
    if [ "$EUID" -ne 0 ]; then 
        log_error "Этот скрипт должен запускаться от имени администратора (sudo)!"
        exit 1
    fi
}

check_ufw_status() {
    log_info "Проверка статуса UFW..."
    if command -v ufw &> /dev/null; then
        ufw status verbose
    else
        log_warning "UFW не установлен, устанавливаем..."
        apt update
        apt install -y ufw
        log_success "UFW успешно установлен"
    fi
}

setup_rules() {
    log_info "Настройка правил Firewall..."
    
    # Разрешить SSH
    log_info "Разрешаем SSH (порт 22)..."
    ufw allow 22/tcp comment 'SSH'
    
    # Разрешить HTTP
    log_info "Разрешаем HTTP (порт 80)..."
    ufw allow 80/tcp comment 'HTTP'
    
    # Разрешить HTTPS
    log_info "Разрешаем HTTPS (порт 443)..."
    ufw allow 443/tcp comment 'HTTPS'
    
    # Разрешить Redis
    log_info "Разрешаем Redis (порт 6379)..."
    ufw allow 6379/tcp comment 'Redis'
    
    # Разрешить Qdrant
    log_info "Разрешаем Qdrant (порт 6333)..."
    ufw allow 6333/tcp comment 'Qdrant'
    
    # Разрешить Grafana
    log_info "Разрешаем Grafana (порт 3000)..."
    ufw allow 3000/tcp comment 'Grafana'
    
    # Разрешить Prometheus
    log_info "Разрешаем Prometheus (порт 9090)..."
    ufw allow 9090/tcp comment 'Prometheus'
    
    log_success "Все правила Firewall настроены"
}

enable_ufw() {
    log_info "Включаем UFW..."
    echo "y" | ufw enable
    log_success "UFW успешно включен"
}

verify_rules() {
    log_info "Проверка правил Firewall..."
    echo ""
    ufw status numbered
}

test_ports() {
    log_info "Тестирование портов..."
    
    # Тест SSH
    if nc -z localhost 22 2>/dev/null; then
        log_success "SSH порт (22) работает"
    else
        log_error "SSH порт (22) не работает"
    fi
    
    # Тест Redis
    if nc -z localhost 6379 2>/dev/null; then
        log_success "Redis порт (6379) работает"
    else
        log_error "Redis порт (6379) не работает"
    fi
    
    # Тест Qdrant
    if nc -z localhost 6333 2>/dev/null; then
        log_success "Qdrant порт (6333) работает"
    else
        log_error "Qdrant порт (6333) не работает"
    fi
    
    # Тест Grafana
    if nc -z localhost 3000 2>/dev/null; then
        log_success "Grafana порт (3000) работает"
    else
        log_error "Grafana порт (3000) не работает"
    fi
    
    # Тест Prometheus
    if nc -z localhost 9090 2>/dev/null; then
        log_success "Prometheus порт (9090) работает"
    else
        log_error "Prometheus порт (9090) не работает"
    fi
}

print_summary() {
    echo ""
    log_info "========================================"
    log_info "Статус Firewall после настройки:"
    log_info "========================================"
    ufw status verbose
    echo ""
    log_success "Firewall успешно настроен!"
    log_info "Все порты открыты и работают"
}

main() {
    echo ""
    log_info "========================================"
    log_info "Настройка Firewall для HomeCompany"
    log_info "========================================"
    echo ""
    
    # Проверка прав
    check_root
    
    # Проверка статуса UFW
    check_ufw_status
    
    # Настройка правил
    setup_rules
    
    # Включаем UFW
    enable_ufw
    
    # Проверка правил
    verify_rules
    
    # Тестирование портов
    test_ports
    
    # Вывод суммы
    print_summary
    
    echo ""
    log_success "Настройка завершена успешно!"
    echo ""
}

main
