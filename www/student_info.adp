<SCRIPT LANGUAGE="JavaScript">
<!--
function check_text(campo, num, max) {
if (campo.value.length > max) campo.value = campo.value.substring(0, max);
else num.value = max - campo.value.length;
}
-->
</script>
<STYLE type="text/css">
.borde1 {border: 1px solid #5C81B7} 
.borde1a { background:#CCDDFF; width:25%} 
.borde2 {border-bottom: 1px solid #5C81B7}
.borde_top {border-top: 1px solid #5C81B7}
.borde_no_top {border-right: 1px solid #5C81B7; border-bottom: 1px solid #5C81B7; border-left:1px solid #5C81B7}
</style>

<TABLE class="form">
<CAPTION class="form">&nbsp;#cards.card_Personal_info#</CAPTION>
<TR class="form">
        <TH class="form">#dotlrn.student_role_pretty_name#: </TH>
        <TD class="form">@last_name@, @first_names@</TD>
        <TD ROWSPAN="5" class="photo">@photo_student;noquote@</TD>
</TR>
<TR class="form">
        <TH class="form">#cards.Email#: </TH>
        <TD class="form">@user_info.email@</TD>
</TR><TR class="form">
        <TH class="form">#cards.Home_page#: </TH>
        <TD class="form">@user_info.url@&nbsp;</TD>



<if @mode@ ne "info_edit">
</TR><TR class="form">
        <TH class="form">#cards.address#: </TH>
        <TD class="form">@address@&nbsp;</TD>
</TR><TR class="form">
        <TH class="form">#cards.phones#: </TH>
        <TD class="form">@phone1@&nbsp;</TD>
</TR>
<!-- MODE EDIT LINK **************************************************-->       
<TR class="form">
<FORM METHOD="post" name="fm_info">
        <TD class=""><INPUT type="hidden" name="user_id" value="@user_id@">
                <INPUT type="hidden" name="nav_sel" value="ficha">
                <INPUT type="hidden" name="mode" value="info_edit">
                <INPUT type="image" name="submit" value="submit" border="0" alt="#Edit Info" 
                title="#Edit Info" src="icons/edit.gif" style="margin:0;padding:0"></TD>
                </form>
        </TR>
</if><else>
<FORM METHOD="post" name="fe_info" onSubmit="">
<TR class="form"><TD class="form">#cards.address#: </TD>
        <TD class="form">
        <INPUT type="text" size="50" maxlength="50"  name="user_address" value="@address@"></TD>
        </TR>   
<TR class="form"><TD class="form">#cards.phones#: </TD>
        <TD class="form"><INPUT type="text" size="30" maxlength="30"  name="user_phones" value="@phone1@"></TD>
        </TR>
<!-- MODE UPDATE LINK **************************************************-->     
<TR><TD></TD>   
        <TD><INPUT type="hidden" name="user_id" value="@user_id@">
                <INPUT type="hidden" name="nav_sel" value="ficha">
                <INPUT type="hidden" name="mode" value="info_update">
                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ok.gif" 
                ALT="#cards.card_Accept#" title="#cards.card_Accept#" 
                onclick="document.fe_info.mode.value='info_update'">&nbsp;&nbsp;
                <INPUT type="image" name="submit" value="submit" size="10" title="#cards.card_Cancel#" 
                src="icons/ko.gif" ALT="#cards.card_Cancel#" 
                onclick="document.fe_info.mode.value='info_cancel'">
        </TD>
        </TR>
</FORM>
</else>

</TABLE>

<!-- STUDENT COMMENT --> 
<TABLE class="form">
<CAPTION class="form">&nbsp;#cards.comunication#</CAPTION>
<TR class="form">
        <TH class="form">#cards.student_comment#:<BR>
        <A HREF="student_card?user_id=@user_id@&nav_sel=ficha&mode=student_edit" title="#cards.student_comment# #cards.card_Edit#" class="noline"><img alt="#cards.student_comment# #cards.card_Edit#" src="icons/edit.gif"></A>
        </TH>
        <if @mode@ ne "student_edit">
                <!-- MODE EDIT LINK **************************************************-->       
        <TD class="form"><PRE>@comm_student@&nbsp;</PRE>
        

        </TD>
                
        </if><else>
                <FORM METHOD="post" name="fe_student" onSubmit="">      
        <TD class="form">
                <TEXTAREA rows="3" cols="80" name="student_comment" style="font:100% Arial; text-align:left"
                onKeyDown="check_text(this.form.student_comment,this.form.resto,1000);" 
                onKeyUp="check_text(this.form.student_comment,this.form.resto,1000)">@comm_student@</TEXTAREA>
                <BR>
                <SPAN style="font-size:80%">#cards.max_char1# 1000 #cards.max_char2# 
        <input readonly type="text" name="resto" size="4" maxlength="4" value="1000"
        style="font-size:90%; text-align: center"></span>
        
                
        
                <INPUT type="hidden" name="user_id" value="@user_id@">
                <INPUT type="hidden" name="nav_sel" value="ficha">
                <INPUT type="hidden" name="mode" value="">
                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ok.gif" 
                ALT="#cards.card_Accept#" title="#cards.card_Accept#" 
                onclick="document.fe_student.mode.value='student_update'">&nbsp;&nbsp;
                <INPUT type="image" name="submit" value="submit" size="10" title="#cards.card_Cancel#" 
                src="icons/ko.gif" ALT="#cards.card_Cancel#" 
                onclick="document.fe_student.mode.value='';document.fe_student.student_comment.value='' ">
                </TD>
                </form>         

        </else>         

        </tr>
        <TR class="form">
                <TH class="form">#cards.teacher_comment#: </TH>
                <TD class="form"><PRE>@comm_teacher@&nbsp;</PRE></TD>
        </TR>
</TABLE>
        
        
        
        
        
        
        
<BR>
