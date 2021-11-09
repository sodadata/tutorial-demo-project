#!/usr/bin/env bash

FILENAME=soda-sql-docker-demo.tar.gz

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $SCRIPTS_DIR/../

tar zcvf soda-sql-docker-demo.tar.gz data workspace docker-compose.yaml \
    scripts/init.sql scripts/bashrc.txt scripts/motd.txt \
    scripts/shell_bindings.sh \
    Dockerfile_soda_sql README.md
