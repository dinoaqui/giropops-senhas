### Documentação: Aplicativo Flask 'giropops-senhas' com Redis em Docker

#### Introdução

Este documento descreve como configurar e executar um aplicativo Flask juntamente com um servidor Redis, ambos em contêineres Docker separados. Utilizando Docker, este guia facilita o processo de empacotamento, distribuição e execução da aplicação em qualquer ambiente compatível com contêineres.

#### Pré-requisitos

- Docker instalado. Para instalação, consulte a [documentação oficial do Docker](https://docs.docker.com/get-docker/).
- Conhecimento básico sobre Docker, Python, Flask, e Redis.

### Preparação dos Arquivos do Projeto

Os arquivos necessários para o projeto incluem:

- `requirements.txt`: Lista de dependências Python para o aplicativo Flask.
- `app.py`: Arquivo principal da aplicação Flask.
- `templates/`: Diretório para os templates HTML do Flask.
- `static/`: Diretório para arquivos estáticos (CSS, JavaScript).

### Dockerfile.app

O `Dockerfile.app` é utilizado para construir a imagem Docker do aplicativo Flask:

```Dockerfile
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
```

#### Dockerfile.redis

O `Dockerfile.redis` prepara o contêiner Docker para o servidor Redis. A imagem oficial `redis:7.2.4` pode ser usada diretamente, tornando a criação de um Dockerfile específico opcional. Para documentação:

```Dockerfile
FROM redis:7.2.4
EXPOSE 6379
ENTRYPOINT ["redis-server"]
```

### Construção e Execução dos Contêineres Docker

#### Construindo as Imagens Docker

- **Aplicativo Flask**:

  ```shell
  docker build -t dinoaqui/linuxtips-giropops-senhas:1.0 -f Dockerfile.app .
  ```

- **Servidor Redis** (Se necessário):

  ```shell
  docker build -t dinoaqui/redis-server:1.0 -f Dockerfile.redis .
  ```

#### Criando a Rede Docker

```shell
docker network create vnet-app
```

#### Executando os Contêineres

- **Servidor Redis**:

  ```shell
  docker run -d --name redis-server --network vnet-app dinoaqui/redis-server:1.0
  ```

- **Aplicativo Flask**:

  ```shell
  docker run -it -p 5000:5000 --network vnet-app --name app dinoaqui/linuxtips-giropops-senhas:1.0
  ```

#### Acessando a Aplicação

O aplicativo Flask está disponível em `http://localhost:5000` após os contêineres serem iniciados.

### Conclusão

Este documento forneceu um guia detalhado para configurar e executar um aplicativo Flask com um servidor Redis em contêineres Docker, incluindo a criação dos Dockerfiles. Esta abordagem promove a eficiência no desenvolvimento, testes e implantação, assegurando a consistência entre diferentes ambientes de execução.
