FROM alpine:latest

# Install tools
RUN apk add --no-cache wget unzip ca-certificates bash curl dos2unix

# Install Xray
RUN wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip && \
    mv xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm Xray-linux-64.zip

# Install Cloudflared
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

# Install Ngrok
RUN curl -s https://bin.equinox.io/c/bNy73dqVs7w/ngrok-v3-stable-linux-amd64.tgz | tar xz -C /usr/local/bin

WORKDIR /etc/xray
COPY . .

# Line ending issue ကို ရှင်းရန်
RUN dos2unix entrypoint.sh && chmod +x entrypoint.sh

# Port 443 ကို ဖွင့်ပေးရန်
EXPOSE 443

CMD ["bash", "./entrypoint.sh"]
