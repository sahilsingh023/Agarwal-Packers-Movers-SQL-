USE agarwal_packers;

#1 Total bookings per branch
SELECT branch_id, COUNT(*) AS total_bookings
FROM bookings
GROUP BY branch_id
ORDER BY total_bookings DESC;


#2 Unassigned bookings
SELECT booking_id, booking_date
FROM bookings
WHERE vehicle_id IS NULL;


#3 Duplicate customers
SELECT customer_name, mobile_no, COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_name, mobile_no
HAVING COUNT(*) > 1;


#4 Delayed deliveries
SELECT booking_id, expected_delivery_date
FROM shipments
WHERE expected_delivery_date < CURDATE()
AND delivery_status <> 'Delivered';


#5 Vehicle utilization
SELECT v.vehicle_id,
COUNT(b.booking_id) AS total_trips
FROM vehicles v
LEFT JOIN bookings b
ON v.vehicle_id = b.vehicle_id
GROUP BY v.vehicle_id
ORDER BY total_trips DESC;


#6 Idle vehicles (not used in last 7 days)
SELECT vehicle_id, last_used_date
FROM vehicles
WHERE last_used_date < CURDATE() - INTERVAL 7 DAY;


#7 Revenue per city
SELECT city, SUM(amount) AS total_revenue
FROM payments
GROUP BY city
ORDER BY total_revenue DESC;


#8 Pending payments
SELECT booking_id, customer_id, amount
FROM payments
WHERE payment_status = 'Pending';


#9 Top 5 customers by revenue
SELECT customer_id,
SUM(amount) AS total_spent
FROM payments
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;


#10 Most used route
SELECT source_city, destination_city,
COUNT(*) AS total_trips
FROM shipments
GROUP BY source_city, destination_city
ORDER BY total_trips DESC
LIMIT 1;


#11 Cancelled bookings
SELECT *
FROM bookings
WHERE status = 'Cancelled';


#12 Low inventory alert
SELECT item_name, quantity, minimum_required
FROM inventory
WHERE quantity < minimum_required;


#13 Monthly revenue trend
SELECT DATE_FORMAT(payment_date,'%Y-%m') AS month,
SUM(amount) AS monthly_revenue
FROM payments
GROUP BY month
ORDER BY month;


#14 Repeat customers
SELECT customer_id, COUNT(*) AS total_bookings
FROM bookings
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY total_bookings DESC;


#15 Driver late reporting
SELECT driver_id, reporting_time, scheduled_time
FROM driver_attendance
WHERE reporting_time > scheduled_time;


#16 Average delivery time
SELECT ROUND(AVG(DATEDIFF(delivery_date, booking_date)),2) AS avg_delivery_days
FROM shipments
WHERE delivery_status = 'Delivered';


#17 Branch performance with revenue
SELECT b.branch_id,
COUNT(b.booking_id) AS total_orders,
SUM(p.amount) AS total_revenue
FROM bookings b
LEFT JOIN payments p
ON b.booking_id = p.booking_id
GROUP BY b.branch_id
ORDER BY total_revenue DESC;


#18 Customer city wise booking count
SELECT c.city,
COUNT(b.booking_id) AS total_orders
FROM customers c
JOIN bookings b
ON c.customer_id = b.customer_id
GROUP BY c.city
ORDER BY total_orders DESC;


#19 Overloaded vehicles
SELECT v.vehicle_id, v.capacity,
SUM(b.load_weight) AS total_load
FROM vehicles v
JOIN bookings b
ON v.vehicle_id = b.vehicle_id
GROUP BY v.vehicle_id, v.capacity
HAVING total_load > v.capacity;


#20 Best performing branch (CTE)
WITH branch_perf AS (
SELECT branch_id,
COUNT(*) AS total_bookings
FROM bookings
GROUP BY branch_id
)
SELECT *
FROM branch_perf
ORDER BY total_bookings DESC
LIMIT 1;