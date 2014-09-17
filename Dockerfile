FROM million12/typo3-neos-abstract:latest
MAINTAINER Marcin Ryzycki marcin@m12.io

# ENV: Install following TYPO3 Neos version
ENV TYPO3_NEOS_VERSION 1.1.2

# ENV: Repository for installed TYPO3 Neos distribution 
#ENV TYPO3_NEOS_REPO_URL git://git.typo3.org/Neos/Distributions/Base.git

# ENV: Optional composer install parameters
#ENV TYPO3_NEOS_COMPOSER_PARAMS --dev --prefer-source

# Pre-install TYPO3 Neos into /tmp/typo3-neos.tgz
RUN . /build-typo3-neos/pre-install-typo3-neos.sh
