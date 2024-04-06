FROM debian:bullseye-slim

WORKDIR /app

COPY requirements.txt .
COPY app.py .
COPY templates templates/
COPY static static/

RUN apt-get update && \
    apt-get install -y python3-pip && \
    python3 -m pip install --no-cache-dir -r requirements.txt && \
    python3 -m pip install --upgrade flask werkzeug

EXPOSE 5000

ENV REDIS_HOST="redis-server"

CMD ["flask", "run", "--host=0.0.0.0"]
