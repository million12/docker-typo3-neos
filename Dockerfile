#
# million12/typo3-neos
#
FROM million12/typo3-flow-neos-abstract:latest
MAINTAINER Marcin Ryzycki marcin@m12.io

ENV \
  T3APP_BUILD_REPO_URL="git://git.typo3.org/Neos/Distributions/Base.git" \
  T3APP_BUILD_BRANCH=2.0 \
  T3APP_NEOS_SITE_PACKAGE=TYPO3.NeosDemoTypo3Org

# Pre-install Neos CMS
RUN . /build-typo3-app/pre-install-typo3-app.sh
