#!/bin/bash

set -e
set -o pipefail

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=C.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

function fullstop {
  >&2 echo ${@}
  exit 1
}

THIS_CHKSUM_ARTIFACT=/var/tmp/bootstrap.$(cksum < $0 | awk '{ print $1 }').artifact

if [[ ! -e ${THIS_CHKSUM_ARTIFACT} ]];
then
  (apt-get update && apt-get install -y locales) || fullstop failed to install locales

  (locale-gen --purge en_US.UTF-8 && /bin/echo -e "LANG=$LANG\nLANGUAGE=$LANGUAGE\n" | tee /etc/default/locale \
    && locale-gen $LANGUAGE \
    && dpkg-reconfigure locales) || fullstop failed to configure locales

  (apt-get update \
    && apt-get upgrade --no-install-recommends -y \
    && apt-get install --no-install-recommends -y \
         ruby2* ruby2*-dev libruby2* ruby-bundler rubygems-integration build-essential aha \
    && apt-get clean && rm -rf /var/lib/apt/lists/*) || fullstop failed to install ruby deps

  id app || (useradd -G sudo --home-dir /home/app --create-home --shell /bin/bash app || fullstop failed to create app user)
  mkdir -p /home/app/current && chown app. /home/app/current || fullstop failed to create app dir

  #https://github.com/buildkite/terminal-to-html/releases/download/v3.3.0/terminal-to-html-3.3.0-linux-amd64.gz

  touch ${THIS_CHKSUM_ARTIFACT}
fi
