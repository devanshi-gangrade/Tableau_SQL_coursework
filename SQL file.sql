use employees_mod;


#Gender Distribution by year
select
year(from_date) as calender_year,
e.gender,
count(e.emp_no) as number_of_employees
from t_employees e
join t_dept_emp d
on e.emp_no = d.emp_no
group by calender_year,e.gender
having calender_year >= '1990';


#Number of managers by department
select
d.dept_name,
ee.gender,
m.emp_no,
m.from_date,
m.to_date,
e.calender_year,
(case
when year(m.to_date) >= e.calender_year
and year(m.from_date) <= e.calender_year then 1
else 0
end) as active
from
(select year(hire_date) as calender_year
from t_employees
group by calender_year) e
cross join
t_dept_manager m
join t_departments d on m.dept_no = d.dept_no
join t_employees ee on m.emp_no = ee.emp_no
order by m.emp_no,calender_year;


#Average annual salary by year
select
e.gender,
d.dept_name,
round(avg(s.salary)) as salary,
year(s.from_date) as calender_year
from
t_salaries s
join t_employees e on s.emp_no = e.emp_no
join t_dept_emp m on m.emp_no = e.emp_no
join t_departments d on d.dept_no = m.dept_no
group by d.dept_no,e.gender,calender_year
having calender_year <= '2002'
order by d.dept_no;


#Average employee salary since 1990
delimiter $$
create procedure filter_salary (in p_min_salary float, in p_max_salary float)
begin

select 
e.gender,
d.dept_name,
avg(s.salary) as avg_salary
from
t_employees e
join t_dept_emp de on e.emp_no = de.emp_no
join t_salaries s on e.emp_no = s.emp_no
join t_departments d on d.dept_no = de.dept_no
where s.salary between p_min_salary and p_max_salary
group by d.dept_name, e.gender;

end $$

delimiter ;

call filter_salary(50000,90000);