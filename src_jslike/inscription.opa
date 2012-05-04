type inscription =
  {Date.date date, int pack_bouf, int pack_matos, int pack_forfait,
   int pack_cours, int num_place, or {non}
                                  or {oui} priorite,
   int tour}

database User.map(inscription) /skiutc/inscription

database /skiutc/inscription[_]/priorite = {non}

module Inscription {
    inscription empty =
        {
         date : Date.epoch,
         pack_bouf : -1,
         pack_matos : -1,
         pack_forfait : -1,
         pack_cours : -1,
         num_place : 9999,
         priorite : {non},
         tour : 0
         }
    function bool is_open() {
        if (User.is_logged())
          if (User.is_team())
            /skiutc/conf/site/inscription_team <= Date.now()
          else /skiutc/conf/site/inscription <= Date.now()
        else false
    }
    function xhtml place_restante() {
        total = /skiutc/conf/voyage/nb_place;
        reste =
            (total - Map.size(/skiutc/inscription)) -
              /skiutc/conf/voyage/nb_assos;
        couleur = if (reste > 25) "vert"
            else if (reste > 0) "jaune" else "rouge";
        <span class="{couleur}">[nb de place restante : {reste} / {total}]</span>
    }
    function Order.ordering compare((_, inscription value1), (_,
                                                              inscription value2)) {
        if (value1.tour < value2.tour) {lt}
        else if (value1.tour > value2.tour) {gt}
          else if (value1.date < value2.date) {lt}
            else if (value1.date > value2.date) {gt} else {eq}
    }
    @async function update_places() {
        inscrit = Map.To.assoc_list(/skiutc/inscription);
        (team, prio, reste) =
            List.fold((function((key, value),
                       (team, prio, reste)) {
                       if (User_data.is_in_team(key))
                         (List.add((key, value), team), prio, reste)
                       else
                         if (value.priorite == {oui})
                           (team, List.add((key, value), prio), reste)
                         else (team, prio, List.add((key, value), reste))
              }), inscrit, ([], [], []))
        team = List.sort_with(compare, team);
        prio = List.sort_with(compare, prio);
        reste = List.sort_with(compare, reste);
        inscrit = List.append(team, List.append(prio, reste));
        assos_used = Mutable.make(/skiutc/conf/voyage/nb_assos);
        List.iteri((function(i, (key, value)) {
                      i = i + 1;
                      if (User_data.is_in_team(key))
                        /skiutc/inscription[key]/num_place <- i
                      else
                        if (value.priorite == {oui}) {
                          assos_used.set(assos_used.get() - 1);
                          /skiutc/inscription[key]/num_place <- i
                        } else {
                          num_place = i + Int.max(0, assos_used.get());
                          /skiutc/inscription[key]/num_place <- num_place
                        }
          }), inscrit)
    }
    function xhtml ma_place() {
        place = /skiutc/inscription[User.get_current()]/num_place;
        if (place > /skiutc/conf/voyage/nb_place)
          <span class="jaune">[Tu es {place}{if (place == 1) "er"
          else "eme"} sur la liste des preinscriptions (liste d'attente a partir de la {/skiutc/conf/voyage/nb_place}ième place)]</span>
        else <span class="vert">[Tu es {place}{if (place == 1) "er"
          else "eme"} sur la liste des preinscriptions]</span>
    }
    function is_inscrit() {
        Db.exists(@/skiutc/inscription[User.get_current()])
    }
    function xhtml link(string id) {
        match (is_inscrit()) {
        case { true }:
          <a onclick={function(_) {
                      get_popup(id, inscription_content())
          }}>Modifier mon inscription </a>
        case { false }:
          if (is_open())
            if (User_data.get(User.get_current()).reglement)
              if (User_data.is_profil_edited(User.get_current()))
                if (User_data.get(User.get_current()).cotisant_bde)
                  <>
                   <a onclick={function(_) {
                               get_popup(id, inscription_content())
                   }}>M'inscrire </a>{place_restante()}</>
                else
                  match (User_data.get(User.get_current()).login_utc) {
                  case { utc : _ }:
                    <>M'inscrire 
                     <span class="rouge">[Tu dois aller cotiser au BDE]</span></>
                  case { invite : _ }:
                    <>
                     <a onclick={function(_) {
                                 get_popup(id, inscription_content())
                     }}>M'inscrire </a>{place_restante()}</>
                  }
              else
                <>M'inscrire 
                 <span class="rouge">[Tu n'as pas edité ton profil]</span></>
            else
              <>M'inscrire 
               <span class="rouge">[Tu n'as pas accepté le réglement]</span></>
          else <>M'inscrire <span class="rouge">[INSCRIPTION FERME]</span></>
        }
    }
    function xhtml inscription_content() {
        inscription_user(User.get_current())
    }
    function xhtml inscription_user(login) {
        function select_from(param) {
            ref =
                match (param) {
                case { bouf }: @/skiutc/conf/bouf
                case { matos }: @/skiutc/conf/matos
                case { forfait }: @/skiutc/conf/forfait
                case { cours }: @/skiutc/conf/cours
                };
            function ref_k(key) {
                match (param) {
                case { bouf }: @/skiutc/conf/bouf[key]
                case { matos }: @/skiutc/conf/matos[key]
                case { forfait }: @/skiutc/conf/forfait[key]
                case { cours }: @/skiutc/conf/cours[key]
                }
            }
            @todo
        }
        function save() {
            pack_bouf =
                Option.`default`(0,
                  Parser.try_parse(Rule.integer, Dom.get_value(#select_bouf)));
            pack_matos =
                Option.`default`(0,
                  Parser.try_parse(Rule.integer,
                    Dom.get_value(#select_matos)));
            pack_forfait =
                Option.`default`(0,
                  Parser.try_parse(Rule.integer,
                    Dom.get_value(#select_forfait)));
            pack_cours =
                Option.`default`(0,
                  Parser.try_parse(Rule.integer,
                    Dom.get_value(#select_cours)));
            if (Db.exists(@/skiutc/inscription[login]))
              /skiutc/inscription[login] <- {/skiutc/inscription[login] with
                                             ~pack_bouf, ~pack_matos,
                                             ~pack_forfait, ~pack_cours}
                else
                  /skiutc/inscription[login] <- {empty with
                                                 date : Date.now(),
                                                 ~pack_bouf, ~pack_matos,
                                                 ~pack_forfait, ~pack_cours};
            update_places();
            Client.reload()
        }
        <>

         <div class="info" style="height: 130px; width: 700px; margin-left: auto; margin-right: auto;">A partir du moment ou tu valides ce formulaire, tu seras pré-inscrit pour skiut 2012.<br/>
Tu pourras modifier les infos de ce formulaire jusqu'à ton paiement, qui validera complétement ton inscription. <br/>
Tu recevras par mail, plusieurs crénaux horaire pour payer. <br/>
Si tu ne te présentes pas, ta place sera libéré pour une personne sur liste d'attente. Et la régle du premier arrivé, premier servi s'appliquera.
</div>
         
<br/>
Pack de base : {/skiutc/conf/voyage/prix_base} € <br/>

         {match (User_data.get(login).login_utc) {
         case { utc : _ }: <></>
         case { invite : _ }: <>Cotisation BDE : 20€ <br/></>
         }}
Pack bouff : 
         <select id="select_bouf">{select_from({bouf})}</select> <br/>
         
Pack matos : 
         <select id="select_matos">{select_from({matos})}</select> <br/>
         
Forfait : 
         <select id="select_forfait">{select_from({forfait})}</select> <br/>
         
Cours : <select id="select_cours">{select_from({cours})}</select> 
         <br/>
<br/>

         {if (Db.exists(@/skiutc/paiement[login]))
            <>Tu ne peux plus modifier, car tu as payé pour ces choix !</>
         else
           <><button onclick={function(_) {
                              save()
            }}> Valider </button>
            {if (Db.exists(@/skiutc/inscription[login]))
               <>- 
                <a onclick={function(_) {
                            Db.remove(@/skiutc/inscription[login]);
                            Client.reload()
                }}> Me désinscrire </a></>
            else <></>} </>}
         
</>
    }
    function void get_popup(string id, xhtml content) {
        Dom.transform([#{id} = <div id="shadow" style="display:none; position:fixed; top:0; left:0; width: 100%; height: 100%; background-color: #ccc; z-index: 10; opacity:0.7; filter: alpha(opcity=70);"/>]);
        Dom.show(#shadow);
        Dom.transform([#{id} =+ <div id="inscription">
{Popup.xhtml("Inscription",
                                                          content)}
</div>]);
        void
    }
}

Inscription.update_places();