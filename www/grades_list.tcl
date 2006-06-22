ad_page_contract {
}  -query {     
  {nav_sel:optional ""}
  {order:optional last_name}
  {order_dir:optional asc}
  {mode:optional ""}  
} -properties { 
        block:multirow
        grades:multirow
}

#template::multirow create block percent_id percent_name type percent rvalor block_grade block_gradep
template::multirow create grades num user_id note_id nom

#set l_alum_grades [list]
set error 0
# Declaració de variables
set widthheight_param "width=72 height=90"
set export_vars [export_url_vars user_id]
# acs_user::get -user_id $user_id -array user_info
set existe_photo 1
set subsite_url [subsite::get_element -element url]
set is_edit 0

# Grade Stats
set passed 0
set not_passed 0
set not_presented 0


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
#set card_id [cards::get_card_id -community_id $community_id -user_id $user_id]
set my_user_id [ad_conn user_id]
set referer [ns_conn url]

# Si no som administradors  [admin_p = 0] --> error: permis denegat 
set admin_p [dotlrn::user_can_admin_community_p -user_id $my_user_id -community_id $community_id]
if {!$admin_p} {
                        ad_return_error [lang::util::localize "#acs-subsite.Error#"] [lang::util::localize "#dotlrn.deniedpermission#"]         
}

set datetime [clock_to_ansi [clock seconds]]


# Obtenemos la lista de bloques de la comunidad y ampliamos el multirow
db_multirow block_list select_blocks { *SQL* }
multirow foreach block_list {
  # eval "template::multirow extend grades " $percent_name ==> CAMBIO 
  eval "template::multirow extend grades " $percent_id
  #  " " $ percent_name "_p"  
}
template::multirow extend grades final_grade


if {$community_id ne $community_selected} {
        db_multirow student select_sc_estudents_info { *SQL* }
} else { 
        db_multirow student select_students_info { *SQL* }
}

db_multirow block_grades select_block_grades { *SQL* }
set num_alumne 1
multirow foreach student {
  set grade_final 0
  set grade_block 0
  set grade_block_p 0
  set grade_state 1
  set nom ""
  # Añadimos al multirow User_Id - Card_Id - Nombre del Alumno
  template::multirow append grades $num_alumne $user_id $card_id [append nom $last_name ", " $first_names]
  set num_alumne [expr $num_alumne + 1]
  set num [template::multirow size grades]
  multirow foreach block_grades {
        
          set grade_block ""
          set grade_block_p ""
          set grade_block_value ""
        if {$ref_card == $card_id} {
          set grade_block [expr $nota_bloque * 1.00 / $nt]        
          #append grade_block $nota_bloque " - " $nt " - " $xcent
          set grade_block_p [expr $grade_block * $xcent /100.00]
          #set grade_block_p $grade_block
          if {$grade_block < $rvalor} {
                set grade_state 0
          }
          set grade_final [expr $grade_final + $grade_block_p]
          # Añadimos al multirow la información del bloque
          # set column $percent_name  ==> MOD: vamos a utilizar ref_percent 
          set column $ref_percent
          append grade_block_value [format "%2.2f" $grade_block] " (" [format "%2.2f" $grade_block_p]  ")"
          template::multirow set grades $num $column $grade_block_value
          #append column "_p"
          #template::multirow set grades $ num $ column $ grade_block_p
        }
  }
  set grade_final [format "%2.2f" $grade_final]  
  if {($grade_state == 0) && $grade_final >= 5} {
        set grade_final  "4*"   
        set not_passed [expr $not_passed + 1]   
  } else {
        if {$grade_final <= 0} {
          set grade_final "NP"
          set not_presented [expr $not_presented + 1]
        } else {
                if {$grade_final >= 5} {
                        set passed [expr $passed + 1]
                } else {
                        set not_passed [expr $not_passed + 1]
                }
        }
  }
  
  # Añadimos al multirow la nota final
  template::multirow set grades $num final_grade $grade_final
}  

# LIST TEMPLATE         
# Preparación
set elements [list num [list label "&nbsp;"]]
lappend elements nom [list label "#dotlrn.First_Name#"]

multirow foreach block_list {
        # lappend elements $percent_name \ ==> CAMBIO
        lappend elements $percent_id \
        [list label $percent_name ]
#       lappend elements $ {percent_name}_p \
        [list label $ {percent_name}_p  ]
}

lappend elements final_grade [list label "#cards.card_Final_grade#"]


if {$mode eq "list"} {
        template::list::create \
                -name list_grades \
                -multirow grades \
                -key card_id \
                -class "list_to_print" \
                -elements $elements
} else {
        if {$mode eq "csv"} {   
                template::list::create \
                -name list_grades \
                -multirow grades \
                -key card_id \
                -elements $elements\
                -selected_format csv -formats {
                        csv { output csv }
                }
                template::list::write_output -name list_grades  
                
                } else {
                        template::list::create \
                        -name list_grades \
                        -multirow grades \
                        -key card_id \
                        -elements $elements
        }
}
