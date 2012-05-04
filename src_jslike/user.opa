import stdlib.widgets.loginbox

import stdlib.web.client

type User.status = option(User.ref)

type User.info = UserContext.t(User.status)

module User {
    ref_anonymous = "anonymous"
    private state = UserContext.make((User.status) Option.none)
    function get_status() {
        UserContext.execute((function(a) {
                             a
          }), state)
    }
    function get_current() {
        Option.`default`(User_data.mk_ref(ref_anonymous), get_status())
    }
    function is_logged() {
        Option.is_some(get_status())
    }
    function is_team() {
        /skiutc/users[get_current()]/team_skiutc
    }
    function is_admin() {
        get_current() == "roddehug"
    }
    function has_payed() {
        Option.is_some(?/skiutc/paiement[get_current()])
    }
    function log(User.ref user) {
        UserContext.change((function(_) {
                            Option.some(user)
          }), state)
    }
    function login(login, passwd) {
        useref = User_data.mk_ref(login);
        user = ?/skiutc/users[useref];
        match (user) {
            case { some : u }:
              if (Option.is_some(u.passwd) &&
                    (Option.get(u.passwd) ==
                       Option.get(User_data.mk_password(passwd))))
                log(User_data.mk_ref(login))
              else {} {}
            default: void
            }
            ;
        Client.reload()
    }
    function logout() {
        UserContext.change((function(_) {
                            Option.none
          }), state);
        if (myCas.is_logged()) myCas.logout_void() else Client.reload()
    }
    function xhtml loginbox() {
        user_opt =
            match (get_status()) {
            case { some : u }:
              Option.some(<>Bonjour {User_data.get_name(u)} ! <br/> <br/>
                           <a onclick={(function(_) {
                                        logout()
                           })}>Déconnexion</a></>)
            default: Option.none
            };
        WLoginbox.html_default("login_box", login, user_opt)
    }
}