module Stats {
    site_email = Email.of_string("skiutc@assos.utc.fr")
    admin_email = Email.of_string("skiutc@assos.utc.fr")
    function xhtml link() {
        <a href="admin_stats.html">Statistiques </a>
    }
    function make_stats(param) {
        (getid, map) =
            match (param) {
            case { bouff }:
              (function(ins) {
               ins.pack_bouf
               }, /skiutc/conf/bouf)
            case { matos }:
              (function(ins) {
               ins.pack_matos
               }, /skiutc/conf/matos)
            case { forfait }:
              (function(ins) {
               ins.pack_forfait
               }, /skiutc/conf/forfait)
            case { cours }:
              (function(ins) {
               ins.pack_cours
               }, /skiutc/conf/cours)
            }
        function count(key) {
            List.length(List.filter((function(elt) {
                                     getid(elt) == key
                          }),
                          List.fold((function(v,
                                     a) {
                                     List.add(/skiutc/inscription[v], a)
                            }), Map.To.key_list(/skiutc/paiement), [])))
        }
        <table border="1">
<thead>
<th>Titre</th><th>Nombre</th><th>Prix unitaire</th><th>Montant total</th>
</thead>{
        Map.fold((function(key, value, acc) {
                    nb = count(key);
                    <>{XmlConvert.of_alpha(acc)}
                     <tr><td>{value.title}</td>
<td>{nb}</td>
<td>{value.prix}</td>
<td>{
                     value.prix * Float.of_int(nb)}</td></tr></>
          }), map, <></>)}
</table>
    }
    function xhtml get_content() {
        inscrit = Map.To.assoc_list(/skiutc/inscription);
        paye = Map.To.key_list(/skiutc/paiement);
        all = Map.To.key_list(/skiutc/users);
        (team, reste) =
            List.fold((function(key,
                       (team, reste)) {
                       if (User_data.is_in_team(key))
                         (List.add(key, team), reste)
                       else (team, List.add(key, reste))
              }), all, ([], []))
        (team_ins, prio_ins, reste_ins) =
            List.fold((function((key, value),
                       (team, prio, reste)) {
                       if (User_data.is_in_team(key))
                         (List.add((key, value), team), prio, reste)
                       else
                         if (value.priorite == {oui})
                           (team, List.add((key, value), prio), reste)
                         else (team, prio, List.add((key, value), reste))
              }), inscrit, ([], [], []))
        (team_pay, prio_pay, reste_pay) =
            List.fold((function(key,
                       (team, prio, reste)) {
                       if (User_data.is_in_team(key))
                         (List.add(key, team), prio, reste)
                       else
                         if (/skiutc/inscription[key]/priorite == {oui})
                           (team, List.add(key, prio), reste)
                         else (team, prio, List.add(key, reste))
              }), paye, ([], [], []))
        <div class="right_cellule">
Statistiques
<br/><br/>
<table border="1">
<thead>
<th>Categorie</th><th>NB paye / NB d'Inscrits / Total</th>
</thead>
<tr><td>Team</td><td>{
        List.length(team_pay)} / {List.length(team_ins)} / {List.length(team)}</td></tr>
<tr><td>Prioritaire</td><td>{
        List.length(prio_pay)} / {List.length(prio_ins)} / {List.length(prio_ins)}</td></tr>
<tr><td>Autres</td><td>{
        List.length(reste_pay)} / {List.length(reste_ins)} / {List.length(reste)}</td></tr>
<tr><td>Total</td><td>{
        Map.size(/skiutc/paiement)} / {Map.size(/skiutc/inscription)} / {
        Map.size(/skiutc/users)}</td></tr>
</table>
<br/>
<h2>Pack bouff</h2>
{
        make_stats({bouff})}
<h2>Pack matos</h2>
{make_stats({matos})}
<h2>Pack forfait</h2>
{
        make_stats({forfait})}
<h2>Pack cours</h2>
{make_stats({cours})}
</div>
    }
    function get_page() {
        {
         ref : "admin_stats.html",
         title : "Statistiques",
         content : get_content()
         }
    }
}