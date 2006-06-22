ad_page_contract {
}  -query {     
  user_id:integer,notnull
  {mode:optional ""}  
  {note_id:integer,optional ""}
  {note_grade:optional ""}
  {note_comment:optional ""}
  {note_type:integer,optional ""}
  {note_act:boolean,optional ""}
  {note_act_yes:integer,optional ""}
  {nav_sel:optional ""}  
  {mail_subject:optional ""}
  {mail_body:optional ""}
  {info_edit:optional ""}
  {comment_id:optional ""}
  {comment:optional ""}  
  {teacher_comment:optional ""}  
  
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
set nb 0

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

# Si no som administradors  [admin_p = 0] --> error: permis denegat 
set admin_p [dotlrn::user_can_admin_community_p -user_id $my_user_id -community_id $community_id]
if {!$admin_p} {
                        ad_return_error [lang::util::localize "#acs-subsite.Error#"] [lang::util::localize "#dotlrn.deniedpermission#"]         
}

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

if {$mode eq "cancel"} {
        set mode ""
        set comment_id ""
        set comment ""
        
}

# Edicion de comentarios
if {$mode eq "comment_edit"} {  
        set comment_sel $comment_id
}

# Update de comentarios
if {$mode eq "comment_update"} {        
        set date [clock_to_ansi [clock seconds]]
        db_dml update_comment { *SQL* } 
        set mode ""
        set comment_id ""
}

# Update de comentarios
if {$mode eq "comment_delete"} {        
        db_dml delete_comment { *SQL* }
        set mode ""
        set comment_id ""
}

# Insert de comentarios
if {$mode eq "comment_insert"} {        
        set date [clock_to_ansi [clock seconds]]
        db_dml insert_comment { *SQL* } 
        set msg "INSERT OK"
        set mode ""
        #ad_returnredirect "./student_notes?user_id=$user_id&nav_sel=$nav_sel"
}

#Update notes
if {$mode eq "note_update"} {   
        if {$note_act eq 1 || $note_act_yes eq 1} {
                set note_actv 1 
        } else {
                set note_actv 0 
        }
        set date [clock_to_ansi [clock seconds]]
        db_dml update_note { *SQL* } 
        set mode ""
        set note_id ""
        #ad_returnredirect "./student_notes?user_id=$user_id&nav_sel=$nav_sel"
}

#Update teacher_comment
if {$mode eq "teacher_update"} {        
db_dml update_teacher_comment { *SQL* } 
        set mode ""
        set note_id ""
        #ad_returnredirect "./student_notes?user_id=$user_id&nav_sel=$nav_sel"
}


set user_name [cards::get_student_name -user_id $user_id]
db_multirow blocks select_blocks { *SQL* }

 multirow foreach blocks {
        set nb [expr $nb + 1]
 }

if {($nb eq 0) && ($nav_sel ne "comment")} {
        set nav_sel "ficha"
}
 
 #if {$nav_sel ne "comments"} {
#       if {$nb eq 0} {
#       set nav_sel "ficha"
#       }
# }
 
 set nbe [expr $nb + 3]

