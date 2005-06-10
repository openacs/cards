<!-- <master>  --><!-- #dotlrn.gestion_evaluacion_name# -->
<SCRIPT LANGUAGE="JavaScript">
<!-- Original:  Paco Soler -->
<!-- Begin

function validaNum (campo, valor, max, min , txt) {

if (isNaN(valor) || valor == " " || valor == "" || parseInt(valor) < min || parseInt(valor) > max) {
	alert("#cards.card_Invalid_value1#" + txt + "#cards.card_Invalid_value2#" + max + ".");
	campo.select();
	campo.style.backgroundColor="#ffcc00"
}
	else{campo.style.backgroundColor="#ffffff"
	} 
}

function validaForm (f) {
	if (f.mode_cancel.value == "mode_cancel") {
		f.asig_alias.value = "";
		f.asig_percent.value = 0;
		f.asig_rvalor.value = 0;
		return true;
	} else {
	error = 0
	if (f.asig_alias.value == "" || f.asig_alias.value == " ") {
		f.asig_alias.style.backgroundColor="#ffcc00";
		error = 1
	} else {f.asig_alias.style.backgroundColor="#ffffff";}
	if (isNaN(f.asig_percent.value) || parseInt(f.asig_percent.value) > 100 || parseInt(f.asig_percent.value) < 0) {		
			f.asig_percent.style.backgroundColor="#ffcc00";
			error = 2
	} else {f.asig_percent.style.backgroundColor="#ffffff";}
	if (isNaN(f.asig_rvalor.value) || parseInt(f.asig_rvalor.value) > 10 || parseInt(f.asig_rvalor.value) < 0){			
			f.asig_rvalor.style.backgroundColor="#ffcc00"
			error = 3			
	} else {f.asig_rvalor.style.backgroundColor="#ffffff";}

	if (error > 0) { alert ("#cards.card_Invalid_data#");return false}
	else return true
	}
}	

//  End -->
</script>
<!--		a lert ("Nombre de bloque no válido. Inténtalo de nuevo.");
		a lert ("Porcentaje no válido. Inténtalo de nuevo.");
		a lert ("Restricción no válida. Inténtalo de nuevo.");-->

<link rel="stylesheet" href="cards.css" type="text/css">
<TABLE width="100%">
<TR>
<TD style="font-weight:bold">
<div class="volver">&nbsp;&nbsp;#cards.card_Subjet#: <%= [dotlrn_community::get_community_description -community_id $community_id] %>&nbsp;&nbsp; <!--  - community_id --></div></TD>
<TD ALIGN="RIGHT">
<div class="volver">
<A HREF="cards" class="t" style="color:#ffffff;font-weight:bold">&nbsp;&nbsp;#cards.card_Back#&nbsp;&nbsp;</A></div></TD></TR>
</TABLE>
<DIV style="width:100%">
<!-- AQUI VA LA GESTIÓN DE BLOQUES -->
<table width="100%" cellpadding="5" cellspacing="0" border="0">
<TR>
	<TD COLSPAN="3"><h4 style="color:#6186b0">&nbsp;#cards.card_Evaluation_blocks_list#</h4>
	<table  class="list" width="100%" cellpadding="3" cellspacing="1" border="0">
    <tr class="list-header">
		<th class="list_c" width="4%" align="center" ><B>Nº</B></th>
		<th class="list_c" width="15%" align="left"><B>#cards.card_Data_type#</B></th>
		<th class="list_c" width="45%" align="left"><B>#cards.card_Block_name#</B></th>
		<th class="list_c" width="8%" align="center"><B>%</B></th>
		<th class="list_c" width="8%" align="center"><B>NP</B></th>	
		<th class="list_c" width="8%" align="center"><B>R[>=]</B></th>	
		<if @is_edit@ ne 1>
		<th class="list_c" width="6%" align="center"><B>#cards.card_Edit#</B></th>
		<th class="list" width="6%" align="center" style="padding:4px"><B>#cards.card_Delete#</B></th>	
		</if><else>
		<th class="list_c" width="6%" align="center"><B>#cards.card_Accept#</B></th>
		<th class="list" width="6%" align="center" style="padding:4px"><B>#cards.card_Cancel#</B></th>	
		</else>
		<!-- <td>#dotlrn.id_type_note_name#</td>  <td>#dotlrn.name_note_name#</td>  <td>#dotlrn.percent_name#</td>	-->
    </tr>
	<if @found_asig@> <!--  SI HAY ASIGNACIONES  -->
	<multiple name="asig">
	<if @asig.rownum@ eq @sel_edit_asig@> <!-- SI LA ASIGNACION ACTUAL ES LA EDITADA -->
		<tr class="list_c_sel">
		<td class="list_c" width="4%" align="center">@asig.rownum@</td>  	
		<FORM METHOD="post" name="fe" onSubmit = "return validaForm(this)">
		<INPUT type="hidden" name="asig_id" value="@asig.id_xcent@">
		<INPUT type="hidden" name="asig_num" value="@asig.rownum@">		
		<td width="15%" class="list_c_sel">
			
			<SELECT name="asig_type"  onchange="if (this.options[this.selectedIndex].value==3) {fe.asig_percent.disabled = true;fe.asig_rvalor.disabled = true}	else {fe.asig_percent.disabled = false;fe.asig_rvalor.disabled = false}">
			<if @asig.ref_basetype@ ne 3>
			<multiple name="types">
			<if @types.id_basetype@ ne 3>
			<if @asig.ref_basetype@ eq @types.id_basetype@>
				<OPTION SELECTED value="@types.id_basetype@">@types.name_basetype@</OPTION>
			</if> <else>
				<OPTION value="@types.id_basetype@">@types.name_basetype@</OPTION>
			</else>
			</if>
			</multiple>
			</if>
			<else>
				<OPTION SELECTED value="3">#cards.card_Text#</OPTION>
			</else>
			</SELECT>		
			
		</td>
		<td width="45%" class="list_c_sel" ><INPUT type="text" size="50" name="asig_alias" value="@asig.name_xcent@"></td>
		<if @sel_edit_type@ lt 3> <!--  SI TIPO BASE DISTINTO TEXTO  --->
		<!--  ********* %  **********-->
		  <td width="8%" align="center" class="list_c_sel">
			<INPUT type="text" size="5" name="asig_percent" value="@asig.xcent@">
			<!--onblur="validaNum(document.fe.asig_percent,document.fe.asig_percent.value, 100, 0 , 'porcentaje')"> --></TD>
		<!--  ********* NP  **********-->			
		  <td width="8%" align="center" class="list_c_sel">
		  <if @asig.np@>
			<INPUT type="checkbox" size="1" name="asig_np"  value="1" checked>
			</if><else>
			<INPUT type="checkbox" size="1" name="asig_np"  value="1"></else></TD>			
		<!--  *********  <=  **********-->						
		  <td width="8%" align="center" class="list_c_sel">
			<INPUT type="text" size="5" name="asig_rvalor" value="@asig.rvalor@">
<!--	onblur="validaNum(document.fe.asig_rvalor, document.fe.asig_rvalor.value, 10, 0 , 'restricción')">--></TD>
		</if><else>  <!--  SI TIPO BASE TEXTO  --->
		<!--  ********* %  **********-->
		  <td width="8%" align="center" class="list_c_sel">
			<INPUT type="text" size="5" name="asig_percent" value="@asig.xcent@" disabled="false"></TD>
		<!--  ********* NP  **********-->			
		  <td width="8%" align="center" class="list_c_sel">
		  <if @asig.np@>
			<INPUT type="checkbox" size="1" name="asig_np"  value="1" checked disabled="false">
			</if><else>
			<INPUT type="checkbox" size="1" name="asig_np"  value="1" disabled="false"></else></TD>
		<!--  *********  <=  **********-->			
		  <td width="8%" align="center" class="list_c_sel">
			<INPUT type="text" size="5" name="asig_rvalor" value="@asig.rvalor@" disabled="false"></TD>
		</else>			
		<td width="6%" class="list_c" align="center"> 				
		<INPUT type="hidden" name="mode_update" value="">		
		<INPUT type="hidden" name="mode" value="">		
		<INPUT type="image" name="submit" value="submit" size="10" src="icons/ok.gif" ALT="#cards.card_Accept#" title="#cards.card_Accept#" onclick="document.fe.mode_update.value='mode_update';">
			
		</td>  
		<td width="6%" class="list" align="center">
		<INPUT type="hidden" name="mode_cancel" value="">		
		<INPUT type="image" name="submit" value="submit" size="10" title="#cards.card_Cancel#" src="icons/ko.gif" ALT="#cards.card_Cancel#"  onclick="document.fe.mode_cancel.value='mode_cancel';document.fe.mode.value=''">
		</td> 		
		</FORM>
		</if> <else> <!-- SI LA ASIGNACION ACTUAL NO ES LA EDITADA -->
	<if @asig.rownum@ odd>	
		<tr class="list-odd_c" onmouseover="javascript:style.backgroundColor='#99ccff'" onmouseout="javascript:style.backgroundColor='#EAF2FF'">
		</if><else>
		<tr class="list-even_c" onmouseover="javascript:style.backgroundColor='#99ccff'" onmouseout="javascript:style.backgroundColor='#FFFFFF'">
		</else>				
	<td class="list_c" width="4%" align="center">@asig.rownum@</td>  				
	<td width="15%" class="list_c"><% set name_type_note [format "%s" @asig.name_basetype@] %> <%= $name_type_note %></td>
	<td width="45%" class="list_c"><% set alias_type_note [format "%s" @asig.name_xcent@] %> <%= $alias_type_note %></td>
	<td width="8%" align="center" class="list_c" ><% set percent_type_note [format "%s" @asig.xcent@] %><%= $percent_type_note %></td>
	<td width="8%" align="center" class="list_c" >
	<if @asig.np@>
		<INPUT type="checkbox" size="1" name="asig_np"  value="1" checked disabled="true">
		</if><else>
		<INPUT type="checkbox" size="1" name="asig_np"  value="1" disabled="true"></else></td>
	
	<td width="8%" align="center" class="list_c" >@asig.rvalor@</td>
	<!-- MODE EDIT LINK **************************************************-->	
	<FORM METHOD="post" name="fm" class="p">
	<td width="6%"  height="auto" class="list_c" align="center"> <if @is_edit@ ne 1>
		<INPUT type="hidden" name="asig_id" value="@asig.id_xcent@">
		<INPUT type="hidden" name="asig_num" value="@asig.rownum@">
		<INPUT type="hidden" name="mode" value="edit">
		<INPUT type="image" name="submit" value="submit" border="0" alt="#cards.card_Edit#" title="#cards.card_Edit# #cards.card_Block#" src="icons/edit.gif" style="margin:0;padding:0" onsubmit="">		
	</if></td></form>
	<!-- MODE DELETE LINK ****************************************************-->
	<FORM METHOD="post" name="fd" style="height:5px;vertical-align:middle">
	<td width="6%" class="list" align="center"><if @is_edit@ ne 1>
	<INPUT type="hidden" name="asig_id" value="@asig.id_xcent@">
	<INPUT type="hidden" name="asig_num" value="@asig.rownum@">
	<INPUT type="hidden" name="mode" value="delete">
	<INPUT type="image" name="submit" value="submit" border="0" title="#cards.card_Delete# #cards.card_Block#" alt="#cards.card_Delete# #cards.card_Block#" src="icons/papelera.gif" onclick="return confirm('#cards.card_del_bloc1# @asig.name_xcent@ #cards.card_del_bloc2#')" style="margin:0;padding:0">		
	</if></td></form>		
	</else>
	</tr>
	</multiple>
	</if>
	<!-- Aqui va una fila para INSERTAR tipos a no ser que estemos en edición-->
	<if @is_edit@ ne 1>
	<FORM METHOD="post" name="fi" onSubmit = "return validaForm(this)">
	<!-- <INPUT type="hidden" name="asig_id" value="update">  No estoy seguro de que haga falta -->
	<tr style="background:#e0e0e0;">
		<td width="4%" align="center" class="list_c"><B>*</B> <!--@ num_asig @    -->	</td>
		<td width="15%" class="list_c">
		<SELECT name="asig_type"  onchange="if (this.options[this.selectedIndex].value==3) {fi.asig_percent.disabled = true;fi.asig_rvalor.disabled = true}	else {fi.asig_percent.disabled = false;fi.asig_rvalor.disabled = false}">
			<multiple name="types">
			<OPTION value="@types.id_basetype@">@types.name_basetype@</OPTION>
			</multiple></SELECT></td>
		<td width="45%" class="list_c">
			<INPUT type="text" size="55" name="asig_alias"></td>
		<td width="8%" align="center" class="list_c">
		<!-- valida_num(this.asig_percent,this.asig_percent.value,0,100)--->
			<INPUT type="text" size="5" name="asig_percent" value="0">
			<!--onblur="validaNum(document.fi.asig_percent, document.fi.asig_percent.value, 100, 0 , 'porcentaje')">--></td>
		<td width="8%" align="center" class="list_c">
			<INPUT type="checkbox" size="1" name="asig_np"  value="1"></td>		
		
		<td width="8%" align="center" class="list_c"><INPUT type="text" size="5" name="asig_rvalor" value="0">
		<!--onblur="validaNum(document.fi.asig_rvalor, document.fi.asig_rvalor.value, 10, 0 , 'restricción')">--></td>	
		<!--<INPUT type="submit" name="mode_add" value="Añadir">-->
		<td width="6%" colspan="2" class="list_c"> <CENTER>
		<INPUT type="hidden" name="mode_insert" value="mode_insert">
	<input type="image" name="submit" value="submit" border="0" title="#dotlrn.New# #cards.card_Block#"  ALT="#dotlrn.New# #cards.card_Block#" src="icons/plus.gif" style="margin:0;padding:0" onclick="">		
	</CENTER></td>  
	</tr></form>
	</if>
	</table></TD>
</TR>
<TR><TD COLSPAN="3" ALIGN="RIGHT"><if @total@ gt @base@>
<h4 style="color:#6186b0"><U>#cards.card_Total_assigned#</U>:<SPAN style="color:red">@total@</span> / @base@</h4>
</if>
<else>	
<h4 style="color:#6186b0"><U>#cards.card_Total_assigned#</U>: @total@ / @base@</h4>
</else></TD>
</TR>
<TR>
	<TD COLSPAN="3">
	<TABLE width="60%" class="list" cellpadding="5" cellspacing="1" border="0">
	<TR  class="list-header">
		<th class="list_c" COLSPAN="4" style="text-align:left"><B>#cards.card_Setup_options#</B></th>
	</TR><FORM METHOD="post" name="fb">

	<TR class="list-even_c">
		<TD width="1%" class="list_c">&nbsp;</TD>
		<TD width="25%" class="list_c">#cards.card_Allow_students_access#
		<TD width="57%" class="list_c">
			<if @alum_view@>
			<INPUT type="checkbox" size="1" name="alum_view"  value="1" checked>
			</if><else>
			<INPUT type="checkbox" size="1" name="alum_view"  value="1">
			</else></TD>
		<TD  width="2%"  class="list_c" rowspan="1" valign="middle"><INPUT type="hidden" name="mode_base" value="mode_base">
	<input type="image" name="submit" value="submit" src="icons/ok.gif" ALT="#cards.card_Allow_students_access#" TITLE="#cards.card_Allow_students_access#"></TD>
	</TR>	
	</TABLE>
	</FORM>
	</TD>
</TR>
</TABLE>
</DIV>


<BR><BR>
<if @error@>
<SCRIPT>
alert("@msg_error@")
</SCRIPT>
</if>