# bb-RubyAPI-Postgres
Barebones Docker Ruby + Postgres setup for VirtualBox + Windows on mounted drive. This assumes you want to work on your windows machine while running Docker in a VM.

## Requirements
1. Virtualbox VM installed, OS of choice (using Ubuntu SERVER - not GUI - in this case)
2. Your VM mounted with your Windows folder (check this tutorial out: https://askubuntu.com/questions/45594/where-is-virtualbox-shared-folders-mounted-in-a-virtual-guest). In Ubuntu, you'll also have to have GuestAdditions installed. Your shared folder will show up in `/media`

## Steps
1. Clone this project into your shared mounted Windows folder. This could be your shared folder, too. If it is, make sure it's mounted in your VM and shows up in `/media`
3. Boot up your VM, make sure it's updated.
```
$ sudo apt-get update
$ sudo apt-get upgrade
```

4. Install Docker 
``` 
$ sudo apt install docker.io docker-compose
$ sudo systemctl start docker
$ sudo systemctl enable docker
```
3a. For S&G, make sure you actually did install docker:
`$ docker --version` # should get docker version number

4. Create a volume:
`$ docker volume create --name NAMEYOURVOLUME --driver local`

HIGHLY RECOMMENDED OPTIONAL 
4. You can change the folder names, username, and passwords in Dockerfile and docker-compose (highly recommended)
In Dockerfile: change `/railsapi` to whatever you want
In docker-compose.yml change 
* `/railsapi` to whatever you put in Dockerfile
* `POSTGRES_PASSWORD` to whatever password you want for postgres
* `POSTGRESS_USER` to whatever user you want for postgres

5. Change `data-railsapi` in docker-compose.yml to whatever your volume name you created in step 3.
6. While this setup is made to use the --api tag, you can choose to build the full ruby suite. 
FOR API: `$ docker-compose run web rails new . --api --T --force --database=postgresql`
FOR FULL: `$ docker-compose run web rails new . --force --database=postgresql`
7. `$ docker-compose build`
8. Go to `config/database.yml` and replace with:
```
default: &default
  adapter: postgresql
  encoding: unicode
  host: db
  username: WHATEVER_USERNAME_IN_DOCKER_COMPOSE
  password: WHATEVER_PASSWORD_IN_DOCKER_COMPOSE
  pool: 5

development:
  <<: *default
  database: YOURAPPNAME_development


test:
  <<: *default
  database: YOURAPPNAME_test
```
Change YOURAPPNAME to your app name (or whatever else you want, but probably easiest to keep it your app name)
Change WHATEVER_USERNAME/PASSWORD.

9. `$ lfconfig` and write down the IP address you have in (generally) eth0s.
10. `$ docker-compose up`
11. Open another terminal (putty, cmder, whatever), with
`ssh yourvmusername@THE_IP_FROM_STEP_9`
12. `$ docker-compose run web rake db:create`
13. In your Windows browser (not VM, because if you're running a server VM, you won't have that):
type in the IP:PORT to see if your rails app is up and running. Example (if you left the default port to 3000):
`129.134.0.0:3000`
14. Success! Keep your VM running but now you can use your favorite editor in Windows.

# References
+ Documentation initially taken from https://docs.docker.com/compose/rails/#connect-the-database
+ Ubuntu docker installation: https://linuxconfig.org/how-to-install-docker-on-ubuntu-18-04-bionic-beaver
