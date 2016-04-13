FROM davedoesdev/docker-dtuf
RUN apt-get update -y && \
    apt-get install -y git &&
    git status
