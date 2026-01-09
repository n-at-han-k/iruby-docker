# IRuby Jupyter

## Docker Image

```bash
docker pull ghcr.io/n-at-han-k/iruby-docker:latest
```

## Helm Chart

```bash
helm repo add jupyter https://n-at-han-k.github.io/iruby-docker
helm install jupyter jupyter/jupyter --set ingress.host=jupyter.example.com --set token=secret
```
