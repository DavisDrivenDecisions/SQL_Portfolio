SELECT *
FROM world_life_expectancy.worldlifexpectancy;

#search for duplicates by comparing the country and year columns

Select 
country, 
year,
Concat(country,year),
Count(Concat(country,year))
From world_life_expectancy.worldlifexpectancy
Group By country,year,Concat(country,year)
Having Count(Concat(country,year)) > 1;

#found 3 duplicates: Ireland, Senegal, and Zimbabwe. Next, I need to identify the row ids for the duplicates. 

Select *
From(
Select row_id, 
Concat(country,year), 
ROW_NUMBER() OVER(PARTITION BY Concat(country,year) ORDER BY Concat(country,year)) as row_num
From world_life_expectancy.worldlifexpectancy) as row_table 
Where row_num >1;

# the above formula identified the row_id of each duplicate. Now, I will write a query to remove  the duplicates. 

Delete From world_life_expectancy.worldlifexpectancy
Where row_id In( 
     Select row_id
From(
Select row_id, 
Concat(country,year), 
ROW_NUMBER() OVER(PARTITION BY Concat(country,year) ORDER BY Concat(country,year)) as row_num
From world_life_expectancy.worldlifexpectancy) as row_table 
Where row_num >1)
;

#Three rows were affected. Let's check by running the query beginning on row 17 again. If there is no output, then the duplicates have been removed. 

# There are blank spaces in the status column. Let's check to see how many there are. 

Select *
From world_life_expectancy.worldlifexpectancy
Where status = '';

Select Distinct(country)
From world_life_expectancy.worldlifexpectancy
Where status = 'Developing';

Update world_life_expectancy.worldlifexpectancy t1
Join world_life_expectancy.worldlifexpectancy t2
On t1.country = t2.country
Set t1.status = 'Developing'
Where t1.status = ''
And t2.status <> ''
And t2.status = 'Developing'
;

Update world_life_expectancy.worldlifexpectancy t1
Join world_life_expectancy.worldlifexpectancy t2
On t1.country = t2.country
Set t1.status = 'Developed'
Where t1.status = ''
And t2.status <> ''
And t2.status = 'Developed'
;

#All blank fields have been populated. Check by running the query on Line 42.

 # There are some blanks in the Life Expectancy column that we will fill now. 
 
Select country,year, lifeexpectancy 
From world_life_expectancy.worldlifexpectancy;
#Where Lifeexpectancy = ''

# Here I joined the table to itself twice in oreder to find the avg increase around the #years that were blank. Row 81 shows the calculation needed in order to update the table 
# and populate the blanks.

Select t1.country,t1.year,t1.lifeexpectancy,
t2.country,t2.year,t2.lifeexpectancy, 
t3.country,t3.year,t3.lifeexpectancy,
Round((t2.lifeexpectancy + t3.lifeexpectancy) / 2,1)
From world_life_expectancy.worldlifexpectancy t1
Join world_life_expectancy.worldlifexpectancy t2
On t1.Country = t2.Country and t1.year = t2.year -1
Join world_life_expectancy.worldlifexpectancy t3
On t1.Country = t3.Country and t1.year = t3.year +1
Where t1.lifeexpectancy = '';

#Below is the successful update query. Lifeexpectancy no longer has any blanks. 

Update world_life_expectancy.worldlifexpectancy t1
Join world_life_expectancy.worldlifexpectancy t2
On t1.Country = t2.Country and t1.year = t2.year -1
Join world_life_expectancy.worldlifexpectancy t3
On t1.Country = t3.Country and t1.year = t3.year +1
Set t1.lifeexpectancy = Round((t2.lifeexpectancy + t3.lifeexpectancy) / 2,1)
Where t1.lifeexpectancy = ''
;

SELECT *
FROM world_life_expectancy.worldlifexpectancy;
