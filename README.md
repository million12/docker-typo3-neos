# TYPO3 Neos | Docker image
[![Circle CI](https://circleci.com/gh/million12/docker-typo3-neos.png?style=badge)](https://circleci.com/gh/million12/docker-typo3-neos)

This is a [million12/typo3-neos](https://registry.hub.docker.com/u/million12/typo3-neos/) Docker container with [TYPO3 Neos](http://neos.typo3.org) default *base* distribution.

It is an example of how you can build your own TYPO3 Neos installation, perhaps from your own repository, using the abstract [million12/typo3-flow-neos-abstract](https://github.com/million12/docker-typo3-flow-neos-abstract) Docker image. Please read extensive documentation there to learn more.
 
This container contains PHP/Nginx setup. You will need a separate container with database. See the instructions below.

## Usage

By default, the container starts and fully configure TYPO3 Neos, incl. importing default site package and creating the 1st admin user. Login: `admin`, password: `password`.

Launch required containers:

```
docker run -d --name=db --env="MARIADB_PASS=my-pass" million12/mariadb
docker run -d --name=neos -p=8080:80 --link=db:db --env="T3APP_VHOST_NAMES=neos dev.neos" million12/typo3-neos
```

You can inspect how the Neos provisioning is going on using `docker logs -f neos`. When you see something like `nginx entered RUNNING state`, you are ready to go.

Don't forget to **map vhost name(s)**, provided in above command via `T3APP_VHOST_NAMES` env variable, on your local machine. Do this by adding following line to your `/etc/hosts` file:  
```
YOUR_DOCKER_IP neos dev.neos
```

**Now go to [http://neos:8080/](http://neos:8080/)** (or respectively http://dev.neos:8080/ for *Development* environment) and enjoy playing with TYPO3 Neos!

#### Development

Launch separate SSH container and link it with running `neos` container:
``` 
docker run -d --name=dev --link=db:db --link=neos:web --volumes-from=neos -p=1122:22 --env="IMPORT_GITHUB_PUB_KEYS=your-github-username-here" million12/php-app-ssh
```  
Please provide your GitHub username to `IMPORT_GITHUB_PUB_KEYS` env variable; your public SSH key will be imported from there. After container is launched, your key will be automatically added inside container and you can log in using **www user**:  
```
ssh -p 1122 www@YOUR_DOCKER_IP
```

You will find TYPO3 Neos in `typo3-app` directory (by default). You can do all `./flow` commands from there, upload files via SFTP, in general: do all development using it. Learn more about the SSH container on [million12/docker-php-app-ssh](https://github.com/million12/docker-php-app-ssh) repository page.

Note: the good part with that side SSH container is that it is build on top of [million12/php-app](https://github.com/million12/docker-php-app) image, exactly the same which is used as a base iamge for [million12/typo3-flow-neos-abstract](https://github.com/million12/docker-typo3-flow-neos-abstract). Therefore you can be sure you have the same PHP configuration, the same software as inside container with running TYPO3 Neos. In practise it means: no quirk issues due to differences in environments.


## Usage with fig

Instead of manually launching all containers like described above, you can use [Fig](http://www.fig.sh/). Fig is a Docker orchestration tool and it is very easy to use. If you do not have it yet, [install](http://www.fig.sh/install.html) it first. 

The [fig.yml](fig.yml) config file is already provided, so you can **launch TYPO3 Neos with just one command**:  
```
fig up [-d]
```

And you're done.

You can uncomment the `dev` container if you need SSH access. Remember to supply your GitHub username to `IMPORT_GITHUB_PUB_KEYS` env variable. Provided account has to have your public SSH key added.


## Running tests

It is very easy to run unit, functional and Behat tests against TYPO3 Neos with this container. Because some of TYPO3 Neos tests require Selenium with Firefox, we will launch [million12/behat-selenium](https://github.com/million12/docker-behat-selenium) image, link it with running Neos container and run the tests from there. Container million12/behat-selenium it is based on the same image with PHP as our TYPO3 Neos container, so we can be sure we are working in the same environment.

Here's how you can run all TYPO3 Neos test suites:  
```
docker run -d --name=db --env="MARIADB_PASS=my-pass" million12/mariadb
docker run -d --name=neos-testing --link=db:db --env="T3APP_VHOST_NAMES=behat.dev.neos" --env="T3APP_DO_INIT_TESTS=true" --env="T3APP_DO_INIT=false" million12/typo3-neos

# Wait till Neos container is fully provisioned (docker logs -f neos-testing). Then launch tests:
docker run -ti --volumes-from=neos-testing --link=neos-testing:web --link=db:db million12/behat-selenium "
    echo \$WEB_PORT_80_TCP_ADDR \$WEB_ENV_T3APP_VHOST_NAMES >> /etc/hosts && cat /etc/hosts && \
    su www -c \"
      cd ~/typo3-app && \
      echo -e '\n\n======== RUNNING TYPO3 NEOS TESTS =======\n\n' && \
      bin/phpunit -c Build/BuildEssentials/PhpUnit/UnitTests.xml && \
      bin/phpunit -c Build/BuildEssentials/PhpUnit/FunctionalTests.xml && \
      bin/behat -c Packages/Application/TYPO3.Neos/Tests/Behavior/behat.yml
    \"
"
```  
and you should see all tests nicely passing ;-)

## Authors

Author: Marcin Ryzycki (<marcin@m12.io>)  

---

**Sponsored by** [Typostrap.io - the new prototyping tool](http://typostrap.io/) for building highly-interactive prototypes of your website or web app. Built on top of TYPO3 Neos CMS and Zurb Foundation framework.
