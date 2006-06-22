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
<DIV class="all">
<div class="comm">@community_name@</div>
<div class="back">
        <A HREF="cards_list" class="back">#cards.card_Back#</A>
</div>
<div class="spacer">&nbsp;</div>


<!-- TABLA DE BLOQUES-->
  <table  class="uv_table" summary="#cards.summary_Assignments_list#">
  <caption class="uv_table">#cards.card_Evaluation_blocks_list#</caption>
  <tr class="uv_table_header">
        <th class="uv_cell" width="4%">Nº</th>
        <th class="uv_cell" width="23%" title="#cards.tooltip_data_type#">#cards.card_Data_type#
                <A HREF="manage_blocks?order=type&order_dir=asc" class="orderby" title="#cards.tooltip_orderby_asc#">
                        <IMG SRC="icons/up.gif" alt="#cards.tooltip_orderby_asc#"></A>
                <A HREF="manage_blocks?order=type&order_dir=desc" class="noline" title="#cards.tooltip_orderby_desc#">
                        <IMG SRC="icons/down.gif" alt="#cards.tooltip_orderby_desc#"></A>
        </th>
        
        <th class="uv_cell" width="45%">#cards.card_Block_name#
                <A HREF="manage_blocks?order=percent_name&order_dir=asc" class="orderby" title="#cards.tooltip_orderby_asc#">
                        <IMG SRC="icons/up.gif" alt="#cards.tooltip_orderby_asc#"></A>
                <A HREF="manage_blocks?order=percent_name&order_dir=desc" class="noline" title="#cards.tooltip_orderby_desc#">
                        <IMG SRC="icons/down.gif" alt="#cards.tooltip_orderby_desc#"></A>
        </th>
                
        
        <th class="uv_cell" width="8%" abbr="#cards.percent#" title="#cards.percent#">%
                <A HREF="manage_blocks?order=percent&order_dir=asc" class="orderby" title="#cards.tooltip_orderby_asc#">
                        <IMG SRC="icons/up.gif" alt="#cards.tooltip_orderby_asc#"></A>
                <A HREF="manage_blocks?order=percent&order_dir=desc" class="noline" title="#cards.tooltip_orderby_desc#">
                        <IMG SRC="icons/down.gif" alt="#cards.tooltip_orderby_desc#"></A>               
        </th>           
        <th class="uv_cell" width="8%" abbr="#cards.restriction#" title="#cards.restriction#"><B>R[>=]</B></th> 
        <if @mode@ eq "edit">
        <th class="uv_cell" width="6%">#cards.card_Accept#</th>
        <th class="uv_cell" width="6%">#cards.card_Cancel#</th> 
        </if><else>
        <th class="uv_cell" width="6%">#cards.card_Edit#</th>
        <th class="uv_cell" width="6%">#cards.card_Delete#</th> 
        </else>
  </tr>
        
  <!-- LLISTEM ELS BLOCS DE LA COMUNITAT -->
  <multiple name="block">
  <!-- SI EL BLOC ACTUAL ES EDITAT -->
  <if @block.percent_id@ eq @block_sel_edit@> 
  <tr class="uv_cell_insert">
        <td class="uv_cell_insert" width="4%" align="center">@block.rownum@</td>        
        <FORM METHOD="post" name="fe" onSubmit ="return validaForm(this)">
        <INPUT type="hidden" name="block_id" value="@block.percent_id@">                
        <!--  ********* type  **********-->             
        <td width="23%" class="uv_cell_insert">
          <SELECT name="block_type">
          <!--<if block.type eq 1><OPTION selected value="1"></if><else><OPTION value="1"></else>Única</OPTION> -->
          <if @block.type@ eq 1><OPTION selected value="1"></if>
                <else><OPTION value="1"></else>Básicas</OPTION> 
          <if @block.type@ eq 2><OPTION selected value="2"></if>
                <else><OPTION value="2"></else>Seleccionables</OPTION>          
          <if @block.type@ eq 3><OPTION selected value="3"></if>
                <else><OPTION value="3"></else>Ponderadas</OPTION>              
          </SELECT></td>
        <!--  ********* name  **********-->
        <td width="45%" class="uv_cell_insert" >
          <INPUT class="edit" type="text" size="50" name="block_name" value="@block.percent_name@"></td>
        <!--  ********* %  **********-->
        <td width="8%" align="center" class="uv_cell_insert">
          <INPUT type="text" size="5" name="block_percent" value="@block.percent@">
                </TD>
        <!--  *********  <=  **********-->                                              
        <td width="8%" align="center" class="uv_cell_insert">
          <INPUT type="text" size="5" name="block_rvalor" value="@block.rvalor@">
        <!--  *********  BOTONES  **********-->                                         
        <td width="6%" class="uv_cell_insert" align="center">           
                <INPUT type="hidden" name="mode" value="">
                <INPUT type="hidden" name="block_type_old" value="@block.type@">
                <INPUT type="hidden" name="order" value="@order@">
                <INPUT type="hidden" name="order_dir" value="@order_dir@">
                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ok.gif" 
                ALT="#cards.tooltip_save_changes#" title="#cards.tooltip_save_changes#" 
                onclick="document.fe.mode.value='update'">              
                
        <td width="6%" class="uv_cell_insert" align="center">
                <INPUT type="image" name="submit" value="submit" size="10" 
                title="#cards.tooltip_discard_changes#" src="icons/ko.gif" 
                ALT="#cards.tooltip_discard_changes#"  onclick="document.fe.mode.value='cancel'"></td>
        </FORM>
        </if><else> <!-- SI LA ASIGNACION ACTUAL NO ES LA EDITADA -->
          <if @block.rownum@ odd>       
                <tr class="list-odd" onmouseover="javascript:style.backgroundColor='#99ccff'" onmouseout="javascript:style.backgroundColor='#EAF2FF'">
          </if><else>
                <tr class="list-even" onmouseover="javascript:style.backgroundColor='#99ccff'" onmouseout="javascript:style.backgroundColor='#FFFFFF'">
          </else>                               
        <td class="uv_cell" width="4%" align="center">@block.rownum@</td>                               
        <td width="23%" class="uv_cell">
        <if @block.type@ eq 1>Básicas</if><if @block.type@ eq 2>Seleccionables</if>
        <if @block.type@ eq 3>Ponderadas</if></td>
        <td width="45%" class="uv_cell">@block.percent_name@</td>
        <td width="8%" align="center" class="uv_cell" >@block.percent@</td>
        <td width="8%" align="center" class="uv_cell" >@block.rvalor@</td>
        <!-- MODE EDIT LINK **************************************************-->       
        <FORM METHOD="post" name="fm" class="p">
        <td width="6%"  height="auto" class="uv_cell" align="center">
                <if @is_edit@ ne 1>
                <INPUT type="hidden" name="block_id" value="@block.percent_id@">
                <INPUT type="hidden" name="mode" value="edit">
                <INPUT type="hidden" name="order" value="@order@">
                <INPUT type="hidden" name="order_dir" value="@order_dir@">
                <INPUT type="image" name="submit" value="submit" border="0" alt="#cards.card_Edit#" title="#cards.card_Edit# #cards.card_Block#" src="icons/edit.gif" style="margin:0;padding:0">               
                </if></td></form>
        <!-- MODE DELETE LINK ****************************************************-->
        <FORM METHOD="post" name="fd" style="height:5px;vertical-align:middle">
        <td width="6%" class="uv_cell" align="center">
                <if @is_edit@ ne 1>
                <INPUT type="hidden" name="block_id" value="@block.percent_id@">
                <INPUT type="hidden" name="mode" value="delete">
                <INPUT type="hidden" name="order" value="@order@">
                <INPUT type="hidden" name="order_dir" value="@order_dir@">
                <INPUT type="image" name="submit" value="submit" border="0" title="#cards.card_Delete# #cards.card_Block#"
                alt="#cards.card_Delete# #cards.card_Block#" src="icons/papelera.gif" style="margin:0;padding:0"
                onclick="return confirm('#cards.card_del_bloc1# @block.percent_name@ #cards.card_del_bloc2#')">         
                </if></td></form>               
        </else>
        </tr>
        </multiple>     

<!-- Aqui va una fila para INSERTAR tipos a no ser que estemos en edición-->
<if @mode@ ne "edit">
        <FORM METHOD="post" name="fi" onSubmit = "return validaForm(this)">
        <!-- <INPUT type="hidden" name="asig_id" value="update">  No estoy seguro de que haga falta -->
        <tr class="uv_cell_insert">
                <td width="4%" align="center" class="uv_cell_insert"><span class="big">*</span></td>
                <td width="23%" class="uv_cell_insert">
                        <SELECT name="block_type">
                                <OPTION value="1">Básicas</OPTION>                              
                                <OPTION value="2">Seleccionables</OPTION>       
                                <OPTION value="3">Ponderadas</OPTION>           
                        </SELECT></td>
                <td width="45%" class="uv_cell_insert">
                        <INPUT type="text" size="55" name="block_name" value="@block_name@"></td>
                <td width="8%" align="center" class="uv_cell_insert">
                        <INPUT type="text" size="5" name="block_percent" value="@block_percent@"></td>
                <td width="8%" align="center" class="uv_cell_insert">
                        <INPUT type="text" size="5" name="block_rvalor" value="@block_rvalor@"></td>                    
                <td width="6%" colspan="2" class="uv_cell_insert"><CENTER>
                        <INPUT type="hidden" name="mode" value="insert">
                        <INPUT type="hidden" name="order" value="@order@">
                        <INPUT type="hidden" name="order_dir" value="@order_dir@">                      
                        <INPUT type="image" name="submit" value="submit" border="0" 
                                title="#dotlrn.New# #cards.card_Block#"  ALT="#dotlrn.New# #cards.card_Block#" 
                                src="icons/plus.gif" style="margin:0;padding:0"></CENTER></td>  
        </tr></form>    


<!-- OPCIONES CONFIRUGACIÓN-->


</if>
        </TABLE>
<if @total@ gt 100><h4 class="total"><U>#cards.card_Total_assigned#</U>:<SPAN class="alert">@total@</span> / 100</h4>
</if> <else>    
<h4 class="total"><U>#cards.card_Total_assigned#</U>: @total@ / 100</h4>
</else>
<div class="spacer">&nbsp;</div>

<UL>
<LI class="config_item"> #cards.card_Allow_students_access#:&nbsp;
        <SPAN CLASS="yes">
        <if @allow_view_grades@ eq 1>
                #cards.yes# | <A HREF="manage_blocks?mode=allow&alum_view=0">#cards.no#</A>
        </if><else>
                <A HREF="manage_blocks?mode=allow&alum_view=1">#cards.yes#</A> | #cards.no# 
        </else>
        </SPAN>
<if @subgroup@ eq 1>
<LI class="config_item"> #cards.card_reuse_parent_cards#:&nbsp;
        <SPAN CLASS="yes">
        <if @reuse_parent_cards@ eq 1>
                #cards.yes# | <A HREF="manage_blocks?mode=reuse&reuse_cards=0">#cards.no#</A>
        </if><else>
                <A HREF="manage_blocks?mode=reuse&reuse_cards=1">#cards.yes#</A> | #cards.no# 
        </else>
        </SPAN>
</if>   
</UL>

<BR><BR>
<if @error@>
<SCRIPT>
eval ("@cambia@")
eval("@senyala@" + "'#ffcc00'")
alert("@msg_error@")


</SCRIPT>
</if>
