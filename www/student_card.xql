
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


<fullquery name="update_student_info">
    <querytext>
                update card set 
                address = :user_address,
                phone1 = :user_phones
                where ref_community = :community_id and
                card_id = :card_id
        </querytext>
</fullquery>    

<fullquery name="update_student_comment">
    <querytext>
                update card set 
                comm_student = :student_comment
                where ref_community = :community_id and
                card_id = :card_id
        </querytext>
        </fullquery>            
        
        
</queryset>

