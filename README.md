# Soda SQL Demo

This repo provides an easy way to set up a PostgreSQL database with data from the <a href="https://data.cityofnewyork.us/Transportation/Bus-Breakdown-and-Delays/ez4e-fazm" target="_blank">NYC Bus Breakdowns and Delay Dataset</a> and a pre-configured Soda SQL project. You can use this repo as a test environment in which to experiment with Soda SQL. The Soda SQL interactive demo also references this project.

## Pre-Requisites

* a recent version of [Docker](https://docs.docker.com/get-docker/) 
* [Docker Compose](https://docs.docker.com/compose/install/) that is able to run `docker-compose` files version 3.9 and later

## Set up using a script

From the command-line, run the following command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/sodadata/tutorial-demo-project/main/scripts/setup.sh)"
```

The command completes the following tasks:

* fetches and unpacks the demo in the local directory
* spins up the Docker containers using Docker Compose
* drops you into a shell in the container, ready to begin using Soda SQL.

```bash

+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| Welcome to the Docker-based shell for testing Soda SQL        |
| To exit, just type CTRL-D or type "exit" and hit return       |
|                                                               |
| Type "hint" if you don't know where to start                  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

Soda SQL, see https://docs.soda.io
(c) Soda Data NV 2021
root@462fc591d108:/workspace# 
```

#### Troubleshoot
**Problem:** When running the script on a Mac, you get an error such as `failed to solve with frontend dockerfile.v0: failed to read dockerfile: error from sender: open /Users/<user>/.Trash: operation not permitted`.

**Solution:** You need to grant Full Disk Access to the Terminal application. Go to System Preferences > Security & Privacy > Privacy, then select Full Disk Access. Check the box next to Terminal to grant full disk access.

## Set up manually

1. Clone this repository to your local environment.
2. In the command-line, navigate into the tutorial project: `cd tutorial-demo-project`.
3. Build the Docker containers: `docker-compose up -d` (the `-d` flag means "detached" which means that you do not need to keep the terminal running for the docker containers to continue to run.)
4. Validate that the setup is complete: `docker ps -a | grep soda`  This command yields output like the following:

```
CONTAINER ID   IMAGE                                    COMMAND                  CREATED       STATUS         PORTS                                       NAMES
90b555b29ccd   tutorial-demo-project_soda_sql_project   "/bin/bash"              3 hours ago   Exited (2) 3 seconds ago   0.0.0.0:8001->5432/tcp, :::8001->5432/tcp   tutorial-demo-project_soda_sql_project_1
d7950300de7a   postgres                                 "docker-entrypoint.s…"   3 hours ago   Up 3 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   tutorial-demo-project_soda_sql_tutorial_db_1
```
5. To run Soda commands and test your dataset, you need to get into the container's shell. From the project's root dir where the `docker-compose.yml` file exists, run the following command:

```bash
docker-compose run --rm soda_sql_project "cd /workspace && /bin/bash"
```
This command drops you into the container's shell with a prompt like the following:

```bash
root@90461262c35e:/workspace# 
```


## (Optional) Examine or query the dataset

Once the docker container is up, you can use any database clients such as DBeaver or DataGrip to connect to the database and query the `new_york.breakdowns` dataset.

To set up a connection in those clients use the following parameters:

```
host: localhost
username: sodasql
password: <leave empty>
port: 5432
```

The table exists in the `sodasql_tutorial` database in the `new_york` schema. You can select it using the following query:

```sql
select * from sodasql_tutorial.new_york.breakdowns limit 50;
```

## Run Soda commands in the Soda SQL Docker container

Access <a href="https://docs.soda.io/soda-sql/configure.html" target="_blank">docs.soda.io</a> for full instructions on how to set up and use Soda SQL.

* Try running `soda` to see a list of Soda commands.
* Try running `soda create postgres` to create a new Soda SQL project.
* To enable you to run `soda analyze` and `soda scan` without configuring anything yourself, you can navigate to the `new_york_bus_breakdowns_demo` directory to use a sample `warehouse.yml` and sample `breakdowns-demo.yml` file. In the `new_york_bus_breakdowns_demo` directory, try running:
    * `soda analyze`
    * `soda scan warehouse.yml tables/breakdowns-demo.yml` 

The output from the scan command yields something like this:

```
  | 2.1.0b18
  | Scanning tables/breakdowns-demo.yml ...
...
  | Derived measurement: invalid_count(school_age_or_prek) = 0
  | Derived measurement: valid_percentage(school_age_or_prek) = 100.0
  | Test test(row_count > 0) passed with measurements {"expression_result": 199998, "row_count": 199998}
  | Test column(school_year) test(invalid_percentage == 0) passed with measurements {"expression_result": 0.0, "invalid_percentage": 0.0}
  | Test column(bus_no) test(invalid_percentage <= 20) passed with measurements {"expression_result": 19.99919999199992, "invalid_percentage": 19.99919999199992}
  | Test column(schools_serviced) test(invalid_percentage <= 15) passed with measurements {"expression_result": 12.095620956209562, "invalid_percentage": 12.095620956209562}
  | Test column(incident_number) test(invalid_percentage == 0) failed with measurements {"expression_result": 0.4785047850478505, "invalid_percentage": 0.4785047850478505}
  | Test column(incident_number) test(missing_count == 0) failed with measurements {"expression_result": 192614, "missing_count": 192614}
  | Executed 2 queries in 0:00:02.360158
  | Scan summary ------
  | 245 measurements computed
  | 6 tests executed
  | 2 of 6 tests failed:
  |   Test column(incident_number) test(invalid_percentage == 0) failed with measurements {"expression_result": 0.4785047850478505, "invalid_percentage": 0.4785047850478505}
  |   Test column(incident_number) test(missing_count == 0) failed with measurements {"expression_result": 192614, "missing_count": 192614}
  | Exiting with code 1
```


### Modify the tests 

In the `new_york_bus_breakdowns_demo` directory, you can use a command-line text editor to open the `breakdowns-demo.yml` and adjust the existing tests or add new ones to the YAML file. Save the file, then run `soda scan warehouse.yml tables/breakdowns-demo.yml` again to see the results of your new or modified tests.

Learn how to define tests in the YAML file at <a href="https://docs.soda.io/soda-sql/tests.html" target="_blank">docs.soda.io</a>.

## Exit

When you're done with the test environment, you can stop the Docker container.

* If you set up the container using the script, use `ctrl+d` to shut down your container, or type `exit`.
* If you set up the container manually, type `exit` or use `docker-compose down`.
