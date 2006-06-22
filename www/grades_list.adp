<if @mode@ ne "list"><master></if>
<else>
<link rel="stylesheet" type="text/css" href="/resources/acs-templating/lists.css" media="all" />
</else>
<link rel="stylesheet" href="cards.css" type="text/css">



<div class="all">
<!-- CABECERA -->
<div class="comm">@community_name@</div>
<div class="back">
        <A HREF="cards_list" class="back">#cards.card_Back#</A>
</div>
<div class="spacer">&nbsp;</div>
<div class="title">#cards.card_Grades_list#</div>

<listtemplate name="list_grades"></listtemplate>
<P><SPAN class="cursive">@student:rowcount@ #cards.card_Students#  &nbsp;&nbsp;&nbsp;&nbsp;</SPAN>
<SPAN class="underline">#cards.card_Passed#</SPAN>: <SPAN class="bold">@passed@ &nbsp;&nbsp;&nbsp;&nbsp;</SPAN>
<SPAN class="underline">#cards.card_Not_passed#</SPAN>: <SPAN class="bold">@not_passed@&nbsp;&nbsp;&nbsp;&nbsp;</SPAN>
<SPAN class="underline">#cards.card_Not_done#</SPAN>: <SPAN class="bold">@not_presented@</SPAN>
<BR><BR>       
<if @mode@ ne "list">
        <form name="gt" action="" method="post">
        <input type="hidden" name="mode" value="csv">
        <INPUT type="submit" value="#cards.generate_csv#">&nbsp;&nbsp;&nbsp;&nbsp;
        <INPUT type="button" value="#cards.print_version#"      onclick="location.href='grades_list?mode=list'">
        <BR><BR>
#cards.card_Without_academic_validity#
        </form>
</if>
       

</div>
<BR><BR>
<!--<if error@><SCRIPT>alert("@msg_error")</SCRIPT></if>-->
