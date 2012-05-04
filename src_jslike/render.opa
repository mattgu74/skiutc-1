type page = {string ref, string title, xhtml content}

module Render {
    function xhtml template(page page) {
        <div id="global">
<div id="header">
<br/>
<br/>
{Menu.html(page)}
</div>
<div id="center">
<div id="left">
<div class="left_cellule fbcell" onready={
        function(_) {
        Facebook.load()
        }}>
Facebook
<br/>
<br/>
<div class="fbplugin">
{Facebook.html({
                                                           
                                                           href :
                                                             "https://www.facebook.com/pages/SkiUTC/265089426858018",
                                                           width : "197",
                                                           height : "272",
                                                           faces : "true",
                                                           border : "#b7d4e3",
                                                           stream : "false",
                                                           header : "false"
                                                           })}
</div>
</div>
<div class="left_cellule">
Connectez vous
<br/>
<br/>{
        if (User.is_logged()) XmlConvert.of_alpha(User.loginbox())
        else
          <>
           <a class="button" href="{myCas.login_url()}"><strong>Etudiant UTC</strong></a>
           <br/><br/>
                            
           <a class="button" onclick={function(_) {
                                      Dom.toggle(#login_invite)
           }}><strong>Invité</strong></a><br/>
                            
           <div id="login_invite" style={[Css_build.display({css_none})]}>{
           User.loginbox()}</div></>}
</div>
</div>
<div id="right">
{page.content}
</div>
</div>
<div id="footer">
Site en <a href="http://www.opalang.org">OPA</a> par Matthieu Guffroy
<br/>
<br/>
<a href="accueil.html">Accueil</a>
</div>
</div>
    }
    function resource public(page page) {
        function xhtml googleanalytics(id) {
            <script type="text/javascript">
var _gaq = _gaq || [];
_gaq.push(['_setAccount', '{id}']);
_gaq.push(['_trackPageview']);
(function() {
var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
</script>
        }
        Resource.full_page("SkiUTC - " ^ page.title, template(page),
          <><link rel="stylesheet" type="text/css" href="res/css.css"/>
           {XmlConvert.of_alpha(googleanalytics("UA-25934255-1"))}</>,
          {success}, [])
    }
    function resource private(page page) {
        if (User.is_logged()) public(page)
        else
          public({
                  ref : "Private",
                  title : "Erreur 403",
                  content :
                    <div class="right_cellule">
Accés interdit !
<br/><br/>
Tu dois être connecté pour afficher cette page ! <br/>
Utilise l'interface de connexion dans la collone gauche, pour te connecter.<br/><br/>
<div class="info">Tu dois utiliser le CAS, le login/password est reservé pour les invités.</div>
</div>
                  })
    }
    function resource team(page page) {
        if (User.is_team()) public(page)
        else
          public({
                  ref : "Private",
                  title : "Erreur 403",
                  content :
                    <div class="right_cellule">
Accés interdit !
<br/><br/>
Cette page est réservé a la team...
</div>
                  })
    }
    function resource admin(page page) {
        if (User.is_admin()) public(page)
        else
          public({
                  ref : "Private",
                  title : "Erreur 403",
                  content :
                    <div class="right_cellule">
Accés interdit !
<br/><br/>
Cette page est réservé a l'administrateur...
</div>
                  })
    }
    function resource cas(page page) {
        if (myCas.get_status() != {unlogged}) public(page)
        else
          myCas.login_to("http://{Option.`default`("localhost",
                                    Option.`default`(some("localhost"),
                                      HttpRequest.get_host()))}{base_url}/{page.ref}")
    }
    function resource error() {
        public({
                ref : "404",
                title : "Erreur 404",
                content : <>Page introuvable</>
                })
    }
}