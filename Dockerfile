FROM alpine:latest

# လိုအပ်တဲ့ software တွေ သွင်းမယ်
RUN apk add --no-cache xray nginx bash curl

# Website အတွက် folder ဆောက်မယ်
RUN mkdir -p /run/nginx && mkdir -p /usr/share/nginx/html

# index.html ဖိုင်ကို ဒီမှာတင် တစ်ခါတည်း ဆောက်လိုက်တာပါ
RUN echo "<html><head><title>Welcome</title></head><body style='background-color: #121212; color: white; text-align: center; padding-top: 50px;'><h1>Server Status: <span style='color: #4CAF50;'>Online</span></h1><p>VLESS WebSocket Service is running properly.</p></body></html>" > /usr/share/nginx/html/index.html

# Nginx configuration (Port 8080 ကို နားထောင်ပြီး Xray ဆီ လွှဲပေးဖို့)
RUN echo 'server { \
    listen 8080; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { \
        try_files $uri $uri/ =404; \
    } \
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

# Railway က Port 8080 ကို သုံးတာမို့ expose လုပ်ပေးမယ်
EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]
