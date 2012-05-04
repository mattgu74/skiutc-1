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

let clos_args_1 = CR.args_apply1

let clos_args_2 closure a0 a1 =
match closure.CR.args with
    | [||] -> (Obj.magic closure.CR.func)  a0 a1
    | [|e0|] -> (Obj.magic closure.CR.func) e0 a0 a1
    | [|e0; e1|] -> (Obj.magic closure.CR.func) e0 e1 a0 a1
    | [|e0; e1; e2|] -> (Obj.magic closure.CR.func) e0 e1 e2 a0 a1
    | [|e0; e1; e2; e3|] -> (Obj.magic closure.CR.func) e0 e1 e2 e3 a0 a1
    | [|e0; e1; e2; e3; e4|] -> (Obj.magic closure.CR.func) e0 e1 e2 e3 e4 a0 a1
    | [|e0; e1; e2; e3; e4; e5|] -> (Obj.magic closure.CR.func) e0 e1 e2 e3 e4 e5 a0 a1
    | [|e0; e1; e2; e3; e4; e5; e6|] -> (Obj.magic closure.CR.func) e0 e1 e2 e3 e4 e5 e6 a0 a1
    | [|e0; e1; e2; e3; e4; e5; e6; e7|] -> (Obj.magic closure.CR.func) e0 e1 e2 e3 e4 e5 e6 e7 a0 a1
    | [|e0; e1; e2; e3; e4; e5; e6; e7; e8|] -> (Obj.magic closure.CR.func) e0 e1 e2 e3 e4 e5 e6 e7 e8 a0 a1
    | _ -> CR.args_apply closure(Obj.magic (a0, a1) : Obj.t array)

let clos_export_0 clos =
  fun () -> clos_args_0 clos
let clos_export_1 clos =
  fun a0 -> clos_args_1 clos a0
let clos_export_2 clos =
  fun a0 a1 -> clos_args_2 clos a0 a1
let clos_env_0 f   =
 CR.env_apply f [||]
let clos_env_1 f x0  =
 CR.env_apply f (Obj.magic {tuple1 = x0} : Obj.t array)
let clos_env_2 f x0 x1  =
 CR.env_apply f (Obj.magic (x0, x1) : Obj.t array)
let clos_env_3 f x0 x1 x2  =
 CR.env_apply f (Obj.magic (x0, x1, x2) : Obj.t array)
let clos_env_4 f x0 x1 x2 x3  =
 CR.env_apply f (Obj.magic (x0, x1, x2, x3) : Obj.t array)
let clos_env_5 f x0 x1 x2 x3 x4  =
 CR.env_apply f (Obj.magic (x0, x1, x2, x3, x4) : Obj.t array)
let clos_env_6 f x0 x1 x2 x3 x4 x5  =
 CR.env_apply f (Obj.magic (x0, x1, x2, x3, x4, x5) : Obj.t array)
let clos_env_7 f x0 x1 x2 x3 x4 x5 x6  =
 CR.env_apply f (Obj.magic (x0, x1, x2, x3, x4, x5, x6) : Obj.t array)
let clos_env_8 f x0 x1 x2 x3 x4 x5 x6 x7  =
 CR.env_apply f (Obj.magic (x0, x1, x2, x3, x4, x5, x6, x7) : Obj.t array)
let clos_env__with_ty1 f x0 ty0 =
 CR.env_apply_with_ty f (Obj.magic {tuple1 = x0} : Obj.t array)(Obj.magic {tuple1 = ty0} : Obj.t array)
let clos_env__with_ty2 f x0 x1 ty0 ty1 =
 CR.env_apply_with_ty f (Obj.magic (x0, x1) : Obj.t array)(Obj.magic (ty0, ty1) : Obj.t array)
let clos_env__with_ty3 f x0 x1 x2 ty0 ty1 ty2 =
 CR.env_apply_with_ty f (Obj.magic (x0, x1, x2) : Obj.t array)(Obj.magic (ty0, ty1, ty2) : Obj.t array)
let clos_env__with_ty4 f x0 x1 x2 x3 ty0 ty1 ty2 ty3 =
 CR.env_apply_with_ty f (Obj.magic (x0, x1, x2, x3) : Obj.t array)(Obj.magic (ty0, ty1, ty2, ty3) : Obj.t array)
let clos_env__with_ty5 f x0 x1 x2 x3 x4 ty0 ty1 ty2 ty3 ty4 =
 CR.env_apply_with_ty f (Obj.magic (x0, x1, x2, x3, x4) : Obj.t array)(Obj.magic (ty0, ty1, ty2, ty3, ty4) : Obj.t array)
let clos_env__with_ty6 f x0 x1 x2 x3 x4 x5 ty0 ty1 ty2 ty3 ty4 ty5 =
 CR.env_apply_with_ty f (Obj.magic (x0, x1, x2, x3, x4, x5) : Obj.t array)(Obj.magic (ty0, ty1, ty2, ty3, ty4, ty5) : Obj.t array)
let clos_env__with_ty7 f x0 x1 x2 x3 x4 x5 x6 ty0 ty1 ty2 ty3 ty4 ty5 ty6 =
 CR.env_apply_with_ty f (Obj.magic (x0, x1, x2, x3, x4, x5, x6) : Obj.t array)(Obj.magic (ty0, ty1, ty2, ty3, ty4, ty5, ty6) : Obj.t array)
let clos_env__with_ty8 f x0 x1 x2 x3 x4 x5 x6 x7 ty0 ty1 ty2 ty3 ty4 ty5 ty6 ty7 =
 CR.env_apply_with_ty f (Obj.magic (x0, x1, x2, x3, x4, x5, x6, x7) : Obj.t array)(Obj.magic (ty0, ty1, ty2, ty3, ty4, ty5, ty6, ty7) : Obj.t array)

(** {6 Converters} *)

let bslp0 ( x0 (* : 'v0 *) ) ( x1 : int ) ( x2 : string ) ( x3 : QmlFlatServerLib.record )  =
  let p3 = QmlFlatServerLib.unwrap_bool x3 in
  let r = OpabslgenMLRuntime.BslClosure.create_and_register ( x0 (* : alpha *) ) x1 x2 p3 in
  r

let bslp5 ( x0 : string ) ( x1 (* : 'v0 *) )  =
  let r = OpabslgenMLRuntime.BslValue.Tsc.add x0 ( x1 (* : alpha *) ) in
  let r2 = QmlFlatServerLib.empty in
  r2

