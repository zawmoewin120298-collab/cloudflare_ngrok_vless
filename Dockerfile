FROM alpine:latest

# လိုအပ်တဲ့ Tools များသွင်းခြင်း
RUN apk add --no-cache wget unzip ca-certificates bash curl dos2unix

# Xray Install
RUN wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip && \
    mv xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm Xray-linux-64.zip

# Cloudflared Install
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

# Ngrok Install
RUN curl -s https://bin.equinox.io/c/bNy73dqVs7w/ngrok-v3-stable-linux-amd64.tgz | tar xz -C /usr/local/bin

WORKDIR /etc/xray
COPY . .

# Windows line endings ကို Linux format သို့ ပြောင်းခြင်းနှင့် permission ပေးခြင်း
RUN dos2unix entrypoint.sh && chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
