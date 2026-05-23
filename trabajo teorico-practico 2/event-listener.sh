#!/bin/bash

TOKEN="8901262056:AAFv2Y4C58U3BHP7-4CTduAnCsBeNRWO_1I"
CHAT_ID="5711714768"

echo "El servidor de eventos esta encendido y escuchando al cluster..."

kubectl get events --watch -o json | jq --unbuffered -rc '.reason, .involvedObject.kind, .message' | while read -r REASON; do
    read -r KIND
    read -r MESSAGE

    if [ "$REASON" == "Started" ] || [ "$REASON" == "ScalingReplicaSet" ] || [ "$REASON" == "Killing" ] || [ "$REASON" == "BackOff" ] || [ "$REASON" == "Unhealthy" ]; then
        if [ "$REASON" == "Killing" ] || [[ "$MESSAGE" == *"Scaled down"* ]]; then
            EMOJI="🔴 *ELIMINACIÓN / PARADA*"
        elif [ "$REASON" == "BackOff" ] || [ "$REASON" == "Unhealthy" ]; then
            EMOJI="⚠️ *ALERTA / REINICIO O FALLO*"
        else
            EMOJI="🟢 *CREACIÓN / ARRANQUE*"
        fi
        
        TEXT=" *NUEVO EVENTO EN KUBERNETES* %0A%0A⚡ *Estado:* $EMOJI%0A📢 *Acción:* $REASON%0A📦 *Componente:* $KIND%0A📝 *Detalle:* $MESSAGE"
        
        curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
            -d "chat_id=$CHAT_ID" \
            -d "text=$TEXT" \
            -d "parse_mode=Markdown" > /dev/null
    fi
done
