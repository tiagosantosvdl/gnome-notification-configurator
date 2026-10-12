.DEFAULT_GOAL := build

.PHONY: build check release install clean

build:
	bash scripts/cli build

check:
	npm run check
	glib-compile-schemas --strict --dry-run schemas
	python3 -B -m unittest discover -s tests -p '*test.py'

release: build
	python3 -B scripts/package-release.py --build-dir _build

install: release
	gnome-extensions install --force "dist/$$(node -p 'const m = require("./metadata.json"); m.uuid + "-" + m["version-name"].replaceAll(" ", "-") + ".zip"')"

clean:
	rm -rf _build dist
