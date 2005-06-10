<master>
<SCRIPT LANGUAGE="JavaScript">
<!-- Original:  Paco Soler -->
<!-- Begin

function validaForm (f) {

	error = 0
	if (isNaN(f.note_value.value) || parseInt(f.note_value.value) > 10 || parseInt(f.note_value.value) < 0) {	
			f.note_value.style.backgroundColor="#ffcc00";
			error = 2
	} else {f.note_value.style.backgroundColor="#ffffff";}
	
	if (error > 0) { alert ("#cards.card_Invalid_data#");return false}
	else return true
	
}	

//  End -->
</script>

<link rel="stylesheet" href="cards.css" type="text/css">
<TABLE width="100%">
<TR>
<TD style="font-weight:bold">
<div class="volver">
&nbsp;&nbsp;<%= [dotlrn_community::get_community_description -community_id $community_id] %>&nbsp;&nbsp;</div></TD>
<TD ALIGN="RIGHT">
<div class="volver">
<A HREF="gest_notes" class="t" style="color:#ffffff;font-weight:bold">&nbsp;&nbsp;#cards.card_Back#&nbsp;&nbsp;</A></div></TD>
</TR>
</TABLE>
<table width="70%" cellpadding="5" cellspacing="0" border="0">
<TR> 
	<TD COLSPAN="2"><h4 style="color:#6186b0">#cards.card_Grade#: @sel_note@</h4>
	<table width="100%" class="list" cellpadding="5" cellspacing="0">
    <tr class="list-header">
		<th class="list_c" class="">&nbsp;</th>
		<th class="list_c" width="30%"><B>#dotlrn.student_role_pretty_plural#</B></th>
		<th class="list_c" width="40%"><B>#cards.card_Comment#</B></th>
		<th class="list_c" width="10%"><B>#cards.card_Grade#</B></th>
		<if @act_note@>
		<th class="list_c" width="10%"><B>#cards.card_Active#</B></th>		
		</if>
		<th class="list_c" width="10%"><B>#cards.card_Edit#</B></th>
    </tr>	
	<multiple name="llista">
		<if @is_edit@ ne @llista.id_card_notes@> <!--SI NO editamos la que toca-->		
		<if @llista.rownum@ odd>
		<tr class="list-odd_c" onmouseover="javascript:style.backgroundColor='#99ccff'" onmouseout="javascript:style.backgroundColor='#EAF2FF'">
		</if><else>
		<tr class="list-even_c" onmouseover="javascript:style.backgroundColor='#99ccff'" onmouseout="javascript:style.backgroundColor='#FFFFFF'">
		</else>		
		<td class="list_c" width="1%">@llista.rownum@</td>
		<td class="list_c" width="30%"><%= [set fullname [format "%s, %s" @llista.last_name@ @llista.first_names@]] %></td>		
		<td class="list_c" width="40%">@llista.value_s@</td>
		<td class="list_c" width="10%" align="right">@llista.value_n@</td>
		<if @act_note@>
		<td class="list_c" width="10%" align="right">
		<if @llista.is_active@>
			<INPUT type="checkbox" size="1" name="note_active" checked disabled>
		</if><else>
			<INPUT type="checkbox" size="1" name="note_active" disabled>
		</else></td>		
		</if>		
		<!-- MODE EDIT LINK **************************************************-->
			<if @is_edit@ eq 0>
			<FORM METHOD="post" name="fm">
			<td class="list_c" width="10%" align="center">
				<INPUT type="hidden" name="mode" value="edit">
				<INPUT type="hidden" name="note_sel" value="@note_sel@">
				<INPUT type="hidden" name="note_id" value="@llista.id_card_notes@">
				<INPUT type="image" name="submit" value="submit" border="0" alt="#cards.card_Edit# #cards.card_Grade#" title="#cards.card_Edit# #cards.card_Grade#"
				src="icons/edit.gif">		
			</td>
			</form>						
			</if>
			<else><td class="list_c" width="10%">&nbsp;</td></else>
			
		</if><else>
		<tr class="list_c_sel">
		<td class="list_c" width="1%">@llista.rownum@</td>
		<td class="list_c" width="30%"><%= [set fullname [format "%s, %s" @llista.last_name@ @llista.first_names@]] %>
				
		</td>		
		<!-- MODE UPDATE **************************************************-->
		<a name="goto_edit"></a>
		<FORM METHOD="post" name="fe" onsubmit="return validaForm(this)">
		<INPUT type="hidden" name="note_sel" value="@note_sel@">
		<INPUT type="hidden" name="note_id" value="@llista.id_card_notes@">
			
		<td class="list_c_sel" width="40%">
			<INPUT type="text" size="55" name="note_desc" value="@llista.value_s@"></td>
		<td class="list_c_sel" width="10%">
			<INPUT type="text" size="5" name="note_value" value="@llista.value_n@"></td>

		<if @act_note@>			
		<td class="list_c_sel" width="10%">
			<if @llista.is_active@>
				<INPUT type="checkbox" size="1" name="note_active" value="1" checked="true">
			</if>
			<else>
				<INPUT type="checkbox" size="1" name="note_active" value="1">
			</else>
		</td>			
		</if>
		<else>
			<INPUT type="hidden" size="1" name="note_active" value="1">
		</else>
		
		
		<td width="10%" class="list_c_sel"  align="center">
		<INPUT type="hidden" name="mode_update" value="">
		<INPUT type="image" name="submit" value="submit" size="10" src="icons/ok.gif" ALT="#cards.card_Accept#" title="#cards.card_Accept#" onclick="document.fe.mode_update.value='mode_update'">&nbsp;&nbsp;
		<INPUT type="hidden" name="mode_cancel" value="">
	<INPUT type="image" name="submit" value="submit" size="10" src="icons/ko.gif" ALT="#cards.card_Cancel#" 
	title="#cards.card_Cancel#" onclick="document.fe.mode_cancel.value='mode_cancel'">

		</td> 		
		</FORM>
	</else>
	</multiple>
	</table>
	</TD>
</TR>
</TABLE><BR><BR>
<if @error@><SCRIPT>alert("@msg_error@")</SCRIPT></if>
		<script>
				document.forms['fe'].note_value.focus();
		</script>