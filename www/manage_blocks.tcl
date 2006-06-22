ad_page_contract {
}  -query {  
  {mode:optional ""}
  {block_id:integer,optional ""}
  {block_type:integer,optional ""}
  {block_type_old:integer,optional ""}
  {block_name:optional ""}  
  {block_percent:integer,optional 0}  
  {block_rvalor:float,optional 0}    
  {order:optional percent}
  {order_dir:optional desc}  
  {alum_view:integer,optional 0} 
  {reuse_cards:integer,optional 0} 
} -properties {
}

# Declaració de variables a emprar
set error 0
set msg_error ""
set link_url ""
set block_sel_edit ""
set is_edit 0
set total 0
set total_p 0



# Community and big parent community
set community_selected [dotlrn_community::get_community_id]
set community_name [cards::get_community_pretty_name -community_id $community_selected]
set parent_community_id [cards::get_big_parent_community -community_id $community_selected]
set reuse_parent_cards [cards::get_community_parameter -community_id $community_selected -param "ReuseParentCards"]
set allow_view_grades [cards::get_community_parameter -community_id $community_selected -param "AllowGradeView"] 

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





##########     MODE  ALLOW STUDENTS VIEW     ##########
if {$mode == "allow"} {
        cards::update_cards_parameter -community_id $community_selected -param "AllowGradeView" -value $alum_view       
        set allow_view_grades [cards::get_community_parameter -community_id $community_selected -param "AllowGradeView"]
}

##########     MODE  REUSE PARENTs CARDS    ##########
if {$mode == "reuse"} {
        cards::update_cards_parameter -community_id $community_selected -param "ReuseParentCards" -value $reuse_cards   
        ad_returnredirect "./cards_list"

}

##########     MODE  CANCELAR --> No fa res, redireccio a la pagina anterior     ##########
if {$mode eq "cancel"} {
        set mode ""
        #ad_returnredirect "./manage_blocks?order=$order&order_dir=$order_dir"
}
#set msg_error "HEMOS INSERTADO"
#set link_url "./manage_blocks?mode="

##########     MODO  INSERTAR                                                  ##########
if {$mode eq "insert"} {
        # Comprobación nombre bloque ya existe
        set found_block [db_0or1row found_block_i { *SQL* }]
        if {($found_block eq 0) && ($block_name ne "") && ($block_name ne " ")} {
                if {($block_percent >= 0) && ($block_percent <= 100)} {
                        if {($block_rvalor >= 0) && ($block_rvalor <= 10)} {
                                db_dml insert_blocks { *SQL* } 
                                set mode ""
                                set block_name ""
                                set block_type 1
                                set block_percent 0
                                set block_rvalor 0                              
                                #ad_returnredirect "./manage_blocks?order=$order&order_dir=$order_dir"
                        } else {
                                set error 1
                set msg_error "Valor restricción no válido"
                                append cambia "document.fi.block_rvalor.value='" $block_rvalor "'"
                                set senyala "document.fi.block_rvalor.style.backgroundColor="
                        }
                } else {
                        set error 1
                        set msg_error "Porcentaje no válido"
                        append cambia "document.fi.block_percent.value='" $block_percent "'"
                        set senyala "document.fi.block_percent.style.backgroundColor="
                }        
        } else {
                set error 1
        set msg_error "Nombre de bloque ya existe o es nulo"
                append cambia "document.fi.block_name.value='" $block_name "'"
                set senyala "document.fi.block_name.style.backgroundColor="
        }

} 

##########     MODO  ACTUALIZAR                                            ##########
if {$mode eq "update"} {
        set found_block [db_0or1row found_block_u { *SQL* }]
        if {($block_name ne "") && ($found_block eq 0) } {                
                if {($block_percent >= 0) && ($block_percent <= 100)} {
                        if {($block_rvalor >= 0) && ($block_rvalor <= 10)} {
                                if {($block_type_old < $block_type) && ($block_type_old ==3 || $block_type ==3)} {
                                        set new_percent 0
                                        db_dml update_task_percent { *SQL* }
                                } else {
                                        if {($block_type_old > $block_type) && ($block_type_old ==3 || $block_type ==3)} {
                                        set new_percent -1
                                        db_dml update_task_percent { *SQL* }
                                        }
                                }
                db_dml update_block { *SQL* }
                                set mode ""
                                set block_name ""
                                set block_type 1
                                set block_percent 0
                                set block_rvalor 0
                                #ad_returnredirect "./manage_blocks?order=$order&order_dir=$order_dir"
                        } else {
                                set mode edit
                                set error 1
                                set msg_error "Valor de restricción no válido."
                                append cambia "document.fe.block_rvalor.value='" $block_rvalor "'"
                                set senyala "document.fe.block_rvalor.style.backgroundColor="
                        }
        } else {
                                set mode edit
                                set error 1
                                set msg_error "Porcentaje no válido."
                                append cambia "document.fe.block_percent.value='" $block_percent "'"
                                set senyala "document.fe.block_percent.style.backgroundColor="
                }       
        } else { 
                set mode edit
                set error 1
        set msg_error "Nombre de bloque ya existente o no válido."
                append cambia "document.fe.block_name.value='" $block_name "'"
                set senyala "document.fe.block_name.style.backgroundColor="
        }
} 

##########     MODO  BORRAR --> Borrado en cascada            ########## 
if {$mode eq "delete"} {
        set l_del_notes [db_list select_notes { *SQL* }]    
    foreach del_i $l_del_notes {
                # Borramos anotaciones de los alumnos de ese tipo base
        db_dml delete_note { *SQL* }               
    }
        # Borramos las anotaciones de la comunidad de ese tipo base
        db_dml delete_block_tasks { *SQL* }               
        # Borramos el bloque básico
        db_dml delete_block  { *SQL* }
        set mode ""
}               

##########     MODO  EDITAR --> Modificar bloques ya creados    ##########
if {$mode eq "edit"} {
        set block_sel_edit $block_id
        set is_edit 1
        #db_1row t_sel { *SQL* }
        #set sel_edit_type $type
}


# Obtenim la llista de blocs de la comunitat
db_multirow block select_blocks { *SQL* } 
db_1row total_percent { *SQL* } 
if {$total_p > 0} {
        set total $total_p 
} else {
        set total 0
}


