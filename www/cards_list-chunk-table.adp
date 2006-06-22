<!-- NOMBRE ASIGNATURA + BOTON VOLVER-->
<link rel="stylesheet" href="cards.css" type="text/css">

<TABLE width="100%">
<TR>
<TD style="font-weight:bold">
<div class="volver">
&nbsp;&nbsp;<%= [dotlrn_community::get_community_description -community_id $community_id] %>&nbsp;&nbsp;</div></TD>
<TD ALIGN="RIGHT">
<div class="volver">
<A HREF="../one-community" class="t" style="color:#ffffff;font-weight:bold">&nbsp;&nbsp;#cards.card_Back#&nbsp;&nbsp;</A></div></TD>
</TR>
</TABLE>
<BR>

<!-- ENLACES GESTION EVALUACION -->
<TABLE cellspacing="1" cellpadding="3" class="list">
        <TR class="list-button-bar">
        <TD class="list-button-bar" colspan="4">
                <A HREF="gest_eval" class="button">&nbsp;#cards.card_Setup_evaluation#&nbsp;</A>
                <A HREF="gest_notes" class="button">&nbsp;#cards.card_Manage_notes#&nbsp;</A>
                <A HREF="list_notes" class="button">&nbsp;#cards.card_Grades_list#&nbsp;</A>
				  <A HREF="orla" class="button">&nbsp;#cards.card_Orla#&nbsp;</A>
<!--            <A name="EvalxA" class="button">&nbsp;Evaluar Por Anotación&nbsp;</A>-->
        </TR>
        </TABLE> 

<table with="75%" class="list" cellpadding="5" cellspacing="0">
    <tr class="list-header">
      <th class="list">&nbsp;</th>
      <th class="list" align="left">#dotlrn.Last_Name#, #dotlrn.First_Name#</th>     
    </tr>
<multiple name="current_members">
  <if @current_members.rownum@ odd>
    <tr class="list-odd" onmouseover="javascript:style.backgroundColor='#99ccff'" onmouseout="javascript:style.backgroundColor='#EAF2FF'">
  </if>
  <else>
    <tr class="list-even" onmouseover="javascript:style.backgroundColor='#99ccff'" onmouseout="javascript:style.backgroundColor='#FFFFFF'">
  </else>
  
  <if @current_members:rowcount@ eq @current_members.rownum@>
  <td width="1%" class="list" style=" border-bottom: 3px solid #A0BDEB;"></if><else>
  <td width="1%" class="list"></else>
    <A HREF="notes?user_id=@current_members.user_id@"><IMG SRC="icons/card.gif" BORDER=0></A>
  </td>
  
  <if @current_members:rowcount@ eq @current_members.rownum@>
  <td class="list" style=" border-bottom: 3px solid #A0BDEB;"></if><else>
  <td class="list"></else>
    <% set fullname [format "%s, %s" @current_members.last_name@ @current_members.first_names@] %>
    <%= [format "<A HREF=\"notes?user_id=%s\">%s, %s</A>" @current_members.user_id@ @current_members.last_name@ @current_members.first_names@] %>    
  </td>
  </tr>
</multiple>
</table>
<I> <%= @current_members:rowcount@ %> #dotlrn.student_role_pretty_plural# </I>

<!--
<BR><SPAN STYLE="color:#ddebf5">num_alum_del@ </SPAN>
<BR><SPAN STYLE="color:#ddebf5">Alumnos sin card user_no_card:rowcount@ </SPAN>
<BR><SPAN STYLE="color:#ddebf5">Anotaciones de la com:  community_notes:rowcount@ </SPAN>
-->