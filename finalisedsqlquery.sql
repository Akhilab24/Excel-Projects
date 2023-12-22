use genzdataset;
show tables;
select * from learning_aspirations;
select * from manager_aspirations;
select * from mission_aspirations;
select * from personalized_info;

select * from learning_aspirations l left join manager_aspirations m1 on l.ResponseID= m1.ResponseID 
left join mission_aspirations m2 on m1.ResponseID=m2.ResponseID
left join personalized_info p on m2.ResponseID=p.ResponseID;



----- 1. what percentage of male and female genz wnats to go to office every day
select 
round((sum(case when Gender = 'Male\r' then 1 else 0 end)/count(*))*100,2) as Male_Genz,
round((sum(case when Gender = 'Female\r' then 1 else 0 end)/count(*))*100,2) as Female_Genz
from personalized_info p
inner join learning_aspirations l on l.ResponseID=p.ResponseID
where preferredWorkingEnvironment='Every day office environment';

----- 2. what percentage of Genz's who have chosen their career in business operations are most likely to be influenced by their parents

select 
round((sum(case when ClosestAspirationalCareer like 'Business operations%' then 1 else 0 end)/count(*))*100,2) as Genz_BO
from learning_aspirations
where CareerInfluenceFactor='My Parents';

----- 3.what percentage of Genz's prefer opting for higher studies,give gender wise approach
select
round((sum(case when highereducationabroad like 'yes%' then 1 else 0 end)/count(*))*100,2)as percentage_genz,
gender from personalized_info p
inner join learning_aspirations as l on p.responseid=l.responseid
group by gender;


----- 4.what percentage of Genz's are willing and not willing to work for a company whose mission is misaligned with their public actions or even their products
select
round((sum(case when gender='Male\r' and misalignedmissionlikelihood like 'will work%' then 1 else 0 end)/count(*))*100,2) as Male_willwork,
round((sum(case when gender='Male\r' and misalignedmissionlikelihood like 'will not  work%' then 1 else 0 end)/count(*))*100,2) as Male_willnotwork,
round((sum(case when gender='Female\r' and misalignedmissionlikelihood like 'will work%' then 1 else 0 end)/count(*))*100,2) as Female_willwork,
round((sum(case when gender='Female\r' and misalignedmissionlikelihood like 'will not work%' then 1 else 0 end)/count(*))*100,2) as Female_willnotwork
from personalized_info p
inner join mission_aspirations m on p.responseid=m.responseid;

----- 5. what is the most suitable environment according to female genz
select PreferredWorkingEnvironment,
count(*) as count
from learning_aspirations l
inner join personalized_info p on l.responseid=p.responseid
where gender='female\r'
group by preferredworkingenvironment
order by count(*) desc
limit 1;


----- 6. Calculate the total number of female who aspire to work in their closest aspirational career and have no social impact likelihood of 1 to 5
select count(gender) as Female_genz_count
from personalized_info p
inner join learning_aspirations l on p.responseid=l.responseid
inner join mission_aspirations m on m.responseid=l.responseid
where gender='female\r' and nosocialimpactlikelihood between 1 and 5;

----- 7.retrive the male who are intrested in higher education abroad and a career influence factor of my parents
select count(case when p.Gender='male\r' then 1 end) as Male_genz
from personalized_info p
inner join learning_aspirations l on p.responseid=l.responseid 
where HigherEducationAbroad like 'yes%' and CareerInfluenceFactor='my parents';

----- 8.determine percentage of gender who have no social impact likelihood of 8 to 10 among those who are intrested in higher education abroad
select
round((sum(case when Gender = 'Male\r' then 1 else 0 end)/count(*))*100,2) as Malegenz_percentage,
round((sum(case when Gender = 'Female\r' then 1 else 0 end)/count(*))*100,2) as Femalegenz_percentage
from personalized_info p
inner join mission_aspirations m on p.responseid=m.responseid
inner join learning_aspirations l on m.responseid=l.responseid
where nosocialimpactlikelihood between 8 and 10
and highereducationabroad like 'yes%';


----- 9.Give a detailed split of genz preferrences to work with teams,data should include male,female and overall in counts and also overall in %
select
 count(case when p.Gender='male\r' then 1 end) as Male_count,
 count(case when p.Gender='female\r' then 1 end) as female_count,
round((sum(case when Gender = 'Male\r' then 1 else 0 end)/count(*))*100,2) as Malegenz_percentage,
round((sum(case when Gender = 'Female\r' then 1 else 0 end)/count(*))*100,2) as Femalegenz_percentage
from personalized_info p
inner join manager_aspirations m2  on p.responseid=m2.responseid
where m2.preferredworksetup like '%team%' ;

----- 10. Give a  detailed breakdown of worklikelihood3years for each gender
select m2.worklikelihood3years,
count(case when p.Gender='male\r' then 1 end) as Male_count,
count(case when p.Gender='female\r' then 1 end) as female_count
 from personalized_info p 
 inner join manager_aspirations m2 on p.responseid=m2.responseid
 group by m2.worklikelihood3years;
 
 ----- 11.what is the average starting salary expectations at 3 year mark at each gender
 select gender, round(avg(expectedsalary3years),2) as average_expected_salary_3years
 from personalized_info p
 inner join mission_aspirations m on p.responseid=m.responseid
 group by gender;
 
 ----- 12.what is the average starting salary expectations at 5 year mark at each gender
 select gender, round(avg(expectedsalary5years),2) as average_expected_salary_5years
 from personalized_info p
 inner join mission_aspirations m on p.responseid=m.responseid
 group by gender;
 
 ----- 13.what is the average  higher bar salary expectations at 3 year mark at each gender
 select gender, round(avg(expectedsalary3years),2) as average_expected_higherbar_salary_3years
 from personalized_info p
 inner join mission_aspirations m on p.responseid=m.responseid
 where expectedsalary3years like '%50%' group by gender;
 
----- 14.what is the average  higher bar salary expectations at 5 year mark at each gender
select gender, round(avg(expectedsalary5years),2) as average_expected_higherbar_salary_5years
 from personalized_info p
 inner join mission_aspirations m on p.responseid=m.responseid
 where expectedsalary5years like '%50%' group by gender;
 
 ----- 15.what is the average starting salary expectations at 3 year mark at each gender and each state in india
 select gender,zipcode , round(avg(expectedsalary3years),2) as average_expected_salary_3years_eachstate_india
 from personalized_info p
 inner join mission_aspirations m on p.responseid=m.responseid
 where currentcountry='india' 
 group by gender,zipcode;
 
 ----- 16.what is the average starting salary expectations at 5 year mark at each gender and each state in india
 select gender,zipcode , round(avg(expectedsalary5years),2) as average_expected_salary_5years_eachstate_india
 from personalized_info p
 inner join mission_aspirations m on p.responseid=m.responseid
 where currentcountry='india' 
 group by gender,zipcode;
 
 ----- 17.what is the average  higher bar salary expectations at 3 year mark at each gender and each state in india
 select gender,zipcode , round(avg(expectedsalary3years),2) as average_expected_higherbar_salary_3years_eachstate_india
 from personalized_info p
 inner join mission_aspirations m on p.responseid=m.responseid
 where currentcountry='india'  and expectedsalary3years like '%50%'
 group by gender,zipcode;
 
 ----- 18.what is the average  higher bar salary expectations at 5 year mark at each gender and each state in india
 select gender,zipcode , round(avg(expectedsalary5years),2) as average_expected_higherbar_salary_5years_eachstate_india
 from personalized_info p
 inner join mission_aspirations m on p.responseid=m.responseid
 where currentcountry='india'  and expectedsalary5years like '%50%'
 group by gender,zipcode;
 
 ----- 19. give a detailed breakdown of the possibility of genz working for an org if the mission is misaligned for each state in india
 select zipcode,misalignedmissionlikelihood, 
 count(misalignedmissionlikelihood) as genz_count
 from personalized_info p
 inner join mission_aspirations m on p.responseid =m.responseid
 where currentcountry='india'
 group by zipcode,misalignedmissionlikelihood;