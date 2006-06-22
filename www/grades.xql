<?xml version="1.0"?>
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>        

        <fullquery name="select_comment">
        <querytext>
                        select * from card_comment 
                        where ref_card = :card_id and
                        ref_community = :community_id
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
                        select * from card_percent where ref_community= :community_id order by percent desc
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
        

</queryset>

                        
