import stdlib.widgets.datepicker

module MyDateWidget {
    function xhtml edit(path) {
        id = Dom.fresh_id();
        date = Db.read(path);
        function on_edit(date) {
            Db.write(path,
              Date.advance(date,
                Duration.h(Int.of_string(Dom.get_value(#{(id ^ "_heure")})) -
                             2)))
        }
        <>{WDatepicker.edit_default(on_edit, id, date)} 
         <input id={id ^ "_heure"} value={Date.get_hour(date) + 1}/></>
    }
}