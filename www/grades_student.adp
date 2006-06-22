<link rel="stylesheet" href="cards.css" type="text/css">


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
  <tr class="list-header">
        <th colspan="3" class="block">&nbsp;<B>@block.percent_name@</B> (@block.percent@%)
        <if @block.rvalor@ gt 0>&nbsp;[>= @block.rvalor@] </if>
        </th>
        <th colspan="4" align="right" class="block_avg"><B>&nbsp;#cards.avg#: 
           <%= [format "%2.2f" @block.block_grade@] %></B>
          (<%= [format "%2.2f" @block.block_gradep@] %>)</th>
  </tr>   
  <tr class="list-odd" height="6">
        <th width="21%" class="uv_cell">#cards.card_Note#</th>
        <th width="9%" class="uv_cell">#cards.card_Date#</th>
        <th width="45%" class="uv_cell">#cards.card_Comment#</th>
        <th width="13%" class="uv_cell" colspan="3">#cards.card_Grade#</th>
        <th width="3%" class="uv_cell">#cards.card_Active#</th>                  
  </tr>
  <multiple name="grades">
        <if @grades.ref_percent@ eq @block.percent_id@>   
          <tr class="list-even" onmouseover="javascript:style.backgroundColor='#99ccff'" 
          onmouseout="javascript:style.backgroundColor='#FFFFFF'">
                <td width="21%" class="uv_cell">@grades.task_name@ 
                <if @grades.type@ eq 3>[@grades.task_percent@%]</if></td>
       <td width="9%" class="uv_cell"><%= [string range [format "%s" @grades.date_mod@] 0 15] %></td>
           <td width="45%" class="uv_cell">&nbsp;@grades.note_comment@</td>
           <td width="13%" class="uv_cell" align="right" colspan="3">
           <B>@grades.grade@ / @grades.max_grade@&nbsp;</B></td>
           <td width="3%" class="uv_cell">
       <if @grades.is_active@>
       <INPUT type="checkbox" size="1" name="noteact" checked disabled>
       </if><else>
       <INPUT type="checkbox" size="1" name="noteact" disabled>
       </else>                         
      </td>                   
        </if>
        </tr>
  </multiple>
</if>   
</multiple>
</else>
<TR>
<TD COLSPAN="7" align="right">#cards.grade_alert# - #cards.card_Without_academic_validity#
</TD>
</TR>
</table>
<BR>
