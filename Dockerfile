FROM alpine:latest
# Nginx နဲ့ Xray ကို သွင်းပါမယ်
RUN apk add --no-cache xray nginx bash curl
# Website အတုတစ်ခု ဆောက်ပါမယ် (ဒါမှ Railway က Healthy ဖြစ်မှာပါ)
RUN mkdir -p /run/nginx && mkdir -p /usr/share/nginx/html
RUN echo "<html><body><h1>Server is Online</h1></body></html>" > /usr/share/nginx/html/index.html
# Port 8080 ကို Xray ဆီ လွှဲပေးဖို့ Nginx config ရေးပါမယ်
RUN echo 'server { listen 8080; location / { root /usr/share/nginx/html; } location /getWorkerUpdates { proxy_pass http://127.0.0.1:443; proxy_http_version 1.1; proxy_set_header Upgrade $http_upgrade; proxy_set_header Connection "upgrade"; proxy_set_header Host $http_host; } }' > /etc/nginx/http.d/default.conf

WORKDIR /etc/xray
COPY . .
RUN chmod +x entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["./entrypoint.sh"]
