FROM alpine:latest

# လိုအပ်တာတွေ အကုန်သွင်းမယ်
RUN apk add --no-cache wget unzip ca-certificates bash curl

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
# လက်ရှိ folder ထဲက ဖိုင်အားလုံး (config.json, entrypoint.sh) ကို ကူးမယ်
COPY . .

# အရေးကြီးသည်- entrypoint.sh ကို execute လုပ်ခွင့်ပေးရန်
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
