FROM davedoesdev/docker-dtuf
COPY .git /.git
RUN apt-get update -y && \
    apt-get install -y git curl && \
    release_name="$(git describe)" && \
    release_name=publish-0.0.24 && \
    echo TODO: REMOVE THE ABOVE LINE && \
    repo_url="$(git config --get remote.origin.url)" && \
    repo_url="${repo_url%.git}" && \
    mkdir rumprun-package-binaries && \
    curl "$repo_url/releases/tag/$release_name" | \
        grep -o '[^/]*\.tar\.xz"' | tr -d '"' | tr '\n' '\0' | \
        xargs -0 -n 1 -I % sh -c "curl $repo_url/releases/download/$release_name/% | tar -C rumprun-package-binaries -Jx" && \
    rm -rf .git
