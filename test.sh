#!/bin/bash
sudo apt update -y
sudo apt install -y qemu-system-x86 wget curl neofetch

if [ ! -f "ngrok" ]; then
    wget -O ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
    tar -zxvf ngrok.tgz
fi
if ! grep -q "authtoken: 2caMIyH98jojFijfUDA9HHKZDZ0_2naziucGo1SjGJ4xWL8QM" ~/.ngrok2/ngrok.yml 2>/dev/null; then
    ./ngrok authtoken 2caMIyH98jojFijfUDA9HHKZDZ0_2naziucGo1SjGJ4xWL8QM
fi
if ! pgrep -f "ngrok tcp 5900" > /dev/null; then
    ./ngrok tcp 5900 --region ap &>/dev/null &
fi
echo "Please wait for installing..."
echo "Installing QEMU (2-3m)..."
echo "Downloading Windows Disk..."
if [ ! -f "lite7.qcow2" ]; then
    curl -L -o lite7.qcow2 https://app.vagrantup.com/thuonghai2711/boxes/WindowsQCOW2/versions/1.0.3/providers/qemu.box
fi
echo "Windows 7 x86 Lite"
echo "Your VNC IP Address:"
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
echo "===================="
echo    "Script by CAAT"
echo "===================="
sudo qemu-system-x86_64 -vnc :0 -hda lite7.qcow2  -smp cores=2  -m 8192M -machine usb=on -device usb-tablet > /dev/null 2>&1
