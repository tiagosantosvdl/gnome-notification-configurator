# Notification Configurator

This is [@tiagosantosvdl's fork](https://github.com/tiagosantosvdl/gnome-notification-configurator) of [upstream Notification Configurator](https://github.com/ExposedCat/gnome-notification-configurator), a GNOME Shell extension for notification positioning, filtering, timeouts and appearance. This fork is maintained by Codex and provides its own versioned extension packages.

[![Check and build](https://github.com/tiagosantosvdl/gnome-notification-configurator/actions/workflows/ci.yml/badge.svg)](https://github.com/tiagosantosvdl/gnome-notification-configurator/actions/workflows/ci.yml)
[![Release packages](https://github.com/tiagosantosvdl/gnome-notification-configurator/actions/workflows/release.yml/badge.svg)](https://github.com/tiagosantosvdl/gnome-notification-configurator/actions/workflows/release.yml)
[![GNOME 46–51](https://img.shields.io/badge/GNOME-46--51-blue.svg)](metadata.json)
[![License: GPL v3 or later](https://img.shields.io/badge/License-GPLv3%2B-blue.svg)](LICENSE)

## Project status

Current fork version: **2.6.2**; integer GNOME extension version: **23**. The fork adds versioned ZIP and Debian packages with SHA-256 checksums, separate CI and release workflows, consistent version metadata, and builds that do not install into the running desktop.

- Extension UUID: `notification-configurator@exposedcat`.
- Declared GNOME Shell support: **46–51**.
- Settings schema: `org.gnome.shell.extensions.notification-configurator`.
- Gettext domain: `notification-configurator@exposedcat`.

The fork retains upstream's UUID and settings schema, preserving saved preferences. The [GNOME Extensions listing](https://extensions.gnome.org/extension/8249/notification-configurator/) distributes upstream; use this fork's releases or source to install the fork. Declared compatibility is not a completed desktop test matrix. Runtime behavior needs separate verification after installation and a fresh login.

## Features

- Set horizontal and vertical notification positioning, including the bottom-right corner.
- Configure global rules and per-pattern overrides matched by case-insensitive regular expressions for application, title and body.
- Filter notifications and limit repeated notifications from the same application.
- Configure timeout, urgency, fullscreen behavior and notification-center grouping.
- Customize colors, text sizes, margins and the application title row.
- Configure how attention-requesting windows are handled.
- Export and import configuration and send sample notifications from preferences.

![Notification Configurator preview](assets/preview.png)

## Installation

Download packages from this fork's [GitHub Releases](https://github.com/tiagosantosvdl/gnome-notification-configurator/releases). Each release includes a ZIP, Debian package and `SHA256SUMS`.

Choose one installation method. A per-user copy shadows a system copy with the same UUID. Back up an existing per-user copy before removing it when switching to the Debian package. Upstream and this fork share a UUID and cannot run side by side.

### Debian / Ubuntu package

```sh
sudo apt install ./gnome-shell-extension-notification-configurator-tiagosantosvdl_2.6.2_all.deb
```

The architecture-independent package depends on GNOME Shell 46–51 and `gir1.2-adw-1`. It installs under `/usr/share/gnome-shell/extensions/notification-configurator@exposedcat/`.

Log out and back in after installation or an upgrade, then enable it:

```sh
gnome-extensions enable notification-configurator@exposedcat
```

### Per-user ZIP

```sh
gnome-extensions install --force ./notification-configurator@exposedcat-2.6.2.zip
```

Install libadwaita's introspection bindings (`gir1.2-adw-1` on Debian / Ubuntu) for preferences. Log out and back in, then enable the extension using the command above.

### Verify downloads

Place the packages and `SHA256SUMS` together, then run:

```sh
sha256sum -c SHA256SUMS
```

## Build from source

```sh
sudo apt install git gettext libglib2.0-bin make python3 dpkg-dev nodejs npm
git clone https://github.com/tiagosantosvdl/gnome-notification-configurator.git
cd gnome-notification-configurator
npm ci
make check
make release
```

CI uses Node.js 22. Build output goes to ignored `_build/`; release artifacts go to ignored `dist/`. Plain `make` builds without installing or activating the extension. Release output is:

- `dist/notification-configurator@exposedcat-2.6.2.zip`
- `dist/gnome-shell-extension-notification-configurator-tiagosantosvdl_2.6.2_all.deb`
- `dist/SHA256SUMS`

```sh
(cd dist && sha256sum -c SHA256SUMS)
sudo apt install ./dist/gnome-shell-extension-notification-configurator-tiagosantosvdl_2.6.2_all.deb
```

`make install` explicitly installs the per-user ZIP. `make clean` removes `_build/` and `dist/`. Source schemas, translations and generated JavaScript are included in both package formats; development dependencies are excluded.

## Configuration and logs

```sh
gnome-extensions prefs notification-configurator@exposedcat
journalctl --user --boot --output=short-iso --grep '[Nn]otification'
```

Set horizontal position to **Right** and vertical position to **Bottom** in preferences. Configuration is stored as JSON strings in the `global` and `patterns` schema keys. Existing preferences take precedence over deployment defaults. Review logs before sharing them.

The extension package keeps upstream defaults. Machine-specific defaults belong in the deployment configuration, rather than overwriting users' saved settings in the package.

## Verification

```sh
npm run check
glib-compile-schemas --strict --dry-run schemas
python3 -B -m unittest discover -s tests -p '*test.py'
make release
(cd dist && sha256sum -c SHA256SUMS)
git diff --check
```

Packaging tests verify matching ZIP/DEB extension payloads, checksums, root ownership, directory/file permissions, required files, version validation and prerelease ordering. TypeScript checking and package validation do not establish visible GNOME Shell behavior.

## Releases

Keep `package.json`, both root version entries in `package-lock.json`, and metadata `version-name` consistent. Metadata `version` remains a positive integer; `version-name` uses a space instead of a hyphen for prereleases.

Branch pushes and pull requests run checks and build downloadable artifacts. They do not create tags or publish releases. An explicit `v<version>` tag push or a published GitHub Release runs the release workflow, validates the version, builds packages and attaches them to the release. Manual release-workflow dispatch only builds downloadable artifacts.

Use new annotated tags. Do not move published tags or force-push. Verify workflow success, published assets and their checksums before distributing a release.

## Development and translations

Edit TypeScript under `src/`, schemas under `schemas/`, and `.po` translation sources under `po/`. Do not edit generated `_build/` files. Run `npm run translate` to update translation templates and review the changes.

`npm start` and `npm run start:container` explicitly install a per-user copy and start a nested development Shell. They are desktop-changing commands; use `make check` and `make release` for isolated validation.

## Support, credits and license

Report fork issues to [this repository's issue tracker](https://github.com/tiagosantosvdl/gnome-notification-configurator/issues). Include the extension version, GNOME version, installation method and relevant logs.

Credit to [ExposedCat and upstream contributors](https://github.com/ExposedCat/gnome-notification-configurator) for the extension, translations and artwork. The original project also provides [upstream support and sponsorship information](https://github.com/ExposedCat/gnome-notification-configurator#readme).

Licensed under [GPL-3.0-or-later](LICENSE). Preserve upstream copyright and license notices.
