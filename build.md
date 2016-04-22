# Introduction

I've set up automated builds for the Rumprun toolchain and Rumprun packages.

The toolchain is built into a Docker image using Docker Hub automated builds.

The packages are built on Travis CI using the toolchain image. Build artifacts
(Rumprun binaries) are published individually to Github Releases.

Further, all Rumprun binaries are put into another Docker image along with a
script which uses [`dtuf`](https://github.com/davedoesdev/dtuf) to publish them
to a Docker registry. `dtuf` can then be used to fetch and update the binaries
on other computers without need for the Docker client.

The Rumprun binaries can be run in KVM as normal. Docker is _not_ required to
run them.

# Toolchain

The Rumprun toolchain image is [`davedoesdev/rumprun-toolchain-x86_64-rumprun-netbsd-hw`](https://hub.docker.com/r/davedoesdev/rumprun-toolchain-x86_64-rumprun-netbsd-hw/).

It builds automatically from the [source repo](https://github.com/davedoesdev/rumprun-toolchain-x86_64-rumprun-netbsd-hw). The Rumprun source is kept as a
submodule and built in the [normal way](https://github.com/rumpkernel/wiki/wiki/Tutorial:-Building-Rumprun-Unikernels#1-building-the-rumprun-platform).

If you look at the [`Dockerfile`](https://github.com/davedoesdev/rumprun-toolchain-x86_64-rumprun-netbsd-hw/blob/master/Dockerfile), you'll see that `davedoesdev/rumprun-toolchain-x86_64-rumprun-netbsd-hw` uses [`davedoesdev/rumprun-toolchain-base-hw`](https://hub.docker.com/r/davedoesdev/rumprun-toolchain-base-hw/) as its base image, which in turn uses [`davedoesdev/rumprun-toolchain-base`](https://hub.docker.com/r/davedoesdev/rumprun-toolchain-base/) as its. I've attempted to arrange the images so the root is generic, then specialised by the platform, then by the architecture. I've used Docker Hub's linked build feature to ensure descendant images are rebuilt when a parent image changes.

# Packages

Rumprun packages are built using another Docker image, [`davedoesdev/rumprun-pkgbuild-x86_64-rumprun-netbsd-hw`](https://hub.docker.com/r/davedoesdev/rumprun-pkgbuild-x86_64-rumprun-netbsd-hw/) (source [here](https://github.com/davedoesdev/rumprun-pkgbuild-x86_64-rumprun-netbsd-hw)). This image uses the toolchain image
as its base and adds all the dependencies that the Rumprun packages need.

The build itself happens on Travis CI, using [my fork](https://github.com/davedoesdev/rumprun-packages) of the packages repo. I've changed [`.travis.yml`](https://github.com/davedoesdev/rumprun-packages/blob/master/.travis.yml) so it calls a script ([`.docker-build/build-package-in-docker.sh`](https://github.com/davedoesdev/rumprun-packages/blob/master/.docker-build/build-package-in-docker.sh)) to build each package using the Docker image.

Packages can use another new script ([`.publish/push.sh`](https://github.com/davedoesdev/rumprun-packages/blob/master/.publish/push.sh)) to add an artifact to
the build output. Currently only the `nodejs` package does this.

After a successful build, `.travis.yml` arranges for all artifacts to be
published to the project's [Releases page](https://github.com/davedoesdev/rumprun-packages/releases) on Github. Travis does this for tagged builds only.

You'll also see that I added a [`Dockerfile`](https://github.com/davedoesdev/rumprun-packages/blob/master/Dockerfile) to my fork. After all the artifacts are published to Github Releases, `.travis.yml` triggers a build of the repo on Docker Hub. The `Dockerfile` fetches all the artifacts from
Github Releases and puts them into a new image, [`davedoesdev/rumprun-packages`](https://hub.docker.com/r/davedoesdev/rumprun-packages/), in the directory
`/rumprun-package-binaries`.

# dtuf

## Publishing binaries
 
I'm also publishing the Rumprun package binaries using
[`dtuf`](https://github.com/davedoesdev/dtuf). `dtuf` uses
[The Update Framework (TUF)](https://theupdateframework.github.io/) to
distribute files and updates to files. It uses a Docker registry (you can [run
your own](https://github.com/docker/distribution/blob/master/docs/deploying.md))
to store the files and TUF metadata.

I'm doing this using a Docker image, [`davedoesdev/rumprun-packages-dtuf`](https://hub.docker.com/r/davedoesdev/rumprun-packages-dtuf/). Its [`Dockerfile`](https://github.com/davedoesdev/rumprun-packages-dtuf/blob/master/Dockerfile) adds `dtuf` to the image containing all the Rumprun binaries (`davedoesdev/rumprun-packages`), along with a [helper script](https://github.com/davedoesdev/rumprun-packages-dtuf/blob/master/dtuf.sh) which uploads new package binaries to a Docker
registry.

The [source repo](https://github.com/davedoesdev/rumprun-packages-dtuf) also
contains a [script for launching the image](https://github.com/davedoesdev/rumprun-packages-dtuf/blob/master/rumprun-packages-dtuf.sh).

If you're interested, these are the command I use to sync the package binaries
to my registry:

```shell
export DTUF_HOST=unikernel.teksilo.com:5000
export DTUF_TARGETS_LIFETIME=365d
export DTUF_SNAPSHOT_LIFETIME=182d
export DTUF_TIMESTAMP_LIFETIME=91d
export DTUF_USERNAME=teksilo

set +o history
export DTUF_TARGETS_KEY_PASSWORD='xxx'
export DTUF_SNAPSHOT_KEY_PASSWORD='xxx'
export DTUF_TIMESTAMP_KEY_PASSWORD='xxx'
export DTUF_PASSWORD='xxx'
set -o history

rumprun-packages-dtuf.sh publish teksilo
```

(substituting `xxx` of course).

## Downloading binaries

You can download and run Rumprun package binaries from my Docker registry using
`dtuf`. No Docker client or image is required to download or run the binaries.

For example, on a Ubuntu machine you do the following to download and run
Node.js 4.3.0:

```shell
# TUF uses the cryptography package so you need these tools first:
sudo apt-get install build-essential libssl-dev libffi-dev python-dev python-pip

# Install dtuf. Make sure pip's ~/.local/bin directory is in your PATH.
pip install python-dtuf

# Point dtuf to my Docker registry
export DTUF_HOST=unikernel.teksilo.com:5000

# This is the public key for my Node repo. Normal due diligence applies.
pkey_url=https://raw.githubusercontent.com/davedoesdev/dtuf-keys/master/unikernel.teksilo.com/teksilo/node/root_key.pub

# Download Node metadata
curl $pkey_url | dtuf pull-metadata teksilo/node -

# Download v4.3.0
dtuf pull-target teksilo/node 4.3.0-x86_64-rumprun-netbsd-hw_generic > node

# Run it
qemu-system-x86_64 -enable-kvm -m 160 -kernel node -append '{"cmdline": "node"}'
```

Later on, to list subsequent updates you can run:

```shell
dtuf pull-metadata teksilo/node
```
