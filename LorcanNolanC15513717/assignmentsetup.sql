/* Dropping tables in reverse oreder that they are created to respect 
foreign key constraints*/
drop table resource_booking;
drop table menu_booking;
drop table menu_ingredients;
drop table payments;
drop table booking;
drop table resources;
drop table clients;
drop table menu;
drop table ingredients;

--------------------------------------------------------------------

create table Ingredients
(
    IngID       number(4) not null,
    IngName     varchar2(25) not null,
    IngCost     number(4,2) not null,
    CostType    varchar2(8) not null,
    constraint ingredients_pk primary key (IngID),
    -- Will only accept input of 'Per Item' or 'Per Kilo'
    constraint costtype_chk check (CostType = 'Per Item' or CostType = 'Per Kilo')
);

insert into Ingredients values (5000, 'mushrooms', 5.67, 'Per Kilo');
insert into Ingredients values (5001, 'bread crumbs', 1.49, 'Per Kilo');
insert into Ingredients values (5002, 'flour', 1.75, 'Per Kilo');
insert into Ingredients values (5003, 'eggs', 0.32, 'Per Item');
insert into Ingredients values (5004, 'vegetable oil', 1.35, 'Per Kilo');
insert into Ingredients values (5005, 'melon', 1.69, 'Per Item');
insert into Ingredients values (5006, 'parma ham', 32.10, 'Per Kilo');
insert into Ingredients values (5007, 'prawns', 18.80, 'Per Kilo');
insert into Ingredients values (5008, 'little gem lettuce', 0.45, 'Per Item');
insert into Ingredients values (5009, 'mayonnaise', 6.40, 'Per Kilo');
insert into Ingredients values (5010, 'tomato chutney', 5.30, 'Per Kilo');
insert into Ingredients values (5011, 'worcestershire sauce', 12.10, 'Per Kilo');
insert into Ingredients values (5012, 'horseradish sauce', 11.80, 'Per Kilo');
insert into Ingredients values (5013, 'potatoes', 0.59, 'Per Item');
insert into Ingredients values (5014, 'strip loin steak', 18.43, 'Per Kilo');
insert into Ingredients values (5015, 'salmon fillet', 15.64, 'Per Kilo');
insert into Ingredients values (5016, 'spring onion', 0.69, 'Per Item');
insert into Ingredients values (5017, 'spinach', 4.40, 'Per Kilo');
insert into Ingredients values (5018, 'penne pasta', 0.94, 'Per Kilo');
insert into Ingredients values (5019, 'aubergine', 0.59, 'Per Item');
insert into Ingredients values (5020, 'courgette', 0.63, 'Per Item');
insert into Ingredients values (5021, 'peppers', 0.69, 'Per Item');
insert into Ingredients values (5022, 'garlic', 0.29, 'Per Item');
insert into Ingredients values (5023, 'vine tomatoes', 0.19, 'Per Item');
insert into Ingredients values (5024, 'butter', 7.47, 'Per Kilo');
insert into Ingredients values (5025, 'sugar', 01.19, 'Per Kilo');
insert into Ingredients values (5026, 'apples', 0.50, 'Per Item');
insert into Ingredients values (5027, 'cream', 3.99, 'Per Kilo');
insert into Ingredients values (5028, 'orange', 0.60, 'Per Item');
insert into Ingredients values (5029, 'banana', 0.22, 'Per Item');
insert into Ingredients values (5030, 'kiwi', 0.20, 'Per Item');
insert into Ingredients values (5031, 'pear', 0.55, 'Per Item');

--------------------------------------------------------------------

create table Menu
(
    mNumber         number(2) not null,
    mName           varchar2(50) not null,
    courseType      varchar2(7) not null,
    mDesc           varchar2(50) not null,
    mPrice          number(2) not null,
    mRecipe         varchar2(75) not null,
    mRecipeDur      varchar2(20) not null,
    constraint menu_pk primary key (mNumber),
    constraint coursetype_chk check (courseType = 'Starter' or courseType = 'Main' or courseType = 'Dessert')
);

insert into Menu values (1, 'Breaded Mushrooms', 'Starter', 'Fluffy mushrooms', 8, 'Apply batter and shallow fry on pan', '30 minutes');
insert into Menu values (2, 'Melon and Parma Ham', 'Starter', 'Juicy melon paired with fine Ham', 5, 'Slice Melon and serve with ham', '5 minutes');
insert into Menu values (3, 'Prawn Cocktail', 'Starter', 'Cooked prawns in cocktail sauce', 5, 'Cook prawns and create sauce', '20 minutes');
insert into Menu values (4, 'Steak', 'Main', '8oz. Strip loin steak and homemade chips', 20, 'Pan fry steak', '20 minutes');
insert into Menu values (5, 'Salmon', 'Main', 'Stuffed with prawns', 20, 'Grill the fish on both sides', '45 minutes');
insert into Menu values (6, 'Penne pasta with Vegetables', 'Main', 'Mediterranean style pasta', 15, 'Cut and prepare veg. Cook pasta and veg seperately and mix before serving','30 minutes');
insert into Menu values (7, 'Apple Tart', 'Dessert', 'With cream on top', 5, 'Bake the Tart', '13 minutes');
insert into Menu values (8, 'Fruit Salad', 'Dessert', 'Great selection of fruit', 5, 'Cut ', '5 minutes');

--------------------------------------------------------------------

create table Clients
(
    clientID    number(4) not null,
    cFirstName  varchar2(15) not null,
    cLastName   varchar2(15) not null,
    cAddress    varchar2(60) not null,
    cPhone      number(10) not null,
    constraint client_pk primary key (clientID)
);

insert into Clients values (0001, 'Lorcan', 'Nolano', 'Ashbourne Burrows', 0851997432);
insert into Clients values (0002, 'Michael', 'Scofield', 'Idrone Drift', 085198412);
insert into Clients values (0003, 'Colm', 'Farrell', 'Mullahoran Hill', 0852397482);
insert into Clients values (0004, 'Kevin', 'Redman', 'Dalkey Town', 0831598402);
insert into Clients values (0005, 'Sean', 'Meyles', 'Prague', 0831598430);
insert into Clients values (0006, 'Finn', 'Wolfhard', 'Bray Bowl', 0851432123);
insert into Clients values (0007, 'Steve', 'Martin', 'Beverly Hills', 0871907422);
insert into Clients values (0008, 'Gary', 'Cahill', 'Dundruma', 0841596431);

--------------------------------------------------------------------

create table Resources
(
    rCode       number(4) not null,
    rDesc       varchar2(50) not null,
    rCategory   varchar2(10) not null,
    -- price per unit
    rPrice      number(4,2) not null,
    -- total available
    rQuantity   number(3) not null,
    constraint resources_pk primary key (rCode),
    constraint category_chk check (rCategory = 'Delph' or rCategory = 'Cutlery' or rCategory = 'Furniture' or rCategory = 'Decoration')
);

insert into Resources values (4000, 'Stainless Steel Fork', 'Cutlery', 0.5, 200);
insert into Resources values (4001, 'Stainless Steel Knife', 'Cutlery', 0.5, 200);
insert into Resources values (4002, 'Stainless Steel Dessert Spoon', 'Cutlery', 0.5, 200);
insert into Resources values (4003, 'Stainless Steel Steak Knife', 'Cutlery', 0.5, 200);
insert into Resources values (4004, 'Plate', 'Delph', 1, 300);
insert into Resources values (4005, 'Pasta Bowl', 'Delph', 1, 200);
insert into Resources values (4006, 'Dessert Bowl', 'Delph', 1, 300);
insert into Resources values (4007, 'Chair', 'Furniture', 5, 75);
insert into Resources values (4008, 'Table', 'Furniture', 10, 15);
insert into Resources values (4009, 'Table Mat', 'Decoration', 1, 150);
insert into Resources values (4010, 'Table Cloth', 'Decoration', 2, 50);

--------------------------------------------------------------------

create table Booking
(
    bookingID       number(4) not null,
    clientID        number(4) not null,
    eventDate       timestamp not null,
    eventLoc        varchar2(40) not null,
    bookingDate     timestamp not null,
    bookingCost     number(7,2),
    foodStatus      char,
    bookingStatus   char not null,
    constraint booking_pk primary key (bookingID),
    constraint client_booking_fk foreign key (clientID) references Clients(clientID),
    constraint foodstatus_chk check (foodStatus = 'R' or foodStatus = null),
    constraint bookingstatus_chk check (bookingStatus = 'P' or bookingStatus = 'C' or bookingStatus = 'F')
);

insert into Booking (bookingID, clientID, eventDate, eventLoc, bookingDate, bookingCost, bookingStatus)
values (2000, 0001, to_timestamp('12 Dec 2017', 'DD MON YYYY'), '12 Birchwood Grove, Santry, Dublin', to_timestamp('10 Nov 2017', 'DD MON YYYY'), 1313.5, 'C');
insert into Booking values (2001, 0003, to_timestamp('03 Nov 2017', 'DD MON YYYY'), '65 The Fairways, Virginia, Co. Cavan', to_timestamp('20 Oct 2017', 'DD MON YYYY'), 1547, 'R', 'F');
insert into Booking (bookingID, clientID, eventDate, eventLoc, bookingDate, bookingCost, bookingStatus)
values (2002, 0002, to_timestamp('08 Jan 2018', 'DD MON YYYY'), '189 Fleenstown Way, Knocklyon, Dublin', to_timestamp('05 Nov 2017', 'DD MON YYYY'), 1277, 'P');

--------------------------------------------------------------------

create table Payments
(
    paymentID   number(4) not null,
    bookingID   number(4) not null,
    paymentVal  number(5,2) not null,
    constraint payments_pk primary key (paymentID),
    constraint booking_payments_fk foreign key (bookingID) references Booking(bookingID)
);

insert into Payments values (6000, 2000, 300);
insert into Payments values (6001, 2000, 400);
insert into Payments values (6002, 2001, 400);
insert into Payments values (6003, 2001, 500);
insert into Payments values (6004, 2001, 617);
insert into Payments values (6005, 2002, 150);

--------------------------------------------------------------------

create table Menu_ingredients
(
    mNumber     number(2) not null,
    IngID       number(4) not null,
    -- IngQty represents the amount needed for one serving
    IngQty      number(6,3) not null,
    constraint menu_ingredients_pk primary key (mNumber, IngID),
    constraint ings_menuings_fk foreign key (IngID) references Ingredients(IngID),
    constraint menu_menuings_fk foreign key (mNumber) references Menu(mNumber)
);

-- IngQty of 0.1 represents 100 grams as the ingredients price is measured per kilo
insert into Menu_ingredients values (1, 5000, 0.1);
insert into Menu_ingredients values (1, 5001, 0.1);
insert into Menu_ingredients values (1, 5002, 0.1);
-- IngQty of 2 represents 2 eggs as the cost of eggs are measured per item
insert into Menu_ingredients values (1, 5003, 2);
insert into Menu_ingredients values (1, 5004, 0.5);
insert into Menu_ingredients values (2, 5005, 0.25);
insert into Menu_ingredients values (2, 5006, 0.05);
insert into Menu_ingredients values (3, 5007, 0.1);
insert into Menu_ingredients values (3, 5008, 1);
insert into Menu_ingredients values (3, 5009, 0.01);
insert into Menu_ingredients values (3, 5010, 0.01);
insert into Menu_ingredients values (3, 5011, 0.01);
insert into Menu_ingredients values (3, 5012, 0.01);
insert into Menu_ingredients values (4, 5013, 2);
insert into Menu_ingredients values (4, 5014, 0.22);
insert into Menu_ingredients values (5, 5015, 0.25);
insert into Menu_ingredients values (5, 5007, 0.075);
insert into Menu_ingredients values (5, 5016, 3);
insert into Menu_ingredients values (5, 5000, 0.03);
insert into Menu_ingredients values (5, 5017, 0.1);
insert into Menu_ingredients values (5, 5009, 0.02);
insert into Menu_ingredients values (6, 5018, 0.125);
insert into Menu_ingredients values (6, 5019, 0.25);
insert into Menu_ingredients values (6, 5020, 0.5);
insert into Menu_ingredients values (6, 5021, 0.5);
insert into Menu_ingredients values (6, 5022, 0.5);
insert into Menu_ingredients values (6, 5023, 3);
insert into Menu_ingredients values (7, 5002, 0.05);
insert into Menu_ingredients values (7, 5024, 0.025);
insert into Menu_ingredients values (7, 5025, 0.001);
insert into Menu_ingredients values (7, 5003, 0.25);
insert into Menu_ingredients values (7, 5026, 0.5);
insert into Menu_ingredients values (7, 5027, 0.1);
insert into Menu_ingredients values (8, 5026, 0.25);
insert into Menu_ingredients values (8, 5028, 0.25);
insert into Menu_ingredients values (8, 5029, 0.25);
insert into Menu_ingredients values (8, 5030, 0.25);
insert into Menu_ingredients values (8, 5031, 0.25);

--------------------------------------------------------------------

create table Menu_booking
(
    mNumber         number(2) not null,
    bookingID       number(4) not null,
    mBookingQty     number(3) not null,
    constraint menubooking_pk primary key (mNumber, bookingID),
    constraint menu_menubooking_fk foreign key (mNumber) references Menu(mNumber),
    constraint booking_menubooking_fk foreign key (bookingID) references Booking(bookingID)
);

insert into Menu_booking values (1, 2000, 5);
insert into Menu_booking values (1, 2001, 10);
insert into Menu_booking values (1, 2002, 20);
insert into Menu_booking values (2, 2000, 10);
insert into Menu_booking values (2, 2001, 15);
insert into Menu_booking values (2, 2002, 5);
insert into Menu_booking values (3, 2000, 5);
insert into Menu_booking values (3, 2001, 12);
insert into Menu_booking values (3, 2002, 7);
insert into Menu_booking values (4, 2000, 25);
insert into Menu_booking values (4, 2001, 20);
insert into Menu_booking values (4, 2002, 13);
insert into Menu_booking values (5, 2000, 5);
insert into Menu_booking values (5, 2001, 16);
insert into Menu_booking values (5, 2002, 18);
insert into Menu_booking values (6, 2000, 6);
insert into Menu_booking values (6, 2001, 7);
insert into Menu_booking values (6, 2002, 4);
insert into Menu_booking values (7, 2000, 15);
insert into Menu_booking values (7, 2001, 23);
insert into Menu_booking values (7, 2002, 15);
insert into Menu_booking values (8, 2000, 10);
insert into Menu_booking values (8, 2001, 4);
insert into Menu_booking values (8, 2002, 5);

--------------------------------------------------------------------

create table Resource_booking
(
    rCode           number(4) not null,
    bookingID       number(4) not null,
    rBookingQty     number(3) not null,
    constraint resource_booking_pk primary key (rCode, bookingID),
    constraint resource_rebook_fk foreign key (rCode) references Resources(rCode),
    constraint booking_rebook_fk foreign key (bookingID) references Booking(bookingID)
);

insert into Resource_booking values (4002, 2000, 30);
insert into Resource_booking values (4000, 2000, 50);
insert into Resource_booking values (4001, 2000, 50);
insert into Resource_booking values (4003, 2000, 25);
insert into Resource_booking values (4004, 2000, 50);
insert into Resource_booking values (4005, 2000, 6);
insert into Resource_booking values (4006, 2000, 50);
insert into Resource_booking values (4007, 2000, 20);
insert into Resource_booking values (4008, 2000, 10);
insert into Resource_booking values (4002, 2001, 30);
insert into Resource_booking values (4000, 2001, 50);
insert into Resource_booking values (4001, 2001, 50);
insert into Resource_booking values (4003, 2001, 20);
insert into Resource_booking values (4004, 2001, 30);
insert into Resource_booking values (4005, 2001, 7);
insert into Resource_booking values (4006, 2001, 50);
insert into Resource_booking values (4007, 2001, 30);
insert into Resource_booking values (4008, 2001, 3);
insert into Resource_booking values (4009, 2001, 30);
insert into Resource_booking values (4002, 2002, 25);
insert into Resource_booking values (4000, 2002, 50);
insert into Resource_booking values (4001, 2002, 50);
insert into Resource_booking values (4003, 2002, 13);
insert into Resource_booking values (4004, 2002, 50);
insert into Resource_booking values (4005, 2002, 4);
insert into Resource_booking values (4006, 2002, 25);
insert into Resource_booking values (4007, 2002, 15);
insert into Resource_booking values (4008, 2002, 2);
insert into Resource_booking values (4009, 2002, 30);
insert into Resource_booking values (4010, 2002, 2);

-- moflaherty is granted privileges to align with the role of Annette
-- update privilege given as Annette can change status of the food to R for ready
GRANT SELECT, UPDATE ON booking TO moflaherty;
GRANT SELECT ON clients TO moflaherty;
-- update delete and insert privileges ingredients, menu and menu_ingredients
-- tables as she changes menu items every season
GRANT SELECT, UPDATE, DELETE, INSERT ON ingredients TO moflaherty;
GRANT SELECT, UPDATE, DELETE, INSERT ON menu TO moflaherty;
GRANT SELECT ON menu_booking TO moflaherty;
GRANT SELECT, UPDATE, DELETE, INSERT ON menu_ingredients TO moflaherty;
GRANT SELECT ON payments TO moflaherty;
GRANT SELECT ON resource_booking TO moflaherty;
GRANT SELECT ON resources TO moflaherty;

-- lnolan is granted privileges to align with the role of Carol
-- update, delete and insert privilege granted to booking, menu_booking
-- and resource_booking tables as she handles the bookings from customers
GRANT SELECT, UPDATE, DELETE, INSERT ON booking TO lnolan;
-- privileges granted on client table to allow for client info to be kept
-- when a booking is made
GRANT SELECT, UPDATE, DELETE, INSERT ON clients TO lnolan;
GRANT SELECT ON ingredients TO lnolan;
GRANT SELECT ON menu TO lnolan;
GRANT SELECT, UPDATE, DELETE, INSERT ON menu_booking TO lnolan;
GRANT SELECT ON menu_ingredients TO lnolan;
-- privileges granted on payments table as Carol processes payments also
GRANT SELECT, UPDATE, DELETE, INSERT ON payments TO lnolan;
GRANT SELECT, UPDATE, DELETE, INSERT ON resource_booking TO lnolan;
GRANT SELECT ON resources TO lnolan;

-- ckavanagh is granted privileges to align with the role of Charlie
GRANT SELECT ON booking TO ckavanagh;
GRANT SELECT ON clients TO ckavanagh;
GRANT SELECT ON ingredients TO ckavanagh;
GRANT SELECT ON menu TO ckavanagh;
GRANT SELECT ON menu_booking TO ckavanagh;
GRANT SELECT ON menu_ingredients TO ckavanagh;
GRANT SELECT ON payments TO ckavanagh;
GRANT SELECT ON resource_booking TO ckavanagh;
-- Charlie is granted privileges on resources table as he looks after the 
-- resources and keeps track of stock levels and adds new resource items
GRANT SELECT, UPDATE, DELETE, INSERT ON resources TO ckavanagh;

commit;