# /cards/eval2cards

ad_page_contract {    
        Paco Soler Lahuerta
        fransola@uv.es
} -query {
    {num_e:optional ""}
        {msg_e:optional ""}
    {url:optional ""}
    

}

# Prevent to call from out
#


# Error cases
switch -exact -- $num_e { 
    1 {
                set msg_e "#cards.no_tasks_to_import#"
                set url "cards_list"
        }
        
    2 {
                set msg_e "#cards.no_tasks_grades_to_import#"
                set url "eval2cards"
        }   
        
        3 {
                set msg_e "#cards.subgroup_tasks_grades_import#"
                set url "cards_list"                    
        }
        
        default {
        } 
}

#ad_return_template
