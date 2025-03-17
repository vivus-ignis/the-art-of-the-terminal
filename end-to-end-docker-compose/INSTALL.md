# VM setup for docker compose

The following was tested on Debian 12.

### Base software install (run as root)

```bash
apt-get update
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
cat /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl status docker
wget -qO - 'https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub' | gpg --dearmor > /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg
echo "deb [arch=all,$(dpkg --print-architecture) signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://proget.makedeb.org prebuilt-mpr $(lsb_release -cs)" > /etc/apt/sources.list.d/prebuilt-mpr.list
apt-get update
apt-get install just
apt-get install age
apt-get install -y build-essential  # required for cargo
```

### User setup

```bash
useradd -m -G docker -s /bin/bash deploy
su - deploy
mkdir .ssh
# C-d
cp /root/.ssh/authorized_keys /home/deploy/.ssh/
chown deploy:deploy /home/deploy/.ssh/authorized_keys
```

### Kerek install (run as user 'deploy')

```bash
wget -O install.sh https://sh.rustup.rs
less install.sh  # always check what you download!
bash install.sh
echo '. "$HOME/.cargo/env"' >> ~/.bashrc
. ~/.bashrc
cargo install --git https://github.com/evolutics/kerek
mkdir -p ~/.docker/cli-plugins
ln -s $(which kerek) ~/.docker/cli-plugins/docker-deploy
docker deploy --help
```
