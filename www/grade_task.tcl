ad_page_contract {
}  -query {  
        task_id:integer,notnull

    item_ids:array,integer,optional
    item_to_edit_ids:array,integer,optional
    
    evaluation_ids:array,integer,optional

    grade:array,optional
    note_comment:array,optional
    is_active:array,optional    
        
  {mode:optional "edit"}  
  {mode2:optional ""}  
} -properties {
} -validate {
    valid_grade {
        set counter 0
        foreach note_id [array names grade] {
          if { [info exists grade($note_id)] && ![empty_string_p $grade($note_id)] } {
                incr counter
                set grade($note_id) [template::util::leadingTrim $grade($note_id)]
                if { ![ad_var_type_check_number_p $grade($note_id)] } {
                set wrong_grade $grade($note_id)
                ad_complain "[_ evaluation.lt_The_grade_must_be_a_v]"
                }
          }
        }
    }
        valid_note_comment {
                foreach note_id [array names note_comment] {
            if { [info exists note_comment($note_id)] && ![info exists grade($note_id)] } {
                set wrong_comments $note_comment($note_id)
                ad_complain "[_ evaluation.lt_There_is_a_comment_fo]"
            }
            if { [info exists note_comment($note_id)] && ([string length $note_comment($note_id)] > 400) } {
                set wrong_comments $note_comment($note_id)
                ad_complain "[_ evaluation.lt_There_is_a_comment_la]"
            }
        }
        }
}

# Declaració de variables a emprar
set error 0
set msg_error ""
set link_url ""
set is_edit 0
set return_url "manage_tasks"

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


#set community_id [dotlrn_community::get_community_id]
#set community_selected $community_id
#set community_id [cards::get_big_parent_community -community_id $community_id]

#if {$community_selected ne $community_id} {
#       append community_name [cards::get_community_pretty_name -community_id $community_id] \
#       " :: " [cards::get_community_pretty_name -community_id $community_selected]
#} else {
#       set community_name [cards::get_community_pretty_name -community_id $community_id]
#}



# Usuari que som y url a la que estem
set my_user_id [ad_conn user_id]
set referer [ns_conn url]

# Si no som administradors  [admin_p = 0] --> error: permis denegat 
set admin_p [dotlrn::user_can_admin_community_p -user_id $my_user_id -community_id $community_id]
if {!$admin_p} {
                        ad_return_error [lang::util::localize "#acs-subsite.Error#"] [lang::util::localize "#dotlrn.deniedpermission#"]         
}

# Obtenemos datos de la tarea
db_1row get_task_info { *SQL* }

if {$mode eq "edit"} {


if {$parent_community_id ne $community_selected} {
        db_multirow task_grades get_sc_task_grades { *SQL* }
} else { 
        db_multirow task_grades get_task_grades { *SQL* }
}


set elements [list name [list label "#cards.card_Student#" \
        display_template {<span class="student">@task_grades.name@</span>}]]

lappend elements note_comment \
                [list label "#cards.card_Comment#" \
                display_template {<TEXTAREA rows="2" cols="50" name="note_comment.@task_grades.note_id@" wrap>@task_grades.note_comment@</TEXTAREA>}]
                
lappend elements grade \
                [list label "#cards.card_Grade#" \
                display_template {<INPUT type="text" size="4" name="grade.@task_grades.note_id@" value="@task_grades.grade@" onblur="this.value = convertComma(this.value);">}]

if {$type == 2} {
        lappend elements is_active \
                [list label "#cards.card_Active#" \
                display_template {
                  <if @task_grades.is_active@>
                  <INPUT type="checkbox" size="1" name="is_active.@task_grades.note_id@" value="1" checked>               
                  </if><else>
                  <INPUT type="checkbox" size="1" name="is_active.@task_grades.note_id@" value="1">
                  </else>}] 
}

template::list::create \
    -name task_grades \
    -multirow task_grades \
    -key note_id \
    -elements $elements
}

        
set num_activas 0

if {$mode == "update"} {
 if {$mode2 == ""} {
        set num_activas 0
  set l_notes [db_list get_note_ids { *SQL* }]
  foreach note_id $l_notes {                            
        if {[info exists grade($note_id)] && ![empty_string_p $$grade($note_id)]} {
          set new_grade $grade($note_id)
        } else {
          set new_grade 0.00
        }
        if {[info exists grade($note_id)]} {
          set new_comment $note_comment($note_id)
        } else {
          set new_comment ""
        }
        
        if {[info exists is_active($note_id)]} {
                set num_activas [expr $num_activas + 1]
                if {$is_active($note_id)} {
                        set new_actv 1
                } else {
                        set new_actv 0
                }
        } else {
                if {$type == 2} {
                        set new_actv 0
                        set num_activas [expr $num_activas + 1]
                } else {
                        set new_actv 1
                }
        }        
        db_dml update_note { *SQL* }
  }
  } else {
  set return_url "eval2cards"
  }
        # Obtenemos datos de la tarea   
if {$community_id ne $community_selected} {
        db_multirow task_grades get_sc_task_grades { *SQL* }
} else { 
        db_multirow task_grades get_task_grades { *SQL* }
}       

        set elements [list name [list label "#cards.card_Student#"]]

        lappend elements note_comment \
                [list label "#cards.card_Comment#" \
                display_template {<pre>@task_grades.note_comment@</pre>}]
                
lappend elements grade \
                [list label "#cards.card_Grade#" \
                display_template {@task_grades.grade@}]

if {$type == 2} {
        lappend elements is_active \
                [list label "#cards.card_Active#" \
                display_template {
                  <if @task_grades.is_active@>
                  <INPUT type="checkbox" size="1" name="is_active.@task_grades.note_id@" value="1" checked disabled>
                  </if><else>
                  <INPUT type="checkbox" size="1" name="is_active.@task_grades.note_id@" value="1" disabled>
                  </else>}] 
}


template::list::create \
    -name task_grades \
    -multirow task_grades \
    -key note_id \
    -elements $elements 
}


if { $mode eq "csvchanged" } {

set mode ""
# Obtenemos datos de la tarea   
if {$community_id ne $community_selected} {
        db_multirow task_grades get_sc_task_grades { *SQL* }
} else { 
        db_multirow task_grades get_task_grades { *SQL* }
}

set elements [list name [list label "#cards.card_Student#"]]

        lappend elements note_comment \
                [list label "#cards.card_Comment#" \
                display_template {<pre>@task_grades.note_comment@</pre>}]
                
        lappend elements grade \
                [list label "#cards.card_Grade#" \
                display_template {@task_grades.grade@}]

if {$type == 2} {
        lappend elements is_active \
                [list label "#cards.card_Active#" \
                display_template {
                  <if @task_grades.is_active@>
                  <INPUT type="checkbox" size="1" name="is_active.@task_grades.note_id@" value="1" checked disabled>
                  </if><else>
                  <INPUT type="checkbox" size="1" name="is_active.@task_grades.note_id@" value="1" disabled>
                  </else>}] 
}


template::list::create \
    -name task_grades \
    -multirow task_grades \
    -key note_id \
    -elements $elements \
        -selected_format csv -formats {
        csv { output csv }
    }
    template::list::write_output -name task_grades
}
