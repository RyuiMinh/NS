# Đặt giá trị colab (True nếu đang chạy trong môi trường Colab, False nếu không)
colab=$(if [ -d "/content" ]; then echo true; else echo false; fi)

# Nếu colab = true, tạo folder và thiết lập đường dẫn lưu ảnh
if $colab; then
    IMG_DIR="/content/drive/MyDrive/img/win"
    if [ ! -d "$IMG_DIR" ]; then
        echo "Creating directory $IMG_DIR..."
        mkdir -p "$IMG_DIR"
    fi
    IMG_PATH="$IMG_DIR/w10x64.img"
else
    IMG_PATH="w10x64.img"
fi

# Kiểm tra và tải ngrok nếu chưa có
if [ ! -f "ngrok-v3-stable-linux-amd64.tgz" ]; then
    echo "Downloading Ngrok..."
    wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
    tar -xvzf ngrok-v3-stable-linux-amd64.tgz
fi

# Đăng ký authtoken ngrok
if [ ! -f "./ngrok" ]; then
    tar -xvzf ngrok-v3-stable-linux-amd64.tgz
fi
./ngrok authtoken 2caMIyH98jojFijfUDA9HHKZDZ0_2naziucGo1SjGJ4xWL8QM
nohup ./ngrok tcp 5900 &>/dev/null &

echo "Ngrok Connect!"
echo "-------------------------------"

# Cập nhật hệ thống
sudo apt update -y > /dev/null 2>&1
echo "Installing QEMU..."
sudo apt install qemu-system-x86 curl -y > /dev/null 2>&1

# Kiểm tra và tải đĩa Windows nếu chưa có
if [ ! -f "$IMG_PATH" ]; then
    echo "Downloading Windows Disk..."
    curl -L -o "$IMG_PATH" https://bit.ly/akuhnetW10x64
fi

echo "Windows 10 x64 Lite"
echo "Your VNC IP Address:"
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'

echo "Script by fb.me/LeVuHg"
echo "Starting Windows..."

# Khởi động QEMU với Windows
sudo qemu-system-x86_64 -vnc :0 -hda "$IMG_PATH" -machine usb=on -device usb-tablet -vga virtio -display default,show-cursor=on
