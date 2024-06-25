# github-runners


## Prerequisites (orangepi)
```bash
sudo apt install -y qemu-kvm libvirt-clients libvirt-daemon-system virtinst bridge-utils libguestfs-tools
sudo apt install --no-install-recommends qemu-system-arm libvirt-clients \
  libvirt-daemon-system bridge-utils virtinst libvirt-daemon qemu-utils \
  qemu-efi-aarch64
sudo apt install --no-install-recommends libvirt-daemon \
  libvirt-daemon-system libvirt-clients qemu-kvm qemu-system-arm \
  qemu-utils qemu-efi-aarch64 qemu-efi-arm arm-trusted-firmware \
  seabios bridge-utils virtinst dnsmasq-base ipxe-qemu

sudo apt install -y ansible git

sudo systemctl enable libvirtd
sudo systemctl start libvirtd
```
### VM setup
```bash
# download image
wget https://cdimage.debian.org/debian-cd/current/arm64/iso-dvd/debian-12.5.0-arm64-DVD-1.iso
```
### Once VM is booted up
```bash
# remove cdrom first line from /etc/apt/sources.list
su root
apt-get install -y git sudo
vi /etc/apt/sources.list
vi /etc/sudoers # add gh
ALL            ALL = (ALL) NOPASSWD: ALL


# install essentials
# for now we're cheating to win.. just a little bit
su root
cd
git clone https://github.com/bradfordwagner/container-ansible.git src && cd src
./install_ansible.sh debian ~/src

# as gh user
sudo rm -rf ~/src ~/.ansible
. /ansible_env/bin/activate
git clone https://github.com/bradfordwagner/github-runners.git src && cd src
ansible-galaxy install -r requirements.yml --force
ansible-playbook \
  -i localhost, -c local \
  --ask-become-pass \
  ./pb-sudoer.yml

# https://docs.github.com/en/rest/actions/self-hosted-runners?apiVersion=2022-11-28#create-a-registration-token-for-a-repository
# "Administration" repository permissions (write)
gh_pat=...
ansible-playbook -i localhost ./pb-self.yml -e runners_token=${gh_pat}

# this is what the cicd runs
ansible-playbook -i localhost ./pb-vms.yml -e runners_token=${gh_pat}

# install docker https://docs.docker.com/engine/install/debian/#install-using-the-repository
sudo usermod -aG docker $USER # allow access to docker sock
newgrp docker # give access without restart
```
