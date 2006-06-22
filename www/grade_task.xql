<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

        <fullquery name="get_task_info">      
      <querytext>
                select t.*,p.type as type 
                from card_task t, card_percent p 
                where 
                        task_id = :task_id and 
                        t.ref_community = p.ref_community and 
                        t.ref_percent = p.percent_id
      </querytext>
        </fullquery>
        
        <fullquery name="get_task_grades">      
      <querytext>
                select  last_name||', '||first_names as name,
                                note_id, ref_card, grade, note_comment, is_active 
                from card_note, acs_users_all, card 
                where   ref_task = :task_id and 
                                user_id = ref_user and ref_card=card_id
                                and user_id in (
                                        select  a.user_id as user_id
                                        from    acs_users_all a, dotlrn_member_rels_approved r 
                                        where   r.community_id = :community_id and 
                                                        r.user_id = a.user_id and
                                                        (role='student' or role='member')
                                                        order by user_id asc                            
                                        )
                order by last_name
      </querytext>
        </fullquery>
        
        <fullquery name="get_sc_task_grades">      
      <querytext>
                select  last_name||', '||first_names as name,
                                note_id, ref_card, grade, note_comment, is_active 
                from card_note, acs_users_all, card 
                where   ref_task = :task_id and 
                                user_id = ref_user and ref_card=card_id
                                and user_id in (
                                        select  a.user_id as user_id
                                        from    acs_users_all a, dotlrn_member_rels_approved r 
                                        where   r.community_id = :community_selected and 
                                                        r.user_id = a.user_id and
                                                        (role='student' or role='member')
                                                        order by user_id asc                            
                                        )
                order by last_name
      </querytext>
        </fullquery>    
        


        <fullquery name="get_note_ids">      
      <querytext>
                select  note_id
                from card_note
                where   ref_task = :task_id
      </querytext>
        </fullquery>    
        
<fullquery name="update_note">
    <querytext>
                update card_note set 
                grade = :new_grade, note_comment= :new_comment, is_active= :new_actv
                where note_id = :note_id
        </querytext>
</fullquery>            
        
        
</queryset>

