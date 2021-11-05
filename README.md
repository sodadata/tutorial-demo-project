# Soda SQL Demo Containers

This repo provides an easy way to set up a `postgresql` database with demo data from the NYC Bus Breakdowns and Delay Dataset (also used in the interactve demo tutorial) along with a pre-configure `soda-sql` project and environment to facilitate quick start with minimal investment from users.

## Pre-Requisites

You should have a recent version of docker and docker-compose that is able to run `docker-compose` files version "3.9" and up.

## Installation

1. Clone this repository in a location of your choosing
2. Once cloned, navigate into the project `cd tutorial-demo-project`
3. Build/Start the containers with `docker-compose up -d` (the `-d` flag means "detached" which means that you won't need to keep the terminal running for the docker containers to stay alive.
4. You can validate that the setup worked by running `docker ps -a | grep soda` command which should output something like below:

```
CONTAINER ID   IMAGE                                    COMMAND                  CREATED       STATUS         PORTS                                       NAMES
90b555b29ccd   tutorial-demo-project_soda_sql_project   "/bin/bash"              3 hours ago   Exited (2) 3 seconds ago   0.0.0.0:8001->5432/tcp, :::8001->5432/tcp   tutorial-demo-project_soda_sql_project_1
d7950300de7a   postgres                                 "docker-entrypoint.s…"   3 hours ago   Up 3 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   tutorial-demo-project_soda_sql_tutorial_db_1
```

## Usage

### Visualise or query the data

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

Please note: in this demo setup, we do not have a password set for accessing the database. You should of course never use this approach for your own datasets. Read our [docs](https://docs.soda.io/soda/warehouse_types.html) to learn more on how to configure credentials for the supported data sources.

### Run tests in the `soda-sql` docker container

To run `soda scan` and test your dataset, you need to get into the provided container's shell. Just issue this command (from the project root dir where the file `docker-compose.yml` lives):

```bash
docker-compose run --rm soda_sql_project "cd /workspace && /bin/bash"
```

This will allow you to access the docker container's shell where you can now run the `soda analyze` command:

```bash
cd new_york_bus_breakdown_demo

soda analyze
```

As a result, the file `tables/breakdowns.yml` will be created. Now you can run a scan:

```bash
soda scan warehouse.yml tables/breakdowns.yml
```

This will run the scan and print the collected metrics along with the results of the tests that are set up. If you have not added or deleted any of the tests we added for you the bottom of the `scan` output should look something like this:

```
...
  | Derived measurement: invalid_count(school_age_or_prek) = 0
  | Derived measurement: valid_percentage(school_age_or_prek) = 100.0
  | Test test(row_count > 0) passed with measurements {"expression_result": 199998, "row_count": 199998}
  | Test column(school_year) test(invalid_percentage == 0) passed with measurements {"expression_result": 0.0, "invalid_percentage": 0.0}
  | Test column(bus_no) test(invalid_percentage <= 20) passed with measurements {"expression_result": 19.99919999199992, "invalid_percentage": 19.99919999199992}
  | Test column(schools_serviced) test(invalid_percentage <= 15) passed with measurements {"expression_result": 12.095620956209562, "invalid_percentage": 12.095620956209562}
  | Executed 2 queries in 0:00:01.445494
  | Scan summary ------
  | 239 measurements computed
  | 4 tests executed
  | All is good. No tests failed.
  | Exiting with code 0
```

You can use an example modified version of the file `tables/breakdowns.yml` as available in `tables/breakdowns-demo.yml` for demo purposes to run another, modified scan:

```bash
cp tables/breakdowns-demo.yml tables/breakdowns.yml
soda scan warehouse.yml tables/breakdowns.yml
```

This time it will end with 2 out of 6 tests failed.

If you want to exit the Docker container's shell, just type `exit` and hit return. 

### Modify your tests locally

From the repository root, you can navigate into the `workspace/new_york_bus_breakdown_demo` folder. This folder is your `soda-sql` project.

Feel free to make as many changes as you want to the `breakdowns.yml` file. Set up tests you would like to run on this table (see docs.soda.io).
This project folder is kept in sync since it wil be mounted by the docker container that you can use to issue the `soda` commands in the next step.

### Tear Down

When you're done feel free to shut down your containers using:

```bash
docker-compose down
```

### Utilities

You can optionally use some example shell functions available in `shell_bindings.sh` and source that file for your convenience.
