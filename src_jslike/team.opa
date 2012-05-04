module Team {
    function xhtml picture(User.t user) {
        hash = Crypto.Hash.md5(user.email);
        <img src="http://www.gravatar.com/avatar/{hash}?s=90" alt="{user.prenom} {user.nom}"/>
    }
    function xhtml render(User.t user) {
        <div class="right_cellule left">
{user.prenom} {user.nom} ({match (user.login_utc) {
        case ~{ utc }: utc
        default: ""
        }})
<br/><br/>
{picture(user)} - {user.statut}
</div>
    }
    function xhtml xhtml_team() {
        List.fold((function(v, acc) {
                   <>{render(v)}{acc}</>
          }), User_data.get_team(), <></>)
    }
    function xhtml content() {
        <>

         <div class="right_cellule">
La Team
<br/><br/>
<div class="info"> Pour contacter la team, envoie un mail à l'adresse : skiutc@assos.utc.fr </div>
<br/>
</div>
         
{xhtml_team()}
</>
    }
    function get_page() {
        {ref : "team.html", title : "La Team", content : content()}
    }
}