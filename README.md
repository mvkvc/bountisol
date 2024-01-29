# ctransfer

Work with anyone from anywhere.

## Features

- [X] ~~Payments~~
- [ ] Invoices
- [ ] Disputes
- [ ] Bounties

## Components

- `programs/`: Solana programs.
- `app/`: Main application.
- `sh/`: Shell scripts.

## Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Nix](https://nixos.org/download.html) (w/ [flakes](https://nixos.wiki/wiki/Flakes) enabled)

## Setup

- Copy `.secret_` to `.secret` and fill in the values.
- Run `nix develop` to enter the Nix environment shell.
- Run `sh/setup.sh` to install dependencies.
