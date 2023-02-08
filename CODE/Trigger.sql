
------------------------------------------------------------------------------------------------------------

-------Triggers 1.
---A trigger that prevents the deletion of a row in the "ARTISTS" table if there is a corresponding row in the "CUSTOMER_FOLLOWS_ARTISTS" table:
CREATE OR REPLACE TRIGGER prevent_artist_deletion
AFTER DELETE ON ARTISTS
FOR EACH ROW
DECLARE
   v_artist_exists INTEGER;
BEGIN
   SELECT COUNT(*) INTO v_artist_exists FROM CUSTOMER_FOLLOWS_ARTISTS WHERE AR_NAME = :OLD.A_NAME;
   IF v_artist_exists > 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Cannot delete artist with followers');
   END IF;
END;
--check
DELETE FROM ARTISTS WHERE A_NAME = 'Caesar';
--Note: This trigger raises an application error with a custom message when a user 
--tries to delete a row in the "ARTISTS" table that is being referenced by a row in the "CUSTOMER_FOLLOWS_ARTISTS" table.
--return a row with the trigger name, type, and triggering event.
SELECT TRIGGER_NAME, TRIGGER_TYPE, TRIGGERING_EVENT
FROM USER_TRIGGERS
WHERE TRIGGER_NAME = 'PREVENT_ARTIST_DELETION';
--User sourse
SELECT TEXT
FROM USER_SOURCE
WHERE NAME = 'PREVENT_ARTIST_DELETION'
ORDER BY LINE;

-----
-----Trigger 2
----trigger by trying to insert a new row into the "PIECESOFART" table with a price less than 100, you should get an error message as specified in the trigger.
CREATE OR REPLACE TRIGGER MIN_PRICE
BEFORE INSERT ON PIECESOFART
FOR EACH ROW
BEGIN
    IF :NEW.PRICE < 100 THEN
        raise_application_error(-20325, 'Minimun price is at least 100 dollar');
    END IF;
END;
---=check
INSERT INTO PIECESOFART (ARTIST, YEAR, TITLE, TYPE, PRICE, CUSTOMERNAME)
VALUES ('John Doe', '2022', 'My Painting', 'Painting', 50, 'Ryan');


--Triger 3

---A trigger that checks data integrity for the "ARTIST" column in the "PIECESOFART" table by checking if the value being inserted or updated exists in the "ARTISTS" table:
CREATE OR REPLACE TRIGGER check_artist_integrity
BEFORE INSERT OR UPDATE ON PIECESOFART
FOR EACH ROW
DECLARE
v_artist_exists INTEGER;
BEGIN
SELECT COUNT(*) INTO v_artist_exists FROM ARTISTS WHERE A_NAME = :NEW.ARTIST;
IF v_artist_exists = 0 THEN
RAISE_APPLICATION_ERROR(-20002, 'Invalid artist name');
END IF;
END;
--Note: This trigger raises an application error with a custom message when a user tries to insert or update a row 
--in the "PIECESOFART" table with an "ARTIST" value that does not exist in the "ARTISTS" table.
---check
INSERT INTO PIECESOFART(ARTIST,YEAR,TITLE,TYPE,PRICE)VALUES('Invalid Artist','1998','StadiumPrototype',6,1000000);


---show all the trigger 
SELECT TRIGGER_NAME, TRIGGER_TYPE, TABLE_NAME, TRIGGERING_EVENT 
FROM USER_TRIGGERS;

