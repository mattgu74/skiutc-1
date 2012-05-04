module Exterieur {
    function validate() {
        email = Dom.get_value(#email_ext);
        pass = Random.string(5);
        User_data.save(User_data.mk_ref(email),
          {/skiutc/users[email] with
           login_utc : {invite : User.get_current()}, ~email,
           passwd : User_data.mk_password(pass)});
        objet = "Un ami te propose de t'inscrire \195\160 SkiUTC";
        message =
            {
             text :
               "Bonjour, \n Ton adresse email : {email} a \195\169t\195\169 ajout\195\169 au site de skiutc par : {
               User.get_current()}\n \nPour te connecter au site de skiutc utilise le bouton \"invit\195\169\" ton login est ton adresse mail et ton mot de passe est : {pass}\n\n\nPS : Tu dois valider ton inscription le plus vite possible.\n\nPS2 : Ton d\195\169part ne sera confirm\195\169 que lorsque tu auras pay\195\169.\n\nPS3 : Etant donn\195\169 qu'il y a d\195\169j\195\160 une liste d'attente cons\195\169quente, nous ne te garrantissons rien quand \195\160 ton d\195\169part pour le moment.\n\n\n\nSkiUTC."
             };
        email_send(Email.of_string("skiutc@assos.utc.fr"),
          Email.of_string("mattgu74@gmail.com"), objet, message,
          (function(_) {
           void
          }));
        email_send(Email.of_string("skiutc@assos.utc.fr"),
          Email.of_string("thibaut.ouvrier.buffet@gmail.com"), objet,
          message, (function(_) {
                    void
          }));
        email_send(Email.of_string("skiutc@assos.utc.fr"),
          Email.of_string(email), objet, message, (function(_) {
                                                   void
          }));
        Dom.transform([#info_ext = <>login = {email} , password = {pass}</>]);
        Dom.clear_value(#email_ext)
    }
    function xhtml ajout() {
        <>Ajouter un exterieur : <br/>
Email : <input id="email_ext"/>
         <button onclick={function(_) {
                          validate()
         }}>Ajouter</button><br/>
<span id="info_ext"/></>
    }
}