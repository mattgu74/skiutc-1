import stdlib.themes.bootstrap
import stdlib.widgets.bootstrap
import stdlib.web.client

WB = WBootstrap;
user_is_logged = false;
user_is_team = false;
user_is_admin = false;

Parser.general_parser(((http_request -> resource))) urls = {
  parser{
    "" : 
      function(_req) {
        Render.public_p(Accueil.get_page())
      }
    case "/" : 
      function(_req) {
        Render.public_p(Accueil.get_page())
      }
    case "/accueil.html" .* :
      function(_req) {
        Render.public_p(Accueil.get_page())
      }
  /*
    case "/asso.html" .* :
      function(_req) {
      Render.public(Asso.get_page())
      }
    case "/presentation.html" .* :
      function(_req) {
      Render.public(Presentation.get_page())
      }
    case "/partenaires.html" .* :
      function(_req) {
      Render.public(Partenaires.get_page())
      }
    case "/team.html" .* :
      function(_req) {
      Render.public(Team.get_page())
      }
  */
    case .* : function(_req) {
        Render.error()
      }
  }
}

Server.make( Resource.add_auto_server( @static_resource_directory("res"), urls));