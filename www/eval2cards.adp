<!-- <master>  -->
<SCRIPT LANGUAGE="JavaScript">
<!-- Original:  Paco Soler -->
<!-- Begin
function validaForm (f) {
        if (f.mode.value == "cancel") {
                f.block_name.value = "";
                f.block_percent.value = 0;
                f.block_rvalor.value = 0;
                return true;
        } else {
        error = 0
        if (f.block_name.value == "" || f.block_name.value == " ") {
                f.block_name.style.backgroundColor="#ffcc00";
                error = 1
        } else {f.block_name.style.backgroundColor="#ffffff";}
        if (isNaN(f.block_percent.value) || parseInt(f.block_percent.value) > 100 || parseInt(f.block_percent.value) < 0) {
                        f.block_percent.style.backgroundColor="#ffcc00";
                        error = 2
        } else {f.block_percent.style.backgroundColor="#ffffff";}
        if (isNaN(f.block_rvalor.value) || parseInt(f.block_rvalor.value) > 10 || parseInt(f.block_rvalor.value) < 0){          
                        f.block_rvalor.style.backgroundColor="#ffcc00"
                        error = 3                       
        } else {f.block_rvalor.style.backgroundColor="#ffffff";}

        if (error > 0) { alert ("#cards.card_Invalid_data#");return false}
        else return true
        }
}       
        
//  End -->
</script>

<link rel="stylesheet" href="cards.css" type="text/css">
<!-- CABECERA -->
<DIV id="all" class="all">
<!-- CABECERA -->
        <div class="comm">@community_name@</div>
        <div class="back">
                <A HREF="cards_list" class="back">#cards.card_Back#</A>
        </div>

<div class="spacer">&nbsp;</div>


<H2 style="color:darkblue">#cards.import_grades_from_eval#</H2>

<!-- package_id = @package_id
TABLA DE TAREAS EVALUATION&CARDS-->
<if @mode@ eq 'update'>

</if>
<else>

<if @taskXgrade:rowcount@ ne 0 and @taskXbloc:rowcount@ ne 0>
<P style="width:65%">#cards.eval2card_info#</P>

<FORM METHOD="post" name="task_notes">
<P><B>#cards.select_evaluation_task#</B><BR>
<SELECT name="e_task">
  <multiple name="taskXgrade">
        <OPTION selected value="@taskXgrade.task_item_id@">@taskXgrade.egt_name@</OPTION>       
  </multiple>
</SELECT>

<P><B>#cards.select_card_task#</B><BR>
<SELECT name="c_task">
  <multiple name="taskXbloc">
        <OPTION selected value="@taskXbloc.task_id@">@taskXbloc.cbt_name@</OPTION>      
  </multiple>
</SELECT>
<BR>
<input type="hidden" name="mode" value="update">                
<P><INPUT TYPE="SUBMIT" VALUE="#cards.Import_grades_#" onClick="return confirm('#cards.import_grades_confirm#')">
</form>

</if>
<else>#cards.no_tasks_to_import#</else>

</else>
