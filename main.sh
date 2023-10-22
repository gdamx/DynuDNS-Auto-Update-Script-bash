#!/bin/bash

echo "Updating DNS Record... Please Wait"
ip=$(curl ipinfo.io/ip)
discord_url="webhook_url"
out=$(curl "https://username:password@api.dynu.com/nic/update?hostname=urdomain.com&alias=subdomain&myip=$ip&myipv6=2602:1234::3")


generate_post_good() {
  cat <<EOF
{

  "embeds": [{
    "title": "DNS Location",
    "description": "DNS UPDATE NEW IP : $ip",
    "color": "45883"
  }]
}
EOF
}

generate_post_bad() {
  cat <<EOF
{

  "embeds": [{
    "title": "DNS Location",
    "description": "DNS UPDATE STATUS : $out",
    "color": "16711723"
  }]
}
EOF
}
generate_post_nochg() {
  cat <<EOF
{

  "embeds": [{
    "title": "DNS Location",
    "description": "DNS UPDATE NOT NEEDED : $out",
    "color": "45883"
  }]
}
EOF
}


if [[ "$out" == "nochg" ]]
then
    curl -H "Content-Type: application/json" -X POST -d "$(generate_post_nochg)" $discord_url

elif [[ "$out" == *"good"* ]]
then
    curl -H "Content-Type: application/json" -X POST -d "$(generate_post_good)" $discord_url
else
    curl -H "Content-Type: application/json" -X POST -d "$(generate_post_bad)" $discord_url
fi
echo $ip
printf "done!"


