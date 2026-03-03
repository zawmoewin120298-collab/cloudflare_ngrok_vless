#!/bin/bash

# ၁။ Nginx (Web Server) ကို background မှာ စတင် run မယ်
# ဒါမှ Railway က port 80 ကို အလုပ်လုပ်နေတယ်လို့ သတ်မှတ်မှာပါ
echo "Starting Nginx Web Server..."
nginx

# ၂။ Xray Core ကို background မှာ run မယ်
echo "Starting Xray Core..."
xray run -c /etc/xray/config.json &

# ၃။ Cloudflare Tunnel ကို စစ်ဆေးပြီး run မယ်
if [ ! -z "$TUNNEL_TOKEN" ]; then
    echo "Starting Cloudflare Tunnel..."
    # Tunnel ကို foreground မှာ run ထားခြင်းဖြင့် Railway app မပိတ်သွားအောင် ထိန်းထားမယ်
    cloudflared tunnel --no-autoupdate run --token $TUNNEL_TOKEN
else
    echo "No TUNNEL_TOKEN provided."
    echo "Using Direct Port or waiting for background processes..."
    # အကယ်၍ Tunnel မရှိရင် background က xray/nginx သေမသွားအောင် wait နဲ့ ဆွဲထားမယ်
    wait
fi
