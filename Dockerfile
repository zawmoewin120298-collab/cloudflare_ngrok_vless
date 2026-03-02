FROM alpine:latest

# လိုအပ်သော tools များသွင်းခြင်း
RUN apk add --no-cache wget unzip ca-certificates bash curl dos2unix

# 1. Xray-core သွင်းခြင်း
RUN wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip && \
    mv xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm Xray-linux-64.zip

# 2. Ngrok သွင်းခြင်း (Official Alpine Repo ကို သုံးခြင်း)
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apk/keys/ngrok.asc > /dev/null && \
    echo "https://ngrok-agent.s3.amazonaws.com/alpine/edge/main" | tee -a /etc/apk/repositories && \
    apk update && apk add ngrok

WORKDIR /etc/xray
COPY . .

# ဖိုင် format များ ပြင်ဆင်ခြင်း
RUN dos2unix entrypoint.sh && chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
