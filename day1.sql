
with
children as
(
	select 
		child_id,
		name as child_name
	from public.children
),

toy_catalogue as
(
	select 
		toy_id,
		toy_name,
		category,
		difficulty_to_make,
		case category
			when 'outdoor' then 'Outside Workshop'
			when 'educational' then 'Learning Workshop'
			else 'General Workshop'
		end as workshop_assignment,
		case difficulty_to_make
			when 1 then 'Simple Gift'
			when 2 then 'Moderate Gift'
			else 'Complex Gift'
		end as gift_complexity
	from public.toy_catalogue
),

expanded_wish_list as
(
	select
		list_id,
		child_id,
		wishes,
		wishes->'colors'->>0 as first_color_choice,
		json_array_length(wishes->'colors') as color_count,
		wishes->>'first_choice' as first_choice,
		wishes->>'second_choice' as second_choice,
		submitted_date,
		row_number() over (partition by child_id order by submitted_date desc) as wish_order
	from public.wish_lists 
),

gift_list as
(
	select 
        -- child_id,
		child_name as name,
		first_choice as primary_wish,
		second_choice as backup_wish,
		first_color_choice as favorite_color,
		color_count,
        -- wishes,
        -- difficulty_to_make,
        -- category,
		gift_complexity,
		workshop_assignment
	from expanded_wish_list
	inner join children using(child_id)
	inner join toy_catalogue on toy_name = first_choice
	where wish_order = 1
)

select * from gift_list
order by name


