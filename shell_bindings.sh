function build(){
	docker-compose build
}

#just an example wrapper, modify if you have another working directory under /workspace
function soda(){
	docker-compose run --rm soda_sql_project "cd /workspace/new_york_bus_breakdown_demo && soda $*"
}

function soda_shell(){
	docker-compose run --rm soda_sql_project "cd /workspace && /bin/bash"
}

function shutdown_soda(){
	docker-compose down
}
