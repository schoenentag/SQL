--2022.08.03 TEST
--2. 사원의 id를 입력받아 부서이름, job_id, 급여 연간 총수입을 출력하는 PL/SQL Block를 작성하세요.
-- 급여나 커미션이 Null일 경우더라도 값이 출력되도록 하세요.
set serveroutput on
create or replace procedure p_sal
  (p_empId employees.employee_id%type)
is
 v_dname departments.department_name%type;
 v_jobId employees.job_id%type;
 v_sal employees.salary%type;
begin
  select d.department_name, e.job_id, (e.salary*12+(e.salary*nvl(e.COMMISSION_PCT,0)*12)) as "연간총수입"
  into v_dname, v_jobId, v_sal
  from employees e, departments d
  where e.department_id = d.department_id
  and e.employee_id = p_empId;
  DBMS_OUTPUT.put_line('부서이름 : ' || v_dname || ', 직무 : ' || v_jobId || ', 연간 총수입 : ' || v_sal);
end p_sal;
/
execute p_sal(100);
select * from employees where employee_id = 100;

--3.employees에서 특정 사원의 입사년도가 1998년 이후에 입사하면 'New employee', 아니면 'Career employee'라고 출력하시오.
create or replace function f_emp
 (f_empId employees.employee_id%type)
  return varchar2
is
 v_hireDate employees.hire_date%type;
begin
  select hire_date
  into v_hireDate
  from employees
  where employee_id = f_empId;
  
  if to_char(v_hireDate, 'YYYY' ) >= 1998 then
   return 'New employee';
  else 
   return 'Career employee';
  end if;
end f_emp;
/
execute dbms_output.put_line(f_emp(100));
execute dbms_output.put_line(f_emp(201));
select * from employees where employee_id = 201;

--4. 구구단 1단~9단을 출력하는 PL/SQL 블록을 작성하시오 (단, 홀수단만 출력)
declare
begin
  for i in 1..9 loop
    if mod(i,2) = 1 then
    dbms_output.put_line(i ||'단');
      for j in 1..9 loop
        dbms_output.put_line(i ||'*' || j ||'=' || i*j);
      end loop;
    end if;
  end loop;
end;
/

-- 5. 부서번호를 입력하면 해당 부서에 근무하는 사원의 사번, 이름, 급여를 출력하는 PL/SQL블록을 작성하시오.
create or replace procedure empList
  (p_dId employees.department_id%type)
is
  cursor c_emp_cursor is
    select employee_id, last_name, salary
    from employees
    where department_id = p_dId;
begin
  for emp_cursor in c_emp_cursor loop
    DBMS_OUTPUT.PUT_LINE('사번 : '||emp_cursor.employee_id ||', 성 : ' || emp_cursor.last_name || ', 급여 :'|| emp_cursor.salary);
  end loop;
end;
/
execute empList(50);
select * from employees where department_id = 50;

-- 6. 직원들의 사번, 급여 증가치만 입력하면 employees테이블에 쉽게 사원의 급여를 갱신할 수 있도록 procedure를 작성하시오.
-- 만약 입력한 사원이 없는 경우 'NO search employee!!'라는 메세지를 출력하시오(exception절 사용)
create or replace procedure empSal
 (p_empId employees.employee_id%type,
  p_persent number)
is
  v_sal employees.salary%type;
begin
  select salary
  into v_sal
  from employees
  where employee_id = p_empId;
  
  update employees set salary = salary*(1+p_persent/100) where employee_id = p_empId;

exception
  when no_data_found then
  dbms_output.put_line('NO search employee!!');
end empSal;
/
execute empSal(100,10);
execute empSal(1000,10);
select employee_id, salary from employees where employee_id = 100; 
rollback;

--7. 주민등록번호(9911021234567)를 입력받으면 나이와 성별을 출력하는 프로그램을 작성하세요.
create or replace package p_num
is
  function f_age (f_num varchar2) return varchar2;
  function f_sex (f_num varchar2) return varchar2;
end p_num;
/
create or replace package body p_num
is
  function f_age
    (f_num varchar2)
    return varchar2
  is
    v_age varchar2(10);
    v_year varchar2(10);
    v_crrYear varchar2(10) := to_char(sysdate, 'YYYY');
  begin
    if substr(f_num,7,1) in ('1','2') then
      v_year := 19 || substr(f_num,1,2); 
      v_age := v_crrYear - v_year + 1;
    else
      v_year := 20 || substr(f_num,1,2); 
      v_age := v_crrYear - v_year + 1;
    end if;
    return v_age;
  end f_age;
  
  function f_sex
    (f_num varchar2)
    return varchar2
  is
    v_sex varchar2(10);
  begin
    if substr(f_num,7,1) in ('1','3') then
      v_sex := '남자';
    else
      v_sex := '여자';
    end if;
    return v_sex;
  end f_sex;
end p_num;
/
execute dbms_output.put_line('나이 : '||p_num.f_age('9911021234567')||'살');
execute dbms_output.put_line('성별 : '||p_num.f_sex('9911021234567'));
execute dbms_output.put_line('나이 : '||p_num.f_age('0007284123456')||'살');
execute dbms_output.put_line('성별 : '||p_num.f_sex('0007284123456'));

--8. 사원의 사번을 입력으로 받으면 근무한 년수를 출력하는 function을 작성하시오
create or replace function e_year
  (f_empId employees.employee_id%type)
  return number
is
  v_arbeitYear number(15);
begin
  select trunc(((sysdate - hire_date)+1)/365)
  into v_arbeitYear
  from employees
  where employee_id = f_empId;
return v_arbeitYear;  
end e_year;
/
execute dbms_output.put_line(e_year(100)||'년');

--9. 부서이름을 입력하면 부서의 책임자(Manager)이름을 출력하는 Function을 작성하시오.
create or replace function d_manager
 (p_dname departments.department_name%type)
 return varchar2
is
  v_manager varchar2(20);
begin
  select e.last_name
  into v_manager
  from employees e , departments d
  where d.department_name = p_dname
  and d.manager_id = e.employee_id; 
  return v_manager;
end d_manager;
/
execute dbms_output.put_line(d_manager('IT'));
select * from employees;
select * from departments;

--10. HR사용자에게 존재하는 프로시저, 함수, 패키지, 패키지 바디의 이름과 소스코드를 확인하는 SQL구문을 작성하시오.
select * from user_source
where type = 'PROCEDURE';

--11. 다음과 같이 출력
declare 
 v_astar varchar2(1000) := '*';
begin
  for i in 1..9 loop
     dbms_output.put(lpad(v_astar,10,'-'));
      v_astar := v_astar || '*';
    dbms_output.put_line(' ');
  end loop;
end;
/
declare
v_char varchar2(1000) := '가나다';
begin
dbms_output.put_line(lpad(v_char, 10, '-'));
end;
/