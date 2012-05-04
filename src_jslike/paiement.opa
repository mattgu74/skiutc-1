import stdlib.widgets.completion

type paiement =
  {Date.date date, float montant_cheque1, float montant_cheque2,
   bool cheque_bde, User.ref permanencier, option(Date.date) validation,
   option(Date.date) validation2}

database User.map(paiement) /skiutc/paiement

database /skiutc/paiement[_]/cheque_bde = false

module Paiement {
    paiement empty =
        {
         date : Date.epoch,
         montant_cheque1 : float 0.,
         montant_cheque2 : float 0.,
         cheque_bde : (bool) false,
         permanencier : (User.ref) "anonyme",
         validation : option(Date.date) none,
         validation2 : option(Date.date) none
         }
    function bool can_pay(User.ref user) {
        Map.size(/skiutc/paiement) < /skiutc/conf/voyage/nb_place
    }
    function bool a_paye(User.ref user) {
        Db.exists(@/skiutc/paiement[user])
    }
    function register(User.ref login, paiement paiement) {
        paiement = {paiement with date : Date.now()};
        nb = if (paiement.montant_cheque2 > 0.) 2 else 1;
        resume =
            if (nb == 1) {
              "Un ch\195\168que de {paiement.montant_cheque1} \226\130\172"
            } else {
              "Un ch\195\168que de {paiement.montant_cheque1} \226\130\172 et un ch\195\168que de {paiement.montant_cheque2} \226\130\172"
            };
        message =
            {
             text :
               "\nBonjour {User_data.get_name(login)} ({login}),\n\n\n\nNous avons bien re\195\167u ton paiement pour le voyage SkiUTC.\n\nTu as pay\195\169 en {nb} fois avec :\n\n{resume}\n\nTu devras bient\195\180t choisir ton appartement sur le site.\n\nNous t'enverrons un mail pour te prevenir lorsque \195\167a aura lieu ;) \n\n\n\nBSU (Bisous SkiUTC)\n\n"
             };
        email_send(Mailing.site_email, Mailing.site_email,
          "[SkiUTC] Accus\195\169 r\195\169ception paiement", message,
          (function(_) {
           void
          }));
        email_send(Mailing.site_email,
          Email.of_string(/skiutc/users[login]/email),
          "[SkiUTC] Accus\195\169 r\195\169ception paiement", message,
          (function(_) {
           void
          }));
        /skiutc/paiement[login] <- paiement
    }
    function prepare(id) {
        function printer(Date.date date) {
            Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M"),
              date)
        }
        user = User.get_current();
        pack_bouf = /skiutc/conf/bouf[/skiutc/inscription[user]/pack_bouf];
        pack_matos =
            /skiutc/conf/matos[/skiutc/inscription[user]/pack_matos];
        pack_forfait =
            /skiutc/conf/forfait[/skiutc/inscription[user]/pack_forfait];
        pack_cours =
            /skiutc/conf/cours[/skiutc/inscription[user]/pack_cours];
        total =
            (((/skiutc/conf/voyage/prix_base + pack_bouf.prix) +
                pack_matos.prix) +
               pack_forfait.prix) +
              pack_cours.prix;
        Dom.transform([#{id} = <div id="shadow" style="display:none; position:fixed; top:0; left:0; width: 100%; height: 100%; background-color: #ccc; z-index: 10; opacity:0.7; filter: alpha(opcity=70);"/>]);
        Dom.show(#shadow);
        Dom.transform([#{id} =+ <div id="my_paiement">
{Popup.xhtml("Mon paiement",
                                                          <>

                                                           <h1>Rappel de ce que tu as choisi : </h1>
                                                           
Pack de base : 
                                                           {/skiutc/conf/voyage/prix_base}
                                                            € <br/>
                                                           
Pack nourriture : 
                                                           <strong>{pack_bouf.title}</strong>
                                                            - 
                                                           {pack_bouf.desc}
                                                            à 
                                                           {pack_bouf.prix}
                                                            €<br/>
                                                           
Pack matériel : 
                                                           <strong>{pack_matos.title}</strong>
                                                            - 
                                                           {pack_matos.desc}
                                                            à 
                                                           {pack_matos.prix}
                                                            €<br/>
                                                           
Pack forfait : 
                                                           <strong>{pack_forfait.title}</strong>
                                                            - 
                                                           {pack_forfait.desc}
                                                            à 
                                                           {pack_forfait.prix}
                                                            €<br/>
Cours : 
                                                           <strong>{pack_cours.title}</strong>
                                                            - 
                                                           {pack_cours.desc}
                                                            à 
                                                           {pack_cours.prix}
                                                            €<br/>
<br/>
                                                           
==== TOTAL ====
                                                           <br/>
{total} €
                                                           <br/>
<br/>
                                                           
== OPTION 1 ==
                                                           <br/>
                                                           
Tu dois ammener un chèque de 
                                                           {total} €<br/>
                                                           
A l'ordre de "
                                                           {/skiutc/conf/voyage/ordre_cheque}
                                                           " <br/>
<br/>
                                                           
== OPTION 2 ==
                                                           <br/>
                                                           
Tu dois ammener deux chèques :
                                                           <br/>
                                                           
1. 180€ (encaissé immédiatement : 10-15novembre)
                                                           <br/>
2. 
                                                           {total - 180.}
                                                           € (encaissé 10-15 décembre)
                                                           <br/>
                                                           
A l'ordre de "
                                                           {/skiutc/conf/voyage/ordre_cheque}
                                                           " <br/>
<br/>
                                                           
== CAUTION == 
                                                           <br/>
                                                           
Un chèque de caution de 
                                                           {/skiutc/conf/voyage/caution}
                                                            € <br/>
                                                           
A l'ordre de "
                                                           {/skiutc/conf/voyage/ordre_caution}
                                                           " <br/>
<br/>

                                                           {if (/skiutc/inscription[
                                                                  user]/num_place >
                                                                  /skiutc/conf/voyage/nb_place)
                                                              <>
<br/>
                                                               
A partir du 
                                                               {printer(/skiutc/conf/site/paiement_all)}
                                                                nous libérerons les places des personnes sur liste principale n'ayant pas payé à temps. Tu seras contacter par mail en fonction de ta place sur liste d'attente pour venir payer. Tu auras 2 jours avant que ta place file à nouveau pour quelqu'un d'autre.
                                                               <br/>

                                                               <div class="attention">Nous ferons notre possible pour respecter l'ordre de la liste d'attente, mais viens quand meme le plus vite possible a partir du moment ou l'on te dit de venir. Les dernières places partiront en premier arrivé = premier servi.</div>
                                                               
</>
                                                           else
                                                             <>
<br/>
                                                              
Viens vite payer dès les premières permanences.
                                                              <br/>

                                                              <div class="attention">A partir du {
                                                              printer(/skiutc/conf/site/paiement_all)} si tu n'as toujours pas payé, ta place sera remise en vente et tu ne seras plus prioritaire.</div>
                                                              
<br/>
</>}
                                                           
</>)}
</div>]);
        void
    }
    function receive(id) {
        permanencier = User.get_current();
        function get_user(user) {
            pack_bouf =
                /skiutc/conf/bouf[/skiutc/inscription[user]/pack_bouf];
            pack_matos =
                /skiutc/conf/matos[/skiutc/inscription[user]/pack_matos];
            pack_forfait =
                /skiutc/conf/forfait[/skiutc/inscription[user]/pack_forfait];
            total =
                ((/skiutc/conf/voyage/prix_base + pack_bouf.prix) +
                   pack_matos.prix) +
                  pack_forfait.prix;
            (pack_bouf, pack_matos, pack_forfait, total)
        }
        function init() {
            function step2(_) {
                login = Dom.get_value(#login);
                function load() {
                    prix_base = Db.read(@/skiutc/conf/voyage/prix_base);
                    pack_bouf =
                        /skiutc/conf/bouf[/skiutc/inscription[login]/pack_bouf];
                    pack_matos =
                        /skiutc/conf/matos[/skiutc/inscription[login]/pack_matos];
                    pack_forfait =
                        /skiutc/conf/forfait[/skiutc/inscription[login]/pack_forfait];
                    pack_cours =
                        /skiutc/conf/cours[/skiutc/inscription[login]/pack_cours];
                    total =
                        (((/skiutc/conf/voyage/prix_base + pack_bouf.prix) +
                            pack_matos.prix) +
                           pack_forfait.prix) +
                          pack_cours.prix;
                    function valide() {
                        function next(opt) {
                            paiement =
                                if (opt == 1)
                                  (paiement) {empty with
                                              montant_cheque1 : float total,
                                              montant_cheque2 : float 0.,
                                              permanencier :
                                                (User.ref) User.get_current()}
                                else
                                  (paiement) {empty with
                                              montant_cheque1 : float 180.,
                                              montant_cheque2 :
                                                total - float 180.,
                                              permanencier :
                                                (User.ref) User.get_current()};
                            function do_register() {
                                register(login, paiement);
                                Dom.transform([#etape2 = <></>])
                            }
                            function annule() {
                                Dom.transform([#etape2 = <></>])
                            }
                            Dom.transform([#etape2 =+ <>
                                                        J'ai reçu les chèques (ordre) suivants : 
                                                       <br/>

                                                       {paiement.montant_cheque1}
                                                       € (
                                                       {/skiutc/conf/voyage/ordre_cheque}
                                                       ) <br/>

                                                       {if (paiement.montant_cheque2 >
                                                              0.)
                                                          <>
                                                           {paiement.montant_cheque2}
                                                           € (
                                                           {/skiutc/conf/voyage/ordre_cheque}
                                                           )<br/></>
                                                       else <></>}

                                                       {/skiutc/conf/voyage/caution}
                                                       € (
                                                       {/skiutc/conf/voyage/ordre_caution}
                                                       ) <br/>

                                                       <button onclick={(
                                                       function(_) {
                                                       do_register()
                                                       })}>Enregistrer !</button>
                                                       <a onclick={(function(_) {
                                                                    annule()
                                                       })}>Annuler</a></>])
                        }
                        Dom.transform([#etape2 =+ <>
                                                   <button onclick={(
                                                   function(_) {
                                                   next(1)
                                                   })}>Paiement en une fois</button>
                                                   <button onclick={(
                                                   function(_) {
                                                   next(2)
                                                   })}>Paiement en deux fois</button>
                                                   <br/></>])
                    }
                    <><h1>Son choix :</h1>
Pack de base : {prix_base} € 
                     <br/>
Pack nourriture : 
                     <strong>{pack_bouf.title}</strong> - {pack_bouf.desc}
                      à {pack_bouf.prix} €<br/>
Pack matériel : 
                     <strong>{pack_matos.title}</strong> - {pack_matos.desc}
                      à {pack_matos.prix} €<br/>
Pack forfait : 
                     <strong>{pack_forfait.title}</strong> - 
                     {pack_forfait.desc} à {pack_forfait.prix} €<br/>
                      
Pack Cours : <strong>{pack_cours.title}</strong> - 
                     {pack_cours.desc} à {pack_cours.prix} €<br/>
<br/>
                     
==== TOTAL ====<br/>
{total} €<br/>
<br/>
                     
== OPTION 1 ==<br/>
Un chèque de {total} €<br/>
                     
A l'ordre de "{/skiutc/conf/voyage/ordre_cheque}" <br/>
                     
<br/>
== OPTION 2 ==<br/>
Deux chèques :<br/>
                     
1. 180€ (encaissé immédiatement : 10-15novembre)
                     <br/>
2. {total - 180.}€ (encaissé 10-15 décembre)
                     <br/>
A l'ordre de "{/skiutc/conf/voyage/ordre_cheque}" 
                     <br/>
<br/>
== CAUTION == <br/>
                     
Un chèque de caution de {/skiutc/conf/voyage/caution}
                      € <br/>
A l'ordre de "
                     {/skiutc/conf/voyage/ordre_caution}" <br/>
<br/>

                     <button onclick={function(_) {
                                      valide()
                     }}>Commencer le paiement</button><br/></>
                }
                if (Option.is_none(?/skiutc/users[login]))
                  Dom.transform([#etape2 = <div class="attention"> Ce login n'est pas dans le site ! </div>])
                else
                  if (Option.is_none(?/skiutc/inscription[login]))
                    Dom.transform([#etape2 = <div class="attention"> Cet utilisateur n'est pas inscrit </div>])
                  else
                    if (Option.is_some(?/skiutc/paiement[login]))
                      Dom.transform([#etape2 = <div class="attention"> Cet utilisateur a déjà payé ! </div>])
                    else
                      if (not(can_pay(login)))
                        Dom.transform([#etape2 = <div class="attention"> Cet utilisateur est sur liste d'attente ! </div>])
                      else Dom.transform([#etape2 = load()])
            }
            it = {input : "", display : <></>, item : ""};
            list = /skiutc/users;
            function list_nom(in) {
                u = String.to_upper;
                l =
                    List.map((function((key, v)) {
                              {
                               input : in,
                               display : <>{v.prenom} {v.nom} ({key})</>,
                               item : key
                               }
                      }),
                      List.filter((function((key, v)) {
                                   String.has_prefix(u(in), u(key)) ||
                                     (String.has_prefix(u(in),
                                        u((v.prenom ^ " ") ^ v.nom)) ||
                                        String.has_prefix(u(in),
                                          u((v.nom ^ " ") ^ v.prenom)))
                        }), Map.To.assoc_list(list)));
                l
            }
            function onselect(item) {
                Dom.set_value(#login, item)
            }
            <>
Recherche : 
             {WCompletion.html({WCompletion.default_config with
                                suggest : list_nom},
                onselect, "input_nom", it)}
             <br/>
Login : <input id="login" readonly="readonly"/> 
             <button onclick={step2}>Go !</button><br/>
</>
        }
        Dom.transform([#{id} = <div id="shadow" style="display:none; position:fixed; top:0; left:0; width: 100%; height: 100%; background-color: #ccc; z-index: 10; opacity:0.7; filter: alpha(opcity=70);"/>]);
        Dom.show(#shadow);
        Dom.transform([#{id} =+ <div id="my_paiement">
{Popup.xhtml("Mon paiement",
                                                          <>

                                                           <h3>Etape 1 - Trouver un étudiant</h3>
                                                           
{init()}

                                                           <div id="etape2"/>
                                                           
</>)}
</div>]);
        void
    }
}