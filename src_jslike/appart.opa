module SelectAppart {
    function xhtml button_ajout(key, appart) {
        function action() {
            Appart.subscribe(User.get_current(), key);
            Client.reload()
        }
        <button onclick={function(_) {
                         action()
        }}> M'ajouter ici </button>
    }
    function xhtml xhtml_tool_switch(current_user, current_user_switch, other_ref) {
        <></>
    }
    server function show_places(key, appart) {
        tuple_3 init = (0, <></>, false);
        current_ref = User.get_current();
        current_switch = User_data.get_switch(current_ref);
        function do_one(state) {
            (n, acc, param) = state
            occ = List.get(n, appart.occupants);
            (value, p) =
                if (Option.is_some(occ)) {
                  pl = Option.get(occ);
                  if ((pl == User.get_current()))
                    (<span class="me">--Moi même, je suis ICI--</span>,
                     param)
                  else
                    (<><span class="occupe">{User_data.get_name(pl)}</span>

                      {xhtml_tool_switch(current_ref, current_switch, pl)}
                      
</>,
                     param)
                } else
                  if (appart.bloque)
                    (<span class="bloque">Place Bloque</span>, param)
                  else (<span class="libre">Place libre</span>, true)
            (n + 1, <>{acc}<div class="place">{value}</div></>, p)
        }
        (_, r, p) =
            for(init, do_one, (function((n, _, _)) {
                               n < appart.nb_place
              }))
        if (p) <>{r}{button_ajout(key, appart)}</> else r
    }
    function renderAppart(key) {
        appart = /skiutc/apparts[key];
        class = if (appart.calme) "calme" else "fetard";
        <>

         <div class="{class} appart">{appart.nb_place} places.
{show_places(key,
                                                                  appart)}
</div>
         
</>
    }
    server function xhtml show_current_switch() {
        <></>
    }
    server function xhtml show_switch_requests() {
        <></>
    }
    function select() {
        residences =
            List.unique_list_of(List.map((function(a) {
                                          a.residence
                                  }), Map.To.val_list(/skiutc/apparts)));
        content =
            List.fold((function(v,
                       acc) {
                       <>{acc}

                        <div class="right_cellule">
{v}
<br/><br/>
{@todo}
<div style="clear: both;"/>
</div></>
              }), residences, <></>);
        <>

         <div class="right_cellule">
Sélection des appartements
<br/><br/>
<div class="info">Pour échanger avec quelqu'un, cliquez sur le 'E' à côté de son nom, vous serez alors en attente d'une approbation de sa part. S'il change d'appart, ou accepte une autre demande, votre demande sera alors annulée.</div>
{
         show_current_switch()}
{show_switch_requests()}
</div>
{content}
</>
    }
    function content() {
        if (User.is_logged()) if (User.has_payed()) select()
          else
            <div class="right_cellule">
Sélection des appartements
<br/><br/>
Vous ne faites pas partie des 310 personnes partant pour Skiutc...
<br/>
</div>
        else
          <div class="right_cellule">
Sélection des appartements
<br/><br/>
Veuillez vous connecter !
<br/>
</div>
    }
    function get_page() {
        {
         ref : "appart.html",
         title : "Selection des apparts",
         content : content()
         }
    }
}