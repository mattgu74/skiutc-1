module Listing {
    function xhtml link() {
        <a href="admin_listing.html">Listings </a>
    }
    function xhtml get_content() {
        exposed function content() {
            List.sort_by((function(value) {
                          Option.`default`(Inscription.empty,
                            value.inscription).num_place
              }), @todo)
        }
        bouf = /skiutc/conf/bouf;
        matos = /skiutc/conf/matos;
        forfait = /skiutc/conf/forfait;
        both function clean_utc(u) {
            match (u) {
            case ~{ utc }:
              <img src="https://demeter.utc.fr/pls/portal30/portal30.get_photo_utilisateur?username={utc}" alt="{utc}" width="150"/>
            case ~{ invite }: <>invite par {invite}</>
            }
        }
        both function sexe_to_string(s) {
            match (s) {
            case { male }: "Homme"
            case { female }: "Femme"
            }
        }
        both function xhtml row2line(row, bool grey) {
            <tr style="{if (grey) "background-color:#BBB;"
            else ""}">
<td class="td_place">{Option.`default`(Inscription.empty,
                                               row.inscription).num_place}</td>
<td class="td_key">{row.key}</td>
<td class="td_prenom">{row.user.prenom}</td>
<td class="td_nom">{row.user.nom}</td>
<td class="td_utc">{
            clean_utc(row.user.login_utc)}</td>
<td class="td_sexe">{
            sexe_to_string(row.user.sexe)}</td>
<td class="td_team">{
            if (row.user.team_skiutc) "Oui"
            else ""}</td>
<td class="td_cotisant">{if (row.user.cotisant_bde)
                                                     "Oui"
            else "NON !!!"}</td>
<td class="td_email">{row.user.email}</td>
<td class="td_tel">{row.user.tel}</td>
<td class="td_adresse">{row.user.adresse}</td>
<td class="td_taille">{row.user.taille} cm</td>
<td class="td_poids">{row.user.poids} kg</td>
<td class="td_pointure">{row.user.pointure}</td>
<td class="td_taille_vet">{row.user.taille_vet}</td>
{
            if (Option.is_some(row.inscription)) {
              ins = Option.get(row.inscription);
              <><td class="td_inscrit">OUI</td>
                      
               <td class="td_ins_date">{Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M"),
                                          ins.date)}</td>
               
                      
               <td class="td_ins_bouf">{Option.`default`({
                                                          title : "ERROR",
                                                          desc : "",
                                                          prix : 0.
                                                          },
                                          Map.get(ins.pack_bouf, bouf)).title}</td>
               
                      
               <td class="td_ins_matos">{Option.`default`({
                                                           title : "ERROR",
                                                           desc : "",
                                                           prix : 0.
                                                           },
                                           Map.get(ins.pack_matos, matos)).title}</td>
               
                      
               <td class="td_ins_forfait">{Option.`default`({
                                                             title : "ERROR",
                                                             desc : "",
                                                             prix : 0.
                                                             },
                                             Map.get(ins.pack_forfait,
                                               forfait)).title}</td>
               
                      
               <td class="td_ins_priorite">{match (ins.priorite) {
               case { non }: ""
               case { oui }: "Place reserve"
               }}</td></>
            } else
              <><td class="td_inscrit">NON</td>
                      
               <td class="td_ins_date"/>
                      
               <td class="td_ins_bouf"/>
                      
               <td class="td_ins_matos"/>
                      
               <td class="td_ins_forfait"/>
                      
               <td class="td_ins_priorite"/></>}
</tr>
        }
        client function hide_column(class) {
            Dom.hide(Dom.select_class(class));
            void
        }
        client function show_column(class) {
            Dom.show(Dom.select_class(class));
            void
        }
        server function sort(class) {
            content_sorted =
                List.sort_by((function(row) {
                              match (class) {
                              case "td_key": row.key
                              case "td_prenom": row.user.prenom
                              case "td_nom": row.user.nom
                              case "td_utc":
                                "{clean_utc(row.user.login_utc)}"
                              case "td_sexe": sexe_to_string(row.user.sexe)
                              case "td_team": if (row.user.team_skiutc) "yes"
                                else "no"
                              case "td_cotisant":
                                if (row.user.cotisant_bde) "Oui"
                                else "NON !!!"
                              case "td_email": row.user.email
                              case "td_tel": row.user.tel
                              case "td_adresse": row.user.adresse
                              case "td_taille": row.user.taille
                              case "td_poids": row.user.poids
                              case "td_pointure": row.user.pointure
                              case "td_taille_vet": row.user.taille_vet
                              case "td_inscrit":
                                if (Option.is_some(row.inscription)) "oui"
                                else "non"
                              case "td_ins_date":
                                Date.to_formatted_string(Date.generate_printer("%y%m%d%H%M"),
                                  Option.`default`(Inscription.empty,
                                    row.inscription).date)
                              case "td_ins_bouf":
                                String.of_int(Option.`default`(Inscription.empty,
                                                row.inscription).pack_bouf)
                              case "td_ins_matos":
                                String.of_int(Option.`default`(Inscription.empty,
                                                row.inscription).pack_matos)
                              case "td_ins_forfait":
                                String.of_int(Option.`default`(Inscription.empty,
                                                row.inscription).pack_forfait)
                              default: row.key
                              }
                  }), content());
            (table, _) =
                List.fold((function(v,
                           a) {
                           (acc, coul) = a
                           (<>{acc}{row2line(v, not(coul))}</>, not(coul))
                  }), content_sorted, (<></>, true))
            Dom.transform([#table_body = table])
        }
        client function checkbox(class) {
            WCheckbox.edit(WCheckbox.default_config, Dom.fresh_id(),
              {
               editable : true,
               function on_change(v) {
                 if (v) show_column(class) else hide_column(class)
               }
              },
            true)
    }
    <>
<h1> Listing </h1>
<br/>

     <a onclick={function(_) {
                 Inscription.update_places();
                 Client.reload()
     }}>Actualiser les numeros de places</a><br/>
{Stats.link()}
<br/>
<hr/>

     <table border="1">
<thead>
<tr style="font-weight: bold;">
<th class="td_place">Position</th>
<th class="td_key"><a onclick={
     function(_) {
     sort("td_key")
     }}>Login</a></th>
<th class="td_prenom"><a onclick={function(_) {
                                                         sort("td_prenom")
     }}>Prenom</a></th>
<th class="td_nom"><a onclick={function(_) {
                                                       sort("td_nom")
     }}>Nom</a></th>
<th class="td_utc"><a onclick={function(_) {
                                                    sort("td_utc")
     }}>UTC</a></th>
<th class="td_sexe"><a onclick={function(_) {
                                                     sort("td_sexe")
     }}>Sexe</a></th>
<th class="td_team"><a onclick={function(_) {
                                                      sort("td_team")
     }}>Team</a></th>
<th class="td_cotisant"><a onclick={function(_) {
                                                          sort("td_cotisant")
     }}>Cotisant</a></th>
<th class="td_email"><a onclick={function(_) {
                                                           sort("td_email")
     }}>Email</a></th>
<th class="td_tel"><a onclick={function(_) {
                                                      sort("td_tel")
     }}>Tel</a></th>
<th class="td_adresse"><a onclick={function(_) {
                                                        sort("td_adresse")
     }}>Adresse</a></th>
<th class="td_taille"><a onclick={function(_) {
                                                           sort("td_taille")
     }}>Taille</a></th>
<th class="td_poids"><a onclick={function(_) {
                                                         sort("td_poids")
     }}>Poids</a></th>
<th class="td_pointure"><a onclick={function(_) {
                                                           sort("td_pointure")
     }}>Pointure</a></th>
<th class="td_taille_vet"><a onclick={function(_) {
                                                                sort("td_taille_vet")
     }}>Taille Vetement</a></th>
<th class="td_inscrit"><a onclick={function(_) {
                                                                    sort("td_inscrit")
     }}>Inscrit ?</a></th>
<th class="td_ins_date"><a onclick={function(_) {
                                                               sort("td_ins_date")
     }}>Date d'inscription</a></th>
<th class="td_ins_bouf"><a onclick={
     function(_) {
     sort("td_ins_bouf")
     }}>Pack bouffe</a></th>
<th class="td_ins_matos"><a onclick={function(_) {
                                                                  sort("td_ins_matos")
     }}>Pack matos</a></th>
<th class="td_ins_forfait"><a onclick={function(_) {
                                                                   sort("td_ins_forfait")
     }}>Choix du forfait</a></th>
<th class="td_ins_priorite">Priorite</th>
</tr>
</thead>
<tbody id="table_body">
{
     (table, _) =
         List.fold((function(v,
                    a) {
                    (acc, coul) = a
                    (<>{acc}{row2line(v, not(coul))}</>, not(coul))
           }), content(), (<></>, true))
     table}
</tbody>
</table>
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
      Resource.full_page("SkiUTC - Admin Listings", get_content(),
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