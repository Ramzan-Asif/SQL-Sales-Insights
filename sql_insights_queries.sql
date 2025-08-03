
-- Total quantity of tracks sold per genre, ordered by most sold:
select t.genreid, g.name, sum(i.Quantity) as total_Qty from invoiceline i
join track t on t.trackid = i.trackid
join genre g on g.genreid = t.genreid
group by t.genreid, g.name order by total_Qty desc;

-- Total quantity of albums sold per artist, ordered by most sold:
select a.name as artist_name, sum(i.Quantity) as total_Qty_of_albums_sold
from invoiceline i join track t
on t.trackid = i.trackid
join album ab on ab.albumid = t.albumid
join artist a on a.artistid = ab.artistid
group by a.name order by total_Qty_of_albums_sold desc;

-- Total revenue generated per artist, ordered by highest revenue:
select a.artistid, a.name as atrist_name,
sum(il.unitprice * il.quantity) as revenue
from invoiceline il join track t 
on t.trackid = il.trackid
join album ab on ab.albumid = t.albumid
join artist a on a.artistid = ab.artistid
group by a.artistid, a.name
order by revenue desc;

-- Total amount spent by each customer, ordered by top spenders:
select c.customerid, c.firstname || ' ' || c.lastname as customer_name,
sum(i.total) as total_spent from invoice i join customers c
on c.customerid = i.customerid
group by c.customerid, c.firstname || ' ' || c.lastname order by total_spent desc;

-- Total revenue generated per billing country, ordered by highest revenue:
select billingcountry, sum(total) as revenue
from invoice group by billingcountry
order by revenue desc;

-- Monthly revenue grouped by invoice date (Year-Month), ordered by oldest to newest:
select to_char(invoicedate, 'YYYY-MM') as month_year, sum(total) as revenue
from invoice group by to_char(invoicedate, 'YYYY-MM') order by month_year asc;

-- Top 10 most sold tracks overall:
select trackid, name, units_sold
from (select t.trackid, t.name, sum(il.Quantity) as units_sold
from track t join invoiceline il
on t.trackid = il.trackid
group by t.trackid, t.name
order by units_sold desc)
where rownum <= 10;

-- Top-selling track per country (only 1 track per country with highest units sold):
select country, track_name, units_sold
from (
  select 
    i.billingcountry as country,
    t.name as track_name, 
    sum(il.Quantity) as units_sold,
    row_number() over (partition by i.billingcountry order by sum(il.Quantity) desc) as rnk
  from invoice i 
  join invoiceline il on i.invoiceid = il.invoiceid
  join track t on t.trackid = il.trackid
  group by i.billingcountry, t.name
)
where rnk = 1;

