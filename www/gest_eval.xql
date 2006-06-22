<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>
	
	<fullquery name="update_base_note">
        <querytext>
			update uv_card_base_note
			set base_note= 100,  alum_view= :alum_view
			where community_id= :community_id
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
	
	<fullquery name="nom_bloc">
        <querytext>
			select name_xcent 
			from uv_card_xcent_note 
			where ref_community_id = :community_id and name_xcent = :asig_alias
	    </querytext>
    </fullquery>
	
	<fullquery name="insert_xcent">
        <querytext>
			insert into uv_card_xcent_note
				(ref_community_id, ref_basetype, name_xcent, xcent, allow_act, rvalor,np)
            values
                (:community_id, :asig_type, :asig_alias, :asig_percent, :asig_act, :asig_rvalor, :asig_np)      
	    </querytext>
    </fullquery>

	<fullquery name="num_xcent">
        <querytext>
			select id_xcent from uv_card_xcent_note 
			where ref_community_id = :community_id 
			and name_xcent = :asig_alias 
			and ref_basetype = :asig_type
	    </querytext>
    </fullquery>
	                
	<fullquery name="insert_subtype">
        <querytext>
			insert into uv_card_subtype_note
				(ref_community_id, name_subtype, ref_xcent)
            values
                (:community_id, :asig_alias, :id_xcent) 
	    </querytext>
    </fullquery>	
	
	
		<fullquery name="update_xcent">
        <querytext>
			update uv_card_xcent_note
            set ref_basetype= :asig_type, xcent= :asig_percent,
				name_xcent= :asig_alias, allow_act= :asig_act,
				rvalor= :asig_rvalor, np= :asig_np
            where id_xcent= :asig_id
	    </querytext>
    </fullquery>	
	
	
	<fullquery name="del_notes">
        <querytext>
			select id_subtype from uv_card_subtype_note
			where ref_xcent = :asig_id
	    </querytext>
    </fullquery>	
	


	<fullquery name="delete_card_note">
        <querytext>
			delete from uv_card_notes where ref_subtype= :del_i
	    </querytext>
    </fullquery>	

	<fullquery name="delete_subtype">
        <querytext>
			delete from uv_card_subtype_note where ref_xcent= :asig_id 
	    </querytext>
    </fullquery>	
	
	<fullquery name="delete_xcent">
        <querytext>
			delete from uv_card_xcent_note where id_xcent= :asig_id
	    </querytext>
    </fullquery>		
	
	
 
 
	
	<fullquery name="types_sql">
        <querytext>
			select * from uv_card_basetype_note order by id_basetype
	    </querytext>
    </fullquery>	
	
	<fullquery name="blocs_sql">
        <querytext>
			select * from uv_card_xcent_note where ref_community_id = :community_id order by id_xcent
	    </querytext>
    </fullquery>		
	
	<fullquery name="asig_sql">
        <querytext>
			select * from uv_card_xcent_note 
				inner join uv_card_basetype_note on 
					(uv_card_basetype_note.id_basetype = uv_card_xcent_note.ref_basetype) 
			where uv_card_xcent_note.ref_community_id = :community_id 
			order by uv_card_xcent_note.xcent desc
	    </querytext>
    </fullquery>	
	
	<fullquery name="asig_list">
        <querytext>
			select id_xcent from uv_card_xcent_note 
			where ref_community_id = :community_id
	    </querytext>
    </fullquery>	

	<fullquery name="t_sel">
        <querytext>
		 select * from uv_card_xcent_note where id_xcent = :asig_id
	    </querytext>
    </fullquery>	
	
	<fullquery name="total_xc">
        <querytext>
			select sum(uv_card_xcent_note.xcent) as total
			from uv_card_xcent_note 
			where uv_card_xcent_note.ref_community_id = :community_id
	    </querytext>
    </fullquery>		
</queryset>

