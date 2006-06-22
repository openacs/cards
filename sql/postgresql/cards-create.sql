-- TABLE UV_CARD -------------------------------------------------------------
create sequence card_sequence start 1;
create table card (
    card_id           integer primary key default nextval ('card_sequence'),
    ref_community     integer not null,
    ref_user          integer not null,
    comm_student      varchar (1000),
    comm_teacher      varchar (1000),
    closed            boolean default 'f',
    address           varchar (300),
    phone1            varchar (60),
    grade             varchar (30)
);
create unique index card_idx on card (ref_community, ref_user);

-- TABLE  CARD_PERCENT -------------------------------------------------------------
create sequence card_percent_sequence start 1;
create table card_percent (
        percent_id          integer primary key default nextval('card_percent_sequence'),  
        ref_community       integer not null,
        percent_name        varchar (50),
                type                            integer not null,
        percent             double precision default 0,        
        rvalor              double precision default 0.0
);
create index card_percent_comm_idx on card_percent (ref_community);

-- TABLE CARD_TASK -------------------------------------------------------------
create sequence card_task_sequence start 1;  
create table card_task (
        task_id                         integer primary key default nextval('card_task_sequence'),
        ref_community       integer not null,
        ref_percent         integer not null,
                task_name           varchar (50),
        task_percent        double precision default 0.00,
                max_grade           double precision not null default 10.00,
        constraint          ref_percent_fk foreign key (ref_percent) references card_percent (percent_id)
);
create index card_task_comm_idx on card_task (ref_community);
create index card_task_percent_idx on card_task (ref_percent);    

-- TABLE CARD_NOTE -------------------------------------------------------------
create sequence card_note_sequence start 1;
create table card_note (
        note_id        integer primary key default nextval('card_note_sequence'),
        ref_card        integer not null,        
                ref_community   integer not null,
        ref_task        integer not null,
                date            timestamptz default current_timestamp not null,
                date_mod        timestamptz default current_timestamp not null,
        grade           numeric(4,2) default 0.00,
        note_comment    varchar (400),        
        is_active       boolean default true,        
        constraint      ref_task_fk foreign key (ref_task) references card_task (task_id),
        constraint      ref_id_cards_fk foreign key (ref_card) references card (card_id)
);
create index card_note_comm_idx on card_note (ref_community);
create index card_note_task_idx on card_note (ref_task);



-- TABLE CARD_COMMENTS  -------------------------------------------------------------
create sequence card_comment_sequence start 1;
create table card_comment (
        comment_id      integer primary key default nextval('card_comment_sequence'),
        ref_card        integer not null,        
                ref_community   integer not null,
        date            timestamptz default current_timestamp not null,
                date_mod        timestamptz default current_timestamp not null,
        comment         varchar (400),        
        constraint      ref_id_cards_fk foreign key (ref_card) references card(card_id)
);
create index card_comment_comm_idx on card_comment (ref_community);
