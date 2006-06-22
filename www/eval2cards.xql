<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_evaluation_pid">      
        <querytext>
                select object_id as package_id 
                from acs_objects o, apm_packages p 
                where o.object_id = p.package_id and p.package_key = 'evaluation' 
                and o.context_id = (select package_id from dotlrn_communities_all 
                                                        where community_id = :community_id)
    </querytext>
</fullquery>
   
<fullquery name="get_class_grades">      
      <querytext>
            select eg.grade_id, eg.item_id,     eg.grade_plural_name,
                eg.comments,eg.weight
            from evaluation_gradesx eg, acs_objects ao
                where content_revision__is_live(eg.grade_id) = true
          and eg.item_id = ao.object_id
                  and ao.context_id = :package_id
                $orderby
      </querytext>
</fullquery>

<fullquery name="get_taskXgrades">      
      <querytext>
        select eg.grade_name || ' : ' || task_name as egt_name, eg.grade_id, eg.item_id, eg.weight, 
                task_id, task_item_id
        from evaluation_gradesx eg, acs_objects ao, evaluation_tasks et 
        where   content_revision__is_live(eg.grade_id) = true and 
                        content_revision__is_live(task_id) = true and 
                        eg.item_id = ao.object_id and
                        ao.context_id = :package_id and 
                        et.grade_item_id = eg.grade_item_id
      </querytext>
</fullquery>

<fullquery name="get_taskXbloc">      
      <querytext>
                select p.percent_name || ' : ' || t.task_name as cbt_name, 
                        t.task_id, p.percent_id 
                from card_percent p, card_task t 
                where t.ref_community = p.ref_community and 
                        p.ref_community = :community_id and p.percent_id = t.ref_percent;
      </querytext>
</fullquery>

<fullquery name="get_task_notes">      
      <querytext>
                        select *, (select description from  evaluation_student_evalsx where evaluation_id=ev.evaluation_id) as comments from evaluation_student_evals ev where task_item_id = :e_task
      </querytext>
</fullquery>

<fullquery name="update_c_task">      
    <querytext>
                update card_note set grade = :grade, note_comment = :comments
                        where ref_task = :c_task and
                                ref_card = :card_id and
                                ref_community = :community_id
     </querytext>
</fullquery>

<fullquery name="get_perfect_score">      
      <querytext>
                select perfect_score 
                from evaluation_tasks, cr_items 
                where task_item_id = item_id and 
                        live_revision = task_id and 
                        task_item_id = :e_task
      </querytext>
</fullquery>

<fullquery name="get_max_grade">      
      <querytext>
                        select max_grade from card_task where task_id = :c_task
      </querytext>
</fullquery>

<fullquery name="get_group_members">      
      <querytext>
                        select p.person_id as party_id from persons p, acs_rels map where p.person_id = map.object_id_two and map.object_id_one = :party_id
      </querytext>
</fullquery>


<fullquery name="get_card_id">      
      <querytext>
                        select card_id from card where ref_community = :community_id and ref_user = :party_id
      </querytext>
</fullquery>




</queryset>
