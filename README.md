### Documentação: Aplicativo Flask com Redis em Docker

#### Introdução

Este documento descreve como configurar e executar um aplicativo Flask e um servidor Redis em contêineres Docker separados. Além disso, explica como enviar estas imagens para o Docker Hub, utilizando o usuário `dinoaqui`.

#### Pré-requisitos

- Docker instalado.
- Conta no Docker Hub (usuário `dinoaqui`).
- Conhecimento básico sobre Docker, Python, Flask, e Redis.

### Preparação dos Arquivos do Projeto

Os arquivos necessários para o projeto incluem:

- `requirements.txt`: Dependências do Python.
- `app.py`: Aplicativo Flask principal.
- `templates/`: Diretório para os templates HTML do Flask.
- `static/`: Diretório para arquivos estáticos (CSS, JavaScript).

### Dockerfile.app

```Dockerfile
FROM debian:bullseye-slim
WORKDIR /app
COPY requirements.txt .
COPY app.py .
COPY templates templates/
COPY static static/
RUN apt-get update && apt-get install -y python3-pip && \
    python3 -m pip install --no-cache-dir -r requirements.txt && \
    python3 -m pip install --upgrade flask werkzeug
EXPOSE 5000
ENV REDIS_HOST="redis-server"
CMD ["flask", "run", "--host=0.0.0.0"]
```

### Dockerfile.redis

```Dockerfile
FROM redis:7.2.4
EXPOSE 6379
ENTRYPOINT ["redis-server"]
```

### Construção e Execução dos Contêineres Docker

#### Construindo as Imagens Docker

```shell
docker build -t dinoaqui/linuxtips-giropops-senhas:1.0 -f Dockerfile.app .
docker build -t dinoaqui/redis-server:1.0 -f Dockerfile.redis .
```

#### Criando a Rede Docker

```shell
docker network create vnet-app
```

#### Executando os Contêineres

```shell
docker run -d --name redis-server --network vnet-app dinoaqui/redis-server:1.0
docker run -it -p 5000:5000 --network vnet-app --name app dinoaqui/linuxtips-giropops-senhas:1.0
```

### Enviando as Imagens para o Docker Hub

#### 1. Login no Docker Hub

Para enviar suas imagens, primeiro faça login no Docker Hub através do terminal:

```shell
docker login
```

Digite seu nome de usuário `dinoaqui` e senha quando solicitado.

#### 2. Fazendo Push das Imagens

Com as imagens construídas e taggeadas com o seu usuário do Docker Hub, faça o push delas para o repositório:

```shell
docker push dinoaqui/linuxtips-giropops-senhas:1.0
docker push dinoaqui/redis-server:1.0
```

### Conclusão

Esta documentação guiou você pela criação, configuração e execução de um aplicativo Flask com Redis em contêineres Docker, além de mostrar como enviar essas imagens para o Docker Hub usando o usuário `dinoaqui`. Isso facilita a distribuição, compartilhamento e implantação das suas imagens Docker em qualquer ambiente compatível.
