# ctransfer

Work with anyone from anywhere.

## Demo

WIP

## Features

- [X] Track/request payments
- [ ] Bounties
- [ ] Invoices
- [ ] Disputes

## Components

- `programs/`: Solana programs.
- `app/`: Full-stack web application.
- `sh/`: Shell scripts.

## Developing

### Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Nix](https://nixos.org/download.html) (w/ [flakes](https://nixos.wiki/wiki/Flakes) enabled)

### Setup

- Copy `.secret_` to `.secret` and fill in the values.
- Run `nix develop` to enter the Nix environment shell.
- Run `sh/setup.sh` to install dependencies.
