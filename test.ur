style content

open Rmath
open Canvas_FFI

val pi = 3.141592653589793

val black = make_rgba 0 0 0 1.0
val white = make_rgba 255 255 255 1.0
val red = make_rgba 255 0 0 1.0
val green = make_rgba 0 255 0 1.0
val blue = make_rgba 0 0 255 1.0
val transparent = make_rgba 0 0 0 0.0

val max_x = 800.0
val max_y = 300.0

fun make_transform n min_val max_val = (fn v => round((n-1.0)*(v - min_val)/(max_val - min_val))+1)

val tr_x = make_transform max_x 0.0 (4.0*pi)
val tr_y = make_transform max_y 1.0 (-1.0) (* reversed bounds *)

(* val calc_f : float -> float -> float -> (float -> float) -> list (float * float) *)
fun calc_f from eps to f =
    let
	fun loop x agg =
	    if x>to then agg else (loop (x+eps) ((x,f x) :: agg))
    in
	loop from []
    end

val calc_f2 = fn f => fn () => return (calc_f 0.0 0.001 (6.0*pi) f)
val calc_dnorm = calc_f2 (fn x => Rmath.dnorm x 3.0 0.5 0)
val calc_sin = calc_f2 sin
val calc_cos = calc_f2 cos

fun main () =
    c <- fresh;
    (* dat <- source ([] : list (float * float)); *)
    let
	fun xyplot (lst : list (float * float)) =
	    ctx <- getContext2d c;
	    setGlobalCompositeOperation ctx DestinationOver;
	    clearRect ctx 0.0 0.0 max_x max_y;
	    setFillStyle ctx (make_rgba 0 0 0 0.4);
	    setStrokeStyle ctx red;
	    save ctx;
	    let
		fun draw lst =
		    let
			fun loop lst = case lst of
					   [] => stroke ctx
					 | (x,fx) :: tl => (lineTo ctx (tr_x x) (tr_y fx); loop tl)
		    in
			beginPath ctx;
			(case lst of
			     (x,fx) :: tl => (moveTo ctx (tr_x x) (tr_y fx); loop tl)
			   | [] => stroke ctx);
			return ()
		    end
	    in
		draw lst
	    end
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
		<table>
		  <tr>
		    <th>Expression</th><th>Value</th>
		  </tr>
		  <tr>
		    <td><tt>Rmath.dnorm 0.0 0.0 1.0 0 </tt></td> <td> {[Rmath.dnorm 0.0 0.0 1.0 0]}</td>
		  </tr>
		  <tr>
      		    <td><tt>Rmath.dnorm4 0.0 0.0 1.0 0 </tt></td> <td> {[Rmath.dnorm4 0.0 0.0 1.0 0]}</td>
		  </tr>
		  <tr>
		    <td><tt>Rmath.pnorm 1.96 0.0 1.0 0 0 </tt></td> <td> {[Rmath.pnorm 1.96 0.0 1.0 0 0]}</td>
		  </tr>
		  <tr>
		    <td><tt>Rmath.qnorm 0.975 0.0 1.0 1 0 </tt></td> <td> {[Rmath.qnorm 0.975 0.0 1.0 1 0]}</td>
		  </tr>
		  <tr>
		    <td><tt>Rmath.m_e </tt></td> <td> {[Rmath.m_e]}</td>
		  </tr>
		  <tr>
		    <td><tt>Rmath.rnorm 0.0 1.0 </tt></td> <td> {[Rmath.rnorm 0.0 1.0]}</td>
		  </tr>
		  <tr>
		    <td><tt>Rmath.rnorm 0.0 1.0 </tt></td> <td> {[Rmath.rnorm 0.0 1.0]}</td>
		  </tr>
		</table>
	    </div>
	    <canvas id={c} height=300 width=800/>
	    <button value="Show sin plot" onclick={fn _ => lst <- calc_sin(); xyplot lst}/>
	    <button value="Show cos plot" onclick={fn _ => lst <- calc_cos(); xyplot lst}/>
	    <button value="Show sin plot (server)" onclick={fn _ => lst <- rpc(calc_sin()); xyplot lst}/>
	    <button value="Show dnorm plot (server)" onclick={fn _ => lst <- rpc(calc_dnorm()); xyplot lst}/>
	  </body>
	</xml>
    end
