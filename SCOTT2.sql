set serveroutput on;

begin
DBMS_OUTPUT.PUT_LINE('Hello, PL/SQL!');
end;

declare
    v_empno number(4) := 7788;
    V_ename varchar(10);
BEGIN
    v_ename := 'scott';
    dbms_output.put_line('V_EMPNO : ' || V_EMPNO);
    DBMS_output.put_line('V_ENAME : ' || V_ENAME);
end;

declare
    v_deptno number(2,0) := 50;
begin
    dbms_output.put_line('v_deptno : ' || v_deptno);
end;

declare 
    v_dept_row dept%rowtype;
begin
    select deptno, dname, loc into v_dept_row
    from dept
    where deptno = 40;
    dbms_output_put_line('deptno : ' || V_DEPT_ROW.deptno);
end;

declare 
    v_number number := 14;
begin
    if mod(v_number, 2) =1 then
        dbms_output.put_line('v_number는 홀수입니다');
    else
        dbms_output.put_line('v_number는 짝수입니다');
    end if;
end;

declare
    v_score number := 87;
begin
    if v_score >= 90 then
        dbms_output.put_line('A학점');
    elsif v_score >= 80 then
        dbms_output.put_line('B학점');
     elsif v_score >= 70 then
        dbms_output.put_line('C학점');
     elsif v_score >= 60 then
        dbms_output.put_line('D학점');
     else
        dbms_output.put_line('F학점');
    end if;
end;

declare
    v_score number := 87;
begin
    case
        when v_score >= 90 then dbms_output.put_line('A학점');
        when v_score >= 80 then dbms_output.put_line('B학점');
        when v_score >= 70 then dbms_output.put_line('C학점');
        when v_score >= 60 then dbms_output.put_line('D학점');
        else dbms_output.put_line('F학점');
    end case;
end;

declare
    v_num number := 0;
begin
    while v_num < 4 LOOP
    dbms_output.put_line('현재 V_NUM : ' || V_NUM);
    V_num := v_num + 1;
    end loop;
end;

begin
    for i in 0..4 loop
        continue when mod(i,2) = 1; --나머지 구하는 연산
        dbms_output.put_line('현재i의 값 : ' || i);
    end loop;
end;

--declare
--    type rec_dept is record(
--    deptno number(2) not null := 99,
--    dname dept.dname%type,
--    loc dept.loc%type
--    );

declare
    type rec_dept is record(
        deptno dept.deptno%type,
        dname dept.dname%type,
        loc dept.loc%type
    );
    type rec_emp is record(
    empno emp.empno%type,
    ename emp.ename%type,
    dinfo rec_dept
    );
    emp_rec rec_emp;
begin
    select e.empno, e.ename, d.deptno, d.dname, d.loc
    
    into emp_rec.empno, emp_rec.ename,
        emp_rec.dinfo.deptno,
        emp_rec.dinfo.dname,
        emp_rec.dinfo.loc
    from emp e, dept d
    where e.deptno = d.deptno
    and e.empno = 7788;
    dbms_output.put_line('empno : ' || emp_rec.empno);
    dbms_output.put_line('ename : ' || emp_rec.ename);
    
    dbms_output.put_line('deptno : ' || emp_rec.dinfo.deptno);
    dbms_output.put_line('dname: ' || emp_rec.dinfo.dname);
    dbms_output.put_line('loc : ' || emp_rec.dinfo.loc);
end;

select * from emp where empno = 7788;


declare
    type itab_dept is table of dept%rowtype
        index by pls_integer;
        
    dept_arr itab_dept;
    idx pls_integer := 0;
    
begin
    for i in(select * from dept) loop
    idx := idx + 1;
    dept_arr(idx).deptno := i.deptno;
    dept_arr(idx).dname := i.dname;
    dept_arr(idx).loc := i.loc;
    
    dbms_output.put_line(
        dept_arr(idx).deptno || ' : ' ||
        dept_arr(idx).dname || ' : ' ||
        dept_arr(idx).loc);
    end loop;
end;


create or replace procedure pro_noparam
is
    V_EMPNO NUMBER(4) := 7788; --변수 선언
    V_ENAME VARCHAR2(10);  --변수 선언
 begin 
    V_ENAME := 'SCOTT';
    DBMS_output.put_line('V_EMPNO : ' || V_EMPNO);
    DBMS_output.put_line('V_ENAME : ' || V_ENAME);
end;

execute pro_noparam;

create or replace procedure pro_param_out
(
    in_empno in EMP.EMPNO%TYPE, --파라미터 선언 부위 (괄호 안) 
    out_ename out EMP.ENAME%TYPE,
    out_sal out EMP.SAL%TYPE
)
is
--일반 변수 선언 부위
begin
    select ENAME, SAL INTO out_ename, out_sal
        from emp
    where EMPNO = in_empno;
end pro_param_out;

declare 
    v_ename EMP.ENAME%TYPE;
    v_sal EMP.SAL%TYPE;
begin
    pro_param_out(7788, v_ename, v_sal);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || v_sal);
end;

select ename as 직원성명,
       deptno as 부서번호,
       decode(deptno, 10, '부서번호10번', '10번아님') as DECODE
from emp;

select ename as 직원성명,
       job as 직책,
       hiredate as 입사일,
       decode(job, 'SALESMAN', '세일즈맨', 'X') as 세일즈맨여부
from emp;


    
    

