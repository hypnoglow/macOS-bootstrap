# macOS-bootstrap

A simple script that brings macOS system to a consistent state
by tweaking and installing apps and packages, e.g. after a fresh installation.

## Usage

    ./bootstrap

## Fresh macOS installation

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

## License

[MIT](https://github.com/hypnoglow/macOS-bootstrap/blob/master/LICENCE.md)
