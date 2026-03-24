#!/usr/bin/env bash
set -e

echo "🚀 Docker registry mirror switcher"

# ----------------------------
# check docker
# ----------------------------
if ! command -v docker >/dev/null 2>&1; then
    echo "❌ Docker not installed"
    exit 1
fi

# ----------------------------
# require root
# ----------------------------
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run as root: sudo bash $0"
    exit 1
fi

# ----------------------------
# backup config
# ----------------------------
echo "📦 Backing up Docker config..."

mkdir -p /etc/docker

if [ -f /etc/docker/daemon.json ]; then
    cp /etc/docker/daemon.json /etc/docker/daemon.json.bak
fi

# ----------------------------
# write mirrors
# ----------------------------
echo "📝 Writing registry mirrors..."

cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": [
    "https://mirror.ccs.tencentyun.com",
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com"
  ],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

# ----------------------------
# restart docker
# ----------------------------
echo "🔄 Restarting Docker..."

if command -v systemctl >/dev/null 2>&1; then
    systemctl daemon-reload
    systemctl restart docker
else
    service docker restart
fi

# ----------------------------
# verify
# ----------------------------
echo ""
echo "✅ Done!"
echo "📡 Testing Docker..."

docker info | grep -i "Registry Mirrors" || true