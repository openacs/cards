ad_page_contract {
}  -query {  
  {mode:optional ""}  
  {mode_insert:optional ""}
  {mode_update:optional ""}
  {mode_cancel:optional ""}
  {mode_base:optional ""}  
} -properties {
}
#ns_log Notice "0000"
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
# Nota base de la asignatura
#db_1row nbase "select base_note from uv_card_base_note where community_id = :community_id"
#set bn $base_note
set bn 100

# PARA BORRAR SI FUNCIONA EL XQL
# Buscar els alumnes de la comunitat (Apellidos, Nombre, User_id, Id_card)
#db_multirow alum alum_sql "select acs_users_all.user_id, id_card, last_name, first_names from acs_users_all, dotlrn_member_rels_approved inner join uv_card on (ref_user_id = user_id) where dotlrn_member_rels_approved.community_id = :community_id and dotlrn_member_rels_approved.user_id = acs_users_all.user_id and (role='student' or role='member') and uv_card.ref_community_id = community_id order by last_name, first_names asc"
#Buscar els blocs d'avaluació de la comunitat
#db_multirow bloques blocs_eval_sql "select id_xcent, xcent, name_xcent, rvalor from uv_card_xcent_note where ref_community_id = :community_id order by xcent desc, name_xcent asc"

# NUEVA CONSULTA
#db_multirow notes notes_eval_sql "select ref_id_card, ref_xcent, name_xcent, xcent, avg(value_n)*xcent*1.00/100.00 as mitja_p, rvalor, np from uv_card_notes n, uv_card_subtype_note sn, uv_card_xcent_note xn where sn.ref_xcent = xn.id_xcent and sn.ref_community_id = :community_id and xn.ref_community_id = :community_id and n.ref_subtype = sn.id_subtype and is_active = 'true' and xcent<>0 group by  ref_xcent,name_xcent,xcent,ref_id_card, rvalor,np order by ref_id_card asc, xcent desc, ref_xcent asc;"

# Buscar els alumnes de la comunitat (Apellidos, Nombre, User_id, Id_card)
db_multirow alum alum_sql {}
#Buscar els blocs d'avaluació de la comunitat
db_multirow bloques blocs_eval_sql {}
# NUEVA CONSULTA
db_multirow notes notes_eval_sql {}


#CALCULO NOTAS Y ESTADISTICAS
set aprobados 0
set suspensos 0
set nnp 0
set restrict  0 

#Obtenemos el numero de bloques con NP activo y lo guardamos en np_num
#db_1row npn_sql "select count(np) as npn from uv_card_xcent_note where ref_community_id= :community_id and np<>'f'"
db_1row npn_sql {}

set np_num $npn
# Listado de notas finales calculadas
set l_notas [list]

#ns_log Notice "11111"

multirow foreach alum {
        set restrict "NO"
        set nota_media 0
        set aux_m 0
        set aux_r 0
        set np_count 0
        set r_txt "(*)" 
                
        # Recorremos todas las notas del usuario actual
        multirow foreach notes {        
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
                set nnp [expr $nnp + 1]
        } else {
                if {$restrict eq "SI" && $nota_media > 5} {
                        lappend l_notas -1
                        set suspensos [expr $suspensos + 1]
                } else {
                        lappend l_notas $nota_media
                        if {$nota_media >= 5} {
                                set aprobados [expr $aprobados + 1]
                        } else {
                                set suspensos [expr $suspensos + 1]
                        }

                }       
        }
}
#ns_log Notice "2222"

