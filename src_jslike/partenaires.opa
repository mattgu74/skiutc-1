module Partenaires {
    function xhtml xhtml_partenaire(string titre, string link, string src_img, xhtml content) {
        <div class="right_cellule">
{titre}
<br/>
<br/>
<table>
<tr>
<td>
<a href="{link}"><img src="{src_img}" alt="{titre}" width="300px"/></a>
</td>
<td>
<p>
{content}
</p>
</td>
</tr>
</table>
</div>
    }
    function xhtml content() {
        <>

         <div class="right_cellule">
Nos partenaires !
<br/><br/>
Nous continuons de rechercher des partenaires pour la session 2012, de skiutc !<br/><br/>
Si vous êtes intéressés par notre projet et souhaitez faire partie de nos partenaires n’hésitez pas à nous contacter à l’adresse : <strong>skiutc@assos.utc.fr</strong>
</div>
         
<div class="right_cellule">Nos partenaires...</div>

         {xhtml_partenaire("La Soci\195\169t\195\169 G\195\169n\195\169rale",
            "http://www.societegenerale.fr/",
            "http://www.societegenerale.fr/images/eimm_logo.png",
            <>La Société générale est une des principales banques françaises et une des plus anciennes. Elle fait partie des trois piliers de l'industrie bancaire française non mutualiste (aussi appelés 'les Trois Vieilles').</>)}
         

         {xhtml_partenaire("BDE UTC", "http://wwwassos.utc.fr/",
            "http://wwwassos.utc.fr/comedmus/comedmus2007/images/photos/BDE.jpg",
            <>
             <p>Le bureau des étudiants de l'UTC (BDE-UTC) est une association 1901 qui a pour objet l'animation et la structuration de la vie étudiante de l'UTC de manière saine, responsable et constructive.</p>
             <p>
Dans ce cadre le BDE-UTC administre la Maison des Étudiants (MDE), partie du bâtiment C du centre Benjamin Franklin, dans le cadre de la Convention d'Occupation de la MDE signée chaque année avec l'UTC. Depuis début septembre, le BDE et ses commissions s'attache à supprimer les nuisances sonores aux abords des bâtiments.</p></>)}
         

         {xhtml_partenaire("Rossignol", "http://www.rossignol.com/",
            "http://www.jachete-francais.fr/sites/default/files/rossignol.jpg",
            <>Rossignol est une entreprise de fabrication de matériels de sports d'hiver.</>)}
         

         {xhtml_partenaire("UCPA", "http://www.ucpa-vacances.com/",
            "/skiutc/res/ucpa.jpg",
            <><strong>Donnez du rythme à vos vacances !</strong><br/>
              L'UCPA est aujourd'hui l'un des meilleurs organisateurs de voyages pour tout publics. Leurs offres attractives permettent de partir aussi bien sur un week-end que pour 2 semaines à la découverte de tout types de loisirs et de sports! Ambiance garantie !</>)}
         
</>
    }
    function get_page() {
        {
         ref : "partenaires.html",
         title : "Nos partenaires",
         content : content()
         }
    }
}