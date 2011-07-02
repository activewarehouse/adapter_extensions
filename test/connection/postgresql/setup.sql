create table people (
  first_name char(255),
  last_name char(255),
  ssn char(64)
);
delete from people;
create table places (
	address text,
	city char(255),
	state char(255),
	country char(2)
);
delete from places;

create table truncate_test (
  id SERIAL PRIMARY KEY,
	x char(4)
);
delete from truncate_test;
insert into truncate_test (x) values ('a');
insert into truncate_test (x) values ('b');
insert into truncate_test (x) values ('c');