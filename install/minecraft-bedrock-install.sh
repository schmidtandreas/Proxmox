#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE
source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"

color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y wget
$STD apt-get install -y unzip
msg_ok "Installed Dependencies"

get_mc_br_version()
{
    echo "1.20.81.01"
}

msg_info "Installing MineCraft Bedrock"
MCBR_VERSION="$(get_mc_br_version)"
MCBR_SERVER_ARCHIVE="bedrock-server-${MCBR_VERSION}.zip"
MCBR_SERVER_URL="https://minecraft.azureedge.net/bin-linux/${MCBR_SERVER_ARCHIVE}"
MCBR_SYSTEMD_SERVICE="/lib/systemd/system/minecraft.service"

if [ -f "${MCBR_SYSTEMD_SERVICE}" ]; then
    systemctl stop minecraft
else
    cat <<EOF >"${MCBR_SYSTEMD_SERVICE}"
[Unit]
Description=MineCraft Bedrock Server

[Service]
WorkingDirectory=/minecraft
Environment="LD_LIBRARY_PATH=/minecraft"
ExecStart=/minecraft/bedrock_server

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable minecraft
fi
wget "${MCBR_SERVER_URL}"
[ ! -d "/minecraft" ] && mkdir "/minecraft"
unzip -d "/minecraft" "${MCBR_SERVER_ARCHIVE}"
sed -i "s|level-name=.*|level-name=Schmidty Land|" "/minecraft/server.properties"
systemctl start minecraft
msg_ok "Installed MineCraft Bedrock"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
