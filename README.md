# ctransfer

Easily work with anyone and manage your payments using Solana.

## Features

- [X] ~~Payments~~
- [ ] Invoices
- [ ] Bounties
- [ ] Agreements
- [ ] Disputes

## Components

- `programs/`: Solana programs.
- `services/app/`: Main application.
- `services/node/`: NodeJS server for using JS libraries.
- `services/site/`: Landing page, documentation, and blog.

## Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Nix](https://nixos.org/download.html) (w/ [flakes](https://nixos.wiki/wiki/Flakes) enabled)

## Setup

- Copy `.secret_` to `.secret` and fill in the values.
- Run `nix develop` to enter the Nix environment shell.
- Run `sh/setup.sh` to install dependencies.

## Related

- [cachet](https://github.com/mvkvc/cachet): On-chain reputation and voting system using Solana.
