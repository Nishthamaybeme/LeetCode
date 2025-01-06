WITH SalesData AS (
    SELECT 
        u.product_id,
        u.units,
        p.price
    FROM 
        UnitsSold u
    JOIN 
        Prices p
    ON 
        u.product_id = p.product_id 
        AND u.purchase_date BETWEEN p.start_date AND p.end_date
),
WeightedPrice AS (
    SELECT 
        product_id,
        SUM(units * price) AS total_price,
        SUM(units) AS total_units
    FROM 
        SalesData
    GROUP BY 
        product_id
)
SELECT 
    p.product_id,
    ROUND(COALESCE(w.total_price / w.total_units, 0), 2) AS average_price
FROM 
    Prices p
LEFT JOIN 
    WeightedPrice w
ON 
    p.product_id = w.product_id
GROUP BY 
    p.product_id;
