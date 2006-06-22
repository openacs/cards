<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

	
	
	<fullquery name="alum_sql">
        <querytext>
			select 	acs_users_all.user_id, id_card, last_name, first_names,
					id_card_notes, value_s, value_n, is_active 
			from acs_users_all, dotlrn_member_rels_approved 
				inner join uv_card
					inner join uv_card_notes on id_card = ref_id_card 
				on (ref_user_id = user_id) 
			where 	dotlrn_member_rels_approved.community_id = :community_id 
					and	dotlrn_member_rels_approved.user_id = acs_users_all.user_id 
					and (role='student' or role='member') 
					and uv_card.ref_community_id = :community_id 
					and ref_subtype = :note_sel 
			order by last_name, first_names asc
	    </querytext>
    </fullquery>
	
	<fullquery name="update_card_note">
        <querytext>
			update uv_card_notes
				set value_n= :note_value, value_s= :note_desc, is_active= :note_active
				where id_card_notes = :note_id
	    </querytext>
    </fullquery>
	
	<fullquery name="act_note">
        <querytext>
			select allow_act from uv_card_xcent_note xn 
				inner join uv_card_subtype_note sn on (id_xcent = ref_xcent) 
			where sn.ref_community_id = :community_id and id_subtype = :note_sel
	    </querytext>
    </fullquery>
	
	<fullquery name="sel_note">
        <querytext>
			select name_subtype from uv_card_subtype_note 
			where id_subtype = :note_sel
	    </querytext>
    </fullquery>
</queryset>
