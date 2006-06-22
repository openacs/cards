<!-- <master>  -->
<SCRIPT LANGUAGE="JavaScript">
<!-- Original:  Paco Soler -->
<!-- Begin
function validaForm (f) {
  if (f.mode.value == "cancel") {
        f.task_name.value = "";
        f.task_percent.value = 0;
        f.task_max_grade.value = 0;
        return true;
  } else {
        error = 0
        if (f.task_name.value == "" || f.task_name.value == " ") {
          f.task_name.style.backgroundColor="#ffcc00";
          error = 1
        } else {
          f.task_name.style.backgroundColor="#ffffff";
        }
        if (f.task_percent.value != "auto") {
        
        if (isNaN(f.task_percent.value) || parseInt(f.task_percent.value) > 100 || parseInt(f.task_percent.value) <= 0) {
                        f.task_percent.style.backgroundColor="#ffcc00";
                        error = 2
        } else {f.task_percent.style.backgroundColor="#ffffff";}
        }
        if (isNaN(f.task_max_grade.value) || parseInt(f.task_max_grade.value) <= 0){            
                        f.task_max_grade.style.backgroundColor="#ffcc00"
                        error = 3                       
        } else {f.task_max_grade.style.backgroundColor="#ffffff";}

        if (error > 0) { alert ("#cards.card_Invalid_data#");return false}
        else return true
        }
        
}       
        
//  End -->
</script>

<link rel="stylesheet" href="cards.css" type="text/css">
<!-- CABECERA -->
<DIV class="all">
<div class="comm">@community_name@</div>
<div class="back">
        <A HREF="cards_list" class="back">#cards.card_Back#</A>
</div>
<div class="spacer">&nbsp;</div>

<if @block:rowcount@ eq 0>
<h4 style="color:#6186b0">&nbsp;#cards.card_tasks_list#</h4><BR>
<A href="manage_blocks">#cards.blocks_first#</a>
</if><else>


<!-- TABLA DE TAREAS / ANOTACIONES -->

<table  class="uv_table" summary="#cards.summary_Task_list#">
  <caption class="uv_table">#cards.card_tasks_list#</caption>
  <tr class="uv_table_header">
        <th class="uv_cell" width="4%" align="center"><B>Nº</B></th>
        <th class="uv_cell" width="23%" align="left" title="#cards.tooltip_block_of_task#">#cards.card_task_block#
                <A HREF="manage_tasks?order=ref_percent&order_dir=asc" class="orderby" 
                        title="#cards.tooltip_orderby_asc#">
                        <IMG SRC="icons/up.gif" alt="#cards.tooltip_orderby_asc#"></A>
                <A HREF="manage_tasks?order=ref_percent&order_dir=desc" class="noline"
                        title="#cards.tooltip_orderby_desc#">
                        <IMG SRC="icons/down.gif" alt="#cards.tooltip_orderby_desc#"></A>
        </th>
        
        <th class="uv_cell" width="45%" align="left">#cards.card_task_name#
                <A HREF="manage_tasks?order=task_name&order_dir=asc" class="orderby" 
                        title="#cards.tooltip_orderby_asc#">
                        <IMG SRC="icons/up.gif" alt="#cards.tooltip_orderby_asc#"></A>
                <A HREF="manage_tasks?order=task_name&order_dir=desc" class="noline"
                        title="#cards.tooltip_orderby_desc#">
                        <IMG SRC="icons/down.gif" alt="#cards.tooltip_orderby_desc#"></A>
        </th>
        <th class="uv_cell" width="8%" align="center" abbr="#cards.percent#" title="#cards.percent#">%</th>     
                <th class="uv_cell" width="10%" align="center" title="#cards.tooltip_max_grade#">#cards.card_task_max_grade#</th>       
        <if @mode@ eq "edit">
        <th class="uv_cell" width="5%" align="center"><B>#cards.card_Accept#</B></th>
        <th class="uv_cell" width="5%" align="center" style="padding:4px"><B>#cards.card_Cancel#</B></th>       
        </if><else>
        <th class="uv_cell" width="5%" align="center"><B>#cards.card_Edit#</B></th>
        <th class="uv_cell" width="5%" align="center" style="padding:4px"><B>#cards.card_Delete#</B></th>       
        </else>
  </tr>
        
  <!-- LLISTEM LES TASKS  DE LA COMUNITAT -->
  <multiple name="task">
  <!-- SI EL BLOC ACTUAL ES EDITAT -->
  <if @task.task_id@ eq @task_sel_edit@> 
  <tr class="uv_cell_insert">
        <td class="uv_cell_insert" width="4%" align="center">@task.rownum@</td>    
        <FORM METHOD="post" name="fe" onSubmit ="return validaForm(this)">
        <INPUT type="hidden" name="task_id" value="@task.task_id@">             
        <!--  ********* type  **********-->             
        <td width="23%" class="uv_cell_insert">
          <SELECT name="task_block_type" onchange="if(this.options[this.selectedIndex].value.split('-')[1] !=3) {fe.task_percent.disabled = true;fe.task_percent.value = 'auto'}        else {fe.task_percent.disabled = false; fe.task_percent.value = 0} fe.task_block.value = this.options[this.selectedIndex].value.split('-')[0]">
                <multiple name="block">
                  <if @block.percent_id@ eq @task.ref_percent@>
                        <OPTION selected value="@block.percent_id@-@block.type@">@block.percent_name@                           
                  </if>
                  <else><OPTION value="@block.percent_id@-@block.type@">@block.percent_name@</else>
                </multiple>
          </SELECT></td>
        <!--  ********* name  **********-->
        <td width="45%" class="uv_cell_insert" >
          <INPUT type="text" size="50" name="task_name" value="@task.task_name@"></td>
        <!--  ********* %  **********-->
        <td width="8%" align="center" class="uv_cell_insert">           
                <if @task.type@ ne 3><INPUT type="text" size="5" name="task_percent" value="auto" disabled></if>
                <else><INPUT type="text" size="5" name="task_percent" value="@task.task_percent@"></else>
        </TD>
        <!--  *********  <=  **********-->                                              
        <td width="8%" align="center" class="uv_cell_insert">
          <INPUT type="text" size="5" name="task_max_grade" value="@task.max_grade@">
        <!--  *********  BOTONES  **********-->                                         
        <td width="6%" class="uv_cell_insert" align="center">           
                <INPUT type="hidden" name="mode" value="">
                <INPUT type="hidden" name="task_block" value="@task.ref_percent@">
                <INPUT type="hidden" name="order" value="@order@">
                <INPUT type="hidden" name="order_dir" value="@order_dir@">
                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ok.gif" 
                ALT="#cards.tooltip_save_changes#" title="#cards.tooltip_save_changes#" 
                onclick="document.fe.mode.value='update'">              
                
        <td width="6%" class="uv_cell_insert" align="center">
                <INPUT type="image" name="submit" value="submit" 
                size="10" title="#cards.tooltip_discard_changes#" ALT="#cards.tooltip_discard_changes#"
                src="icons/ko.gif" onclick="document.fe.mode.value='cancel'"></td>
        </FORM>
        </if><else> <!-- SI LA ASIGNACION ACTUAL NO ES LA EDITADA -->
          <if @task.rownum@ odd>        
                <tr class="list-odd" onmouseover="javascript:style.backgroundColor='#99ccff'" onmouseout="javascript:style.backgroundColor='#EAF2FF'">
          </if><else>
                <tr class="list-even" onmouseover="javascript:style.backgroundColor='#99ccff'" onmouseout="javascript:style.backgroundColor='#FFFFFF'">
          </else>                               
        <td class="uv_cell" width="4%" align="center">@task.rownum@</td>                                
        <td width="23%" class="uv_cell">@task.percent_name@</td>
        <td width="45%" class="uv_cell">
        <a href="grade_task_list?task_id=@task.task_id@&mode=list"
                class="noline" title="#cards.tooltip_list_to_print#">
        <IMG src="icons/listado.gif" alt="#cards.tooltip_list_to_print#"></a>&nbsp;
        <a href="grade_task_list?task_id=@task.task_id@&mode=csv" 
                class="noline" title="#cards.tooltip_csv#">
        <IMG src="icons/csv.gif" alt="#cards.tooltip_csv#"></a>&nbsp;&nbsp;&nbsp;
        <A HREF="grade_task?task_id=@task.task_id@" class="noline"
                title="#cards.tooltip_grade_students#">@task.task_name@</a></td>
        <td width="8%" align="center" class="uv_cell" >
                <if @task.type@ ne 3>auto</if>
                <else>@task.task_percent@</else></td>
        <td width="8%" align="center" class="uv_cell" >@task.max_grade@</td>
        <!-- MODE EDIT LINK **************************************************-->       
        <FORM METHOD="post" name="fm" class="p">
        <td width="6%"  height="auto" class="uv_cell" align="center">
                <if @is_edit@ ne 1>
                <INPUT type="hidden" name="task_id" value="@task.task_id@">
                <INPUT type="hidden" name="mode" value="edit">
                <INPUT type="hidden" name="order" value="@order@">
                <INPUT type="hidden" name="order_dir" value="@order_dir@">
                <INPUT type="image" name="submit" value="submit" border="0" alt="#cards.card_Edit#" 
                title="#cards.card_Edit# #cards.card_task#" src="icons/edit.gif" 
                style="margin:0;padding:0">             
                </if></td></form>
        <!-- MODE DELETE LINK ****************************************************-->
        <FORM METHOD="post" name="fd" style="height:5px;vertical-align:middle">
        <td width="6%" class="uv_cell" align="center">
                <if @is_edit@ ne 1>
                <INPUT type="hidden" name="task_id" value="@task.task_id@">
                <INPUT type="hidden" name="mode" value="delete">
                <INPUT type="hidden" name="order" value="@order@">
                <INPUT type="hidden" name="order_dir" value="@order_dir@">
                <INPUT type="image" name="submit" value="submit" border="0" 
                title="#cards.card_Delete# #cards.card_task#" alt="#cards.card_Delete# #cards.card_task#" 
                src="icons/papelera.gif" style="margin:0;padding:0" onclick="return confirm('#cards.card_del_note1# @task.task_name@ #cards.card_del_note2#')">
                </if></td></form>               
        </else>
        </tr>
        </multiple>     

<!-- Aqui va una fila para INSERTAR tipos a no ser que estemos en edición-->
<if @mode@ ne "edit">
        <FORM METHOD="post" name="fi"  onSubmit ="return validaForm(this)">
        <!-- <INPUT type="hidden" name="asig_id" value="update">  No estoy seguro de que haga falta -->
        <tr class="uv_cell_insert">
                <td width="4%" align="center" class="uv_cell_insert"><span class="big">*</span></td>
                <td width="23%" class="uv_cell_insert">                 
                <SELECT name="task_block_type" onchange="if(this.options[this.selectedIndex].value.split('-')[1] !=3) {fi.task_percent.disabled = true;fi.task_percent.value = 'auto'}  else {fi.task_percent.disabled = false; fi.task_percent.value = 0} fi.task_block.value = this.options[this.selectedIndex].value.split('-')[0]">
                                <multiple name="block">
                                        <OPTION value="@block.percent_id@-@block.type@">@block.percent_name@</OPTION>   
                                </multiple>     
                        </SELECT>
                </td>
                <td width="45%" class="uv_cell_insert">
                        <INPUT type="text" size="55" name="task_name" value="@task_name_sel@"></td>
                <td width="8%" align="center" class="uv_cell_insert">
                        <if @task_type_sel@ ne 3>
                        <INPUT type="text" size="5" name="task_percent" value="auto" disabled>
                        </if><else>
                        <INPUT type="text" size="5" name="task_percent" value="0"></else>
                        </td>
                <td width="8%" align="center" class="uv_cell_insert">
                        <INPUT type="text" size="5" name="task_max_grade" value="@task_max_grade@"></td>                        
                <td width="6%" colspan="2" class="uv_cell_insert"><CENTER>
                        <INPUT type="hidden" name="mode" value="insert">
                        <INPUT type="hidden" name="task_block" value="@task_percent_sel@">                      
                        <INPUT type="hidden" name="order" value="@order@">
                        <INPUT type="hidden" name="order_dir" value="@order_dir@">
                        <INPUT type="image" name="submit" value="submit" border="0" 
                                title="#dotlrn.New# #cards.card_task#"  ALT="#dotlrn.New# #cards.card_task#" 
                                src="icons/plus.gif" style="margin:0;padding:0"></CENTER></td>
        </tr></form>
</if>

</TABLE>

</ELSE>
<BR><BR>
<if @error@>
<SCRIPT>
eval ("@cambia@")
eval("@senyala@" + "'#ffcc00'")
alert("@msg_error@")


</SCRIPT>
</if>
