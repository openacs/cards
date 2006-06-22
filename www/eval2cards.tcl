# /cards/eval2cards

ad_page_contract {    
        Paco Soler Lahuerta
        fransola@uv.es
} -query {
    {mode:optional ""}
    {e_task:optional ""}
    {c_task:optional ""}

}


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



if {$reuse_parent_cards == 1} {
        ad_returnredirect "cards_error?num_e=3"
} else {


# Obtenemos  comunity_id
#set community_id [dotlrn_community::get_community_id]
#set community_name [cards::get_community_pretty_name -community_id $community_id]
# Obtenemos pakage_id del paquete evaluation para la comunidad
set ev_ctrl [db_0or1row get_evaluation_pid {* SQL *}]




# Si no hay paquete volvemos de donde veníamos
if {$ev_ctrl == 0} { 
    ad_returnredirect "cards_error?num_e=1"
} else {

        if {$mode == "update"} {

        # Obtenemos el perfect score de la tarea de evaluation seleccionada
        db_1row get_perfect_score {* SQL *}
        # Obtenemos el max_grade de la tarea de card seleccionada
        db_1row get_max_grade {* SQL *}
        
        
        
        # Seleccionar las notas de las tareas de cada alumno en evaluation
        db_multirow task_notes get_task_notes {* SQL *}
        set cont 0
        # actualizarla con las de evaluation
        multirow foreach task_notes {
                if {[empty_string_p $grade]} {
                        set grade 0.00
                } else {                                        
                
                        if {$perfect_score > 0} {
                                set grade [expr $grade * $max_grade / 100]
                        }
                
                        # Si el party id es un grupo buscamos los usuarios
                        set is_group [db_0or1row get_is_group "select group_id from evaluation_task_groups where group_id = :party_id"]
                
                        # Si no es un grupo
                        if {$is_group == 0} {           
                                db_1row get_card_id  {* SQL *}
                                db_dml update_c_task  { *SQL* }
                                set cont [expr $cont + 1]
                                set mode ""
                        # Si es un grupo
                        } else {
                                db_multirow group_members get_group_members {* SQL *}
                                multirow foreach group_members {
                                        db_1row get_card_id  {* SQL *}
                                        db_dml update_c_task  { *SQL* }
                                        set cont [expr $cont + 1]
                                        set mode ""                     
                                }
                        }
                }
        }
        # redirigir a la pagina de notas para que la penya compruebe lo que hay.
        if {$cont > 0} {
                ad_returnredirect "grade_task?task_id=$c_task&mode=update&mode2=eval"
        } else {
                ad_returnredirect "cards_error?num_e=2"
        }
        
        
  } 
        # obtenemos las tareas por asignaciones del evaluation de la  comunidad
        db_multirow taskXgrade get_taskXgrades {* SQL *}
  
        # obtenemos las tareas por bloques de las cards de la comunidad
        db_multirow taskXbloc get_taskXbloc {* SQL *}
        
 }
}

