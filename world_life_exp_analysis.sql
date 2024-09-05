SELECT *
FROM world_life_expectancy.worldlifexpectancy;

# the following query helps us to see which countries had the highest increase of life expectancy 
#and which countries didn't increase as much. 

select country, 
min(Lifeexpectancy), 
max(Lifeexpectancy),
round(max(Lifeexpectancy) - min(Lifeexpectancy),1) as Life_Increase_15_Years
FROM world_life_expectancy.worldlifexpectancy
group by country
Having min(Lifeexpectancy) <> 0 and max(Lifeexpectancy) <> 0
order by  Life_Increase_15_Years desc
 ;
 
 SELECT *
FROM world_life_expectancy.worldlifexpectancy;

#Now, let's check the increases per year. 

SELECT Year, Round(Avg(Lifeexpectancy),2)
FROM world_life_expectancy.worldlifexpectancy
Group By Year
Having min(Lifeexpectancy) <> 0 and max(Lifeexpectancy) <> 0  
Order by Year
;

#Check for correlations between Life expectancy and GDP

SELECT country,
       round(avg(Lifeexpectancy), 2) as Avg_Life_Exp,
       round(avg(GDP), 2) as Avg_GDP
FROM world_life_expectancy.worldlifexpectancy
GROUP BY country
HAVING Avg_GDP > 0 and Avg_Life_Exp > 0
ORDER BY Avg_GDP desc;


SELECT country,
       round(avg(Lifeexpectancy), 2) as Avg_Life_Exp,
       round(avg(GDP), 2) as Avg_GDP
FROM world_life_expectancy.worldlifexpectancy
GROUP BY country
HAVING Avg_GDP > 0 and Avg_Life_Exp > 0
ORDER BY Avg_GDP desc;

Select 
Sum(Case When GDP >=1500 then 1 else 0 End) High_GDP_Count,
Round(AVG(Case When GDP >=1500 then Lifeexpectancy else null End),1) Low_GDP_Lifeexpectancy,
Sum(Case When GDP <=1500 then 1 else 0 End) High_GDP_Count,
Round(AVG(Case When GDP <=1500 then Lifeexpectancy else null End),1) Low_GDP_Lifeexpectancy
From world_life_expectancy.worldlifexpectancy;

Select status,
Count(Distinct country),
round(avg(Lifeexpectancy),2)
From world_life_expectancy.worldlifexpectancy
Group By status;

#potential correllations between bmi and lifeexpectancy

Select country,  
round(avg(lifeexpectancy),1) as Avg_Life_Exp, 
round(avg(bmi),1) as Avg_Bmi
From world_life_expectancy.worldlifexpectancy
Group By country
Having Avg_Life_Exp <> 0 and Avg_Bmi <> 0
Order By Avg_Bmi desc;

 SELECT country, 
 year,
 Lifeexpectancy, 
 AdultMortality,
 sum(AdultMortality)over(partition by country order by year) as rolling_total
FROM world_life_expectancy.worldlifexpectancy;