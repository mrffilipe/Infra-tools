#!/bin/bash
echo "==> Verificando se container nginx-proxy está ativo..."
if docker ps | grep -q nginx-proxy; then
  echo "==> Reiniciando container nginx-proxy após renovação SSL"
  docker restart nginx-proxy
else
  echo "==> nginx-proxy não está ativo. Nenhuma ação tomada."
fi
