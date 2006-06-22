<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>
    <fullquery name="alum_sql">
        <querytext>
			select acs_users_all.user_id as user_id,
					id_card,
					last_name,
					first_names 
			from 	acs_users_all,
					dotlrn_member_rels_approved 
						inner join uv_card on (ref_user_id = user_id) 
			where dotlrn_member_rels_approved.community_id = :community_id and 
					dotlrn_member_rels_approved.user_id = acs_users_all.user_id and 
					(role='student' or role='member') and 
					uv_card.ref_community_id = community_id 
			order by last_name, first_names asc
        </querytext>
    </fullquery>
</queryset>
