use librarydb;
-- Task1:Creating a stored procedure that accepts an age group as a parameter and retrieves the most popular books (top 10) borrowed by users in that age group:
DELIMITER //

CREATE PROCEDURE GetTopBooksByAgeGroup(IN p_age_group VARCHAR(20))
BEGIN
    SELECT 
        b.book_id,
        b.title,
        b.author,
        COUNT(*) AS borrow_count
    FROM 
        books b
    JOIN 
        loans l ON b.book_id = l.book_id
    JOIN 
        borrowers br ON l.borrower_id = br.borrower_id
    WHERE 
        br.age_group = p_age_group
    GROUP BY 
        b.book_id, b.title, b.author
    ORDER BY 
        borrow_count DESC
    LIMIT 10;
END //

DELIMITER ;
CALL GetTopBooksByAgeGroup('Adults (25-64)');
CALL GetTopBooksByAgeGroup('Teens (13-19)');
CALL GetTopBooksByAgeGroup( 'Children (0-12)');

-- Task2:Write a query to create a procedure that accepts year as
-- a parameter and calculates the number of loans issued
-- for each month within that year
DELIMITER //

CREATE PROCEDURE GetMonthlyLoanCountByYear(IN p_year INT)
BEGIN
    SELECT 
        MONTH(loan_date) AS month,
        COUNT(*) AS loan_count
    FROM 
        loans
    WHERE 
        YEAR(loan_date) = p_year
    GROUP BY 
        MONTH(loan_date)
    ORDER BY 
        month;
END //

DELIMITER ;

CALL GetMonthlyLoanCountByYear(2024);
-- task3:
-- Write a query to create a procedure that creates anew loan entry in the loans table. It accepts book andborrower IDs as parameters and inserts a new recordwith the current date and a calculated due datebased on the library's loan period policy.

DELIMITER //

CREATE PROCEDURE CreateNewLoan(IN p_book_id INT, IN p_borrower_id INT)
BEGIN
    DECLARE v_loan_date DATE;
    DECLARE v_due_date DATE;
    
    -- Set the loan date to the current date
    SET v_loan_date = CURDATE();
    
    -- Calculate the due date (14 days from the loan date)
    SET v_due_date = DATE_ADD(v_loan_date, INTERVAL 14 DAY);
    
    -- Insert the new loan record
    INSERT INTO loans (book_id, borrower_id, loan_date, return_date)
    VALUES (p_book_id, p_borrower_id, v_loan_date, v_due_date);
    
    -- Confirm the insertion
    SELECT LAST_INSERT_ID() AS new_loan_id, v_loan_date AS loan_date, v_due_date AS due_date;
END //

DELIMITER ;

CALL CreateNewLoan(1, 2);

/*Task4:Write a query to create a procedure that updates the
return_date for a specific loan identified by the loan_id
parameter. It essentially performs an UPDATE operation
on the loans table, setting the retum_date to the current
date.*/

DELIMITER //

CREATE PROCEDURE UpdateLoanReturnDate(IN p_loan_id INT)
BEGIN
    DECLARE v_rows_affected INT;

    -- Update the return_date for the specified loan
    UPDATE loans
    SET return_date = CURDATE()
    WHERE loan_id = p_loan_id AND return_date IS NULL;

    -- Get the number of rows affected by the update
    SET v_rows_affected = ROW_COUNT();

    -- Check if the update was successful
    IF v_rows_affected > 0 THEN
        SELECT 'Loan return date updated successfully.' AS message, 
               p_loan_id AS loan_id, 
               CURDATE() AS return_date;
    ELSE
        SELECT 'No update performed. The loan may not exist or has already been returned.' AS message;
    END IF;
END //

DELIMITER ;

CALL UpdateLoanReturnDate(1);

/*task5:‘Write a query to create a procedure that accepts
three parameters: borrower ID, new name (optional),
‘and new email (optional). It performs an UPDATE
operation on the borrowers table, updating the
specified fields for the borrower identified by the
borrower_id.*/

DELIMITER //

CREATE PROCEDURE UpdateBorrowerInfo(
    IN p_borrower_id INT,
    IN p_new_name VARCHAR(255),
    IN p_new_email VARCHAR(100)
)
BEGIN
    DECLARE v_rows_affected INT;

    -- Update the borrower information
    UPDATE borrowers
    SET
        name = COALESCE(p_new_name, name),
        email = COALESCE(p_new_email, email)
    WHERE borrower_id = p_borrower_id;

    -- Get the number of rows affected by the update
    SET v_rows_affected = ROW_COUNT();

    -- Check if the update was successful
    IF v_rows_affected > 0 THEN
        SELECT 'Borrower information updated successfully.' AS message, 
               p_borrower_id AS borrower_id,
               (SELECT name FROM borrowers WHERE borrower_id = p_borrower_id) AS updated_name,
               (SELECT email FROM borrowers WHERE borrower_id = p_borrower_id) AS updated_email;
    ELSE
        SELECT 'No update performed. The borrower may not exist.' AS message;
    END IF;
END //

DELIMITER ;
CALL UpdateBorrowerInfo(1, 'New Name', NULL);

/*task6:Write a query to create a procedure that accepts a
borrower ID as a parameter. It retrieves the
borrower's record from the loans table and checks for
‘any outstanding overdue books. Based on the
presence of overdue books, the procedure returns
the status of the borrower, indicating whether the
borrower is eligible for borrowing (if the borrow count
is not greater than 0) or not.
Hint: Utilize IF-THEN-ELSE (refer to Additional
Material) to check the eligibility status of borrowers.*/

DELIMITER //

CREATE PROCEDURE CheckBorrowerEligibility(IN p_borrower_id INT)
BEGIN
    DECLARE v_overdue_count INT;
    DECLARE v_borrow_count INT;
    DECLARE v_status VARCHAR(50);

    -- Count overdue books
    SELECT COUNT(*) INTO v_overdue_count
    FROM loans
    WHERE borrower_id = p_borrower_id
    AND return_date IS NULL
    AND loan_date < DATE_SUB(CURDATE(), INTERVAL 14 DAY);

    -- Count current borrowed books
    SELECT COUNT(*) INTO v_borrow_count
    FROM loans
    WHERE borrower_id = p_borrower_id
    AND return_date IS NULL;

    -- Check eligibility
    IF v_overdue_count > 0 THEN
        SET v_status = 'Not Eligible - Has overdue books';
    ELSEIF v_borrow_count >= 3 THEN
        SET v_status = 'Not Eligible - Maximum books borrowed';
    ELSE
        SET v_status = 'Eligible for borrowing';
    END IF;

    -- Return the result
    SELECT 
        p_borrower_id AS borrower_id,
        v_overdue_count AS overdue_books,
        v_borrow_count AS current_borrowed,
        v_status AS eligibility_status;
END //

DELIMITER ;
CALL CheckBorrowerEligibility(1);

/*Task6:continuation:*/
DELIMITER //

CREATE PROCEDURE CustomizeBorrowerEligibilityCheck(IN p_borrower_id INT)
BEGIN
    DECLARE v_borrower_name VARCHAR(255);
    DECLARE v_overdue_count INT;
    DECLARE v_borrow_count INT;
    DECLARE v_status VARCHAR(50);

    -- Get borrower's name
    SELECT name INTO v_borrower_name
    FROM borrowers
    WHERE borrower_id = p_borrower_id;

    -- Call the CheckBorrowerEligibility procedure and store results
    CALL CheckBorrowerEligibility(p_borrower_id);
    
    -- Capture the results
    SET v_overdue_count = (SELECT overdue_books FROM (SELECT overdue_books FROM CheckBorrowerEligibility) AS temp);
    SET v_borrow_count = (SELECT current_borrowed FROM (SELECT current_borrowed FROM CheckBorrowerEligibility) AS temp);
    SET v_status = (SELECT eligibility_status FROM (SELECT eligibility_status FROM CheckBorrowerEligibility) AS temp);

    -- Customize the output
    IF v_borrower_name IS NULL THEN
        SELECT 'Borrower not found.' AS message;
    ELSE
        SELECT 
            CONCAT('Borrower: ', v_borrower_name) AS borrower_info,
            CASE 
                WHEN v_overdue_count > 0 THEN CONCAT('Has ', v_overdue_count, ' overdue book(s).')
                ELSE 'No overdue books.'
            END AS overdue_status,
            CONCAT('Currently borrowed books: ', v_borrow_count) AS current_borrows,
            CASE 
                WHEN v_status = 'Eligible for borrowing' THEN 'Eligible to borrow more books.'
                ELSE 'Not eligible to borrow more books at this time.'
            END AS eligibility_status,
            CASE
                WHEN v_status = 'Eligible for borrowing' THEN 
                    CONCAT('Can borrow up to ', 3 - v_borrow_count, ' more book(s).')
                WHEN v_overdue_count > 0 THEN 'Please return overdue books to regain borrowing privileges.'
                ELSE 'Please return some books to borrow more.'
            END AS recommendation;
    END IF;
END //

DELIMITER ;



