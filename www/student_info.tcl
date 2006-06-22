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
set community_id [dotlrn_community::get_community_id]
set community_selected $community_id
set community_id [cards::get_big_parent_community -community_id $community_id]

# Usuari que som y url a la que estem
set card_id [cards::get_card_id -community_id $community_id -user_id $user_id]
set my_user_id [ad_conn user_id]
set referer [ns_conn url]
set photo_student [cards::get_student_photo -user_id $user_id -param $widthheight_param -return_url $referer]

db_0or1row select_found_card { *SQL* }
db_1row student_name { *SQL* }
