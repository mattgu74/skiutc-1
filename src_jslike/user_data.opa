import stdlib.crypto

import stdlib.web.mail

abstract type User.passwd = option(string)

abstract type User.ref = string

type User.t =
  {string prenom, string nom, or {string utc}
                              or {string invite} login_utc,
   or {male}
   or {female} sexe, bool team_skiutc, string statut, string email,
   string tel, string adresse, string taille, string poids, string pointure,
   string taille_vet, User.passwd passwd, bool cotisant_bde, bool reglement,
   option(User.ref) switch}

type User.map('a) = ordered_map(User.ref, 'a, String.order)

database User.map(User.t) /skiutc/users

database /skiutc/users[_]/team_skiutc = {false}

database /skiutc/users[_]/sexe = {male}

database /skiutc/users[_]/cotisant_bde = {false}

database /skiutc/users[_]/reglement = {false}

database /skiutc/users[_]/login_utc = {invite : ""}

module User_data {
    User.t empty =
        {
         prenom : "Utilisateur",
         nom : "Anonyme",
         login_utc : {invite : ""},
         sexe : {male},
         team_skiutc : false,
         statut : "",
         email : "",
         tel : "",
         adresse : "",
         taille : "",
         poids : "",
         pointure : "",
         taille_vet : "",
         passwd : none,
         cotisant_bde : false,
         reglement : false,
         switch : none
         }
    function bool is_profil_edited(User.ref user_ref) {
        user = get(user_ref);
        if (String.length(user.tel) < 8) false
        else if (String.length(user.taille) < 2) false
          else if (String.length(user.email) < 2) false
            else if (String.length(user.poids) < 2) false
              else if (String.length(user.nom) < 2) false
                else if (String.length(user.adresse) < 4) false
                  else if (String.length(user.pointure) < 2) false else true
    }
    function bool is_in_team(User.ref user_ref) {
        /skiutc/users[user_ref]/team_skiutc
    }
    function User.ref mk_ref(string login) {
        String.to_lower(login)
    }
    ref_to_string =
        @stringifier(function(User.ref ref) {
                     string ref
          } ; User.ref)
    function User.passwd mk_password(string pswd) {
        some(Crypto.Hash.sha2(pswd))
    }
    function void save(User.ref ref, User.t user) {
        jlog("user saved : {Debug.dump(user)}");
        /skiutc/users[ref] <- user
    }
    function User.t get(User.ref ref) {
        Option.`default`(empty, ?/skiutc/users[ref])
    }
    function list(User.t) get_team() {
        Map.fold((function(key, value,
                  acc) {
                  if (value.team_skiutc) List.add(value, acc) else acc
          }), /skiutc/users, [])
    }
    function string get_name(User.ref ref) {
        u = get(ref);
        "{u.prenom} {u.nom}"
    }
    function bool exists(User.ref ref) {
        Option.is_some(?/skiutc/users[ref])
    }
    function rm(User.ref login) {
        Db.remove(@/skiutc/users[login])
    }
    function void update_utc(User.ref ref) {
        if (Option.is_none(Email.of_string_opt(/skiutc/users[ref]/email)))
          /skiutc/users[ref]/email <- "{ref}@etu.utc.fr"
            else {} {};
        uri =
            Option.get(Uri.of_string("http://wwwassos.utc.fr/intra/api.php?login={ref}&key=vYa4b9BzVN98YkLt6xD9p6784dXS8e"));
        match (WebClient.Result.as_xml(WebClient.Get.try_get(uri))) {
        case { failure : _ }: void
        case ~{ success }:
          match (WebClient.Result.get_class(success)) {
          case { success }:
            match (success.content) {
            case ~{ args, ... }:
              user =
                  List.fold((function(v,
                             a) {
                             if (v.name == "nom")
                               {a with
                                nom :
                                  String.capitalize(String.to_lower(v.value))}
                             else
                               if (v.name == "prenom")
                                 {a with
                                  prenom :
                                    String.capitalize(String.to_lower(v.value))}
                               else
                                 if (v.name == "cotisant")
                                   if (v.value == "true")
                                     {a with cotisant_bde : true}
                                   else {a with cotisant_bde : false}
                                 else a
                    }), args,
                    {/skiutc/users[ref] with login_utc : {utc : ref}});
              /skiutc/users[ref] <- user
            default: void
            }
          default: void
          }
        }
    }
    function User.t get_utc() {
        match (myCas.get_status()) {
        case { logged : login }: update_utc(login);
          /skiutc/users[login]
        case { unlogged }: empty
        }
    }
    function option(User.ref) get_switch(User.ref ref) {
        user = get(ref);
        user.switch
    }
    function void set_switch(User.ref ref, option(User.ref) switch) {
        user = get(ref);
        save(ref, {user with ~switch})
    }
}

function void init_user() {
    User.t matthieu = {/skiutc/users["mguffroy"] with team_skiutc : true};
    /skiutc/users["mguffroy"] <- matthieu;
    hugo = {/skiutc/users["roddehug"] with team_skiutc : true};
    /skiutc/users["roddehug"] <- hugo;
    void
}

init_user();