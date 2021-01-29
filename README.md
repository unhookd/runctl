# runctl

Continously Deploy your application without trusting your CI/CD system. `runctl` is a release controller designed for safe integration with external deployment triggers.

# debug

```
ssh -L 9292:127.0.0.1:9292 -A <host>
docker run --mount type=bind,source=~/.kube,target=/home/app/.kube -it --rm -p 9292:9292 runctl:latest bash
bundle exec rackup -o 0.0.0.0 -p 9292 config.ru
```
