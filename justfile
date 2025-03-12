default:
    @just --list

vendor-providers:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p priv/
    curl -sL https://oembed.com/providers.json > priv/providers.json
