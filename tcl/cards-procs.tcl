ad_library {
    TCL library for the quota system

    @author Paco Soler (fransola@uv.es)
    @creation-date 5 September 2005
}
 
 
namespace eval cards {

# OBTENER COMUNIDAD PADRE
ad_proc -public get_parent_community {
        {-community_id ""}
} {
    Returns a parent community_id 
} {
   db_1row select_parent_community { *SQL* }
   return $parent_community_id
}

# OBTENER PRIMERA COMUNIDAD PADRE 
ad_proc -public get_big_parent_community {
        {-community_id ""}
} {
    Returns a high parent community_id 
} {
                set pcomm_id [cards::get_parent_community -community_id $community_id]
                while { $pcomm_id > 0} {
                        set community_id $pcomm_id
                        set pcomm_id [cards::get_parent_community -community_id $community_id]
                }
                return $community_id
}               

#Obtener el pretty _name de una comunidad
ad_proc -public get_community_pretty_name {
{-community_id ""}
} {
    Returns pretty name of the community
} {
        db_1row select_comm_pretty_name { *SQL* }       
        return $pretty_name
}       

# GET PACKAGE PARAMETER ID
ad_proc -public get_parameter_id {
        {-param ""}
} {
    Returns the parameter id of the community instance 
} {     
   return [db_string sql "select parameter_id from apm_parameters where parameter_name = :param"]
}

# GET PACKAGE PARAMETER ID FOR THE COMMUNITY
ad_proc -public get_cards_package_id {
{-community_id ""}
} {
    Returns the package_id of cards
} {
        set ctrl [db_0or1row get_cards_package_id { *SQL* }]
        if {$ctrl == 0} {
                return 0
        } else {
                return $pid
        }
}       

# GET A PARAMETER INSTANCE FOR THIS COMMUNITY
ad_proc -public get_community_parameter {
        {-community_id ""}
        {-param ""}
} {
    Returns the parameter instance for the community
} {  
   set pid [cards::get_cards_package_id -community_id $community_id]
   if {$pid == 0} {
      return 1   
   } else {
                set param_id [cards::get_parameter_id -param $param]
                db_0or1row get_community_parameter {* SQL *}
                return $value
   }
}

# UPDATE CARDS PARAMETERS
ad_proc -public update_cards_parameter {
        {-community_id ""}
        {-param ""}
        {-value ""}
} {
    Update the parameter reuse_parent_cards
} {  
        set pid [cards::get_cards_package_id -community_id $community_id]
        set param_id [cards::get_parameter_id -param $param]
        db_dml update_cards_parameter { *SQL* } 
}


########################################

# LISTA DE ESTUDIANTES (user_id) DE LA COMUNIDAD
ad_proc -public get_student_list {
        {-community_id ""}
} {
    Returns a students "user_id" list of the community
} {
   return [db_list get_student_list get_student_list]
}

# LISTA DE ESTUDIANTES SIN  CARD (user_id) DE LA COMUNIDAD
ad_proc -public get_no_card_student_list {
        {-community_id ""}
} {
    Returns a students "user_id" list of the community without card
} {
   return [db_list get_no_card_student_list get_no_card_student_list] 
}

# LISTA DE FICHAS DE ESTUDIANTE (card_id) DE LA COMUNIDAD
ad_proc -public get_cards_list {
        {-community_id ""}
} {
    Returns a students "card_id" list of the community
} {
        set l_students [cards::get_student_list -community_id $community_id]
        foreach usr $l_students {               
                lappend l_cards [cards::get_card_id -community_id $community_id -user_id $usr]
   }
   return $l_cards
}

# LlISTA DE LOS card_id DE UNA COMMUNITY - Incluso las borradas.
ad_proc -public get_all_community_cards {
        {-community_id ""}
} {
    Returns a students "card_id" list of the community with deleted it
} {
        return [db_list get_all_community_cards get_all_community_cards]
}

# LISTA DE TAREAS DE LA COMUNIDAD (task_id)
ad_proc -private get_community_tasks {
        {-community_id ""}
} {
    Returns a "task_id" list of community tasks  
} {
   return [db_list get_community_tasks get_community_tasks]
}

# LISTA DE TAREAS DE LA COMUNIDAD (task_id)
ad_proc -private get_task_type {
        {-task_block ""}
} {
    Returns a "task_type" of the block
} {
        db_1row get_task_type get_task_type
        return $type
}


# LISTA DE TAREAS DE LA COMUNIDAD (task_id)
ad_proc -private get_community_blocks {
        {-community_id ""}
} {
    Returns a "block_id" list of the community blocks  
} {
   return [db_list get_community_blocks get_community_blocks]
}


# CREAR NUEVA FICHA
ad_proc -private create_student_card {
        {-community_id ""}
        {-user_id ""}
} {
    Create a new student card
} {
        db_dml insert_new_card { *SQL* } 
}


# OBTENER CARD_ID DE UN ALUMNO
ad_proc -private get_card_id {
        {-community_id ""}
        {-user_id ""}
} {
    Get a student card_id
} {
        db_0or1row select_card_id { *SQL* }
        return $card_id
}       


# CREAR ANOTACION AL ALUMNO
ad_proc -private create_student_note {
        {-community_id ""}
        {-card_id ""}
        {-task_id ""}
} {
    Create a new student card
} {
        db_dml insert_new_note { *SQL* } 
}       


# OBTENER EL NOMBRE DE UN USUARIO

ad_proc -private get_student_name {
        {-user_id ""}
} {
    Create a new student card
} {
        db_1row select_student_name { *SQL* } 
        append name $last_name ", " $first_names
        return $name
}       


# OBTENER LA FOTO DE UN ESTUDIANTE - IMG o ENLACE PARA SUBIRLA
ad_proc -private get_student_photo {
    -user_id:required
        {-param ""}
        {-return_url ""}
        {-admin ""}
} {
    Get the student_photo
} {
        set username [cards::get_student_name -user_id $user_id]
        if { [db_0or1row select_student_photo { *SQL* }] } {
                if {$admin eq ""} {
                        set photo_url "<img src=\"/shared/portrait-bits.tcl?user_id=$user_id\" "
                        append photo_url $param " alt=\"" $username "\">" "<a href=\"/user/portrait/upload?return%5furl="
                        append photo_url $return_url "?user_id=" $user_id "\" alt=\"" $username "\">"  "<BR>#cards.change_photo#</a>"
                } else {
                        set photo_url "<img src=\"/shared/portrait-bits.tcl?user_id=$user_id\" "
                        append photo_url $param " alt=\"" $username "\">"
                }
        } else {
                if {$admin eq ""} {
                        set photo_url "<a href=\"/user/portrait/upload?return%5furl="
                        append photo_url $return_url "?user_id=" $user_id "\" alt=\"" $username "\">"  "<BR>#cards.upload_photo#</a>"
                } else {
                        set photo_url "#cards.no_photo# <BR>"
                        #append photo_url $username
                }
        }
        return $photo_url
}       


# Obtener foto para la orla
ad_proc -private get_photo_orla {
    -user_id:required
        {-param ""}
} {
    Get the student_photo
} {
        set username [cards::get_student_name -user_id $user_id]
        if { [db_0or1row select_student_photo { *SQL* }] } {
          set photo_url ""
          append photo_url "<A HREF=\"student_notes?user_id=$user_id\" alt=\"$username\">"
          append photo_url "<img src=\"/shared/portrait-bits.tcl?user_id=$user_id\" $param></a><BR>"
          append photo_url "<p class=\"photo_text\">$username</p>"
        } else {
          set photo_url ""
          append photo_url "<A HREF=\"student_notes?user_id=$user_id\" alt=\" $username \">"
          append photo_url "<img src=\"./icons/no-photo.jpg\" $param></a><BR>"
          append photo_url "<p class=\"photo_text\">$username</p>"
        }
        return $photo_url
}       


#fin de la libreria de funciones. OJO!!!!!!!!!
} 
