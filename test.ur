style content

open Json
open Rmath
open Chartjsffi

val pi = 3.141592653589793

(* val calc_f : float -> float -> float -> (float -> float) -> list (float * float) *)
fun calc_f from eps to f =
    let
	fun loop x agg =
	    if x>to then agg else (loop (x+eps) ((x,f x) :: agg))
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
						 
type options = {Legend : bool}
type float_pair = {X : float, Y : float}
type dataset = {Data : list float_pair, Fill : bool, ShowLine : bool}
type chartData = {Datasets : list dataset}
type config = {ChartData : chartData, Options : options}

val json_options : json options = json_record {Legend = "legend"}
val json_float_pair : json float_pair = json_record {X = "x", Y = "y"}
val json_dataset : json dataset = json_record {Data = "data", Fill = "fill", ShowLine = "showLine"}
val json_chartData : json chartData = json_record {Datasets = "datasets"}
val json_config : json config = json_record {ChartData="data", Options = "options"}

fun pairToXY [a ::: Type] [b ::: Type] lst = List.mp (fn (x:a,y:b) => {X=x, Y=y}) lst

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
		<button value="Show cos plot"
		onclick={fn _ => lst <- calc_cos();
			    chart <- chartjsChart c lst;
			    return ()}></button>
		<button value="Show sin plot (server)"
		onclick={fn _ => lst <- rpc(calc_sin());
			    chart <- chartjsChart c lst;
			    return ()}></button>
		<button value="Show dnorm plot (server)"
		onclick={fn _ => plot_dnorm()}></button>
		<button value="Show sin plot (server+JSON)"
		onclick={fn _ => lst <- rpc(calc_sin());
			    chart <- chartjsChartJson c (toJson {ChartData={Datasets={Data=pairToXY lst,
										      Fill=False, ShowLine=True} :: []},
								 Options = {Legend = False}});
			    return ()}></button>
		<button value="Show sin plot (server+struct)"
		onclick={fn _ => lst <- rpc(calc_sin());
			    chart <- chartjsChartStruct c {Data={Datasets={Data=pairToXY lst,
									   Fill=False, ShowLine=True} :: []},
							   Options = {Legend = False}};
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
