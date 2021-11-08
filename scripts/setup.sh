#!/usr/bin/env bash
set -u

abort() {
  printf "%s\n" "$@"
  exit 1
}

# Check for Bash being there
if [ -z "${BASH_VERSION:-}" ]
then
  abort "Bash is required to interpret this script."
fi

# Check OS
OS="$(uname)"
if [[ "${OS}" == "Linux" ]]
then
  SODA_DEMO_ON_LINUX=1
elif [[ "${OS}" != "Darwin" ]]
then
  abort "Soda Demo is only supported on macOS and Linux."
fi

# Check Docker commands being available
if ! docker info > /dev/null 2>&1; then
  abort "This script uses Docker, and it isn't running or available - please make sure you have a local Docker installation running."
fi

if ! docker-compose version > /dev/null 2>&1; then
  abort "This script uses Docker Compose, and it isn't running or available - please make sure you have a local Docker Compose installation."
fi

getc() {
  local save_state
  save_state="$(/bin/stty -g)"
  /bin/stty raw -echo
  IFS='' read -r -n 1 -d '' "$@"
  /bin/stty "${save_state}"
}

ring_bell() {
  # Use the shell's audible bell.
  if [[ -t 1 ]]
  then
    printf "\a"
  fi
}

wait_for_user() {
  local c
  echo
  echo "This will fetch and unpack the demo in the local directory. Press RETURN to continue or any other key to abort"
  getc c
  # we test for \r and \n because some stuff does \r instead
  if ! [[ "${c}" == $'\r' || "${c}" == $'\n' ]]
  then
    exit 1
  fi
}

if [[ -z "${NONINTERACTIVE-}" ]]
then
  ring_bell
  wait_for_user
fi

# fetch the gzip file and extract - @TODO, since project is still private, the next line should be uncommented once public
# curl "https://raw.githubusercontent.com/sodadata/tutorial-demo-project/feat/setup-script/soda-sql-docker-demo.tar.gz" | tar -xz
echo "For now you need to manually download from https://raw.githubusercontent.com/sodadata/tutorial-demo-project/feat/setup-script/soda-sql-docker-demo.tar.gz and then hit RETURN (warning message not relevant) again:"
wait_for_user

# extract
tar -zxf soda-sql-docker-demo.tar.gz
rm soda-sql-docker-demo.tar.gz

# run docker-compose
docker-compose up -d 

# run the shell
docker-compose run --use-aliases --rm soda_sql_project  "cd /workspace && /bin/bash"