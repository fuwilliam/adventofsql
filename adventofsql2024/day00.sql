with 
children_gifts as
(
	select * from children 
	inner join christmaslist using(child_id)
	where was_delivered
)

select 
	country,
	city,
	count(child_id) as children_count,
	avg(naughty_nice_score) as avg_naughty_nice_score
from children_gifts
group by 1, 2
having count(child_id) >= 5 
order by 4 desc