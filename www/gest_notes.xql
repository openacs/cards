<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>
	
 
	
	<fullquery name="tipo">
        <querytext>
		select name_xcent as tipo from uv_card_xcent_note where id_xcent = :nav_sel
	    </querytext>
    </fullquery>
	
	<fullquery name="alias_sql">
        <querytext>
		select name_subtype from uv_card_subtype_note 
		where name_subtype = :asig_alias 
			and ref_community_id = :community_id 
			and ref_xcent = :asig_type
	    </querytext>
    </fullquery>
	
	<fullquery name="list_alum">
        <querytext>
			select acs_users_all.user_id 
			from acs_users_all, dotlrn_member_rels_approved 
			where dotlrn_member_rels_approved.community_id = :community_id 
			and dotlrn_member_rels_approved.user_id = acs_users_all.user_id 
			and (role='student' or role='member')
	    </querytext>
    </fullquery>
	
	<fullquery name="select_found_card">
        <querytext>
		 select * from uv_card 
		 where ref_user_id= :alum_id and ref_community_id= :community_id
	    </querytext>
    </fullquery>
	
	<fullquery name="insert_new_card">
        <querytext>
			insert into uv_card	(ref_community_id, ref_user_id)
			values (:community_id, :alum_id)
	    </querytext>
    </fullquery>
	

	
	<fullquery name="insert_subtype">
        <querytext>
			insert into uv_card_subtype_note
			(ref_community_id, ref_xcent, name_subtype)
			values
			(:community_id, :asig_type, :asig_alias)
	    </querytext>
    </fullquery>	
	
	<fullquery name="get_subtype_id">
        <querytext>
		 select max(id_subtype) from uv_card_subtype_note 
		 where name_subtype = :asig_alias and ref_community_id = :community_id
	    </querytext>
    </fullquery>	
		
	<fullquery name="alum_idcard">
        <querytext>
			select id_card from uv_card 
			where ref_user_id = :alum_id and ref_community_id = :community_id
	    </querytext>
    </fullquery>	
	
	
	<fullquery name="insert_note">
        <querytext>
			insert into uv_card_notes (ref_id_card,ref_subtype,value_n,r_community_id)
			values (:card_id, :tipo_act, 0.00, :community_id)
	    </querytext>
    </fullquery>	
	
	
	<fullquery name="update_subtype">
        <querytext>
			update uv_card_subtype_note
			set ref_xcent= :asig_type, name_subtype= :asig_alias
			where id_subtype= :asig_id
	    </querytext>
    </fullquery>	
	
			
	<fullquery name="delete_note">
        <querytext>
			delete from uv_card_notes where ref_subtype= :asig_id
	    </querytext>
    </fullquery>	
	
	<fullquery name="delete_subtype">
        <querytext>
			delete from uv_card_subtype_note where id_subtype= :asig_id		
	    </querytext>
    </fullquery>	
	
	<fullquery name="asig_list">
        <querytext>
			select id_xcent from uv_card_xcent_note where ref_community_id = :community_id
	    </querytext>
    </fullquery>	
	
	<fullquery name="asig_sql">
        <querytext>
			select * from uv_card_subtype_note 
				inner join (uv_card_xcent_note 
					inner join uv_card_basetype_note on ref_basetype = id_basetype) 
				on ref_xcent = id_xcent 
			where uv_card_subtype_note.ref_community_id = :community_id 
			order by xcent desc, name_subtype asc
	    </querytext>
    </fullquery>	
	
	<fullquery name="num_xcent">
        <querytext>
			select count (*) from uv_card_xcent_note where ref_community_id = :community_id
	    </querytext>
    </fullquery>	


	<fullquery name="types_sql">
        <querytext>
			select * from uv_card_xcent_note 
			where ref_community_id = :community_id and ref_basetype <> 3 order by id_xcent
	    </querytext>
    </fullquery>	
	
	<fullquery name="blocs_eval_sql">
        <querytext>
			select * from uv_card_xcent_note 
			where ref_community_id = :community_id order by xcent desc
	    </querytext>
    </fullquery>	

</queryset>
