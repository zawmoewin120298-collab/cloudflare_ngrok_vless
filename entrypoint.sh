#!/bin/bash

# Xray ကို background မှာ run ထားမယ်
xray run -c /etc/xray/config.json &

# Cloudflare Tunnel ကို foreground မှာ run မယ် (ဒါမှ Railway က app သေမသွားမှာပါ)
if [ ! -z "$TUNNEL_TOKEN" ]; then
    echo "Starting Cloudflare Tunnel..."
    cloudflared tunnel --no-autoupdate run --token $TUNNEL_TOKEN
else
    echo "No TUNNEL_TOKEN provided. If you want to use Ngrok, please verify your card first."
    # အကယ်၍ cloudflare မသုံးရင်လည်း xray ကို ဆက် run ထားဖို့ wait သုံးမယ်
    wait
fi
