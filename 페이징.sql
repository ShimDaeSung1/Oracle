create table member (
    id varchar2(10) primary key,
    pass varchar2(10) not null,
    name varchar2(30) not null,
    regidate date default sysdate not null  
);

create table board(
    num number primary key,
    title varchar2(200) not null,
    content varchar2(2000) not null,
    id varchar2(10) not null,
    postdate date default sysdate not null,
    visitcount number(6)
);

alter table board
    add constraint board_mem_fk foreign key(id)
    references member (id);
    
--일련번호용 시퀀스 생성
create sequence seq_board_num
    increment by 1
    start with 1
    minvalue 1
    nomaxvalue
    nocycle
    nocache;

insert into member(id, pass, name) values('musthave','1234','머스트해브');   

insert into board(num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '제목1입니다', '내용1입니다', 'musthave',
            sysdate, 0);
            
select*from board order by num desc;
delete board;

insert into board(num, title, content, id, postdate, visitcount)
select seq_board_num.nextval, title, content, id, postdate, visitcount from board;

select rownum, board.* from board
where rownum between 11 and 20
order by num desc;

select * from (
    select tb.*, rownum rNum from(
        select * from board order by num desc
    )tb
)
where rNum between 11 and 20;


select count(*) from board;
commit;
