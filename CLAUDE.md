# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`mq-crawler` is a web crawler component of the [mq](https://mqlang.org) ecosystem. It crawls websites, converts HTML to Markdown, and optionally processes results with mq-lang queries. It supports concurrent crawling and three HTTP backend strategies: simple `reqwest`, WebDriver via `fantoccini`, and headless Chrome via `chromiumoxide` (CDP).

## Build & Test Commands

```bash
just build          # Release build
just run <args>     # Run the CLI (e.g., just run -- --help)
just fmt            # cargo fmt --check
just lint           # cargo clippy
just test           # fmt + lint + cargo nextest run

# Direct cargo commands
cargo build                     # Dev build
cargo build --release           # Release build
cargo test                      # Run tests
cargo test -- <test_name>       # Single test
cargo nextest run               # Tests via nextest
```

## Architecture

**Source files** (`src/`):

| File | Purpose |
|---|---|
| `main.rs` | CLI entry point. Parses args via `clap`, selects HTTP backend, creates and runs `Crawler`. |
| `lib.rs` | Re-exports `crawler` and `http_client` modules. |
| `http_client.rs` | `HttpClient` enum: `Reqwest` (simple HTTP), `Fantoccini` (WebDriver), `Chromium` (headless Chrome via CDP). |
| `crawler.rs` | Core crawl logic: queue management, concurrency via `Semaphore`, HTML-to-Markdown, link extraction, optional mq-lang query. |

**Data flow**: URL → `HttpClient` (fetch HTML) → `scraper` (parse HTML, extract links) → `mq_markdown` (HTML→Markdown) → optional `mq_lang` query → output (stdout or files).

**Key dependencies**: `tokio`, `scraper`, `chromiumoxide`/`fantoccini`, `reqwest`, `dashmap`/`crossbeam`, `mq-lang` + `mq-markdown` (crates.io).

## Coding Conventions

- **Rust edition 2024**, toolchain `1.95.0` (pinned in `rust-toolchain.toml`)
- **Formatting**: `cargo fmt --all -- --check` (max width 120 per `rustfmt.toml`)
- **Linting**: `cargo clippy --all-targets --all-features -- -D clippy::all`
- **Error handling**: `miette` for user-facing errors, no panics, return `Result`
- **Testing**: `rstest` for table-driven tests, `httpmock` for HTTP mocking
- **Visibility**: Default to `pub(crate)` or tighter

## Commit Messages

```
<type>(<scope>): <description>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci` (with emoji prefixes).

## License

MIT
