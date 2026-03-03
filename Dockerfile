FROM alpine:latest

# လိုအပ်သော tools များသွင်းခြင်း (Nodejs ပါဝင်သည်)
RUN apk add --no-cache wget unzip ca-certificates bash curl dos2unix nodejs npm

# 1. Xray-core သွင်းခြင်း
RUN wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip && \
    mv xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm Xray-linux-64.zip

# 2. Cloudflared သွင်းခြင်း
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

# 3. Ngrok သွင်းခြင်း (Link မသုံးဘဲ npm မှတစ်ဆင့် သွင်းသည် - ဤနည်းလမ်းသည် 404 error ကိုကျော်လွှားနိုင်သည်)
RUN npm install -g ngrok

WORKDIR /etc/xray
COPY . .

# ဖိုင် format ပြင်ဆင်ခြင်း
RUN dos2unix entrypoint.sh && chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
