<!-- <master>  --><!-- #dotlrn.gestion_evaluacion_name# -->
<link rel="stylesheet" href="cards.css" type="text/css">

<!-- TABLA CONTENEDORA -->
<table width="100%" border="0">
<!-- Si alum_view = TRUE ==> Mostramos menu opciones -->
<TR>
<TD style="font-weight:bold">
<div class="volver">&nbsp;&nbsp;#cards.card_Subjet#: 
&nbsp;&nbsp;<%= [dotlrn_community::get_community_description -community_id $community_id] %>&nbsp;&nbsp;</div></TD>
<TD ALIGN="RIGHT">
<div class="volver">
<A HREF="cards" class="t" style="color:#ffffff;font-weight:bold">&nbsp;&nbsp;#cards.card_Back#&nbsp;&nbsp;</A></div></TD>
</TR>
<TR><TD colspan="2">&nbsp;</TD>
</TR>

<TR><TD>
        <if @alum_view@> 
        <!--  ****************  NAVBAR - Selección datos a mostrar  *************** -->
        <TABLE border="0">
        <TR>
        <if @nav_sel@ eq "ficha"><TD class="list-button-bar">
        <a name="dp" class="button1">#cards.card_Personal_info#</a></TD>
        </if><else><TD class="list-button-bar">
        <a href="card?card_id=@id_card@&user_id=@user_id@&nav_sel=ficha"
        class="button">#cards.card_Personal_info#</a></TD></else>
        <if @nav_sel@ eq ""><TD class="list-button-bar">
        <A name="notas" class="button1">#cards.card_Grades#</a></TD>
        </if><else><TD class="list-button-bar">
        <a href="card?card_id=@id_card@&user_id=@user_id@" class="button">
        #cards.card_Grades#</a></TD></else>
        <multiple name="blocs_eval">
        <if @blocs_eval.xcent@ gt 0>
                <if @nav_sel@ eq @blocs_eval.id_xcent@>
                <TD class="list-button-bar"><A name="blck" class="button1">
                @blocs_eval.name_xcent@</a></TD>
                </if><else>
                <TD  class="list-button-bar">
                <a href="card?card_id=@id_card@&user_id=@user_id@&nav_sel=@blocs_eval.id_xcent@"
                 class="button">@blocs_eval.name_xcent@</a></TD>
                </else>
        </if>           
        </multiple>
        </TR>
        </TABLE>
        </if><else>
        <H3>#cards.card_Personal_info#</H3>
        </else>
<!-- FIN NAVBAR -->
</TD>
<TD>&nbsp;
        <if @alum_view@> 
        <TABLE border="0">
        <TR>
        <TD     align="right" style="border: 3px solid orange"><B>&nbsp;&nbsp;#cards.card_Average_grade#:&nbsp; 
        <if @nota_media@ eq NP>
                <span style="color:#000000">NP&nbsp;&nbsp;</span>
        </if>
        <else>
                <if @nota_media@ ge 5>
                        <span style="color:green">      <%= [string range [format "%s" @nota_media@] 0 3] %>&nbsp;&nbsp;
                </if>
                <else>
                        <span style="color:red">
                                <if @nota_media@ eq -1>
                                        4*&nbsp;&nbsp;
                                </if>
                                <else>
                                        <%= [string range [format "%s" @nota_media@] 0 3] %>&nbsp;&nbsp;
                                </else>
                        </span>
                </else>
        </else>
                
        </TD></TR>
        </TABLE></if>
</TD>
</TR>


<table width="100%" cellpadding="5" cellspacing="0" border="0">
<TR><TD colspan="2">
<table width="100%" class="list" cellpadding="5" cellspacing="0" BORDER="0">
<!--  ****************  MOSTRAR - DATOS PERSONALES  *************** -->
<if @nav_sel@ eq "ficha">

  <TR class="list-even">
    <TD width="10%" rowspan="2" class="list_c">
      <if @existe_photo@ eq 1>
        <CENTER><IMG @widthheight_param@ SRC="@subsite_url@shared/portrait-bits.tcl?@export_vars@" alt="@user_info.name@"></CENTER>
      </if>
      <else>
        <CENTER><IMG @widthheight_param@ SRC="icons/nophoto.gif" alt="@user_info.name@"></CENTER>
      </else>
    </TD>
    <TD colspan="2" class="list">
      <B>@user_info.name@</B><BR>
      <FONT COLOR=#0000FF>#dotlrn.Email#</FONT> @user_info.email@   <FONT COLOR=#0000FF>#acs-subsite.Home_page#:</FONT> @user_info.url@ <BR>
      </TD>
        <TR class="list-even">
        <if @is_edit@ eq 1> <!--SI ESTAMOS EN EDICION -->
        <FORM METHOD="post" name="fe">
        <TD class="list_c">     
                <INPUT type="hidden" name="user_id" value="@user_id@">
                <INPUT type="hidden" name="card_id" value="@card_id@">
                <INPUT type="hidden" name="nav_sel" value="@nav_sel@">
                <FONT COLOR=#0000FF>#dotlrn.address#: &nbsp;</FONT>
                        <INPUT type="text" size=60 name="address" value="@address@"><BR>
                <FONT COLOR=#0000FF>#dotlrn.phone1#:</FONT>
                        <INPUT type="text" size=60 name="phone1" value="@phone1@"><BR>
                <FONT COLOR=#0000FF>#dotlrn.phone2#:</FONT>
                <INPUT type="text" size=60 name="phone2" value="@phone2@"><BR>  
        </TD>
        <TD width="4%" class="list" align="center">
                <INPUT type="hidden" name="mode_update" value="">               
                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ok.gif" ALT="#cards.card_Accept#" title="#cards.card_Accept#" onclick="document.fe.mode_update.value='mode_update1'">
                <INPUT type="hidden" name="mode_cancel" value="">               
                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ko.gif" ALT="#cards.card_Cancel#" title="#cards.card_Cancel#" onclick="document.fe.mode_cancel.value='mode_cancel'"></TD>
        </FORM> 
        </if>
        <else>
        <FORM METHOD="post" name="fm1">
        <TD class="list_c">
                <INPUT type="hidden" name="user_id" value="@user_id@">
                <INPUT type="hidden" name="card_id" value="@id_card@">
                <INPUT type="hidden" name="nav_sel" value="@nav_sel@">
                <FONT COLOR=#0000FF>#dotlrn.address#:</FONT></U> @address@<BR>
                <FONT COLOR=#0000FF>#dotlrn.phone1#:</FONT> @phone1@<BR>
                <FONT COLOR=#0000FF>#dotlrn.phone2#:</FONT> @phone2@<BR></TD>
        <TD width="4%" class="list_c" align="center">
                <INPUT type="hidden" name="mode" value="edit1">
                <INPUT type="image" name="submit" value="submit" border="0" alt="#cards.card_Edit# #cards.card_Personal_info#" title="#cards.card_Edit# #cards.card_Personal_info#" src="icons/edit.gif" style="margin:0;padding:0"></TD>
        </FORM>
        </else> 
  </TR>
  <TR class="list-even">
    <if @is_edit@ eq 2> <!--SI ESTAMOS EN EDICION 2 -->
        <FORM METHOD="post" name="fe2">
    <TD colspan="2" class="list_c" >
                <INPUT type="hidden" name="user_id" value="@user_id@">
                <INPUT type="hidden" name="card_id" value="@card_id@">
                <INPUT type="hidden" name="nav_sel" value="@nav_sel@">
                <B>#dotlrn.observations_from_student_to_teacher#:</B><BR>
                <TEXTAREA INPUT type="text" rows="5" cols="80"  name="comm_student" value="@comm_student@"></TEXTAREA>
    </TD>
        <TD width="10%" class="list_c"  align="center"> 
                <INPUT type="hidden" name="mode_update" value="">               
                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ok.gif" ALT="#cards.card_Accept#" title="#cards.card.Accept#" onclick="document.fe2.mode_update.value='mode_update2'">
                <INPUT type="hidden" name="mode_cancel" value="">               
                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ko.gif" ALT="#cards.card_Cancel#" title="#cards.card.Cancel#"  onclick="document.fe2.mode_cancel.value='mode_cancel'">
        </TD>
        </FORM> 
        </if>
        <else> <!--SI  NNO ESTAMOS-->
        <FORM METHOD="post" name="fm1">
        <TD colspan="2" class="list_c">
                <INPUT type="hidden" name="user_id" value="@user_id@">
                <INPUT type="hidden" name="card_id" value="@id_card@">
                <INPUT type="hidden" name="nav_sel" value="@nav_sel@">
                <B>#dotlrn.observations_from_student_to_teacher#:</B><BR>
      @comm_student@
        </TD>
        <TD width="10%" class="list_c" align="center">
                <INPUT type="hidden" name="mode" value="edit2">
                <INPUT type="image" name="submit" value="submit" border="0" ALT="#cards.card_Edit# #cards.card_Comment#" title="#cards.card_Edit# #cards.card_Comment#" src="icons/edit.gif" style="margin:0;padding:0"></TD>
        </FORM> 
        </else>
        </TD>
  </TR>  
  <TR class="list-even">
    <TD colspan="3" class="list">

      <B>#dotlrn.observations_from_teacher_to_student#:</B><BR>
      @comm_teacher@
    </TD>
  </TR>
</TABLE>
<BR>

</if>
<else>
<!--  ****************  MOSTRAR - NOTAS ALUMNO *************** -->
<multiple name="blocs_eval">
<if @blocs_eval.xcent@ gt 0>
        <if @nav_sel@ eq @blocs_eval.id_xcent@ or @nav_sel@ eq "">
        <tr class="list-header">
                <th colspan="3" class="list_h"><B>@blocs_eval.name_xcent@</B> (@blocs_eval.xcent@%)</th>
                <th colspan="2" align="right" class="list_h">   
                        <multiple name="blocs_eval1">
                        <if @blocs_eval1.ref_xcent@ eq @blocs_eval.id_xcent@>
                                <B>Media: <%= [string range [format "%s" @blocs_eval1.mitja@] 0 3] %></B>
                        </if>
                        </multiple></th>
        </tr>
        
        <tr class="list-odd_c" height="6" style="font-size:9px">
        <td width="1%" class="list_c">  &nbsp;</td>
        <td width="27%" class="list_c">#cards.card_Note#</td>
        <td width="56%" class="list_c">#cards.card_Comment#</td>
        <td width="6%" class="list_c">#cards.card_Grade#</td>
        <td width="6%" class="list_c">#cards.card_Active#</td>                  
        </tr>
        
        <multiple name="notes">
        <if @notes.ref_xcent@ eq @blocs_eval.id_xcent@>
                <tr class="list-even" onmouseover="javascript:style.backgroundColor='#99ccff'"
                onmouseout="javascript:style.backgroundColor='#FFFFFF'">        
                        <td width="1%" class="list_c">&nbsp;</td>
                        <td width="27%" class="list_c">@notes.name_subtype@</td>
                        <td width="56%" class="list_c">&nbsp;@notes.value_s@</td>
                        <td width="6%" class="list_c">@notes.value_n@</td>
                        <td width="6%" class="list_c">
                        <if @notes.is_active@>
                                <INPUT type="checkbox" size="1" name="noteact" checked disabled>
                        </if><else>
                                <INPUT type="checkbox" size="1" name="noteact" disabled>
                        </else>                         
                        </td>                   
                </tr>
        </if>
        </multiple>
        </if>   
</if>
</multiple>
</else>
<TR>
<TD colspan="5" align="right">#cards.card_Without_academic_validity#</TD>
</TR>
</TABLE>
</td></TR>
</TABLE><BR><BR>
<if @error@><SCRIPT>alert("@msg_error@")</SCRIPT>
</if>
