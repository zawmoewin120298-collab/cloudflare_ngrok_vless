FROM alpine:latest

# လိုအပ်သော tools များသွင်းခြင်း
RUN apk add --no-cache wget unzip ca-certificates bash curl dos2unix

# 1. Xray-core သွင်းခြင်း (Stable Link)
RUN wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip && \
    mv xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm Xray-linux-64.zip

# 2. Cloudflared သွင်းခြင်း
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

# 3. Ngrok သွင်းခြင်း (ပိုမိုစိတ်ချရသော Link ကို ပြောင်းသုံးထားသည်)
RUN wget https://bin.equinox.io/c/bNy73dqVs7w/ngrok-v3-stable-linux-amd64.zip && \
    unzip ngrok-v3-stable-linux-amd64.zip && \
    mv ngrok /usr/local/bin/ngrok && \
    chmod +x /usr/local/bin/ngrok && \
    rm ngrok-v3-stable-linux-amd64.zip

WORKDIR /etc/xray
COPY . .

# ဖိုင် format များ ပြင်ဆင်ခြင်း
RUN dos2unix entrypoint.sh && chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
