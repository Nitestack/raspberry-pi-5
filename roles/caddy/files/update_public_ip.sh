NEW_PUBLIC_IP=$(curl -s https://api.ipify.org)
ENV_FILE="/etc/caddy/env"

if [ -f $ENV_FILE ]; then
  PUBLIC_IP=$(grep -oP '(?<=^PUBLIC_IP=).*' $ENV_FILE)
fi

if [ "$PUBLIC_IP" != "$NEW_PUBLIC_IP" ]; then
  echo "PUBLIC_IP=$NEW_PUBLIC_IP" >$ENV_FILE
  systemctl restart caddy
fi
