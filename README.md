# Infra-tools

Este repositório contém um conjunto de scripts shell e arquivos de configuração voltados para provisionamento e manutenção de uma VPS Linux com foco em aplicações Docker e certificados SSL automatizados via Let's Encrypt.

Ele segue uma abordagem modular e moderna, separando a responsabilidade de **provisionamento** da de **execução de serviços**, com **boas práticas DevOps**.

---

## Estrutura do Projeto

```text
infra-tools/
├── infra/
│   ├── setup-vps.sh                 # Instala Docker, Docker Compose e Certbot
│   ├── install-certbot.sh           # Gera certificados SSL com Let's Encrypt
│   └── nginx-restart-hook.sh        # Reinicia Nginx após renovação do cert
│
├── proxy/
│   ├── docker-compose.yml           # Executa o proxy reverso com Nginx
│   └── nginx.conf                   # Configuração com paths e SSL
````

---

## Pré-requisitos

* VPS Linux (Ubuntu 22.04 recomendado)
* Um domínio válido e apontado para o IP da VPS
* Permissões de `sudo` para instalação de pacotes e uso do Docker
* A porta **80 e 443 liberadas** no firewall da VPS

---

## Fluxo de Uso

### 1. Provisionar a VPS (instalar Docker, Docker Compose e Certbot)

```bash
bash infra/setup-vps.sh
```

---

### 2. Gerar o certificado SSL com Let's Encrypt

```bash
bash infra/install-certbot.sh seu-dominio.com
```

> Obs: Isso para temporariamente o container `nginx-proxy` caso esteja rodando, usa Certbot em modo standalone e gera os certificados para `/etc/letsencrypt/live/seu-dominio.com/`.

---

### 3. Configurar o agendamento de renovação automática

Abra o crontab do root:

```bash
sudo crontab -e
```

Adicione a seguinte linha:

```bash
0 3 * * * certbot renew --deploy-hook "/caminho/infra/nginx-restart-hook.sh"
```

> Essa linha verifica diariamente a validade do certificado e reinicia o container do Nginx caso a renovação aconteça.

---

### 4. Subir o container Nginx com proxy reverso e SSL

```bash
cd proxy
docker compose up -d
```

O Nginx usará os certificados reais montados via volume e fará o proxy para seus serviços internos:

* `/` → frontend:3000
* `/keycloak` → keycloak:8080
* `/backend` → backend:5000

---

## Boas práticas utilizadas

* **Separação de responsabilidades**: provisioning vs execução
* **Automação da renovação SSL** com reinício controlado
* **Uso de redes Docker externas** para compor múltiplos projetos
* **Volume readonly** para acesso seguro aos certificados pelo container
* **Scripts reutilizáveis e documentados**

---

## Possíveis melhorias futuras

* Adicionar suporte a subdomínios (wildcard ou SAN)
* Modularizar `nginx.conf` para múltiplos projetos
* Scripts com suporte a múltiplos ambientes (produção, staging)
* Adicionar setup para watcher de logs, monitoramento ou backups

---

## Licença

Este projeto é open-source, sob a licença MIT. Fique à vontade para usar, adaptar e contribuir.
