divert(`-1')
define(`LOWER',`translit($1, `A-Z', `z-a')')
define(`DIST1FUNCTION',`FUNCTION4($1 cumulative density function,p$2,double,q,double,$3,int,lower,int,log)
FUNCTION4($1 quantile function,q$2,double,p,double,$3,int,lower,int,log)
FUNCTION3($1 probability density function,d$2,double,p,double,$3,int,log)
FUNCTION1($1 random numbers,r$2,double,$3)')
define(`DIST2FUNCTION',`FUNCTION5($1 cumulative density function,p$2,double,q,double,$3,double,$4,int,lower,int,log)
FUNCTION5($1 quantile function,q$2,double,p,double,$3,double,$4,int,lower,int,log)
FUNCTION4($1 probability density function,d$2,double,p,double,$3,double,$4,int,log)
FUNCTION2($1 random numbers,r$2,double,$3,double,$4)')
define(`DIST3FUNCTION',`FUNCTION6($1 cumulative density function,p$2,double,q,double,$3,double,$4,double,$5,int,lower,int,log)
FUNCTION6($1 quantile function,q$2,double,p,double,$3,double,$4,double,$5,int,lower,int,log)
FUNCTION5($1 probability density function,d$2,double,p,double,$3,double,$4,double,$5,int,log)
FUNCTION3($1 random numbers,r$2,double,$3,double,$4,double,$5)')
define(`EXTRAFUNS',`val log1pexp = rf_log1pexp
val qnorm = qnorm5
val pnorm = pnorm5
val dnorm = dnorm4
(* additional functions *)
fun poisson_ci(x, conflevel, alternative) =
    let
	val alpha = (1.0-conflevel)/2.0
	fun pL(x,alpha) = if Real.==(x,0.0) then 0.0 else qgamma(alpha,x, 1.0, 1, 0)
	fun pU(x,alpha) = qgamma(1.0-alpha, x+1.0, 1.0, 1, 0)
    in
	case alternative of
	    Less => (0.0, pU(x, 1.0-conflevel))
	  | Greater => (pL(x, 1.0-conflevel), $1)
	  | TwoSided => (pL(x,alpha), pU(x,alpha))
    end
fun id x = x
(* operations on ranges from..to *)
fun seq_list(from,to) =
    let
	fun loop(i,y) = if i>to then y else loop(i+1,i :: y)
    in
	List.rev(loop(from,[]))
    end
(* infix -- *)
(* fun a -- b = seq_list(a,b) *)
fun tabulate f (from,to) = List.tabulate(to-from+1,fn i => f(i+from))
fun for f init (from, to) =
    let
	fun loop(i,y) = if i>to then y else loop(i+1,f(i,y))
    in
	loop(from,init)
    end
fun sum f = for (fn (i, y) => Real.+(f(real(i)),y)) 0.0
fun sum f = for (fn (i, y) => f(i)+y) 0
fun count predicate = for (fn (i, y) => if predicate(i) then y+1 else y) 0
fun poisson_test(x, t, r, alternative) =
    let
	val m = r*t
    in
	case alternative of
	    Less => ppois(x,m,1,0)
	  | Greater => ppois(x-1.0,m,0,0)
	  | TwoSided =>
	    if Real.==(m,0.0) then (if Real.==(x,0.0) then 1.0 else 0.0)
	    else
		let
		    val relErr = 1.0 + 1.0e~7
		    val d = dpois(x,m,0)
		    val dstar = d * relErr
		    fun pred i = dpois(real(i),m,0)<=dstar
		in
		    if Real.==(x,m) then 1.0
		    else if x<m then
			let
			    fun loop n = if dpois(real(n),m,0)>d then loop(n*2) else n
			    val n = loop(Real.ceil(2.0*m-x))
			    val y = count pred (Real.ceil(m), n)
			in
			    ppois(x,m,1,0) + ppois(real(n-y),m,0,0)
			end
		    else (* x>m *)
			let
			    val y = count pred (0,Real.floor(m))
			in
			    ppois(real(y-1),m,1,0) + ppois(x-1.0, m,0,0)
			end
		end
    end
end')
divert(`1')dnl
CONSTANT(e,M_E,2.718281828459045235360287471353)
CONSTANT(log2(e),M_LOG2E,1.442695040888963407359924681002)
CONSTANT(log10(e),M_LOG10E,0.434294481903251827651128918917)
CONSTANT(ln(2),M_LN2,0.693147180559945309417232121458)
CONSTANT(ln(10),M_LN10,2.302585092994045684017991454684)
CONSTANT(pi,M_PI,3.141592653589793238462643383280)
CONSTANT(2*pi,M_2PI,6.283185307179586476925286766559)
CONSTANT(pi/2,M_PI_2,1.570796326794896619231321691640)
CONSTANT(pi/4,M_PI_4,0.785398163397448309615660845820)
CONSTANT(1/pi,M_1_PI,0.318309886183790671537767526745)
CONSTANT(2/pi,M_2_PI,0.636619772367581343075535053490)
CONSTANT(2/sqrt(pi),M_2_SQRTPI,1.128379167095512573896158903122)
CONSTANT(sqrt(2),M_SQRT2,1.414213562373095048801688724210)
CONSTANT(1/sqrt(2),M_SQRT1_2,0.707106781186547524400844362105)
CONSTANT(sqrt(3),M_SQRT_3,1.732050807568877293527446341506)
CONSTANT(sqrt(32),M_SQRT_32,5.656854249492380195206754896838)
CONSTANT(log10(2),M_LOG10_2,0.301029995663981195213738894724)
CONSTANT(sqrt(pi),M_SQRT_PI,1.772453850905516027298167483341)
CONSTANT(1/sqrt(2pi),M_1_SQRT_2PI,0.398942280401432677939946059934)
CONSTANT(sqrt(2/pi),M_SQRT_2dPI,0.797884560802865355879892119869)
CONSTANT(log(2*pi),M_LN_2PI,1.837877066409345483560659472811)
CONSTANT(log(pi)/2,M_LN_SQRT_PI,0.572364942924700087071713675677)
CONSTANT(log(2*pi)/2,M_LN_SQRT_2PI,0.918938533204672741780329736406)
CONSTANT(log(pi/2)/2,M_LN_SQRT_PId2,0.225791352644727432363097614947)
FUNCTION2(R_pow function,R_pow,double,x,double,y)
FUNCTION2(R_pow_di function,R_pow_di,double,x,int,y)
FUNCTION0(Normal random numbers,norm_rand)
FUNCTION0(Uniform random numbers,unif_rand)
FUNCTION0(Exponential random numbers,exp_rand)
dnl FUNCTION2(Set random seed,set_seed,int,a,int,b)
dnl void get_seed(unsigned int *, unsigned int *) // polyml
FUNCTION5(Normal cumulative density function,pnorm5,double,q,double,mean,double,sd,int,lower,int,log)
FUNCTION5(Normal quantile function,qnorm5,double,p,double,mean,double,sd,int,lower,int,log)
FUNCTION4(Normal probability density function,dnorm4,double,p,double,mean,double,sd,int,log)
FUNCTION2(Normal random numbers,rnorm,double,mean,double,sd)
DIST2FUNCTION(Uniform,unif,min,max)
DIST2FUNCTION(Gamma,gamma,shape,scale)
FUNCTION1(Accurate log(1+x) - x (care for small x),log1pmx,double,x)
FUNCTION1(log(1 + exp(x)),Rf_log1pexp,double,x)
FUNCTION1(Accurate log(gamma(x+1)) for small x (0 < x < 0.5),lgamma1p,double,x)
FUNCTION2(log (exp (logx) + exp (logy)),logspace_add,double,logx,double,logy)
FUNCTION2(log (exp (logx) - exp (logy)),logspace_sub,double,logx,double,logy)
dnl double logspace_sum(const double *, int);
DIST2FUNCTION(Beta,beta,shape1,shape2)
DIST2FUNCTION(Log-normal,lnorm,meanlog,sdlog)
DIST1FUNCTION(Chi-squared,chisq,df)
DIST2FUNCTION(Non-central chi-squared,nchisq,df,ncp)
DIST2FUNCTION(F,f,df1,df2)
DIST1FUNCTION(T,t,df)
DIST2FUNCTION(Binomial,binom,size,prob)
dnl void rmultinom(int n, double* prob, int K, int* rN); // polyml
DIST2FUNCTION(Cauchy,cauchy,location,scale)
DIST1FUNCTION(Exponential,exp,rate)
DIST1FUNCTION(Geometric,geom,prob)
DIST3FUNCTION(Hypergeometric,hyper,m,n,k)
DIST2FUNCTION(Negative Binomial,nbinom,size,prob)
DIST1FUNCTION(Poisson,pois,lambda)
DIST2FUNCTION(Weibull,weibull,shape,scale)
DIST2FUNCTION(Logistic,logis,location,scale)
dnl DIST3FUNCTION(nbeta,shape1,shape2,ncp) // see below
FUNCTION6(Non-central beta cumulative distribution function,pnbeta,double,q,double,shape1,double,shape2,double,ncp,int,lower,int,log)
FUNCTION6(Non-central beta quantile function,qnbeta,double,p,double,shape1,double,shape2,double,ncp,int,lower,int,log)
FUNCTION5(Non-central beta probability density function,dnbeta,double,x,double,shape1,double,shape2,double,ncp,int,log)
dnl FUNCTION3(rnbeta,double,shape1,double,shape2,double,ncp) // not available
dnl DIST3FUNCTION(nf,df1,df2,ncp) // see below
FUNCTION6(Non-central F cumulative distribution function,pnf,double,q,double,df1,double,df2,double,ncp,int,lower,int,log)
FUNCTION6(Non-central F quantile function,qnf,double,p,double,df1,double,df2,double,ncp,int,lower,int,log)
FUNCTION5(Non-central F probability density function,dnf,double,x,double,df1,double,df2,double,ncp,int,log)
dnl DIST2FUNCTION(nt,df,ncp) // see below
FUNCTION5(Non-central Student t cumulative distribution function,pnt,double,q,double,df,double,ncp,int,lower,int,log)
FUNCTION5(Non-central Student t quantile function,qnt,double,p,double,df,double,ncp,int,lower,int,log)
FUNCTION4(Non-central Student t probability density function,dnt,double,x,double,df,double,ncp,int,log)
FUNCTION6(Studentised rangecumulative distribution function,ptukey,double,q,double,nmeans,double,df,double,nranges,int,lower,int,log)
FUNCTION6(Studentised range quantile function,qtukey,double,p,double,nmeans,double,df,double,nranges,int,lower,int,log)
DIST2FUNCTION(Wilcoxon rank sum,wilcox, m, n)
DIST1FUNCTION(Wilcoxon signed rank,signrank,n)
FUNCTION1(gammafn,gammafn,double,x)
FUNCTION1(lgammafn,lgammafn,double,x)
dnl double lgammafn_sign(double, int* ); // polyml
dnl void dpsifn(double, int, int, int, double*, int*, int* ); // not yet implemented
FUNCTION2(psigamma,psigamma,double,x,double,y)
FUNCTION1(digamma,digamma,double,x)
FUNCTION1(trigamma,trigamma,double,x)
FUNCTION1(tetragamma,tetragamma,double,x)
FUNCTION1(pentagamma,pentagamma,double,x)
FUNCTION2(beta,beta,double,x,double,y)
FUNCTION2(lbeta,lbeta,double,x,double,y)
FUNCTION2(choose,choose,double,n,double,k)
FUNCTION2(lchoose,lchoose,double,n,double,k)
FUNCTION3(bessel_i,bessel_i,double,x,double,nu,double,scaled)
FUNCTION2(bessel_j,bessel_j,double,x,double,nu)
FUNCTION3(bessel_k,bessel_k,double,x,double,nu,double,scaled)
FUNCTION2(bessel_y,bessel_y,double,x,double,nu)
dnl double bessel_i_ex(double, double, double, double * ); // see bessel_i
dnl double bessel_j_ex(double, double, double * );         // see bessel_j
dnl double bessel_k_ex(double, double, double, double * ); // see bessel_k
dnl double bessel_y_ex(double, double, double * );         // see bessel_y
dnl double pythag(double x,double y); // not available
dnl int	imax2(int, int); // polyml
dnl int	imin2(int, int); // polyml
FUNCTION2(fmax2,fmax2,double,x,double,y)
FUNCTION2(fmin2,fmin2,double,x,double,y)
FUNCTION1(sign,sign,double,x)
FUNCTION2(fprec,fprec,double,x,double,y)
FUNCTION2(fround,fround,double,x,double,y)
FUNCTION2(fsign,fsign,double,x,double,y)
FUNCTION1(ftrunc,ftrunc,double,x)
FUNCTION1(cospi,cospi,double,x)
FUNCTION1(sinpi,sinpi,double,x)
FUNCTION1(tanpi,tanpi,double,x)
dnl rmath_export double NA_REAL;  // ?
dnl rmath_export double R_PosInf; // ?
dnl rmath_export double R_NegInf; // ?
dnl rmath_export int N01_kind;    // ?
