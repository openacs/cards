<SCRIPT LANGUAGE="JavaScript">
<!--
function check_text(campo, num, max) {
if (campo.value.length > max) campo.value = campo.value.substring(0, max);
else num.value = max - campo.value.length;
}
-->
</script>

<TABLE class="uv_table" summary="#cards.summary_Private_comments#">
  <caption class="uv_table">#cards.comments#</caption>
  <tr class="uv_table_header">
        <th width="10%" class="uv_cell">#cards.card_Date#</th>
        <th width="AUTO" class="uv_cell">#cards.card_Comment#</th>       
        <th width="8%" class="uv_cell" colspan="2">#cards.card_Action#</th>      
  </tr>
 
<if @comments:rowcount@ ne 0> <!-- SI HAY COMMENTS -->
  <multiple name="comments">
    <if @comments.comment_id@ eq @comment_id@> 
                <tr>              
                
                <td width="10%" class="uv_cell">
                &nbsp;<span class="char"><%= [string range [format "%s" @comments.date_mod@] 0 15] %></span></td>   
                
                <FORM METHOD="post" name="fec">
                  <INPUT type="hidden" name="user_id" value="@user_id@">
                  <INPUT type="hidden" name="comment_id" value="@comment_id@">
                  <INPUT type="hidden" name="nav_sel" value="comment">
                  <INPUT type="hidden" name="mode" value=""> 
                <td width="70%" class="uv_cell">
                <CENTER>
                <TEXTAREA rows="3" cols="100" name="comment"
                onKeyDown="check_text(this.form.comment,this.form.resto,400);" 
                onKeyUp="check_text(this.form.comment,this.form.resto,400)">@comments.comment@</TEXTAREA><BR>
                <SPAN class="char"># Máximo 400 carácteres. Quedan: 
                <input readonly type="text" name="resto" size="3" maxlength="3" value="400"></span></center>    
                
                <td width="7%" align="center" class="uv_cell" colspan="2">                                        
                  <INPUT type="image" name="submit" value="submit" size="10" src="icons/ok.gif" 
       ALT="#cards.card_Accept#" title="#cards.card_Accept#" onclick=
           "document.fec.mode.value='comment_update'">
         <INPUT type="image" name="submit" value="submit" size="10" src="icons/ko.gif" 
        ALT="#cards.card_Cancel#" title="#cards.card_Cancel#" onclick=
                "document.fec.mode.value='cancel'">
                </td>           
       </FORM></TR>
        </if><else><!-- MODO LISTAR -->
  
                <if @mode@ eq "comment_edit">
                        <tr class="list-even">
                </if><else>
                        <tr class="list-even" onmouseover="javascript:style.backgroundColor='#99ccff'" 
                        onmouseout="javascript:style.backgroundColor='#FFFFFF'">
                </else>  
          
          <td width="10%" class="uv_cell">
          &nbsp;<span class="char"><%= [string range [format "%s" @comments.date_mod@] 0 15] %></span></td>
                <td  width="AUTO" class="uv_cell"><PRE>@comments.comment@</PRE></td>
                <if @mode@ eq "comment_edit"> <!-- MODO EDICION -->     
                        <td width="6%" class="uv_cell" colspan="2">&nbsp;</td>      
                </if><else>   
                <FORM METHOD="post" name="fce">
                  <td width="3%" align="center" class="list">                                     
                        <INPUT type="hidden" name="user_id" value="@user_id@">
                        <INPUT type="hidden" name="comment_id" value="@comments.comment_id@">
                        <INPUT type="hidden" name="nav_sel" value="comment">
                        <INPUT type="hidden" name="mode" value="comment_edit">
                        <INPUT type="image" name="submit" value="submit" border="0" src="icons/edit.gif" 
                        alt="#cards.card_Edit# #cards.card_Comment#" title="#cards.card_Edit# #cards.card_Comment#">   
                  </td>
                </form>
       <FORM METHOD="post" name="fcd">
                  <td width="3%" class="uv_cell" align="left">
                        <INPUT type="hidden" name="user_id" value="@user_id@">
                        <INPUT type="hidden" name="comment_id" value="@comments.comment_id@">
                        <INPUT type="hidden" name="nav_sel" value="comment">
                        <INPUT type="hidden" name="mode" value="comment_delete">
                        <INPUT type="image" name="submit" value="submit" border="0" alt="#cards.card_Delete# #cards.card_Comment#" title="#cards.card_Delete# #cards.card_Comment#" src="icons/papelera.gif">                
         </td>                   
       </form>          
           </else>
        </else>
  </multiple>
</if>

<if @mode@ ne "comment_edit">
<!-- INSERT COMMENTS  ****************************************-->
  <FORM METHOD="post" name="fit">
        <INPUT type="hidden" name="user_id" value="@user_id@">
        <INPUT type="hidden" name="nav_sel" value="comment">
        <INPUT type="hidden" name="mode" value="comment_insert">                
        <tr class="uv_cell_insert">
        
        <td width="10%" class="uv_cell_insert">&nbsp;<%= [string range [format "%s" @datetime@] 0 15] %></td>  
        <td  width="70%" class="uv_cell_insert">
        <CENTER>
                <TEXTAREA rows="3" cols="100" name="comment"
                onKeyDown="check_text(this.form.comment,this.form.resto,400);" 
                onKeyUp="check_text(this.form.comment,this.form.resto,400)"></TEXTAREA><BR>
                <SPAN class="char">#cards.max_char1# 400 #cards.max_char2#
                <input readonly type="text" name="resto" size="3" maxlength="3" value="400" ></span></center>   
        <!--<INPUT type="text" size="70" name="comment" value="">--></td>
        
        <td width="6%" align="center" class="uv_cell_insert" colspan="2">
        <INPUT type="image" name="submit" value="submit" size="10" src="icons/plus.gif"
        ALT="#dotlrn.New# #cards.card_Comment#" title="#dotlrn.New# #cards.card_Comment#"></td>           
  </tr>
  </form>  
 </if>
</table>
<H4>#cards.private_comment_note#</H4>
