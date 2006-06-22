
<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>
        
        <fullquery name="select_blocks">
                <querytext>
                        select * from card_percent
                        where ref_community = :community_id
                        order by percent desc
            </querytext>
    </fullquery>        

<fullquery name="get_teacher_mail">
    <querytext>
                select email as teacher_email from acs_users_all where user_id = :my_user_id
        </querytext>
</fullquery>    



<fullquery name="get_student_mail">
    <querytext>
                select email as student_email from acs_users_all where user_id = :user_id
        </querytext>
</fullquery>    


<fullquery name="update_last_sendmail">
    <querytext>
                update card set 
                comm_teacher = :comment
                where ref_community = :community_id and
                card_id = :card_id
        </querytext>
</fullquery>    


        <fullquery name="insert_comment">
        <querytext>
                        insert into card_comment
                        (ref_card, ref_community, date, date_mod, comment) 
                        values(:card_id, :community_id, :date, :date, :comment) 
                </querytext>
    </fullquery>        
        
        
        <fullquery name="update_comment">
        <querytext>
                        update card_comment
                        set comment = :comment, date_mod = :date
                        where comment_id = :comment_id          
            </querytext>
    </fullquery>        
        
        <fullquery name="delete_comment">
        <querytext>
                        delete from card_comment 
                        where comment_id = :comment_id
            </querytext>
    </fullquery>

        <fullquery name="update_note">
        <querytext>
                        update card_note
                        set note_comment = :note_comment, date_mod = :date, grade = :note_grade, is_active= :note_actv
                        where note_id = :note_id                
            </querytext>
    </fullquery>                

        <fullquery name="update_teacher_comment">
    <querytext>
                update card set 
                comm_teacher = :teacher_comment
                where ref_community = :community_id and
                card_id = :card_id
        </querytext>
        </fullquery>    


        
</queryset>

