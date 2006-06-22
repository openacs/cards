<if @mode@ ne "list">
<MASTER>
</if>

<link rel="stylesheet" href="cards.css" type="text/css">

<!-- CABECERA -->
<DIV width="100%">
<div class="comm">#cards.card_Orla#: @community_name@</div>
<div class="back">
        <A HREF="cards_list" class="back">#cards.card_Back#</A>
</div>

<div class="spacer">&nbsp;</div>


<div class="container">
        <multiple name="photos">
<!--
<%= [set idx [expr @photos.rownum@ % 7]] 
        set idx @idx@
%>
-->
        <if @idx@ eq 0>         
                <div class="float">
                        @photos.student;noquote@
                </div>          
                <div class="spacer">&nbsp;</div>
        </if>
        <else>
                <div class="float">
                        @photos.student;noquote@
                </div>
        </else>
        </multiple>
        <div class="spacer">&nbsp;</div>
</div>

<if @mode@ ne "list">
<a href="list-photos?mode=list">#cards.print_version#</a>
</if>
<if @error@><SCRIPT>alert("@msg_error@")</SCRIPT>
</if>


