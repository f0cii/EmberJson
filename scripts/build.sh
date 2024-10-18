#!/bin/bash
set -e
magic run template
# export REPO_URL=https://conda.modular.com/max
echo "Using repository URL: $REPO_URL"
magic run rattler-build build -r recipes -c $REPO_URL -c conda-forge --skip-existing=all