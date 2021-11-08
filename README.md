# Soda SQL Demo Containers

This repo provides an easy way to set up a `postgresql` database with demo data from the NYC Bus Breakdowns and Delay Dataset (also used in the interactve demo tutorial) along with a pre-configure `soda-sql` project and environment to facilitate quick start with minimal investment from users.

## Pre-Requisites

You should have a recent version of docker and docker-compose that is able to run `docker-compose` files version "3.9" and up.

## Installation

### Using a convenience setup script

Just run:

@TODO: token step needs to be removed once the project is public

```bash
export GH_TOKEN=`get your token from checking the below URL in a browser, it will be added as a paramter in the URL`
```

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/sodadata/tutorial-demo-project/feat/setup-script/scripts/setup.sh\?token=${GH_TOKEN})"
```

This will:

- fetch the created package and unpack it
- spin up the containers using Docker Compose
- and put you in a shell in the container

### Manual setup


1. Clone this repository in a location of your choosing
2. Once cloned, navigate into the project `cd tutorial-demo-project`
3. Build/Start the containers with `docker-compose up -d` (the `-d` flag means "detached" which means that you won't need to keep the terminal running for the docker containers to stay alive.
4. You can validate that the setup worked by running the `docker ps` command which should output something like below:

```
CONTAINER ID   IMAGE                                    COMMAND                  CREATED       STATUS         PORTS                                       NAMES
90b555b29ccd   tutorial-demo-project_soda_sql_project   "/bin/bash"              3 hours ago   Up 3 seconds   0.0.0.0:8001->5432/tcp, :::8001->5432/tcp   tutorial-demo-project_soda_sql_project_1
d7950300de7a   postgres                                 "docker-entrypoint.s…"   3 hours ago   Up 3 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   tutorial-demo-project_soda_sql_tutorial_db_1
```

## Usage

### Shell Bindings

To make running your commands inside the docker container feel just like you'd be running them locally we've created a few shell bindings.

To make them available to your current terminal session just type: `source scripts/shell_bindings.sh` and you'll be able to do `soda --help` or `soda scan` (in fact any of the soda commands) and they will be run in the docker container without added instructions to docker.

If bindings aren't for you and you'd prefer to log into the container's bash and run your commands in there that's fine too. You can do the following:

1. Grab the name or ID of the soda_sql_project container via the `docker ps` (see above).
2. Run the following command replacing `<container ref>` with either the ID or the name you grabbed earlier.

```bash
docker exec -it <container ref> bash
```

For example, in the snippet above, the container is named `tutorial-demo-project_soda_sql_project_1` so we would run the following:

```bash
docker exec -it tutorial-demo-project_soda_sql_project_1 bash
```

## Visualise or query the data

Once the docker container is up, you can use any database clients such as DBeaver or DataGrip to connect to the database and query the `new_york.breakdowns` dataset.
To set up a connection in those clients use the following parameters:

```
host: localhost
username: sodasql
password: <leave empty>
port: 5432
```

The table lives in the `sodasql_tutorial` database in the `new_york` schema. You can select it like so

```sql
select * from sodasql_tutorial.new_york.breakdowns limit 50;
```

## Modify your tests locally

From the repository root, you can navigate into the `workspace/new_york_bus_breakdown` folder. This folder is your `soda-sql` project.

Feel free to make as many changes as you want to the `breakdowns.yml` file. Set up tests you would like to run on this table (see docs.soda.io).
This project folder is kept in sync with the docker container you spun up in earlier steps.

## Run tests in the `soda-sql` docker container

To run `soda scan` and test your dataset, you need to get into the `tutorial-demo-project_soda_sql_project` container's shell.
If you followed the [Shell Bindings instructions](#shell-bindings) you should know what to do. If not, scroll back up a bit :)

To do so, you need to know either the container ID or its name. The `docker ps` command will give you that (as shown in the earlier steps).
For example, in the snippet above, the container is named `tutorial-demo-project_soda_sql_project_1`.

To enter its shell run the following command:

```bash
docker exec -it tutorial-demo-project_soda_sql_project_1 bash
```

This will turn your terminal into the docker container's shell where you can run navigate into the `soda-sql` tutorial project (the exact copy as the one you have locally) and run a `soda scan`.

```bash
cd new_york_bus_breakdown

soda scan warehouse.yml tables/breakdowns.yml
```

This will run the scan and print the collected metrics along with the results of the tests that are set up. If you have not added or deleted any of the tests we added for you the bottom of the `scan` output should look something like this:

```
  | Test test(row_count > 0) passed with measurements {"expression_result": 199998, "row_count": 199998}
  | Test column(incident_number) test(invalid_percentage == 0) failed with measurements {"expression_result": 0.4785047850478505, "invalid_percentage": 0.4785047850478505}
  | Test column(incident_number) test(missing_count < 0) failed with measurements {"expression_result": 192614, "missing_count": 192614}
  | Executed 2 queries in 0:00:00.159331
  | Scan summary ------
  | 233 measurements computed
  | 3 tests executed
  | 2 of 3 tests failed:
  |   Test column(incident_number) test(invalid_percentage == 0) failed with measurements {"expression_result": 0.4785047850478505, "invalid_percentage": 0.4785047850478505}
  |   Test column(incident_number) test(missing_count < 0) failed with measurements {"expression_result": 192614, "missing_count": 192614}
  | Exiting with code 1
```

## Tear Down

When you're done feel free to shut down your containers.

If you have sourced the [shell bindings](#shell-bindings) you can type `shutdown_soda` or `docker-compose down`
