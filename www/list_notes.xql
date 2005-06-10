<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>
    
	
	<fullquery name="alum_sql">
        <querytext>
		select 	acs_users_all.user_id,
				id_card, last_name,
				first_names 
		from 	acs_users_all,
				dotlrn_member_rels_approved inner join uv_card on (ref_user_id = user_id) 
		where	dotlrn_member_rels_approved.community_id = :community_id and
				dotlrn_member_rels_approved.user_id = acs_users_all.user_id and
				(role='student' or role='member') 
				and uv_card.ref_community_id = community_id 
		order	by last_name, first_names asc
        </querytext>
    </fullquery>

	
	<fullquery name="blocs_eval_sql">
		<querytext>
			select id_xcent, xcent, name_xcent, rvalor 
			from uv_card_xcent_note 
			where ref_community_id = :community_id 
			order by xcent desc, name_xcent asc
        </querytext>
    </fullquery>
	
	
	<fullquery name="notes_eval_sql">
        <querytext>
			select 	ref_id_card, ref_xcent, name_xcent, xcent,
					avg(value_n)*xcent*1.00/100.00 as mitja_p,
					rvalor, np 
			from 	uv_card_notes n, uv_card_subtype_note sn, uv_card_xcent_note xn 
			where 	sn.ref_xcent = xn.id_xcent and 
					sn.ref_community_id = :community_id and 
					xn.ref_community_id = :community_id and 
					n.ref_subtype = sn.id_subtype and 
					is_active = 'true' and xcent<>0 
			group by  ref_xcent,name_xcent,xcent,ref_id_card, rvalor,np 
			order by ref_id_card asc, xcent desc, ref_xcent asc;
        </querytext>
    </fullquery>
	
	
	<fullquery name="npn_sql">
        <querytext>
			select count(np) as npn from uv_card_xcent_note where ref_community_id= :community_id and np<>'f'
        </querytext>
    </fullquery>
	
	

	
</queryset>



