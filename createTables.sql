create table users (username varchar(50) not null primary key, password varchar(150) not null, enabled boolean not null);

create table authorities(username varchar(50) not null, authority varchar(50) not null);

alter table authorities add foreign key(username) references users(username);


insert into users values('leela','secret',true);

insert into users values('abc', 'password', true);

insert into authorities values('leela', 'ROLE_ADMIN');

insert into authorities values('leela', 'ROLE_USER');

insert into authorities values('abc', 'ROLE_USER');

select * from users;
select * from authorities;


export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_172.jdk/Contents/Home
export DERBY_INSTALL=/Users/Leela/Desktop/spring-workspace/db-derby-10.11.1.1-bin
export CLASSPATH=$CLASSPATH:$DERBY_INSTALL/lib/derby.jar:$DERBY_INSTALL/lib/derbytools.jar:$DERBY_INSTALL/lib/derbyclient.jar

java org.apache.derby.tools.ij
connect 'jdbc:derby:MyDB;create=true';
connect 'jdbc:derby://localhost/MyDB2';



drop table authorities;
drop table users;

create table tbl_users (username varchar(50) not null primary key, password varchar(150) not null);
create table tbl_roles(username varchar(50) not null, role varchar(50) not null);

insert into tbl_users values('prasad','secret');
insert into tbl_users values('xyz', 'password');
insert into tbl_roles values('prasad', 'ROLE_ADMIN');
insert into tbl_roles values('prasad', 'ROLE_USER');
insert into tbl_roles values('xyz', 'ROLE_USER');