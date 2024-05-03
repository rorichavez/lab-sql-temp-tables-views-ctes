USE sakila;

SELECT * FROM customer;
# Step 1: Create a View
-- summarizes rental information for each customer. 
-- Should include: customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW summarizes_rental AS
SELECT c.customer_id, c.first_name, c.email, COUNT(r.rental_date) AS total_rentals 
FROM customer AS c
LEFT JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY customer_id
ORDER BY c.first_name;

SELECT * FROM summarizes_rental;

#Step 2: Create a Temporary Table
-- That calculates the total amount paid by each customer (total_paid). 
-- Should use the rental summary view created in Step 1 to join with the 
-- payment table and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE payment_table  AS
SELECT sr.customer_id, SUM(p.amount) AS total_paid
FROM summarizes_rental AS sr
LEFT JOIN payment AS p
ON sr.customer_id = p.customer_id
GROUP BY customer_id;

SELECT * FROM payment_table;

# Step 3: Create a CTE and the Customer Summary Report
-- That joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- Should include the customer's name, email address, rental count, and total amount paid.
-- Create the query to generate the final customer summary report, which should include: 
-- Customer name, email, rental_count, total_paid and average_payment_per_rental, 
-- this last column is a derived column from total_paid and rental_count.

WITH average_payment_per_rental AS (
	SELECT 
    sr.first_name, 
    sr.email,
    sr.total_rentals,
    pt.total_paid
    -- (total_paid  / total_rentals, 2) AS average_payment -- TAMBIÉN SE PUEDE PONER AQUI.
	FROM summarizes_rental AS sr 
	JOIN payment_table AS pt ON sr.customer_id =pt.customer_id
)
SELECT *, FORMAT(total_paid  / total_rentals, 2) AS average_payment
FROM average_payment_per_rental;

