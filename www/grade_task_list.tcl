ad_page_contract {
}  -query {  
        task_id:integer,notnull

  {mode:optional "list"}  
} -properties {
} 

# Declaració de variables a emprar
set error 0
set msg_error ""
set link_url ""
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
set my_user_id [ad_conn user_id]
set referer [ns_conn url]

# Si no som administradors  [admin_p = 0] --> error: permis denegat 
set admin_p [dotlrn::user_can_admin_community_p -user_id $my_user_id -community_id $community_id]
if {!$admin_p} {
                        ad_return_error [lang::util::localize "#acs-subsite.Error#"] [lang::util::localize "#dotlrn.deniedpermission#"]         
}

# Obtenemos datos de la tarea
db_1row get_task_info { *SQL* }

# Obtenemos datos del bloque. En concreto el % para ctrl caso especia % = 0
db_1row get_block_percent { *SQL* }

# Obtenemos datos de la tarea   
if {$community_selected ne $community_selected} {
        db_multirow task_grades get_sc_task_grades { *SQL* }
} else { 
        db_multirow task_grades get_task_grades { *SQL* }
}

if { $mode eq "list" } {
set mode ""
set elements [list name [list label "#cards.card_Student#"]]
#lappend elements note_comment \
                [list label "#cards.card_Comment#" \
                display_template {<pre>@task_grades.note_comment@</pre>}]
                
if {$percent == 0} {
                lappend elements note_comment \
                [list label "#cards.card_Comment#" \
                display_template {@task_grades.note_comment@}]
                lappend elements grade \
                [list label "&nbsp;&nbsp;&nbsp;#cards.card_Grade#" \
                display_template {&nbsp;&nbsp;&nbsp;@task_grades.grade@}]
} else {                
        lappend elements grade \
                [list label "&nbsp;&nbsp;&nbsp;#cards.card_Grade#" \
                display_template {&nbsp;&nbsp;&nbsp;@task_grades.grade@}]
}

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
        
# CSV   
if { $mode eq "csv" } {

set mode ""

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

        
