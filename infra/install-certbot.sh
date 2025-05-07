#!/bin/bash
set -e

DOMINIO=$1

if [ -z "$DOMINIO" ]; then
  echo "Uso: ./install-certbot.sh seu-dominio.com"
  exit 1
fi

echo "==> Parando temporariamente o proxy reverso na porta 80"
docker stop nginx-proxy || true

echo "==> Solicitando certificado Let's Encrypt para $DOMINIO"
certbot certonly --standalone -d $DOMINIO

echo "==> Certificado gerado com sucesso!"
