#!/bin/bash

echo "Publishing nightly packages from $CONDA_BLD_PATH..."
for file in $CONDA_BLD_PATH/**/*.conda; do
    echo "Uploading $file..."
    magic run rattler-build upload prefix -c "mojo-libs-f0cii-nightly-test" "$file" --api-key=$PREFIX_API_KEY || true
done

rm $CONDA_BLD_PATH/**/*.conda
