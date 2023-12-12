# syntax=docker/dockerfile:1.3-labs

FROM cr.ray.io/rayproject/oss-ci-base_build

SHELL ["/bin/bash", "-ice"]

COPY . .

RUN <<EOF
#!/bin/bash

set -euo pipefail

curl -sfL "https://github.com/kubernetes-sigs/kind/releases/download/v0.11.1/kind-linux-amd64" -o /usr/local/bin/kind
chmod +x /usr/local/bin/kind
kind version

curl -sfL "https://dl.k8s.io/release/v1.28.4/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl
kubectl version --client

curl -sfL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.2.1/kustomize_v5.2.1_linux_amd64.tar.gz" \
    | tar -xzf -C /usr/local/bin kustomize

pip install -U --ignore-installed \
    -r python/requirements.txt -c python/requirements_compiled.txt \

pip install -U --ignore-installed \
    docker -c python/requirements_compiled.txt \

EOF
