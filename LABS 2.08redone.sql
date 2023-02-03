USE sakila;

-- Write a query to display for each store its store ID, city, and country.-- 

SELECT s.store_id, c.city, co.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id;;

-- Write a query to display how much business, in dollars, each store brought in.

SELECT p.address, SUM(p.amount) as 'total business'
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN (
  SELECT s.store_id, a.address
  FROM store s 
  JOIN address a ON a.address_id = s.address_id
) b ON i.store_id = b.store_id
GROUP BY p.address;

-- Which film categories are longest?

SELECT c.name, AVG(f.length) as avg_length
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length) > (SELECT AVG(length) FROM film)
ORDER BY AVG(f.length) DESC;


-- Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(f.title) as rentals
FROM film f 
JOIN rental r ON f.film_id = r.film_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER BY rentals DESC;



-- List the top five genres in gross revenue in descending order.Is "Academy Dinosaur" available for rent from Store 1?

select film.film_id, film.title, store.store_id, inventory.inventory_id
from inventory join store using (store_id) join film using (film_id)
where film.title = 'Academy Dinosaur' and store.store_id = 1;

SELECT i.inventory_id
FROM rental r
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN store s ON i.store_id = s.store_id
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'Academy Dinosaur'
AND s.store_id = 1
AND r.return_date IS NOT NULL;


-- Get all pairs of actors that worked together.

SELECT f.film_id, a1.actor_id as actor_id1, a2.actor_id as actor_id2, 
       concat(a1.first_name, " ", a1.last_name) as actor1, 
       concat(a2.first_name, " ", a2.last_name) as actor2
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a1 ON fa.actor_id = a1.actor_id
JOIN film_actor fa2 ON f.film_id = fa2.film_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
WHERE f.film_id = <insert_film_id> AND fa.actor_id <> fa2.actor_id;


-- Get all pairs of customers that have rented the same film more than 3 times.

SELECT concat(first_name, ' ', last_name) AS Customer_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category ca ON fc.category_id = ca.category_id
WHERE ca.name = '' AND r.rental_id > 3
GROUP BY Customer_name
HAVING COUNT(*) > 3
ORDER BY Customer_name;


-- For each film, list actor that has acted in more films.
SELECT actor_id, first_name, last_name, COUNT(actor_id) AS film_count
FROM film_actor
JOIN actor ON film_actor.actor_id = actor.actor_id
GROUP BY actor_id
ORDER BY film_count DESC
LIMIT 1;
