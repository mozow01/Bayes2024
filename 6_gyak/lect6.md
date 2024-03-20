# Feltételes valószínűség és inferálás

## Kártyahúzás visszatevéssel (binomiális eloszlás)

Egy 52 lapos francia kártyapakliban annak a valószínűsége, hogy egy kártya kőr (♥): p = 13/52 = 0.25. Keressük annak az X valószínűségi változónak az eloszlását, ami azt mondja meg, hogy ha _visszatevéssel_ kiveszünk a pakliból 3 lapot, akkor hány ebből a kőr, tehát

X := ,,kőrök száma 3 visszatevéses húzásból, francia kártyapakliban''

````javascript
var model = function() {
  var H1 = flip(0.25);
  var H2 = flip(0.25);
  var H3 = flip(0.25);
  var X = H1 + H2 + H3;
  return {'X': X}
}
var eloszlás = Enumerate(model);

var binom = Binomial({p: 0.25, n: 3});

viz.auto(binom);
viz.auto(eloszlás);
````

````flip(0.25)```` most a categorical egy spéci, spórolós változata. Boole-értéket ad vissza (azaz 0-t vagy 1-et) mégpedig 0.25 arányban az 1 javára. Húzás után visszatesszük a lapokat, így a szituáció hasonlít arra, amikor 3 ember utazik egy liftben és az egyik szellent. Ha az országos átlag szerint annak az egyánya, hogy egy ember a lifben elszellenti magát 0.25, akkor X eloszlása azt fogja megmutatni, hogy mi annak az valószínűsége, hogy pontosan 0, 1, 2, vagy 3 ember csinálja ezt a méltatlan dolgot. X tehát az oszlopok méretével arányos mértékű valószínűságekkel vesznek fel 0 és 3 közötti értékeket. Tusjuk jó, az a binomiális eloszlás és ezért a ````binom```` változó ugyanolyan eloszlású lesz. Lásd még a webppl dokumentációját!

**Érdekesebb** probléma a következő. Ha tudunk valamit a szituációból, ez az eloszlás változni fog. Pl.: mi akkor X eloszlása, **ha tudjuk,** hogy az első esetben kőrt húzunk. 

````javascript

var model2 = function() {
  var H1 = flip(0.25)
  var H2 = flip(0.25)
  var H3 = flip(0.25)
  condition( H1 == 1 )
  var X = H1 + H2 + H3
  return {'X': X}
}
var eloszlás2 = Enumerate(model2)

viz.auto(eloszlás2)
````

Itt ismét ````condition( H1 == 1 )```` játszotta a fő szerepet. Világos, hogy X már nem vehet fel 0 értéket, mert már H1 == 1.

Általában egy _X_ binomiális változó eloszlása:

[![\\ \Pr(X = k) = \binom{n}{k}p^k(1-p)^{n-k}](https://latex.codecogs.com/svg.latex?%5C%5C%20%5CPr(X%20%3D%20k)%20%3D%20%5Cbinom%7Bn%7D%7Bk%7Dp%5Ek(1-p)%5E%7Bn-k%7D)](#_)

Tehát van egy _p_ valószínűségű Boole-változó (Bernoulli változó) és _X_ jelentse azt, hogy ha _n_-szer egy ilyen kísérletet végrehajtunk (egymástól **függetlenül**), akkor ebből hányszor jön ki _igaz_. A magyarázat világos. 

## Házi?

````javascript
var model = function () {
    var C = categorical({ps: [0.4, 0.1, 0.3, 0.2], 
                            vs: ["11", "10", "01", "00"]});
    var AorB = (C=="11" || C=="10" || C=="01") ;
    return  {AorB} 
}

var Z = Infer({method: 'enumerate', model: model})

viz(Z)
````

## A feltételes valószínűség

Ekkor leszűkítjük az elemi események terét a feltételre, a B eseményt teljesítő elemi részeseményekre, azaz innentől nem Ω, hanem B az összes elemi események tere:

[![\\ \Pr(A\mid B)=\frac{\Pr (A\cdot B)}{\Pr B},\quad \Pr B\ne 0  \\ ](https://latex.codecogs.com/svg.latex?%5C%5C%20%5CPr(A%5Cmid%20B)%3D%5Cfrac%7B%5CPr%20(A%5Ccdot%20B)%7D%7B%5CPr%20B%7D%2C%5Cquad%20%5CPr%20B%5Cne%200%20%20%5C%5C%20)](#_)

Itt A és B események, azaz halmazok vagy állítások és nem változók. 

**Szorzatszabály.** A feltételes valószínűség sokszor olyan intuitív, hogy azonnal ennek az értékét tudjuk, sőt, vannak olyan tárgyalások is (Rényi), amelyekben a feltételes valószínűség az alapfogalom. Éppen ezért a definíciót néha így írják:

[![\\ \Pr(A\mid B)\cdot \Pr A= \Pr (A\cdot B) \\ ](https://latex.codecogs.com/svg.latex?%5C%5C%20%5CPr(A%5Cmid%20B)%5Ccdot%20%5CPr%20A%3D%20%5CPr%20(A%5Ccdot%20B)%20%5C%5C%20)](#_)

**Változókkal**

Ha adott az X és Y változó és annak valamely x és y értéke, akkor az írásmód:

[![\\ \Pr(X=x\mid Y=y)=\frac{\Pr (X=x\wedge Y=y)}{\Pr (Y=y)},\quad \Pr (Y=y)\ne 0 ](https://latex.codecogs.com/svg.latex?%5C%5C%20%5CPr(X%3Dx%5Cmid%20Y%3Dy)%3D%5Cfrac%7B%5CPr%20(X%3Dx%5Cwedge%20Y%3Dy)%7D%7B%5CPr%20(Y%3Dy)%7D%2C%5Cquad%20%5CPr%20(Y%3Dy)%5Cne%200%20)](#_)
vagy

[![\\ \Pr(X=x\mid Y=y)\cdot\Pr (Y=y)=\Pr (X=x\wedge Y=y)](https://latex.codecogs.com/svg.latex?%5C%5C%20%5CPr(X%3Dx%5Cmid%20Y%3Dy)%5Ccdot%5CPr%20(Y%3Dy)%3D%5CPr%20(X%3Dx%5Cwedge%20Y%3Dy))](#_)

az együttes vagy joint vagy többváltozós valószínűség _felbontását_ szorzatra **faktorizációnak** nevezzük. A faktorizáció feltételes valószínűségekkel a függőségi viszonyokat jeleníti meg.  

**1.** 

Pesten annak a valószínűsége, hogy március 14-edikán esik: 1/3. Ha esik, akkor 50%-os valószínűséggel dugul be a város. Ha nem esik, akkor a dugó kialakulásának aránya 0,25.   

**a)** Mi annak a valószínűsége, hogy közlekedési torlódás alakul ki?

Legyen R az az igaz/hamis értékű kategorikus változó, hogy esik. Ekkor 

<img src="https://render.githubusercontent.com/render/math?math=R%20%5C%3B~%20%5C%3B%5Ctext%7Bcategorical%7D(%5Ctext%7Bigaz%3A%7D%5C%3B%201%2F3%3B%5Ctext%7B%20hamis%3A%7D%5C%3B2%2F3)%20">

vagyis ez nem függ semmitől. A dugó T változója viszont feltételesen van megadva:  

<img src="https://render.githubusercontent.com/render/math?math=T%20%5C%3B~%5C%3B%20%5Ctext%7Bcategorical(igaz%2C%20ha%20R%3Digaz%3A%7D%5C%3B%201%2F2%3B%5C%3B%5Ctext%7Bigaz%2C%20ha%20R%3Dhamis%3A%20%7D%5C%3B1%2F2%3B%5C%3B%5Ctext%7Bhamis%2C%20ha%20R%3Digaz%3A%7D%5C%3B3%2F4%3B%5C%3B%5Ctext%7Bhamis%2C%20ha%20R%3Dhamis%3A%20%7D%5C%3B1%2F4%20%5Ctext%7B)%7D%20">

_Rögzített_ x és y értékek esetén:

<img src="https://render.githubusercontent.com/render/math?math=P(R%3Dx%2CT%3Dy)%3DP(T%3Dy%5Cmid%20R%3Dx%20)%5Ccdot%20P(R%3Dx)%20">  

Számoljuk ki az előző óra alapján:

````javascript
var model6 = function () {
    var R = flip(1/3)
    var T = R==true ? flip(1/2) : flip(1/4)
    return  {R: R, T: T, '(R,T)': [R, T]}
}

var Z = Infer({method: 'enumerate', model: model6})

viz(Z)
````

Ami nekünk kell, az a T eloszlása. De ez függ az R-ről, ezért erre szummázunk és a joint valószínűséget  

<img src="https://render.githubusercontent.com/render/math?math=P(T%3Dy)%3D%5Csum_%7Bx%3D%5Ctext%7Bigaz%2C%20hamis%7D%7D%20P(Y%3Dy%2C%20X%3Dx)%20%3D%20P(Y%3Dy%2C%20X%3Digaz)%2BP(Y%3Dy%2C%20X%3Dhamis)">


**b)** Tudjuk, hogy annak a valószínűsége, hogy késem, 1/2 ha nincs dugó, ha viszont dugó van, akkor 90%. Mennyi a késésem eloszlása? 

Legyen ez a változó L.

<img src="https://render.githubusercontent.com/render/math?math=L%5C%3B~%5C%3B%5Ctext%7Bcategorical(igaz%3A%7D%5C%3B1%5C%2C%3B%5Ctext%7Bha%20T%20igaz%7D%3B%5C%3B%5C%3B1%2F2%2C%5C%3B%5Ctext%7Bha%20T%20hamis%7D)">

Ekkor a függési viszonyok:

<img src="https://render.githubusercontent.com/render/math?math=P(R%3Dx%2CT%3Dy%2CL%3Dz)%3D%20P(L%3Dy%5Cmid%20T%3Dy)%5Ccdot%20P(T%3Dy%5Cmid%20R%3Dx)%5Ccdot%20P(R%3Dx)">

Alakítsuk át a programot és marginalizáljunk L-re!

### Feltételes eloszlás joint eloszlás esetén általános eset

A 

<img src="https://render.githubusercontent.com/render/math?math=P(X%2CY)%3A%3DP(X%3Dx_i%2CY%3Dy_j)%3A%3DP(X%3Dx_i%5Cwedge%20Y%3Dy_j)">

**joint eloszlás** esetén, a **feltételes valószínűség** gyakran a fenti egy speciális esete és így definiálják:

<img src="https://render.githubusercontent.com/render/math?math=P(X%7CY)%3A%3D%20P(X%3Dx_i%5Cmid%20Y%3Dy_i)">

Persze ezt is lehet szorzat formában írni:

<img src="https://render.githubusercontent.com/render/math?math=P(X%2CY)%3DP(X%3Dx_i%5Cwedge%20Y%3Dy_i)%3DP(X%3Dx_i%5Cmid%20Y%3Dy_i)%5Ccdot%20P(Y%3Dy_j)">

ahol P(Y) = P( Y = y<sub>j</sub> ) speciálisan egyben az egyik marginális eloszlás is:

<img src="https://render.githubusercontent.com/render/math?math=P(Y%3Dy_j)%3D%5Csum_i%20P(X%3Dx_i%2CY%3Dy_j)">

**Megjegyzés.** Vegyük észre, hogy a P (X | Y = y<sub>j</sub> ) = P( X = x<sub>i</sub> | Y = y<sub>j</sub> ) rögzített y<sub>j</sub>-re szintén az **X változó** egy valószínűségi eloszlása (pl. egyre összegződik: 

<img src="https://render.githubusercontent.com/render/math?math=%5Csum_%7Bi%7D%20P(X%3Dx_i%5Cmid%20Y%3Dy_i)%3D%5Csum_%7Bi%7D%5Cdfrac%7BP(X%3Dx_i%2CY%3Dy_j)%7D%7BP(Y%3Dy_j)%7D%3D%5Cdfrac%7B%5Csum_%7Bi%7DP(X%3Dx_i%2CY%3Dy_j)%7D%7BP(Y%3Dy_j)%7D%3D%5Cdfrac%7BP(Y%3Dy_j)%7D%7BP(Y%3Dy_j)%7D%3D1">)

Mindez Y-ra nem igaz: az Y értékben változó P(X = x<sub>i</sub> | Y ) kifejezés csak egy egyszerű függvény, pl. nem feltétlenül összegződik 1-re.



