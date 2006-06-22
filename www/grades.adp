<SCRIPT LANGUAGE="JavaScript">
<!--
function check_text(campo, num, max) {
if (campo.value.length > max) campo.value = campo.value.substring(0, max);
else num.value = max - campo.value.length;
}



function convertComma(str){
var out = "", flag = 0;

for (i = 0; i < str.length; i++) {
        if (str.charAt(i) != ",") {
                out += str.charAt(i);
                flag = 0;
        } else {
                if(flag == 0) {
                        out += ".";
                        flag = 1;
                }
        }
}

if (isNaN(out) || str == "") {
        out = 0.00
} 

return out;
}
-->
</script>

<div class="spacer">&nbsp;</div>
<TABLE class="uv_table1" summary="#cards.summary_card_grades#">
        <tr>
        <th colspan="3">#cards.card_Grades_list#</th>
        <th colspan="4" class="final_grade">#cards.card_Average_grade#: 
        <if @nota_final@ ne "NP" and @nota_final@ ne "4*"><%= [format "%2.2f" @nota_final@] %></if>
        <else>@nota_final@</else>
        </th>
  </tr>

<!--  ****************  MOSTRAR - NOTAS ALUMNO *************** -->
<if @block:rowcount@ eq 0>
#cards.card_No_notes#
</if>
<else>
<multiple name="block">
<if @nav_sel@ eq @block.percent_id@ or @nav_sel@ eq "">
  <tr>
        <th colspan="3" class="block">&nbsp;<B>@block.percent_name@</B> (@block.percent@%)
        <if @block.rvalor@ gt 0>&nbsp;[>= @block.rvalor@] </if>
        </th>
        <th colspan="4" align="right" class="block_avg"><B>&nbsp;#cards.avg#: 
           <%= [format "%2.2f" @block.block_grade@] %></B>
           
          (<%= [format "%2.2f" @block.block_gradep@] %>)</th>
         
  </tr>
        
  <tr class="list-odd" height="6">
        <th width="21%" class="uv_cell">#cards.card_Note#</th>

        <th width="12%" class="uv_cell">#cards.card_Date#</th>
        <th width="45%" class="uv_cell">#cards.card_Comment#</th>
        <th width="10%" class="uv_cell">#cards.card_Grade#</th>
        <th width="3%" class="uv_cell">#cards.card_Active#</th>                  
        <th width="5%" class="uv_cell">#cards.card_Action#</th>      
  </tr>
  <multiple name="grades">
        <if @grades.ref_percent@ eq @block.percent_id@>
          <if @grades.note_id@ ne @note_id@> <!--SI NO editamos -->
          <tr class="list-even" onmouseover="javascript:style.backgroundColor='#99ccff'" 
          onmouseout="javascript:style.backgroundColor='#FFFFFF'">
                <td width="21%" class="uv_cell">@grades.task_name@ 
                <if @grades.type@ eq 3>[@grades.task_percent@%]</if></td>

       <td width="9%" class="uv_cell"><%=[string range [format "%s" @grades.date_mod@] 0 15]%></td>
           <td width="45%" class="uv_cell">&nbsp;@grades.note_comment@</td>
           <td width="10%" class="uv_cell"><B>@grades.grade@ / @grades.max_grade@&nbsp;</B></td>
           <td width="3%" class="uv_cell">
       <if @grades.is_active@>
       <INPUT type="checkbox" size="1" name="noteact" checked disabled>
       </if><else>
       <INPUT type="checkbox" size="1" name="noteact" disabled>
       </else>                         
      </td>                   
                        
<!-- MODE EDIT LINK **************************************************-->                               
        <FORM METHOD="post" action="student_notes#@grades.note_id@" name="fm">
        <td width="5%" align="center" class="list">                     
        <INPUT type="hidden" name="user_id" value="@user_id@">
        <INPUT type="hidden" name="note_id" value="@grades.note_id@">
        <INPUT type="hidden" name="nav_sel" value="@nav_sel@">
        <INPUT type="hidden" name="mode" value="note_edit">
        <INPUT type="image" name="submit" value="submit" border="0" alt="#cards.card_Edit# #cards.card_Grade#" title="#cards.card_Edit# #cards.card_Grade#" src="icons/edit.gif">
        </td>
        </form>                 
        </if><else> <!--SI editamos -->
          <if @grades.note_id@ ne @note_id@> <!--NO ES LA EDITADA -->
                <tr class="list-even">
                <td width="21%" class="uv_cell">@grades.task_name@ 
                <if @grades.type@ eq 3>[@grades.task_percent@%]</if></td>
                <td width="9%" class="uv_cell">&nbsp;
                        <%= [string range [format "%s" @grades.date_mod@] 0 15] %></td>
                <td width="45%" class="uv_cell">&nbsp;@grades.task_comment@</td>
           <td width="10%" class="uv_cell" align="right"><B>@grades.grade@ / @grades.max_grade@&nbsp;</B></td>
                <td width="3%" class="uv_cell">
                        <if @grades.is_active@>
                        <INPUT type="checkbox" size="1" name="noteact" checked disabled>
                        </if><else><INPUT type="checkbox" size="1" name="noteact" disabled></else></td>
                        <td width="7%" align="right" class="uv_cell">&nbsp;</td>                         
          </if><else> <!-- ES LA EDITADA -->
                <tr class="uv_cell_insert">
                <td width="21%" class="uv_cell_insert">@grades.task_name@ 
                <if @grades.type@ eq 3>[@grades.task_percent@%]</if></td>

                <td width="9%" class="uv_cell_insert">&nbsp;
                        <%= [string range [format "%s" @grades.date_mod@] 0 15] %></td>
                <!-- FORMULARIO -->
                
                <FORM METHOD="post" name="fe">
                <INPUT type="hidden" name="user_id" value="@user_id@">
                <INPUT type="hidden" name="note_id" value="@note_id@">
                <INPUT type="hidden" name="nav_sel" value="@nav_sel@">
                <td width="45%" class="uv_cell_insert"><CENTER>
                <A name="@note_id@">
                <TEXTAREA rows="3" cols="60" name="note_comment" wrap 
                onKeyDown="check_text(this.form.note_comment,this.form.resto,400);" 
                onKeyUp="check_text(this.form.note_comment,this.form.resto,400)">@grades.note_comment@</TEXTAREA><BR>

                <SPAN class="char"># Máximo 400 carácteres. Quedan: 
                <input readonly type="text" name="resto" size="3" maxlength="3" value="400"></span></center>
                <!--<INPUT type="text" size="75" name="note_comment" value="@grades.note_comment">--></td>
                <td width="8%" class="uv_cell_insert" align="right">
                <INPUT type="text" size="4" name="note_grade" value="@grades.grade@"
                onblur="this.value = convertComma(this.value);">&nbsp;</td>
                <td width="3%" class="uv_cell_insert">
                <if @grades.is_active@>
                  <if @grades.type@ eq 2>
                  <INPUT type="checkbox" size="1" name="note_act" value="1" checked="true">
                  </if><else>
                  <INPUT type="checkbox" size="1" name="note_act" value="1" checked="true" disabled>
                  <INPUT type="hidden" size="1" name="note_act_yes" value="1">
                  </else>
                </if>
                <else>
                  <if @grades.type@ eq 2>
                  <INPUT type="checkbox" size="1" name="note_act" value="1">
                  </if>
                  <else>
                        <INPUT type="checkbox" size="1" name="note_act" value="1" disabled>
                  </else>
                </else>
                </td>
                <td width="5%" align="center" class="uv_cell_insert">                   
                <INPUT type="hidden" name="mode" value="">               
                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ok.gif" 
                ALT="#cards.card_Accept#" title="#cards.card_Accept#"
                onclick="document.fe.mode.value='note_update'">
                <INPUT type="image" name="submit" value="submit" size="10" src="icons/ko.gif" 
                ALT="#cards.card_Cancel#" title="#cards.card_Cancel#" 
                onclick="document.fe.mode.value=''">
                </td>  
                </FORM>
          </else>
        </else>
        </tr>
  </if>
  </multiple>
</if>   
</multiple>
</else>
<TR>
<TD COLSPAN="6" align="right">#cards.card_Without_academic_validity#
</TD>
</TR>
</table>
<BR>
