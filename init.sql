create schema new_york;
create table new_york.breakdowns (
	school_year varchar,
	busbreakdown_id int,
	run_type varchar,
	bus_no varchar,
	route_number varchar,
	reason varchar,
	schools_serviced varchar,
	occured_on timestamp,
	created_on timestamp,
	boro varchar,
	bus_company_name varchar,
	how_long_delayed varchar,
	number_of_students_on_the_bus int,
	has_contractor_notified_schools varchar,
	has_contractor_notified_parents varchar,
	have_you_alerted_opt varchar,
	informed_on timestamp,
	incident_number varchar,
	last_updated_on timestamp,
	breakdown_or_running_late varchar,
	school_age_or_prek varchar
);

copy new_york.breakdowns
from '/data/bus_breakdown_and_delays.csv' delimiter ',' csv header;
