#!/usr/bin/env bash
# Build the site into public/ with orgo.
set -euo pipefail
cd "$(dirname "$0")"

rm -rf public
orgo build content -o public --strict

# The incremental cache is a build input, not part of the site.
rm -f public/.orgo-cache.json
