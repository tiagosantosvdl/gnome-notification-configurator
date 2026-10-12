#!/usr/bin/env bash
set -euo pipefail
for source in po/*.po; do
    language=$(basename "$source" .po)
    destination="_build/locale/$language/LC_MESSAGES"
    mkdir -p "$destination"
    msgfmt "$source" -o "$destination/notification-configurator@exposedcat.mo"
done
