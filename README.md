# Workspace

[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/pirafrank.svg?style=social&label=Follow%20%40pirafrank)](https://twitter.com/pirafrank)
[![Docker build](https://github.com/pirafrank/workspace/actions/workflows/docker.yml/badge.svg)](https://github.com/pirafrank/workspace/actions/workflows/docker.yml)
[![Linux](https://github.com/pirafrank/workspace/actions/workflows/full_setup_testing.yml/badge.svg)](https://github.com/pirafrank/workspace/actions/workflows/full_setup_testing.yml)
[![macOS](https://github.com/pirafrank/workspace/actions/workflows/macos_testing.yml/badge.svg)](https://github.com/pirafrank/workspace/actions/workflows/macos_testing.yml)
[![docker_pulls](https://img.shields.io/docker/pulls/pirafrank/workspace.svg)](https://hub.docker.com/repository/docker/pirafrank/workspace)
[![GitHub tag](https://img.shields.io/github/tag/pirafrank/workspace?include_prereleases=&sort=semver&color=blue)](https://github.com/pirafrank/workspace/releases/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/pirafrank/workspace/blob/main/LICENSE.md)

A workspace-in-a-container project.

`workspace` is a portable environment in a Docker container, powered by my work and personal dotfiles setup. You can test it straight away:

```sh
docker run -it --name=workspace pirafrank/workspace:bundle
```

## Before we start

**Important : Renamed repository!**

This repository is was previously named `dotfiles` and has been renamed to `workspace`. Dotfiles that once were part of this repo have moved [to their own](https://github.com/pirafrank/dotfiles). Now they are here as a submodule.

I went this way to have the chance to further evolve the workspace project away from dotfiles, keeping both consistent commit history and releases made until today. On the other hand, the `dotfiles` repo has a rewritten commit history.

## What's included

- Ubuntu 20.04-based
- `zsh` + zprezto as default shell
- [dotfiles](https://github.com/pirafrank/dotfiles)
- vim as IDE
- cloud clients and tools
- Java + mvn
- node.js
- Python 3
- Golang
- Rust
- Ruby
- various utils
- optional Docker CLI client
- support for different env versions
- ...and more.

## Supported platforms

Docker images work anywhere Docker images run, from your PC to Kubernetes, to CaaS services.

While almost all scripts and configurations in this repo will also work on non-Debian distros, `setup.sh` script in root is designed for the Debian-based ones. That said, the only differences shoud rely only on a few package and binary names.

macOS + macports is partially supported. I try to make `workspaces` and `setups` scripts work there too, yet macOS is not my daily driver anymore and the Apple Silicon transition adds spice to the receipe.

## Usage

Choose one of the options below:

1. run the containerized workspace (Docker required)
2. run the full `setup.sh` script on a vanilla environment (e.g. a new VPS install)
3. setup specific features (Java+mvn, node.js, etc.) using the scripts in `setups` and `workspaces` dirs. Those scripts are also used to build the workspace Docker images.

### 1. Workspace-in-a-container

You can run the workspace-in-a-container in many occasions.

- easy and fast setup of CLI environment e.g. in a VPS
- Works in CaaS services like Azure Container Instances and [Blink Build](https://beta.blink.build/)
- great for already-configure, fast, ephimeral dev environment
- you name it...

Please check the *workspace-in-a-container* section for further info.

### 2. Full setup

*Debian-based distros only.*

A full setup involves programs installation of programs, their dependencies, download of dotfiles and creation of symlinks. It is meant to setup a vanilla environment. I keep `setup.sh` aligned with the `Dockerfile` used to build the Docker workspace baseimage. The setup comes in two flavors, with and without user creation:

```sh
curl -sSL https://github.com/pirafrank/workspace/raw/main/create_user.sh -o create_user.sh && chmod +x create_user.sh
curl -sSL https://github.com/pirafrank/workspace/raw/main/setup.sh -o setup.sh && chmod +x setup.sh
./create_user.sh
./setup.sh
```

Run the one that best fits your needs. Remember to always check the content of scripts you're about to execute before running them!

### 3. Partial setup

Setup scripts in `setups` and `workspaces` dirs are meant to be executed manually on Linux or macOS, or to build Docker Image workspaces (read below). They assume `~/dotfiles` exists. If you have dotfiles in another dir, please symlink it to `~/dotfiles`.

Core setup uses zsh and zprezto. Files for oh-my-zsh config are available, but I don't use/update them anymore.

### Further notes

`~/.zsh_custom` is automatically sourced if it exists, and `~/bin2` is automatically added to `$PATH`. Both are not part of the repo and can be used to add your-own or machine-specific customizations and other executables.

That's all, there is no real how-to actually. For more info just look at the code.

## A workspace-in-a-container

The main focus is to make Workspace a great workspace-in-a-container setup.

### Available Docker images

The aim is to create a disposable development environment taking advantage of Docker. Images are publicly available on [Docker Hub](https://hub.docker.com/r/pirafrank/workspace) in various flavors. They are:

- `pirafrank/workspace`: base image on which the others are based on. It contains dotfiles, various CLI utils and shell setup
- `pirafrank/workspace:bundle`: bundle of the ones below. Use `workspace_version` inside the container to know about what's bundled.

Dockerfiles available to build:

- `pirafrank/workspace:java`: Java + `mvn`
- `pirafrank/workspace:node`: `nvm` + node.js
- `pirafrank/workspace:python3`: `pyenv` + Python 3
- `pirafrank/workspace:ruby`: `rvm` + Ruby
- `pirafrank/workspace:rust`: latest Rust version and its toolchain
- `pirafrank/workspace:go`: Golang workspace

All workspaces setups are in userspace.

### Versioning

The following apply:

- Docker image builds are made from `main` branch only. Builds are triggered only if changes are made to source files (e.g. it skips changes to pipeline files, README, etc.).
- Only after a successful pipeline run, builds are pushed to docker registries and lightweight tags are added to the repository. Those tags have format: `YYYYMMDD.CommitHash`.
- After a meaniful set of changes are added to repository, I tag one of those lightweight-tagged commits with a signed annotated one using semantic versioning format.
- By the way, although versioning plays its part in pulling a specific version, `latest` and `bundle` tags are meant to be used as the latest stable images.

### OpenSSH Server

Workspace images now ship with openssh-server, so you can deploy your workspace on a CaaS provider and SSH to it.

By default the openssh-server won't start and an interactive shell will launch, this means that if you won't start the workspace from an interactive shell it will exit immediately!

If you deploy on a CaaS and want to leverage openssh-server, just pass these two ENV VARs upon container start:

- `SSH_SERVER`, any value is ok (e.g. 'true'), just don't leave it null;
- `SSH_PUBKEYS`, it holds the pubkey you want to use to connect via SSH (only one pubkey supported atm).

It listens to `0.0.0.0:2222`.

For example:

```sh
docker run -it --rm \
    -p "2222:2222" \
    -e SSH_SERVER=true -e SSH_PUBKEYS="ssh-ed25519 AAAA... francesco@work" \
    pirafrank/workspace:latest
```

if you have multiple SSH pub keys:

```sh
# from file
export SSHKEYS=`cat file_with_many_keys`
# from URL
export SSHKEYS=`curl -sSL some.url/with/keys/sshkeys`
# then in command above
... -e SSH_SERVER=true -e SSH_PUBKEYS="${SSHKEYS}" ...
```

or via run script:

```sh
bash run-workspace.sh latest '--rm -e SSH_SERVER=true -e SSH_PUBKEYS="ssh-ed25519 AAAA... francesco@work"'
```

Check `pre_start.zsh` and `start.sh` scripts for further info.

## Usage scenarios

You can run your workspace in many ways. Check the examples in `scenarios` dir.

### Azure Container Instances

Below an example script to run a workspace in Azure Cloud Shell.

```sh
export SSHKEYS=`curl -sSL gist.github.com/some/secret/gist`
nohup az container create \
  --resource-group YOUR_RESOURCE_GROUP \
  --name SOME_CONTAINER_INSTANCE_NAME \
  --image pirafrank/workspace:bundle \
  --location westeurope \
  --os-type Linux \
  --cpu 1 \
  --memory 2.0 \
  --dns-name-label SOME_CONTAINER_INSTANCE_NAME \
  -e SSH_SERVER='true' SSH_PUBKEYS="${SSHKEYS}" \
    GITUSERNAME='John Doe' GITUSEREMAIL='john@doe.net' \
  --ports 2222 &
```

And because the Container Instance has a name, you can easily stop it:

```sh
az container delete --resource-group YOUR_RESOURCE_GROUP --name SOME_CONTAINER_INSTANCE_NAME
```

Tip: You can save those scripts in your Cloud Shell home dir for easy recovery, e.g. to launch them on-the-go from Cloud Shell in Azure mobile apps.

### AWS Fargate

*Coming soon...*

### You own Kubernetes

For the sake of brevity, please check files in the `scenarios/k8s` dir.

### Blink Build

*Build* is a new service being built by the guys behind [Blink Shell](https://twitter.com/BlinkShell/), the best SSH and mosh client for iOS and iPadOS. It's currently in beta and allows you to SSH into any container publicly available without taking care of the underlying infrastructure, network or firewall. And it's fully integrated in Blink Shell. [I have started tinkering](https://twitter.com/pirafrank/status/1423633599459471361) with it and I have to say it's a great match with my *workspace* for a portable dev environment!

First setup: authenticate and turn on the VM (aka the *machine*)

```sh
build device authenticate
build status
build machine start
build machine status
build ssh-key add
build ssh-key list
```

then bring the workspace up and enter it

```sh
build up --image pirafrank/workspace:bundle bundle
build ssh bundle
```

*Build* is currently available in the [community edition](https://community.blink.sh/).

For more information, run the commands with the `--help` flag.

## Build and run your own

### Build an image

Run `./build.sh all` to build all images.

Add anything you want to exec right before container launch to `pre_start.zsh`.

You can also change the commands executed at startup by editing the `start.sh` script.

### Run an image

Use `run_workspace.sh` to do so. Clone the repo or just download the script.

The script will default to `pirafrank/workspace` images, you just need to specify the tag name.

For example:

```sh
# to run the baseimage
./run-workspace.sh latest
# or to run the java11 one
./run-workspace.sh java11
# or to run it as a disposable container
./run-workspace.sh java11 --rm
# or to name it
./run-workspace.sh java11 '--name somename --rm'
```

## License

Code in this repo is given away for free, as-is and with NO WARRANTY as per the MIT license.

By the way, if something really blows your mind, I'll be happy if you get in touch with me. I always appreciated feedback!

Enjoy!
