# TYPO3 Neos | Docker image

This is a [million12/typo3-neos](https://registry.hub.docker.com/u/million12/typo3-neos/) docker container, with [TYPO3 Neos](http://neos.typo3.org) pre-installed and Nginx/PHP-FPM to run it. It is based on [million12/typo3-neos-abstract](https://github.com/million12/docker-typo3-neos-abstract) - have a look there if you are interested about nitty-gritty of how it works and how to build your own images with custom TYPO3 Neos setup.

## Usage

[Fig](http://www.fig.sh/), simple Docker orchestration tool is used to launch database and TYPO3 Neos containers and link them together. If you don't have it yet, [install](http://www.fig.sh/install.html) it first. 

The [fig.yml](fig.yml) config file is provided, so you can **launch TYPO3 Neos with just one command**:  
```
fig up [-d]
```

Don't forget to **map vhost names** in your `/etc/hosts`. You can do this easily by adding entry with following line to your `/etc/hosts` file:
```
YOUR_DOCKER_IP neos dev.neos test.neos
```

**Now go to [http://neos:8080/](http://neos/)** (or http://dev.neos:8080/ for *Development* environment) and enjoy playing with TYPO3 Neos CMS!


#### Manual launch (without fig)

If you prefer not to use fig, you could launch required containers manually using following steps:

```
docker run -d -v /var/lib/mysql --name=dbdata busybox
docker run -d --volumes-from=dbdata -p=3306 --env="MARIADB_PASS=my-pass" --name=db tutum/mariadb

docker run -d -v /data --name=neosdata busybox
docker run -d --volumes-from=neosdata -p=80:80 --link=db:db --name=neos million12/typo3-neos
docker logs -f neos # to see how TYPO3 Neos initialisation is going on...
```


## Authors

Author: Marcin Ryzycki (<marcin@m12.io>)  
