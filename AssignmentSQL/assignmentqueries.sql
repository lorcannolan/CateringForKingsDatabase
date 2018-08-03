------ Query 1 ------
/* 	SQL to find the most popular meal of each course type offered.
	A view is created to store all necessary info rather than 
	repeatedly using inner joins.
*/
-- altering session to my own schema to be able to create a view
alter session set current_schema = lnolan;

create or replace view totalitembookings as
(
	/*	total_bookings is created to contain the total amount of
		times each menu item has been ordered.
	*/
    select mname, coursetype, sum(mbookingqty) as total_bookings
    from DT2283C1.menu
    join DT2283C1.menu_booking using (mNumber)
    group by mname, coursetype
);

/*	I was getting errors when I attempted to select max(sum(total_bookings))
	along with selecting mname and coursetype so I decided to create the
	sub-query to list menu items from highest to lowest and only return the
	first value, i.e. the most popular menu item.
*/
select * from 
(
	/*	Sub-query was created as to list each starter from highest
		number of total_bookings to lowest.
	*/
    select * from totalitembookings
    where coursetype = 'Starter'
    order by total_bookings desc
)
where rownum <= 1
/* 	Using a union and repeating the previous queries to find the most popular
	main course and dessert.
*/
union
select * from 
(
    select * from totalitembookings
    where coursetype = 'Main'
    order by total_bookings desc
)
where rownum <= 1
union
select * from 
(
    select * from totalitembookings
    where coursetype = 'Dessert'
    order by total_bookings desc
)
where rownum <= 1;

------ Query 2 ------
/* 	SQL to list the names of clients who have ordered table mats, but never 
	table cloths.
*/
-- altering session for convenience prevent writing schema name previous to the table names
alter session set current_schema = DT2283C1;

select distinct(cFirstName || ' ' || cLastName) as client_name
from clients
join booking using (clientID)
join resource_booking using (bookingID)
join resources using (rCode)
where clientID in
(
	--	Find the clientID of the clients whose bookings contain table mats
    select clientID from booking
    where bookingID in
    (
		/* 	Find the bookingID of any bookings that contain the id assigned to
			table mats
		*/
        select bookingID from resource_booking
        where rCode in
        (
			--	Find the code/id of the resource that is assigned to table mats
            select rCode from resources
            where rDesc = 'Table Mat'
        )
    )
	/*	Repeat the above steps but using table cloths instead. Also the minus
		will not include any names of clients who have ordered table cloths.
	*/
    minus
    select clientID from booking
    where bookingID in
    (
        select bookingID from resource_booking
        where rCode in
        (
            select rCode from resources
            where rDesc = 'Table Cloth'
        )
    )
);

------ Query 3 ------
/*	SQL to list names of clients who have ordered all types of resource in the 
	Decoration category. Similar to Query 1, views were needed for this query.
	Cli view contains an indentifying key value, clientID, joined to view decororder
	and the non-key value we are looking for, client_name.
*/
-- altering session to my own schema to be able to create necessary views
alter session set current_schema = lnolan;

create or replace view cli as
(
    select clientID, cFirstName || ' ' || cLastName as client_name
    from DT2283C1.clients
);
/*	Decor view contains an identifying key to the resources in the docoration
	category, rCode, which is joined to decororder.
*/
create or replace view decor as
(
    select rCode, rCategory from DT2283C1.resources
    where rCategory = 'Decoration'
);
/*	Decororder is a weak entity which has a many to one connection with cli and
	decor views.
*/
create or replace view decororder as
(
    select clientID, rCode
    from DT2283C1.booking
    join DT2283C1.resource_booking using (bookingID)
);

select client_name from cli
where not exists
(
    SELECT * FROM decor
    where not exists
    (
        select * from decororder
        where (cli.clientID = decororder.clientID
        and decor.rCode = decororder.rCode)
    )
);

------ Query 4 ------
/*	SQL to list the names of clients who's details have been logged but have yet
	to make a booking.
	Left join will bring all the records from the left table of the join, i.e. clients table,
	even if they don't have a matching record in the right table, i.e. booking table.
*/
-- altering session for convenience prevent writing schema name previous to the table names
alter session set current_schema = DT2283C1;

select cfirstname || ' ' || clastname as client_name
from clients
left join booking on clients.clientid = booking.clientid
where bookingid is null;