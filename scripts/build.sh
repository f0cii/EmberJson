#!/bin/bash
set -e
magic run template
magic run rattler-build build -r recipes -c https://conda.modular.com/max -c conda-forge --skip-existing=all