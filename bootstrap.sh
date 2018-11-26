#!/bin/sh

PLATFORM=$(uname)
BASE_DIR=$(cd "$(dirname "$0")/" || exit; pwd -P)
CONFIG_DIR="$BASE_DIR/.git/goban"
CONFIG_FILE="$CONFIG_DIR/config"
VAGRANT_FILE="$BASE_DIR/Vagrantfile"

#
# Utilities
#

printn_error() {
    printf "\\033[0;31m%s\\033[0;0m\\n" "$1"
}

printn_head() {
    printf "\\033[1;37m%s\\033[0;0m\\n" "$1"
}

printn_notice() {
    printf "\\033[1;37m%s\\033[0;0m\\n" "$1"
}

printn_ok() {
    printf "\\033[0;32m%s\\033[0;0m\\n" "$1"
}

printn_wait() {
    printf "\\033[0;33m%s\\033[0;0m\\n" "$1"
}


#
# Sanity check
#

if [ ! -f "$VAGRANT_FILE" ]; then
    printn_error "The base directory does not appeared to be valid."
    printf "Current value of \\033[1;32mBASE_DIR\\033[0;0m is \\033[1;36m%s\\033[0;0m\\n" "$BASE_DIR"
    exit 1
fi

if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p "$CONFIG_DIR"
fi

cd "$BASE_DIR" || exit


#
# Configuration
#

init_config() {
    VAGRANT_PROVIDER=virtualbox
    VAGRANT_NFS=no
}

# shellcheck source=.git/goban/config disable=SC1091
read_config() {
    if [ -f "$CONFIG_FILE" ]; then
        . "$CONFIG_FILE"
    fi
}

print_usage() {
    printf "Usage: %s [-%s]\\n" "$0" "$OPTS"
    printf "\\n"
    printf "	 -h	    Print this help.\\n"
    printf "	 -v	    Initialize environment using VMware Desktop or VMware Fusion.\\n"
    printf "	 -n	    Initialize vagrant mount using NFS.\\n"
    printf "	 -r	    Reset the configuration.\\n"
    printf "\\n"
    printf "Default projects:\\n"
    printf "\\n"
    printf "	 These projects are setup by default when no arguments are given to bootstrap.\\n"
    printf "	 They are the minimal set of projects required to get the test mode running.\\n"
    printf "\\n"
    printf "	 \\033[1;1mewallet\\033[0;0m    The eWallet server.\\n"
    printf "\\n"
}

enable_vmware() {
    case "$PLATFORM" in
        Darwin* ) VAGRANT_PROVIDER=vmware_fusion;;
        * )       VAGRANT_PROVIDER=vmware_desktop;;
    esac
}

enable_nfs() {
    VAGRANT_NFS=yes
}

reset_config() {
    init_config
    rm "$CONFIG_FILE"
}

OPTS=hvnr
init_config
read_config

ARGS=$(getopt $OPTS "$*" 2>/dev/null)

# shellcheck disable=SC2181
if [ $? != 0 ]; then
    print_usage
    exit 1
fi

# shellcheck disable=SC2086
set -- $ARGS

while true; do
    case "$1" in
        -h ) print_usage; exit 2;;
        -v ) enable_vmware; shift;;
        -n ) enable_nfs; shift;;
        -r ) reset_config; shift;;
        *  ) break;;
    esac
done

case "$PLATFORM" in
    Darwin* )
        if [ "$VAGRANT_PROVIDER" = "vmware_desktop" ]; then
            printn_error "VMware Desktop is only supported on Darwin."
            printf "Please reset the configuration and re-run bootstrap script without -v.\\n"
            exit 1
        fi
        ;;
    FreeBSD* )
        if [ "$VAGRANT_PROVIDER" != "virtualbox" ]; then
            printn_error "Only VirtualBox is supported on FreeBSD."
            printf "Please reset the configuration and re-run bootstrap script without -v.\\n"
            exit 1
        fi
        ;;
    Linux* )
        if [ "$VAGRANT_PROVIDER" = "vmware_fusion" ]; then
            printn_error "VMware Fusion is only supported on Darwin."
            printf "Please reset the configuration and re-run bootstrap script without -v.\\n"
            exit 1
        fi
        ;;
esac

cat <<-EOF > "$CONFIG_FILE"
VAGRANT_PROVIDER=$VAGRANT_PROVIDER
VAGRANT_NFS=$VAGRANT_NFS
EOF


#
# Commons
#

common_config() {
    printn_head "Bootstrapping with the following configurations:"
    printf "VAGRANT_PROVIDER: \\033[1;37m%s\\033[0;0m\\n" "$VAGRANT_PROVIDER"
    printf "VAGRANT_NFS: \\033[1;37m%s\\033[0;0m\\n" "$VAGRANT_NFS"
    printf "\\n"
}

clone_repository() {
    if [ ! -d "$1" ]; then
        printn_wait "Cloning $1..."
        if ! git clone "$2" "$1" 2>&1 |sed "s/^/    /"; then
            printn_error "An error occurred while cloning $1"
            exit 1
        fi
    else
        printn_ok "$1 is already cloned."
    fi
}

common_clone() {
    printn_head "Cloning repositories:"
    clone_repository ewallet ssh://git@github.com/omisego/ewallet.git
    printf "\\n"
}

common_vagrant() {
    printn_head "Initializing Vagrant boxes:"

    if [ ! -d "$BASE_DIR/.vagrant" ]; then
        printf "This step may take a while to complete for the first time.\\n"
        printf "Grab some coffee or read \\033[1;37mhttps://www.vagrantup.com/docs/\\033[0;0m while waiting.\\n"
    fi

    if ! vagrant up --provider "$VAGRANT_PROVIDER" 2>&1 |sed "s/^/  /"; then
        printn_error "An error occurred while initializing Vagrant boxes."
        exit 1
    fi

    printf "\\n"
}

common_done() {
    printn_head "Done bootstrapping environment."
    printf "All virtual machines should be running.\\n"
    printf "  Run \\033[1;36mvagrant ssh\\033[0;0m to access ewallet box.\\n"
    printf "  Run \\033[1;36mvagrant halt\\033[0;0m to shutdown everything.\\n"
    printf "  Run \\033[1;36mvagrant up\\033[0;0m for subsequent boot.\\n"
    printf "  Run \\033[1;36mvagrant provision\\033[0;0m to re-provision the virtual machine.\\n"
    printf "  Run \\033[1;36mvagrant destroy\\033[0;0m to destroy the virtual machine.\\n"
    printf "Refer to the documentation of each project for further instructions.\\n"
}


#
# Darwin
#

bootstrap_darwin() {
    common_config

    export PATH=/usr/local/bin:$PATH
    printn_head "Performing preflight checks:"

    printn_wait "Determining CLI tools status. You may need to enter root password."
    if xcode-select --install 2>/dev/null; then
        printn_notice "Prompting to accept CLI tools license:"
        if ! sudo xcodebuild -license accept; then
            printn_error "An error occured while trying to accept CLI tools license."
            exit 1
        fi
    else
        printf "\\033[1A\\r\\033[K"
        printn_ok "CLI tools is already installed."
    fi

    if hash brew 2>/dev/null; then
        printn_ok "Homebrew is already installed."
    else
        printn_wait "Installing Homebrew..."
        if ! /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 2>&1 |sed "s/^/    /"; then
            printn_error "An error occured while installing Homebrew."
            exit 1
        fi
    fi

    if hash vagrant 2>/dev/null; then
        printn_ok "Vagrant is already installed."
    else
        printn_wait "Vagrant is not installed. Installing..."
        if ! brew cask install vagrant 2>&1 |sed "s/^/    /"; then
            printn_error "An error occured while installing Vagrant."
            exit 1
        fi
    fi

    case $VAGRANT_PROVIDER in
        vmware_fusion)
            if [ -d "/Applications/VMware Fusion.app" ]; then
                printn_ok "VMware Fusion is already installed."
            else
                printn_error "VMware Fusion and VMware Vagrant Plugin must be installed manually."
                printf "For more information, see \\033[1;37mhttps://www.vagrantup.com/vmware/\\033[0;0m\\n"
                exit 1
            fi
            ;;
        virtualbox)
            if [ -d "/Applications/VirtualBox.app" ]; then
                printn_ok "VirtualBox is already installed."
            else
                printn_wait "VirtualBox is not installed. Installing..."
                if ! brew cask install virtualbox 2>&1 |sed "s/^/    /"; then
                    printn_error "An error occured while installing VirtualBox."
                    exit 1
                fi
            fi
            ;;
        *)
            printn_error "Unsupported provisioner: $VAGRANT_PROVIDER"
            exit 1
            ;;
    esac

    printf "\\n"
    common_clone
    common_vagrant
    common_done
}


#
# Main
#

case "$PLATFORM" in
    Darwin* ) bootstrap_darwin;;
    * )
        printn_error "Could not start bootstrap script: $PLATFORM is unsupported."
        printf "If you wish to continue, you may do so using a manual method:\\n"
        printf "1. Clone the \\033[1;37mhttps://github.com/omisego/ewallet\\033[0;0m into ewallet/ directory.\\n"
        printf "2. Install Vagrant and run \\033[1;36mvagrant up\\033[0;0m."
        printf " See also \\033[1;37mhttps://www.vagrantup.com/\\033[0;0m\\n"
        exit 1
        ;;
esac
