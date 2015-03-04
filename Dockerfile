FROM million12/typo3-flow-neos-abstract:latest
MAINTAINER Marcin Ryzycki marcin@m12.io

ENV \
  T3APP_BUILD_REPO_URL="git://git.typo3.org/Neos/Distributions/Base.git" \
  T3APP_BUILD_BRANCH=master \
  T3APP_NEOS_SITE_PACKAGE=TYPO3.NeosDemoTypo3Org

# Pre-install TYPO3 Neos
RUN . /build-typo3-app/pre-install-typo3-app.sh
