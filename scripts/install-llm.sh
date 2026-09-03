#!/usr/bin/env bash

set -Eeuo pipefail

# Simon Willison's LLM CLI: https://github.com/simonw/llm

if ! command -v uv >/dev/null 2>&1; then
  command -v curl >/dev/null 2>&1 || {
    echo 'curl is required to install uv' >&2
    exit 1
  }

  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

uv tool install llm
