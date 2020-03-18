FROM ubuntu:bionic-20180526

COPY bin/bootstrap.sh /var/tmp/bootstrap.sh

RUN /var/tmp/bootstrap.sh

WORKDIR /var/tmp/runctl

ADD --chown=app https://github.com/buildkite/terminal-to-html/releases/download/v3.3.0/terminal-to-html-3.3.0-linux-amd64.gz vendor/bin/
RUN cd vendor/bin && gunzip terminal-to-html-3.3.0-linux-amd64.gz && chmod +x terminal-to-html-3.3.0-linux-amd64
RUN chown app: /var/tmp/runctl

USER app

COPY --chown=app Gemfile Gemfile.lock /var/tmp/runctl/
RUN bundle install --path=vendor/bundle

COPY --chown=app lib /var/tmp/runctl/lib
COPY --chown=app public /var/tmp/runctl/public
COPY --chown=app config.ru /var/tmp/runctl
