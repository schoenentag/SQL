--2022.08.03 package(overload)
--package spec
CREATE OR REPLACE PACKAGE dept_pkg
IS
  PROCEDURE add_department
    (p_deptno departments.department_id%type,
     p_name departments.department_name%type := 'unknown',
     p_loc departments.location_id%type := 1700);
  PROCEDURE add_department
    (p_name departments.department_name%type := 'unknown',
     p_loc departments.location_id%type := 1700);
END dept_pkg;
/
--package body
CREATE OR REPLACE PACKAGE BODY dept_pkg
IS
  PROCEDURE add_department
    (p_deptno departments.department_id%type,
     p_name departments.department_name%type := 'unknown',
     p_loc departments.location_id%type := 1700)
  IS
  BEGIN
    insert into departments (department_id, department_name, location_id)
    values (p_deptno, p_name, p_loc);
  END add_department;

  PROCEDURE add_department
    (p_name departments.department_name%type := 'unknown',
     p_loc departments.location_id%type := 1700)
  IS
  BEGIN
    insert into departments (department_id, department_name, location_id)
    values (departments_seq.NEXTVAL, p_name, p_loc);
  END add_department;
END dept_pkg;
/
execute dept_pkg.add_department(980,'Education', 2500)
execute dept_pkg.add_department('Training', 2500);
select * from departments;

-- 사용자 정의 패키지 생성
CREATE OR REPLACE PACKAGE taxes_pack
IS
  function tax
    (p_value in number)
  return number;
END taxes_pack;
/
CREATE OR REPLACE PACKAGE BODY taxes_pack
IS
  function tax
    (p_value in number)
    return number
  IS
    v_rate number := 0.08;
  BEGIN
    return (p_value * v_rate);
  END tax;
END taxes_pack;
/
select taxes_pack.tax(salary), salary, last_name
from employees;

-- 패키지 PL/SQL 테이블 및 레코드
CREATE OR REPLACE PACKAGE emp_pkg
IS
  type emp_table_type
  is
    table of employees%rowtype
    index by binary_integer;
  procedure get_employees
   (p_emps out emp_table_type);
END emp_pkg;
/
CREATE OR REPLACE PACKAGE BODY emp_pkg
IS
  procedure get_employees
    (p_emps out emp_table_type)
  is
    v_i binary_integer := 0;
  begin
    for emp_record in (select * from employees) loop
      p_emps(v_i) := emp_record;
      v_i := v_i +1;
    end loop;
  end get_employees;
END emp_pkg;
/
set serveroutput on
declare
  v_employees emp_pkg.emp_table_type;
begin
  emp_pkg.get_employees(v_employees);
  dbms_output.put_line('EMP 5: ' || v_employees(4).last_name);
end;
/
--패키지 문제
--1. 주민번호(8912011676666)을 입력하면 나이와 성별을 출력하는 yd_pkg 패키지를 생성하시오.
--나이 출력하는 서브프로그램 (y_age), 성별 출력하는 서브프로그램(y_sex)
create or replace function y_age
  (p_num number)
  return number
is
  v_year number(10); 
  v_crrYear number(4) := 2022;
  v_age number(10);
begin
  if substr(p_num,7,1) = 3 or substr(p_num,7,1) = 4 then
    v_year := 20 || substr(p_num,1,2);
    v_age := v_crrYear - v_year +1;
  elsif substr(p_num,7,1) = 1 or substr(p_num,7,1) = 2 then
    v_year := 19 || substr(p_num,1,2);
    v_age := v_crrYear - v_year +1;
  end if;
  return v_age;
end y_age;
/
execute dbms_output.put_line(y_age(8912011676666)||'살');
/
create or replace function y_sex
  (p_num number)
  return varchar2
is
 v_sex varchar2(15);
begin
  if substr(p_num,7,1) = 1 or substr(p_num,7,1) = 3 then
    v_sex := '남자';
  elsif substr(p_num,7,1) = 2 or substr(p_num,7,1) = 4 then
    v_sex := '여자';
  end if;
  return v_sex;
end y_sex;
/
execute dbms_output.put_line(y_sex(8912011676666));
/
-- 패키지로 만들어보기..
CREATE OR REPLACE PACKAGE yd_pkg
IS
  function y_age (p_num varchar2)
  return varchar2;
  function y_sex (p_num varchar2)
  return varchar2;
END;
/
CREATE OR REPLACE PACKAGE BODY yd_pkg
is
  function y_age
    (p_num varchar2)
    return varchar2
  is
    v_year varchar2(10); 
    v_crrYear varchar2(4) := to_char(sysdate,'yyyy');
    v_age varchar2(10);
  begin
    --if substr(p_num,7,1) = 3 or substr(p_num,7,1) = 4 then
    if substr(p_num,7,1) in(3,4) then 
      v_year := 20 || substr(p_num,1,2);
      v_age := v_crrYear - v_year +1;
    elsif substr(p_num,7,1) in(1,2) then
      v_year := 19 || substr(p_num,1,2);
      v_age := v_crrYear - v_year +1;
  end if;
  return v_age;
  end y_age;

  function y_sex
    (p_num varchar2)
    return varchar2
  is
   v_sex varchar2(15);
  begin
    if substr(p_num,7,1) in(1,3) then
      v_sex := '남자';
    elsif substr(p_num,7,1) in(2,4) then
      v_sex := '여자';
    end if;
    return v_sex;
  end y_sex;
END;
/
execute dbms_output.put_line(yd_pkg.y_age('8912011676666')||'살');
execute dbms_output.put_line(yd_pkg.y_sex('8912011676666'));
execute dbms_output.put_line(yd_pkg.y_age('0012014676666')||'살');
execute dbms_output.put_line(yd_pkg.y_sex('0012014676666'));

--Triggers(트리거)
-- 제재를 가하기 위한 트리거는 권장하지 않음
create or replace trigger secure_emp
before insert on departments
begin 
  if (to_char(sysdate, 'DY') in ('수','일')) or 
    (to_char(sysdate, 'HH24:MI') not between '08:00' and '18:00') then
  raise_application_error(-20500, '입력안됨');
  end if;
end;
/
drop trigger secure_emp;
insert into departments(department_id, department_name)
values (444, 'YD');

-- 트리거 이벤트 결합
create or replace trigger secure_emp
before insert or update or delete on departments
  begin
      if (to_char(sysdate, 'DY') in ('수','일')) or 
         (to_char(sysdate,'HH24') not between '08' and '18') then
        if deleting then
          raise_application_error(-20502, '삭제안됨');
         elsif inserting then
          raise_application_error(-20500, '삽입안됨');
         elsif updating('department_name') then
          raise_application_error(-20503, '갱신안됨');
         else
          raise_application_error(-20504, '작업안됨');
         end if;
        end if;
end;
/
-->삽입안됨
insert into departments(department_id, department_name)
values (555,'YD');
--> 갱신안됨
update departments
set department_name = 'Yedam'
where department_id = 444;
-->작업안됨
update departments
set location_id = '1700'
where department_id = 444;
-->삭제안됨
delete departments
where department_id = 444;

--행트리거
create or replace trigger restrict_salary
before insert or update of salary on employees
for each row
  begin
  if :new.job_id in ('AD_PRES', 'AD_VP') and :new.salary > 15000 then
    raise_application_error(-20202, 'Employee cannot earn more than $15,000.');
  end if;
end;
 /
update employees set salary = 15500 where employee_id = 102;
select * from employees where employee_id =102;
/
-- 행트리거 old값, new값
create table audit_emp(
  user_name varchar2(30),
  time_stamp date,
  id number(6),
  old_last_name varchar2(25),
  new_last_name varchar2(25),
  old_title varchar2(10),
  new_title varchar2(10),
  old_salary number(8,2),
  new_salary number(8,2))
/
create or replace trigger audit_emp_values
after delete or insert or update on employees
for each row
begin
  insert into audit_emp values (user, sysdate, :old.employee_id, :old.last_name, :new.last_name,
                                :old.job_id, :new.job_id, :old.salary, :new.salary);
end;
/
insert into employees(employee_id, last_name, job_id, salary, email, hire_date)
values (999, 'Emp emp', 'SA_REP', 6000, 'TEMPEMP', TRUNC(sysdate));

update employees
set salary = 7000, last_name = 'Smith'
where employee_id = 999;

select * from audit_emp;
select *from employees where employee_id = 999;

--트리거 코드 표시
select trigger_name, trigger_type, triggering_event,
       table_name, referencing_names, when_clause, status, trigger_body
from user_triggers;
drop trigger secure_emp;
drop trigger audit_emp_values;
drop trigger restrict_salary;