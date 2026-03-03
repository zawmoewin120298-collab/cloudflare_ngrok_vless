FROM alpine:latest

# လိုအပ်သော packages များသွင်းခြင်း
RUN apk add --no-cache xray nginx bash curl

# Nginx configuration (Port 80 မှာ website ပြရန်)
RUN mkdir -p /run/nginx
COPY nginx.conf /etc/nginx/http.d/default.conf

# index.html (Website အတု) ထည့်ရန်
RUN mkdir -p /usr/share/nginx/html
echo "<html><body><h1>Server is Running</h1></body></html>" > /usr/share/nginx/html/index.html

# Xray configuration ကူးယူခြင်း
WORKDIR /etc/xray
COPY . .

RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
