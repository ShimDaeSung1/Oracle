--뷰 생성
create or replace view vw_emp20
as
select empno, ename, job, deptno
from emp
where deptno=20;

select * from vw_emp20;

--------- 복잡한 join -------
create view view1
as
select employees.first_name, jobs.job_title, department.departments_name, countries.country_name
from employees, job, departments, locations
where employees.job_id = jobs.job_id
and employees.department_id = departments.department_id
and deapartments.location_id = locations.location_id;

select * from view1;

select * from user_views;

drop view view1;
--- rownum를 이용해서 페이징처리. 게시판에서 페이징 처리시 사용
select * 
from (select rownum as rnum, E.* -- E.*은 해당 테이블의 모든 컬럼을 다 출력하라는 뜻
        from (select * 
            from emp e
                order by sal desc) e
        where rownum<= 6) b
    where b.rnum>=4;
    

create sequence seq_dept_sequence
increment by 10 -- 증가하는 양
START WITH 10 --초기값
maxvalue 90
minvalue 0
nocycle -- 최대값까지 가면 더이상 불가
cache 2; -- 시퀀스를 만들 때 메모리 사용, 시퀀스가 생성할 번호를 메모리에 미리 할당해 놓은 수를 지정

select * from user_sequences;

create table dept_sequence
    as select *
        from dept
        where 1<>1;
        
select  * from dept_sequence;

insert into dept_sequence(deptno, dname, loc)
values (seq_dept_sequence.nextval, 'database', 'seoul');
insert into dept_sequence(deptno, dname, loc)
values (seq_dept_sequence.nextval, 'SQL', 'JEJU');



select * from dept_sequence;

alter sequence seq_dept_sequence
increment by 3
maxvalue 99
cycle;

drop sequence seq_dept_sequence;

--게시판에서 번호 생성을 위한 시퀀스
create sequence board_sequence; --1부터 1씩 증가

create table table_notnull2(
    login_id varchar2(20) not null,
    login_pwd varchar2(20) not null,
    tel varchar2(20)
);

create table table_notnull2(
    login_id varchar2(20) constraint tblnn2_lgnid_nn not null,
    login_pwd varchar2(20) constraint tblnn2_lgnpw_nn not null,
    tel varchar2(20)
);

desc table_notnull;

insert into table_notnull (login_id, login_pwd) values('test', '1234');
insert into table_notnull(login_id) values('www');
select * from table_notnull;

alter table table_notnull2
modify(tel constraint tblnn_tel_nn not null);

create table table_unique(
    login_id varchar2(20) unique,
    login_pwd varchar2(20) not null,
    tel varchar2(20) 
);

insert into table_unique values('hdk', '1234', '010-1111-2222');
insert into table_unique values('hdk', '5678', '010-1111-3333');


create table table_pk(
    login_id varchar2(20) primary key,
    login_pwd varchar2(20) not null,
    tel varchar2(20)
);

desc table_pk;

insert into table_pk values('lss', '1234', '010-1111-2222');
insert into table_pk values('ls', '5678', '010-1111-9999');
update table table_pk set login_id = 'lsa' where login id = 'ls';

create table members (
    id varchar2(50) primary key,
    pw varchar2(50) not null,
    name varchar2(50) not null
);
insert into members values ('hkd', '1234', '홍길동');
insert into members values ('lss', '1234', '이순신');

select * from members;

create sequence board_seq;

create table board(
    bno number primary key,
    title varchar2(50) not null,
    id varchar2(50) constraint fk_members_id references members(id) on delete cascade
);


insert into board values(board_seq.nextval, 'sql이 뭔가요?', 'hkd');

insert into board values(board_seq.nextval, 'sql이 뭔가요?', 'abc');
delete from members where id = 'hkd';

select * from board;


create table table_check(
    login_id varchar2(20) constraint tblck_loginid_pk primary key,
    login_pwd varchar2(20) constraint tblck_loginpw_ck check (length(login_pwd)>3),
    tel varchar2(20)
);

create table temp(
    col1 varchar2(20),
    col2 varchar2(20)
);

grant select on temp to orclstudy;

-- 오라클 연습문제 05
create table Dongari (
    id varchar2(20) primary key,
    name varchar2(20) not null
); --1번 문제

create table DongariJoin(
    num number(4) primary key,
    student_id varchar2(20) not null,
    dongari_id varchar2(20) constraint DongariJoin_FK references Dongari(id)
); --2번 문제

insert into dongari values('001', '축구부');
insert into dongari values('002', '야구부');
insert into dongari values('003', '농구부');
insert into dongari values('004', '피구부');
select * from dongari;

insert into dongarijoin values(1, 'sds', '001');
insert into dongarijoin values(2, 'sds', '002');
insert into dongarijoin values(3, 'kas', '001');
insert into dongarijoin values(4, 'ala', '003');
select * from dongarijoin;

create table student(
    student_id varchar2(20) primary key,
    name varchar2(20) not null
);
insert into student values('sds', '심대성');
insert into student values('kas', '강유석');
insert into student values('ala', '므르므');
insert into student values('www', '월와웹');


alter table Dongarijoin 
add constraint Dongarijoint_id_FK
foreign key(student_id)
references student(student_id);

select * from dongari;

select d.name, s.name, d1.student_id 
from dongari d join dongarijoin d1 on d.id = d1.dongari_id
join student s on d1.student_id = s.student_id; -- 3번 문제 동아리 가입현황 목록

select s.student_id 동아리미가입자, s.name 이름, d.dongari_id
from student s left join dongarijoin d
on s.student_id = d.student_id
where d.dongari_id is null; --4번문제 동아리에 가입하지 않은 학생목록

select d.name 
from dongari d left join dongarijoin d1
on d.id = d1.dongari_id
where d1.dongari_id is null; -- 5번문제 한 명의 학생도 가입하지 않은 동아리

create table book(
    bid char(4) primary key,
    title varchar(20) not null
);

insert into book values('0001', '자바');
insert into book values('0002', 'Oracle');
insert into book values('0003', 'HTML');
insert into book values('0004', 'JSP'); --6번 문제

select * from book;

create table bookRent(
    no number primary key,
    id varchar(10) not null,
    bid char(4) not null constraint bookRent_bid_fk references book(bid),
    rdate date
); --7번문제

alter table bookrent modify id varchar(20);
alter table bookrent add constraint bookrent_id_fk foreign key(id) references student(student_id);

select*from student;

desc student;

insert into bookrent values(20160001, 'sds', '0001', '2016-12-01');
insert into bookrent values(20162233, 'kas', '0002', '2016-12-02'); --8번문제

select s.student_id, s.name, b.title, r.rdate
from student s join bookrent r on s.student_id = r.id
join book b on b.bid = r.bid; -- 9번 문제

select b.title
from book b left join bookrent r
on b.bid = r.bid
where id is null; -- 10번문제 한 번도 대출되지 않은 책 목록










