use sakila;



-- 1.Select the first name, last name, and email address of all the customers who 
-- have rented a movie.
select * from rental;
select * from customer;

	-- subquery: who has rented a movie?
select distinct(customer_id) from rental;

	-- query
select first_name, last_name, email from customer
inner join (
	select distinct(customer_id) from rental
    )sub1
using(customer_id);



-- 2.What is the average payment made by each customer (display the customer id, 
-- customer name (concatenated), and the average payment made).
select * from payment;
select * from customer;

	-- subquery: avg payment per customer_id
select customer_id, avg(amount) average_payment
from payment
group by customer_id;

	-- query: join with the names
select customer_id, concat(first_name, ' ', last_name) as customer, average_payment
from (
	select customer_id, avg(amount) average_payment
	from payment
	group by customer_id
    )sub1
left join customer using(customer_id);



-- 3.Select the name and email address of all the customers who have rented the "Action" movies.
-- Write the query using multiple join statements
-- Write the query using sub queries with multiple WHERE clause and IN condition
-- Verify if the above two queries produce the same results or not
select * from rental;
select * from film;
select * from film_category;
select * from category;
select * from customer;
select * from inventory;

	-- subquery: get the category_id 'Action'
select category_id from category
where name = 'Action';

	-- subquery: get all film_ids that match the category_id
select film_id from film_category
where category_id = (
	select category_id from category
	where name = 'Action'
    );

	-- subquery: get all the copies in the inventory of these films
select inventory_id from inventory
where film_id in (
	select film_id from (
		select film_id from film_category
		where category_id = (
			select category_id from category
			where name = 'Action'
			)
)sub1
);

	-- subquery: get the customers who rented one of those copies
select customer_id from rental
where inventory_id in (
	select inventory_id from (
		select inventory_id from inventory
		where film_id in (
			select film_id from (
				select film_id from film_category
				where category_id = (
					select category_id from category
					where name = 'Action'
					)
		)sub1
		)
)sub2
);

	-- query: collect the info of the customers
select concat(first_name, ' ', last_name) as customer, email
from customer
where customer_id in (
	select customer_id from (
		select customer_id from rental
		where inventory_id in (
			select inventory_id from (
				select inventory_id from inventory
				where film_id in (
					select film_id from (
						select film_id from film_category
						where category_id = (
							select category_id from category
							where name = 'Action'
							)
				)sub1
				)
		)sub2
		)
)sub3
);

	-- Now with joins:
select concat(first_name, ' ', last_name) as customer, email from customer
inner join rental using(customer_id)
inner join inventory using(inventory_id)
inner join film_category using(film_id)
inner join category using(category_id)
where name = 'Action';
	-- it doesn't return the same result. I have checked and there are customers duplicated.
	-- let's try to get rid of them.

select distinct concat(first_name, ' ', last_name) as customer, email from customer 
inner join rental using(customer_id)
inner join inventory using(inventory_id)
inner join film_category using(film_id)
inner join category using(category_id)
where name = 'Action';
	-- now it is the same resultas with the subqueries. But I cannot explain why the results weren't the same.



-- 4.Use the case statement to create a new column classifying existing columns as either or high 
-- value transactions based on the amount of payment. If the amount is between 0 and 2, label should 
-- be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, 
-- then it should be high.
select * from payment;

select 	payment_id, customer_id, rental_id, amount, 
		case 	when amount between 0 and 2 then 'low'
				when amount between 2 and 4 then 'medium'
				else 'high'
				end as value_trans,
		payment_date
from payment;






