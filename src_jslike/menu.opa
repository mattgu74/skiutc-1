module Menu {
    function xhtml html(page page) {
        function string class(string ref) {
            if (ref == page.ref) "menu_select" else "menu"
        }
        <table cellpadding="10" cellspacing="0" width="100%">
<tbody>
<tr>
<td><a href="accueil.html"><div class="{
        class("accueil.html")}">Accueil</div></a></td>
<td><a href="presentation.html"><div class="{
        class("presentation.html")}">Le voyage</div></a></td>
{if (User.is_logged())
                                                                 <td><a href="mon_compte.html"><div class="{
                                                                 class("mon_compte.html")}">Mon Compte</div></a></td>
        else <></>}
<td><a href="asso.html"><div class="{class("asso.html")}">L'Asso</div></a></td>
<td><a href="team.html"><div class="{
        class("team.html")}">La Team</div></a></td>
<td><a href="partenaires.html"><div class="{
        class("partenaires.html")}">Partenaires</div></a></td>
</tr>
</tbody>
</table>
    }
}