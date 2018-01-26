# Goban

Goban (["Go board"](https://en.wikipedia.org/wiki/Go_equipment#Board)) is an environment bootstrapper for OmiseGO-related projects. Goban utilizes [Vagrant](http://www.vagrantup.com/) and [Ansible](http://www.ansible.com/) to provision a virtual machine that resembles production environment. Goban bootstraps the following components with the following dependencies:

| Component    | Vagrant Box | Erlang      | Elixir   | PostgreSQL    |
| ------------ | ----------- | ----------- | -------- | ------------- |
| **eWallet**  | Debian 9₁   | OTP 20.2.2₂ | 1.6.0₂   | PostgreSQL 9₃ |

* ₁ Using [bento/debian-9](https://app.vagrantup.com/bento/boxes/debian-9) Vagrant box for its provider support.
* ₂ Using the latest stable from [Erlang Solutions](https://www.erlang-solutions.com/resources/download.html). The installed version may be newer.
* ₃ Running in a Docker container inside a VM using the [postgres:9](https://hub.docker.com/_/postgres/) image.

## Prerequisites

Goban rely on [SSH agent forwarding](https://developer.github.com/v3/guides/using-ssh-agent-forwarding/) to be able to clone private repositories that are used as dependencies. **Please make sure ssh-agent is running, and key is added to the agent prior to running bootstrap.** To add the key to SSH agent:

```
$ ssh-add
```

To check whether keys are properly added:

```
$ ssh-add -l
```

## Usage

After you've cloned this repository, run:

```
$ bin/bootstrap
```

The command will clone the components into its respective directories and provision the virtual machine.

### macOS

On macOS, the following packages are installed as part of bootstrap:

* [Command Line Tools](https://developer.apple.com/xcode/)
* [Homebrew](http://brew.sh/)
* [Homebrew-Cask](https://caskroom.github.io/)
* [Ansible](https://www.ansible.com/)
* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)

## Usage

Refer to [Getting Started with Vagrant](https://www.vagrantup.com/intro/getting-started/index.html) for more information.