module Popup {
    function xhtml xhtml(string title, xhtml content) {
        <div class="popup">
<h1>{title}</h1>
<div style={[Css_build.text_align({
                                                            
                                                            right
                                                            }),
                                                           Css_build.margin(
                                                             (option) {
                                                                    some :
                                                                    {em : 0.}
                                                                    },
                                                             (option) {
                                                                    some :
                                                                    {em : 0.}
                                                                    },
                                                             (option) {
                                                                    some :
                                                                    {em : 0.}
                                                                    },
                                                             (option) {
                                                                    some :
                                                                    {em : 0.}
                                                                    }),
                                                           Css_build.margin_right({
                                                             
                                                             px : 20
                                                             }),
                                                           Css_build.padding(
                                                             (option) {
                                                                    some :
                                                                    {em : 0.}
                                                                    },
                                                             (option) {
                                                                    some :
                                                                    {em : 0.}
                                                                    },
                                                             (option) {
                                                                    some :
                                                                    {em : 0.}
                                                                    },
                                                             (option) {
                                                                    some :
                                                                    {em : 0.}
                                                                    })]}><a onclick={
        function(_) {
        Client.reload()
        }}>fermer</a></div>
<br/>
<br/>
{content}
</div>
    }
}