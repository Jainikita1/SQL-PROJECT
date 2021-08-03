/*1. We want to run an Email Campaigns for customers of Store 2 (First, Last name, and Email address of customers from Store 2) */

 select first_name,last_name,email from customer  where store_id=2;

 /* 2. List of the movies with a rental rate of 0.99$*/

 select * from film where rental_rate=0.99;

 /* 3.Your objective is to show the rental rate and how many movies are in each rental rate categories*/

 select rental_rate,COUNT(*) AS MOVIE_COUNT from film GROUP BY 1;

 /*4. Which rating do we have the most films in?*/

 select rating,COUNT(*) AS MOVIE_COUNT from film group by 1 ORDER BY 2  DESC;

 /*5. Which rating is most prevalent in each store?*/

 select rating,COUNT(store_id) store1_count from  film JOIN inventory ON film.film_id=inventory.film_id where store_id=1  group by rating order by 2 DESC;
 select rating,COUNT(store_id) store2_count from  film JOIN inventory ON film.film_id=inventory.film_id where store_id=2  group by rating order by 2 DESC;

 /*6. We want to mail the customers about the upcoming promotion*/

select c. customer_id AS user ,first_name AS Name ,email, f.title AS UPCOMING_MOVIE from customer c inner join rental r using (customer_id) inner join inventory i using (inventory_id) inner join film f using (film_id) where c.active=TRUE and f.release_year >= YEAR(CURDATE()) ;

/*7. List of films by Film Name, Category, Language*/

select title AS film_name,category.name AS category,language.name AS language from film inner join category inner join language limit 1;

/*8. How many times each movie has been rented out?*/

select f.film_id,f.title as name,count(rental_id) as rental_count from film f inner join inventory i on i.film_id = f.film_id inner join rental r on r.inventory_id = i.inventory_id group by f.film_id order by rental_count desc;

/*9. What is the Revenue per Movie?*/

select f.film_id,f.title AS MOVIE ,SUM(amount) AS Revenue_Per_Film from film f inner join inventory i using (film_id) inner join rental r using (inventory_id) inner join store s using (store_id) inner join payment p using (rental_id) group by 1 order by 1;

/*10.Most Spending Customer so that we can send him/her rewards or debate points 11. What Store has historically brought the most revenue?*/

select c.first_name,c.customer_id,SUM(amount) from payment p inner join customer c on p.customer_id=c.customer_id  group by c.customer_id order by 3 desc limit 1;

/*11. What Store has historically brought the most revenue?*/

select store_id,SUM(amount) AS Revenue from film f inner join inventory i using (film_id) inner join rental r using (inventory_id) inner join store s using (store_id) inner join payment p using (rental_id) group by 1 order by 2 desc limit 1;

/*12.How many rentals do we have for each month?*/

select MONTH(rental_date) AS month,COUNT(inventory_id) AS no_of_rentals FROM rental group by 1 Order by 2 Desc;

/*13.Rentals per Month (such Jan => How much, etc)*/

select MONTHNAME(rental_date) AS month,COUNT(inventory_id) AS no_of_rentals FROM rental group by 1 Order by 2 Desc;

/*14. Which date the first movie was rented out?*/
select f.film_id,f.title,r.rental_date from film f inner join inventory i on i.film_id=f.film_id inner join rental r on r.inventory_id=i.inventory_id order by r.rental_date limit 1;

/* 15.Which date the last movie was rented out?*/

select f.film_id,f.title,r.rental_date from film f inner join inventory i on i.film_id=f.film_id inner join rental r on r.inventory_id=i.inventory_id order by r.rental_date DESC limit 1; 

/* 16.For each movie, when was the first time and last time it was rented out? 17.What is the Last Rental Date of every customer?*/

select f.film_id,f.title,MIN(rental_date) AS FIRST_RENTAL_DATE, MAX(rental_date) AS LAST_RENTAL_DATE from film f inner join inventory i using (film_id) inner join rental r using (inventory_id) group by 1;

/*17.What is the Last Rental Date of every customer?*/

select MAX(rental_date) AS Last_rent_date,customer_id from rental group by customer_id;

/* 18.What is our Revenue Per Month?*/

select MONTHNAME(payment_date),SUM(amount) AS Revenue from payment group by 1 order by 2 desc ;

/* 19.How many distinct Renters do we have per month?*/

select MONTHNAME(payment_date) AS MONTH,COUNT( DISTINCT customer_id) AS TOTAL_RENTERS from payment group by 1 order by 2 DESC;

/* 20.Show the Number of Distinct Film Rented Each Month*/
select MONTHNAME(rental_date) AS MONTH,COUNT(DISTINCT f.film_id) AS COUNT  from film f inner join inventory i on i.film_id=f.film_id inner join rental r on r.inventory_id=i.inventory_id group by 1 order by 2 desc;

/* 21.Number of Rentals in Comedy, Sports, and Family*/

select name,count(rental_id) AS rental_count from category inner join film_category using (category_id) inner join film using (film_id) inner join inventory using (film_id) inner join rental using (inventory_id) where name IN ('Comedy','Sports','Family') group by name order by 2 desc ;

/* 22.Users who have been rented at least 3 times*/

select customer_id,COUNT(rental_id) AS RENTAL_COUNT from rental group by 1 HAVING RENTAL_COUNT >=3 order by 1 ;

/* 23.How much revenue has one single store made over PG13 and R-rated films? */
select store_id,SUM(amount) AS Revenue from film f inner join inventory i using (film_id) inner join rental r using (inventory_id) inner join store s using (store_id) inner join payment p using (rental_id) where f.rating IN ('PG13','R') group by store_id order by 1 ;

/*24.Active User where active = 1*/

select customer_id,first_name from customer where active=TRUE;

/* 25.Reward Users: who has rented at least 30 times*/

select customer_id AS Reward_user_id,COUNT(rental_id) AS RENTAL_COUNT from rental group by 1 HAVING RENTAL_COUNT >=30 order by 1 ;

/* 26.Reward Users who are also active*/
select customer_id AS Reward_user_id,COUNT(rental_id) AS RENTAL_COUNT from rental inner join customer using (customer_id) where customer.active=TRUE group by 1 HAVING RENTAL_COUNT >=30 order by 1 ;

/* 27.All Rewards Users with Phone*/
select customer_id AS Reward_user_id,COUNT(rental_id) AS RENTAL_COUNT,phone  from rental inner join customer using (customer_id) inner join address using(address_id)  where customer.active=TRUE  group by 1 HAVING RENTAL_COUNT >=30 order by 1 ;
