<!-- <master>  -->
<!-- #dotlrn.gestion_evaluacion_name# -->
<link rel="stylesheet" href="cards.css" type="text/css">

<TABLE width="60%">
<TR>
<TD style="font-weight:bold">
<div class="volver">
&nbsp;&nbsp;#cards.card_Subjet#: <%= [dotlrn_community::get_community_description -community_id $community_id] %>&nbsp;&nbsp;</div></TD>
<TD ALIGN="RIGHT">
<div class="volver">
<A HREF="cards" class="t" style="color:#ffffff;font-weight:bold" >&nbsp;&nbsp;#cards.card_Back#&nbsp;&nbsp;</A></div></TD>
</TR>
</TABLE>

<!--  ****************  NAVBAR - Selección datos a mostrar  *************** -->
<TABLE cellspacing="1" cellpadding="3" class="list">
<TR><h4 style="color:#6186b0">&nbsp;#cards.card_Note_list#</h4>	
	<if @nav_sel@ eq "">
	<TD class="list-button-bar"><a name="notes" class="button1">#cards.card_Notes#</a></TD>
	</if><else><TD  class="list-button-bar">
	<a href="gest_notes" class="button">#cards.card_Notes#</a></TD></else>
	
	<multiple name="blocs_eval">
	<if @blocs_eval.xcent@ gt 0>
		<if @nav_sel@ eq @blocs_eval.id_xcent@>
			<TD class="list-button-bar"><a name="@blocs_eval.name_xcent@" class="button1">@blocs_eval.name_xcent@</a></TD>
		</if><else>
			<TD  class="list-button-bar">
			<a href="gest_notes?nav_sel=@blocs_eval.id_xcent@" class="button">@blocs_eval.name_xcent@</a></TD>
		</else>
	</if>		
	</multiple>
	</TR>
</TABLE>

<table width="60%" cellpadding="5" cellspacing="0" border="0">
<TR> 
	<TD COLSPAN="2">
	<table  class="list" width="100%" cellpadding="3" cellspacing="1" border="0">
    <tr class="list-header">
		<th class="list_c" ><B>&nbsp;</B></td>
		<th class="list_c" ><B>#cards.card_Block#</B></td>
		<th class="list_c" COLSPAN="2"><B>#cards.card_Note_name#<B></td>
		<th class="list_c" >&nbsp;</td>
		<th class="list" >&nbsp;</td>
		<!-- <td>#dotlrn.id_type_note_name#</td>  <td>#dotlrn.name_note_name#</td>  <td>#dotlrn.percent_name#</td>	-->
    </tr>
	<if @found_asig@>	
	<multiple name="asig">
	<if @nav_sel@ eq @asig.id_xcent@ or @nav_sel@ eq "">
	<if @asig.rownum@ eq @sel_edit_asig@>		
	<tr class="list_c_sel">
		<td width="5%"  class="list_c" style="text-align:center">&nbsp;</td>  
		<FORM METHOD="post" name="fe">
		<INPUT type="hidden" name="asig_id" value="@asig.id_subtype@">
		<INPUT type="hidden" name="nav_sel" value="@nav_sel@">
		<td width="23%" class="list_c_sel">
			<SELECT name="asig_type"  onchange="if (this.options[this.selectedIndex].value>5) {fe.asig_percent.disabled = true;}	else {fe.asig_percent.disabled = false;}">
			<multiple name="types">
			<if @asig.ref_xcent@ eq @types.id_xcent@>
				<OPTION SELECTED value="@types.id_xcent@">@types.name_xcent@</OPTION>
			</if> <else>
				<OPTION value="@types.id_xcent@">@types.name_xcent@</OPTION>
			</else>
			</multiple></SELECT>				
		</td>
		<td  colspan="2" width="52%" class="list_c_sel" >
		<INPUT type="text" size="45" name="asig_alias" value="@asig.name_subtype@"></td>
		<td width="2%" class="list_c" >
		<INPUT type="hidden" name="mode_update" value="">
		<INPUT type="image" name="submit" value="submit" size="10" src="icons/ok.gif" ALT="#cards.card_Accept#" title="#cards.card_Accept#" onclick="document.fe.mode_update.value='mode_update'">
		</td>  
		<td width="2%" class="list">		
	<INPUT type="hidden" name="mode_cancel" value="">
	<INPUT type="image" name="submit" value="submit" size="10" src="icons/ko.gif" ALT="#cards.card_Cancel#"
	TITLE="#cards.card_Cancel#"  onclick="document.fe.mode_cancel.value='mode_cancel'">
		</td> 		
		</FORM>
		</if> <else>
		<if @asig.rownum@ odd>
		<tr class="list-odd_c" onmouseover="javascript:style.backgroundColor='#99ccff'" onmouseout="javascript:style.backgroundColor='#EAF2FF'">
		</if><else>
		<tr class="list-even_c" onmouseover="javascript:style.backgroundColor='#99ccff'" onmouseout="javascript:style.backgroundColor='#FFFFFF'">
		</else>	
		<!-- asig.rownum -->
	<td width="5%"  class="list_c" style="text-align:center">&nbsp;</td>  			
	<td width="23%" class="list_c"><% set name_type_note [format "%s" @asig.name_xcent@] %> <%= $name_type_note %></td>
	<td COLSPAN="2"  class="list_c" width="52%">
	<A HREF="eval_note?note_sel=@asig.id_subtype@">
	<% set alias_type_note [format "%s" @asig.name_subtype@] %> <%= $alias_type_note %>
	</A>
	</td>
	<FORM METHOD="post" name="fm">
	<td width="2%" class="list_c"> <if @is_edit@ ne 1>
	<!-- MODE EDIT ****************************************************-->
		<INPUT type="hidden" name="asig_id" value="@asig.id_subtype@">
		<INPUT type="hidden" name="asig_num" value="@asig.rownum@">
		<INPUT type="hidden" name="nav_sel" value="@nav_sel@">		
		<INPUT type="hidden" name="mode" value="edit">
		<if @asig.ref_basetype@ ne 3>
		<INPUT type="image" name="submit" value="submit" size="10" src="icons/edit.gif" ALT="#cards.card_Edit# #cards.card_Note#" TITLE="#cards.card_Edit# #cards.card_Note#">	
		</if>
		</if></td>  </form><FORM METHOD="post" name="fd">
	<td width="2%" class="list" ><if @is_edit@ ne 1>
	<!-- MODE DELETE ****************************************************-->
	<INPUT type="hidden" name="asig_id" value="@asig.id_subtype@">
	<INPUT type="hidden" name="nav_sel" value="@nav_sel@">	
	<INPUT type="hidden" name="mode" value="delete">
	<if @asig.ref_basetype@ ne 3>
	<INPUT type="image" name="submit" value="submit" size="10" src="icons/papelera.gif" ALT="#cards.card_Delete# #cards.card_Note#" title="#cards.card_Delete# #cards.card_Note#" onclick="return confirm('#cards.card_del_note1# @asig.name_subtype@ #cards.card_del_note2#')">
	</if>
	</if></td></form>	
	</else>
	</tr>	
	</if>
	</multiple>
	</if>
	<!-- Aqui va una fila para insertar tipos a no ser que estemos en edición-->
	<if @is_edit@ ne 1>
	<FORM METHOD="post" name="fi">
	<!-- <INPUT type="hidden" name="asig_id" value="update">  No estoy seguro de que haga falta -->
	<tr style="background:#e0e0e0;">
		<td width="5%" class="list_c" style="text-align:center"><B>*</B> <!--@ num_asig @    -->	</td>
		<td width="23%" class="list_c" >
		<if @nav_sel@ eq ""> 
		<SELECT name="asig_type">
			<multiple name="types">
			<OPTION value="@types.id_xcent@">@types.name_xcent@</OPTION>
			</multiple></SELECT></td>
		</if><else>
			<INPUT type="text" size="25" name="asig_type_name" value="@tipo@" disabled>
			<INPUT type="hidden" size="25" name="asig_type" value="@nav_sel@">
			
			</td>
		</else>								
		<td colspan="2" width="55%" class="list_c"><INPUT type="text" size="45" name="asig_alias"></td>
		<td width="4%" colspan="2" class="list_c"> <CENTER>
		<INPUT type="hidden" name="mode_insert" value="mode_insert">		
		<INPUT type="hidden" name="nav_sel" value="@nav_sel@">		
		<INPUT type="image" name="submit" value="submit" size="10" src="icons/plus.gif" ALT="#cards.card_Add_note_asig#" TITLE="#cards.card_Add_note_asig#"></CENTER></td>  
	</tr>
	</form>
	</if></table></TD>
</TR>
</TABLE><BR><BR>
<if @error@><SCRIPT>alert("@msg_error@")</SCRIPT></if>