ad_page_contract {
}  -query {     
  user_id:integer,notnull
  {mode:optional ""}  
  {mail_subject:optional ""}
  {mail_body:optional ""}
} -properties {
}

# Declaració de variables
set widthheight_param "width=72 height=90"
set export_vars [export_url_vars user_id]
acs_user::get -user_id $user_id -array user_info
set existe_photo 1
set subsite_url [subsite::get_element -element url]

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

# Usuari que som y url a la que estem
set card_id [cards::get_card_id -community_id $community_id -user_id $user_id]
set my_user_id [ad_conn user_id]
set referer [ns_conn url]
set photo_student [cards::get_student_photo -user_id $user_id -param $widthheight_param -return_url $referer -admin "1"]


# Si no som administradors  [admin_p = 0] --> error: permis denegat 
set admin_p [dotlrn::user_can_admin_community_p -user_id $my_user_id -community_id $community_id]
if {!$admin_p} {
                        ad_return_error [lang::util::localize "#acs-subsite.Error#"] [lang::util::localize "#dotlrn.deniedpermission#"]         
}


db_0or1row select_found_card { *SQL* }
db_1row student_name { *SQL* }
