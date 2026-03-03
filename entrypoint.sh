#!/bin/bash

# Xray ကို background မှာ run ထားမယ်
xray run -c /etc/xray/config.json &

# 1. Cloudflare Tunnel ရှိရင် run မယ် (Background မှာ run ရန် & ထည့်ပါ)
if [ ! -z "$TUNNEL_TOKEN" ]; then
    echo "Starting Cloudflare Tunnel..."
    cloudflared tunnel --no-autoupdate run --token $TUNNEL_TOKEN &
fi

# 2. Ngrok Tunnel ရှိရင် run မယ်
if [ ! -z "$NGROK_AUTHTOKEN" ]; then
    echo "Starting Ngrok Tunnel..."
    # npm version ngrok အတွက် ဖြစ်စေ၊ binary အတွက်ဖြစ်စေ ဤစာကြောင်းက အလုပ်လုပ်ပါသည်
    ngrok tcp 443 --authtoken $NGROK_AUTHTOKEN
else
    # ဘာ Token မှ မရှိရင် script ကို ရပ်လိုက်မယ်
    if [ -z "$TUNNEL_TOKEN" ]; then
        echo "Error: No Token provided (TUNNEL_TOKEN or NGROK_AUTHTOKEN)"
        exit 1
    fi
    # Cloudflare run နေရင်တော့ ဒီတိုင်း စောင့်နေမယ်
    wait
fi
