ad_page_contract {
}  -query {  
  {mode:optional ""}
  {asig_id:integer,optional ""}
  {asig_num:integer,optional ""}
  {asig_type:integer,optional ""}
  {asig_alias:optional ""}  
  {asig_percent:integer,optional ""}  
  {asig_sel:integer,optional ""}  
  {asig_rvalor:float,optional 0}    
  {asig_np:integer,optional 0}    
  {note_base:integer,optional ""}
  {np_type:integer,optional 0}
  {alum_view:integer,optional 0}
  {mode_insert:optional ""}
  {mode_update:optional ""}
  {mode_cancel:optional ""}
  {mode_base:optional ""}  
} -properties {
}

# Declaració de variables a emprar
set error 0
set msg_error ""
set sel_edit_asig 0
set sel_edit_type 0
set is_edit 0
set asig_act 'f'
set l_bloques [list]
set cc 0
set num_asig 1
# açó no sé el que fa
set dotlrn_url [dotlrn::get_url]

# Comunitat a la que estem y usuari que som
set community_id [dotlrn_community::get_community_id]
set my_user_id [ad_conn user_id]
# Si som administradors a la comunitat
set admin_p [dotlrn::user_can_admin_community_p -user_id $my_user_id -community_id $community_id]

# Açó no sé per a que és.
set referer [ns_conn url]

# Comprovar permisos: Si l'usuari no administrador conectat no es el de la fitxa no li deixem vore-la.
if {!$admin_p} {
                        ad_return_error [lang::util::localize "#acs-subsite.Error#"] [lang::util::localize "#dotlrn.deniedpermission#"]         
}

# MODE BASE --> Aquí van opciones de configuración de la comunidad:
# Alum View --> Permiso a los alumnos para poder ver sus notas
# BASE NOTE --> Descartado: ASIGNACIÓN EN % y NOTAS EN BASE 10
# NP --> Pasado a tabla XCENT, por defecto a false
if {$mode_base ne ""} {
                db_dml update_base_note { *SQL* }               
                set mode_base ""
}

# Comprobacion de modos
#Creamos entrada en UV_CARD_BASE_NOTE si no existe para la comunidad
set found_base [db_0or1row get_base "select * from uv_card_base_note where community_id = :community_id"]
if {!$found_base} {
        db_dml insert_base_note { *SQL* }
        set base 100
        set np_type 0
        set alum_view 0
} else {
        set base $base_note
        set np_type 0
        set alum_view $alum_view
}

##########     MODO  CANCELAR --> No hace nada, redirección     ##########
if {$mode_cancel ne ""} {
        set mode_update ""
        ad_returnredirect "./gest_eval"
        }

##########     MODO  INSERTAR                                                  ##########
if {$mode_insert ne ""} {
        # Comprobación nombre bloque ya existe
        set repe [db_0or1row nom_bloc { *SQL* }]
        # Comprobación nombre bloque no nulo
        if {($asig_percent > 100 ) || ($asig_percent < 0) || ($asig_percent eq "") } {  
                set error 1
                set msg_error "Porcentaje no valido."
                set asig_percent 0
        }
        if {($asig_alias ne "") && ($repe ne 1)} {              
                # Comprobación tipo básico
                if {$asig_type eq 2} {
                        set asig_act 1
                } else {
                        if {$asig_type eq 3} {
                                set asig_act 0
                                set asig_percent 0
                        } else {
                                set asig_act 0
                        }
                }
                if {$asig_rvalor ne ""} {
                        db_dml insert_xcent { *SQL* }
                
                        if {$asig_type eq 3} {
                        db_0or1row num_xcent { *SQL* }
                        
                        db_dml insert_subtype { *SQL* }               
                        }               
                set mode_insert ""
                ad_returnredirect "./gest_eval"
                } else {
                        set error 1
                        set msg_error "Valor restricción no válido"
                }               
        }       else {
                        set error 1
                        set msg_error "Nombre de bloque ya existe o es nulo"
                }
        } 
##########     MODO  ACTUALIZAR                                            ##########
if {$mode_update ne ""} {
        if {$asig_alias ne ""} {                
                if {$asig_type eq 2} {
                        set asig_act 1
                } else {
                        if {$asig_type eq 3} {
                                set asig_act 0
                                set asig_percent 0
                        } else {
                                set asig_act 0
                        }
                }               
                if {$asig_rvalor ne ""} {
                db_dml update_xcent { *SQL* }               
                set mode_update ""
                ad_returnredirect "./gest_eval"
                } else {
                        set error 1
                        set msg_error "Valor restricción no válido"             
                }
        }       else {
                        set error 1
                        set msg_error "Debes introducir un nombre de alias"
                }
        } 
        
##########     MODO  BORRAR --> Borrado en cascada            ########## [OK]
if {$mode eq "delete"} {
        set l_del_notes [db_list del_notes { *SQL* }]    
        foreach del_i $l_del_notes {
        # Borramos anotaciones de los alumnos de ese tipo base
                db_dml delete_card_note { *SQL* }               
        }
        # Borramos las anotaciones de la comunidad de ese tipo base
                db_dml delete_subtype  { *SQL* }               
        # Borramos el bloque básico
                db_dml delete_xcent  { *SQL* }               
        }               
        
# SELECCIÓ DELS TIPUS BASE Y BLOCS DE LA COMUNITAT --> Caldrà  reduir el *
db_multirow types types_sql { *SQL* } 
db_multirow blocs blocs_sql { *SQL* } 
db_multirow asig asig_sql { *SQL* } 

        
# Fem comprovacions per vore si n'hi han assignacions a la communitat i les seleccionem si cal
# found_asig ens controla si n'hi han files o no, next_asig es la següent
set list_asig [db_list asig_list { *SQL* }]

# set num_asig [llength $list_asig]

if {$num_asig ne 0} {
    set found_asig 1
} else {
        set found_asig 0
}



if {$mode eq "edit"} {
                set sel_edit_asig $asig_num
                set is_edit 1
                db_1row t_sel { *SQL* }
                set sel_edit_type $ref_basetype
        } 

# Obtenemos el porcentaje asignado 
db_0or1row total_xc "select sum(uv_card_xcent_note.xcent) as total from uv_card_xcent_note where uv_card_xcent_note.ref_community_id = :community_id"
if {$total eq ""} {
        set total 0
}
