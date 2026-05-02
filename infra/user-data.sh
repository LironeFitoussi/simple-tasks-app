#!/bin/bash
set -e

# === CONFIG ===
REPO_URL="https://github.com/LironeFitoussi/simple-tasks-app.git"
BRANCH="main"
APP_DIR="/app"
BACKEND_SUBDIR="backend"

# === LOGGING ===
exec > /var/log/user-data.log 2>&1

echo "=== STARTING DEPLOYMENT ==="

# === SYSTEM SETUP ===
echo "Waiting for package manager lock..."

while pgrep -x dnf >/dev/null; do
  echo "Package manager is running, waiting..."
  sleep 5
done

dnf update -y
dnf install -y git

# === INSTALL NODE (NodeSource LTS) ===
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
dnf install -y nodejs

# === GLOBAL TOOLS ===
npm install -g pm2

# === CLONE REPO ===
cd /tmp
git clone -b $BRANCH $REPO_URL repo

# === PREPARE APP ===
rm -rf $APP_DIR
mkdir -p $APP_DIR
cp -r /tmp/repo/$BACKEND_SUBDIR/* $APP_DIR

cd $APP_DIR

# === INSTALL & BUILD ===
npm install

if grep -q "\"build\"" package.json; then
  npm run build
fi

# === RUN APP ===
pm2 start npm --name backend-app -- start
pm2 save
pm2 startup systemd -u root --hp /root

echo "=== DEPLOYMENT COMPLETE ==="
