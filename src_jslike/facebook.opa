type Facebook.conf =
  {string href, string width, string height, string faces, string border,
   string stream, string header}

module Facebook {
    load = %%facebook_load%%
    function xhtml html(Facebook.conf conf) {
        <><div id="fb-root"/>
        
         <div class="fb-like-box" data-href={conf.href} data-width={conf.width} data-height={conf.height} data-show-faces={conf.faces} data-border-color={conf.border} data-stream={conf.stream} data-header={conf.header}/></>
    }
}