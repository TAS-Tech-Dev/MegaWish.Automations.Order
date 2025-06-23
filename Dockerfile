FROM n8nio/n8n:1.93.0

USER root

# Cria diretório temporário para templates (opcional, organização)
RUN mkdir -p /home/node/templates

# Copia os workflows para dentro da imagem
COPY ./templates /home/node/templates

# Copia o entrypoint customizado
COPY docker-entrypoint.sh /home/node/docker-entrypoint.sh

# Ajusta permissões para o usuário correto
RUN chown -R node:node /home/node/docker-entrypoint.sh /home/node/templates \
    && chmod +x /home/node/docker-entrypoint.sh

USER node

# Usa nosso script como ponto de entrada
ENTRYPOINT ["/home/node/docker-entrypoint.sh"]
