import stdlib.core.web.request

base_url = Option.`default`("", Resource.base_url)

cas_conf =
    (Cas.config) {url : "https://cas.utc.fr/cas/", service : "{base_url}"}

myCas = Cas(cas_conf)

function restant() {
    Date.between(Date.now(),
      Date.build({
                  year : 2011,
                  month : {october},
                  day : 19,
                  h : 19,
                  min : 15,
                  s : 0,
                  ms : 0
                  }))
}

function duree() {
    Duration.to_human_readable(restant())
}

both function xhtml timeleft() {
    duree = duree();
    <>

     <table id="compte_a_rebour">
<tr id="car_num">
<td>{duree.day}</td>
<td>{duree.h}</td>
<td>{duree.min}</td>
<td>{duree.s}</td>
</tr>
<tr id="car_text">
<td>DAYS</td>
<td>HOURS</td>
<td>MINUTES</td>
<td>SECONDS</td>
</tr>
</table>
     
</>
}

client function refresh() {
    if (Duration.is_positive(restant())) {
      Dom.transform([#time_left_s = XmlConvert.of_alpha(timeleft())]);
      void
    } else Client.reload()
}

function resource wait() {
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
    xhtml page =
        <>
         <div style="margin: auto; width:900px; height: 651px;"><img src="res/skiutc-arrive.jpg" alt="Bient\195\180t" width="900"/></div>
         

         <div style="width: 200px; margin: auto; position: relative; top: -640px; z-index: 10; right: -300px;">Ouverture du site dans : <br/>
<span id="time_left_s" onready={
         function(_) {
         Scheduler.timer(1000, refresh)
         }}>{timeleft()}</span></div>
</>;
    Resource.full_page("SkiUTC arrive ", page,
      <><link rel="stylesheet" type="text/css" href="res/css.css"/>
       {XmlConvert.of_alpha(googleanalytics("UA-25934255-1"))}</>,
      {success}, [])
}

Parser.general_parser(((http_request -> resource))) default_urls = {
    parser{
    "/favicon.gif" :
    function(_req) {
    @static_resource[res/favicon.gif]
    }
    case result = {myCas.resource} : function(_req) {
                                     result
      }}
    }
    
    Parser.general_parser(((http_request -> resource))) urls = {
        parser{
        "" :
        function(_req) {
        Render.public(Accueil.get_page())
        }
        case "/" : 
          function(_req) {
          Render.public(Accueil.get_page())
          }
        case "/accueil.html" .* :
          function(_req) {
          Render.public(Accueil.get_page())
          }
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
        case "/mon_compte.html" .* :
          function(_req) {
          Render.private(Mon_compte.get_page())
          }
        case "/team.html" .* :
          function(_req) {
          Render.public(Team.get_page())
          }
        case "/appart.html" .* :
          function(_req) {
          Render.public(SelectAppart.get_page())
          }
        case "/admin_configuration.html" .* :
          function(_req) {
          Render.team(Configuration.get_page())
          }
        case "/admin_listing.html" .* : function(_req) {
          Listing.resource()
          }
        case "/admin_mailing.html" .* : function(_req) {
          Mailing.resource()
          }
        case "/admin_stats.html" .* :
          function(_req) {
          Render.team(Stats.get_page())
          }
        case "/admin_appart.html" .* :
          function(_req) {
          Render.admin(Appart.get_page())
          }
        case "/admin_user.html" .* :
          function(_req) {
          Render.team(Admin_user.get_page())
          }
        case "/marion.csv" .* : function(_req) {
                                Marion.to_csv()
          }
        case "/marion" .* : function(_req) {
                            Marion.page()
          }
        case "/decalage" .* : function(_req) {
                              Passe_tour.page()
          }
        case "/export.csv" .* : function(_req) {
                                Export.to_csv()
          }
        case "/friends.csv" .* : function(_req) {
                                 FriendList.export_csv()
          }
        case "/friends_team.csv" .* :
          function(_req) {
          FriendList.export_csv_team()
          }
        case "/friends_appart.csv" .* :
          function(_req) {
          FriendList.export_csv_appart()
          }
        case .* : function(_req) {
                  Render.error()
          }}
        }
        
        function Parser.general_parser(((http_request -> resource))) urls_if() {
            if (Duration.is_positive(restant()) && not(User.is_team())) {
              parser{
              default = {default_urls} :
              `default` case "/construction" construct = {urls} : construct
              case .* : function(_req) {
                        wait()
                }}
              } else {
                parser{
                default = {default_urls} :
                `default` case pages = {urls} : pages}
                }
              }
              
              Parser.general_parser(((http_request -> resource))) urls_caller = {
                  parser{
                  get = {urls_if()} :
                  get}
              }
              
              `server` =
                  Server.make(Resource.add_auto_server(@static_resource_directory("res"),
                                urls_caller))