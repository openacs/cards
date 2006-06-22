ad_page_contract {
}  -query {
  {mode:optional ""}
  {order:optional last_name}
  {order_dir:optional asc}
} -properties { 
        photos:multirow
}

set dotlrn_url [dotlrn::get_url]
set my_user_id [ad_conn user_id]
set referer [ns_conn url]
set widthheight_param "width=72 height=90"
template::multirow create photos student
set error 0
set msg_error ""

# Comunitat a la que estem. Check if we are in a subcommunity. In this case, we use the big parent community.
# but we only show the user cards that are in subgroup
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

# Access control
set site_wide_admin_p [permission::permission_p \
    -object_id [acs_magic_object security_context_root] \
    -privilege admin \
]

if {!$site_wide_admin_p} {
    set admin_p [dotlrn::user_can_admin_community_p -user_id $my_user_id -community_id $community_id]
} else {
    set admin_p 1
}

# Students Redirect to its student card
if {!$admin_p} {
        ad_returnredirect "student_card?user_id=$my_user_id&nav_sel=ficha"
        }

# Mostrar el listado de alumnos con ficha
#db_multirow current_members select_students_info { *SQL* }
 
                                 

if {$parent_community_id ne $community_selected} {
        db_multirow current_members select_sc_estudents_info { *SQL* }
} else { 
        db_multirow current_members select_students_info { *SQL* }
}

multirow foreach current_members {
  set photo_student [cards::get_photo_orla -user_id $user_id -param $widthheight_param]
  template::multirow append photos $photo_student       
}
