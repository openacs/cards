<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_current_members">
        <querytext>
            select dotlrn_member_rels_approved.rel_id,
                   dotlrn_member_rels_approved.rel_type,
                   dotlrn_member_rels_approved.role,
                   dotlrn_member_rels_approved.user_id,
                   acs_users_all.first_names,
                   acs_users_all.last_name,
                   acs_users_all.email,
                   (select count(*) from acs_rels where rel_type = 'user_portrait_rel' and object_id_one = dotlrn_member_rels_approved.user_id) as portrait_p,
                   (select count(*) from acs_attribute_values where object_id = dotlrn_member_rels_approved.user_id and attribute_id = :bio_attribute_id and attr_value != '') as bio_p
            from acs_users_all,
                 dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.community_id = :community_id
            and dotlrn_member_rels_approved.user_id = acs_users_all.user_id
            and (role = 'student' or role = 'member')
            order by acs_users_all.last_name asc
        </querytext>
    </fullquery>
	
	
	<fullquery name="get_base">
        <querytext>
			select * from uv_card_base_note 
			where community_id = :community_id
	    </querytext>
    </fullquery>
	
	<fullquery name="insert_base_note">
        <querytext>
			insert into uv_card_base_note
			(community_id, base_note)
			values
			(:community_id, 100)
	    </querytext>
    </fullquery>
		
	
	<fullquery name="alum_del">
		<querytext>
			select count(id_card) as num_alum_del 
			from uv_card 
			where ref_community_id = :community_id and 
			ref_user_id not in 	
				(select user_id 
					from dotlrn_member_rels_approved m 
					where (m.community_id = :community_id 
					and m.role = 'student') OR 
					(m.community_id = :community_id 
					and m.role = 'member')
				)
	    </querytext>
    </fullquery>
	
	
	<fullquery name="delete_card_notes">
        <querytext>
		delete from uv_card_notes 
		where id_card_notes in 
			(select id_card_notes from uv_card_notes 
			 where ref_id_card in 
				(select id_card from uv_card 
				where ref_community_id = :community_id and ref_user_id not in 
					(select user_id from dotlrn_member_rels_approved m 
					where (m.community_id = :community_id and m.role = 'student') OR
						  (m.community_id = :community_id and m.role = 'member')
					)
				)
			)
	    </querytext>
    </fullquery>

	<fullquery name="delete_cards">
        <querytext>
		delete from uv_card 
		where id_card in 
		(select id_card from uv_card 
		 where ref_community_id = :community_id and ref_user_id not in 
			(select user_id from dotlrn_member_rels_approved m 
			 where (m.community_id = :community_id and m.role = 'student') OR 
			       (m.community_id = :community_id and m.role = 'member')
			)
		)
		
	    </querytext>
    </fullquery>
		
	<fullquery name="user_no_card_sql">
        <querytext>
		select a.user_id from acs_users_all a, dotlrn_member_rels_approved r 
		where r.community_id = :community_id and 
			  r.user_id = a.user_id and
			  (role='student' or role='member') and
			  a.user_id not in 
				(select ref_user_id from uv_card where ref_community_id = :community_id)
		</querytext>
    </fullquery>
	

	
	<fullquery name="community_notes_sql">
        <querytext>
			select id_subtype from uv_card_subtype_note s 
				inner join uv_card_xcent_note on (id_xcent = ref_xcent) 
			where s.ref_community_id = :community_id and ref_basetype <> 3		
	    </querytext>
    </fullquery>	
	
	
	
	<fullquery name="insert_add_new_card">
        <querytext>
			insert into uv_card (ref_community_id, ref_user_id)
			values (:community_id, :user_id)
	    </querytext>
    </fullquery>
	
	<fullquery name="card_user_id">
        <querytext>
			select id_card from uv_card 
			where ref_community_id = :community_id and ref_user_id = :user_id
	    </querytext>
    </fullquery>	
	
	
	
	<fullquery name="insert_pending_notes">
        <querytext>
			insert into uv_card_notes (ref_id_card,ref_subtype,value_n,r_community_id)
			values (:id_card, :id_subtype, 0.00, :community_id)
	    </querytext>
    </fullquery>
	
	
	
	<fullquery name="select_pending_users">
        <querytext>
		    select dotlrn_users.*,
				dotlrn_member_rels_full.rel_type,
				dotlrn_member_rels_full.role
			from dotlrn_users,
				 dotlrn_member_rels_full
			where dotlrn_users.user_id = dotlrn_member_rels_full.user_id
				and dotlrn_member_rels_full.community_id = :community_id
				and dotlrn_member_rels_full.member_state = 'needs approval'
	    </querytext>
    </fullquery>
	
	
	
	<fullquery name="bio_attribute_id">
        <querytext>
			select attribute_id
			from acs_attributes
			where object_type = 'person'
				and attribute_name = 'bio'
	    </querytext>
    </fullquery>
	
	
    

</queryset>
