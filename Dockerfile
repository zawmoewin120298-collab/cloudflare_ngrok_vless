FROM alpine:latest
# Nginx ပါ တစ်ခါတည်း သွင်းပါမည်
RUN apk add --no-cache xray nginx bash curl
# Website အတုတစ်ခု ဆောက်ပါမည်
RUN mkdir -p /run/nginx && mkdir -p /usr/share/nginx/html
RUN echo "<html><body><h1>Server is Online</h1></body></html>" > /usr/share/nginx/html/index.html
# Nginx settings (Port 80 ကို ဖွင့်ရန်)
RUN echo 'server { listen 80; location / { root /usr/share/nginx/html; } location /zawmoewin { proxy_pass http://127.0.0.1:10000; proxy_http_version 1.1; proxy_set_header Upgrade $http_upgrade; proxy_set_header Connection "upgrade"; proxy_set_header Host $http_host; } }' > /etc/nginx/http.d/default.conf

WORKDIR /etc/xray
COPY . .
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
