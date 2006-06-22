ad_page_contract {
}  -query {
  {order:optional last_name}
  {order_dir:optional asc}
  {mode:optional ""}
} -properties {
}

set dotlrn_url [dotlrn::get_url]
set my_user_id [ad_conn user_id]
set referer [ns_conn url]


# Check if we are in a subcommunity. In this case, we use the big parent community cards
# but only show the user cards that are in subgroup

# Community and big parent community
set community_selected [dotlrn_community::get_community_id]
set community_name [cards::get_community_pretty_name -community_id $community_selected]
set parent_community_id [cards::get_big_parent_community -community_id $community_selected]
set reuse_parent_cards [cards::get_community_parameter -community_id $community_selected -param "ReuseParentCards"]

if {$community_selected == $parent_community_id} {
        set subgroup 0
        set community_id $community_selected
} else {
        set subgroup 1
        set community_id $community_selected
        # If we reuse the cards we have to do the next actions, otherwise notihing to do
        if {$reuse_parent_cards eq 1} {
                set community_id $parent_community_id
                set community_name [cards::get_community_pretty_name -community_id $community_id]
                append  community_name " :: " [cards::get_community_pretty_name -community_id $community_selected]
        }
}



#set community_id [dotlrn_community::get_community_id]
#set community_selected $community_id
#set community_id [cards::get_big_parent_community -community_id $community_id]
#if {$community_selected ne $community_id} {
#       append community_name [cards::get_community_pretty_name -community_id $community_id] \
#       " :: " [cards::get_community_pretty_name -community_id $community_selected]
#} else {
#       set community_name [cards::get_community_pretty_name -community_id $community_id]
#}



# Access control
set site_wide_admin_p [permission::permission_p \
    -object_id [acs_magic_object security_context_root] \
    -privilege admin \
]

if {!$site_wide_admin_p} {
    set admin_p [dotlrn::user_can_admin_community_p -user_id $my_user_id -community_id $community_id]
} else {
    set admin_p 1
}

set site_admin [acs_user::site_wide_admin_p]

        
        
#****************************************************
#OPCIONES DE MANTENIMIENTO
#****************************************************

# Baja de alumnos no miembros de la comunidad ==> POR DECIDIR


# ------------------------------------------------------------------
# ALTA de alumnos miembros de la comunidad sin ficha
# ------------------------------------------------------------------
# 1. seleccionar usuarios sin card para la comunidad
set num_notes_created 0
set l_students_no_card [cards::get_no_card_student_list -community_id $community_id]

# 2. Seleccionar anotaciones de la comunidad
#db_multirow community_notes community_notes_sql { *SQL* }
set l_tasks [cards::get_community_tasks -community_id $community_id]


# 3. Crear las CARDS a los usuarios sin card
foreach usr $l_students_no_card {
        # creamos la card
    #db_dml insert_add_new_card { *SQL* }
        cards::create_student_card -community_id $community_id -user_id $usr
        
        # Obtenemos su card_id en esa comunidad
    #db_1row card_user_id { *SQL* }
        set card_id [cards::get_card_id -community_id $community_id -user_id $usr]      
        
        # Para cada anotacion de la comunidad
    foreach task $l_tasks {
                # 4. Crear las anotaciones a los alumnos
                #db_dml insert_pending_notes { *SQL* }
                cards::create_student_note -community_id $community_id -card_id $card_id -task_id $task
                set num_notes_created [expr $num_notes_created + 1]
        }
}

# Numero de fichas creadas y anotaciones puestas al dia
set num_cards_created [llength $l_students_no_card]
#set num_notes_created [llength $l_tasks]
#****************************************************


# Students Redirect to its student card
if {!$admin_p} {
        ad_returnredirect "student_card?user_id=$my_user_id&nav_sel=ficha"
        }

# Mostrar el listado de alumnos con ficha


if {$community_selected ne $parent_community_id} {
        db_multirow current_members select_sc_estudents_info { *SQL* }
} else { 
        db_multirow current_members select_students_info { *SQL* }
}
# faltaría arreglarlo aunque de momento no hace falta xq si estamos en un subgrupo no se nos muestran las fichas por defecto


# CSV   
if { $mode eq "csv" } {


set elements [list first_names [list label "#dotlrn.First_Name#"]]

        lappend elements last_name \
                [list label "#dotlrn.Last_Name#"]
                
        lappend elements email \
                [list label "#dotlrn.Email#"]

template::list::create \
    -name csv_members \
    -multirow current_members \
    -key user_id_id \
    -elements $elements \
        -selected_format csv -formats {
        csv { output csv }
    }
    template::list::write_output -name csv_members
}
        
