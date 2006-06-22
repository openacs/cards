ad_page_contract {
}  -query { 
  {note_sel:optional ""}
  {note_id:optional ""}
  {note_value:float,optional ""}
  {note_desc:optional ""}
  {note_active:optional ""}
  {mode:optional ""}  
  {mode_insert:optional ""}
  {mode_update:optional ""}
  {mode_cancel:optional ""}
  {mode_base:optional ""} 
} -properties {
}
set tcl_precision 5
set error 0
set sel_edit_note 0
set is_edit 0
set msg_error ""
# açó no sé el que fa
set dotlrn_url [dotlrn::get_url]
# Comunitat a la que estem y usuari que som  # Si som administradors a la comunitat
set community_id [dotlrn_community::get_community_id]
set my_user_id [ad_conn user_id]
set admin_p [dotlrn::user_can_admin_community_p -user_id $my_user_id -community_id $community_id]
# Açó no sé per a que és.
set referer [ns_conn url]
# L'hora del sistema
set datetime [clock_to_ansi [clock seconds]]
# Comprovar permisos: Si l'usuari no administrador conectat no es el de la fitxa no li deixem vore-la.
#if {!$admin_p} { set link_type 1} else { set link_type 0}# Si no som administradors res de res.
if {!$admin_p} {
			ad_return_error [lang::util::localize "#acs-subsite.Error#"] [lang::util::localize "#dotlrn.deniedpermission#"] 	
}

# Buscar els alumnes de la comunitat (Apellidos, Nombre, User_id, Id_card) y la anotacio
db_multirow llista alum_sql { *SQL* }

if {$mode eq "edit"} {
	set is_edit $note_id
} else {
	set is_edit 0
}

# Comprobacion de modos
if {$mode_cancel ne ""} {
	set mode_update ""
	ad_returnredirect "./eval_note?note_sel=$note_sel"
	}

if {$mode_update ne ""} {
		db_dml update_card_note { *SQL* }		
		set mode_update ""
		ad_returnredirect "./eval_note?note_sel=$note_sel"

}
	
# Obtenemos si la anotacion permite activacion
db_1row act_note { *SQL* }

set act_note $allow_act	
	
# Nombre de anotación seleccionado
db_1row sel_note { *SQL* }

set sel_note $name_subtype

