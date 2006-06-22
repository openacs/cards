ad_page_contract {
}  -query {     
  user_id:integer,notnull
  {mode:optional ""}  
  {nav_sel:optional ""}
  {note_id:optional ""}
} -properties { 
        block:multirow
        grades:multirow
}

# Esto es una xorrada. pero si no lo pongo no va. 
#set uid $user_id 
#set m $mode 
set nid $note_id 
#set nsel $nav_sel


template::multirow create block percent_id percent_name type percent rvalor block_grade block_gradep
template::multirow create grades note_id ref_card task_name task_percent date date_mod note_comment grade gradep max_grade is_active ref_percent type


# Declaració de variables
set widthheight_param "width=72 height=90"
set export_vars [export_url_vars user_id]
acs_user::get -user_id $user_id -array user_info
set existe_photo 1
set subsite_url [subsite::get_element -element url]
set is_edit 0

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

set datetime [clock_to_ansi [clock seconds]]

#db_multirow comments select_comment { *SQL* } 


#if {$mode ne "comment_edit"} {
#       set comment_id ""
#       set mode ""
#}
#template::multirow append usercomm $names $quota $max_quota $files $max_files

set contador 0
set block_gradep 0
set nota_final 0
set grade_state 1


db_multirow blocks select_blocks { *sql* }
multirow foreach blocks {        
        set contador [expr $contador + 1]
        set block_grade 0.00
        set task_num 0
        set gradep 0.00
        db_multirow block_task select_block_tasks {     *sql* }
        multirow foreach block_task {        
          set task_ctrl [db_0or1row task_note { *sql* }]
          if {$task_ctrl eq 1} {                
                if {$is_active eq "t"} {                
                        set gradep [expr $grade * 10 / $max_grade]                      
                        if {$task_percent > 0 & $type eq 3} {
                                set gradep [expr $gradep * $task_percent / 100]
                        }
                        set block_grade [expr $block_grade + $gradep]
                        set task_num [expr $task_num + 1]
                }
                template::multirow append grades $note_id $ref_card $task_name $task_percent $date $date_mod \
                $note_comment $grade $gradep $max_grade $is_active $ref_percent $type                           
          }
        }
        if {$type ne 3 && $task_num > 0} {
                set block_grade [expr $block_grade / $task_num]
        }
        if {$block_grade < $rvalor} { #Si no superamos la restricción
                set grade_avg 1
                set grade_state 0
        } else {
                set grade_avg 0
        }
        set block_gradep [expr $block_grade * $percent / 100]
        set nota_final [expr $nota_final + $block_gradep]
        template::multirow append block $percent_id $percent_name $type $percent $rvalor $block_grade $block_gradep $grade_avg
}

if {($grade_state == 0) && $nota_final >= 5} {
                set nota_final  "4*"    
        } else {
                if {$nota_final <= 0} {
                                set nota_final "NP"
                }
}       

if {$mode ne "note_edit"} {
 set mode ""
        set note_id ""
} else {
        set note_id $nid
}


