create table t_user(
    mid NUMERIC,
    coins numeric,
    name varchar(100) not null ,
    sex varchar(100),
    birthday varchar(100),
    level int not null,
    sign varchar(100),
    identity varchar(100),
    password varchar(100),
    qq varchar(100),
    wechat varchar(100),
    check (identity in('USER','SUPERUSER'))
);


create table follows(
    followee numeric,
    follower numeric
);



create table videos(
    bv varchar(20) not null ,
    title varchar(100) not null ,
    mid numeric not null ,
    name varchar(100) not null ,
    commit_time timestamp(0),
    review_time timestamp(0),
    public_time timestamp(0),
    duration float,
    description text,
    reviewer numeric
);


create table liker(
    bv varchar(20),
    mid numeric
);
create table coin(
    bv varchar(20),
    mid numeric
);
create table favorite(
    bv varchar(20),
    mid numeric
);
create table View(
    bv varchar(20),
    mid numeric,
    view numeric
);
create table Danmu(
    id serial,
    mid numeric not null,
    time numeric not null,
    content text not null,
    postTime varchar,
    bv varchar(15) not null,
    check ( time>=0 )
);
create table Danmu_like(
    id integer not null,
    likeBy numeric not null
);
CREATE INDEX follow_index ON follows (followee, follower);

alter table t_user add primary key (mid);

alter table videos add primary key (bv);

alter table liker add primary key (BV,mid);

alter table favorite add primary key (BV,mid);

alter table coin add primary key (BV,mid);

alter table View add primary key (BV,mid);

alter table Danmu add primary key (id);

