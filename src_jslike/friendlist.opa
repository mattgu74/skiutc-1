type my_friends =
  {list(User.ref) ajoute_par_moi, list(User.ref) attente,
   list(User.ref) lien_fort}

database User.map(my_friends) /skiutc/friends

module FriendList {
    function xhtml link(string id) {
        <a onclick={function(_) {
                    get_popup(id, content())
        }}>Ma liste d'amis </a>
    }
    function refresh() {
        Dom.transform([#my_friends = mes_amis()])
    }
    function add_user(user) {
        /skiutc/friends[User.get_current()]/ajoute_par_moi <- List.add(user,
                                                                /skiutc/friends[
                                                                User.get_current()]/ajoute_par_moi);
        /skiutc/friends[user]/attente <- List.add(User.get_current(),
                                           /skiutc/friends[user]/attente);
        refresh()
    }
    function remove_user(user) {
        /skiutc/friends[User.get_current()]/ajoute_par_moi <- List.remove(user,
                                                                /skiutc/friends[
                                                                User.get_current()]/ajoute_par_moi);
        /skiutc/friends[user]/attente <- List.remove(User.get_current(),
                                           /skiutc/friends[user]/attente);
        void
    }
    function mes_amis() {
        myfriends = /skiutc/friends[User.get_current()];
        function liste(l, bouton) {
            List.fold((function(value,
                       acc) {
                       <>
{acc}
{User_data.get_name(value)} - 

                        {bouton(value)}
<br/>
</>
              }), l, <></>)
        }
        <>
<h2>Amis que j'ai ajouté</h2>

         {liste(myfriends.ajoute_par_moi,
            (function(u) {
             <a onclick={function(_) {
                         remove_user(u);
                         refresh()
             }}>Retirer</a>
            }))}
         
<h2>Personne qui m'ont ajouté</h2>

         {liste(myfriends.attente,
            (function(u) {
             <a onclick={function(_) {
                         add_user(u);
                         refresh()
             }}>Ajouter</a>
            }))}
         
</>
    }
    function xhtml content() {
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
         
Cette liste d'amis nous permettra, de vous regrouper entre pote dans les bus. 
         <br/>
         
Cette liste nous permettra égallement d'essayer de regrouper les apparts de potes, au même étage. 
         <br/>

         <div class="attention">
Uniquement les relations doubles seront prises en compte (vous devez ajouter la personne, et la personne doit vous ajouter).<br/>
Plus vous avez d'amis, plus il y a de chance pour que nous soyons obligé de couper le "groupe".
</div>
                            
<hr/>
Recherche : 
         {WCompletion.html({WCompletion.default_config with
                            suggest : list_nom},
            onselect, "input_nom", it)}
         <br/>
Login : <input id="login" readonly="readonly"/> 
         <button onclick={function(_) {
                          add_user(Dom.get_value(#login))
         }}>Ajouter !</button><br/>
<hr/>

         <div id="my_friends">{mes_amis()}</div>
</>
    }
    function void get_popup(string id, xhtml content) {
        Dom.transform([#{id} = <div id="shadow" style="display:none; position:fixed; top:0; left:0; width: 100%; height: 100%; background-color: #ccc; z-index: 10; opacity:0.7; filter: alpha(opcity=70);"/>]);
        Dom.show(#shadow);
        Dom.transform([#{id} =+ Popup.xhtml("Ma liste d'amis",
                                  <>
{content}
</>)]);
        void
    }
    function make_lien_fort() {
        @todo
    }
    function content_csv() {
        @todo
    }
    function content_csv_strong() {
        make_lien_fort();
        @todo
    }
    function content_csv_team() {
        make_lien_fort();
        @todo
    }
    function content_csv_appart() {
        make_lien_fort();
        @todo
    }
    function export_csv() {
        if (User.is_team())
          Resource.raw_response(content_csv_strong(), "text/csv", {success})
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
    function export_csv_team() {
        if (User.is_team())
          Resource.raw_response(content_csv_team(), "text/csv", {success})
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
    function export_csv_appart() {
        Resource.raw_response(content_csv_appart(), "text/csv", {success})
    }
}