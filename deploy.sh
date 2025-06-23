#!/bin/bash

set -e

# === CONFIGURAÇÕES ===============================
DOMAIN="codesynthlab.shop"
EXPECTED_IP="69.62.96.105"  # <-- Seu IP público da VPS
CADDYFILE="./Caddyfile"
COMPOSE_FILE="docker-compose.yml"
# =================================================

echo "🚀 Iniciando processo de deploy para $DOMAIN"

# === PASSO 0: Instalando Dig ===
echo ""
echo "🔧 Instalando dependências..."
apt-get update
apt-get install -y dnsutils
echo "✅ Dependências instaladas!"

# === PASSO 1: Verificar apontamento do DNS =======
echo ""
echo "🔍 Verificando apontamento DNS do domínio..."

CURRENT_IP=$(dig +short $DOMAIN | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n 1)

echo "📡 IP apontado: $CURRENT_IP"
echo "🎯 IP esperado: $EXPECTED_IP"

if [ "$CURRENT_IP" != "$EXPECTED_IP" ]; then
    echo "❌ Domínio NÃO está apontando corretamente para sua VPS!"
    echo "🛠️  Verifique o registro tipo A no painel da sua hospedagem."
    exit 1
else
    echo "✅ Domínio está corretamente configurado! Prosseguindo..."
fi

# === PASSO 2: Verificar Caddyfile =================
echo ""
if [ ! -f "$CADDYFILE" ]; then
    echo "❌ Arquivo Caddyfile não encontrado!"
    echo "🛠️  Crie o arquivo $CADDYFILE com a configuração do domínio:"
    echo ""
    echo "$DOMAIN {
    reverse_proxy n8n:5678
}"
    exit 1
else
    echo "✅ Caddyfile encontrado!"
fi

# === PASSO 3: Subir serviços com Docker Compose ===
echo ""
echo "🐳 Subindo containers com Docker Compose..."

docker compose -f "$COMPOSE_FILE" up -d --build

echo ""
echo "✅ Todos os containers foram iniciados!"
echo "🌐 Acesse: https://$DOMAIN"
