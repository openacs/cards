ad_page_contract {
}  -query {
    {parent_user_role:multiple,array,optional}
    {order "last_name"}
    {order_direction "asc"}
} -properties {
    users:multirow
    n_parent_users:onevalue
}

set dotlrn_url [dotlrn::get_url]
# use my_user_id here so we don't confuse with user_id from the query
set my_user_id [ad_conn user_id]

set show_drop_button_p [parameter::get_from_package_key \
                              -package_key dotlrn-portlet \
                              -parameter AllowMembersDropGroups]

set community_id [dotlrn_community::get_community_id]
set referer [ns_conn url]
dotlrn::require_user_read_private_data -user_id $my_user_id -object_id $community_id

set site_wide_admin_p [permission::permission_p \
    -object_id [acs_magic_object security_context_root] \
    -privilege admin \
]

if {!$site_wide_admin_p} {
    set admin_p [dotlrn::user_can_admin_community_p -user_id $my_user_id -community_id $community_id]
} else {
    set admin_p 1
}

if {!$admin_p} {
	ad_returnredirect "card?user_id=$my_user_id&nav_sel=ficha"
	}

if {![exists_and_not_null referer]} {
    if {[string equal $admin_p t] == 1} {
        set referer "one-community-admin"
    } else {
        set referer "one-community"
    }
}

# Used in I18N message lookups in adp
set parent_community_name [dotlrn_community::get_parent_name -community_id $community_id]
set community_name [dotlrn_community::get_community_name $community_id]

if {[string compare $order_direction "asc"]==0} {
    set order_html "<img src=\"/resources/dotlrn/down.gif\" height=15 width=15>"
    set opposite_order_direction "desc"
} else {
    set order_html "<img src=\"/resources/dotlrn/up.gif\" height=15 width=15>"
    set opposite_order_direction "asc"
}

# Variables that will be used if the column
# is not selected.

set first_names_order_html ""
set last_name_order_html ""
set email_order_html ""

set first_names_order_direction $order_direction
set last_name_order_direction $order_direction
set email_order_direction $order_direction

# Special case for the selected column.
switch $order {
    "first_names" {
        set first_names_order_html $order_html
        set first_names_order_direction $opposite_order_direction
    }
    "last_name"  {
        set last_name_order_html $order_html
        set last_name_order_direction $opposite_order_direction
    }
    "email"  {
        set email_order_html $order_html
        set email_order_direction $opposite_order_direction
    }
}

set bio_attribute_id [db_string bio_attribute_id { *SQL* }]

# vars to carry over (from previous script)
# Do a special clause for role!

# The note in the members-chunk-table.xql indicated that
# it would be very hard to make sorting work with ad_table
# and sorting by columns functionality was incomplete.  After 
# struggling with ad_table for a while, I went to the
# OpenACS IRC and asked some questions.  The response
# basically was that ad_table needs a refactoring.
# Therefore, I (teadams@alum.mit.edu) decided to 
# simplify and use db_multirow and code my own column
# sorting.  

#****************************************************
#OPCIONES DE MANTENIMIENTO
#****************************************************
# Crear opciones comunidad
#Creamos entrada en UV_CARD_BASE_NOTE si no existe para la comunidad
#set found_base [db_0or1row get_base "select * from uv_card_base_note where community_id = :community_id"]
set found_base 1
set found_base [db_0or1row get_base {}]

if {$found_base eq 0} {
  db_dml insert_base_note {}
}

# BAJA ALUMNOS: Borrar anotaciones y fichas que ya no sirven
# 1. Contamos el nº de alumnos / miembros a borrar
db_0or1row alum_del { *SQL* }
if {$num_alum_del > 0} {
	# 2. Borramos alumnos 
	db_dml delete_card_notes { *sQL*}
	# 3. Borrar fichas 		
	db_dml delete_cards { *SQL* }		
}

########################################################
# PONER AL DIA NUEVOS USUARIOS
# 1. seleccionar usuarios sin card para la comunidad
db_multirow user_no_card user_no_card_sql { *SQL* } 

# 2. Seleccionar anotaciones de la comunidad
db_multirow community_notes community_notes_sql { *SQL* }

# 3. Crear las CARDS a los usuarios sin card
multirow foreach user_no_card {
	# creamos la card
    db_dml insert_add_new_card { *SQL* }
	# Obtenemos su card_id en esa comunidad
    db_1row card_user_id { *SQL* }
	# Para cada anotacion de la comunidad
    multirow foreach community_notes {
		# 4. Crear las anotaciones a los alumnos
		db_dml insert_pending_notes { *SQL* }
	}
}

set order_by "$order $order_direction"

db_multirow -extend { community_member_url } current_members select_current_members {} {
    set community_member_url [acs_community_member_url -user_id $user_id]
}

db_multirow pending_users select_pending_users { *SQL* } {
    set role [dotlrn_community::get_role_pretty_name -community_id $community_id -rel_type $rel_type]
}

if {!$admin_p} {
	ad_returnredirect "card?user_id=$my_user_id&nav_sel=ficha"
	}

# If we are in a subcomm. get the list of the users of the parent
# comm that are not in the subcomm yet, and output them with radios
# for roles, etc.
set subcomm_p [dotlrn_community::subcommunity_p -community_id $community_id]

if {$subcomm_p} {

    form create parent_users_form

    set parent_user_list [dotlrn_community::list_possible_subcomm_users -subcomm_id $community_id]
    set n_parent_users [llength $parent_user_list]

    foreach user $parent_user_list {
        element create parent_users_form "selected_user.[ns_set get $user user_id]" \
            -datatype text \
            -widget radio \
            -options {{{} none} {{} dotlrn_member_rel} {{} dotlrn_admin_rel}} \
            -value none
    }

    if {[form is_valid parent_users_form]} {
        foreach user $parent_user_list {
            set rel [element get_value parent_users_form "selected_user.[ns_set get $user user_id]"]
            if {![string match $rel none]} {
                dotlrn_community::add_user -rel_type $rel $community_id [ns_set get $user user_id]
            }
        }
        ad_returnredirect [ns_conn url]
    }
}
ad_return_template
