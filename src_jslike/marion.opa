import stdlib.widgets.checkbox

module Marion {
    exposed function valider(key, id) {
        /skiutc/paiement[key]/validation <- some(Date.now());
        Dom.set_style_property_unsafe(#{(id ^ "_tr")}, "background-color",
          "#5F5");
        Dom.transform([#{id} = <>Validé le 
                                {Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M:%S"),
                                   Option.get(/skiutc/paiement[key]/validation))}
                                <br/></>])
    }
    exposed function valider2(key, id) {
        /skiutc/paiement[key]/validation2 <- some(Date.now());
        Dom.set_style_property_unsafe(#{(id ^ "_tr")}, "background-color",
          "#5F5");
        Dom.transform([#{id} = <>Validé le 
                                {Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M:%S"),
                                   Option.get(/skiutc/paiement[key]/validation2))}
                                <br/></>])
    }
    server function validation(validation, key, id) {
        if (Option.is_some(validation))
          <>Validé le 
           {Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M:%S"),
              Option.get(validation))}
           <br/></>
        else
          if ((User.get_current() == "mcourvoi") ||
                (User.get_current() == "mguffroy"))
            <>
             <span id={id}><a onclick={function(_) {
                                       valider(key, id)
             }}>Valider le paiement</a></span><br/></>
          else <>Marion n'a pas encore validé le paiement<br/></>
    }
    server function validation2(validation, key, id) {
        if (Option.is_some(validation))
          <>Validé le 
           {Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M:%S"),
              Option.get(validation))}
           <br/></>
        else
          if ((User.get_current() == "mcourvoi") ||
                (User.get_current() == "mguffroy"))
            <>
             <span id={id}><a onclick={function(_) {
                                       valider2(key, id)
             }}>Valider le second paiement</a></span><br/></>
          else <>Marion n'a pas encore validé le second paiement<br/></>
    }
    server function xhtml show_row(r) {
        id = Dom.fresh_id();
        color = if (Option.is_some(r.p.validation)) "5F5" else "F55";
        <tr id={id ^ "_tr"} style="background-color:#{color};">
<td>{r.key}</td>
<td>{r.u.nom}</td>
<td>{r.u.prenom}</td>
<td>{
        Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M:%S"),
          r.p.date)}</td>
<td>{r.p.montant_cheque1} €</td>
<td>{r.p.montant_cheque2} €</td>
<td>{
        User_data.get_name(r.p.permanencier)} ({r.p.permanencier})</td>
<td>{
        validation(r.p.validation, r.key, id)}</td>
<td>{validation2(r.p.validation2,
                                                           r.key, id)}</td>
</tr>
    }
    server function string show_csv(r) {
        validation =
            if (Option.is_some(r.p.validation))
              Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M:%S"),
                Option.get(r.p.validation))
            else "Non valid\195\169";
        validation2 =
            if (Option.is_some(r.p.validation2))
              Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M:%S"),
                Option.get(r.p.validation2))
            else "Non valid\195\169";
        "\"{r.key}\";\"{r.u.nom}\";\"{r.u.prenom}\";\"{Date.to_formatted_string(
                                                         Date.generate_printer("%d/%m/%y \195\160 %H:%M:%S"),
                                                         r.p.date)}\";\"{r.p.montant_cheque1} \226\130\172\";\"{r.p.montant_cheque2} \226\130\172\";\"{
        User_data.get_name(r.p.permanencier)} ({r.p.permanencier})\";\"{validation}\";\"{validation2}\"\n"
    }
    server function content_csv() {
        @todo
    }
    server function content_xhtml() {
        @todo
    }
    server function xhtml get_content() {
        <>
<h1>Validation des paiements</h1>

         <table border="1">
<thead>
<tr style="font-weight: bold;">
<th>Login</th>
<th>Nom</th>
<th>Prénom</th>
<th>Date paiement</th>
<th>Chèque 1</th>
<th>Chèque 2</th>
<th>Vendeur</th>
<th>Validation</th>
<th>Validation 2</th>
</tr>
</thead>
<tbody>{
         content_xhtml()}</tbody>
</table>
</>
    }
    function page() {
        if (User.is_team())
          Resource.full_page("SkiUTC - Validation des paiements",
            get_content(), <></>, {success}, [])
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
    function to_csv() {
        if (User.is_team())
          Resource.raw_response(content_csv(), "text/csv", {success})
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