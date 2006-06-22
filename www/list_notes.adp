<master>
<link rel="stylesheet" href="cards.css" type="text/css">
<TABLE width="100%">
<TR>
<TD style="font-weight:bold">
<div class="volver">
&nbsp;&nbsp;<%= [dotlrn_community::get_community_description -community_id $community_id] %>&nbsp;&nbsp;</div></TD>
<TD ALIGN="RIGHT">
<div class="volver">
<A HREF="cards" class="t" style="color:#ffffff;font-weight:bold">&nbsp;&nbsp;#cards.card_Back#&nbsp;&nbsp;</A></div></TD>
</TR>
<!--<TR>
<TD><%= [string range [format "%f2" [expr 5 + 1]] 0 3] %>
</TD>
<TD><%= [format "%f2" 5.3333333] %>
</TD>
</TR>-->
</TABLE>
<table width="100%" cellpadding="5" cellspacing="0" border="0">
<TR> 
	<TD COLSPAN="2"><h4 style="color:#6186b0">#cards.card_Grades_list#</h4>
	<table width="100%" class="list" cellpadding="5" cellspacing="0">
    <tr class="list-header">
		<th class="list_c" class="">&nbsp;</td>
		<th class="list_c" width="20%"><B>#dotlrn.student_role_pretty_name#</B></td>
		<multiple name="bloques">
		<if @bloques.xcent@ gt 0>
		<th class="list_c" width="10%" align="center"><B>@bloques.name_xcent@ (@bloques.xcent@%)
			<if @bloques.rvalor@ gt 0><BR><span style="color:red">[>=@bloques.rvalor@]</SPAN></if></B></td>
		</if>
		</multiple>
		<th class="list_c" ><B>#cards.card_Final_grade#</B></td>
		<!-- <td>#dotlrn.id_type_note_name#</td>  <td>#dotlrn.name_note_name#</td>  <td>#dotlrn.percent_name#</td>	-->
    </tr>	
	<multiple name="alum">
	<if @alum.rownum@ odd><tr class="list-odd"></if><else><tr class="list-even"></else> 
		<td class="list_c" width="1%">	@alum.rownum@</td>
		<td class="list_c" width="20%"><%= [set fullname [format "%s, %s" @alum.last_name@ @alum.first_names@]] %></td>  
		<multiple name="bloques">
			<if @bloques.xcent@ gt 0>
			<td class="list_c" width="10%">
			<multiple name="notes">
			<if @notes.ref_id_card@ eq @alum.id_card@>
				<If @notes.ref_xcent@ eq @bloques.id_xcent@>
				<TABLE width="100%">
				<TR>
				<TD width="50%" align="left"><B><%= [string range [format "%f2" [expr @notes.mitja_p@*100.00/@notes.xcent@]] 0 3] %></B></TD>
				<TD width="50%" align="right">(<%= [string range [format "%f2" @notes.mitja_p@] 0 3] %>)</TD>
				</TABLE>
				</TD>
				</if>
			</if>
			</multiple>
			</if>
		</multiple>		
		<td width="5%" class="list_c" >
			<list name="l_notas">
				<if @l_notas:rownum@ eq @alum.rownum@>
					<if @l_notas:item@ eq NP><span style="color:#000000">NP</span></td>
					</span></td>
					</if>
					<else>
						<if @l_notas:item@ ge 5><span style="color:green">
							<%= [string range [format "%f2" @l_notas:item@] 0 3] %>
						</if>
						<else>
						<span style="color:red">
							<if @l_notas:item@ eq -1>
							(*)
							</if>
							<else>
							<%= [string range [format "%f2" @l_notas:item@] 0 3] %>
							</else>
						</span></td>
						</else>
					</else>
				</if>
		</list>
	</tr>
	</multiple>
	</table>
	</TD>
</TR>
<TR>
<TD colspan="3"> <u>#cards.card_Passed#</u>: <B>@aprobados@</B>&nbsp;&nbsp;&nbsp;&nbsp;<u>#cards.card_Not_passed#</u>: <B>@suspensos@</B>&nbsp;&nbsp;&nbsp;&nbsp;<u>#cards.card_Not_done#</u>: <B>@nnp@</B></TD>
</TR>
</TABLE><BR><BR>
<if @error@><SCRIPT>alert("@msg_error@")</SCRIPT></if>