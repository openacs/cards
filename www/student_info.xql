<?xml version="1.0"?>
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="student_name">
        <querytext>
                        select last_name, first_names 
                        from acs_users_all 
                        where user_id = :user_id
            </querytext>
    </fullquery>

<fullquery name="select_found_card">
    <querytext>
                select * from card 
                where ref_user= :user_id and ref_community= :community_id
        </querytext>
</fullquery>    


</queryset>

