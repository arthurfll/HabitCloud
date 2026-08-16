#!/usr/bin/env bash
# Deploy script: commita e envia as mudancas para o GitHub (branch main),
# depois builda, tageia e envia a imagem Docker para o Docker Hub.

set -euo pipefail

DOCKER_HUB_IMAGE="arthurfll/cr"
DOCKERFILE_PATH="Core/Dockerfile"
DOCKER_CONTEXT="Core"
GIT_BRANCH="main"

step() {
    echo ""
    echo -e "\033[36m==> $1\033[0m"
}

fail() {
    echo -e "\033[31mFalha em: $1\033[0m" >&2
    exit 1
}

read -rp "Versao do app (ex: 1.0.0): " VERSION
if [ -z "$VERSION" ]; then
    fail "Versao nao pode ser vazia."
fi

read -rp "Comentario do commit: " COMMIT_MESSAGE
if [ -z "$COMMIT_MESSAGE" ]; then
    fail "Comentario nao pode ser vazio."
fi

FULL_TAG="${DOCKER_HUB_IMAGE}:${VERSION}"
LATEST_TAG="${DOCKER_HUB_IMAGE}:latest"

step "Adicionando alteracoes ao git"
git add -A || fail "Adicionando alteracoes ao git"

if git diff --cached --quiet; then
    echo -e "\033[33mNenhuma alteracao para commitar, seguindo para o build da imagem.\033[0m"
else
    step "Commitando alteracoes"
    git commit -m "$COMMIT_MESSAGE" || fail "Commitando alteracoes"
fi

step "Enviando para o GitHub (branch $GIT_BRANCH)"
git push origin "$GIT_BRANCH" || fail "Enviando para o GitHub (branch $GIT_BRANCH)"

step "Buildando a imagem Docker ($FULL_TAG)"
docker build -t "$FULL_TAG" -t "$LATEST_TAG" -f "$DOCKERFILE_PATH" "$DOCKER_CONTEXT" || fail "Buildando a imagem Docker ($FULL_TAG)"

step "Enviando $FULL_TAG para o Docker Hub"
docker push "$FULL_TAG" || fail "Enviando $FULL_TAG para o Docker Hub"

step "Enviando $LATEST_TAG para o Docker Hub"
docker push "$LATEST_TAG" || fail "Enviando $LATEST_TAG para o Docker Hub"

echo ""
echo -e "\033[32mDeploy concluido: $FULL_TAG\033[0m"
