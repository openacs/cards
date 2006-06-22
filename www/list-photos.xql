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
        
</queryset>


