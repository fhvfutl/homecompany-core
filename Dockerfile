# Multi-stage build for HomeCompany
FROM python:3.11-slim as builder

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y     gcc     g++     && rm -rf /var/lib/apt/lists/*

# Копируем requirements и устанавливаем
COPY requirements.txt /tmp/
RUN mkdir -p /home/homecompany/.local && pip install --no-cache-dir --user -r /tmp/requirements.txt

# Финальный образ
FROM python:3.11-slim

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y     gcc     g++     curl     && rm -rf /var/lib/apt/lists/*

# Создаем пользователя
RUN useradd -m -u 1000 homecompany &&     chown -R homecompany:homecompany /home/homecompany

USER homecompany

# Копируем установленные пакеты
COPY --from=builder --chown=homecompany:homecompany /home/homecompany/.local /home/homecompany/.local
COPY --chown=homecompany:homecompany . /home/homecompany

# Устанавливаем PATH
ENV PATH=/home/homecompany/.local/bin:$PATH

# Создаем директории
RUN mkdir -p /home/homecompany/logs /home/homecompany/data

# Устанавливаем рабочую директорию
WORKDIR /home/homecompany

# Запускаем приложение
CMD ["python", "-m", "src.main"]
