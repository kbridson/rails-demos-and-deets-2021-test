
#
# Display provisioner commands before they execute.
#
set -o xtrace

#
# Customize the .bashrc file.
#
cat >> ~/.bashrc <<EOF
# Scott's favorite shell prompt.
export PS1='[\u@\h:\w]\n\$ '

# Makes the shell match filenames in a case-insensitive fashion when performing
# filename expansion (e.g., with *).
shopt -s nocaseglob
EOF

#
# Set up case-insensitive autocompletion.
#
cat > ~/.inputrc <<EOF
# Make the shell auto-complete case insensitive.
set completion-ignore-case On
EOF

#
# Make a symbolic link to the synced directory.
#
ln -s /vagrant ~/workspace

# 
# Set locale and local timezone
# 
sudo update-locale LANG="en_US.UTF-8"
sudo timedatectl set-timezone America/Chicago

# 
# Display motd (Message of the Day)
# 
sudo sed -i 's?motd=/etc/motd?motd=/run/motd.dynamic?g' /etc/pam.d/sshd

#
# Install the requisite Ubuntu packages.
#
# git - Because we'll use it
# libyaml-dev,
# libxslt-dev,
# libxml2-dev,
# libsqlite3-dev - For Ruby on Rails
# gnupg2 - For installing RVM
# python - For building Node from source or Node extensions
#
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
# sudo apt-get update --fix-missing
sudo apt-get -y install git libyaml-dev libxslt-dev libxml2-dev libsqlite3-dev gnupg2 python postgresql postgresql-contrib libpq-dev yarn landscape-common

#
# Install RVM.
#
# gpg2 --keyserver pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
curl -sSL https://get.rvm.io | bash -s stable

#
# Use RVM to install Ruby (a couple versions).
#
~/.rvm/bin/rvm --quiet-curl install ruby-2.5.5
~/.rvm/bin/rvm --quiet-curl install ruby-2.6.3

#
# Install the Node Version Manager (NVM). Note that there may be a newer version now.
#
# Note: added -sS option to silence the curl output.
curl -sS -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
# Make it so the NVM command will be available.
source ~/.nvm/nvm.sh

#
# Install the latest Long-Term Support (LTS) release of Node.
#
nvm install --lts

# 
# Postgres db setup. Replace user, password, and db root for specific project.
# 
# fix permissions for postgres port forwarding
echo "-------------------- fixing listen_addresses on postgresql.conf"
sudo find /etc/postgresql/ -name "postgresql.conf" -exec sed -i "s/#listen_address.*/listen_addresses = '*'/" {} +
# sudo sed -i "s/#listen_address.*/listen_addresses '*'/" /etc/postgresql/9.1/main/postgresql.conf
echo "-------------------- fixing postgres pg_hba.conf file"
# replace the ipv4 host line with the above line
PG_DIR=$(dirname $(sudo find /etc/postgresql/ -name "postgresql.conf" -print))
sudo sh -c "cat >> $PG_DIR/pg_hba.conf <<EOF
# Accept all IPv4 connections - FOR DEVELOPMENT ONLY!!!
host    all         all         0.0.0.0/0             md5
EOF"
sudo /etc/init.d/postgresql restart

echo "-------------------- creating default database"
PG_USER="vagrant"
PG_PSWD="password1"
PG_DB_ROOT="default"

sudo -i -u postgres psql -c "CREATE USER $PG_USER WITH PASSWORD '$PG_PSWD';"
sudo -i -u postgres psql -c "ALTER USER $PG_USER WITH SUPERUSER CREATEDB;"
sudo -i -u postgres psql -c "CREATE DATABASE \"${PG_DB_ROOT}_development\" OWNER $PG_USER;"
sudo -i -u postgres psql -c "CREATE DATABASE \"${PG_DB_ROOT}_test\" OWNER $PG_USER;"
sudo -i -u postgres psql -c "CREATE DATABASE \"${PG_DB_ROOT}_production\" OWNER $PG_USER;"
