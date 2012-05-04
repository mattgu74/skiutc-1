import stdlib.widgets.checkbox

module Passe_tour {
    exposed function more(key, id) {
        /skiutc/inscription[key]/tour <- /skiutc/inscription[key]/tour + 1;
        Dom.transform([#{id ^ "_tour"} = /skiutc/inscription[key]/tour]);
        void
    }
    exposed function less(key, id) {
        /skiutc/inscription[key]/tour <- /skiutc/inscription[key]/tour - 1;
        Dom.transform([#{id ^ "_tour"} = /skiutc/inscription[key]/tour]);
        void
    }
    server function xhtml validation(validation, key, id) {
        <><span id={id}><a onclick={function(_) {
                                    more(key, id)
         }}>+</a></span>
         <span id={id}> <a onclick={function(_) {
                                    less(key, id)
         }}>-</a></span><br/></>
    }
    server function xhtml show_row(r) {
        id = Dom.fresh_id();
        more = if (r.u.team_skiutc) <>Team SkiUTC</>
            else if (r.i.priorite == {oui}) <>Prioritaire</> else <></>;
        <tr id={id ^ "_tr"}>
<td>{r.key}</td>
<td>{r.i.num_place}</td>
<td>{r.u.nom}</td>
<td>{r.u.prenom}</td>
<td>{
        Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M:%S"),
          r.i.date)}</td>
<td><img src="https://demeter.utc.fr/pls/portal30/portal30.get_photo_utilisateur?username={r.key}" alt="{r.key}" width="150"/></td>
<td>{more}</td>
<td><span id={
        id ^ "_tour"}>{r.i.tour}</span></td>
<td>{validation(r.i.tour, r.key,
                                                    id)}</td>
</tr>
    }
    server function xhtml get_content() {
        <>
<h1>Mettre a la fin de la liste d'attente</h1>

         <button onclick={function(_) {
                          Inscription.update_places();
                          Client.reload()
         }}>Mettre a jour les numeros de places</button>

         <table border="1">
<thead>
<tr style="font-weight: bold;">
<th>Login</th>
<th>Numéro place</th>
<th>Nom</th>
<th>Prénom</th>
<th>Date inscription</th>
<th>Photo</th>
<th>+</th>
<th>nb de tour</th>
<th>Décaller</th>
</tr>
</thead>
<tbody>{
         List.fold((function((key, value), acc) {
                      user = /skiutc/users[key];
                      inscription = value;
                      if (Db.exists(@/skiutc/paiement[key]))
                        XmlConvert.of_alpha(acc)
                      else
                        <>{acc}
                         {show_row({~key, u : user, i : inscription})}</>
           }),
           List.sort_by((function((_k, value)) {
                         value.num_place
             }), Map.To.assoc_list(/skiutc/inscription)),
           <></>)}</tbody>
</table>
         
</>
    }
    function page() {
        if (User.is_team())
          Resource.full_page("SkiUTC - Passer un tour", get_content(), <></>,
            {success}, [])
        else
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