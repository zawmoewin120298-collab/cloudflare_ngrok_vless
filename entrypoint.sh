#!/bin/bash

# Nginx ကို background မှာ run ပါ
nginx

# Xray ကို background မှာ run ပါ
# /usr/local/bin/xray လို့ လမ်းကြောင်းအပြည့်အစုံ သုံးတာ ပိုစိတ်ချရပါတယ်
/usr/local/bin/xray run -c /etc/xray/config.json &

# Cloudflare Tunnel ရှိရင် run မယ်၊ မရှိရင် Xray ကို ရှေ့ထုတ်ပြီး စောင့်မယ်
if [ ! -z "$TUNNEL_TOKEN" ]; then
    echo "Starting Cloudflare Tunnel..."
    /usr/local/bin/cloudflared tunnel --no-autoupdate run --token $TUNNEL_TOKEN
else
    echo "No Tunnel Token found, running in direct mode..."
    # Xray process ကို foreground ပြန်ခေါ်ပြီး စောင့်ခိုင်းတာပါ
    wait -n
fi
