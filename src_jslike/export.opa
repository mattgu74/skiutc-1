module Export {
    function record_to_line(r) {
        function utc(u) {
            match (u) {
            case ~{ utc }: "{utc}"
            case ~{ invite }: "exterieur invite par {invite}"
            }
        }
        sexe = if (r.v.sexe == {male}) "Homme" else "Femme";
        team = if (r.v.team_skiutc) "Oui" else "";
        cotisant = if (r.v.cotisant_bde) "Oui" else "NON !!!";
        function string show_date(ins) {
            Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M:%S"),
              ins.date)
        }
        function show_bouf(ins) {
            /skiutc/conf/bouf[ins.pack_bouf]/title
        }
        function show_matos(ins) {
            /skiutc/conf/matos[ins.pack_matos]/title
        }
        function show_forfait(ins) {
            /skiutc/conf/forfait[ins.pack_forfait]/title
        }
        function show_cours(ins) {
            /skiutc/conf/cours[ins.pack_cours]/title
        }
        function m1(p) {
            "{p.montant_cheque1} \226\130\172"
        }
        function m2(p) {
            "{p.montant_cheque2} \226\130\172"
        }
        function perm(p) {
            User_data.get_name(p.permanencier)
        }
        function pvalid(p) {
            if (Option.is_some(p.validation))
              Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M:%S"),
                Option.get(p.validation))
            else "Non valid\195\169"
        }
        function pvalid2(p) {
            if (Option.is_some(p.validation2))
              Date.to_formatted_string(Date.generate_printer("%d/%m/%y \195\160 %H:%M:%S"),
                Option.get(p.validation2))
            else "Non valid\195\169"
        }
        function def(opt, getter) {
            if (Option.is_some(opt)) getter(Option.get(opt)) else "NON"
        }
        function defp(opt, getter) {
            if (Option.is_some(opt)) getter(Option.get(opt)) else "NON"
        }
        function defa(opt, getter) {
            if (Option.is_some(opt)) getter(Option.get(opt)) else "NON"
        }
        function b2s(b) {
            if (b) "Oui" else "Non"
        }
        "\"{r.key}\";\"{r.v.prenom}\";\"{r.v.nom}\";\"{utc(r.v.login_utc)}\";\"{sexe}\";\"{team}\";\"{cotisant}\";\"{r.v.email}\";\"{r.v.tel}\";\"{r.v.adresse}\";\"{r.v.taille}\";\"{r.v.poids}\";\"{r.v.pointure}\";\"{r.v.taille_vet}\";\"{
        def(r.i, show_date)}\";\"{def(r.i, show_bouf)}\";\"{def(r.i,
                                                              show_matos)}\";\"{
        def(r.i, show_forfait)}\";\"{def(r.i, show_cours)}\";\"{def(r.i,
                                                                  (function(a) {
                                                                   "{a.num_place}"
                                                                  }))}\";\"{
        def(r.i, (function(a) {
                  if (a.priorite == {oui}) "oui" else "non"
          }))}\";\"{def(r.i, (function(a) {
                              "{a.tour}"
                      }))}\";\"{defp(r.p, show_date)}\";\"{defp(r.p, m1)}\";\"{
        defp(r.p, m2)}\";\"{defp(r.p, perm)}\";\"{defp(r.p, pvalid)}\";\"{
        defp(r.p, pvalid2)}\";\"{if (Option.is_some(r.mopt)) "OK"
        else "PAR DEFAUT"}\";\"{b2s(r.m.bus_aller)}\";\"{b2s(r.m.bus_retour)}\";\"{
        b2s(r.m.paris)}\";\"{r.m.contact_nom}\";\"{r.m.contact_prenom}\";\"{r.m.contact_tel}\";\"{r.m.sante}\";\"{r.m.more_sante}\";\"{r.m.more}\";\"{
        defa(r.a, (function(a) {
                   a.residence
          }))}\";\"{if (Option.is_some(r.aid)) Option.get(r.aid)
        else -1}\"\n"
    }
    function to_csv() {
        if (User.is_team()) {
          my_content =
              "\"Key\";\"Prenom\";\"Nom\";\"UTC\";\"sexe\";\"team\";\"Cotisant\";\"email\";\"tel\";\"adresse\";\"taille\";\"poids\";\"pointure\";\"vetement\";\"Inscription - date\";\"Inscription pack_bouf\";\"Inscription pack_matos\";\"Inscription forfait\";\"Inscription cours\";\"Num_place\";\"Prioritaire\";\"NB de tour\";\"Paiement - date\";\"Cheque 1\";\"Cheque 2\";\"Permanencier\";\"Validation paiement\";\"Validation paiement 2\";\"INFOS COMPLEMENTAIRES\";\"Bus Aller\";\"Bus Retour\";\"Arret Paris\";\"Contact Nom\";\"Contact Prenom\";\"Telephone contact\";\"Pb sante\";\"En cas de pb\";\"Infos +\";\"Residence\";\"Appart n\194\176\"\n";
           list = {
              @todo
          }
          my_content =
              List.fold((function(v, a) {
                         a ^ record_to_line(v)
                }), list, my_content);
          Resource.raw_response(my_content, "text/csv", {success})
        } else
          Resource.raw_response("Tu n'es pas authoris\195\169 !",
            "text/plain", {unauthorized})
    }
}