ad_page_contract {
}  -query {
    {parent_user_role:multiple,array,optional}
    {order "last_name"}
    {order_direction "asc"}
	
} -properties {
    users:multirow
    n_parent_users:onevalue
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
set widthheight_param "width=64 height=64"
set subsite_url [subsite::get_element -element url]


# Açó no sé per a que és.
set referer [ns_conn url]

# L'hora del sistema
set datetime [clock_to_ansi [clock seconds]]

#Obtenemos lista de alumnos 
#db_multirow alum alum_sql "select acs_users_all.user_id as user_id, id_card, last_name, first_names from acs_users_all, dotlrn_member_rels_approved inner join uv_card on (ref_user_id = user_id) where dotlrn_member_rels_approved.community_id = :community_id and dotlrn_member_rels_approved.user_id = acs_users_all.user_id and (role='student' or role='member') and uv_card.ref_community_id = community_id order by last_name, first_names asc"
db_multirow alum alum_sql {} 

# Comprovar permisos: Si l'usuari no administrador conectat no es el de la fitxa no li deixem vore-la.
#if {!$admin_p} { set link_type 1} else { set link_type 0}
# Si no som administradors res de res.
if {!$admin_p} {
			ad_return_error [lang::util::localize "#acs-subsite.Error#"] [lang::util::localize "#dotlrn.deniedpermission#"] 	
}

	
