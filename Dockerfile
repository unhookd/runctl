FROM ubuntu:bionic-20180526

COPY bin/bootstrap.sh /var/tmp/bootstrap.sh

RUN /var/tmp/bootstrap.sh

COPY --chown=app Gemfile Gemfile.lock /var/tmp/runctl/
COPY --chown=app lib /var/tmp/runctl/lib
COPY --chown=app public /var/tmp/runctl/public

WORKDIR /var/tmp/runctl

USER app

RUN bundle install --path=vendor/bundle
