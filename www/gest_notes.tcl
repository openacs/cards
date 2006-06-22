ad_page_contract {
}  -query {  
  {mode:optional ""}
  {asig_id:integer,optional ""}
  {asig_num:integer,optional ""}
  {asig_type:integer,optional ""}
  {asig_alias:optional ""}  
  {asig_percent:integer,optional ""}  
  {asig_sel:integer,optional ""}
  {nav_sel:optional ""}  
  {mode_insert:optional ""}
  {mode_update:optional ""}
  {mode_cancel:optional ""}
  {mode_base:optional ""}  
} -properties {
}
set tipo 0
set error 0
set msg_error ""
set sel_edit_asig 0
set sel_edit_type 0
set is_edit 0
# açó no sé el que fa
set dotlrn_url [dotlrn::get_url]

# Declaració de variables a emprar
# Comunitat a la que estem y usuari que som
set community_id [dotlrn_community::get_community_id]
set my_user_id [ad_conn user_id]
# Si som administradors a la comunitat
set admin_p [dotlrn::user_can_admin_community_p -user_id $my_user_id -community_id $community_id]

# Açó no sé per a que és.
set referer [ns_conn url]

# Comprovar permisos: Si l'usuari no administrador conectat no es el de la fitxa no li deixem vore-la.
#if {!$admin_p} { set link_type 1} else { set link_type 0}
# Si no som administradors res de res.
if {!$admin_p} {
			ad_return_error [lang::util::localize "#acs-subsite.Error#"] [lang::util::localize "#dotlrn.deniedpermission#"] 	
}

db_0or1row tipo { *SQL* }


# Comprobacion de modos
if {$mode_cancel ne ""} {
	set mode_update ""
	ad_returnredirect "./gest_notes"
	}

if {$mode_insert ne ""} {
	# Comprobamos nombre no repetido
	set alias_repe [db_0or1row alias_sql { *SQL* }]
	
	
	
	if {$asig_alias ne "" && $alias_repe ne 1} {

# Obtenemos lista de los alumnos de esa comunidad
	set l_alum [db_list list_alum { *SQL* } ]
	set l_alum_size [llength $l_alum]		
	# Creación de las CARDS que no existan
	for {set i 0} { $i < $l_alum_size} {incr i 1} { 
		set alum_id [lindex $l_alum $i]
		set found_card [db_0or1row select_found_card { *SQL* }]
		if {!$found_card} {
			db_dml insert_new_card { *SQL* }  
			
		# AçÍ TENIM QUE AFEGIR LES ANOTACIONS si n'hi han a la communitat
		#select * from uv_card_subtype_note where ref_community_id = 1157056;
		}
		
	}
		
	# Creación subtipo
	db_dml insert_subtype { *SQL* }
		
	# Obtencion "id subtipo"
	set tipo_act [lindex [db_list get_subtype_id { *SQL* } ] 0]
	
	# Creación anotaciones de ese tipo para todos los alumnos
	for {set j 0} { $j < [llength $l_alum]} {incr j 1} { 
		set alum_id [lindex $l_alum $j]
		set card_id [db_list alum_idcard { *SQL*}]	
		db_dml insert_note { *SQL* }  		
	}		
		set mode_insert ""
		ad_returnredirect "./gest_notes?nav_sel=$nav_sel"

	}	else {
			set error 1
			set msg_error "Nombre de anotación no valido o ya existe"
	}
}

if {$mode_update ne ""} {

	# Comprobamos nombre no repetido
	set alias_repe [db_0or1row alias_sql { *SQL* }]
	
	#alias_sql "select name_subtype from uv_card_subtype_note where name_subtype = :asig_alias and id_subtype <> :asig_id and ref_community_id = :community_id and ref_xcent = :asig_type"

	if {$asig_alias ne "" && $alias_repe ne 1} {

		db_dml update_subtype { *SQL* }		
		set mode_update ""
		ad_returnredirect "./gest_notes?nav_sel=$nav_sel"

	}	else {
			set error 1
			set msg_error "Nombre de anotación no valido o ya existe"
	}
		
	}	
	
if {$mode eq "delete"} {
		# Borramos la anotación de todos los alumnos 
		db_dml delete_note { *SQL* }		
		# Borramos la anotación de la comunidad
		db_dml delete_subtype { *SQL* }
	}		
	
# Fem comprovacions per vore si n'hi han assignacions a la communitat i les seleccionem si cal
# found_asig ens controla si n'hi han files o no, next_asig es la següent
set list_asig [db_list asig_list { *SQL* }]

set num_asig [llength $list_asig]
if {$num_asig ne 0} {
    set found_asig 1
	db_multirow asig asig_sql { *SQL* }
# and id_basetype <> 3 
	set next_asig [expr $num_asig + 1]
} else {
	set found_asig 0
	set next_asig "*"
}

set is_xcent [lindex [db_list num_xcent { *SQL* }] 0]
if {$is_xcent eq 0}  {
	set error 1
	set msg_error "Para crear anotaciones debes crear antes los bloques básicos"
	ad_returnredirect "./cards"
	
}
# Seleccionem la llista de tipus base
db_multirow types types_sql { *SQL* }


# Obtenció dels blocs d'avaluació de la comunitat
db_multirow blocs_eval blocs_eval_sql { *SQL* }

if {$mode eq "edit"} {
		set sel_edit_asig $asig_num
		set is_edit 1
	} 
