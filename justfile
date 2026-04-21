set working-directory := '.'

export RUST_BACKTRACE := "1"

# Build the crawler in release mode
build:
    cargo build --release

# Run the CLI with the provided arguments
run *args:
    cargo run -- {{args}}

# Run formatting
fmt:
    cargo fmt --all -- --check

# Run formatter and linter
lint:
    cargo clippy --all-targets --all-features -- -D clippy::all

# Run all tests
test: fmt lint
    cargo nextest run --all-features
