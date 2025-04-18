# filepath: /home/zeenyt/Projetos/exam/dockerfile
FROM alpine:latest

# Instalar dependências necessárias
RUN apk update && apk add --no-cache \
    build-base \
    gdb \
    valgrind \
    cmake \
    git \
    boost-dev \
    gtest-dev \
    zsh \
    readline-dev \
    clang \
    bash \
    curl \
	libc-dev \
    libstdc++ \
    diffutils \
	gcc \
	musl-dev \
	procps \
	coreutils \
	iputils \
    && rm -rf /var/cache/apk/*

# Clonar o repositório
RUN git clone https://github.com/phm-aguiar/exam_alpine.git app


# Definir o diretório de trabalho
WORKDIR /app

# Comando padrão
CMD ["tail", "-f", "/dev/null"]