#!/bin/bash
# Nginx ကို အရင် run ပါ (ဒါမှ Railway က အလုပ်လုပ်တယ်လို့ သတ်မှတ်မှာပါ)
nginx
# Xray ကို run ပါ
xray run -c /etc/xray/config.json &
# Cloudflare Tunnel run ပါ
if [ ! -z "$TUNNEL_TOKEN" ]; then
    cloudflared tunnel --no-autoupdate run --token $TUNNEL_TOKEN
else
    wait
fi
