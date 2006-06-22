<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>
    
    <fullquery name="select_students_info">
        <querytext>
                        select acs_users_all.user_id as user_id,
                                        card_id,
                                        last_name,
                                        first_names,
                                        email
                        from    acs_users_all,
                                        dotlrn_member_rels_approved 
                                                inner join card on (ref_user = user_id) 
                        where dotlrn_member_rels_approved.community_id = :community_id and 
                                        dotlrn_member_rels_approved.user_id = acs_users_all.user_id and 
                                        (role='student' or role='member') and 
                                        card.ref_community = community_id 
                        order by $order $order_dir      
        </querytext>
    </fullquery>

        <fullquery name="select_sc_estudents_info">
                <querytext>
                        select 
                                acs_users_all.user_id as user_id,
                                card_id,
                                last_name,
                                first_names,
                                email
                        from
                                acs_users_all,
                                dotlrn_member_rels_approved 
                        inner join 
                                card on (ref_user = user_id) 
                        where 
                                dotlrn_member_rels_approved.community_id = :community_id and 
                                dotlrn_member_rels_approved.user_id = acs_users_all.user_id and 
                                (role='student' or role='member') and 
                                card.ref_community = :community_id and 
                                acs_users_all.user_id in (
                                        select acs_users_all.user_id 
                                        from acs_users_all, dotlrn_member_rels_approved 
                                        where 
                                                dotlrn_member_rels_approved.community_id = :community_selected and 
                                                dotlrn_member_rels_approved.user_id = acs_users_all.user_id and 
                                                (role='student' or role='member')
                                ) 
                        order by $order $order_dir      
        </querytext>
    </fullquery>
                
        
        <fullquery name="select_found_card">
                <querytext>
                        select * from card 
                        where ref_user= :user_id and ref_community= :community_id
                </querytext>
        </fullquery>    

        <fullquery name="select_blocks">
                <querytext>
                        select * from card_percent where ref_community= :community_id 
                                                and percent > 0 order by percent desc
                </querytext>
        </fullquery>    


        <fullquery name="select_block_tasks">
                <querytext>
                        select * from card_task where ref_percent= :percent_id and ref_community = :community_id order by task_name
                </querytext>
        </fullquery>    

        <fullquery name="task_note">
                <querytext>
                        select * from card_note 
                        where ref_card= :card_id and ref_task= :task_id
                </querytext>
        </fullquery>    

        
        <fullquery name="select_block_grades_OLD">
                <querytext>
                        select ref_card,ref_percent, CASE WHEN type=3 THEN '1' ELSE count(task_id) END as nt, CASE WHEN type = 3 THEN sum(grade*task_percent/(max_grade*10.00)) ELSE sum(grade*10.00/(max_grade)) END as nota_bloque, percent as xcent, rvalor, percent_name from card_note inner join (card_task inner join card_percent on (ref_percent = percent_id)) on (ref_task = task_id) where is_active = 't' group by ref_percent,ref_card, type, percent, rvalor, percent_name order by ref_card
                </querytext>
        </fullquery>    
   
        <fullquery name="select_block_grades">
                <querytext>
                        select ref_card,
                               ref_percent,
                               CASE WHEN type=3 THEN '1' ELSE count(task_id) END as nt,
                               CASE WHEN type = 3 THEN sum(grade*task_percent/(max_grade*10.00)) ELSE sum(grade*10.00/(max_grade)) END as nota_bloque,
                               percent as xcent,
                               rvalor,
                               percent_name
                       from card_note cn, card_task ct, card_percent cp
                       where ct.ref_percent = cp.percent_id and
                             ct.ref_community = cp.ref_community and
                             ct.ref_community = cn.ref_community and
                             cn.ref_community = :community_id and
                             cn.ref_task = ct.task_id and
                             is_active = 't' group by ref_percent,ref_card, type, percent, rvalor, percent_name order by ref_card
                </querytext>
        </fullquery>
        
</queryset>



