#How many copies of the film Hunchback Impossible exist in the inventory system?
USE sakila;

SELECT f.title, count(i.inventory_id)
FROM film as f
JOIN inventory as i
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP by f.title;

#List all films whose length is longer than the average of all the films.

SELECT f.title, f.length
FROM film as f
WHERE f.length > (SELECT
    avg(f.length)
	FROM film as f)
ORDER BY f.length DESC;

    
#Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name
FROM (SELECT a.actor_id, a.first_name, a.last_name, f.title
FROM actor as a
JOIN film_actor as fa
ON a.actor_id = fa.actor_id
JOIN film as f
ON fa.film_id = f.film_id
WHERE f.title = 'Alone Trip') sub1;

#Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.

SELECT * 
FROM film as f
JOIN film_category as fc
ON f.film_id = fc.film_id
JOIN category as c
ON fc.category_id = c.category_id
WHERE c.name = 'Family';

#Get name and email from customers from Canada using subqueries. 
#Do the same with joins. Note that to create a join, 
#you will have to identify the correct tables with their primary keys and foreign keys, 
#that will help you get the relevant information.

#SUBQUERY
SELECT first_name, last_name, email
FROM 
(SELECT c.first_name, c.last_name, c.email, co.country
FROM customer as c
JOIN address as a
ON c.address_id = a.address_id
JOIN city as ci
ON a.city_id = ci.city_id
JOIN country as co
ON ci.country_id = co.country_id
WHERE co.country = 'Canada') sub1;

#JOIN
SELECT c.first_name, c.last_name, c.email
FROM customer as c
JOIN address as a
ON c.address_id = a.address_id
JOIN city as ci
ON a.city_id = ci.city_id
JOIN country as co
ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

#Which are films starred by the most prolific actor? 
#Most prolific actor is defined as the actor that has acted in the most number of films. 
#First you will have to find the most prolific actor 
#and then use that actor_id to find the different films that he/she starred.

SELECT count(fa.film_id) as film_count #with this I got the actor_id
FROM actor as a
JOIN film_actor as fa
ON a.actor_id = fa.actor_id
JOIN film as f
ON fa.film_id = f.film_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 1;

SELECT fa.actor_id, a.first_name, a.last_name, f.title
FROM actor as a
JOIN film_actor as fa
ON a.actor_id = fa.actor_id
JOIN film as f
ON fa.film_id = f.film_id
WHERE fa.actor_id = (
SELECT actor_id
FROM(
SELECT a.actor_id, count(fa.film_id) as film_count #with this I got the actor_id
FROM actor as a
JOIN film_actor as fa
ON a.actor_id = fa.actor_id
JOIN film as f
ON fa.film_id = f.film_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 1) sub1);

#Films rented by most profitable customer. 
#You can use the customer table and payment table to find the most profitable customer
#ie the customer that has made the largest sum of payments

SELECT r.customer_id, c.first_name, c.last_name, f.title
FROM film as f
JOIN inventory as i
ON f.film_id = i.film_id
JOIN rental as r
ON i.inventory_id = r.inventory_id
JOIN customer as c
ON r.customer_id = c.customer_id
WHERE r.customer_id = (SELECT customer_id
FROM(
SELECT customer_id, sum(amount) as total_amount
FROM payment
GROUP BY customer_id
ORDER BY total_amount DESC
LIMIT 1) sub1);

#Customers who spent more than the average payments.

SELECT avg(amount) as avg_amount
FROM payment;

SELECT customer_id, avg(amount) as avg_amount
FROM payment
GROUP BY customer_id
HAVING avg_amount > (
SELECT avg(amount) as avg_amount
FROM payment)
ORDER BY avg_amount DESC
LIMIT 10;
