FROM alpine:latest

# လိုအပ်သော software များ သွင်းခြင်း
RUN apk add --no-cache nginx bash curl unzip

# Xray Core ကို Direct Download ဆွဲပြီး သွင်းခြင်း
RUN curl -L -H "Cache-Control: no-cache" -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    mkdir -p /usr/local/bin /etc/xray && \
    unzip /tmp/xray.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/xray && \
    rm /tmp/xray.zip

# Cloudflare Tunnel (cloudflared) ကို သွင်းခြင်း
RUN curl -L --output /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
    chmod +x /usr/local/bin/cloudflared

# Website အတွက် folder နှင့် index.html ဆောက်ခြင်း
RUN mkdir -p /run/nginx /usr/share/nginx/html
RUN echo "<html><body style='background:#121212;color:white;text-align:center;padding-top:50px;'><h1>Server Status: <span style='color:#4CAF50;'>Online</span></h1><p>VLESS Service is running.</p></body></html>" > /usr/share/nginx/html/index.html

# Nginx configuration (Port 8080 ကို နားထောင်ရန်)
RUN echo 'server { \
    listen 8080; \
    location / { root /usr/share/nginx/html; index index.html; } \
    location /getWorkerUpdates { \
        proxy_redirect off; \
        proxy_pass http://127.0.0.1:443; \
        proxy_http_version 1.1; \
        proxy_set_header Upgrade $http_upgrade; \
        proxy_set_header Connection "upgrade"; \
        proxy_set_header Host $http_host; \
    } \
}' > /etc/nginx/http.d/default.conf

WORKDIR /etc/xray
COPY . .
RUN chmod +x entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["./entrypoint.sh"]
