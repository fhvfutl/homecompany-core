# syntax=docker/dockerfile:1.6

FROM python:3.11-slim AS builder

ENV PATH="/opt/venv/bin:$PATH"
RUN python -m venv /opt/venv

COPY requirements.txt /tmp/
RUN /opt/venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt


FROM python:3.11-slim AS final

# Создаем непривилегированного пользователя
RUN groupadd -r homecompany && useradd -r -g homecompany -m -d /home/homecompany homecompany

# Копируем venv целиком — путь детерминирован
COPY --from=builder --chown=homecompany:homecompany /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /home/homecompany
COPY --chown=homecompany:homecompany . /home/homecompany

USER homecompany
CMD ["python", "src/app.py"]
