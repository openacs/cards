<!-- <master>  --><!-- #dotlrn.gestion_evaluacion_name# -->

<!---->
<link rel="stylesheet" href="cards.css" type="text/css">
<TABLE width="100%" border="0">
<TR>
<TD style="font-weight:bold">
<div class="volver">&nbsp;&nbsp;#cards.card_Subjet#: 
&nbsp;&nbsp;<%= [dotlrn_community::get_community_description -community_id $community_id] %>&nbsp;&nbsp;
</div></TD>
<TD ALIGN="RIGHT">
<div class="volver">
<A HREF="cards" class="t" style="color:#ffffff;font-weight:bold">&nbsp;&nbsp;#cards.card_Back#&nbsp;&nbsp;</A></div></TD>
</TR>
<TR>
<TD>
</TD>
<TABLE width="600" style="table-layout:fixed">

<multiple name="alum">
<!--
<%= [set idx [expr @alum.rownum@ % 8]] 
        set idx @idx@
%>
--> 
<!--user_id as user_id
id_card
last_name
first_names-->


<if @idx@ eq 1>
<tr>
<td class="orla">
<TABLE width="75" style="table-layout:fixed">
<TR><TD>
<CENTER><a href="notes?user_id=@alum.user_id@" class="link1" title="@alum.last_name@, @alum.first_names@"><IMG @widthheight_param@ SRC="/shared/portrait-bits.tcl?user_id=@alum.user_id@"> <!--alt="alum.last_name, alum.first_names">--></a>
</CENTER>
</TD></TR>
<TR><TD><CENTER>@alum.last_name@, @alum.first_names@</CENTER>
</TD></TR>
</TABLE>

</td>
</if>
<else>

        <if @idx@ eq 0>
        <td class="orla">
<TABLE width="75" style="table-layout:fixed">
<TR><TD>
<CENTER><a href="notes?user_id=@alum.user_id@" class="link1" title="@alum.last_name@, @alum.first_names@"><IMG @widthheight_param@ SRC="/shared/portrait-bits.tcl?user_id=@alum.user_id@"> <!--alt="alum.last_name, alum.first_names">--></a>
</CENTER>
</TD></TR>
<TR><TD><CENTER>@alum.last_name@, @alum.first_names@</CENTER>
</TD></TR>
</TABLE>

        </td></tr>
        </if>
        <else>
        <td class="orla">
<TABLE width="75" style="table-layout:fixed">
<TR><TD>
<CENTER><a href="notes?user_id=@alum.user_id@" class="link1" title="@alum.last_name@, @alum.first_names@"><IMG @widthheight_param@ SRC="/shared/portrait-bits.tcl?user_id=@alum.user_id@"> <!--alt="alum.last_name, alum.first_names">--></a>
</CENTER>
</TD></TR>
<TR><TD><CENTER>@alum.last_name@, @alum.first_names@</CENTER>
</TD></TR>
</TABLE>
        
        </td>
        </else>
</else>

</multiple>
</TABLE>
</TR>
</table>
@alum:rowcount@ #dotlrn.student_role_pretty_plural#




<if @error@><SCRIPT>alert("@msg_error@")</SCRIPT>
</if>
