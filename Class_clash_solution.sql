/* Following are the two T-SQL solutions to identify clashes for a set of trainers based on their class schedule. 
Specifically, the class that starts while another class is still busy.
*/

--1. Following query will produce results for clashing classes as being asked in the Stage1 interview SQL query.

select trainerid, starttime, endtime  from (
select trainerid, starttime, endtime, lag(endtime) over(partition by trainerid order by starttime) as last_class_end from class) as cl
where starttime<=last_class_end;



--2. Following query will produce results for both clashing class and the class with which it is being clashed with.

with cte as
(
  select *, row_number() over(order by trainerid,starttime) as rn from class
)

select distinct t1.* from cte t1 inner join cte t2
on t1.rn<>t2.rn
and t1.trainerid=t2.trainerid
and t1.starttime<=t2.endtime
and t1.endtime>=t2.starttime