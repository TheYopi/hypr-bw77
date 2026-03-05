#!/usr/bin/env bash

arch_updates=$(checkupdates 2>/dev/null | wc -l)
aur_updates=$(yay -Qum 2>/dev/null | wc -l)
total_arch=$((arch_updates + aur_updates))

if command -v flatpak >/dev/null; then
    flatpak_updates=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
else
    flatpak_updates=0
fi

current_k=$(uname -r | cut -d'-' -f1)
pending_k=$(pacman -Si linux | grep Version | awk '{print $3}' | cut -d'-' -f1)

if [ "$current_k" != "$pending_k" ]; then
    k_msg="Yes"
else
    k_msg="No"
fi

tooltip="Kernel update: $k_msg\nPackages: $total_arch\nFlatpaks: $flatpak_updates"

if [ "$((total_arch + flatpak_updates))" -gt 0 ]; then
    echo "{\"text\": \"$((total_arch + flatpak_updates))\", \"tooltip\": \"$tooltip\", \"class\": \"has-updates\"}"
else
    echo "{\"text\": \"\", \"tooltip\": \"System Up-to-Date\", \"class\": \"updated\"}"
fi
