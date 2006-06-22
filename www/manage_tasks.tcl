ad_page_contract {
}  -query {  
  {mode:optional ""}
  {task_id:integer,optional ""}  
  {task_block:integer,optional ""}  
  {task_name:optional ""}  
  {task_percent:float,optional 0} 
  {task_max_grade:float,optional 10.00}
  {nav_sel:optional ""}    
  {order:optional task_name}
  {order_dir:optional asc}  
} -properties {
}

# Declaració de variables a emprar
set error 0
set msg_error ""
set link_url ""
set task_sel_edit ""
set is_edit 0

# Comunitat a la que estem. Check if we are in a subcommunity. In this case, we use the big parent community.
# but we only show the user cards that are in subgroup
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

# Usuari que som y url a la que estem
set my_user_id [ad_conn user_id]
set referer [ns_conn url]

# Si no som administradors  [admin_p = 0] --> error: permis denegat 
set admin_p [dotlrn::user_can_admin_community_p -user_id $my_user_id -community_id $community_id]
if {!$admin_p} {
                        ad_return_error [lang::util::localize "#acs-subsite.Error#"] [lang::util::localize "#dotlrn.deniedpermission#"]         
}


##########     MODE  CANCELAR --> No fa res, redireccio a la pagina anterior     ##########
if {$mode eq "cancel"} {
        set mode ""
    #ad_returnredirect "./manage_tasks?order=$order&order_dir=$order_dir"
}

##########     MODO  INSERTAR                                                  ##########
if {$mode eq "insert"} {
        # Comprobación nombre bloque ya existe
        set found_task [db_0or1row found_task_i { *SQL* }]
        if {($found_task eq 0) && ($task_name ne "") && ($task_name ne " ")} {
                if {($task_percent >= 0) && ($task_percent <= 100)} {
                        if {($task_max_grade >= 0)} {
                                # Obtener task_type
                                set task_type [cards::get_task_type -task_block $task_block]    
                                if {$task_type eq 3} {
                                        # Comprobar porcentajes totales
                                        set xcent 0
                                } else {
                                        set task_percent -1
                                }
                                db_dml insert_task { *SQL* } 
                                set l_task [cards::get_community_tasks -community_id $community_id]
                                set id_task [lindex $l_task [expr [llength $l_task] - 1]]
                                set l_cards [cards::get_all_community_cards -community_id $community_id]
                                foreach cid $l_cards {
                                        cards::create_student_note -community_id $community_id -card_id $cid -task_id $id_task
                                }                               
                                set mode ""
                                set task_max_grade 10
                                #ad_returnredirect "./manage_tasks?order=$order&order_dir=$order_dir"
                        } else {
                                set error 1
                set msg_error "Nota máxima no válida."
                                append cambia "document.fi.task_max_grade.value='" $task_max_grade "'"
                                set senyala "document.fi.task_max_grade.style.backgroundColor="
                        }
                } else {
                        set error 1
                        set msg_error "Porcentaje no válido"
                        append cambia "document.fi.task_percent.value='" $task_percent "'"
                        set senyala "document.fi.task_percent.style.backgroundColor="
                }        
        } else {
                set error 1
        set msg_error "Nombre de bloque ya existe o es nulo"
                append cambia "document.fi.task_name.value='" $task_name "'"
                set senyala "document.fi.task_name.style.backgroundColor="
        }

} 

##########     MODO  ACTUALIZAR            ##########
if {$mode eq "update"} {
        # Comprobación nombre bloque ya existe
        set found_task [db_0or1row found_task_u { *SQL* }]
        if {($found_task eq 0) && ($task_name ne "") && ($task_name ne " ")} {
                if {($task_percent >= 0) && ($task_percent <= 100)} {
                        if {($task_max_grade >= 0)} {
                                db_dml update_task { *SQL* } 
                                set mode ""
                                set task_max_grade 10
                                #ad_returnredirect "./manage_tasks?order=$order&order_dir=$order_dir"
                        } else {
                                set error 1
                set msg_error "Nota máxima no válida."
                                append cambia "document.fe.task_max_grade.value='" $task_max_grade "'"
                                set senyala "document.fe.task_max_grade.style.backgroundColor="
                        }
                } else {
                        set error 1
                        set msg_error "Porcentaje no válido"
                        append cambia "document.fe.task_percent.value='" $task_percent "'"
                        set senyala "document.fe.task_percent.style.backgroundColor="
                }        
        } else {
                set error 1
        set msg_error "Nombre de bloque ya existe o es nulo"
                append cambia "document.fe.task_name.value='" $task_name "'"
                set senyala "document.fe.task_name.style.backgroundColor="
        }
} 

##########     MODO  BORRAR --> Borrado en cascada            ########## 
if {$mode eq "delete"} {
        # Borramos las anotaciones de los alumnos para esa tarea
        db_dml delete_notes { *SQL* }               
        # Borramos la tarea
        db_dml delete_task  { *SQL* }
        set mode ""
}               

##########     MODO  EDITAR --> Modificar bloques ya creados    ##########
if {$mode eq "edit"} {
        set task_sel_edit $task_id
        set is_edit 1
} else {
        db_multirow block2 select_blocks { *SQL* } 
        multirow foreach block2 {
                set task_name_sel ""
                set task_percent_sel $percent_id
                set task_type_sel $type
                break
        }
}


# Obtenim la llista de blocs de la comunitat
db_multirow task select_tasks { *SQL* } 
db_multirow block select_blocks { *SQL* }

