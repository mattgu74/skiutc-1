type News.news =
  {int id, 
  string author, 
  Date.date date_creation, 
  Date.date date_edition,
  Date.date date_publication, 
  string title, 
  string content}

database News.news /skiutc/news[{id}]

module Accueil {
    function content() {
        if (user_is_team) News.admin() else News.home()
    }
    function get_page() {
        {ref : "accueil.html", title : "Accueil", content : content()}
    }
}

module News {
    function News.news empty() {
        {
         id : 1,
         author : "Author",
         date_creation : Date.now(),
         date_edition : Date.now(),
         date_publication : Date.advance(Date.now(), Duration.days(1)),
         title : "Nouvelle news",
         content : Xhtml.to_string(<>Nouvelle news</>)
         }
    }
    function save(int ref, News.news news) {
        /skiutc/news[{id: ref}] <- {news with date_edition : Date.now()}
    }
    function ref_to_xhtml(int ref) {
        to_xhtml(/skiutc/news[{id: ref}])
    }
    function xhtml to_xhtml(News.news n) {
        function printer(Date.date date) {
            Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M"),
              date)
        }
        <div class="right_cellule">
          {n.title}
          <br/><br/>
          {Xhtml.of_string_unsafe(n.content)}
          <br/>
          <div style="text-align: right; width: 100%; font-size: small;">Le {printer(n.date_publication)}.</div>
        </div>
    }
    function xhtml to_xhtml_admin(int key, News.news n) {
        id = Dom.fresh_id();
        function printer(Date.date date) {
            function echo(d) {
                if (d <= Date.now())
                  <>Parru le {Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M"), d)}.</>
                else
                  <>A parraitre le {Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M"), d)}.</>
            }
            function manage_date() {
                a_news = News.news /skiutc/news[{id: key}];
                d = Date.to_human_readable(a_news.date_publication);
                function validate() {
                    day = Dom.get_value(#{(id ^ "_jour")});
                    month = Dom.get_value(#{(id ^ "_mois")});
                    year = Dom.get_value(#{(id ^ "_annee")});
                    heure = Dom.get_value(#{(id ^ "_heure")});
                    min = Dom.get_value(#{(id ^ "_min")});
                    new_date = Date.of_human_readable({d with
                                                day : Int.of_string(day),
                                                month :Date.Month.of_int(Int.of_string(month) - 1),
                                                year : Int.of_string(year),
                                                h : Int.of_string(heure),
                                                min : Int.of_string(min)
                                              });
                    save(key, {/skiutc/news[{id: key}] with date_publication : new_date});
                    Dom.remove(#{(id ^ "_popup")});
                    Dom.transform([#{id ^ "_date"} = echo(new_date)])
                }
                xhtml content =
                    <>
                      <table style="display: table; border-collapse: separate; border-spacing: 2px 2px; border-color: gray; color=#444;">
                        <tr><td>Jour :</td><td><input id={
                                             id ^ "_jour"} value={d.day}/></td></tr>
                        <tr><td>Mois :</td><td><input id={
                                             id ^ "_mois"} value={Date.Month.to_int(d.month) + 1}/></td></tr>
                        <tr><td>Année :</td><td><input id={
                                             id ^ "_annee"} value={d.year}/></td></tr>
                        <tr><td>Heure :</td><td><input id={
                                             id ^ "_heure"} value={d.h}/></td></tr>
                        <tr><td>Minute :</td><td><input id={
                                             id ^ "_min"} value={d.min}/></td></tr>
                        <tr><td/><td><button onclick={ function(_) { validate()} }>Valider</button></td></tr>
                      </table>
                    </>;
                Dom.transform([#{id ^ "_bloc"} =+ <div id={id ^ "_popup"} style="position: absolute; display:block; background-color: grey; right: 5px; z-index: 99;">{content}</div>])
            }
            <span id={id ^ "_date"} onclick={ function(_) {manage_date()} }>{echo(date)}</span>
        }
        function edit_title() {
            a_news = News.news /skiutc/news[{id: key}];
            Dom.set_value(#{(id ^ "_title_edit")}, a_news.title);
            Dom.hide(#{(id ^ "_title")});
            Dom.show(#{(id ^ "_title_edit")})
        }
        function save_title() {
            title = Dom.get_value(#{(id ^ "_title_edit")});
            save(key, {/skiutc/news[{id: key}] with ~title});
            Dom.transform([#{id ^ "_title"} = <> {title} </>]);
            Dom.hide(#{(id ^ "_title_edit")});
            Dom.show(#{(id ^ "_title")})
        }
        function edit_content() {
            a_news = News.news /skiutc/news[{id: key}];
            Dom.set_value(#{(id ^ "_content_edit")}, a_news.content);
            Dom.hide(#{(id ^ "_content")});
            Dom.show(#{(id ^ "_content_edit")})
        }
        function save_content() {
            content = Dom.get_value(#{(id ^ "_content_edit")});
            save(key, {/skiutc/news[{id: key}] with ~content});
            Dom.transform([#{id ^ "_content"} = Xhtml.of_string_unsafe(content)]);
            Dom.hide(#{(id ^ "_content_edit")});
            Dom.show(#{(id ^ "_content")})
        }
        function delete() {
            Db.remove(@/skiutc/news[{id: key}]);
            Dom.remove(#{(id ^ "_bloc")});
            Dom.Notification.show("", "Supression", "Une news vient d'\195\170tre supprim\195\169 !");
            void
        }
        <div class="right_cellule" id={id ^ "_bloc"}>
          <span id={id ^ "_title"} onclick={ function(_) {edit_title()} }> 
            {
              if (n.title == "") "Empty title"
              else n.title
            } 
          </span>
          <input id={id ^ "_title_edit"} style={[Css_build.display({css_none})]} onblur={ function(_) {save_title()} }/>
          <button onclick={ function(_) {delete()} }>Supprimer</button>
          <br/><br/>
          <div id={id ^ "_content"} onclick={ function(_) {edit_content()} }>
            {Xhtml.of_string_unsafe(n.content)}
            <br/>
          </div>
          <textarea id={id ^ "_content_edit"} style={[Css_build.display({css_none})]} onblur={function(_) {save_content()} } rows="20" cols="90"/>
          <br/>
          <div style="text-align: right; width: 100%; font-size: small;">
            {printer(n.date_publication)}
          </div>
        </div>
    }
    function add_form() {
        Dom.transform([#right += to_xhtml_admin(@todo, empty())]);
        ignore(Dom.put_at_start(#right, #new_news));
        //Dom.Notification.show("", "Ajout", "Une news vient d'\195\170tre ajout\195\169 !");
        void
    }
    function home() {
        @todo
    }
    function xhtml admin() {
        <>
          <button id="new_news" onclick={function(_) {add_form()} }>Ajouter une news</button>
          {@todo}
        </>
    }
}

function void init_news() {
    dbset(News.news,_) dbsetallnews = /skiutc/news;
    int nb_news = Iter.count(DbSet.iterator(dbsetallnews));
    if (nb_news == 0) {
      News.news first =
          {
           id : 0,
           author : "Hugo",
           date_creation : Date.now(),
           date_edition : Date.now(),
           date_publication : Date.now(),
           title : "SkiUTC 2012 Arrive !!",
           content : Xhtml.to_string(<div class="info">Soyez patient... ;) </div>)
          };
      /skiutc/news[{id: 0}] <- first;
      void
    } 
}

init_news();