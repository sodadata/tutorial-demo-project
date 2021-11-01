function build(){
	docker-compose build
}

function soda(){
	docker-compose run --rm soda_sql_project "cd /new_york_bus_breakdown && soda $*"
}

function shutdown_soda(){
	docker-compose down
}
