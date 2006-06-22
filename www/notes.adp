<!-- <master>  --><!-- #dotlrn.gestion_evaluacion_name# -->

<!---->
<link rel="stylesheet" href="cards.css" type="text/css">
<TABLE width="100%" border="0">
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
<TR>
        <TD width="85%"><SPAN style="color:#6186b0;font-weight:bold"><U>#dotlrn.student_role_pretty_name#</U>: @last_name@, @first_names@</SPAN></TD>
        <TD     width="15%" align="center" style="border: 3px solid orange"><B>&nbsp;&nbsp;#cards.card_Average_grade#:&nbsp; 
        <if @nota_media@ eq NP>
                <span style="color:#000000">NP&nbsp;&nbsp;</span>
        </if>
        <else>
                <if @final_note@ ge 5>
                        <span style="color:green">      <%= [string range [format "%s" @nota_media@] 0 3] %>&nbsp;&nbsp;
                </if>
                <else>
                        <span style="color:red">
                                <if @final_note@ eq -1>
                                        4*&nbsp;&nbsp;
                                </if>
                                <else>
                                        <%= [string range [format "%s" @nota_media@] 0 3] %>&nbsp;&nbsp;
                                </else>
                        </span>
                </else>
        </else>
        </TD>
</TR>
</TABLE>
<!--  ****************  NAVBAR - Selección datos a mostrar  *************** -->


<TABLE cellspacing="1" cellpadding="3" class="list">
<TR>
<!-- Datos personales ***********************************************************************-->
        <if @nav_sel@ eq "ficha"><TD class="list-button-bar"><a name="datos" class="button1">#cards.card_Personal_info#</TD>
        </if><else><TD  class="list-button-bar">
        <a href="notes?card_id=@card_id@&user_id=@user_id@&nav_sel=ficha" class="button">#cards.card_Personal_info#</a></TD></else>

<!-- Bloques de texto ***********************************************************************-->        
        <multiple name="blocs_text">
                <if @nav_sel@ eq @blocs_text.id_xcent@>
                        <TD class="list-button-bar"><a name="@blocs_text.name_xcent@" class="button1">@blocs_text.name_xcent@</a></TD>
                </if><else>
                        <TD  class="list-button-bar">
                        <a href="notes?card_id=@card_id@&user_id=@user_id@&nav_sel=@blocs_text.id_xcent@&text_sel=1" class="button">@blocs_text.name_xcent@</a></TD>
                </else>
        </multiple>             
        
<!-- Notas Completas ***********************************************************************-->         
        <if @nbs@ ne 0>
        <if @nav_sel@ eq ""><TD class="list-button-bar"><a name="notes" class="button1">#cards.card_Grades#</TD>
        </if><else><TD  class="list-button-bar">
        <a href="notes?card_id=@card_id@&user_id=@user_id@" class="button">#cards.card_Grades#</a></TD></else>
</if>
<!-- Bloques de notas ***********************************************************************-->        
        
                <multiple name="blocs_eval">
                <if @nav_sel@ eq @blocs_eval.id_xcent@>
                        <TD class="list-button-bar"><a name="@blocs_eval.name_xcent@" class="button1">@blocs_eval.name_xcent@</a></TD>
                </if><else>
                        <TD  class="list-button-bar">
                        <a href="notes?card_id=@card_id@&user_id=@user_id@&nav_sel=@blocs_eval.id_xcent@" class="button">@blocs_eval.name_xcent@</a></TD>
                </else>
        </multiple>
        </TR>
</TABLE>

<table width="100%" cellpadding="5" cellspacing="0" border="0">
<TR><TD colspan="2">
<table width="100%" class="list" cellpadding="5" cellspacing="0">
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
                <TD class="list">
                <FONT COLOR=#0000FF>#dotlrn.address#:</FONT></U> @address@<BR>
                <FONT COLOR=#0000FF>#dotlrn.phone1#:</FONT> @phone1@<BR>
                <FONT COLOR=#0000FF>#dotlrn.phone2#:</FONT> @phone2@<BR>
                </TD>
                <TD class="list">
                </TD>
        
  </TR>
  <TR class="list-even">
    <TD colspan="3" class="list"><B>#dotlrn.observations_from_student_to_teacher#:</B><BR>@comm_student@
    </TD>
  </TR>
  <TR class="list-even">
  <if @is_edit@ eq 2> <!--SI ESTAMOS EN EDICION 2 -->
        <FORM METHOD="post" name="fe2">
    <TD colspan="2" class="list_c">
                <INPUT type="hidden" name="user_id" value="@user_id@">
                <INPUT type="hidden" name="card_id" value="@card_id@">
                <INPUT type="hidden" name="nav_sel" value="@nav_sel@">
                <B>#dotlrn.observations_from_teacher_to_student#:</B><BR>
                <TEXTAREA INPUT type="text" rows="5" cols="60" name="comm_teacher">@comm_teacher@
                </TEXTAREA>
    </TD>
        <TD width="10%" class="list_c" align="center">
                <INPUT type="hidden" name="mode_update" value="">               
                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ok.gif" ALT="#cards.card_Accept#" title="#cards.card_Accept#" onclick="document.fe2.mode_update.value='mode_update2'">
                <INPUT type="hidden" name="mode_cancel" value="">               
                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ko.gif" ALT="#cards.card_Cancel#" title="#cards.card_Cancel#"  onclick="document.fe2.mode_cancel.value='mode_cancel'">
        </TD>
        </FORM> 
        </if>
        <else> <!--SI  NO ESTAMOS en edicion -->
        <FORM METHOD="post" name="fm1">
        <TD colspan="2" class="list_c">
                <INPUT type="hidden" name="user_id" value="@user_id@">
                <INPUT type="hidden" name="card_id" value="@id_card@">
                <INPUT type="hidden" name="nav_sel" value="@nav_sel@">
                <B>#dotlrn.observations_from_teacher_to_student#:</B><BR>@comm_teacher@
        </TD>
        <TD width="10%" class="list" align="center">
                <INPUT type="hidden" name="mode" value="edit2">
                <INPUT type="image" name="submit" value="submit" border="0" alt="#cards.card_Edit#" title="#cards.card_Edit#" src="icons/edit.gif" style="margin:0;padding:0"></TD>
        </FORM> 
        </else>
        </TD>
  </TR>   
</TABLE>
<BR>

</if>
<else>
<!--  ****************  MOSTRAR -TUTORIAS  *************** -->
<if @text_sel@ eq 1>

<tr class="list-header">
                <th colspan="5" class="list_h"><B>&nbsp;&nbsp;&nbsp;@bloc_sel@</B>
</tr>


        <tr class="list-odd_c" height="6" style="font-size:9px">
        <th width="1%" class="list_c">  &nbsp;</th>     
        <th width="10%" class="list_c">#cards.card_Date#</th>
        <th width="AUTO" class="list_c">#cards.card_Comment#</th>       
        <th width="7%" class="list_c" colspan="2">#cards.card_Action#</th>      
        </tr>
<multiple name="notes_text">
        <if @is_edit@ ne 3> <!--SI NO editamos -->
        <tr class="list-even" onmouseover="javascript:style.backgroundColor='#99ccff'" 
                onmouseout="javascript:style.backgroundColor='#FFFFFF'">
                <td width="1%" class="list_c">&nbsp;</td>
                <td width="10%" class="list_c" style="font-size:9px">&nbsp;<%= [string range [format "%s" @notes_text.note_datetime@] 0 15] %></td>                     
                <td  width="AUTO" class="list_c">&nbsp;@notes_text.value_s@</td>
        <!-- MODE EDIT LINK ****** -->                          
                <FORM METHOD="post" name="fmt">
                <td width="4%" align="center" class="list">                                     
                <INPUT type="hidden" name="card_id" value="@notes_text.ref_id_card@">
                <INPUT type="hidden" name="user_id" value="@user_id@">
                <INPUT type="hidden" name="note_id" value="@notes_text.id_card_notes@">
                <INPUT type="hidden" name="nav_sel" value="@nav_sel@">
                <INPUT type="hidden" name="text_sel" value="@text_sel@">
                <INPUT type="hidden" name="mode" value="edit3">
                <INPUT type="image" name="submit" value="submit" border="0" alt="#cards.card_Edit# #cards.card_Comment#" title="#cards.card_Edit# #cards.card_Comment#" src="icons/edit.gif">   
                </td>
                </form>         
                
                <FORM METHOD="post" name="fmt">
                <td width="3%" class="list_c" align="left">
                <INPUT type="hidden" name="card_id" value="@notes_text.ref_id_card@">
                <INPUT type="hidden" name="user_id" value="@user_id@">
                <INPUT type="hidden" name="note_id" value="@notes_text.id_card_notes@">
                <INPUT type="hidden" name="nav_sel" value="@nav_sel@">
                <INPUT type="hidden" name="text_sel" value="@text_sel@">
                <INPUT type="hidden" name="mode" value="delete">
                <INPUT type="image" name="submit" value="submit" border="0" alt="#cards.card_Delete# #cards.card_Comment#" title="#cards.card_Delete# #cards.card_Comment#" src="icons/papelera.gif">   
                
                </td>                   
                </form>         
        </if><else> <!-- SI EDITAMOS -->
                <if @notes_text.id_card_notes@ ne @note_id@> <!--NO ES LA EDITADA -->
                        <tr class="list-even">
                        <td width="1%" class="list_c">&nbsp;</td>
                        <td width="10%" class="list_c" style="font-size:9px">
                        &nbsp;<%= [string range [format "%s" @notes_text.note_datetime@] 0 15] %></td>
                        <td width="75%" class="list_c">&nbsp;@notes_text.value_s@</td>
                        <td width="7%" align="right" class="list_c" colspan="2">&nbsp;</td>                             
        
                </if>
                <else> <!-- ES LA EDITADA -->
                        <tr class="list_c_sel">
                        <td width="1%" class="list_c">&nbsp;</td>
                        <td width="10%" class="list_c" style="font-size:9px">
                        &nbsp;<%= [string range [format "%s" @notes_text.note_datetime@] 0 15] %></td>                                  
                        <!-- FORMULARIO -->
                        <FORM METHOD="post" name="fet">
                        <INPUT type="hidden" name="card_id" value="@card_id@">
                        <INPUT type="hidden" name="user_id" value="@user_id@">
                        <INPUT type="hidden" name="note_id" value="@note_id@">
                        <INPUT type="hidden" name="nav_sel" value="@nav_sel@">
                        <INPUT type="hidden" name="text_sel" value="@text_sel@">
                        <td width="AUTO" class="list_c_sel">
                        <INPUT type="text"  size="70" name="note_desc" value="@notes_text.value_s@"></td>
                        <td width="7%" align="center" class="list_c" colspan="2">                       
                                <INPUT type="hidden" name="mode_update" value="">               
                                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ok.gif" 
                                ALT="#cards.card_Accept#" title="#cards.card_Accept#" onclick="document.fet.mode_update.value='mode_update3'">
                                <INPUT type="hidden" name="mode_cancel" value="">               
                                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ko.gif" 
                                ALT="#cards.card_Cancel#" title="#cards.card_Cancel#" onclick="document.fet.mode_cancel.value='mode_cancel'">
                        </td>           
                        </FORM>
                        <!-- FIN FORMULARIO -->                 
                </else> 
        </else></TR>
</multiple>
        <if @is_edit@ ne 3>
        <FORM METHOD="post" name="fit">
                <INPUT type="hidden" name="card_id" value="@card_id@">
                <INPUT type="hidden" name="user_id" value="@user_id@">
                <INPUT type="hidden" name="note_id" value="@note_id@">
                <INPUT type="hidden" name="text_sel" value="@text_sel@">
        <!-- <INPUT type="hidden" name="asig_id" value="update">  No estoy seguro de que haga falta -->
        <tr style="background:#e0e0e0;">
                <td width="1%" class="list_c">&nbsp;</td>
                <td width="10%" class="list_c" style="font-size:9px">
                &nbsp;<%= [string range [format "%s" @datetime@] 0 15] %></td>
                <td  width="AUTO" class="list_c">
                <INPUT type="text" size="70" name="note_desc" value=""></td>
                <td width="7%" align="right" class="list_c" colspan="2">
                <CENTER>
                <INPUT type="hidden" name="mode_insert" value="mode_insert">            
                <INPUT type="hidden" name="nav_sel" value="@nav_sel@">          
                <INPUT type="image" name="submit" value="submit" size="10" src="icons/plus.gif"
                ALT="#dotlrn.New# #cards.card_Comment#" title="#dotlrn.New# #cards.card_Comment#"></CENTER>             
                </td>           
        </tr>
        </form>
        </if>
</if>
<else>
<!--  ****************  MOSTRAR - NOTAS ALUMNO *************** -->
<if @blocs_eval:rowcount@ eq 0>
#cards.card_No_notes#
</if>
<else>
<multiple name="blocs_eval">
        <if @nav_sel@ eq @blocs_eval.id_xcent@ or @nav_sel@ eq "">
        <tr class="list-header">
                <th colspan="4" class="list_h"><B>@blocs_eval.name_xcent@</B> (@blocs_eval.xcent@%)</th>
                <th colspan="3" align="right" class="list_h">
                        <multiple name="blocs_eval1">
                        <if @blocs_eval1.ref_xcent@ eq @blocs_eval.id_xcent@>
                                <B>#cards.card_Average_grade#: <%= [string range [format "%s" @blocs_eval1.mitja@] 0 3] %></B>
                        </if>
                        </multiple></th>
        </tr>
        
        <tr class="list-odd_c" height="6" style="font-size:9px">
        <th width="1%" class="list_c">  &nbsp;</th>
        <th width="23%" class="list_c">#cards.card_Note#</th>
        <th width="10%" class="list_c">#cards.card_Date#</th>
        <th width="50%" class="list_c">#cards.card_Comment#</th>
        <th width="6%" class="list_c">#cards.card_Grade#</th>
        <th width="3%" class="list_c">#cards.card_Active#</th>                  
        <th width="7%" class="list_c" colspan="2">#cards.card_Action#</th>      
        </tr>
        
        <multiple name="notes">
        <if @notes.ref_xcent@ eq @blocs_eval.id_xcent@>
                        <if @is_edit@ ne 1> <!--SI NO editamos -->
                <tr class="list-even" onmouseover="javascript:style.backgroundColor='#99ccff'" onmouseout="javascript:style.backgroundColor='#FFFFFF'">
                        <td width="1%" class="list_c">&nbsp;</td>
                        <td width="23%" class="list_c">@notes.name_subtype@</td>                        
                        <td width="10%" class="list_c" style="font-size:9px">&nbsp;<%= [string range [format "%s" @notes.note_datetime@] 0 15] %></td>                  
                        <td width="50%" class="list_c">&nbsp;@notes.value_s@</td>
                        <td width="6%" class="list_c" align="right">@notes.value_n@</td>
                        <td width="3%" class="list_c">
                        <if @notes.is_active@>
                        <INPUT type="checkbox" size="1" name="noteact" checked disabled>
                        </if><else>
                        <INPUT type="checkbox" size="1" name="noteact" disabled>
                        </else>                         
                        </td>                   
                        
                        <!-- MODE EDIT LINK **************************************************-->                               
                        <FORM METHOD="post" name="fm">
                        <td width="7%" align="center" class="list">                     
                                <INPUT type="hidden" name="card_id" value="@notes.ref_id_card@">
                                <INPUT type="hidden" name="user_id" value="@user_id@">
                                <INPUT type="hidden" name="note_id" value="@notes.id_card_notes@">
                                <INPUT type="hidden" name="nav_sel" value="@nav_sel@">
                                <INPUT type="hidden" name="mode" value="edit">
                                <INPUT type="image" name="submit" value="submit" border="0" alt="#cards.card_Edit# #cards.card_Grade#" title="#cards.card_Edit# #cards.card_Grade#" src="icons/edit.gif">               
                        </td>
                        </form>                 
                        </if>
                        <else> <!--SI editamos -->
                                <if @notes.id_card_notes@ ne @note_id@> <!--NO ES LA EDITADA -->
                                <tr class="list-even">
                                <td width="1%" class="list_c">&nbsp;</td>
                                <td width="23%" class="list_c">@notes.name_subtype@</td>
                                <td width="10%" class="list_c" style="font-size:9px">&nbsp;<%= [string range [format "%s" @notes.note_datetime@] 0 15] %></td>
                                <td width="50%" class="list_c">&nbsp;@notes.value_s@</td>
                                <td width="6%" class="list_c" align="right">@notes.value_n@</td>
                                <td width="3%" class="list_c">
                        <if @notes.is_active@>
                        <INPUT type="checkbox" size="1" name="noteact" checked disabled>
                        </if><else>
                        <INPUT type="checkbox" size="1" name="noteact" disabled>
                        </else>                                 
                                        </td>                   
                                        <td width="7%" align="right" class="list_c">&nbsp;</td>                         
                                </if>
                                <else> <!-- ES LA EDITADA -->
                                <tr class="list_c_sel">
                        <td width="1%" class="list_c">&nbsp;</td>
                        <td width="23%" class="list_c">@notes.name_subtype@</td>                                                        
                        <td width="10%" class="list_c" style="font-size:9px">&nbsp;<%= [string range [format "%s" @notes.note_datetime@] 0 15] %></td>                                                  
                        <!-- FORMULARIO -->
                        <FORM METHOD="post" name="fe">
                        <INPUT type="hidden" name="card_id" value="@card_id@">
                        <INPUT type="hidden" name="user_id" value="@user_id@">
                        <INPUT type="hidden" name="note_id" value="@note_id@">
                        <INPUT type="hidden" name="nav_sel" value="@nav_sel@">
                        <td width="50%" class="list_c_sel">
                        <INPUT type="text" size="75" name="note_desc" value="@notes.value_s@"></td>
                        <td width="6%" class="list_c_sel">
                        <INPUT type="text" size="4" name="note_value" value="@notes.value_n@"></td>
                        <td width="3%" class="list_c_sel">
                        <if @notes.is_active@>
                                <if @notes.allow_act@>
                                <INPUT type="checkbox" size="1" name="note_act" value="1" checked="true">
                                </if>
                                <else>
                                <INPUT type="checkbox" size="1" name="note_act" value="1" checked="true" disabled>
                                <INPUT type="hidden" size="1" name="note_act_yes" value="1">
                                </else>
                        </if>
                        <else>
                                <if @notes.allow_act@>
                                <INPUT type="checkbox" size="1" name="note_act" value="1">
                                </if>
                                <else>
                                <INPUT type="checkbox" size="1" name="note_act" value="1" disabled>
                                </else>
                        
                        </else>
                        </td>
                        <td width="7%" align="center" class="list_c">                   
                                <INPUT type="hidden" name="mode_update" value="">               
                                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ok.gif" 
                                ALT="#cards.card_Accept#" title="#cards.card_Accept#" onclick="document.fe.mode_update.value='mode_update'">
                                <INPUT type="hidden" name="mode_cancel" value="">               
                                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ko.gif" 
                                ALT="#cards.card_Cancel#" title="#cards.card_Cancel#" onclick="document.fe.mode_cancel.value='mode_cancel'">
                        </td>           
                        </FORM>
                        <!-- FIN FORMULARIO -->                 
                                </else>
                        </else>
                </tr>
        </if>
        </multiple>
        </if>   
</multiple>
</else>
</else>
</else>
<TR>
<TD colspan="7" align="right">#cards.card_Without_academic_validity#</TD>
</TR>
</TABLE>
</td></TR>
</TABLE><BR><BR>
<if @error@><SCRIPT>alert("@msg_error@")</SCRIPT>
</if>
