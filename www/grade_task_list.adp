<link rel="stylesheet" type="text/css" href="/resources/acs-templating/lists.css" media="all" />
<link rel="stylesheet" href="cards.css" type="text/css">

<DIV class="all">
<!-- CABECERA -->
        
        <H3 class="black">@community_name@<BR>@task_name@ 
        <span class="small">[#cards.card_task_max_grade#: @max_grade@]</span></h3>

        <DIV>   
                <listtemplate name="task_grades"></listtemplate>
                <P>@task_grades:rowcount@ #cards.card_Students#
        <DIV>   

        <div class="back_l">
        <A HREF="manage_tasks" class="back">#cards.card_Back#</A>
        </div>
        <BR><BR>        
        
</div>

<if @error@>
        <SCRIPT>alert("@msg_error@")</SCRIPT>
</if>
