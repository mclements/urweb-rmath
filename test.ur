style content

open Rmath

val pi = 3.141592653589793

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
    (* cvas <- Canvasjsffi.makeCanvasjs c; *)
    let
	fun xyplot (lst : list (float * float)) =
	    let
		val x = List.mp (fn pr => pr.1) lst
		val y = List.mp (fn pr => pr.2) lst
	    in
		Canvasjsffi.canvasjsChart c x y
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
	    <button value="Show sin plot" onclick={fn _ => lst <- calc_sin(); cvas <- xyplot lst; return ()}/>
	    <button value="Show cos plot" onclick={fn _ => lst <- calc_cos(); cvas <- xyplot lst; return ()}/>
	    <button value="Show sin plot (server)" onclick={fn _ => lst <- rpc(calc_sin()); cvs <- xyplot lst; return ()}/>
	    <button value="Show dnorm plot (server)" onclick={fn _ => lst <- rpc(calc_dnorm()); cvas <- xyplot lst; return ()}/>
	    <div id={c} style="height: 300px; width: 100%;">
	    </div>
	  </body>
	</xml>
    end
