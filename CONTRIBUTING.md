# Contributing Guidelines

## Repo Overview

This repository contains instructions for Docker to set up 2 containers with data and soda project stub files as well as convenience installation scripts to help users spin up those docker containers with ease.

- `/scripts/`: contains scripts and packaging to help users spin up and enter docker containers with ease.
- `/data/ny_bus_breakdown/`: contains a CSV file of the demo dataset. It is used by the `init.sql` files in `/scripts/`
- `/workspace/new_york_bus_breakdowns_demo/`: contains the example soda-sql project files.

# Formatting & Linting

This repo enforces a few formatting rules via [pre-commit](https://pre-commit.com/).

If you are planning to make changes to this repo please make sure you have `pre-commit` installed on your machine and that `pre-commit` is set up for this project.
Here's how you set it up:

- install pre-commit (in a Python virtual env or globally): `pip install pre-commit`
- `cd` into this repo's root and run `pre-commit install` this will read the `.pre-commit-config.yaml` file and set up git pre-commit hooks as well as take care of installing the right formatters in a safe and isolated environment.
- Every time you commit a file, if it does not behave `pre-commit` will format it for you and you can re-add the files to complete your commit. This typically means running `git add .` and `git commit -m "your message"` once again after a failure.

If you have any question or trouble with this setup get in touch with Bastien Boutonnet.
