#!/usr/bin/env bash
export GITHUB_USER="schmidtandreas"
source <(curl -s https://raw.githubusercontent.com/${GITHUB_USER:-"tteck"}/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    __  ____            ______           ______     ____           __                __  
   /  |/  (_)___  ___  / ____/________ _/ __/ /_   / __ )___  ____/ /________  _____/ /__
  / /|_/ / / __ \/ _ \/ /   / ___/ __ `/ /_/ __/  / __  / _ \/ __  / ___/ __ \/ ___/ //_/
 / /  / / / / / /  __/ /___/ /  / /_/ / __/ /_   / /_/ /  __/ /_/ / /  / /_/ / /__/ ,<   
/_/  /_/_/_/ /_/\___/\____/_/   \__,_/_/  \__/  /_____/\___/\__,_/_/   \____/\___/_/|_|  
                                                                                         
EOF
}
header_info
echo -e "Loading..."
APP="MineCraft-Bedrock"
var_disk="2"
var_cpu="4"
var_ram="2048"
var_os="ubuntu"
var_version="22.04"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -f /minecraft/bedrock_server ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Updating ${APP} LXC"
apt-get update &>/dev/null
apt-get -y upgrade &>/dev/null
msg_ok "Updated Successfully"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
