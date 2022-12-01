USE sakila;

-- Write a query to display for each store its store ID, city, and country.-- 

SELECT d.store_id, d.address, d.city, country.country from country
JOIN 
	(SELECT b.store_id, b.address, c.city, c.country_id FROM city c 
	JOIN 
		(SELECT s.store_id, a.address, a.city_id from store s 
		JOIN address a ON s.address_id = a.address_id) b ON (b.city_id = c.city_id)
		) d ON (d.country_id = country.country_id);

-- Write a query to display how much business, in dollars, each store brought in.

SELECT address, SUM(amount) as 'total business' from payment p JOIN(		
	SELECT address, rental_id FROM rental r JOIN( 
		SELECT address, inventory_id FROM inventory i
			JOIN (
				SELECT s.store_id as store_id, a.address FROM store s 
				JOIN address a ON a.address_id = s.address_id) b
				ON i.store_id = b.store_id
				) c ON c.inventory_id = r.inventory_id)
                d ON d.rental_id = p.rental_id GROUP BY address;

-- Which film categories are longest?

select category.name, avg(length)
from film join film_category using (film_id) join category using (category_id)
group by category.name
having avg(length) > (select avg(length) from film)
order by avg(length) desc;



-- Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(f.title) as rentals from film f 
JOIN 
	(SELECT r.rental_id, i.film_id FROM rental r 
    JOIN 
    inventory i ON i.inventory_id = r.inventory_id) a
    ON a.film_id = f.film_id GROUP BY f.title ORDER BY rentals DESC;



-- List the top five genres in gross revenue in descending order.Is "Academy Dinosaur" available for rent from Store 1?

select film.film_id, film.title, store.store_id, inventory.inventory_id
from inventory join store using (store_id) join film using (film_id)
where film.title = 'Academy Dinosaur' and store.store_id = 1;

select inventory.inventory_id
from inventory join store using (store_id)
     join film using (film_id)
     join rental using (inventory_id)
where film.title = 'Academy Dinosaur'
      and store.store_id = 1
      and not exists (select * from rental
                      where rental.inventory_id = inventory.inventory_id
                      and rental.return_date is null);


-- Get all pairs of actors that worked together.

select f.film_id, fa1.actor_id, fa2.actor_id, concat(a1.first_name," ", a1.last_name), concat(a2.first_name," ", a2.last_name)
from film f
    inner join film_actor fa1 

    on f.film_id=fa1.film_id
    
    inner join actor a1
    on fa1.actor_id=a1.actor_id
    
    inner join film_actor fa2
    on f.film_id=fa2.film_id
    
    inner join actor a2
    on fa2.actor_id=a2.actor_id   
where f.film_id = ;



-- Get all pairs of customers that have rented the same film more than 3 times.

select concat(first_name, ' ', last_name) as Customer_name
from customer c
inner join rental r on r.customer_id = c.customer_id
inner join inventory i on i.inventory_id = r.inventory_id
inner join film f on f.film_id = i.film_id
inner join film_category fc on fc.film_id = f.film_id
inner join category ca on ca.category_id = fc.category_id
where name = '' and rental_id > 3
group by Customer_name
having count(*) > 3
order by Customer_name;



-- For each film, list actor that has acted in more films.

select actor.actor_id, actor.first_name, actor.last_name,
       count(actor_id) as film_count
from actor join film_actor using (actor_id)
group by actor_id
order by film_count desc
limit 1;