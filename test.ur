fun main () = return <xml>
  <head>
    <link href="/style.css" rel="stylesheet" type="text/css"/>
  </head>
  <body>
    <h1>urweb-rmath: an Ur/Web library for the Rmath library</h1>
    <p>This library provides a foreign function interface between Ur/Web and the Rmath library. The Rmath library is a standalone C library that provides some useful mathematical functions for statistics and probability.</p>
    <p>Library requirements on Ubuntu/Debian include <tt>urweb</tt>, <tt>r-mathlib</tt> and <tt>pkg-config</tt>.</p>
    <table>
      <tr>
	<th>Expression</th><th>Value</th>
      </tr>
      <tr>
	<td><tt>Rmath.dnorm 0.0 0.0 1.0 0 </tt></td> <td> {[Rmath.dnorm 0.0 0.0 1.0 0]}</td>
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
      	<td><tt>Rmath.dnorm4 0.0 0.0 1.0 0 </tt></td> <td> {[Rmath.dnorm4 0.0 0.0 1.0 0]}</td>
      </tr>
      <tr>
      	<td><tt>Rmath.pnorm5 1.96 0.0 1.0 0 0 </tt></td> <td> {[Rmath.pnorm5 1.96 0.0 1.0 0 0]}</td>
      </tr>
      <tr>
      	<td><tt>Rmath.qnorm5 0.975 0.0 1.0 1 0 </tt></td> <td> {[Rmath.qnorm5 0.975 0.0 1.0 1 0]}</td>
      </tr>
    </table>
  </body>
</xml>
