# macOS-bootstrap

A simple script that brings macOS system to a desired state. May be useful to run
after a fresh installation or on a regular basis to reconcile the OS.

Basically, the script tweaks the OS and installs and updates apps and packages.

## Usage

### Fresh macOS installation

1. Open Terminal app.

2. Install [Homebrew](https://brew.sh)

3. Install a fresh version of bash to replace outdated macOS builtin bash:

    ```shell
    brew install bash
    ```

4. Run bootstrap with the profile name:

    ```shell
    ./bootstrap <PROFILE_NAME>
    ```

### Reconcile

Run bootstrap, the profile name is optional:

 ```shell
 ./bootstrap [PROFILE_NAME]
 ```

### Profiles

Profile configuration files are located in [profiles](profiles/) under the name
of the profile.

**brew_cask_pinned.list** - if the file exists, the script will pin the casks
listed in this file.

## Docs

[docs](docs/) directory contains some useful info on advanced macOS topics.

## License

[MIT](https://github.com/hypnoglow/macOS-bootstrap/blob/master/LICENCE.md)
