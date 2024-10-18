#!/bin/bash

echo "Publishing nightly packages from $CONDA_BLD_PATH..."
for file in output/**/*.conda; do
    echo "Uploading $file..."
    magic run rattler-build upload prefix -c "$PREFIX_CHANNEL" "$file" --api-key=$PREFIX_DEV_API_KEY || true
done
echo "Publishing completed."
