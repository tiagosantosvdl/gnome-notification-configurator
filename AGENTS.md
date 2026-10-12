# Notification Configurator maintenance

## Working agreement

The standing user instruction is:

> Always discuss the issues only, never makes unless I explicitely require.

Investigate and discuss bug reports first. Explicit implementation requests authorize their corresponding edits and validation. Complete authorized work without repeatedly asking for permission. Commit, push, tag, publish or install only when requested. Keep repository edits, test-VM changes and changes to the running machine separate. Never log out the user or restart their live GNOME Shell automatically. Do not delegate unless explicitly requested.

Maintain this guide autonomously as a practical reference, replacing stale information rather than adding a chronological activity log. Distinguish verified facts from hypotheses and validation limits. Guide updates do not authorize implementation or deployment changes. Check Git status and preserve unrelated work.

This is a public repository. Never include credentials, tokens, passwords, personal data, private application contents or sensitive logs. Use relative paths and generic machine examples. Review documentation before publishing.

## Repository and source

- Fork: https://github.com/tiagosantosvdl/gnome-notification-configurator; branch `main`.
- Upstream: https://github.com/ExposedCat/gnome-notification-configurator; remote `upstream`.
- Fork remote `origin` uses SSH. Preserve upstream history.
- UUID and gettext domain: `notification-configurator@exposedcat`, shared with upstream.
- Schema: `org.gnome.shell.extensions.notification-configurator`. Preserve saved preferences and migration compatibility.
- Source is TypeScript using GJS ES modules and `@girs` bindings under `src/`.
- `src/extension.ts` owns extension lifecycle; `src/shell/notifications.ts` integrates adapters. `src/managers/` handles Shell, source and notification-daemon behavior.
- `src/utils/settings.ts` normalizes JSON global configuration and pattern overrides. Preferences and configuration import/export live under `src/preferences/` and `src/utils/sync.ts`.
- Schemas are under `schemas/`; translation sources are under `po/`; artwork is under `assets/`.
- License: GPL-3.0-or-later, in `LICENSE`. Preserve upstream copyright, license, artwork and translation credit.

Use type-safe, concise TypeScript. Prefer `type` over `interface`, descriptive names, `for of` and static imports. Avoid unnecessary comments. Packaging regression tests are part of the fork's CI conventions. Edit source rather than installed copies, `_build/`, `dist/` or dependencies. Inspect sibling forks when useful; modify them only within the requested scope.

## Builds and validation

CI uses Node.js 22 with `npm ci`. `package-lock.json` is committed. Build dependencies come from the lockfile; do not rewrite runtime source to silence type errors without investigating.

```sh
npm ci
make check
make release
(cd dist && sha256sum -c SHA256SUMS)
git diff --check
```

- Plain `make` builds without installation. `make check` type-checks source, validates schemas and runs packaging tests.
- `scripts/cli build` compiles TypeScript to `_build/`, stages metadata/license/schema files, strictly compiles schemas and compiles translations.
- `scripts/package-release.py` emits versioned ZIP and Debian artifacts plus checksums into `dist/`.
- Generated files and dependencies are ignored. `make clean` deletes `_build/` and `dist/`; retain downloaded release evidence before cleaning.
- ZIP and DEB extension payloads must match byte-for-byte. Debian payload and control archives use root ownership, directories 0755 and files 0644. No standalone runtime executables or maintainer scripts are currently included. Update modes and tests if that changes.
- `tests/release_package_test.py` exercises actual packaging, checksums, metadata, version validation, prerelease ordering, ownership and permissions without installing.
- Run `node --input-type=module --check` against generated JavaScript for syntax validation. Build all translations and inspect the package contents as well.
- Use `python3 -B` to avoid caches. Do not delete unrelated caches or change live dconf to make checks pass.
- `npm run format` rewrites source. `npm start`, container development and `make install` explicitly install a per-user copy; do not use them merely for validation.

## Versions and CI/CD

Release version is `2.6.2`; integer GNOME version is `23`. Declared Shell support is 46–51, inherited from current upstream source. Type and packaging validation do not establish compatibility across that full range. The upstream checkout initially had a stale lockfile version and a removed TypeScript compiler option; the fork aligns version fields and removes that option.

`package.json` version, lockfile root/package versions, and metadata `version-name` must match. Keep metadata `version` a positive integer and increment it for extension updates. Prerelease names use a space in GNOME `version-name` and a hyphen in tags; Debian versions use `~` so prereleases sort before stable releases. Tag names must be `v<release-version>`.

`.github/workflows/ci.yml` checks branch pushes and pull requests, then builds downloadable artifacts. It never creates tags or releases. `.github/workflows/release.yml` builds on explicit tag pushes, published-release events and manual dispatch. Only tag/release events publish; manual dispatch builds artifacts only. Build jobs have read-only repository permissions; only the publish job has `contents: write`.

For an authorized release:

1. Align version fields and README examples, run checks and inspect the diff.
2. Verify the branch, remote head and tag availability. Create a new annotated tag. Push branch and tag atomically; never force-push or move published tags.
3. Verify the release workflow and actual ZIP, DEB and checksum assets. A successful push is not evidence of publication.
4. Download published artifacts under ignored `dist/published-<version>/`, verify their checksums, package metadata and ZIP/DEB payload equality. CI timestamps can make local bytes differ.

README installation, badges and support links belong to this fork. Identify Codex maintenance, retain upstream credit and explain that the GNOME Extensions listing distributes upstream. Deployment-specific positioning and notification rules belong in the consuming repository, not in hard-coded user settings here.

## Installation and runtime limits

The Debian package is `gnome-shell-extension-notification-configurator-tiagosantosvdl` and installs under `/usr/share/gnome-shell/extensions/notification-configurator@exposedcat/`. A per-user copy with the same UUID takes precedence. Preserve preferences and back up unmanaged copies when switching installation methods. Inspect the apt transaction, installed metadata, ownership and files when installation is explicitly requested. Advise a fresh login; do not trigger it.

Global and pattern configuration are JSON strings in `global` and `patterns`. Legacy schema keys remain for migrations. Positioning supports independent horizontal and vertical placement. Preserve cleanup of injected methods, signals, timers and UI styling on disable. Verify behavior with other Shell extensions when changing banner positioning.

The source currently uses the global timeout in `TimeoutAdapter`; a pattern timeout override alone does not prove a per-pattern banner timeout. Critical notification urgency and GNOME's no-timeout behavior must remain intact. Deployment notifications should avoid rate limiting and forced normal urgency. Verify visible persistence, manual lock/unlock recovery and bottom-right positioning separately in an authorized desktop session.
