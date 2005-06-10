<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>
	
	<fullquery name="update_personal_info">
        <querytext>
			update uv_card
			set address= :address, phone1= :phone1, phone2= :phone2
			where id_card= :card_id
	    </querytext>
    </fullquery>
	
	
	
	<fullquery name="update_student_comment">
        <querytext>
			update uv_card
			set comm_student= :comm_student
			where id_card= :card_id
	    </querytext>
    </fullquery>
	


	<fullquery name="get_item_id">
        <querytext>
			select i.width, i.height, cr.title, cr.description, cr.publish_date
			from acs_rels a, cr_items c, cr_revisions cr, images i
			where a.object_id_two = c.item_id
				and c.live_revision = cr.revision_id
				and cr.revision_id = i.image_id
				and a.object_id_one = :user_id
				and a.rel_type = 'user_portrait_rel'		
	    </querytext>
    </fullquery>
	
	
	<fullquery name="select_found_card">
        <querytext>
			select * from uv_card 
			where ref_user_id= :user_id 
			and ref_community_id= :community_id
	    </querytext>
    </fullquery>
	
	
	<fullquery name="insert_add_student_card">
        <querytext>
			insert into uv_card (ref_community_id, ref_user_id)
				values (:community_id, :user_id)
		</querytext>
    </fullquery>
	
	
	<fullquery name="view_notes">
        <querytext>
			select * from uv_card_base_note 
			where community_id = :community_id
	    </querytext>
    </fullquery>
	
	<fullquery name="blocs_eval_sql">
        <querytext>
			select * from uv_card_xcent_note 
			where ref_community_id = :community_id 
			order by xcent desc
	    </querytext>
    </fullquery>	
	
	<fullquery name="blocs_eval1_sql">
        <querytext>
			select ref_xcent, name_xcent, xcent, avg(value_n) as mitja 
			from uv_card_notes inner join 
				(uv_card_subtype_note inner join 
					uv_card_xcent_note on (ref_xcent = id_xcent))
				on (ref_subtype = id_subtype) 
			where ref_id_card = :card_id and is_active = 'true' 
			group by ref_xcent,name_xcent,xcent order by ref_xcent asc
	    </querytext>
    </fullquery>	
	
	<fullquery name="notes_sql">
        <querytext>
			select * from uv_card_notes inner join 
				(uv_card_subtype_note inner join 
					uv_card_xcent_note on (ref_xcent = id_xcent))
				on (ref_subtype = id_subtype) 
			where ref_id_card = :card_id 
			order by id_subtype desc				
	    </querytext>
    </fullquery>	
	
	<fullquery name="notes_eval_sql">
        <querytext>
			select 	ref_id_card, ref_xcent, name_xcent, xcent,
					avg(value_n)*xcent*1.00/100.00 as mitja_p,
					rvalor, np 
			from uv_card_notes n, uv_card_subtype_note sn, uv_card_xcent_note xn 
			where sn.ref_xcent = xn.id_xcent 
				and sn.ref_community_id = :community_id 
				and xn.ref_community_id = :community_id 
				and ref_id_card = :card_id 
				and n.ref_subtype = sn.id_subtype 
				and is_active = 'true' 
				and xcent<>0 
				group by  ref_xcent,name_xcent,xcent,ref_id_card,rvalor,np 
				order by ref_id_card asc, xcent desc, ref_xcent asc
	    </querytext>
    </fullquery>	

	<fullquery name="npn_sql">
        <querytext>
			select count(np) as npn 
			from uv_card_xcent_note 
			where ref_community_id= :community_id and np<>'f'
	    </querytext>
    </fullquery>		
        
</queryset>