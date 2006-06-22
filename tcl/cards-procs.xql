<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

        <fullquery name="cards::get_cards_package_id.get_cards_package_id">
        <querytext>
                        select object_id as pid from acs_objects, apm_packages as apmp
                        where context_id = (
                                select package_id from dotlrn_communities_all 
                                where community_id = :community_id) 
                        and package_key = 'cards' and object_id = apmp.package_id;
            </querytext>
    </fullquery>        
        
        <fullquery name="cards::get_community_parameter.get_community_parameter">
    <querytext>
                select attr_value as value from apm_parameter_values 
                where parameter_id = :param_id and
                      package_id = :pid
        </querytext>
        </fullquery>
        
    <fullquery name="cards::get_student_list.get_student_list">
        <querytext>
                        select  a.user_id as user_id
                        from    acs_users_all a, dotlrn_member_rels_approved r 
                        where   r.community_id = :community_id and 
                                        r.user_id = a.user_id and
                                        (role='student' or role='member')
                        order by user_id asc
        </querytext>
    </fullquery>        

    <fullquery name="cards::get_parent_community.select_parent_community">
        <querytext>
                        select parent_community_id 
                        from dotlrn_communities_all 
                        where community_id = :community_id
        </querytext>
    </fullquery>        
        
        <fullquery name="cards::get_community_pretty_name.select_comm_pretty_name">
        <querytext>
                        select pretty_name
                        from dotlrn_communities_all 
                        where community_id = :community_id
        </querytext>
    </fullquery>        
        
        
    <fullquery name="cards::get_no_card_student_list.get_no_card_student_list">
        <querytext>
                select a.user_id as user_id
                from acs_users_all a, dotlrn_member_rels_approved r 
                where r.community_id = :community_id and 
                          r.user_id = a.user_id and
                          (role='student' or role='member') and
                          a.user_id not in 
                                (select ref_user from card where ref_community = :community_id)
                </querytext>
    </fullquery>                        
        
    <fullquery name="cards::get_all_community_cards.get_all_community_cards">
        <querytext>
                select card_id from card where ref_community = :community_id
                </querytext>
    </fullquery>                        
        
        

        <fullquery name="cards::get_community_blocks.get_community_blocks">     
        <querytext>
                        select block_id from card_percent p                             
                        where s.ref_community = :community_id
                        order by percent desc
            </querytext>
    </fullquery>                
        
        <fullquery name="cards::get_community_tasks.get_community_tasks">       
        <querytext>
                        select task_id from card_task s 
                                inner join card_percent on (percent_id = ref_percent) 
                        where s.ref_community = :community_id
                        order by task_id asc
            </querytext>
    </fullquery>                
        
        <fullquery name="cards::get_task_type.get_task_type">   
        <querytext>
                        select type from card_percent
                        where percent_id = :task_block
            </querytext>
    </fullquery>                        
        
        
        <fullquery name="cards::create_student_card.insert_new_card">
        <querytext>
                        insert into card (ref_community, ref_user)
                        values (:community_id, :user_id)
            </querytext>
    </fullquery>        


        <fullquery name="cards::get_card_id.select_card_id">
        <querytext>
                        select card_id from card 
                        where ref_community = :community_id and ref_user = :user_id
            </querytext>
    </fullquery>        
                
        
        <fullquery name="cards::create_student_note.insert_new_note">
        <querytext>
                        insert into card_note (ref_card,ref_task,grade,ref_community)
                        values (:card_id, :task_id, 0.00, :community_id)
            </querytext>
    </fullquery>        

        
        <fullquery name="cards::get_student_name.select_student_name">
        <querytext>
                        select last_name, first_names 
                        from acs_users_all 
                        where user_id = :user_id
            </querytext>
    </fullquery>

        <fullquery name="cards::get_student_photo.select_student_photo">
        <querytext>
                        select c.item_id 
                        from acs_rels a, cr_items c 
                        where a.object_id_two = c.item_id and 
                        a.object_id_one = :user_id and 
                        a.rel_type = 'user_portrait_rel'
                </querytext>
    </fullquery>        
        
        <fullquery name="cards::get_photo_orla.select_student_photo">
        <querytext>
                        select c.item_id 
                        from acs_rels a, cr_items c 
                        where a.object_id_two = c.item_id and 
                        a.object_id_one = :user_id and 
                        a.rel_type = 'user_portrait_rel'
                </querytext>
    </fullquery>        

<fullquery name="cards::update_cards_parameter.update_cards_parameter">
    <querytext>
                update apm_parameter_values 
                set attr_value = :value
                where parameter_id = :param_id and
                      package_id = :pid
        </querytext>
</fullquery>    
        

        
</queryset>
