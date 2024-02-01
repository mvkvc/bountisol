# ctransfer

Work with anyone from anywhere.

## Components

- `app/`: Full-stack web application.
- `arbitrator/`: LLM inference service.
- `programs/`: Solana programs.
- `sh/`: Shell scripts.

## Developing

### Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Nix](https://nixos.org/download.html) (w/ [flakes](https://nixos.wiki/wiki/Flakes) enabled)

### Setup

- Copy `.env.*_` files to `.env.*` and fill in the values.
- Run `nix develop` to enter the Nix shell.
- Run `sh/setup.sh` to install dependencies.
