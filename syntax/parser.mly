/*
Modeling Kernel Language (MKL) toolchain
Copyright (C) 2010 David Broman

MKL toolchain is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

MKL toolchain is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with MKL toolchain.  If not, see <http://www.gnu.org/licenses/>.
*/

%{ 

  open Ustring.Op
  open Utils
  open Ast
  open Info


  let mktminfo t1 t2 = mkinfo (tm_info t1) (tm_info t2)

  let mkpatinfo t1 t2 = mkinfo (pat_info t1) (pat_info t2)

  let rec metastr n = if n = 0 then us"" else us"#" ^. metastr (n-1) 

  let rec mk_brackets fi n t = 
    if n = 0 then t else TmBracket(fi,mk_brackets fi (n-1) t) 

  let mk_binop fi l op t1 t2 = 
    TmApp(fi,l,TmApp(fi,l,mk_brackets fi l (TmVar(fi,Symtbl.add (us op))),t1),t2)

  let mk_unop fi l op t1 = 
    TmApp(fi,l,mk_brackets fi l (TmVar(fi,Symtbl.add (us op))),t1)

  let mk_binpat_op fi l op t1 t2 = 
    PatModApp(fi,PatModApp(fi,PatExpr(fi,TmVar(fi,Symtbl.add (us op))),t1),t2)

  let mk_unpat_op fi l op t1 = 
    PatModApp(fi,PatExpr(fi,TmVar(fi,Symtbl.add (us op))),t1)

  	  
%}

/* Misc tokens */
%token EOF
%token <int Ast.tokendata> UINT
%token <float Ast.tokendata> UFLOAT
%token <int Ast.tokendata> IDENT
%token <Ast.primitive Ast.tokendata> PRIMITIVE
%token <Ustring.ustring Ast.tokendata> STRING
%token <unit Ast.tokendata> METAAPP

/* Keywords */
%token <unit Ast.tokendata> FUN
%token <unit Ast.tokendata> LET
%token <unit Ast.tokendata> IN
%token <unit Ast.tokendata> IF
%token <unit Ast.tokendata> THEN
%token <unit Ast.tokendata> ELSE
%token <unit Ast.tokendata> TRUE
%token <unit Ast.tokendata> FALSE
%token <unit Ast.tokendata> UP
%token <unit Ast.tokendata> DOWN
%token <unit Ast.tokendata> INT
%token <unit Ast.tokendata> REAL
%token <unit Ast.tokendata> BOOL
%token <unit Ast.tokendata> TYSTRING
%token <unit Ast.tokendata> DPA
%token <unit Ast.tokendata> DPB
%token <unit Ast.tokendata> LCASE
%token <unit Ast.tokendata> OF
%token <unit Ast.tokendata> DECON
%token <unit Ast.tokendata> WITH
%token <unit Ast.tokendata> UK
%token <unit Ast.tokendata> VAL
%token <unit Ast.tokendata> PROJ
%token <unit Ast.tokendata> FST
%token <unit Ast.tokendata> SND
%token <unit Ast.tokendata> IFGUARD
%token <unit Ast.tokendata> IFTHEN
%token <unit Ast.tokendata> IFELSE
%token <unit Ast.tokendata> ERROR
%token <unit Ast.tokendata> MATCH
%token <unit Ast.tokendata> FROM
%token <unit Ast.tokendata> WHEN
%token <unit Ast.tokendata> TYPE
%token <unit Ast.tokendata> ARRAY
%token <unit Ast.tokendata> MAP
%token <unit Ast.tokendata> LIST
%token <unit Ast.tokendata> SET
%token <unit Ast.tokendata> DAESOLVER
%token <unit Ast.tokendata> INCLUDE

/* Operators */
%token <unit Ast.tokendata> EQ            /* "="  */
%token <unit Ast.tokendata> APXEQ         /* "~=" */
%token <unit Ast.tokendata> MOD           /* "mod"*/
%token <unit Ast.tokendata> ADD           /* "+"  */
%token <unit Ast.tokendata> SUB           /* "-"  */
%token <unit Ast.tokendata> MUL           /* "*"  */
%token <unit Ast.tokendata> DIV           /* "/"  */
%token <unit Ast.tokendata> LESS          /* "<"  */
%token <unit Ast.tokendata> LESSEQUAL     /* "<=" */
%token <unit Ast.tokendata> GREAT         /* ">"  */
%token <unit Ast.tokendata> GREATEQUAL    /* ">=" */
%token <unit Ast.tokendata> NOTEQUAL      /* "!=" */
%token <unit Ast.tokendata> DOTADD        /* "+." */
%token <unit Ast.tokendata> DOTSUB        /* "-." */
%token <unit Ast.tokendata> DOTMUL        /* "*." */
%token <unit Ast.tokendata> DOTDIV        /* "/." */
%token <unit Ast.tokendata> DOTLESS       /* "<." */
%token <unit Ast.tokendata> DOTLESSEQUAL  /* "<=."*/
%token <unit Ast.tokendata> DOTGREAT      /* ">." */
%token <unit Ast.tokendata> DOTGREATEQUAL /* ">=."*/
%token <unit Ast.tokendata> DOTNOTEQUAL   /* "!=."*/
%token <unit Ast.tokendata> NOT           /* "!"  */
%token <unit Ast.tokendata> AND           /* "&&" */
%token <unit Ast.tokendata> OR            /* "||" */
%token <unit Ast.tokendata> SEMI          /* ";"  */
%token <unit Ast.tokendata> PLUSPLUS      /* "++"  */
%token <unit Ast.tokendata> EXP           /* "^"  */
%token <unit Ast.tokendata> DOTEXP        /* "^."  */

/* Symbolic Tokens */
%token <unit Ast.tokendata> LPAREN        /* "("  */
%token <unit Ast.tokendata> RPAREN        /* ")"  */
%token <unit Ast.tokendata> LSQUARE       /* "["  */
%token <unit Ast.tokendata> RSQUARE       /* "]"  */
%token <unit Ast.tokendata> LCURLY        /* "{"  */
%token <unit Ast.tokendata> RCURLY        /* "}"  */
%token <unit Ast.tokendata> CONS          /* "::" */
%token <unit Ast.tokendata> COLON         /* ":"  */
%token <unit Ast.tokendata> COMMA         /* ","  */
%token <unit Ast.tokendata> DOT           /* "."  */
%token <unit Ast.tokendata> BAR           /* "|"  */
%token <unit Ast.tokendata> ARROW         /* "->" */
%token <unit Ast.tokendata> DARROW        /* "=>" */
%token <unit Ast.tokendata> ESCAPE        /* "~"  */
%token <unit Ast.tokendata> EQUAL         /* "==" */
%token <unit Ast.tokendata> USCORE        /* "_"  */
%token <unit Ast.tokendata> ESCAPE        /* "~"  */
%token <unit Ast.tokendata> SQUOTE        /* "'"  */

%start main tokens
%type <Ast.top list> main
%type <Ustring.ustring list> tokens


%nonassoc WITH
%nonassoc BAR
%nonassoc LETUK
%left SEMI
%left OR
%left AND 
%nonassoc NOT
%left EQ APXEQ PLUSPLUS
%left LESS LESSEQUAL GREAT GREATEQUAL EQUAL NOTEQUAL
%left DOTLESS DOTLESSEQUAL DOTGREAT DOTGREATEQUAL DOTEQUAL DOTNOTEQUAL
%left ADD SUB DOTADD DOTSUB
%left MUL DIV DOTMUL DOTDIV
%left MOD
%left EXP DOTEXP
%nonassoc UNARYMINUS
%left SQUOTE 

%%


main:
  | top 
      { $1 }

top:
  | EOF
      { [] }
  | LET letpat paramlist EQ term top
      { let fi = mkinfo $1.i (tm_info $5) in
        let (plst,endty) = $3 in
        TopLet(fi,$2,endty,List.rev plst,$5,freein_tm $2 $5)::$6 }
  | LET letpat EQ term top
      { let fi = mkinfo $1.i (tm_info $4) in
        TopLet(fi,$2,None,[],$4,freein_tm $2 $4)::$5 }
  | LET letpat COLON ty EQ term top 
      { let fi = mkinfo $1.i (tm_info $6) in
        TopLet(fi,$2,Some $4,[],$6,freein_tm $2 $6)::$7 }
  | LET letpat COLON ty top %prec LETUK
      { let fi = mkinfo $1.i (ty_info $4) in
        TopNu(fi,$2,$4)::$5 }
  | TYPE IDENT top
      { let fi = mkinfo $1.i $2.i in
        TopNewType(fi,$2.v)::$3 }
  | TYPE IDENT EQ ty top
      { let fi = mkinfo $1.i (ty_info $4) in
        TopNameType(fi,$2.v,$4)::$5 }
  | INCLUDE IDENT top
      { let fi = mkinfo $1.i $2.i in
        let modname = $2.v |> Symtbl.get |> Ustring.to_latin1 
                      |> String.lowercase |> us in                             
        TopInclude(fi,Symtbl.add (modname ^. us".mkl"))::$3 }

ty:
  | tyarrow
      { $1 }
  | tyarrow DARROW ty
      { let fi = mkinfo (ty_info $1) (ty_info $3) in
	TyMap(fi,$2.l,$1,$3) }

tyarrow:
  | tyatom
      { $1 }
  | tyatom ARROW tyarrow
      { let fi = mkinfo (ty_info $1) (ty_info $3) in
	TyArrow(fi,$2.l,$1,$3) }
    
tyatom:
  | IDENT
      { TyIdent($1.i,$1.l,$1.v) }
  | INT 
      { TyInt($1.i,$1.l) }
  | REAL 
      { TyReal($1.i,$1.l) }
  | BOOL 
      { TyBool($1.i,$1.l) }
  | TYSTRING
      { TyString($1.i,$1.l) }
  | LPAREN RPAREN 
      { TyUnit(mkinfo $1.i $2.i,$1.l) } 
  | LSQUARE ty RSQUARE
      { TyList(mkinfo $1.i $3.i,$1.l,$2) }
  | LIST tyatom
      { TyList(mkinfo $1.i (ty_info $2),$1.l,$2) }      
  | LCURLY ty RCURLY
      { TyArray(mkinfo $1.i $3.i,$1.l,$2) }
  | ARRAY tyatom
      { TyArray(mkinfo $1.i (ty_info $2),$1.l,$2) }
  | LPAREN revtypetupleseq RPAREN
      { let fi = mkinfo $1.i $3.i in
        match $2 with
	  | [ty] -> Typesystem.ty_lev_up $1.l ty
	  | tys ->  TyTuple(fi,$1.l,List.rev tys) }
  | LESS GREAT
      { TyAnyModel(mkinfo $1.i $2.i,$1.l) }
  | LESS ty GREAT
      { TyModel(mkinfo $1.i $3.i,$1.l,$2) }
  | MAP tyatom tyatom 
      { TyMap(mkinfo $1.i (ty_info $3),$1.l,$2,$3) }
  | SET tyatom  
      { TySet(mkinfo $1.i (ty_info $2),$1.l,$2) }
  | DAESOLVER 
      { TyDAESolver($1.i,$1.l) }

revtypetupleseq: 
    |   ty
        {[$1]}               
    |   revtypetupleseq COMMA ty
        {$3::$1}

deconpat:
  | UK COLON ty
      { let fi = mkinfo $1.i (ty_info $3) in
        MPatUk(fi,$3) }
  | IDENT IDENT
      { MPatModApp(mkinfo $1.i $2.i,$1.v,$2.v) }
  | IDENT EQUAL IDENT
      { MPatModEqual(mkinfo $1.i $3.i,$1.v,$3.v) }
  | IFGUARD IDENT 
      { MPatModIfGuard(mkinfo $1.i $2.i,$2.v) }
  | IFTHEN IDENT 
      { MPatModIfThen(mkinfo $1.i $2.i,$2.v) }
  | IFELSE IDENT 
      { MPatModIfElse(mkinfo $1.i $2.i,$2.v) }
  | PROJ IDENT FROM IDENT
      { MPatModProj(mkinfo $1.i $4.i,$2.v,$4.v) }
  | VAL IDENT COLON ty
      { let fi = mkinfo $1.i (ty_info $4) in
        MPatVal(fi,$2.v,$4) }

letpat:
  | IDENT
      { $1.v }
  | USCORE
      { Symtbl.add (us"@@wildcard") }



term:
  | cons
      { $1 }
  | FUN IDENT COLON tyatom ARROW term
      { let fi = mkinfo $1.i (tm_info $6) in
        TmLam(fi,$1.l,$2.v,$4,$6) }
  | LET letpat paramlist EQ term IN term
      { let fi = mkinfo $1.i (tm_info $7) in
        let (plst,endty) = $3 in
        TmLet(fi,$1.l,$2,endty,List.rev plst,$5,$7,freein_tm $2 $5) }
  | LET pat_atom EQ term IN term
      { let fi = mkinfo $1.i (tm_info $6) in
        TmMatch(fi,$1.l,$4,[PCase(fi,[$2],None,[],$6)]) }
  | LET letpat COLON ty EQ term IN term
      { let fi = mkinfo $1.i (tm_info $8) in
        TmLet(fi,$1.l,$2,Some $4,[],$6,$8,freein_tm $2 $6) }
  | IF term THEN term ELSE term
      { let fi = mkinfo $1.i (tm_info $6) in
        TmIf(fi,$1.l,$2,$4,$6) }
  | UP term
      { let fi = mkinfo $1.i (tm_info $2) in
        TmUp(fi,$1.l,$2) }
  | DOWN term
      { let fi = mkinfo $1.i (tm_info $2) in
        TmDown(fi,$1.l,$2) }
  | LET letpat COLON ty IN term
      { let fi = mkinfo $1.i (tm_info $6) in
        TmNu(fi,$1.l,$2,$4,$6) }
  | LCASE term OF BAR IDENT CONS IDENT ARROW term BAR LSQUARE RSQUARE ARROW term
      { let fi = mkinfo $1.i (tm_info $14) in
        TmLcase(fi,$1.l,$2,$5.v,$7.v,$9,$14) }  
  | DECON term WITH deconpat THEN term ELSE term
      { let fi = mkinfo $1.i (tm_info $8) in
	TmDecon(fi,$1.l,$2,$4,$6,$8) }
  | PROJ UINT FROM term
      { let fi = mkinfo $1.i (tm_info $4) in
        TmProj(fi,$1.l,$2.v,$4) }
  | MATCH term WITH matchcases
     { let fi = mkinfo $1.i $3.i in
       TmMatch(fi,$1.l,$2,List.rev $4) }
  | ARRAY DOT IDENT atom_list_rev
     { let fi = mkinfo $1.i (tm_info (List.hd $4)) in
       let op = mk_arrayop $3.i $3.v in
       TmArrayOp(fi,$1.l,op,List.rev $4) } 
  | MAP DOT IDENT op_atom_list_rev
     { let fi = if $4 = [] then mkinfo $1.i $3.i 
                else mkinfo $1.i (tm_info (List.hd $4)) in
       let op = mk_mapop $3.i $3.v in
       TmMapOp(fi,$1.l,op,List.rev $4) } 
  | SET DOT IDENT op_atom_list_rev
     { let fi = if $4 = [] then mkinfo $1.i $3.i 
                else mkinfo $1.i (tm_info (List.hd $4)) in
       let op = mk_setop $3.i $3.v in
       TmSetOp(fi,$1.l,op,List.rev $4) } 
  | DAESOLVER DOT IDENT op_atom_list_rev
     { let fi = if $4 = [] then mkinfo $1.i $3.i 
                else mkinfo $1.i (tm_info (List.hd $4)) in
       let op = mk_daesolverop $3.i $3.v in
       TmDAESolverOp(fi,$1.l,op,List.rev $4) } 
       
op_atom_list_rev:
     { [] }
  | atom_list_rev
     { $1 }

atom_list_rev:
  | atom
      { [$1] }
  | atom_list_rev atom
      { $2::$1 }


  
matchcases:
  | BAR pattern op_guard ARROW term
      { let fi = mkinfo $1.i (tm_info $5) in
	[PCase(fi,[$2],$3,[],$5)] }
  | matchcases BAR pattern op_guard ARROW term
      { let fi = mkinfo $2.i (tm_info $6) in
	(PCase(fi,[$3],$4,[],$6))::$1 }

op_guard:
      { None }
  | WHEN term
      { Some $2 }

pattern:
  | pat_cons
      { $1 }
  | PROJ pattern FROM pattern
      { let fi = mkinfo $1.i (pat_info $4) in
        PatModProj(fi,$2,$4) }
  | IF pattern THEN pattern ELSE pattern
      { let fi = mkinfo $1.i (pat_info $6) in
        PatModIf(fi,$2,$4,$6) }

pat_cons:
  | pat_op
      { $1 }
  | pat_op CONS pat_cons 
      { let fi = mkinfo (pat_info $1) (pat_info $3) in
	PatCons(fi,$1,$3) }      


pat_op:
  | pat_left
      { $1 }
  | pat_op EQ pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(=)" $1 $3 }
  | pat_op APXEQ pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(~=)" $1 $3 }
  | pat_op MOD pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(mod)" $1 $3 }
  | pat_op ADD pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(+)" $1 $3 }
  | pat_op SUB pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(-)" $1 $3 }
  | pat_op MUL pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(*)" $1 $3 }
  | pat_op DIV pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(/)" $1 $3 }
  | pat_op LESS pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(<)" $1 $3 }
  | pat_op LESSEQUAL pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(<=)" $1 $3 }
  | pat_op GREAT pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(>)" $1 $3 }
  | pat_op GREATEQUAL pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(>=)" $1 $3 }
  | pat_op NOTEQUAL pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(!=)" $1 $3 }
  | pat_op DOTADD pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(+.)" $1 $3 }
  | pat_op DOTSUB pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(-.)" $1 $3 }
  | pat_op DOTMUL pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(*.)" $1 $3 }
  | pat_op DOTDIV pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(/.)" $1 $3 }
  | pat_op DOTLESS pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(<.)" $1 $3 }
  | pat_op DOTLESSEQUAL pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(<=.)" $1 $3 }
  | pat_op DOTGREAT pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(>.)" $1 $3 }
  | pat_op DOTGREATEQUAL pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(>=.)" $1 $3 }
  | pat_op DOTNOTEQUAL pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(!=.)" $1 $3 }
  | NOT pat_op
      { mk_unpat_op (mkinfo $1.i (pat_info $2)) $1.l "(!)" $2 }
  | pat_op AND pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(&&)" $1 $3 }
  | pat_op OR pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(||)" $1 $3 }
  | pat_op SEMI pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(;)" $1 $3 }
  | pat_op PLUSPLUS pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(++)" $1 $3 }
  | pat_op EXP pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(^)" $1 $3 }
  | pat_op DOTEXP pat_op
      { mk_binpat_op (mkpatinfo $1 $3) $2.l "(^.)" $1 $3 }

  | pat_op SQUOTE
      { mk_unpat_op (mkinfo (pat_info $1) $2.i) $2.l "(')" $1 }
  | SUB pat_op %prec UNARYMINUS
      { mk_unpat_op (mkinfo $1.i (pat_info $2)) $1.l "(--)" $2 }
  | DOTSUB pat_op %prec UNARYMINUS
      { mk_unpat_op (mkinfo $1.i (pat_info $2)) $1.l "(--.)" $2 }

  | pat_op EQUAL pat_op
      { let fi = mkinfo (pat_info $1) (pat_info $3) in
	PatModEqual(fi,$1,$3) }


pat_left:
  | pat_atom
      { $1 }
  | pat_left pat_atom
      { let fi = mkinfo (pat_info $1) (pat_info $2) in
	PatModApp(fi,$1,$2) }
  | FST pat_atom
      { let fi = mkinfo $1.i (pat_info $2) in
        PatModProj(fi,PatExpr(fi,TmConst(fi,$1.l,ConstInt(0))),$2) }
  | SND pat_atom
      { let fi = mkinfo $1.i (pat_info $2) in
        PatModProj(fi,PatExpr(fi,TmConst(fi,$1.l,ConstInt(1))),$2) }
  | VAL IDENT COLON tyatom
      { let fi = mkinfo $1.i (ty_info $4) in
        PatModVal(fi,$2.v,$4) } 

pat_atom:
  | IDENT
      { PatVar($1.i,$1.v) }
  | TRUE 
      { PatExpr($1.i,TmConst($1.i,$1.l,ConstBool(true))) }
  | FALSE 
      { PatExpr($1.i,TmConst($1.i,$1.l,ConstBool(false))) }
  | UINT
      { PatExpr($1.i,TmConst($1.i,$1.l,ConstInt($1.v))) }
  | UFLOAT
      { PatExpr($1.i,TmConst($1.i,$1.l,ConstReal($1.v))) }
  | STRING
      { PatExpr($1.i,TmConst($1.i,$1.l,ConstString($1.v))) }
  | LPAREN RPAREN 
      { PatExpr(mkinfo $1.i $2.i,TmConst($1.i,$1.l,ConstUnit)) } 
  | ESCAPE atom
      { PatExpr(mkinfo $1.i (tm_info $2),$2) }
  | LSQUARE RSQUARE
      { let fi = mkinfo $1.i $2.i in
	PatNil(fi) }     
  | LSQUARE revpatseq RSQUARE
      { let fi = mkinfo $1.i $3.i in
        List.fold_right (fun p a -> PatCons(fi,p,a)) 
          (List.rev $2) (PatNil(fi)) } 
  | UK COLON tyatom 
      { PatUk(mkinfo $1.i (ty_info $3),$3) } 
  | LPAREN revpatseq RPAREN
      { let fi = mkinfo $1.i $3.i in
        match $2 with
	  | [] -> assert false
	  | [p] -> p
	  | ps -> PatTuple(fi,List.rev ps) }
  | USCORE
      { PatWildcard($1.i) }
   

revpatseq: 
    |   pattern
        {[$1]}               
    |   revpatseq COMMA pattern
        {$3::$1}

paramlist:
  | param
      { ([$1],None) }
  | paramlist ARROW param
      { let (lst,_) = $1 in
        ($3::lst,None) }
  | paramlist ARROW tyatom
      { let (lst,_) = $1 in
        (lst,Some $3) }

param: 
  |  IDENT COLON tyatom
      { ($1.v,$3) }

cons:
  | op
      { $1 }
  | op CONS cons 
      { TmCons(mktminfo $1 $3,$2.l,$1,$3) }      


     
op:
  | app_left
      { $1 }
  | op EQ op
      { mk_binop (mktminfo $1 $3) $2.l "(=)" $1 $3 }
  | op APXEQ op
      { mk_binop (mktminfo $1 $3) $2.l "(~=)" $1 $3 }
  | op MOD op
      { mk_binop (mktminfo $1 $3) $2.l "(mod)" $1 $3 }
  | op ADD op
      { mk_binop (mktminfo $1 $3) $2.l "(+)" $1 $3 }
  | op SUB op
      { mk_binop (mktminfo $1 $3) $2.l "(-)" $1 $3 }
  | op MUL op
      { mk_binop (mktminfo $1 $3) $2.l "(*)" $1 $3 }
  | op DIV op
      { mk_binop (mktminfo $1 $3) $2.l "(/)" $1 $3 }
  | op LESS op
      { mk_binop (mktminfo $1 $3) $2.l "(<)" $1 $3 }
  | op LESSEQUAL op
      { mk_binop (mktminfo $1 $3) $2.l "(<=)" $1 $3 }
  | op GREAT op
      { mk_binop (mktminfo $1 $3) $2.l "(>)" $1 $3 }
  | op GREATEQUAL op
      { mk_binop (mktminfo $1 $3) $2.l "(>=)" $1 $3 }
  | op NOTEQUAL op
      { mk_binop (mktminfo $1 $3) $2.l "(!=)" $1 $3 }
  | op DOTADD op
      { mk_binop (mktminfo $1 $3) $2.l "(+.)" $1 $3 }
  | op DOTSUB op
      { mk_binop (mktminfo $1 $3) $2.l "(-.)" $1 $3 }
  | op DOTMUL op
      { mk_binop (mktminfo $1 $3) $2.l "(*.)" $1 $3 }
  | op DOTDIV op
      { mk_binop (mktminfo $1 $3) $2.l "(/.)" $1 $3 }
  | op DOTLESS op
      { mk_binop (mktminfo $1 $3) $2.l "(<.)" $1 $3 }
  | op DOTLESSEQUAL op
      { mk_binop (mktminfo $1 $3) $2.l "(<=.)" $1 $3 }
  | op DOTGREAT op
      { mk_binop (mktminfo $1 $3) $2.l "(>.)" $1 $3 }
  | op DOTGREATEQUAL op
      { mk_binop (mktminfo $1 $3) $2.l "(>=.)" $1 $3 }
  | op DOTNOTEQUAL op
      { mk_binop (mktminfo $1 $3) $2.l "(!=.)" $1 $3 }
  | NOT op
      { mk_unop (mkinfo $1.i (tm_info $2)) $1.l "(!)" $2 }
  | op AND op
      { mk_binop (mktminfo $1 $3) $2.l "(&&)" $1 $3 }
  | op OR op
      { mk_binop (mktminfo $1 $3) $2.l "(||)" $1 $3 }
  | op SEMI op
      { mk_binop (mktminfo $1 $3) $2.l "(;)" $1 $3 }
  | op PLUSPLUS op
      { mk_binop (mktminfo $1 $3) $2.l "(++)" $1 $3 }
  | op EXP op
      { mk_binop (mktminfo $1 $3) $2.l "(^)" $1 $3 }
  | op DOTEXP op
      { mk_binop (mktminfo $1 $3) $2.l "(^.)" $1 $3 }

  | op SQUOTE 
      { mk_unop (mkinfo (tm_info $1) $2.i) $2.l "(')" $1 }
  | SUB op %prec UNARYMINUS
      { mk_unop (mkinfo $1.i (tm_info $2)) $1.l "(--)" $2 }
  | DOTSUB op %prec UNARYMINUS
      { mk_unop (mkinfo $1.i (tm_info $2)) $1.l "(--.)" $2 }

  | op EQUAL op
      { let fi = mktminfo $1 $3 in
        TmEqual(fi,$2.l,$1,$3) }

app_left:
  | atom
      { $1 }
  | app_left app_right
      { let (l,t) = $2 in
        TmApp(mktminfo $1 t,l,$1,t) }
  | DPA atom
      { TmDpa($2) }
  | DPB atom
      { TmDpb($2) }
  | FST atom
      { let fi = mkinfo $1.i (tm_info $2) in
        TmProj(fi,$1.l,0,$2) }
  | SND atom
      { let fi = mkinfo $1.i (tm_info $2) in
        TmProj(fi,$1.l,1,$2) }
  | VAL atom
      { let fi = mkinfo $1.i (tm_info $2) in
        TmVal(fi,$1.l,$2,TyUnit(NoInfo,$1.l)) } 
  | ERROR atom
      { let fi = mkinfo $1.i (tm_info $2) in
        TmError(fi,$1.l,$2) }   
 

app_right:
  | atom
      { (0,$1) }
  | METAAPP atom
      { ($1.l,$2) }

atom:
  | IDENT
      { if $1.l = 0 then TmVar($1.i,$1.v)
        else mk_brackets $1.i $1.l (TmVar($1.i,$1.v)) }
  | TRUE 
      { TmConst($1.i,$1.l,ConstBool(true)) }
  | FALSE 
      { TmConst($1.i,$1.l,ConstBool(false)) }
  | UINT
      { TmConst($1.i,$1.l,ConstInt($1.v)) }
  | UFLOAT
      { TmConst($1.i,$1.l,ConstReal($1.v)) }
  | STRING
      { TmConst($1.i,$1.l,ConstString($1.v)) }
  | PRIMITIVE
      { TmConst($1.i,$1.l,ConstPrim($1.v,[])) }
  | LSQUARE RSQUARE
      { let fi = mkinfo $1.i $2.i in
	TmNil(fi,$1.l,TyBot(fi,$1.l)) }     
  | LSQUARE revtmseq RSQUARE
      { let fi = mkinfo $1.i $3.i in
        TmList(fi,$1.l,$2) }
  | LCURLY revtmseq RCURLY
      { let fi = mkinfo $1.i $3.i in
        TmArray(fi,$1.l,Array.of_list $2) }
  | LPAREN RPAREN 
      { TmConst(mkinfo $1.i $2.i,$1.l,ConstUnit) } 
  | LPAREN revtmseq RPAREN
      { let fi = mkinfo $1.i $3.i in
        match $2 with
	  | [] -> TmConst(fi,$1.l,ConstUnit)
	  | [t] -> if $1.l = 0 then t else mk_brackets fi $1.l t
	  | ts ->  TmTuple(fi,$1.l,List.rev ts) } 
  | ESCAPE atom
      { TmEscape(mkinfo $1.i (tm_info $2),$2) }


revtmseq: 
    |   term
        {[$1]}               
    |   revtmseq COMMA term
        {$3::$1}



      



 




/* ----------- Parsing of tokens - for lexical testing --------- */ 

tokens:
  | toks EOF
      { List.rev $1 }

toks: 
  | tok 
      { [$1] }
  | toks tok
      { $2::$1 } 

tok:
  | UINT { us"uint: " ^. metastr $1.l ^. ustring_of_int $1.v }
  | UFLOAT { us"ufloat: " ^. metastr $1.l ^. ustring_of_float $1.v }
  | IDENT { us"identifier: " ^. Symtbl.get $1.v ^. 
		us" (" ^. ustring_of_int $1.v ^. us")" }
  | STRING { us"string: \"" ^. $1.v ^. us"\"" }
  | METAAPP { us"metaapp: " ^. metastr $1.l }
  | FUN { us"keyword: " ^. metastr $1.l ^. us"fun" }
  | LET { us"keyword: " ^. metastr $1.l ^. us"let" }
  | IN { us"keyword: " ^. metastr $1.l ^. us"in" }
  | IF { us"keyword: " ^. metastr $1.l ^. us"if" }
  | THEN { us"keyword: " ^. metastr $1.l ^. us"then" }
  | ELSE { us"keyword: " ^. metastr $1.l ^. us"else" }
  | MOD { us"keyword: " ^. metastr $1.l ^. us"mod" }
  | TRUE { us"keyword: " ^. metastr $1.l ^. us"true" }
  | FALSE { us"keyword: " ^. metastr $1.l ^. us"false" }
  | EQ { us"symtoken: \"" ^. metastr $1.l ^. us"=\"" }
  | LPAREN { us"symtoken: \"" ^. metastr $1.l ^. us"(\"" }
  | RPAREN { us"symtoken: \"" ^. metastr $1.l ^. us")\"" }
  | LSQUARE { us"symtoken: \"" ^. metastr $1.l ^. us"[\"" }
  | RSQUARE { us"symtoken: \"" ^. metastr $1.l ^. us"]\"" }
  | LCURLY { us"symtoken: \"" ^. metastr $1.l ^. us"{\"" }
  | RCURLY { us"symtoken: \"" ^. metastr $1.l ^. us"}\"" }
  | COLON { us"symtoken: \"" ^. metastr $1.l ^. us":\"" }
  | COMMA { us"symtoken: \"" ^. metastr $1.l ^. us",\"" }
  | DOT { us"symtoken: \"" ^. metastr $1.l ^. us".\"" }
  | ADD { us"symtoken: \"" ^. metastr $1.l ^. us"+\"" }
  | SUB { us"symtoken: \"" ^. metastr $1.l ^. us"-\"" }
  | MUL { us"symtoken: \"" ^. metastr $1.l ^. us"*\"" }
  | DIV { us"symtoken: \"" ^. metastr $1.l ^. us"/\"" }
  | LESS { us"symtoken: \"" ^. metastr $1.l ^. us"<\"" }
  | LESSEQUAL { us"symtoken: \"" ^. metastr $1.l ^. us"<=\"" }
  | GREAT { us"symtoken: \"" ^. metastr $1.l ^. us">\"" }
  | GREATEQUAL { us"symtoken: \"" ^. metastr $1.l ^. us">=\"" }
  | EQUAL { us"symtoken: \"" ^. metastr $1.l ^. us"==\"" }
  | NOTEQUAL { us"symtoken: \"" ^. metastr $1.l ^. us"!=\"" } 
  | DOTADD { us"symtoken: \"" ^. metastr $1.l ^. us"+.\"" }
  | DOTSUB { us"symtoken: \"" ^. metastr $1.l ^. us"-.\"" }
  | DOTMUL { us"symtoken: \"" ^. metastr $1.l ^. us"*.\"" }
  | DOTDIV { us"symtoken: \"" ^. metastr $1.l ^. us"/.\"" }
  | DOTLESS { us"symtoken: \"" ^. metastr $1.l ^. us"<.\"" }
  | DOTLESSEQUAL { us"symtoken: \"" ^. metastr $1.l ^. us"<=.\"" }
  | DOTGREAT { us"symtoken: \"" ^. metastr $1.l ^. us">.\"" }
  | DOTGREATEQUAL { us"symtoken: \"" ^. metastr $1.l ^. us">=.\"" }
  | DOTNOTEQUAL { us"symtoken: \"" ^. metastr $1.l ^. us"!=.\"" } 
  | NOT { us"symtoken: \"" ^. metastr $1.l ^. us"!\"" } 
  | AND { us"symtoken: \"" ^. metastr $1.l ^. us"&&\"" } 
  | OR { us"symtoken: \"" ^. metastr $1.l ^. us"||\"" } 
  | ARROW { us"symtoken: \"" ^. metastr $1.l ^. us"->\"" } 








      
