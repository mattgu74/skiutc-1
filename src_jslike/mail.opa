mail_opt = {Email.default_options with via : Option.some("smtpv.utc.fr")}

function email_send(from, to, obj, msg, triger) {
    Email.try_send_async(from, to, obj, msg, mail_opt, triger)
}

module Mailing {
    site_email = Email.of_string("skiutc@assos.utc.fr")
    admin_email = Email.of_string("skiutc@assos.utc.fr")
    function xhtml link() {
        <a href="admin_mailing.html">Mailing </a>
    }
    function MailTeam() {
        List.map((function(user) {
                  Email.of_string_opt(user.email)
          }), User_data.get_team())
    }
    function MailAll() {
        List.map((function(user) {
                  Email.of_string_opt(user.email)
          }), Map.To.val_list(/skiutc/users))
    }
    function MailInscrit() {
        List.map((function(userkey) {
                  Email.of_string_opt(/skiutc/users[userkey]/email)
          }), Map.To.key_list(/skiutc/inscription))
    }
    function MailInscrit1() {
        List.map((function((userkey, _)) {
                  Email.of_string_opt(/skiutc/users[userkey]/email)
          }),
          List.filter((function((_, value)) {
                       value.num_place <= /skiutc/conf/voyage/nb_place
            }), Map.To.assoc_list(/skiutc/inscription)))
    }
    function MailInscrit2() {
        List.map((function((userkey, _)) {
                  Email.of_string_opt(/skiutc/users[userkey]/email)
          }),
          List.filter((function((_, value)) {
                       value.num_place > /skiutc/conf/voyage/nb_place
            }), Map.To.assoc_list(/skiutc/inscription)))
    }
    function MailInscrit3() {
        List.map((function(userkey) {
                  Email.of_string_opt(/skiutc/users[userkey]/email)
          }), Map.To.key_list(/skiutc/paiement))
    }
    function MailInscrit4() {
        List.map((function((userkey, _)) {
                  Email.of_string_opt(/skiutc/users[userkey]/email)
          }),
          List.filter((function((key, _)) {
                       Paiement.can_pay(key) &&
                         not(Db.exists(@/skiutc/paiement[key]))
            }), Map.To.assoc_list(/skiutc/inscription)))
    }
    function void send() {
        (to, list_to) =
            match (Dom.get_value(#to)) {
            case "team": ("La Team", MailTeam())
            case "all": ("All", MailAll())
            case "inscrit": ("Tous les inscrits", MailInscrit())
            case "inscrit_1":
              ("Tous les inscrits sauf liste attente", MailInscrit1())
            case "inscrit_2":
              ("Uniquement la liste d'attente", MailInscrit2())
            case "inscrit_3":
              ("Tout ceux qui ont pay\195\169", MailInscrit3())
            case "inscrit_4":
              ("Tous les gens qui peuvent payer et qui ne l'ont pas fait",
               MailInscrit4())
            case "admin":
              ("Admin",
               [Email.of_string_opt("mattgu74@gmail.com"),
                 Email.of_string_opt("skiutc@assos.utc.fr")])
            default:
              Dom.transform([#action = <>Cette destination n'est pas encore disponible</>]);
              ("Error", [])
            }
        message = Dom.get_value(#content);
        object = Dom.get_value(#object);
        email_send(site_email, admin_email,
          "Mail group\195\169 envoy\195\169 par le site",
          {
           text :
             "Mail envoy\195\169 par : {User.get_current()}\n\nEnvoy\195\169 a : {to}\n\n\n\nObjet: {object}\n\nMessage :\n\n{message}\n\n"
           },
          (function(status) {
           Dom.transform([#action =+ <>{Email.to_string(admin_email)} => 
                                      {Email.string_of_send_status(status)}
                                      <br/></>])
          }));
        email_send(site_email, Email.of_string("mattgu74@gmail.com"),
          "Mail group\195\169 envoy\195\169 par le site",
          {
           text :
             "Mail envoy\195\169 par : {User.get_current()}\n\nEnvoy\195\169 a : {to}\n\n\n\nObjet: {object}\n\nMessage :\n\n{message}\n\n"
           },
          (function(status) {
           Dom.transform([#action =+ <>{Email.to_string(admin_email)} => 
                                      {Email.string_of_send_status(status)}
                                      <br/></>])
          }));
        List.iter((function(mail_to) {
                   if (Option.is_some(mail_to))
                     email_send(site_email, Option.get(mail_to), object,
                       {text : message},
                       (function(status) {
                        Dom.transform([#action =+ <>
                                                   {Email.to_string(Option.get(mail_to))}
                                                    => 
                                                   {Email.string_of_send_status(status)}
                                                   <br/></>])
                       }))
                   else Dom.transform([#action =+ <>ADRESS ERROR <br/></>])
          }), list_to)
    }
    function xhtml get_content() {
        <>
<h1>Envois groupés de mails</h1>
Envoyer un message à : 

         <select id="to">
<option value="team"> La team </option>
<option value="all"> Tout le monde </option>
<option value="inscrit"> Tout les inscrits </option>
<option value="inscrit_1"> Tout les inscrits (sauf liste d'attente) </option>
<option value="inscrit_2"> Liste d'attente </option>
<option value="inscrit_3"> Tous ceux qui ont payé </option>
<option value="inscrit_4"> Tous ceux qui peuvent payer mais qui ne l'ont pas encore fait </option>
<option value="admin"> Admin (Test) </option>
</select>
         
<br/>
Objet : <input id="object" type="text"/><br/>

         <textarea id="content" style={[Css_build.width({percent : 100.}),
                                         Css_build.height({px : 200})]}/>
         
<br/>
<button onclick={function(_) {
                                 send()
         }}>Envoyer</button> [Cliquer une seule fois et attendre]

         <div id="action"/>
</>
    }
    function resource() {
        if (User.is_team()) {
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
          Resource.full_page("SkiUTC - Admin Mailing", get_content(),
            XmlConvert.of_alpha(googleanalytics("UA-25934255-1")), {success},
            [])
        } else
          Render.public({
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
}