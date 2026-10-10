input-c-headers-path := "openfx/include"
output-data-path := "data/generated"

generate-all: generate-data

generate-data:
    rm -rf {{ output-data-path }}
    mkdir -p {{ output-data-path }}
    cargo run --manifest-path ./openfx-datagen/Cargo.toml --package openfx-datagen \
        --bin cli -- gen-data --input-c-headers {{ input-c-headers-path }} \
        --output-bindings-data "{{ output-data-path }}/bindings" \
        --output-metadata "{{ output-data-path }}/metadata"

detect-stale-generated-contents: generate-all
    #!/usr/bin/env sh
    if ! git diff --quiet; then
        echo "Stale generated contents detected."
        echo "Please run \`just generate-all\` and commit the changes."
        echo "stale files:"
        git --no-pager diff --name-only
        exit 1
    fi
