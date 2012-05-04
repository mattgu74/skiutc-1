type infos_complementaires =
  {bool bus_aller, bool bus_retour, bool paris, string contact_nom,
   string contact_prenom, string contact_tel, string sante,
   string more_sante, string more}

database User.map(infos_complementaires) /skiutc/more

database /skiutc/more[_]/bus_aller = {true}

database /skiutc/more[_]/bus_retour = {true}

database /skiutc/more[_]/paris = {false}

module InfosCompl {
    function xhtml link(string id) {
        <a onclick={function(_) {
                    get_popup(id, content(User.get_current()))
        }}>Informations Complémentaires </a>
    }
    function xhtml linka(string id, u) {
        <a onclick={function(_) {
                    get_popup(id, content(u))
        }}>Editer</a>
    }
    function select_option(show, value, checked) {
        if (checked)
          <option value={value} selected="selected">{show}</option>
        else <option value={value}>{show}</option>
    }
    function save(user) {
        bus_aller =
            match (Dom.get_value(#bus_aller)) {
            case "O": true
            case "N": false
            default: true
            };
        bus_retour =
            match (Dom.get_value(#bus_retour)) {
            case "O": true
            case "N": false
            default: true
            };
        paris =
            match (Dom.get_value(#paris)) {
            case "O": true
            case "N": false
            default: true
            };
        contact_nom = Dom.get_value(#contact_nom);
        contact_prenom = Dom.get_value(#contact_prenom);
        contact_tel = Dom.get_value(#contact_tel);
        sante = Dom.get_value(#sante);
        more_sante = Dom.get_value(#more_sante);
        more = Dom.get_value(#more);
        /skiutc/more[user] <- {/skiutc/more[user] with ~bus_aller,
                               ~bus_retour, ~paris, ~contact_nom,
                               ~contact_prenom, ~contact_tel, ~sante,
                               ~more_sante, ~more};
        Client.reload()
    }
    function xhtml content(user) {
        me = /skiutc/more[user];
        <>
<h2> - Infos BUS - </h2>
Bus aller : 
         <select id="bus_aller">
{select_option("Oui", "O",
                                    me.bus_aller == true)}
{select_option("Non",
                                                              "N",
                                                              me.bus_aller ==
                                                                false)}
</select>
         
<br/>
Bus retour : 
         <select id="bus_retour">
{select_option("Oui", "O",
                                     me.bus_retour == true)}
{select_option("Non",
                                                                "N",
                                                                me.bus_retour ==
                                                                  false)}
</select>
         
<br/>
Je suis interessé par un arrêt à Paris au retour : 
         <select id="paris">
{select_option("Oui", "O", me.paris == true)}
{
         select_option("Non", "N", me.paris == false)}
</select><br/>
         
Attention : Nous arriverons peut être à une heure à laquelle il n'y aura pas de métro !
         <br/>
<br/>
<h2> - Contact en cas d'urgence - </h2>
Prénom : 
         <input id="contact_prenom" value={me.contact_prenom}/><br/>
Nom : 
         <input id="contact_nom" value={me.contact_nom}/><br/>
         
Numéro de téléphone : 
         <input id="contact_tel" value={me.contact_tel}/><br/>

         <h2> - Informations santé - </h2>
         
Avez vous une maladie, ou un problème de santé à déclarer : 
         <input id="sante" value={me.sante}/><br/>
         
Que faire en cas de problème ? (Si maladie déclarée) : 
         <textarea id="more_sante">{me.more_sante} </textarea> <br/>

         <h2> - En plus - </h2>
Quelque chose à ajouter ? : 
         <textarea id="more">{me.more} </textarea> <br/>
<br/>

         <a onclick={function(_) {
                     save(user)
         }}>Enregistrer</a>
</>
    }
    function void get_popup(string id, xhtml content) {
        Dom.transform([#{id} = <div id="shadow" style="display:none; position:fixed; top:0; left:0; width: 100%; height: 100%; background-color: #ccc; z-index: 10; opacity:0.7; filter: alpha(opcity=70);"/>]);
        Dom.show(#shadow);
        Dom.transform([#{id} =+ Popup.xhtml("Mes informations compl\195\169mentaires",
                                  <>
{content}
</>)]);
        void
    }
}