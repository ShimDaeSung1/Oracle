문제1. 오라클XE설치, DB생성하기
create tablespace mydb datafile
'C:\oraclexe\app\oracle\oradata\XE\mydb.dbf' size 100M
autoextend on next 5M;

문제2. 사용자계정 생성하기
create user hkd identified by hkd
default tablespace mydb
temporary tablespace temp;
문제2-1 권한설정
grant dba to hkd;


문제3. 테이블 생성
create table student(
    id varchar(30) PRIMARY KEY,
    name varchar(30) not null,
    department varchar(30) not null
);

insert into student values(201720156, '심대성', '산업공학과');
insert into student values(201920156, '박대성', '전자공학과');
insert into student values(202220156, '김대성', '컴퓨터공학과');

desc student;
select*from student;

문제4. 인덱스 생성하기
create Index dep_index on student(department DESC)

