FROM davedoesdev/docker-dtuf
COPY .git /.git
RUN apt-get update -y && \
    apt-get install -y git curl && \
    release_name="$(git describe)" && \
    git config --get remote.origin.url && \
    curl "https://github.com/davedoesdev/rumprun-packages/releases/tag/$release_name" | grep -o '[^/]*\.tar\.xz"' | tr -d '"'
    rm -rf .git
