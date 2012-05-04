import stdlib.widgets.{accordion,core,checkbox}

type Conf.site =
  {Date.date inscription, Date.date inscription_team, Date.date appart,
   Date.date appart_team, string president_asso, Date.date paiement_all}

type Conf.voyage =
  {int nb_place, int nb_assos, float prix_base, string ordre_cheque,
   string ordre_caution, float caution, Date.date date}

type Conf.pack = {string title, string desc, float prix}

type Conf.conf =
  {Conf.site site, Conf.voyage voyage, intmap(Conf.pack) bouf,
   intmap(Conf.pack) matos, intmap(Conf.pack) forfait,
   intmap(Conf.pack) cours}

database Conf.conf /skiutc/conf

module Configuration {
    WAccordion.config Accordion_config =
        {
         open_first : true,
         close_others : true,
         global_style :
           WStyler.make_style([Css_build.color({
                                                r : 105,
                                                g : 105,
                                                b : 105,
                                                a : 255
                                                }),
                                Css_build.min_height({size : {px : 300}}),
                                Css_build.border_all(Css_build.border_type(
                                                       [Css_build.border_size({
                                                          
                                                          px : 1
                                                          }),
                                                         Css_build.border_solid,
                                                         Css_build.border_color({
                                                           
                                                           r : 0,
                                                           g : 0,
                                                           b : 0,
                                                           a : 255
                                                           })]))]),
         tab_open_style :
           WStyler.make_style([Css_build.background([Css_build.background_color({
                                                       
                                                       r : 17,
                                                       g : 17,
                                                       b : 170,
                                                       a : 255
                                                       })]),
                                Css_build.color({
                                                 r : 255,
                                                 g : 255,
                                                 b : 255,
                                                 a : 255
                                                 }),
                                Css_build.border_all(Css_build.border_type(
                                                       [Css_build.border_size({
                                                          
                                                          px : 1
                                                          }),
                                                         Css_build.border_solid,
                                                         Css_build.border_color({
                                                           
                                                           r : 0,
                                                           g : 0,
                                                           b : 255,
                                                           a : 255
                                                           })]))]),
         tab_close_style :
           WStyler.make_style([Css_build.background([Css_build.background_color({
                                                       
                                                       r : 34,
                                                       g : 34,
                                                       b : 187,
                                                       a : 255
                                                       })]),
                                Css_build.color({
                                                 r : 221,
                                                 g : 221,
                                                 b : 221,
                                                 a : 255
                                                 }),
                                Css_build.border_all(Css_build.border_type(
                                                       [Css_build.border_size({
                                                          
                                                          px : 1
                                                          }),
                                                         Css_build.border_solid,
                                                         Css_build.border_color({
                                                           
                                                           r : 0,
                                                           g : 0,
                                                           b : 255,
                                                           a : 255
                                                           })]))]),
         open_style : WStyler.empty,
         close_style : WStyler.empty,
         tab_content_style :
           WStyler.make_style([Css_build.color({r : 0, g : 0, b : 0, a : 255}),
                                Css_build.min_height({size : {px : 200}}),
                                Css_build.border_all(Css_build.border_type(
                                                       [Css_build.border_size({
                                                          
                                                          px : 1
                                                          }),
                                                         Css_build.border_solid,
                                                         Css_build.border_color({
                                                           
                                                           r : 255,
                                                           g : 255,
                                                           b : 255,
                                                           a : 255
                                                           })]))])
         }
    function edit_string(path) {
        id = Dom.fresh_id();
        function edit() {
            value = Dom.get_value(#{id});
            Db.write(path, value)
        }
        <><input id={id} value={Db.read(path)}/> 
         <button onclick={function(_) {
                          edit()
         }}>Modifier</button></>
    }
    exposed function edit_float(string id, path) {
        value = Dom.get_value(#{id});
        a = Parser.try_parse(Rule.float, value);
        if (Option.is_some(a)) Db.write(path, Option.get(a)) else {} {}
    }
    exposed function edit_int(string id, path) {
        value = Dom.get_value(#{id});
        a = Parser.try_parse(Rule.integer, value);
        if (Option.is_some(a)) Db.write(path, Option.get(a)) else {} {}
    }
    function xhtml conf_site() {
        <>
<br/>
Nom du président de l'assos : 
         {edit_string(@/skiutc/conf/site/president_asso)}
<br/>
         
Activer les inscriptions (pour tout le monde) : 
         {MyDateWidget.edit(@/skiutc/conf/site/inscription)}
<br/>
         
Activer les inscriptions (pour la team) : 
         {MyDateWidget.edit(@/skiutc/conf/site/inscription_team)}
<br/>
         
Paiement autorisé pour tout le monde : 
         {MyDateWidget.edit(@/skiutc/conf/site/paiement_all)}<br/>
         
Avant ce moment la, uniquement les gens qui ne sont pas sur liste d'attente peuvent payer !
         <br/>
<br/>
Activer les inscriptions appart : 
         {MyDateWidget.edit(@/skiutc/conf/site/appart)}
<br/>
         
Activer les inscriptions appart (pour la team) : 
         {MyDateWidget.edit(@/skiutc/conf/site/appart_team)}
<br/>
</>
    }
    function xhtml conf_voyage() {
        <>
<br/>
Places :<br/>
Nombre de place pour le voyage : 
         <input id="place_voyage" value={/skiutc/conf/voyage/nb_place}/> 
         <button onclick={function(_) {
                          edit_int("place_voyage",
                            @/skiutc/conf/voyage/nb_place)
         }}>Modifier</button><br/>
Nombre de place bloqué pour les assos : 
         <input id="place_assos" value={/skiutc/conf/voyage/nb_assos}/> 
         <button onclick={function(_) {
                          edit_int("place_assos",
                            @/skiutc/conf/voyage/nb_assos)
         }}>Modifier</button><br/>
<br/>
<br/>
Ordre du chèque : 
         {edit_string(@/skiutc/conf/voyage/ordre_cheque)}<br/>
         
Prix du pack de base : 
         <input id="prix_base" value={/skiutc/conf/voyage/prix_base}/> € 
         <button onclick={function(_) {
                          edit_float("prix_base",
                            @/skiutc/conf/voyage/prix_base)
         }}>Modifier</button> <br/><br/>
Ordre de la caution : 
         {edit_string(@/skiutc/conf/voyage/ordre_caution)}<br/>
         
Prix de la caution : 
         <input id="caution" value={/skiutc/conf/voyage/caution}/> € 
         <button onclick={function(_) {
                          edit_float("caution", @/skiutc/conf/voyage/caution)
         }}>Modifier</button> <br/>
<br/>
Date de départ :  
         {MyDateWidget.edit(@/skiutc/conf/voyage/date)}
<br/>
</>
    }
    function xhtml conf_team() {
        recursive function xhtml list() {
                      function remove(login_utc) {
                          match (login_utc) {
                              case ~{ utc }:
                                /skiutc/users[User_data.mk_ref(utc)]/team_skiutc <- false
                              default: void
                              }
                              ;
                          Dom.transform([#list_team = list()])
                      }
                      <ul>
{List.fold((function(v,
                                       a) {
                                       <>{a}
                                        <li>{v.prenom} {v.nom} <a onclick={
                                        function(_) {
                                        remove(v.login_utc)
                                        }}>[retirer]</a></li></>
                              }), User_data.get_team(), <></>)}
</ul>
        }
        function add() {
            login = Dom.get_value(#login_team);
            if (User_data.exists(User_data.mk_ref(login))) {
              User_data.update_utc(User_data.mk_ref(login));
              /skiutc/users[User_data.mk_ref(login)]/team_skiutc <- true;
              Dom.transform([#list_team = list()]);
              Dom.clear_value(#login_team);
              void
            } else {
              Dom.transform([#list_team += <>
                                            <span class="rouge">{login} n'est pas encore enregistré dans le site</span>
                                            <br/></>]);
              void
            }
        }
        <>
<br/>
Ajouter un login utc à la team : <input id="login_team"/>
         <button onclick={function(_) {
                          add()
         }}>Ajouter</button><br/>
<br/>
Liste des personnes déjà rentré : 
         <br/>
<div id="list_team">{list()}</div>
</>
    }
    function xhtml conf_pack(param) {
        id = Dom.fresh_id();
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
        recursive function list() {
                      function rm(key) {
                          Db.remove(ref_k(key));
                          Dom.transform([#{"pack_list_" ^ id} = list()])
                      }
                      function edit(key) {
                          function do_edit() {
                              title = Dom.get_value(#{(id ^ "_title")});
                              desc = Dom.get_value(#{(id ^ "_desc")});
                              prix =
                                  Option.`default`(0.,
                                    Parser.try_parse(Rule.float,
                                      Dom.get_value(#{(id ^ "_prix")})));
                              jlog("edit pack {title} {desc} {prix}");
                              Db.write(ref_k(key), ~{title, desc, prix});
                              Dom.transform([#{"add_" ^ id} = <>
                                                               Pour ajouter un autre pack, actualise la page
                                                               <br/></>,
                                              #{"pack_list_" ^ id} = 
                                              list()])
                          }
                           form = {
                              value = Db.read(ref_k(key));
                              <>Titre : 
                               <input id={id ^ "_title"} value={value.title}/>
                               <br/>
Description : 
                               <input id={id ^ "_desc"} value={value.desc}/>
                               <br/>
Prix : 
                               <input id={id ^ "_prix"} value={value.prix}/>
                               <br/>

                               <button onclick={function(_) {
                                                do_edit()
                               }}> Editer </button></>
                          }
                          Dom.transform([#{"add_" ^ id} = form])
                      }
                      @todo
        }
        recursive function new() {
                      function add() {
                          title = Dom.get_value(#{(id ^ "_title")});
                          desc = Dom.get_value(#{(id ^ "_desc")});
                          prix =
                              Option.`default`(0.,
                                Parser.try_parse(Rule.float,
                                  Dom.get_value(#{(id ^ "_prix")})));
                           new_id = {
                              @todo
                          }
                          new_ref = ref_k(new_id);
                          jlog("add pack {title} {desc} {prix}");
                          Db.write(new_ref, ~{title, desc, prix});
                          Dom.transform([#{"add_" ^ id} = <>
                                                           <button onclick={(
                                                           function(_) {
                                                           new()
                                                           })}> Ajouter un pack </button>
                                                           <br/></>,
                                          #{"pack_list_" ^ id} = list()])
                      }
                      xhtml form =
                          <>Titre : <input id={id ^ "_title"}/><br/>
                           
Description : <input id={id ^ "_desc"}/><br/>
                           
Prix : <input id={id ^ "_prix"}/><br/>

                           <button onclick={function(_) {
                                            add()
                           }}> Ajouter </button></>;
                      Dom.transform([#{"add_" ^ id} = form])
        }
        <>

         <div id={"add_" ^ id}><button onclick={function(_) {
                                                new()
         }}> Ajouter un pack </button><br/></div>
<h3> Liste des packs </h3>

         <div id={"pack_list_" ^ id}>{list()}</div>
</>
    }
    function xhtml content() {
        <div class="right_cellule">
Configuration
<br/><br/>
{WAccordion.html_xhtml_content(Accordion_config,
                                                                Dom.fresh_id(),
                                                                [(Dom.fresh_id(),
                                                                  "Site",
                                                                  conf_site()),
                                                                  (Dom.fresh_id(),
                                                                   "Voyage",
                                                                   conf_voyage()),
                                                                  (Dom.fresh_id(),
                                                                   "Team",
                                                                   conf_team()),
                                                                  (Dom.fresh_id(),
                                                                   "Pack Bouff",
                                                                   conf_pack({
                                                                    
                                                                    bouf
                                                                    })),
                                                                  (Dom.fresh_id(),
                                                                   "Pack Matos",
                                                                   conf_pack({
                                                                    
                                                                    matos
                                                                    })),
                                                                  (Dom.fresh_id(),
                                                                   "Forfaits",
                                                                   conf_pack({
                                                                    
                                                                    forfait
                                                                    })),
                                                                  (Dom.fresh_id(),
                                                                   "Cours",
                                                                   conf_pack({
                                                                    
                                                                    cours
                                                                    }))])}
</div>
    }
    function get_page() {
        {
         ref : "configuration.html",
         title : "Configuration",
         content : content()
         }
    }
}