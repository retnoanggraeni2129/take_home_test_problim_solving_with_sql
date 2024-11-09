CREATE TABLE final_project.order_tab(
	orderid int,
	userid int,
	itemid int, 
	gmv float, 
	order_time text
);

CREATE TABLE final_project.user_tab(
	userid int,
	register_time text,
	country text
);

SELECT 
	country, 
	COUNT(DISTINCT order_tab.userid) AS count_user
FROM final_project.order_tab
JOIN final_project.user_tab
	ON final_project.order_tab.userid = final_project.user_tab.userid
GROUP BY 1
ORDER BY 2 DESC;


SELECT 
	user_tab.country,
	COUNT(DISTINCT order_tab.orderid) AS count_order
FROM final_project.order_tab
JOIN final_project.user_tab
ON final_project.order_tab.userid = final_project.user_tab.userid
GROUP BY 1
ORDER BY 2 DESC;

SELECT 
	user_tab.userid, 
	MIN(register_time) AS first_order_date
FROM final_project.order_tab
JOIN final_project.user_tab
	ON final_project.order_tab.userid = final_project.user_tab.userid
GROUP BY 1
ORDER BY 2;

SELECT 
	o.userid, 
	o.orderid, 
	o.order_time, 
	o.gmv AS first_order_gmv
FROM final_project.order_tab o
JOIN (
    SELECT userid, MIN(order_time) AS first_order_time
    FROM final_project.order_tab
    GROUP BY userid
) first_orders 
	ON o.userid = first_orders.userid AND o.order_time = first_orders.first_order_time
ORDER BY o.orderid ASC;

SELECT 
	o.orderid, 
	o.userid, 
	o.order_time, 
	u.register_time
FROM final_project.order_tab o
JOIN final_project.user_tab u 
	ON o.userid = u.userid
WHERE o.order_time < u.register_time;

SELECT 
	o.orderid, 
	o.userid
FROM final_project.order_tab o
LEFT JOIN final_project.user_tab u 
	ON o.userid = u.userid
WHERE u.userid IS NULL;

WITH gmv_stats AS (
    SELECT AVG(gmv) AS avg_gmv, STDDEV(gmv) AS stddev_gmv
    FROM final_project.order_tab
)
SELECT o.orderid, o.userid, o.gmv
FROM final_project.order_tab o
JOIN gmv_stats gs ON 1=1
WHERE o.gmv > (gs.avg_gmv + 2 * gs.stddev_gmv) OR o.gmv < (gs.avg_gmv - 2 * gs.stddev_gmv);


