module Mon_compte {
    function edit_profil(login) {
        me = User_data.get(login);
        function select_option(show, value, checked) {
            if (checked)
              <option value={value} selected="selected">{show}</option>
            else <option value={value}>{show}</option>
        }
        function save() {
            prenom = Dom.get_value(#prenom);
            nom = Dom.get_value(#nom);
             sexe = {
                jlog(Dom.get_value(#sexe));
                match (Dom.get_value(#sexe)) {
                case "H": {male}
                case "F": {female}
                default: {male}
                }
            }
            email = Dom.get_value(#email);
            tel = Dom.get_value(#tel);
            adresse = Dom.get_value(#adresse);
            taille = Dom.get_value(#taille);
            poids = Dom.get_value(#poids);
            pointure = Dom.get_value(#pointure);
            taille_vet = Dom.get_value(#taille_vet);
             statut = {
                tmp = Dom.get_value(#statut);
                if (String.is_empty(tmp)) "Aucun" else tmp
            }
            User_data.save(login,
              {User_data.get(login) with ~prenom, ~nom, ~sexe, ~email,
               ~statut, ~tel, ~adresse, ~taille, ~poids, ~pointure,
               ~taille_vet});
            Client.reload()
        }
        Dom.transform([#tool_box = <div id="shadow" style="display:none; position:fixed; top:0; left:0; width: 100%; height: 100%; background-color: #ccc; z-index: 10; opacity:0.7; filter: alpha(opcity=70);"/>]);
        Dom.show(#shadow);
        Dom.transform([#tool_box =+ <div id="my_profil">
{Popup.xhtml("Mon profil",
                                                            <>
Prénom : 
                                                             <input id="prenom" value={me.prenom}/>
                                                             <br/>
Nom : 
                                                             <input id="nom" value={me.nom}/>
                                                             <br/>
Sexe : 
                                                             <select id="sexe">
{
                                                             select_option("Homme",
                                                               "H",
                                                               me.sexe ==
                                                                 {male})}
{
                                                             select_option("Femme",
                                                               "F",
                                                               me.sexe ==
                                                                 {female})}
</select>
                                                             
<br/>
Email : 
                                                             <input id="email" value={me.email}/>
                                                             <br/>
                                                             
Telephone : 
                                                             <input id="tel" value={me.tel}/>
                                                              (ton portable pour pouvoir te joindre en cas de soucis)
                                                             <br/>
Adresse : 
                                                             <textarea id="adresse">{me.adresse} </textarea>
                                                              <br/>
<br/>
                                                             
-- Les infos ci dessous sont à destination du Tour Opérateur pour prévoir ski/surf.

                                                             <br/>
Poids : 
                                                             <input id="poids" value={me.poids}/>
                                                             Kg<br/>
                                                             
Taille : 
                                                             <input id="taille" value={me.taille}/>
                                                             Cm<br/>
                                                             
Pointure : 
                                                             <input id="pointure" value={me.pointure}/>
                                                             <br/>
<br/>
                                                             
Taille vetement : 
                                                             <select id="taille_vet">
{
                                                             select_option("XS",
                                                               "XS",
                                                               me.taille_vet ==
                                                                 "XS")}
{
                                                             select_option("S",
                                                               "S",
                                                               me.taille_vet ==
                                                                 "S")}
{
                                                             select_option("M",
                                                               "M",
                                                               me.taille_vet ==
                                                                 "M")}
{
                                                             select_option("L",
                                                               "L",
                                                               me.taille_vet ==
                                                                 "L")}
{
                                                             select_option("XL",
                                                               "XL",
                                                               me.taille_vet ==
                                                                 "XL")}
{
                                                             select_option("XXL",
                                                               "XXL",
                                                               me.taille_vet ==
                                                                 "XXL")}
</select>
                                                             
<br/>
                                                             
* Cette info nous servira si nous réalisons un vétement SkiUTC (Pull / tee-shirt...)
                                                             <br/>
<br/>

                                                             {if (me.team_skiutc)
                                                                <>
                                                                 Statut dans la team : 
                                                                 <input id="statut" value={me.statut}/>
                                                                 <br/></>
                                                             else <></>}

                                                             <br/>

                                                             <a onclick={(
                                                             function(_) {
                                                             save()
                                                             })}>Valider</a>
                                                             
</>)}
</div>]);
        void
    }
    function profil() {
        function is_ok(bool param) {
            if (param) <span class="vert">[OK]</span>
            else <span class="rouge">[PAS OK]</span>
        }
        function reglement() {
            function accept(a) {
                /skiutc/users[User.get_current()]/reglement <- a;
                Client.reload()
            }
            Dom.transform([#tool_box = <div id="shadow" style="display:none; position:fixed; top:0; left:0; width: 100%; height: 100%; background-color: #ccc; z-index: 10; opacity:0.7; filter: alpha(opcity=70);"/>]);
            Dom.show(#shadow);
            Dom.transform([#tool_box =+ <div id="reglement">
{Popup.xhtml("Le R\195\169glement",
                                                                <>

                                                                 <h2>Inscriptions</h2>
                                                                 
<br/>
                                                                 
Les inscriptions à Ski UTC sont ouvertes à toute personne interne à l'UTC. Elles sont ouvertes à partir du 
                                                                 {/skiutc/conf/site/inscription}
                                                                 .<br/>
                                                                 
Il y a 
                                                                 {/skiutc/conf/voyage/nb_place}
                                                                  places disponibles cette année pour SkiUTC.
                                                                 <br/>
                                                                 
La date, l'heure et le numéro d'enregistrement des inscriptions sont relevés automatiquement par la base de données.
                                                                 <br/>
                                                                 
Ces données servent directement à établir l'ordre des inscriptions.
                                                                 <br/>
<br/>
                                                                 
Les personnes peuvent s'inscrire au delà des 
                                                                 {/skiutc/conf/voyage/nb_place}
                                                                  places, mais seront automatiquement placées sur liste d'attente, sans engagement de notre part quant à leur départ.
                                                                 <br/>
<br/>
                                                                 
Les enregistrements seront traités et les personnes sur liste d'attente seront prévenues s'il y a eu des désistements.
                                                                 <br/>
<br/>
                                                                 
L’accés au site de SkiUTC est PERSONNEL, toutes modifications faites par un tiers ne pourraient être imputable à SkiUTC. 
                                                                 <br/>
                                                                 
Nous demandons à toutes les personnes désirant s'inscrire de bien vouloir faire preuve de civisme, et donc de ne pas valider l'inscription pour un ami. 
                                                                 <br/>
                                                                 
SkiUTC n'a pas d'accès à votre mot de passe et n'utilisera pas vos informations personnelles à d'autres fins que celles de SkiUTC.
                                                                 <br/>
                                                                 
Pour les personnes extérieures à l'UTC, elles ne peuvent être inscrites que par un étudiant de l'UTC lui même inscrit au voyage, et elles devront payer une cotisation BDE (obligatoire pour 
                                                                 <strong>tous les participants</strong>
                                                                 ). <br/>

                                                                 <br/>
                                                                 
Le projet étant destiné aux étudiants UTCéens l'équipe de SkiUTC n’ouvrira l’inscription aux extérieurs que s’il reste de la place. 
                                                                 <br/>
<br/>

                                                                 <strong>Toute inscription n'est valide qu'après le dépôt des chèques.</strong>
                                                                 <br/>
<br/>
                                                                 
SkiUTC se réserve le droit d'annuler toute inscription non valide.

                                                                 <br/>
<br/>

                                                                 <h2>Paiement</h2>
                                                                 
<br/>
                                                                 
Les inscrits recevront par mail 3 créneaux horaire de passage pour payer leur séjour. 
                                                                 <br/>
                                                                 
Si au terme de ces 3 créneaux un inscrit n’a pas payé son voyage, sa place se verra libéré au profit d’une personne sur liste d’attente.
                                                                 <br/>
                                                                 
Il aura la possibilité de se ré-ajouter sur liste d’attente.
                                                                 <br/>
<br/>
                                                                 
A réception des chèques par l'association SkiUTC, aucun désistement ne pourra donner lieu à un remboursement sauf autorisation spéciale de la part du président de SkiUTC, 
                                                                 {/skiutc/conf/site/president_asso}
                                                                 .<br/>
<br/>
                                                                 
SkiUTC n'est aucunement responsable des étudiants une fois arrivés sur le site.
                                                                 <br/>
<br/>
                                                                 
Un chèque de caution de 
                                                                 {/skiutc/conf/voyage/caution}
                                                                 € est demandé aux participants du voyage.
                                                                 <br/>
                                                                 
En effet, dans le cadre de SkiUTC, il vous est demandé de répondre à certaines règles de "bonne conduite", dictées pour la plupart par le bon sens, et dont nous vous donnons ci-après une liste non exhaustive d'exemples.
                                                                 <br/>
<br/>
                                                                 
En tout état de cause, SkiUTC se réserve le droit de prendre, en cas de nécessité, les dispositions appropriées : encaissement d'un des chèques de caution selon la nature du non-respect, fin anticipée du voyage,…
                                                                 <br/>
<br/>
                                                                 
Nécessitera l'encaissement de tout ou partie du chèque de 
                                                                 {/skiutc/conf/voyage/caution}
                                                                 € :<br/>

                                                                 <ul>
<li>toute dégradation des locaux de façon irréversible ou nécessitant des travaux de réparation,</li>
<li>les nuisances sonores (à répétition et après avertissement),</li>
<li>tout comportement pouvant nuire à l'image du projet SkiUTC où à celle de l'Université (au nom de laquelle vous partez)</li>
<li>tout débordement constaté dû à l'ingestion de boissons alcoolisées,</li>
<li>la saisie de substances illicites (drogues,…) dans les cars ou pendant le voyage par des autorités compétentes (en plus des poursuites judiciaires qui pourront être menées contre vous).</li></ul>
                                                                 
<br/>
                                                                 
En clair, il s'agit de bien voir que l'objectif du voyage reste de pouvoir découvrir la montagne et de profiter de ce cadre pour pouvoir nouer des liens entre étudiants sans tomber dans aucun excès mais tout en restant festif, convivial et sportif.

                                                                 <br/>
<br/>
                                                                 
Sauf encaissemement pour une des raisons citées précédemment, les chèques de cautions seront rendus OU détruits après le voyage.

                                                                 <br/>
<br/>
                                                                 
S'inscrire à SkiUTC, c'est comprendre et accepter ce réglement.

                                                                 <br/>
<br/>

                                                                 <a onclick={(
                                                                 function(_) {
                                                                 accept(true)
                                                                 })}> J'accepte le réglement </a>
                                                                  | 
                                                                 <a onclick={(
                                                                 function(_) {
                                                                 accept(false)
                                                                 })}> Je n'accepte pas le réglement </a>
                                                                 
</>)}</div>]);
            void
        }
        function my_profil() {
            edit_profil(User.get_current())
        }
        <>
<h2>Mon profil</h2>
<div id="tool_box"/>

         {if (Paiement.a_paye(User.get_current()))
            <div class="ok">Nous avons bien enregistré ton paiement !</div>
         else
           if (Inscription.is_inscrit())
             <div class="attention"><a onclick={function(_) {
                                                Paiement.prepare("tool_box")
             }}>A préparer pour le paiement.</a><br/></div>
           else
             <div class="info"> Tu dois remplir ton profil pour pouvoir ensuite valider ton inscription !<br/>
Tant que tu n'as pas pu valider ton inscription, tu n'es pas inscrit...</div>}
         
<br/>
Etape à valider :

         <ul>
{if (Inscription.is_open())
                 <>
                  <li><a onclick={function(_) {
                                  reglement()
                  }}>Lire et accepter le réglement </a> {is_ok(User_data.get(
                                                                  User.get_current()).reglement)}</li>
                  
            
                  <li><a onclick={function(_) {
                                  my_profil()
                  }}>Remplir tous les champs de mon profil </a> {is_ok(
                                                                   User_data.is_profil_edited(
                                                                    User.get_current()))}</li>
                  
            
                  <li>Être cotisant BDE {is_ok(User_data.get(User.get_current()).cotisant_bde)}</li>
                  
            <li>{Inscription.link("tool_box")}</li>
                  
            <li>{FriendList.link("tool_box")}</li></>
         else
           <>
            <li>Lire et accepter le réglement <span class="rouge">[Inscriptions pas encore ouvertes !]</span></li>
            
            
            <li><a onclick={function(_) {
                            my_profil()
            }}>Remplir tous les champs de mon profil </a> {is_ok(User_data.is_profil_edited(
                                                                   User.get_current()))}</li>
            
            
            <li>Être cotisant BDE {is_ok(User_data.get(User.get_current()).cotisant_bde)}</li>
            
            <li>{Inscription.link("tool_box")}</li>
            
            <li>{FriendList.link("tool_box")}</li></>}
<li>{InfosCompl.link("tool_box")} </li>  
<li><a href="appart.html">Inscription aux appartements !!</a></li>            
</ul>
         
<br/>
<br/>
</>
    }
    function xhtml content_logged() {
        <div class="right_cellule">
Mon compte
<br/><br/>
Bonjour {User_data.get_name(
                                                                    User.get_current())} !<br/>
<br/>
{
        profil()}          
</div>
    }
    function xhtml content_team() {
        <div class="right_cellule">
Mon compte
<br/><br/>
Bonjour {User_data.get_name(
                                                                    User.get_current())} !<br/>
<br/>
{
        profil()}
<h2>Tache d'administration</h2>
<div id="box_useful"/>
<div class="info">Attention, les actions que tu peux réaliser ci dessous relève de l'administration du site ! Fais gaffe à toi et soit responsable ^^</div>
<ul>
<li><a href="admin_configuration.html">Configuration</a></li>
<li>{
        Listing.link()}</li>
<li>{Stats.link()}</li>
<li>{Mailing.link()}</li>
<li>{
        Appart.link()}</li>
<li>{Admin_user.link()}</li>
<li><a onclick={
        function(_) {
        Paiement.receive("tool_box")
        }}>Recevoir les paiements</a></li>
<li>{Exterieur.ajout()}</li>
</ul>
</div>
    }
    function content() {
        if (User.is_logged()) if (User.is_team()) content_team()
          else content_logged()
        else
          <div class="right_cellule">
Mon compte
<br/><br/>
Veuillez vous connecter !
<br/>
</div>
    }
    function get_page() {
        {ref : "mon_compte.html", title : "Mon Compte", content : content()}
    }
}