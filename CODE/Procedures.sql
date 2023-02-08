
-----------------------------------------------------------------------------------------------------
----Procedures_1
---stored procedure that can be used to insert data into the PIECESOFART table:
CREATE PROCEDURE insert_piecesofart
(
    p_artist IN VARCHAR2,
    p_year IN VARCHAR2,
    p_title IN VARCHAR2,
    p_type IN VARCHAR2,
    p_price IN NUMBER,
    p_customer IN VARCHAR2
)
AS
BEGIN
    INSERT INTO PIECESOFART (ARTIST, YEAR, TITLE, TYPE, PRICE, CUSTOMERNAME)
    VALUES (p_artist, p_year, p_title, p_type, p_price, p_customer);
    COMMIT;
END;



----call
BEGIN
    insert_piecesofart('Salvador Dali', '1931', 'The Persistence of Memory', 'Surrealism', 100000, 'Ryan');
END;

----Procedures_2
---This procedure takes in a customer name as an input and checks if that customer exists in the
-- CUSTOMERS table. If the customer does not exist, it raises a custom exception with error code 
--20001 and message 'Customer does not exist'. This can be used to handle cases where the user tries
-- to perform an action on a non-existent customer.
CREATE OR REPLACE PROCEDURE raise_custom_exception (p_customer_name IN VARCHAR2)
IS
    l_customer_name VARCHAR2(20);
BEGIN
    -- check if the customer exists
    SELECT CUSTOMER_NAME INTO l_customer_name FROM CUSTOMERS
    WHERE CUSTOMER_NAME = p_customer_name;
    
    -- if customer does not exist, raise custom exception
    IF l_customer_name IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Customer does not exist');
    END IF;
    
    -- continue with the rest of the procedure
    -- ...
    
EXCEPTION
    WHEN OTHERS THEN
        -- log the error
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        
        -- re-raise the exception
        RAISE;
END;
---call
BEGIN
    RAISE_CUSTOM_EXCEPTION('John Doe');
END;



---procedure 3
--he procedure accepts two input parameters: a string representing the name of the artist and a number representing the new age of the artist.
-- The procedure first selects the current age of the artist from the ARTISTS table using the artist 
--name as the search criterion. If the artist is not found, the procedure will raise an exception 
CREATE OR REPLACE PROCEDURE update_artist_age (p_artist_name IN VARCHAR2, p_new_age IN NUMBER)
AS
    -- Declare variables
    l_current_age NUMBER;
    l_artist_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT(l_artist_not_found, -2291);
BEGIN
    -- Find the current age of the artist
    SELECT a_age INTO l_current_age
    FROM artists
    WHERE a_name = p_artist_name;

    -- Update the artist's age
    UPDATE artists
    SET a_age = p_new_age
    WHERE a_name = p_artist_name;

    -- Handle the exception if the artist is not found
    EXCEPTION
        WHEN l_artist_not_found THEN
            DBMS_OUTPUT.put_line('Artist not found. Please check the artist name and try again.');
END;

--- call
BEGIN
    UPDATE_ARTIST_AGE('Slade ', 55);
END;
