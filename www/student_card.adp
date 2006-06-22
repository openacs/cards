<master>
<property name="title">@community_name@</property>
<link rel="stylesheet" href="cards.css" type="text/css">

<!-- CABECERA -->

<DIV  class="all">
        <div class="float"><span class="cursive">#cards.card_Student#</span>: <span class="bold">@user_name@&nbsp;&nbsp;</span></div>
        <div class="float"><span class="cursive">#cards.card_Subjet#</span>: <span class="bold">@community_name@&nbsp;&nbsp;</span></div>
        <div class="back">
                <A HREF="../one-community" class="back">#cards.card_Back#</A>
        </div>
<div class="spacer">&nbsp;</div>


<if @allow_view_grades@ eq 1>
<!-- BARRA DE NAVEGACION-->
<div class="navbar">
<!-- Datos personales ***********************************************************************-->
        <a href="student_card?user_id=@user_id@&nav_sel=ficha" class="button_item">#cards.card_Personal_info#</a>


<!-- Notas Completas ***********************************************************************-->         
        <a href="student_card?user_id=@user_id@" class="button_item">#cards.card_Grades#</a>

<!-- Bloques de notas ***********************************************************************-->                  
        <multiple name="blocks">
        <a href="student_card?user_id=@user_id@&nav_sel=@blocks.percent_id@" class="button_item">@blocks.percent_name@</a>
  </multiple>
</if>
<div class="spacer">&nbsp;</div>
  
<div>
  

<!-- DATOS PERSONALES *******************************************************************-->
<if @nav_sel@ eq "ficha">
        <include src="student_info" &=user_id=@user_id@ &=mode=@mode@>
</if>



<!-- NOTAS *******************************************************************-->
<if @allow_view_grades@ eq 1>
        <if @nav_sel@ ne "ficha" and @nav_sel@ ne "comment" and @nav_sel@ ne 0>
                <include src="grades_student" &=user_id=@user_id@ &=nav_sel=@nav_sel@>
        </if>
</if>



</div>
<BR>


<if @error@>
<SCRIPT>
eval ("@cambia@")
eval("@senyala@" + "'#ffcc00'")
alert("@msg_error@")
</SCRIPT>
</if>
