<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="insert_blocks">
        <querytext>
                insert into card_percent
                        (ref_community, type, percent_name, percent, rvalor)
                values
                        (:community_id, :block_type, :block_name, :block_percent, :block_rvalor)
        </querytext>
</fullquery>

<fullquery name="select_blocks">
        <querytext>
                select * from card_percent where ref_community = :community_id 
                order by $order $order_dir      
        </querytext>
</fullquery>


<fullquery name="t_sel">
        <querytext>
                 select * from card_percent where percent_id = :block_id
            </querytext>
</fullquery>    


<fullquery name="update_block">
        <querytext>
                update card_percent
            set percent_name= :block_name, percent= :block_percent, 
                                type= :block_type, rvalor= :block_rvalor
                        where percent_id= :block_id
        </querytext>
</fullquery>    


        <fullquery name="select_notes">
        <querytext>
                        select task_id from card_task
                        where ref_percent = :block_id
            </querytext>
    </fullquery>        
        

        <fullquery name="delete_note">
        <querytext>
                        delete from card_note where ref_task= :del_i
            </querytext>
    </fullquery>        


        <fullquery name="delete_block_tasks">
        <querytext>
                        delete from card_task where ref_percent= :block_id 
            </querytext>
    </fullquery>        
        
        <fullquery name="delete_block">
        <querytext>
                        delete from card_percent where percent_id= :block_id
            </querytext>
    </fullquery>                


        <fullquery name="found_block_i">
        <querytext>
                        select percent_id from card_percent 
                        where ref_community = :community_id and percent_name = :block_name
                </querytext>
    </fullquery>        
        
        <fullquery name="found_block_u">
        <querytext>
                        select percent_id from card_percent 
                        where   ref_community = :community_id and 
                                        percent_name = :block_name 
                                        and percent_id <> :block_id
                </querytext>
    </fullquery>                

        
        <fullquery name="total_percent">
        <querytext>
                        select sum (percent) as total_p from card_percent 
                        where   ref_community = :community_id
                                        
                </querytext>
    </fullquery>

        
        <fullquery name="update_task_percent">
        <querytext>
                        update card_task
            set task_percent= :new_percent
                        where ref_percent= :block_id
                </querytext>
    </fullquery>        

</queryset>
