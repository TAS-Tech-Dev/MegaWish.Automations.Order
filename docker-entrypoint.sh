#!/bin/sh
set -e

# Importa workflows, ativa todos e inicia o n8n
n8n import:workflow --separate --input=/workflows || true
n8n update:workflow --all --active=true || true
exec n8n 