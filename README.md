# Goban

Goban (["Go board"](https://en.wikipedia.org/wiki/Go_equipment#Board)) is an environment bootstrapper for OmiseGO-related projects. Goban utilizes [Vagrant](http://www.vagrantup.com/) and [Ansible](http://www.ansible.com/) to provision a virtual machine that resembles production environment. Goban bootstraps the following components with the following dependencies:

| Component   | Vagrant Box | Erlang      | Elixir | PostgreSQL    | Node.js | Yarn   |
| ----------- | ----------- | ----------- | ------ | ------------- | ------- | ------ |
| **eWallet** | Debian 9₁   | OTP 20.2.2₂ | 1.6.5₂ | PostgreSQL 9₃ | 8.9.4₄  | 1.5.1₅ |

-   ₁ Using [bento/debian-9](https://app.vagrantup.com/bento/boxes/debian-9) Vagrant box for its provider support.
-   ₂ Using the release from [Erlang Solutions](https://www.erlang-solutions.com/resources/download.html). The installed version may be newer.
-   ₃ Running in a Docker container inside a VM using the [postgres:9](https://hub.docker.com/_/postgres/) image.
-   ₄ Using a pinned version from [NodeSource](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions).
-   ₅ Using a pinned version from [Yarn](https://yarnpkg.com/lang/en/docs/install/). The installed version may be newer.

## Requisites

The command will clone the components into its respective directories and provision the virtual machine.

### macOS

On macOS, the following packages are installed as part of bootstrap:

-   [Command Line Tools](https://developer.apple.com/xcode/)
-   [Homebrew](http://brew.sh/)
-   [Homebrew-Cask](https://caskroom.github.io/)
-   [Ansible](https://www.ansible.com/)
-   [Vagrant](https://www.vagrantup.com/)
-   [VirtualBox](https://www.virtualbox.org/)

## Usage

After you've cloned this repository, run:

```
$ ./bootstrap.sh
```

Refer to [Getting Started with Vagrant](https://www.vagrantup.com/intro/getting-started/index.html) for more information.

# Contributing

See [how you can help](.github/CONTRIBUTING.md).

# License

Goban is released under the [Apache License](https://www.apache.org/licenses/LICENSE-2.0).
