alter session set current_schema = lnolan;

SET SERVEROUTPUT ON

-- Creating sequences necessary for transactions related to the role of Carol
CREATE SEQUENCE clientseq
    MINVALUE 20
    MAXVALUE 999
    START WITH 20
    INCREMENT BY 1
    CACHE 20;

/

CREATE SEQUENCE bookingseq
    MINVALUE 2020
    MAXVALUE 2999
    START WITH 2020
    INCREMENT BY 1
    CACHE 20;
    
/

CREATE SEQUENCE paymentseq
    MINVALUE 6020
    MAXVALUE 6999
    START WITH 6020
    INCREMENT BY 1
    CACHE 20;
    
/

------ Transaction 1 ------
/*	Program written in PL/SQL to enter a new client value to the client table
*/
DECLARE
    v_clientid DT2283C1.clients.clientid%TYPE;
    v_cFirst DT2283C1.clients.cFirstName%TYPE    := '&Enter_First_Name';
    v_cLast DT2283C1.clients.cLastName%TYPE      := '&Enter_Last_Name';
    v_cAddress DT2283C1.clients.cAddress%TYPE    := '&Enter_Address';
    v_cPhone DT2283C1.clients.cPhone%TYPE        := '&Enter_Phone_Num';

BEGIN
    v_clientid := clientseq.nextval;
    insert into DT2283C1.clients values 
    (v_clientid, v_cFirst, v_cLast, v_cAddress, v_cPhone);
    commit;
    dbms_output.put_line(v_cFirst||' is added, with client ID '|| v_clientid || ', address ' || v_cAddress || ' and phone number ' || v_cPhone);
    
EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('Error number '||SQLCODE||
      ' meaning '||SQLERRM||'. Rolling back...');
  ROLLBACK;
END;

/

------ Transaction 2 ------
/*	Program written in PL/SQL to enter a new booking value to the booking table
*/    
DECLARE
    v_bookingid DT2283C1.booking.bookingid%TYPE;
	-- Takes in client's first and last name and will find its associated ID value
    v_cFirstName DT2283C1.clients.cFirstName%TYPE        := '&Enter_First_Name';
    v_cLastName DT2283C1.clients.cLastName%TYPE          := '&Enter_Last_Name';
    v_cID DT2283C1.clients.clientID%TYPE;
    v_eventDate DT2283C1.booking.eventDate%TYPE          := '&Enter_Event_Date';
    v_eventLoc DT2283C1.booking.eventLoc%TYPE            := '&Enter_Event_Location';
    v_bookingDate DT2283C1.booking.bookingDate%TYPE      := systimestamp;
	-- Is calculated later on after values have been added to menu_booking and resource_booking tables
    v_bookingCost DT2283C1.booking.bookingCost%TYPE;
    v_bookingStatus DT2283C1.booking.bookingStatus%TYPE  := '&Enter_Booking_Status';
    
BEGIN
    v_bookingid := bookingseq.nextval;
	-- Finding clientID
    select clientID into v_cID from DT2283C1.clients where (cFirstName like v_cFirstName and cLastName like v_cLastName);
    insert into DT2283C1.booking (bookingID, clientID, eventDate, eventLoc, bookingDate, bookingStatus) values 
    (v_bookingid, v_cID, v_eventDate, v_eventLoc, v_bookingDate, v_bookingStatus);
    commit;
    dbms_output.put_line(v_bookingid ||' is added, with client ID '|| v_cID || ', eDate ' || v_eventDate || ', eLoc ' || v_eventLoc || ', bDate ' || v_bookingDate);
    
EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('Error number '||SQLCODE||
      ' meaning '||SQLERRM||'. Rolling back...');
  ROLLBACK;
END;

/

------ Transaction 3 ------
/*	Program written in PL/SQL to enter a new booking value to the booking table
*/    
DECLARE
    v_bID DT2283C1.booking.bookingid%TYPE                := '&Enter_Booking_ID';
	-- Takes in menu item name and finds its associated ID value
    v_mName DT2283C1.menu.mName%TYPE                     := '&Enter_Menu_Name';
    v_mNum DT2283C1.menu.mNumber%TYPE;
	-- Takes in the number of specified menu items ordered from a specific booking
    v_mBookingQty DT2283C1.menu_booking.mBookingQty%TYPE := '&Enter_Quantity';
    
BEGIN
	-- Finding menu number/id
    select mNumber into v_mNum from DT2283C1.Menu where (mName like v_mName);
    insert into DT2283C1.menu_booking values 
    (v_mNum, v_bID, v_mBookingQty);
    commit;
    dbms_output.put_line(v_mNum||' is added, with booking ID '|| v_bID || ' and booking quantity ' || v_mBookingQty);
    
EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('Error number '||SQLCODE||
      ' meaning '||SQLERRM||'. Rolling back...');
  ROLLBACK;
END;

/

------ Transaction 4 ------
/*	Very similar to transaction 3 but with the resource_booking table
*/    
DECLARE
    v_bID DT2283C1.booking.bookingid%TYPE                    := '&Enter_Booking_ID';
    v_rDesc DT2283C1.resources.rDesc%TYPE                    := '&Enter_Resource_Desc';
    v_rCode DT2283C1.resources.rCode%TYPE;
    v_rBookingQty DT2283C1.resource_booking.rBookingQty%TYPE := '&Enter_Quantity';
    
BEGIN
    select rCode into v_rCode from DT2283C1.resources where (rDesc like v_rDesc);
    insert into DT2283C1.resource_booking values 
    (v_rCode, v_bID, v_rBookingQty);
    commit;
    dbms_output.put_line(v_rCode||' is added, with booking ID '|| v_bID || ' and booking quantity ' || v_rBookingQty);
    
EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('Error number '||SQLCODE||
      ' meaning '||SQLERRM||'. Rolling back...');
  ROLLBACK;
END;

/

------ Transaction 5 ------
/*	Program written in PL/SQL to calculate and enter the total booking cost of a specified booking
*/    
DECLARE
    v_bID DT2283C1.booking.bookingid%TYPE    := '&Enter_Booking_ID';
    v_mPrice INTEGER;
    v_rPrice INTEGER;

BEGIN
	-- Calculates the total price of all food items in the specified booking
    select sum(mBookingQty * mPrice) into v_mPrice from DT2283C1.menu_booking 
    join DT2283C1.menu using (mNumber)
    where (bookingID like v_bID);
	-- Calculates the total price of all resource items in the specified booking
    select sum(rBookingQty * rPrice) into v_rPrice from DT2283C1.resource_booking 
    join DT2283C1.resources using (rCode) 
    where (bookingID like v_bID);
	-- updates the booking with the price of total resource items plus total food food items
    update DT2283C1.booking 
    set bookingCost = (v_mPrice + v_rPrice) 
    where bookingId like v_bID;
    commit;
    dbms_output.put_line(v_mPrice + v_rPric ||' is added as a booking cost for booking ID '|| v_bID);
    
EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('Error number '||SQLCODE||
      ' meaning '||SQLERRM||'. Rolling back...');
  ROLLBACK;
END;

/

------ Transaction 6 ------
/*	Program written in PL/SQL to enter a new payment value to the payment table
*/ 
DECLARE
    v_bID DT2283C1.booking.bookingid%TYPE                := '&Enter_Booking_ID';
    v_paymentID DT2283C1.payments.paymentID%TYPE;
    v_paymentAmount DT2283C1.payments.paymentVal%TYPE    := '&Enter_Payment_Value';

BEGIN
    v_paymentID := paymentseq.nextval;
    insert into DT2283C1.payments values 
    (v_paymentID, v_bID, v_paymentAmount);
    commit;
    dbms_output.put_line(v_paymentID ||' is added, with booking ID '|| v_bID || ' and payment value of ' || v_paymentAmount);
    
EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('Error number '||SQLCODE||
      ' meaning '||SQLERRM||'. Rolling back...');
  ROLLBACK;
END;

/