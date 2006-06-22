<MASTER>
<link rel="stylesheet" href="cards.css" type="text/css">

<DIV id="all" class="all">
<!-- CABECERA -->
        <div class="comm">@community_name@</div>
        <div class="back">
                <A HREF="../one-community" class="back">#cards.card_Back#</A>
        </div>

<div class="spacer">&nbsp;</div>

<!-- MENU DE OPCIONES  -->

        <A HREF="manage_blocks" class="button_item" title="#cards.tooltip_Setup_evaluation#">#cards.card_Setup_evaluation#</A>
        <A HREF="manage_tasks" class="button_item" title="#cards.tooltip_Manage_notes#">#cards.card_Manage_notes#</A>
        <A HREF="eval2cards" class="button_item"  title="#cards.tooltip_Eval2task#">#cards.import_grades#</A>
    <A HREF="grades_list" class="button_item" title="#cards.tooltip_List_grades#">#cards.card_Grades_list#</A>
        <A HREF="list-photos" class="button_item" title="#cards.tooltip_List_photos#">#cards.card_Orla#</A>
<div class="spacer">&nbsp;</div>

<!--  LLISTA D'ALUMNES EN CSV -->
<if @mode@ eq "csv">
<listtemplate name="csv_members"></listtemplate>
</if>

<!-- CAPÇALERA LLISTAT ALUMNES -->
<table class="uv_list" summary="#cards.summary_List_alum#">
<CAPTION class="uv_list">#cards.card_Student_records#</CAPTION>
  <tr class="uv_list_header">
    <th class="uv_list">&nbsp;</th>
    <th class="uv_list">#dotlrn.Last_Name#&nbsp;&nbsp;
                <A HREF="cards_list?order=last_name&order_dir=asc" class="noline">
                        <IMG SRC="icons/up.gif" alt="#cards.tooltip_orderby_asc#"></A>
                <A HREF="cards_list?order=last_name&order_dir=desc" class="noline">
                        <IMG SRC="icons/down.gif" alt="#cards.tooltip_orderby_desc#"></A>               
        </th>
        <th class="uv_list">#dotlrn.First_Name#&nbsp;&nbsp;
                <A HREF="cards_list?order=first_names&order_dir=asc" class="noline">
                        <IMG SRC="icons/up.gif" alt="#cards.tooltip_orderby_asc#"></A>
                <A HREF="cards_list?order=first_names&order_dir=desc" class="noline">
                        <IMG SRC="icons/down.gif" alt="#cards.tooltip_orderby_desc#"></A>
        </th>
        <th class="uv_list">#dotlrn.Email#&nbsp;&nbsp;
                <A HREF="cards_list?order=email&order_dir=asc" class="noline">
                        <IMG SRC="icons/up.gif" alt="#cards.tooltip_orderby_asc#"></A>
                <A HREF="cards_list?order=email&order_dir=desc" class="noline">
                        <IMG SRC="icons/down.gif" alt="#cards.tooltip_orderby_desc#"></A>       
        </th>
  </tr>

<!-- LLISTAT D'ALUMNES -->
<multiple name="current_members">
  <if @current_members.rownum@ odd>
    <tr class="list-odd" onmouseover="javascript:style.backgroundColor='#99ccff'" onmouseout="javascript:style.backgroundColor='#EAF2FF'">
  </if><else>
    <tr class="list-even" onmouseover="javascript:style.backgroundColor='#99ccff'" onmouseout="javascript:style.backgroundColor='#FFFFFF'">
  </else>
    <td class="uv_list"><B>@current_members.rownum@</B></td>
    <td class="uv_list">
                <A HREF="student_notes?user_id=@current_members.user_id@" class="alum">
                        @current_members.last_name@</A></td>
    <td class="uv_list">
                <A HREF="student_notes?user_id=@current_members.user_id@" class="alum">
                        @current_members.first_names@</A>       
        </td>
    <td class="uv_list">
                <A HREF="student_notes?user_id=@current_members.user_id@" class="alum">
                        @current_members.email@</A>       
        </td>  
  </tr>
</multiple>
</table><BR>
<%= @current_members:rowcount@ %> #dotlrn.student_role_pretty_plural#<BR>
<A HREF="cards_list?mode=csv" class="csv">#cards.generate_csv#</A>

</div>
<!--<P>Numero de cards creadas: @num_cards_created 
<P>Número de notas/tareas de la comunidad: @num_notes_created -->


