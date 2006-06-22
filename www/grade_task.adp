<master>
<SCRIPT LANGUAGE="JavaScript">
<!--
function convertComma(str){
var out = "", flag = 0;

for (i = 0; i < str.length; i++) {
        if (str.charAt(i) != ",") {
                out += str.charAt(i);
                flag = 0;
        } else {
                if(flag == 0) {
                        out += ".";
                        flag = 1;
                }
        }
}

if (isNaN(out) || str == "") {
        out = 0.00
} 

return out;
}
-->
</script>

<link rel="stylesheet" href="cards.css" type="text/css">
<!-- CABECERA -->
<DIV class="all">
<div class="comm">@community_name@</div>
<div class="back">
        <A HREF="@return_url@" class="back">#cards.card_Back#</A>
</div>
<div class="spacer">&nbsp;</div>

<div class="all">

<if @mode@ eq "edit">
<H3 style="color:#6186B0">#cards.task_grade_edit# @task_name@<BR>
#cards.card_task_max_grade#: @max_grade@</h3>
<form name="gt" action="" method="post">
                <input type="hidden" name="task_id" value="@task_id@">
                <input type="hidden" name="mode" value="update">
                <listtemplate name="task_grades"></listtemplate>
                @task_grades:rowcount@ #cards.card_Students#<BR><BR>
                <INPUT type="submit" value="#cards.send_task_grades#" 
                onclick="document.gt.mode.value='update'" title="#cards.tooltip_save_changes#"></FORM>
                <FORM action="manage_tasks">
                <INPUT type="submit" value="#cards.card_Cancel#" title="#cards.tooltip_discard_changes#"></FORM>
</form>
</if>


<if @mode@ eq "update">
<H3 style="color:#6186B0">#cards.task_grades_act# 
        <if @mode2@ eq "eval"> #cards.from_eval#</if>: @task_name@      
        <BR>#cards.card_task_max_grade#: @max_grade@</h3>
<listtemplate name="task_grades"></listtemplate>
        @task_grades:rowcount@ #cards.card_Students#<BR><BR>
<div class="back_l">
        <A HREF="@return_url@" class="back">#cards.card_Back#</A>
</div>
<BR><BR>        
        
</if>
</div>

<if @error@>
        <SCRIPT>alert("@msg_error@")</SCRIPT>
</if>
