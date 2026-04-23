#!/bin/bash

# ---------- Colors ----------
RESET='\033[0m'
BOLD='\033[1m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'

# ---------- Convert hex little-endian to IP decimal ----------
hex_to_ip() {
    local hex="$1"
    printf "%d.%d.%d.%d" \
        "0x${hex:6:2}" "0x${hex:4:2}" "0x${hex:2:2}" "0x${hex:0:2}"
}

# ---------- Convert hex to port decimal ----------
hex_to_port() {
    printf "%d" "$(( 16#$1 ))"
}

# ---------- Break line ----------
line() {
    printf "${GRAY}+%-21s+%-21s+${RESET}\n" \
        "---------------------" "---------------------"
}

# ---------- Read and print TCP connections ----------
connections() {
    local file="/proc/net/tcp"

    line
    printf "${BOLD}| %-19s | %-19s |${RESET}\n" "LOCAL ADDRESS:PORT" "REMOTE ADDRESS:PORT"
    line

    tail -n +2 "$file" | while read -r sl local_address rem_address rest; do
        # Separa hex_ip:hex_porta usando IFS
        IFS=':' read -r local_hex_ip local_hex_port <<< "$local_address"
        IFS=':' read -r rem_hex_ip   rem_hex_port   <<< "$rem_address"

        local_ip=$(hex_to_ip "$local_hex_ip")
        local_port=$(hex_to_port "$local_hex_port")

        rem_ip=$(hex_to_ip "$rem_hex_ip")
        rem_port=$(hex_to_port "$rem_hex_port")

        printf "${CYAN}| %-19s${RESET} | %-19s |\n" \
            "${local_ip}:${local_port}" \
            "${rem_ip}:${rem_port}"
    done

    line
}

connections
