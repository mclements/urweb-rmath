style content

open Rmath
open Chartjsffi

val pi = 3.141592653589793

(* val calc_f : float -> float -> float -> (float -> float) -> list {X: float, Y: float} *)
fun calc_f from eps to f =
    let
	fun loop x agg =
	    if x>to then agg else (loop (x+eps) ({X=x, Y=(f x)} :: agg))
    in
	loop from []
    end

val calc_f2 = fn f => fn () => return (calc_f 0.0 0.1 (6.0*pi) f)
fun calc_dnorm mu sigma = return(calc_f 0.0 0.1 5.0 (fn x => dnorm x mu sigma 0))
val calc_sin = calc_f2 sin
val calc_cos = calc_f2 cos

fun dn [a] (_ : show a) (x : source a) : xbody = <xml>
  <dyn signal={v <- signal x; return (txt v)}></dyn>
</xml>
						 
fun expand [original ::: {Type}] [additional ::: {Type}] [original ~ additional]
           (fl : folder additional) (r : $original)
    : $(original ++ map option additional) =
    r ++ @map0 [option] (fn [t ::_] => None) fl

(* fun allNone [tr :: {Type}]  *)
(*            (fl : folder tr)  *)
(*     : $tr = *)
(*     @map0 [ident] (fn [t ::_] => None) fl *)

fun update
        [keep] [change] [keep ~ change]
        (xs : $(keep ++ change)) (ys : $change)
    : $(keep ++ change) =
    xs --- change ++ ys
    
(* fun update2 *)
(*         [keep] [change] [keep ~ change] (fl : folder change) *)
(*         (xs : $(keep ++ change)) (ys : $change) *)
(*     : $(keep ++ change) = *)
(*     @foldR [ident] [fn change => $(keep ++ change)] *)
(*     (fn [nm ::_] [v ::_] [r ::_] [[nm] ~ r] v vs => *)
(* 	(vs -- nm) ++ {nm = v}) *)
(*     xs fl ys *)

con optionify = map option

fun optionify [ts ::: {Type}] (fl : folder ts) (r : $ts) : $(optionify ts) =
    @foldR [ident] [fn ts => $(optionify ts)]
     (fn [nm ::_] [v ::_] [r ::_] [[nm] ~ r] v vs =>
             {nm = Some v} ++ vs)
     {} fl r

(* fun defaultSetting *)
(* 	[keep] [change] [keep ~ change] *)
(* 	(args : $change) *)
(*     : $(keep ++ change) = *)
(*     update {A=1, B=2} args *)

(* fun defaultSetting *)
(*         [keep] [change] [keep ~ change] *)
(*         (args : $change) *)
(*     : $(keep ++ change) = *)
(*     ({A=1,B=1} : $(keep ++ change)) --- change ++ args *)

val defaultSetting = update {A=1, B=2}

val _ = defaultSetting {A=2} (* {A=2, B=2} *)
(* val _ = defaultSetting {B=3} (\* {A=1, B=3} *\) *)
	
    
con data = list {X : float, Y : float}
con options = {Legend : option bool,
	       ShowLines : option bool}
con dataset = {Data: option data,
	       Fill : option bool,
	       ShowLine : option bool,
	       Label : option string,
	       BorderColor : option string}
	       
fun makeOptions args : options =
    update ({Legend = None : option bool,
	     ShowLines = None : option bool} : options)
	   (optionify args)

fun makeDataset args =
    update ({Data=None : option data,
	     Fill=None : option bool,
	     ShowLine=None : option bool,
	     Label=None : option string,
	     BorderColor=None : option string} : dataset)
	   (optionify args)
    
(* fun makeDataset [keep] [change] [keep ~ change] (args : $change) : $(keep ++ change) = *)
(*     update ({Data=None : option data, *)
(* 	     Fill=None : option bool, *)
(* 	     ShowLine=None : option bool, *)
(* 	     Label=None : option string, *)
(* 	     BorderColor=None : option string} : $(keep ++ change)) *)
(* 	   args *)

(* fun makeOptions [keep] [change] [keep ~ change] (args : $change) : $(optionify (keep ++ change)) = *)
(*     update {Legend = None : option bool, *)
(* 	     ShowLines = None : option bool}  *)
(* 	   (optionify args) *)

(* fun makeDataset [keep] [change] [keep ~ change] (args : $change) : $(optionify (keep ++ change)) = *)
(*     update ({Data=None : option data, *)
(* 	     Fill=None : option bool, *)
(* 	     ShowLine=None : option bool, *)
(* 	     Label=None : option string, *)
(* 	     BorderColor=None : option string} : $(optionify (keep ++ change))) *)
(* 	   (optionify args) *)

(* fun makeDataset args : dataset = *)
(*     update (allNone dataset) (optionify args) *)

(* fun chartjs *)
(* 	id *)
(* 	args *)
(* 	: transaction chartjschart = *)
(*     chartjsChartStruct id {Typ = args.Typ, *)
(* 			   Options = makeOptions args.Options, *)
(* 			   Data = {Datasets = List.mp makeDataset args.Data.Datasets}} *)
		       
fun main () =
    c <- fresh;
    mu <- source (Some 3.0);
    sigma <- source (Some 1.0);
    let
	fun plot_dnorm () =
	    m <- get mu;
	    s <- get sigma;
	    lst <- rpc(calc_dnorm (Option.get 0.0 m) (Option.get 1.0 s));
	    chart <- chartjsChart c lst;
	    return ()
    in
	return <xml>
	  <head>
	    <title>urweb-rmath: an Ur/Web library for the Rmath library</title>
	    <link href="http://www.pirilampo.org/styles/readtheorg/css/htmlize.css" rel="stylesheet" type="text/css"/>
	    <link href="http://www.pirilampo.org/styles/readtheorg/css/readtheorg.css" rel="stylesheet" type="text/css"/>
	  </head>
	  <body>
	    <div class={content}>
	      <h1>urweb-rmath: an Ur/Web library for the Rmath library</h1>
	      <p>This library provides a foreign function interface
		between <a href="http://www.impredicative.com/ur/">Ur/Web</a>
		and the standalone <a href="https://cran.r-project.org/doc/manuals/r-release/R-admin.html">Rmath</a>
		library. The Rmath library is a standalone C library that
		provides some useful mathematical functions for statistics and
		probability.</p>
		<p>Library requirements on Ubuntu/Debian: <tt>apt install urweb r-mathlib pkg-config</tt></p>
		<button value="Show sin plot"
		onclick={fn _ => lst <- calc_sin();
			    chart <- chartjsChart c lst;
			    return ()}></button>
		<button value="Show cos plot (server)"
		onclick={fn _ => lst <- rpc(calc_cos());
			    chart <- chartjsChart c lst;
			    return ()}></button>
		<button value="Show dnorm plot (server)"
		onclick={fn _ => plot_dnorm()}></button>
		<button value="Show sin+cos plot (server+struct)"
		onclick={fn _ => lst <- rpc(calc_sin()); lst2 <- rpc(calc_cos());
			    chart <- chartjsChartStruct
					 c
					 {Typ="scatter", (* shortened keyword *)
					  Data={Datasets = makeDataset {Data=lst,
					  				 Fill= False,
					  				 BorderColor="red",
					  				 Label="Sine"} ::
					  		makeDataset {Data=lst2,
					  			      Fill=False,
					  			      BorderColor="blue",
					  			      Label="Cosine"} :: []},
					  (* Data={Datasets = makeDataset {Data=Some lst, *)
					  (* 				 Fill=Some False, *)
					  (* 				 BorderColor=Some "red", *)
					  (* 				 Label=Some "Sine"} :: *)
					  (* 		makeDataset {Data=Some lst2, *)
					  (* 			      Fill=Some False, *)
					  (* 			      BorderColor=Some "blue", *)
					  (* 			      Label=Some "Cosine"} :: []}, *)
					  Options = makeOptions {ShowLines = True}};
			    return ()}></button>
		<p></p>
		<crange source={mu} min={0.0} max={5.0} step={0.1}
		onchange={plot_dnorm()}>
		</crange> mu: {dn mu}<br></br>
		<crange source={sigma} min={0.1} max={2.0} step={0.1}
		onchange={plot_dnorm()}>
		</crange> sigma: {dn sigma}<br></br>
		<canvas id={c} width=800 height=300></canvas>
		</div>
		<hr/>
		<table>
		  <tr><th>Expression</th><th>Value</th></tr>
		  <tr><td><tt>Rmath.dnorm 0.0 0.0 1.0 0 </tt></td><td>{[Rmath.dnorm 0.0 0.0 1.0 0]}</td></tr>
		  <tr><td><tt>dnorm4 0.0 0.0 1.0 0 </tt></td><td>{[dnorm4 0.0 0.0 1.0 0]}</td></tr>
		  <tr><td><tt>pnorm 1.96 0.0 1.0 0 0 </tt></td><td>{[pnorm 1.96 0.0 1.0 0 0]}</td></tr>
		  <tr><td><tt>qnorm 0.975 0.0 1.0 1 0 </tt></td><td>{[qnorm 0.975 0.0 1.0 1 0]}</td></tr>
		  <tr><td><tt>m_e </tt></td><td>{[m_e]}</td></tr>
		  <tr><td><tt>rnorm 0.0 1.0 </tt></td><td>{[rnorm 0.0 1.0]}</td></tr>
		  <tr><td><tt>rnorm 0.0 1.0 </tt></td><td>{[rnorm 0.0 1.0]}</td></tr>
		</table>
		</body>
		</xml>
    end
