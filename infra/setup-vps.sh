#!/bin/bash
set -e

echo "==> Atualizando pacotes base"
apt-get update && apt-get upgrade -y

echo "==> Instalando dependências para o repositório Docker"
apt-get install -y ca-certificates curl gnupg lsb-release

echo "==> Adicionando chave GPG oficial do Docker"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "==> Adicionando repositório do Docker ao APT"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update

echo "==> Instalando Docker Engine e ferramentas"
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "==> Testando Docker com 'hello-world'"
docker run hello-world

echo "==> Habilitando Docker no boot"
systemctl enable docker

echo "==> Instalando Certbot (modo standalone)"
apt-get install -y certbot

echo "==> Testando Certbot com --version"
certbot --version

echo "==> Criando rede Docker externa chamada 'nginx-network'"
docker network create nginx-network || true

echo "==> VPS provisionada com sucesso!"
