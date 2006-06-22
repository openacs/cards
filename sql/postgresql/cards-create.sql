-- TABLE UV_CARD -------------------------------------------------------------
create sequence uv_card_sequence start 1;
create table uv_card (
    id_card           integer primary key default nextval ('uv_card_sequence'),
    ref_community_id  integer not null,
    ref_user_id       integer not null,
    comm_student      varchar (1000),
    comm_teacher      varchar (1000),
    address           varchar (300),
    phone1            varchar (30),
    phone2            varchar (30)
);
create unique index uv_card_idx on uv_card (ref_community_id, ref_user_id);


-- TABLE UV_CARD_BASE_NOTE -------------------------------------------------------------
create table uv_card_base_note (
        community_id    integer primary key,
        base_note       integer not null default 100,
        alum_view   integer default 0
); 

-- TABLE UV_CARD_BASETYPE_NOTE -------------------------------------------------------------
create table uv_card_basetype_note (
        id_basetype     integer primary key,          
        name_basetype   varchar (30),
        info_basetype   varchar (300),
        is_numeric      boolean default true
);

-- TABLE UV_CARD_XCENT_NOTE -------------------------------------------------------------
create sequence uv_card_xcent_note_sequence start 1;
create table uv_card_xcent_note (
        id_xcent                integer primary key default nextval('uv_card_xcent_note_sequence'),  
        ref_community_id        integer not null,
        ref_basetype    integer not null,
        name_xcent              varchar (50),
        xcent               double precision default 0,
        allow_act               boolean default false,
        rvalor          double precision default 0.0,
        np              boolean default false,
        constraint              ref_basetype_fk foreign key (ref_basetype) references uv_card_basetype_note (id_basetype)
);
create index uv_card_xcent_comm_idx on uv_card_xcent_note (ref_community_id);

-- TABLE UV_CARD_SUBTYPE_NOTE -------------------------------------------------------------
create sequence uv_card_subtype_note_sequence start 1;  
create table uv_card_subtype_note (
        id_subtype              integer primary key default nextval('uv_card_subtype_note_sequence'),
        ref_community_id        integer not null,
        ref_xcent               integer not null,
        sub_xcent       double precision default 0.00,
        name_subtype    varchar (50),
        constraint              ref_xcent_fk foreign key (ref_xcent) references uv_card_xcent_note (id_xcent)
);
create index uv_card_subtype_comm_idx on uv_card_subtype_note (ref_community_id);
create index uv_card_subtype_xcent_idx on uv_card_subtype_note (ref_xcent);    

-- TABLE UV_CARD_NOTES -------------------------------------------------------------
create sequence uv_card_notes_sequence start 1;
create table uv_card_notes (
        id_card_notes   integer primary key default nextval('uv_card_notes_sequence'),
        ref_id_card     integer not null,
        note_datetime   timestamptz default current_timestamp not null,
        ref_subtype     integer not null,
        value_n         numeric(4,2) default 0.00,
        value_s         varchar (300),
        is_public       boolean default false,
        is_active       boolean default true,
        r_community_id  integer not null,
        constraint      ref_subtype_fk foreign key (ref_subtype) references uv_card_subtype_note(id_subtype),
        constraint      ref_id_cards_fk foreign key (ref_id_card) references uv_card(id_card)
);
create index uv_card_notes_comm_idx on uv_card_notes (r_community_id);
create index uv_card_notes_subtype_idx on uv_card_notes (ref_subtype);


-- INICIALIZACIÓN DE DATOS -------------------------------------------------------------
insert into uv_card_basetype_note (id_basetype, name_basetype, info_basetype, is_numeric) values (1,'Básico', 'Anotaciones sencillas: prácticas, tareas, trabajos, actividades, ...','t');
insert into uv_card_basetype_note (id_basetype, name_basetype, info_basetype, is_numeric) values (2,'Seleccionable', 'Anotaciones que permiten selección: exámenes','t');
insert into uv_card_basetype_note (id_basetype, name_basetype, info_basetype, is_numeric) values (3,'Texto', 'Anotaciones sin asignación de nota: comentarios','f');

