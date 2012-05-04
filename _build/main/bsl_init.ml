(* Translation of bsl in the flat compiler runtime algebra*)
module CR = QmlClosureRuntime
(** {6 cps tools} *)
let return_exc = OpabslgenMLRuntime.BslPervasives.return_exc
let uncps = OpabslgenMLRuntime.BslCps.uncps_ml
let uncps0 s k f = (); fun () -> uncps s k f
let cps f k = QmlCpsServerLib.return k f
let cps0 f k = QmlCpsServerLib.return k (f ())

(** {6 closure tools} *)
type 'a tuple1 = { tuple1 : 'a }
let clos_args_0 closure  =
match closure.CR.args with
    | [||] -> (Obj.magic closure.CR.func) ()
    | [|e0|] -> (Obj.magic closure.CR.func) e0
    | [|e0; e1|] -> (Obj.magic closure.CR.func) e0 e1
    | [|e0; e1; e2|] -> (Obj.magic closure.CR.func) e0 e1 e2
    | [|e0; e1; e2; e3|] -> (Obj.magic closure.CR.func) e0 e1 e2 e3
    | [|e0; e1; e2; e3; e4|] -> (Obj.magic closure.CR.func) e0 e1 e2 e3 e4
    | [|e0; e1; e2; e3; e4; e5|] -> (Obj.magic closure.CR.func) e0 e1 e2 e3 e4 e5
    | [|e0; e1; e2; e3; e4; e5; e6|] -> (Obj.magic closure.CR.func) e0 e1 e2 e3 e4 e5 e6
    | [|e0; e1; e2; e3; e4; e5; e6; e7|] -> (Obj.magic closure.CR.func) e0 e1 e2 e3 e4 e5 e6 e7
    | [|e0; e1; e2; e3; e4; e5; e6; e7; e8|] -> (Obj.magic closure.CR.func) e0 e1 e2 e3 e4 e5 e6 e7 e8
    | _ -> CR.args_apply closure[||]

let clos_export_0 clos =
  fun () -> clos_args_0 clos

(** {6 Converters} *)

let bslp6 ()  =
  let r = OpabslgenMLRuntime.Badop_engine.check_remaining_arguments () in
  let r2 = QmlFlatServerLib.empty in
  r2

let bslp7 ( x0 : string )  =
  let r = OpabslgenMLRuntime.BslInit.set_executable_id x0 in
  let r2 = QmlFlatServerLib.empty in
  r2

let bslp8 ( x0 : QmlFlatServerLib.record )  =
  let p0 = QmlFlatServerLib.unwrap_bool x0 in
  let r = OpabslgenMLRuntime.BslJsIdent.set_cleaning_default_value p0 in
  let r2 = QmlFlatServerLib.empty in
  r2

