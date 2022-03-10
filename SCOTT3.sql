create table avg_sal(
    deptno number(2, 0) not null,
    avgsal number not null
);

insert into avg_sal
select 20, avg(sal)
from emp
where deptno=20;

select * from avg_sal;

commit;

create or replace procedure proc_avg_sal(
    p_deptno in number
)
is
begin
    insert into avg_sal
    select p_deptno, avg(sal)
    from emp
    where deptno=p_deptno;
    
    commit;
end;

exec proc_avg_sal(10);   

select * from avg_sal;


create or replace function func_aftertax(
    sal in number
)
return number
is
    tax number := 0.05;
begin
    return (round(sal-(sal*tax)));
end func_aftertax;

select empno, ename, sal, func_aftertax(sal) as AFTERTAX
 from emp;
 

create table emp_trg
as
select * from emp;

create or replace trigger trg_emp_nodml_weekend
before
insert or update or delete on EMP_TRG
for each row -- :old, :new를 사용
declare
    v_row emp%rowtype
begin
    select * into v_row 
    from : old;
    
    if to_char(sysdate, 'DY') IN ('토', '일') then
        if inserting then
            raise_application_error(-20000, '주말 사원정보 추가 불가');
        elsif updating then
            raise_application_error(-20001, '주말 사원정보 수정 불가');
        elsif deleting then
            raise_application_error(-20002, '주말 사원정보 삭제 불가');
        else
            raise_application_error(-20003, '주말 사원정보 변경 불가');
        end if;
    end if;
end;

delete from emp_trg;
update emp_trg set sal = 1000;

select * from emp_trg;

rollback;

--로그 저장용 테이블
create table emp_trg_log( 
    tablename varchar2(10),
    dml_type varchar2(10),
    empno number(4),
    user_name varchar2(30),
    change_data date
);

create or replace trigger trg_emp_log
after
insert or update or delete on emp_trg
for each row

begin
    if inserting then
        insert into emp_trg_log
        values('EMP_TRG', 'INSERT', :new.empno,
                SYS_CONTEXT('USERENV', 'SESSION_USER'), sysdate);
            
    elsif updating then
        insert into emp_trg_log
        values('EMP_TRG', 'UPDATE', :old.empno,
                SYS_CONTEXT('USERENV', 'SESSION_USER'), sysdate);
         insert into emp_trg_log
        values('EMP_TRG', 'UPDATE', :new.empno,
                SYS_CONTEXT('USERENV', 'SESSION_USER'), sysdate);
                
    elsif deleting then
        insert into emp_trg_log
        values('EMP_TRG', 'delete', :old.empno,
                SYS_CONTEXT('USERENV', 'SESSION_USER'), sysdate);
    end if;
end;

desc emp_trg;
select * from emp_trg
insert into emp_trg values(9999,'TestEmp','CLERK',7788,'22-03-03', 1200,null,20)
delete from emp_trg where empno=9999;

commit;

select * from emp_trg_log

update emp_trg set
empno = 7777 where empno = 9999; --old는 9999, new는 7777이다.

drop trigger trg_emp_log;
    
