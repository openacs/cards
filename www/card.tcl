ad_page_contract {
} -query {
  user_id:integer
  {card_id:integer,optional ""}
  {mode:optional ""}  
  {mode_update:optional ""}
  {mode_cancel:optional ""}
  {nav_sel:optional ""}  
  {address:optional ""}
  {phone1:optional ""}  
  {phone2:optional ""}
  {comm_student:optional ""}
} -properties {
}

# prevent this page from being called when not in a community
if {[empty_string_p [dotlrn_community::get_community_id]]} {
    ad_returnredirect "[dotlrn::get_url]"
}

set community_id [dotlrn_community::get_community_id]
set admin_p [dotlrn::user_can_admin_community_p -user_id [ad_get_user_id] -community_id $community_id]
set return_url "[ns_conn url]?[ns_conn query]"
set subsite_url [subsite::get_element -element url]
acs_user::get -user_id $user_id -array user_info
set widthheight_param "width=64 height=64"
set export_vars [export_url_vars user_id]
set error 0
set msg_error 0
set is_edit 0

#CHECK PERMISSIONS
if {!$admin_p} {
  if {$user_id != [ad_get_user_id]} {
    ad_return_error [lang::util::localize "#acs-subsite.Error#"] [lang::util::localize "#dotlrn.deniedpermission#"]
  }
}


# modo EDIT --> Control de la edición de campos
if {$mode eq "edit1"} {
        set is_edit 1
} else {
        if { $mode eq "edit2" } {
                set is_edit 2
        }
}

# Modo CANCELAR --> No hace nada, redirección
if {$mode_cancel ne ""} {
        set mode_update ""
                ad_returnredirect "card?user_id=$user_id&nav_sel=ficha"
}
        
# Modo UPDATE_1
if {$mode_update eq "mode_update1"} {
  db_dml update_personal_info { *SQL* }
  set mode_update ""
  ad_returnredirect "card?user_id=$user_id&nav_sel=ficha"
}

# Modo UPDATE_2
if {$mode_update eq "mode_update2"} {
  db_dml update_student_comment { *SQL* }
  set mode_update ""
  ad_returnredirect "card?user_id=$user_id&nav_sel=ficha"      
}

set existe_photo 1;
if ![db_0or1row get_item_id { *SQL* } ] {
  set existe_photo 0;
}

# Comprobamos que el alumno tiene CARD
# En caso contrario la creamos
set found_card [db_0or1row select_found_card { *SQL* }]
if {!$found_card} {
  db_dml insert_add_student_card { *SQL* }
  db_0or1row select_found_card { *SQL* }
}

set is_teacher [dotlrn::user_can_admin_community_p -user_id [ad_get_user_id] -community_id $community_id]


# Obtenemos los parametros de configuración de la evaluacion de la asignatura
db_1row view_notes { *SQL* }

set bn $base_note

db_multirow blocs_eval blocs_eval_sql { *SQL* }
db_multirow blocs_eval1 blocs_eval1_sql { *SQL* }
db_multirow notes notes_sql { *SQL* }
# NUEVA CONSULTA
db_multirow notes11 notes_eval_sql { *SQL* }
        
        
# CALCULO NOTA FINAL
set nota_m 0
set final_note 0
set np_count 0
set restrict  0 
#Obtenemos el numero de bloques con NP activo y lo guardamos en np_num
db_1row npn_sql { *SQL* }
set np_num $npn
        
# Recorremos todas las notas del usuario actual
set restrict "NO"
        set nota_media 0
        set aux_m 0
        set aux_r 0
        set np_count 0
        set r_txt "(*)" 
       
        # Recorremos todas las notas del usuario actual
        multirow foreach notes11 {      
                if {$ref_id_card eq $id_card} {
                        set nota_media [expr $nota_media + $mitja_p]
                        set rval [expr $rvalor * $xcent * 1.00  / 100]                                          
                        # Control de restricción. Si se la salta activamos restrict
                        if {($mitja_p < $rval) && ($mitja_p ne 0)} {
                                set restrict "SI"
                        }
                        # Control de NP. Si esta activo y media es cero incrementamos 1 el contador de np's
                        if {($np eq "t") && ($mitja_p eq 0)} {
                                set np_count [expr $np_count + 1]
                        }       
                }
        }
        
        # Control de NP, Restriccion y estadisticas
        if {($np_count eq $np_num) && ($np_num ne 0)} {
                lappend l_notas "NP"
        } else {
                if {$restrict eq "SI" && $nota_media > 5} {
                        lappend l_notas -1
                } else {
                        lappend l_notas $nota_media
                }       
        }       