ad_page_contract {
}  -query {     
  user_id:integer,notnull
  {mode:optional ""}  
  {nav_sel:optional ""}  
  {mail_subject:optional ""}
  {mail_body:optional ""}
  {info_edit:optional ""}
  {user_address:optional ""}
  {user_phones:optional ""}  
  {comment_id:optional ""}
  {comment:optional ""}  
  {student_comment:optional ""}  
  
} -properties {
}

# Declaració de variables a emprar
set error 0
set senyala ""
set link_url ""
set task_sel_edit ""
set is_edit 0
set info_edit 0
set grade_avg 10
set user_id $user_id
set msg ""

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
set allow_view_grades [cards::get_community_parameter -community_id $community_selected -param "AllowGradeView"] 


# Usuari que som y url a la que estem
set card_id [cards::get_card_id -community_id $community_id -user_id $user_id]
set my_user_id [ad_conn user_id]
set referer [ns_conn url]

# Envio de MAILS
if {$mode eq "mail"} {  
        db_1row get_teacher_mail { *SQL* }
        db_1row get_student_mail { *SQL* }

        ns_sendmail $student_email $teacher_email $mail_subject $mail_body
        set mode ""
        set datetime [clock_to_ansi [clock seconds]]
        append comment "-> " $datetime ": " $mail_subject "<BR> " $mail_body    
        db_dml update_last_sendmail { *SQL* } 
}


# Update student_info
if {$mode eq "info_update"} {   
        set date [clock_to_ansi [clock seconds]]
        db_dml update_student_info { *SQL* } 
        set mode ""
        #ad_returnredirect "./student_card?user_id=$user_id&nav_sel=$nav_sel"
}

#Update student_comment
if {$mode eq "student_update"} {        
db_dml update_student_comment { *SQL* } 
        set mode ""
        set note_id ""
        #ad_returnredirect "./student_card?user_id=$user_id&nav_sel=$nav_sel"
}

set user_name [cards::get_student_name -user_id $user_id]

db_multirow blocks select_blocks { *SQL* }

