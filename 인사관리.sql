--2022.07.25
--1.
select *
from employees
where commission_pct is not null;
--2.
select employee_id, last_name, salary, hire_date, department_id
from employees
order by salary asc;
--3.
select employee_id, last_name, to_char(hire_date,'YYYY-MM-DD'), salary
from employees;
--3-1.
select *
from employees
where hire_date = to_date('1997년 9월 17일', 'YYYY"년" MM"월" DD"일"');

--4.
select A.employee_id, A.last_name, B.department_id, B.DEPARTMENT_NAME
from employees A, departments B
where A.department_id = B.department_id;
--4-1.
select A.employee_id, A.last_name, B.department_id, B.DEPARTMENT_NAME
from employees A, departments B
where A.department_id = B.department_id
and a.salary >= 4000;
--4-2.
select  e.last_name, d.DEPARTMENT_NAME, l.CITY
from employees e, departments d, locations l
where e.department_id = d.department_id
and d.LOCATION_ID = l.location_id; 
--5.
select department_id, round(avg(nvl(salary,0)),0) AS "평균급여"
from employees
group by department_id;
--5-1.
select min(avg(nvl(salary,0))) 
from employees
group by department_id ;
--6.
select employee_id, last_name, salary, job_id, department_id
from employees
where department_id =
(select department_id
from employees where employee_id =142) ;
--7.
select employee_id, last_name, hire_date, ADD_MONTHS(hire_date,6) AS "입사 6개월 후"
from employees;
--8.
create table sawon(
S_NO number(4),
name varchar2(15) not null,
id varchar2(15) not null,
hiredate date,
pay number(4)
);
--8-1.
alter table sawon add PRIMARY key(s_no);
alter table sawon modify pay not null;
desc sawon;
--9(1).
insert into sawon values(101, 'Jason', 'ja101', to_date('17/09/01','YY/MM/DD'), 800);
insert into sawon (S_NO,name, id, hiredate) values(104, 'Min', 'm104', '14/07/02');
select * from sawon;
commit;
--9.(2).
update sawon set pay = 700 where S_NO = 104;
--10.(영구삭제)
drop table sawon PURGE;

-- 2022.07.25 PL/SQL
declare
v_fname varchar(20);
begin
  select first_name into v_fname from employees
  where employee_id =100;
end;
/

-- 출력값을 받기 위한 쿼리문--
set serveroutput on;

declare
v_fname varchar2(20);
begin
select first_name
into v_fname
from employees
where employee_id =100;
DBMS_OUTPUT.PUT_LINE(' The first Name of the Employee is ' || v_fname);
--println(DBMS_OUTPUT.PUT_LINE()) / print(DBMS_OUTPUT.PUT())--
end;
/

--2022.07.26
--스칼라(Scalar)변수
set serveroutput on;
declare
  v_myName varchar2(20);
BEGIN
  DBMS_OUTPUT.PUT_LINE('My name is: ' || v_myName);
  v_myName := 'John';
  DBMS_OUTPUT.PUT_LINE('My name is: ' || v_myName);
END;
/
declare
  v_myName varchar2(20) :='John';
BEGIN
  v_myName := 'Steven';
  DBMS_OUTPUT.PUT_LINE('My name is: ' || v_myName);
END;
/
declare
  employee_id number(6);
BEGIN
  select employee_id
  into employee_id
  from employees
  where last_name = 'Kochhar';
  DBMS_OUTPUT.PUT_LINE('employee_id:' || employee_id );
END;
/
declare
  v_employee_id number(6);
BEGIN
  select employee_id
  into v_employee_id
  from employees
  where last_name = 'Kochhar';
  DBMS_OUTPUT.PUT_LINE('employee_id:' || v_employee_id );
END;
/
declare
  v_emp_hiredate employees.hire_date%type;
  v_emp_salary employees.salary%type;
begin
  select hire_date, salary
  into v_emp_hiredate, v_emp_salary
  from employees
  where employee_id =100;
  dbms_output.put_line('Hire date is : ' || v_emp_hiredate);
  dbms_output.put_line('Hire date is : ' || v_emp_salary);
end;
/
--복습(치환변수 &, &&)
select * from employees where employee_id =&id;
select &&id, department_id from employees where &id=100;
--id의 값 : employee_id
--&id 변수 선언 해제
undefine id;
--바인드(Binde)변수
--variable g_monthly_sal number; 디벨로퍼에서는 사용안됨 run sql cammand Line에서 해야함
declare
  v_sal number(9,2) := 12000;
  --12000입력
begin
  :g_monthly_sal := v_sal/12;
end;
/
set autoprint on;
print g_monthly_sal;
/
--variable b_emp_salary number; 디벨로퍼에서는 사용안됨 run sql cammand Line에서 해야함
begin
  select salary
  into :b_emp_salary
  from employees where employee_id=178;
end;
/
print b_emp_salary;
select first_name, last_name
from employees
where salary=:b_emp_salary;
--중첩 블록 및 변수 범위
declare
v_outer_variable varchar2(20) :='GLOBAL VARIABLE';
begin
  declare
    v_inner_variable varchar2(20) :='LOCAL VARIABLE';
  begin
    dbms_output.put_line(v_inner_variable);
    dbms_output.put_line(v_outer_variable);
  end;
dbms_output.put_line(v_outer_variable);
--dbms_output.put_line(v_inner_variable); 하위 블록이므로 상위 블록(하위블록 범위밖)에서 쓸 수 없음
end;
/
declare
  v_weight number(3) := 600;
  v_message varchar2(255) := 'Product 10012';
begin
  declare
    v_weight number(7,2) := 50000;
    v_message varchar2(255) := 'Product 11001';
    v_new_locn varchar2(50) := 'Europe';
  begin 
    v_weight := v_weight+1;
    v_new_locn := 'western' || v_new_locn;
    dbms_output.put_line(v_weight);
    dbms_output.put_line(v_message);
    dbms_output.put_line(v_new_locn);
  end;
  v_weight := v_weight +1;
  v_message := v_message || ' is in stock';
  dbms_output.put_line(v_weight);
  dbms_output.put_line(v_message);
end;
/
--pL/SQL의 SELECT 문 (select ~ into~)
declare
  v_fname varchar2(25);
begin
  select first_name
  into v_fname
  from employees
  where employee_id = 200;
  DBMS_OUTPUT.PUT_LINE('First Name is :' ||v_fname);
END;
/
declare
  v_emp_hiredate employees.hire_date%type;
  v_emp_salary employees.salary%type;
begin
  select hire_date, salary
  into v_emp_hiredate, v_emp_salary
  from employees
  where employee_id =100;
  dbms_output.put_line('Hire date is : ' || v_emp_hiredate);
  dbms_output.put_line('Hire date is : ' || v_emp_salary);
end;
/
--1.사원번호를 입력(치환변수사용&)할 경우 사원번호, 사원이름, 부서이름을 출력하는 PL/SQL
declare
  v_id  employees.employee_id%type;
  v_name  employees.last_name%type;
  v_dname  departments.department_name%type;
begin
  select e.employee_id, e.last_name, d.DEPARTMENT_NAME
  into v_id, v_name, v_dname
  from employees e, departments d
  where e.DEPARTMENT_ID = d.DEPARTMENT_ID
  and e.employee_id = &v_id;
  DBMS_OUTPUT.PUT_LINE(v_id || v_name || v_dname);
end;
/
desc employees;
desc departments;
--2. 사원번호를 입력할 경우, 사원이름, 급여, 연봉->(급여*12+(nvl(급여,0)*nvl(커미션퍼센트,0)*12)) 출력
declare
  v_id  employees.employee_id%type;
  v_name  employees.last_name%type;
  v_sal   employees.SALARY%type;
  v_sal12  employees.SALARY%type; 
begin
  select last_name, SALARY, (SALARY*12+(nvl(SALARY,0)*nvl(COMMISSION_PCT,0)*12)) as 연봉
  into v_name, v_sal, v_sal12
  from employees
  where employee_id = &v_id;
  DBMS_OUTPUT.PUT_LINE(v_name || v_sal || v_sal12);
end;
/
--3-1. 사원번호를 입력할 경우 입사일 2000년 이후 'New employee' / 2000년 이전이면 'Career employee'
declare
  v_temp varchar2(50);
begin
  select
  case when to_char(hire_date,'YYYY') < '2000' then  'Career employee'
  else 'New employee'
  end
  as 비고
  into v_temp
  from employees
  where employee_id = &eno;
  DBMS_OUTPUT.PUT_LINE(v_temp);
end;
/
--SQL커서(SQL%ROWCOUNT)
declare
  v_rows_deleted varchar2(30);
  v_empno employees.employee_id%type := 176;
begin
  delete from employees
  where employee_id = v_empno;
  v_rows_deleted := (SQL%ROWCOUNT || 'row deleted.');
  DBMS_OUTPUT.PUT_LINE(v_rows_deleted);
end;
/
--IF문
declare
  v_myage number := &no;
begin
  if v_myage < 11
  then
  DBMS_OUTPUT.PUT_LINE('I am a child');
  END if;
END;
/
declare
  v_myage number := &no;
begin
  if v_myage < 11
  then
  DBMS_OUTPUT.PUT_LINE('I am a child');
  else
  DBMS_OUTPUT.PUT_LINE('I am not a child');
  END if;
END;
/
declare
  v_myage number := &no;
begin
  if v_myage < 11
  then
  DBMS_OUTPUT.PUT_LINE('I am a child');
  elsif v_myage < 20
  then
  DBMS_OUTPUT.PUT_LINE('I am young');
  elsif v_myage < 30
  then
  DBMS_OUTPUT.PUT_LINE('I am in my twenties');
   elsif v_myage < 40
  then
  DBMS_OUTPUT.PUT_LINE('I am in my thirties');
  else
  DBMS_OUTPUT.PUT_LINE('I am always young');
  END if;
END;
/
declare
  v_myage number;
begin
  if v_myage < 11
  then
  DBMS_OUTPUT.PUT_LINE('I am a child');
  else
  DBMS_OUTPUT.PUT_LINE('I am not a child');
  END if;
END;
/
--연습문제
create table test01(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

create table test02(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

declare
  v_id employees.employee_id%type;
  v_name employees.last_name%type;
  v_hireDate employees.hire_date%type;
begin
  select employee_id, last_name, hire_date
  into v_id, v_name, v_hireDate
  from employees
  where employee_id = &no;

  if to_char(v_hireDate,'YYYY') >= '2000'
  then
  insert into test01 values(v_id, v_name, v_hireDate);
  else
  insert into test02 values(v_id, v_name, v_hireDate);
  end if;
end;
/
--02-1 if문 문제
create table emp00
as
  select *
  from   employees
  where  employee_id = 0;

declare
  v_did employees.department_id%type;
begin
  select department_id
  into v_did
  from employees
  where employee_id = &no;
  
  if v_did
  then
  elsif
  then
  else
  end if;
end;
/
select department_id
from employees;
--02.2 if문제
declare
  v_name  employees.last_name%type;
  v_sal  employees.salary%type;
  v_salUp  employees.salary%type;
begin
  select last_name, salary
  into v_name, v_sal
  from employees
  where employee_id = &no;
  
  if v_sal <= 5000
    then
      v_salUp := v_sal*1.2;
      DBMS_OUTPUT.PUT_LINE(v_name ||' '|| v_sal ||' '|| v_salUp);
    elsif v_sal <= 10000
    then
      v_salUp := v_sal*1.15;
      DBMS_OUTPUT.PUT_LINE(v_name ||' '|| v_sal ||' '|| v_salUp);
    elsif v_sal <= 15000
    then
      v_salUp := v_sal*1.10;
      DBMS_OUTPUT.PUT_LINE(v_name ||' '|| v_sal ||' '|| v_salUp);
    else 
      v_salUp := v_sal;
      DBMS_OUTPUT.PUT_LINE(v_name ||' '|| v_sal ||' '|| v_salUp);
    end if;
end;
/
rollback;
--02-3
--사원번호를 입력할 경우 해당 사원을 삭제하는 PL/SQL 작성
--단, 해당사원이 없는 경우 " 해당사원이 없습니다" 출력

begin
 delete from employees
 where employee_id = &no;

 if sql%notfound
 then 
 DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다');
 else
 DBMS_OUTPUT.PUT_LINE(sql%rowcount || '개가 삭제되었습니다.');
 end if;
end;
/
--02-4
declare 
 v_per number(3) := &vp;
begin
 update employees
 set salary = salary*(1+v_per/100)
 where employee_id = &no;

 if sql%notfound
 then 
 DBMS_OUTPUT.PUT_LINE('No search employee!!');
 else
 DBMS_OUTPUT.PUT_LINE('갱신되었습니다.');
 end if;
end;
/
select * from employees
where employee_id = 200;
--생년월일을 입력(치환변수&사용)할 경우 해당년도의 띠 출력
--mod(본인생년,12 ) 11 =>  양
--쥐, 소, 호랑이, 토끼, 용, 뱀, 말, 양, 원숭이, 닭, 개, 돼지
-- 4, 5,   6,     7,  8,  9,  10, 11,  0,    1,  2,  3
declare
  v_birth number(10) := &no;
  v_ddi number(10);
begin  
  v_ddi := mod(v_birth,12);
  if v_ddi = 0 then
  DBMS_OUTPUT.PUT_LINE('원숭이띠');
  elsif v_ddi = 1 then
  DBMS_OUTPUT.PUT_LINE('닭띠');
  elsif v_ddi = 2 then
  DBMS_OUTPUT.PUT_LINE('개띠');
  elsif v_ddi = 3 then
  DBMS_OUTPUT.PUT_LINE('돼지띠');
  elsif v_ddi = 4 then
  DBMS_OUTPUT.PUT_LINE('쥐띠');
  elsif v_ddi = 5 then
  DBMS_OUTPUT.PUT_LINE('소띠');
  elsif v_ddi = 6 then
  DBMS_OUTPUT.PUT_LINE('호랑이띠');
  elsif v_ddi = 7 then
  DBMS_OUTPUT.PUT_LINE('토끼띠');
  elsif v_ddi = 8 then
  DBMS_OUTPUT.PUT_LINE('용띠');
  elsif v_ddi = 9 then
  DBMS_OUTPUT.PUT_LINE('뱀띠');
  elsif v_ddi = 10 then
  DBMS_OUTPUT.PUT_LINE('말띠');
  elsif v_ddi = 11 then
  DBMS_OUTPUT.PUT_LINE('양띠');
  else
  DBMS_OUTPUT.PUT_LINE('찾을 수 없는 값입니다.');
  end if;
end;
/
--2022.07.27
--morning practice
--사원번호, 사원이름, 인상된 급여, 소속된 부서 이름을 출력, 인상된 급여는 업무별로...
set serveroutput on;
declare
  v_id employees.employee_id%type;
  v_name employees.last_name%type;
  v_dname departments.department_name%type;
  v_sal employees.salary%type;
  v_salUp employees.salary%type;
  v_jid employees.job_id%type;
begin
  select e.employee_id, e.last_name, e.salary, upper(e.job_id), d.department_name
  into v_id, v_name, v_sal,v_jid, v_dname 
  from employees e, departments d
  where e.department_id = d.department_id
  and employee_id = &no;
  
  if v_jid = 'IT_PROG'  then
    v_salUp := v_sal*1.1;
    elsif v_jid = 'ST_CLERK' then
    v_salUp := v_sal*1.2;
    elsif v_jid = 'ST_MAN' then
    v_salUp := v_sal*1.3;
    else
    v_salUp := v_sal;
    end if;
    
    if v_salUp = v_sal then
      DBMS_OUTPUT.PUT_LINE('사원번호 : '||v_id||', 사원이름 : '|| v_name||', 급여 : ' || v_salUp ||'(인상x), 소속된 부서 : '||  v_dname);
    else
      DBMS_OUTPUT.PUT_LINE('사원번호 : '||v_id||', 사원이름 : '|| v_name||', 인상된 급여 : ' || v_salUp ||', 소속된 부서 : '||  v_dname);

      
    end if;
end;
/
desc departments;
select * from employees;
select * from departments;
select * from jobs;

--부서번호를 입력할 경우 입력된 부서에서 제일 높은 급여를 받는 사원의 사원번호, 사원이름, 급여, 부서이름 출력
declare
  v_id employees.employee_id%type;
  v_name employees.last_name%type;
  v_dname departments.department_name%type;
  v_sal employees.salary%type;
begin  
  select e.employee_id, e.last_name, e.salary, d.department_name
  into v_id, v_name, v_sal, v_dname
  from employees e, departments d
  where e.department_id = d.department_id
  and e.salary = (
      select max(salary)
      from employees
      where department_id = &dno
      group by department_id);
 DBMS_OUTPUT.put_line('제일 높은 급여의 주인공! 사원번호 : '||v_id||', 이름 : ' ||v_name||', 급여 : ' ||v_sal||', 부서이름 : ' ||v_dname);
end;
/
--LOOP
--기본 루프
DECLARE
  v_countryid locations.country_id%type := 'CA';
  v_loc_id    locations.location_id%type;
  v_counter   number(2) := 1;
  v_new_city  locations.city%type := 'Montreal';
BEGIN
  select max(location_id)
  into v_loc_id
  from locations
  where country_id = v_countryid;
  loop
    insert into locations(location_id, city, country_id)
    values((v_loc_id + v_counter), v_new_city, v_countryid);
    v_counter := v_counter +1;
    exit when v_counter >3;
  end loop;
END;
/
select * from locations;
--while loop (조건 비교)
DECLARE
  v_countryid locations.country_id%type := 'CA';
  v_loc_id    locations.location_id%type;
  v_counter   number(2) := 1;
  v_new_city  locations.city%type := 'Montreal';
BEGIN
  select max(location_id)
  into v_loc_id
  from locations
  where country_id = v_countryid;
   while v_counter <=3 loop
    insert into locations(location_id, city, country_id)
    values((v_loc_id + v_counter), v_new_city, v_countryid);
    v_counter := v_counter +1;
   end loop;
END;
/
select * from locations;
--for loop
DECLARE
  v_countryid locations.country_id%type := 'CA';
  v_loc_id    locations.location_id%type;
  v_new_city  locations.city%type := 'Montreal';
BEGIN
  select max(location_id)
  into v_loc_id
  from locations
  where country_id = v_countryid;
   for i in 1..3 loop
    insert into locations(location_id, city, country_id)
    values((v_loc_id + i), v_new_city, v_countryid);
   end loop;
END;
/
select * from locations;
--loop 기초 연습문제
create table aaa
(a number(3));
create table bbb
(b number(3));
--1.aaa 테이블에 1부터10까지 입력되도록 PL/SQL 블록을 작성(insert 문은 1번)
begin
  for i in 1..10 loop
    insert into aaa values(i);
  end loop;
end;
/
select * from aaa;
--2. bbb 테이블에 1부터 10까지 최종 합계 값을 PL/SQL 블록으로 작성
declare
 v_sum number(20) := 0;
begin
  for i in 1..10 loop
    v_sum := v_sum + i;
    if i = 10 then
      insert into bbb values(v_sum);
    end if;
  end loop;
end;
/
select * from bbb;
rollback;
--3. aaa 테이블에 1부터 10까지 짝수만 입력되도록 PL/SQL 블록을 작성(insert, if 사용)
declare
  v_num number(20) := 0; 
begin
   for i in 1..10 loop
     if mod(1,2) = 0 then
     v_num := i;
       if i = 10 then
         insert into aaa values(v_num);
       end if;
     end if;
   end loop;
end;
/
rollback;
select * from aaa;
--4. bbb 테이블에 1부터 10까지 짝수 최종 합계 값을 PL/SQL 블록으로 작성
declare
  v_num number(20) := 0; 
  v_sum number(20) := 0;
begin
   for i in 1..10 loop
     if mod(i,2) = 0 then
       v_num := i;
       v_sum := v_sum + v_num;
       if i = 10 then
         insert into bbb values(v_sum);
       end if;
     end if;
   end loop; 
end;
/
rollback;
select * from bbb;
--5. 1부터 10까지에서 짝수의 합계는 aaa 테이블, 홀수의 합계는 bbb
declare
  v_num number(20) := 0; 
  v_sumA number(20) := 0;
  v_sumB number(20) := 0;
begin
   for i in 1..10 loop
     if mod(i,2) = 0 then
       v_num := i;
       v_sumA := v_sumA + v_num;
       if i = 10 then
         insert into aaa values(v_sumA);
       end if; 
      end if;
      v_num := i;
      v_sumB := v_sumB + v_num;
      if i = 10 then
        insert into bbb values(v_sumB);
     end if;
   end loop; 
end;
/
rollback;
select * from aaa;
select * from bbb;
--loop 제어문 실습
--1. 별 찍기
declare
  v_star varchar(10);
begin
  for i in 1..5 loop
    v_star := '*';
    for j in 1..i loop
      DBMS_OUTPUT.put(v_star);
    end loop;
    DBMS_OUTPUT.put_line(' ');
  end loop;
end;
/
--2. 치환변수(&)를 사용하면 숫자를 입력하면 해당 구구단이 출력
declare
 v_dan number(10) := &num;
begin
  for i in 1..9 loop
    DBMS_OUTPUT.put_line(v_dan || '*' || i || '=' || v_dan*i);
  end loop;
end;
/
--3. 구구단 2~9단 출력
declare
 v_dan number(10) := 2;
begin
  for i in 2..9 loop
    v_dan := i;
    for j in 1..9 loop
      DBMS_OUTPUT.put_line(v_dan || '*' || j || '=' || v_dan*j);
    end loop;
  end loop;
end;
/
-- 구구단 1~9단 홀추만 출력
declare
 v_dan number(10) := 1;
begin
  for i in 1..9 loop
    v_dan := i;
    if mod(i,2) = 1 then
      for j in 1..9 loop
          DBMS_OUTPUT.put_line(v_dan || '*' || j || '=' || v_dan*j);
      end loop;
    end if;
  end loop;
end;
/
--레코드(RECORD)
declare
  type t_rec is record
    (v_sal number(8),
     v_minsal number(8) default 1000,
     v_hire_date employees.hire_date%type,
     v_recl employees%rowtype);
  v_myrec t_rec;
begin
  v_myrec.v_sal := v_myrec.v_minsal+500;
  v_myrec.v_hire_date := sysdate;
  select *
  into v_myrec.v_recl
  from employees
  where employee_id = 100;
  -- 데이터 통일을 위해서 to_char 사용...
  DBMS_OUTPUT.put_line(v_myrec.v_recl.last_name || ' ' || to_char(v_myrec.v_hire_date) || ' ' || to_char(v_myrec.v_sal));
  DBMS_OUTPUT.put_line(v_myrec.v_recl.last_name || ' ' || v_myrec.v_hire_date || ' ' || v_myrec.v_sal);
end;
/
select * from employees where employee_id = 100;
select * from departments;
--%rowtype
create table retired_emps (empno, ename, job, mgr, hiredate,
                           leavedate, sal, comm, deptno)
as
  select employee_id, last_name, job_id, manager_id, hire_date,
         sysdate, salary, commission_pct, department_id
  from   employees
  where  employee_id = 0;
  
declare
  v_employee_number number := 124;
  v_emp_rec         employees%rowtype;
begin
  select * into v_emp_rec from employees
  where employee_id = v_employee_number;
  insert into retired_emps(empno, ename, job, mgr, hiredate, leavedate, sal, comm, deptno)
  values ( v_emp_rec.employee_id, v_emp_rec.last_name,
           v_emp_rec.job_id, v_emp_rec.manager_id,
           v_emp_rec.hire_date, sysdate,
           v_emp_rec.salary, v_emp_rec.commission_pct,
           v_emp_rec.department_id);
end;
/
select * from employees where employee_id = 124;
select * from retired_emps;
--record 문제
--사원번호를 입력(치환변수)할 경우 부서별로 구분하여 각각의 테이블에 입력하는 PL/SQL 블록 작성
--단, 해당 부서가 없는 사원은 emp00테이블에 입력
declare
  emp_record employees%rowtype;
begin
  select *
  into emp_record
  from employees
  where employee_id = &eno;
  
  if emp_record.department_id = 10 then
    insert into emp10 values emp_record;
  elsif emp_record.department_id = 20 then
    insert into emp20 values emp_record;
  elsif emp_record.department_id = 30 then
    insert into emp30 values emp_record;
  elsif emp_record.department_id = 40 then
    insert into emp40 values emp_record;
  elsif emp_record.department_id = 50 then
    insert into emp50 values emp_record;
  else
    insert into emp00 values emp_record;
  end if;
end;
/
select * from employees;
select * from emp10;
rollback;

declare
  v_employee_number number :=124;
  v_emp_rec retired_emps%rowtype;
begin
  select *
  into v_emp_rec
  from retired_emps;
  
  v_emp_rec.leavedate := current_date-1;
  update retired_emps
  set row = v_emp_rec
  where empno = v_employee_number;
end;
/
select * from retired_emps;

--PL/SQL 테이블
declare
  type dept_table_type is table of
      departments%rowtype index by pls_integer;
  dept_table dept_table_type;
begin
  select *
  into dept_table(2)
  from departments
  where department_id = 20;
  DBMS_OUTPUT.PUT_LINE(dept_table(2).department_id ||' ' || dept_table(2).department_name|| ' '||
  dept_table(2).manager_id);
end;
/
--2022.07.28
set serveroutput on;
Declare
  type emp_table_type is table of
  employees%rowtype index by pls_integer;
  my_emp_table emp_table_type;
  max_count number(3) := 104;
begin
  for i in 100..max_count
  loop
    select * into my_emp_table(i)
    from employees
    where employee_id =i;
  end loop;
  for i in my_emp_table.first..my_emp_table.last
  loop
    DBMS_OUTPUT.PUT_LINE(my_emp_table(i).last_name);
  end loop;
end;
/

-- 커서(Cursor)
-- 부서번호(치환변수&)를 입력할 경우, 사원이름, 소속된 부서이름을 출력하는 PL/SPL을 출력하시오.
--개념설명
declare
  v_ename employees.last_name%type;
  v_dname departments.department_name%type;
begin
  select e.last_name, d.department_name
  into v_ename, v_dname
  from employees e , departments d
  where e.department_id = d.department_id
  -- error : exact fetch returns more than requested number of rows
  -- 변수의 값에는 하나만 들어갈 수 있는데 두개 이상의 값이 리턴되는 경우... 문제 발생
  -- 그러므로 여러 값을 받기 위해선 커서가 필요함
  and e.department_id = &id;
  -- 사원번호를 입력할 경우
  and e.employee_id = &id;
  DBMS_OUTPUT.PUT_LINE(v_ename || ', ' || v_dname);
end;
/
select * from employees where department_id =20 ;
/
-- 위의 실습내용 커서 변환
declare
  cursor c_emp_cursor is
    select e.last_name, d.department_name
    from employees e , departments d
    where e.department_id = d.department_id
    and e.department_id = &id;
  v_ename employees.last_name%type;
  v_dname departments.department_name%type;
begin
  open c_emp_cursor;
  loop
    fetch c_emp_cursor
    into v_ename, v_dname;
    exit when c_emp_cursor%notfound;
    DBMS_OUTPUT.PUT_LINE(v_ename || ', ' || v_dname);
  end loop;
  close c_emp_cursor;
end;
/
select * from employees where department_id =20 ;
/

DECLARE
  cursor c_emp_cursor is
  select employee_id, last_name
  from employees
  where department_id =20;
  v_empno employees.employee_id%type;
  v_lname employees.last_name%type;
BEGIN
  open c_emp_cursor;
  loop
    fetch c_emp_cursor
    into v_empno, v_lname;
    exit when c_emp_cursor%notfound;
    DBMS_OUTPUT.PUT_LINE(v_empno ||' '||v_lname);
  end loop;
  close c_emp_cursor;
END;
/
--커서 및 레코드
create table temp_list(empid, empname)
  as select employee_id, last_name
  from employees
  where employee_id = 0;

DECLARE
  cursor emp_cursor is
    select employee_id, last_name
    from employees
    where department_id =10;
  emp_record emp_cursor%rowtype;
BEGIN
  open emp_cursor;
  loop
    fetch emp_cursor
    into emp_record;
    exit when emp_cursor%notfound;
    insert into temp_list(empid, empname)
    values (emp_record.employee_id, emp_record.last_name);
  end loop;
  commit;
  close emp_cursor;
END;
/
rollback;
select * from temp_list;
-- Cursor for Loops
DECLARE
  cursor c_emp_cursor is
    select employee_id, last_name
    from employees
  where department_id = 50;
BEGIN
  for emp_record
  in c_emp_cursor
  loop
    dbms_output.put_line(emp_record.employee_id || '' || emp_record.last_name);
  end loop;
END;
/
--
select * from employees where department_id = 50;
DECLARE
  cursor sal_cursor is
    select salary
    from employees
    where department_id = 50
    for update of salary nowait;
BEGIN
  for emp_record in sal_cursor loop
    update employees
    set salary = emp_record.salary * 1.10
    where current of sal_cursor;
  end loop;
  commit;
END;
/
--커서 문제
--사원 테이블에서 사원의 사원번호, 사원이름, 입사연도를 다음 기준에 맞게 각각 test01, test02에 입력
--입사년도 2000년(포함) 이전 입사한 사원은 test01 테이블에 입력
--입사년도 2000년 이후 입사한 사원은 test02 테이블에 입력
--반드시 cursor사용
--1) for loop사용
DECLARE
  cursor c_emp_cursor is
    select employee_id, last_name, hire_date
    from employees;
BEGIN
  for emp_cursor in c_emp_cursor loop
    if to_char(emp_cursor.hire_date, 'YYYY') <= '2000' then
      insert into test01 values emp_cursor;
    else
      insert into test02 values emp_cursor;
    end if;
  end loop;
END;
/
rollback;
select * from test01;
--2)기본 loop.
DECLARE
  cursor c_emp_cursor is
    select employee_id, last_name, hire_date
    from employees;
  v_id employees.employee_id%type;
  v_name employees.last_name%type;
  v_hireDate employees.hire_date%type;
BEGIN
  open c_emp_cursor;
  loop
    fetch c_emp_cursor
    into  v_id, v_name, v_hireDate;
    exit when c_emp_cursor%notfound;
    if to_char(v_hireDate,'YYYY') <= '2000' then
      insert into test01 values (v_id, v_name, v_hireDate);
    elsif to_char(v_hireDate,'YYYY') > '2000' then
      insert into test02 values (v_id, v_name, v_hireDate);
    end if;
  end loop;
  close c_emp_cursor;
END;
/
rollback;
select * from test01;
select * from test02;
delete from test01;
commit;
--3.
DECLARE
  cursor c_emp_cursor is
    select e.LAST_NAME, e.HIRE_DATE, d.DEPARTMENT_NAME
    from employees e, departments d
    where e.DEPARTMENT_ID = d.DEPARTMENT_ID
    and e.DEPARTMENT_ID = &dno;
BEGIN
  for emp_cursor in c_emp_cursor loop
    dbms_output.put_line(emp_cursor.last_name || ' ' || emp_cursor.hire_date || ' ' || emp_cursor.department_name );
  end loop; 
END;
/

--4.
DECLARE
  cursor c_emp_cursor is
    select employee_id, last_name, department_id
    from employees
    where department_id = &dno;
BEGIN
  for emp_cursor in c_emp_cursor loop
    dbms_output.put_line(emp_cursor.employee_id || ' ' || emp_cursor.last_name || ' ' || emp_cursor.department_id );
  end loop;
END;
/
--5.
DECLARE
  cursor c_emp_cursor is
    select last_name, salary, (salary*12+(salary*nvl(COMMISSION_PCT,0)*12)) as salary12
    from employees
    where department_id = &dno;
BEGIN
 for emp_cursor in c_emp_cursor loop
   dbms_output.put_line(emp_cursor.last_name || ' '|| emp_cursor.salary ||' '|| emp_cursor.salary12);
 end loop;
END;
/
desc employees;
--6.
DECLARE
  cursor c_sal_cursor is
    select job_id, avg(nvl(salary,0)) as jobId_avg
    from employees
    where department_id = &d_id
    group by job_id;
BEGIN
  for sal_cursor in c_sal_cursor loop
    dbms_output.put_line(sal_cursor.job_id || ' ' ||sal_cursor.jobId_avg);
  end loop;
END;
/
select * from employees;
select * from jobs;
--7.
DECLARE
  cursor c_emp_cursor is
    select employee_id, last_name, hire_date, salary
    from employees;
BEGIN
  for emp_cursor in c_emp_cursor loop
    if emp_cursor.salary >= 5000 then
      insert into test01 (EMPID, ENAME, HIREDATE) values (emp_cursor.employee_id, emp_cursor.last_name, emp_cursor.hire_date);
     else
      insert into test02 (EMPID, ENAME, HIREDATE) values (emp_cursor.employee_id, emp_cursor.last_name, emp_cursor.hire_date);
    end if;
  end loop;
END;
/
rollback;
select * from test01;
select * from test02;
select * from employees where employee_id = 200; 
--미리 정의 된 예외처리(Trap) - no_data_found
DECLARE
  v_name employees.last_name%type;
BEGIN
  select last_name
  into v_name
  from employees
  -- 없는 사원 입력해보기 : 0
  where employee_id = &id;
EXCEPTION
  when no_data_found then
    DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
END;
/
--미리 정의 된 예외처리(Trap) - too_many_rows
DECLARE
  v_name employees.last_name%type;
BEGIN
  select last_name
  into v_name
  from employees
  where department_id = &id;
EXCEPTION
  when too_many_rows then
    DBMS_OUTPUT.PUT_LINE('한개 이상의 행이 질의되었습니다');

END;
/
select *from employees where department_id = 50;
-- 미리 정의하지 않은 예외 트랩
DECLARE
  e_insert_excep EXCEPTION;
  pragma exception_init(e_insert_excep, -01400);
BEGIN
  insert into departments (department_id, department_name) values(280, null);
EXCEPTION
  when e_insert_excep then
  dbms_output.put_line('insert operation failed');
  dbms_output.put_line(sqlcode ||' ' ||sqlerrm);
END;
/
-- 사용자가 정의한 예외트랩
DECLARE
  v_deptno number := 500;
  v_name varchar2(20) := 'Testing';
  e_invalid_department EXCEPTION;
BEGIN
  update departments
  set department_name = v_name
  where department_id = v_deptno;
  if sql%notfound then
    raise e_invalid_department;
  end if;
EXCEPTION
  when e_invalid_department then
  dbms_output.put_line('No such department id.');
END;
/
--RAISE_APPLICATION_ERROR 프로시저
DECLARE
  e_name exception;
BEGIN
  delete from employees
  where last_name='&id';
  if sql%notfound then
    raise e_name;
  end if;
EXCEPTION
 when e_name then
   raise_application_error (-20999, '해당사원이 없습니다.');
   --dbms_output.put_line('해당사원이 없습니다.');
END;
/
--실제론 이런식으로 쓰임
BEGIN
  delete from employees
  where last_name='&id';
  if sql%notfound then
    raise_application_error (-20999, '해당사원이 없습니다.');
  end if;
END;
/
--2022.07.29 exception
set serveroutput on;
drop table emp_test;
create table emp_test
as
  select employee_id, last_name
  from   employees
  where  employee_id < 200;
select * from emp_test;
--1.emp_test 테이블에서 사원번호를 사용(&치환변수 사용)하여 사원을 삭제하는 PL/SQL을 작성하시오.
--(단, 사용자 정의 예외사항 사용)
--(단, 사원이 없으면 "해당사원이 없습니다.'라는 오류메시지 발생)
DECLARE
 e_emp_test exception;
BEGIN
  delete from emp_test
  where employee_id = &id;
  if sql%notfound then
    raise e_emp_test;
  end if;
EXCEPTION
  when e_emp_test then
    dbms_output.put_line('해당 사원이 없습니다.');
END;
/
--2. 사원(employees) 테이블에서 사원번호를 입력(&사용)받아 10% 인상된 급여로 수정하는 PL/SQL을 작성하시오.
-- 단, 2000년(포함) 이후 입사한 사원은 갱신하지 않고 "2000년 이후 입사한 사원입니다." <-exception 절 사용이라고 출력되도록 하시오.
undefine &id;
DECLARE
  v_eid employees.employee_id%type := &eid;
 v_hireDate employees.hire_date%type;
 e_sal exception;
BEGIN 
  select hire_date
  into v_hireDate
  from employees
  where employee_id = v_eid;
  
  if to_char(v_hireDate, 'YYYY') >= 2000 then
    raise e_sal;
  else
    update employees set salary = salary * 1.1 where employee_id = v_eid;
  end if;
EXCEPTION
  when e_sal then
    dbms_output.put_line('2000년 이후 입사한 사원입니다');
END;
/
rollback;
select * from employees where employee_id =201;
--3. 사원(employees) 테이블에서 부서번호를 입력(&사용)받아   <- cursor 사용
--10% 인상된 급여로 수정하는 PL/SQL을 작성하시오.
--단, 단 해당 부서에 사원이 없으면 "해당 부서에는 사원이 없습니다." (<-exception 절 사용)라고 출력되도록 하시오.
--?????????????????????????????????????????????????????????????????????????????????????????
DECLARE
  v_did employees.department_id%type := &did;
  cursor c_emp_cursor is
    select salary
    from employees
    where department_id = v_did
    for update of salary nowait;
  e_emp exception;
BEGIN
  for emp_cursor in c_emp_cursor loop
    if sql%notfound then
      raise e_emp;
    else 
      update employees set salary = emp_cursor.salary * 1.1
      --update employees set salary = salary *1.1;
      where current of c_emp_cursor;
      --where department_id = v_did;
    end if;
  end loop;
EXCEPTION
  when e_emp then
   dbms_output.put_line('해당 부서에는 사원이 없습니다.');
END;
/
rollback;
select * from employees where department_id = 50;
--내장 프로시저(in 매개변수)
create or replace procedure raise_salary
  (p_id in employees.employee_id%type,
   p_percent in number)
  is
begin
  update employees
  set salary = salary * (1+p_percent/100)
  where employee_id = p_id;
end raise_salary;
/
execute raise_salary(100, 10);
select *from employees where employee_id =100;
rollback;
--실제로는 이런식으로 쓰임...
begin
  raise_salary (100,10);
end;
/
--내장프로시저(out 매개변수)
CREATE or replace procedure query_emp
  (p_id employees.employee_id%type,
   p_name out employees.last_name%type,
   p_salary out employees.salary%type) is
begin
  select last_name, salary
  into p_name, p_salary
  from employees
  where employee_id = p_id;
end query_emp;
/
--사용법
declare
  v_emp_name employees.last_name%type;
  v_emp_sal employees.salary%type;
begin
  query_emp(100, v_emp_name, v_emp_sal);
  dbms_output.put_line(v_emp_name || ' earns ' || to_char(v_emp_sal, '$999,999.00'));
end;
/
rollback;
--내장프로시저(in out 매개변수)
create or replace procedure format_phone
  (p_phone_no in out varchar2) is
begin
  p_phone_no := '(' || substr(p_phone_no, 1,3)||
                ')' || substr(p_phone_no, 4,3)||
                '-' || substr(p_phone_no, 7);
end format_phone;
/
--
create or replace procedure add_dept(
  p_name in departments.department_name%type,
  p_loc in departments.location_id%type) is
BEGIN
  insert into departments(department_id, department_name, location_id)
  values (departments_seq.nextval, p_name, p_loc);
end add_dept;
/
execute add_dept ('training', 2500);
execute add_dept (p_loc=>2500, p_name=>'EDUCATION');
select * from departments;
select * from locations;
--재컴파일(디폴트값)
create or replace procedure add_dept(
  p_name in departments.department_name%type :='Unknown',
  p_loc in departments.location_id%type default 1700) is
BEGIN
  insert into departments(department_id, department_name, location_id)
  values (departments_seq.nextval, p_name, p_loc);
end add_dept;
/
execute add_dept;
execute add_dept ('ADVERTISING', p_loc=>1400);
execute add_dept (p_loc=>1400);
--프로시저 삭제
drop procedure raise_salary;
--
create procedure add_department(
  p_name varchar2, p_mgr number, p_loc number) is
begin
  insert into departments(department_id, department_name, manager_id, location_id)
  values (departments_seq.nextval, p_name, p_mgr, p_loc);
  dbms_output.put_line('Added Dept: ' || p_name);
exception
  when others then
  dbms_output.put_line('Err : adding dept ' || p_name);
*/
end;
/
drop procedure add_department;
create  procedure create_departments is
begin
  add_department('Media', 100, 1800);
  add_department('Editing', 99, 1800);
  add_department('Advertising', 101, 1800);
end;
execute create_departments;
/
drop procedure create_departments;
--프로시저 조회
select text from user_source
where name ='ADD_DEPT' and type = 'PROCEDURE'
order by line;
-- 프로시저 문제 (in 매개변수 사용)
--1. 주민등록번호를 입력하면 다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오.
--EXECUTE yedam_ju(9501011667777) -> 950101-1******
create procedure yedam_ju (
 p_num varchar2) is
begin
  DBMS_OUTPUT.PUT_LINE(substr(p_num, 1, 6) ||'-' || substr(p_num, 7,1) || '******');
end yedam_ju;
/
EXECUTE yedam_ju(9501011667777);
drop procedure yedam_ju;
--2. 사원번호를 입력할 경우 삭제하는 TEST_PRO 프로시저를 생성하시오.
--단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
--예) EXECUTE TEST_PRO(176)
create procedure test_pro(
  p_id employees.employee_id%type)
is
begin
  delete from employees where employee_id = p_id;
  if sql%notfound then
    DBMS_OUTPUT.PUT_LINE('해당 사원이 없습니다.');
  end if;
end test_pro;
/
rollback;
EXECUTE TEST_PRO(178);
select * from employees;
--2-1 예외처리
create or replace procedure test_pro(
  p_id employees.employee_id%type)
is
  v_id employees.employee_id%type;
  no_delete exception;
begin
  delete from employees where employee_id = p_id;
  if sql%notfound then
    raise no_delete;
  end if;
EXCEPTION
  when no_delete then
  dbms_output.put_line('해당 사원이 없습니다.');
end test_pro;
/
rollback;
EXECUTE TEST_PRO(210);
select * from employees;
--3.다음과 같이 PL/SQL 블록을 실행할 경우 사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는 '*'가 출력되도록 yedam_emp 프로시저를 생성하시오.
--실행) EXECUTE yedam_emp(176)
--실행결과) TAYLOR -> T*****  <- 이름 크기만큼 별표(*) 출력
create or replace procedure yedam_emp (
  p_id employees.employee_id%type)
is
  v_name employees.last_name%type;
begin
  select last_name
  into v_name
  from employees
  where employee_id = p_id;
  DBMS_OUTPUT.put_line(rpad(substr(v_name,1,1),length(v_name),'*'));
end yedam_emp;
/
EXECUTE yedam_emp(100);
drop procedure yedam_emp;
-- 프로시저2 연습문제
--1. 부서번호를 입력할 경우 해당부서에 근무하는 사원의 사원번호, 사원이름(last_name)을 출력하는 get_emp 프로시저를 생성하시오. (cursor 사용해야 함)
-- 단, 사원이 없을 경우 "해당 부서에는 사원이 없습니다."라고 출력(exception 사용)
--실행) EXECUTE get_emp(30)
create or replace procedure get_emp(
 p_dept_id employees.department_id%type)
is
 cursor emp_cursor is
   select *
   from employees
   where department_id = p_dept_id; 
  v_emp_record emp_cursor%rowtype;
  e_no_data exception;
begin
  open emp_cursor;
  loop
  fetch emp_cursor into v_emp_record;
  if emp_cursor%rowcount = 0 then
    raise e_no_data;
  end if;
  exit when emp_cursor%notfound;
  DBMS_OUTPUT.PUT_LINE('ID : ' || v_emp_record.employee_id || ', NAME : ' || v_emp_record.last_name);
  end loop;
  close emp_cursor;
exception
  WHEN e_no_data THEN
    DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.');
end get_emp;
/
rollback;
drop procedure get_emp;
EXECUTE get_emp(50);
EXECUTE get_emp(30);
--2 직원들의 사번, 급여 증가치만 입력하면 Employees테이블에 쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요. 
--만약 입력한 사원이 없는 경우에는 ‘No search employee!!’라는 메시지를 출력하세요.(예외처리)
--실행) EXECUTE y_update(200, 10)
create or replace procedure y_update(
  p_id employees.employee_id%type,
  p_persent number)
is
  no_data_exception exception;
begin
  update employees set salary = salary*(1+p_persent/100) where employee_id = p_id;
  if sql%notfound then 
    raise no_data_exception;
  end if;
exception
  when no_data_exception then
    DBMS_OUTPUT.PUT_LINE('No search employee!!');
end;
/
EXECUTE y_update(300, 10);
rollback;
select * from employees where employee_id = 300;
--3.
create table yedam01
(y_id number(10),
 y_name varchar2(20));
create table yedam02
(y_id number(10),
 y_name varchar2(20));
 --3-1 부서번호를 입력하면 사원들 중에서 입사년도가 2000년 이전 입사한 사원은 yedam01 테이블에 입력하고,
--입사년도가 2000년(포함) 이후 입사한 사원은 yedam02 테이블에 입력하는 y_proc 프로시저를 생성하시오.
--3-2.
--1. 단, 부서번호가 없을 경우 "해당부서가 없습니다" 예외처리
--2. 단, 해당하는 부서에 사원이 없을 경우 "해당부서에 사원이 없습니다" 예외처리
--실행) EXECUTE y_proc(20);
create or replace procedure y_proc (
  p_did employees.department_id%type)
is
   cursor emp_cursor is
    select *
    from employees
    where department_id = p_did;
  v_emp_record emp_cursor%rowtype;
  e_no_person exception;
  v_deptId employees.department_id%type;
begin
  select department_id
  into v_deptId
  from departments
  where department_id = p_did;
  
  open emp_cursor;
  loop
    fetch emp_cursor into v_emp_record;
    if emp_cursor%rowcount = 0 then
      raise e_no_person;
    end if;
    exit when emp_cursor%notfound;
    if to_char(v_emp_record.hire_date,'yyyy') < '2000' then
      insert into yedam01 values(v_emp_record.employee_id, v_emp_record.last_name);
    else
      insert into yedam02 values(v_emp_record.employee_id, v_emp_record.last_name);
    end if;
  end loop;
  close emp_cursor;
 exception
   when e_no_person then
   dbms_output.put_line('해당부서의 인간이 없습니다요');
   when no_data_found then
   dbms_output.put_line('해당부서가 없습니다요.');
 end y_proc;
 /
 rollback;
 EXECUTE y_proc(360);
select * from employees;
select * from yedam01;
select * from yedam02;
select * from departments;

--2022.08.01 (사용자 함수)
set serveroutput on;
create or replace function get_sal
 (p_id employees.employee_id%type)
  return number is
  v_sal employees.salary%type := 0;
begin
  select salary
  into v_sal
  from employees
  where employee_id = p_id;
  return v_sal;
end get_sal;
/
--사용자 함수 실행
execute dbms_output.put_line(get_sal(100));
/
-- 
create or replace function tax
  (p_value in number)
  return number is
begin
  return (p_value * 0.08);
end tax;
/
select employee_id, last_name, salary, tax(salary)
from employees
where department_id =100;
/
-- 함수 문제
--1. 숫자를 입력할 경우 입력된 숫자까지의 정수의 합계를 출력하는 함수를 작성하시오.
-- 실행 예) EXECUTE DBMS_OUTPUT.PUT_LINE(ydsum(10))
create or replace function ydsum
  (p_num number)
  return number
is
  v_sum number := 0;
begin
  for i in 1..p_num loop
    v_sum := v_sum + i;
  end loop;
  return (v_sum);
end ydsum;
/
EXECUTE DBMS_OUTPUT.PUT_LINE(ydsum(10));
--2. 사원번호를 입력할 경우 다음 조건을 만족하는 결과가 출력되는 ydinc 함수를 생성하시오.
-- 급여가 5000 이하이면 20% 인상된 급여 출력
-- 급여가 10000 이하이면 15% 인상된 급여 출력
-- 급여가 20000 이하이면 10% 인상된 급여 출력
-- 급여가 20000 이상이면 급여 그대로 출력
--실행) SELECT last_name, salary, YDINC(employee_id)
--     FROM   employees;
create or replace function ydinc
  (p_empId employees.employee_id%type)
  return number
is
  v_salUp employees.salary%type;
begin
 select 
    case  when salary <= 5000 then salary * 1.20
         when salary <= 10000 then salary * 1.15
         when salary <= 20000 then salary *1.10
         else  salary
         end
         as "인상된 급여"
  into v_salUp
  from employees
  where employee_id = p_empId;
  return (v_salUp);
  
--  select salary
--  into v_salUp
--  from employees
--  where employee_id = p_empId;
--  
--  if v_salUp < 5000 then
--    v_salUp := v_salUp * 1.2;
--  elsif v_salUp < 10000 then
--    v_salUp := v_salUp * 1.15;
--    elsif v_salUp < 20000 then
--    v_salUp := v_salUp * 1.1;
--  else 
--    v_salUp := v_salUp;
--  end if;
--  return v_salUp;
end ydinc;
/
SELECT last_name, salary, YDINC(employee_id)
     FROM   employees;
     /
-- 왜 안됨??????????????????
select 
    case  when salary <= 5000 then salary * 1.20
         when salary <= 10000 then salary * 1.15
         when salary <= 20000 then salary *1.10
         else  salary
         end
         as "인상된 급여"
  from employees;
--3. 사원번호를 입력하면 해당 사원의 연봉이 출력되는 yd_func 함수를 생성하시오.
-- >연봉계산 : (급여+(급여*인센티브퍼센트))*12
create or replace function yd_func
  (p_empId employees.employee_id%type)
  return number
is
  v_sal12 employees.salary%type;
begin
  select (SALARY*12+(nvl(SALARY,0)*nvl(COMMISSION_PCT,0)*12))
  into v_sal12
  from employees
  where employee_id = p_empId;
  return v_sal12;
end yd_func;
/
SELECT last_name, salary, YD_FUNC(employee_id)
FROM   employees;
/
-- 4. 예제와 같이 출력되는 subname 함수를 작성하시오.
-- SELECT last_name, subname(last_name)
--FROM   employees;
-- LAST_NAME     SUBNAME(LA
-- ------------ ------------
-- King         K***
-- Smith        S****
create or replace function subname
  (p_name employees.last_name%type)
  return varchar2
is
begin
  return rpad(substr(p_name,1,1),length(p_name), '*');
end;
/
SELECT last_name, subname(last_name)
FROM   employees;
--5.사원번호를 입력하면 인상된 급여가 출력되도록 inc_sal 함수 생성하시오.
create or replace function inc_sal
  (p_empId employees.employee_id%type,
   p_persent number)
  return number
is
 v_sal employees.salary%type;
begin
  select salary*(1+p_persent/100)
  into v_sal
  from employees
  where employee_id = p_empId;
  return v_sal;
end;
/
SELECT last_name, salary, inc_sal(employee_id, 10)
FROM   employees;
/
EXECUTE DBMS_OUTPUT.PUT_LINE(inc_sal(100, 10));
--08_2_1 함수문제
--1. 사원번호를 입력하면 last_name + first_name 이 출력되는 y_yedam 함수를 생성하시오.
-- 실행) EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174)) / 출력 예)  Abel Ellen
-- SELECT employee_id, y_yedam(employee_id) FROM   employees;
create or replace function y_yedam
  ( p_empId employees.employee_id%type)
  return varchar2
is
 v_fullName employees.last_name%type;
begin
  select last_name ||' '|| first_name
  into v_fullName
  from employees
  where employee_id = p_empId;
  return v_fullName;
end y_yedam;
/
EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174));
SELECT employee_id, y_yedam(employee_id)
FROM   employees;
/
--2-1. 사원번호를 입력하면 소속 부서명를 출력하는 y_dept 함수를 생성하시오.
--(단, 다음과 같은 경우 예외처리(exception) 
-- 입력된 사원이 없거나 소속 부서가 없는 경우 -> 사원이 아니거나 소속 부서가 없습니다.)
create or replace function y_dept
  (p_empId employees.employee_id%type)
  return varchar2
is
 v_dname departments.department_name%type;
begin
  select d.department_name
  into v_dname
  from employees e, departments d
  where e.department_id = d.department_id
  and     e.employee_id = p_empId;
  return v_dname;
exception
  when no_data_found then
    return '사원이 아니거나 소속 부서가 없습니다.';

end y_dept;
/
execute dbms_output.put_line(y_dept(1));

--3. 부서번호를 입력할 경우 부서에 속한 사원의 사원이름, 부서이름을 출력하는 y_test 함수를 생성하시오.
--단, 소속된 부서에 사원이 없을 경우 예외처리(소속된 사원이 없습니다.) */

create or replace function y_test
  (p_deptId employees.department_id%type)
return varchar2
is
  v_name employees.last_name%type;
  v_deptName departments.department_name%type;
  message varchar2(1500);
  
  cursor dept_cursor is
  select e.last_name, d.department_name 
  from employees e, departments d
  where e.department_id = d.department_id
  and d.department_id = p_deptId;
  
  dept_record dept_cursor%rowtype;
begin
  open dept_cursor;
  
  loop
  fetch dept_cursor into dept_record;
   message := message || '사원이름: ' || dept_record.last_name || ', 부서 : '|| dept_record.department_name ||CHR(13);
    exit when dept_cursor%notfound; 
  end loop;
    close dept_cursor;
  return message;
exception
  when no_data_found then
     return '사원이 없습니다';
end y_test;
/
execute dbms_output.put_line(y_test(50));