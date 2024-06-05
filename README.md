# github-runners


## Prerequisites
```bash
sudo apt install -y qemu-kvm libvirt-clients libvirt-daemon-system virtinst bridge-utils libguestfs-tools

sudo apt install -y ansible git


sudo systemctl enable libvirtd
sudo systemctl start libvirtd

```
### Once VM is booted up
```bash
# remove cdrom first line from /etc/apt/sources.list
su root
vi /etc/apt/sources.list

# install essentials
# for now we're cheating to win.. just a little bit
su root
apt-get install -y git
git clone https://github.com/bradfordwagner/container-ansible.git src && cd src
./install_ansible.sh debian ~/src

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
```
