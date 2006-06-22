<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>


        <fullquery name="found_task_i">
        <querytext>
                        select  task_id from card_task 
                        where   ref_community = :community_id and 
                                        task_name = :task_name and
                                        ref_percent = :task_block
                </querytext>
    </fullquery>        
        

        <fullquery name="found_task_u">
        <querytext>
                        select  task_id from card_task 
                        where   ref_community = :community_id and 
                                        task_name = :task_name and
                                        ref_percent = :task_block
                                        and task_id <> :task_id
                </querytext>
    </fullquery>


        <fullquery name="select_tasks">
        <querytext>
                        select t.*,p.percent_id, p.type, p.percent_name
                        from card_task t 
                        inner join card_percent p on (percent_id = ref_percent) 
                        where t.ref_community = :community_id
                        order by $order $order_dir
                </querytext>
    </fullquery>
        
        <fullquery name="select_blocks">
        <querytext>
                        select *                        
                        from card_percent p 
                        where p.ref_community = :community_id
                        order by type asc
                </querytext>
    </fullquery>

        <fullquery name="select_tasks_by_percent">
        <querytext>
                        select  * from card_task 
                        where   ref_community = :community_id and
                                        ref_percent = :nav_sel
                                        order by $order $order_dir
                </querytext>
        </fullquery>

        
        <fullquery name="insert_task">
        <querytext>
                insert into card_task
                        (ref_community, ref_percent, task_name, task_percent, max_grade)
                values
                        (:community_id, :task_block, :task_name, :task_percent, :task_max_grade)
                </querytext>
    </fullquery>
                
        <fullquery name="update_task">
        <querytext>
                        update card_task set 
                                ref_percent = :task_block, task_name = :task_name, 
                                task_percent= :task_percent, max_grade= :task_max_grade
                        where ref_community = :community_id and
                                task_id = :task_id
                </querytext>
    </fullquery>
        
        <fullquery name="delete_task">
        <querytext>
                        delete from card_task where task_id = :task_id 
            </querytext>
    </fullquery>        

        <fullquery name="delete_notes">
        <querytext>
                        delete from card_note where ref_task= :task_id
            </querytext>
    </fullquery>        
        
        <fullquery name="get_percent_type">
        <querytext>
                        select type as sel_type from card_percent where percent_id = :act_ref_percent
            </querytext>
    </fullquery>                
        
</queryset>
        
