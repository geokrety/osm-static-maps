FROM node:16-buster

RUN \
    apt-get update \
    && \
    apt-get install -y \
        chromium \
        libx11-xcb1 \
        libxtst6 \
        libnss3 \
        libxss1 \
        libasound2 \
        libatk-bridge2.0-0 \
        libgtk-3-0 \
        fonts-wqy-zenhei \
    && \
    rm -rf /var/lib/apt/lists/*

RUN \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && \
    /root/.cargo/bin/cargo install --root /usr/local oxipng

USER node
WORKDIR /app
EXPOSE 3000

COPY --chown=node:node . /app
RUN npm install

CMD [ "npm", "run", "start" ]

HEALTHCHECK CMD curl -f http://localhost:3000/health || exit 1
