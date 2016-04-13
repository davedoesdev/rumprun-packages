FROM davedoesdev/docker-dtuf
COPY .git /.git
RUN apt-get update -y && \
    apt-get install -y git && \
    git describe && \
    rm -rf .git
