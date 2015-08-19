[![Stories in Ready](https://badge.waffle.io/evercam/evercam-devops.png?label=ready&title=Ready)](https://waffle.io/evercam/evercam-devops)
## Evercam Development Environment Setup

#### Install Host dependencies

* [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](http://www.vagrantup.com/downloads.html)
* [Python](https://www.python.org/downloads/)
* [Git](http://git-scm.com/downloads)

#### Clone this repository and it's submodules

```
git clone https://github.com/evercam/evercam-devops.git && cd evercam-devops
git pull && git submodule init && git submodule update && git submodule status
git submodule foreach --recursive git checkout master
git submodule foreach --recursive git pull
```

#### Install Ansible dependencies

```
sudo pip install ansible
sudo ansible-galaxy install -r ansible/requirements.yml --force
```

#### Create a `private_vars_devops.yml` file and fill it in with your information

```
aws_access_key: "aws_access_key"
aws_secret_key: "aws_secret_key"
```

#### Copy example `.env` file into required directories

```
cp .env evercam-api/
cp .env evercam-dashboard/
cp .env evercam-models/
cp .env evercam-media/
```

#### Run Vagrant and ssh into the VM

```
vagrant up && vagrant ssh
```

Grab a cup of your favorite beverage, this is going to take some time...

#### Test that everything is working

```
cd /vagrant/evercam-api
bundle install
fakes3 --root=/tmp/fakes3 --port=10453 &
./scripts/create
bundle exec rspec

cd /vagrant/evercam-dashboard
bundle install
bundle exec rspec --pattern 'c*/*_spec.rb,h*/*_spec.rb'

echo -e "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf
sudo apt-get update
sudo apt-get --yes --force-yes install libjpeg-dev

cd /vagrant/evercam-media
npm install
mix local.hex
mix deps.get && mix deps.compile && mix compile
mix test
```

You're done!

### Now start the API server:

```
cd /vagrant/evercam-api
bundle exec rackup -o 0.0.0.0
```

### And in another terminal tab/window start the Dashboard server:

```
cd /vagrant/evercam-dashboard
EVERCAM_LOCAL=true bundle exec rails server -b 0.0.0.0
```

### And in another terminal tab/window start the Media server:

```
cd /vagrant/evercam-media
EVERCAM_LOCAL=true mix phoenix.server
```

### Another way to execute media server:

```
cd /vagrant/evercam-media
mix release
cp -r priv_dir/ rel/evercam_media/priv_dir
EVERCAM_LOCAL=true rel/evercam_media/bin/evercam_media foreground
```

### And in another terminal tab/window start the Phony camera for offline tests:

```
cd /vagrant/phony_camera
EVERCAM_LOCAL=true node index
```

Open [http://localhost:3000/](http://localhost:3000/) in a browser and you'll see the dashboard of the Next Big Thing&trade;
