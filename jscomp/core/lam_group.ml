(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)





(** This is not a recursive type definition *)
type t = 
  | Single of Lambda.let_kind  * Ident.t * Lam.t
  | Recursive of (Ident.t * Lam.t) list
  | Nop of Lam.t 


let pp = Format.fprintf 

let str_of_kind (kind : Lambda.let_kind) = 
  match kind with 
  | Alias -> "a"
  | Strict -> ""
  | StrictOpt -> "o"
  | Variable -> "v" 

let pp_group env fmt ( x : t) =
  match x with
  | Single (kind, id, lam) ->
    Format.fprintf fmt "@[let@ %a@ =%s@ @[<hv>%a@]@ @]" Ident.print id (str_of_kind kind) 
      (Lam_print.env_lambda env) lam
  | Recursive lst -> 
    List.iter (fun (id,lam) -> 
        Format.fprintf fmt
          "@[let %a@ =r@ %a@ @]" Ident.print id (Lam_print.env_lambda env) lam
      ) lst
  | Nop lam -> Lam_print.env_lambda env fmt lam



