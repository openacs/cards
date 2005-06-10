ad_page_contract {
}  -query {  	
	user_id:integer,notnull
  {mode:optional ""}  
  {card_id:integer,optional ""}
  {note_id:integer,optional ""}
  {note_value:float,optional ""}
  {note_desc:optional ""}
  {note_type:integer,optional ""}
  {note_sel:integer,optional ""}
  {note_act:integer,optional ""}
  {note_act_yes:integer,optional ""}
  {mode_insert:optional ""}
  {mode_update:optional ""}
  {mode_cancel:optional ""}
  {mode_base:optional ""}
  {nav_sel:optional ""}
  {text_sel:optional ""}
  {comm_teacher:optional ""}
} -properties {
}

# previndre que la pàgina siga cridada fora d'una comunitat
if {[empty_string_p [dotlrn_community::get_community_id]]} {
    ad_returnredirect "[dotlrn::get_url]"
}

set bloc_sel ""
set is_edit 0
set tcl_precision 5
set error 0
set sel_edit_note 0
set is_edit 0
set msg_error ""
# açó no sé el que fa
set dotlrn_url [dotlrn::get_url]

# Declaració de variables a emprar
# Comunitat a la que estem y usuari que som
set community_id [dotlrn_community::get_community_id]
set my_user_id [ad_conn user_id]
# Si som administradors a la comunitat
set admin_p [dotlrn::user_can_admin_community_p -user_id $my_user_id -community_id $community_id]

# COSES QUE VENEN DE CARD.TCL
set return_url "[ns_conn url]?[ns_conn query]"
set subsite_url [subsite::get_element -element url]
acs_user::get -user_id $user_id -array user_info
set widthheight_param "width=64 height=64"
set export_vars [export_url_vars user_id]

# Açó no sé per a que és.
set referer [ns_conn url]

# L'hora del sistema
set datetime [clock_to_ansi [clock seconds]]


# modo EDIT --> Control de la edición de campos
if { $mode eq "edit2" } {
		set is_edit 2
	}

if { $mode eq "edit3" } {
		set is_edit 3
	}	

if { $mode eq "delete"} {
	db_dml delete_note { *SQL* } 
	set mode ""
	ad_returnredirect "./notes?card_id=$card_id&user_id=$user_id&nav_sel=$nav_sel&text_sel=$text_sel"
	}	
	
	
if {$mode_cancel ne ""} {
	set mode_update ""
	ad_returnredirect "./notes?card_id=$card_id&user_id=$user_id&nav_sel=$nav_sel&text_sel=$text_sel"
	}

# Modo UPDATE_2
if {$mode_update eq "mode_update2"} {
	 db_dml update_comm_teacher { *SQL* } 
	set mode_update ""	
	ad_returnredirect "./notes?card_id=$card_id&user_id=$user_id&nav_sel=$nav_sel"	
}

# Modo UPDATE_3
#note_datetime = :datetime,
if {$mode_update eq "mode_update3"} {
	 db_dml update_text_note { *SQL* } 
	set mode_update ""	
	ad_returnredirect "./notes?card_id=$card_id&user_id=$user_id&nav_sel=$nav_sel&text_sel=1"	
}


# Modo INSERT TEXT
if {$mode_insert eq "mode_insert"} {
db_0or1row get_st { *SQL* }

	 db_dml insert_text_note { *SQL* }
	set mode_insert ""	
	ad_returnredirect "./notes?card_id=$card_id&user_id=$user_id&nav_sel=$nav_sel&text_sel=1"	
}


#  DATOS PERSONALES

set existe_photo 1;
if ![db_0or1row get_item_id { *SQL* }] {
  set existe_photo 0;
}


set found_card [db_0or1row select_found_card { *SQL* }]

if {!$found_card} {
  db_dml insert_new_card { *SQL* }
  db_0or1row select_found_card { *SQL* }
# Añadir ANOTACIONES QUE NO TENGA
# select * from uv_card_subtype_note where ref_community_id = 1157056;
}

if {$card_id eq ""} {
	set card_id $id_card
}

set is_teacher [dotlrn::user_can_admin_community_p -user_id [ad_get_user_id] -community_id $community_id]
	
# FIN DATOS PERSONALES


# Obtenemos los parametros de configuración de la evaluacion de la asignatura
#db_1row view_notes "select * from uv_card_base_note where community_id = :community_id"
#set bn $base_note
set bn 100

# Comprovar permisos: Si l'usuari no administrador conectat no es el de la fitxa no li deixem vore-la.
#if {!$admin_p} { set link_type 1} else { set link_type 0}
# Si no som administradors res de res.
if {!$admin_p} {
			ad_return_error [lang::util::localize "#acs-subsite.Error#"] [lang::util::localize "#dotlrn.deniedpermission#"] 	
}

# Comprobacion de modos

#Creamos entrada en UV_CARD_BASE_TYPE si no existe para la comunidad
# set found_base [db_0or1row get_base "select * from uv_card_base_note where community_id = :community_id"]

if {$mode_update ne ""} {
	if {$note_act eq 1} {
		set note_actv 1	
	} else {
		if {$note_act_yes eq 1} {
			set note_actv 1
		} else {
			set note_actv 0	
		}
	}
		set note_value [expr $note_value * 1.00]
		db_dml update_card_note { *SQL* }		
		set mode_update ""
		ad_returnredirect "./notes?card_id=$card_id&user_id=$user_id&nav_sel=$nav_sel"
	}	
	
if {$mode eq "delete"} {
		db_dml delete_note { *SQL* }		
	}		
set sel_edit_note 0

if {$mode eq "edit"} {
	set sel_edit_note $note_sel
	set is_edit 1
	} 
	
# Obtenció de les dades del alumne (noms i cognoms)
db_1row alum_data { *SQL* } 

# Obtenció dels blocs d'avaluació de la comunitat sense els de text
db_multirow blocs_eval select_blocs_eval_sql { *SQL* }


# Obtenció dels blocs d'avaluació de la comunitat (TOTS)
set l_b [db_list get_bloc { *SQL* } ]

# Nº de blocs de la comunitat
set nbs [llength $l_b]

# Si no tenim blocs, mostrarem les dades personals
if {$nbs eq 0 } {
	set nav_sel "ficha"
}

# Seleccionem els blocs de text
db_multirow blocs_text select_blocs_text_sql { *SQL* }

# Mostrem les anotacions del bloc de text seleccionat
if {$text_sel eq 1} {
db_multirow notes_text text_notes_sql { *SQL* }
db_0or1row bloc_sel { *SQL* }
}
# Obtenció dels blocs d'avaluació de la comunitat amb la mitja
db_multirow blocs_eval1 blocs_eval1_sql { *SQL* }

db_multirow notes notes_sql { *SQL* }

# NUEVA CONSULTA
db_multirow notes1 notes_eval_sql { *SQL* }

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
	multirow foreach notes1 {	
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



