# TYPO3 Neos | Docker image
[![Circle CI](https://circleci.com/gh/million12/docker-typo3-neos.png?style=badge)](https://circleci.com/gh/million12/docker-typo3-neos)

This is a [million12/typo3-neos](https://registry.hub.docker.com/u/million12/typo3-neos/) docker container, with [TYPO3 Neos](http://neos.typo3.org) pre-installed and Nginx/PHP-FPM to run it. It is based on [million12/typo3-neos-abstract](https://github.com/million12/docker-typo3-neos-abstract) - have a look there if you are interested about nitty-gritty of how it works and how to build your own images with custom TYPO3 Neos setup.

## Usage

[Fig](http://www.fig.sh/), simple Docker orchestration tool is used to launch database and TYPO3 Neos containers and link them together. If you don't have it yet, [install](http://www.fig.sh/install.html) it first. 

The [fig.yml](fig.yml) config file is provided, so you can **launch TYPO3 Neos with just one command**:  
```
fig up [-d]
```

Don't forget to **map vhost names** in your `/etc/hosts`. You can do this easily by adding entry with following line to your `/etc/hosts` file:
```
YOUR_DOCKER_IP neos dev.neos behat.dev.neos
```

**Now go to [http://neos:8080/](http://neos/)** (or http://dev.neos:8080/ for *Development* environment) and enjoy playing with TYPO3 Neos CMS!


#### Manual launch (without fig)

If you prefer not to use fig, you could launch required containers manually using following steps:

```
docker run -d --name=db --env="MARIADB_PASS=my-pass" tutum/mariadb
docker run -d --name=neos -p=8080:80 --link=db:db million12/typo3-neos
docker logs -f neos # to see how TYPO3 Neos initialisation is going on...

# If you need to SSH into your set up, launch also SSH container and glue it to the above one:
docker run -d --name=dev --link=db:db --link=neos:web --volumes-from=neos -p=1122:22 million12/php-app-ssh
```

### Running tests

This container is ready to run unit, functional and Behat tests against TYPO3 Neos. For an example how to run them, see the [million12/behat-selenium](https://github.com/million12/docker-behat-selenium) repository.


## Authors

Author: Marcin Ryzycki (<marcin@m12.io>)  

---

**Sponsored by** [Typostrap.io - the new prototyping tool](http://typostrap.io/) for building highly-interactive prototypes of your website or web app. Built on top of TYPO3 Neos CMS and Zurb Foundation framework.
