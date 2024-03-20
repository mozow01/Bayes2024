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

Pesten annak a valószínűsége, hogy március 20-adikán esik: 1/3. Ha esik, akkor 50%-os valószínűséggel dugul be a város. Ha nem esik, akkor a dugó kialakulásának aránya 0,25.   

**a)** Mi annak a valószínűsége, hogy közlekedési torlódás alakul ki?

Legyen R az az igaz/hamis értékű kategorikus változó, hogy esik. Ekkor 

[![\\ R\sim categorical(1/3,2/3)](https://latex.codecogs.com/svg.latex?%5C%5C%20R%5Csim%20categorical(1%2F3%2C2%2F3))](#_)

vagyis ez nem függ semmitől. A dugó T változója viszont feltételesen van megadva:  

[![\\ T\sim \begin{cases}categorial(0.5,0.5) & R=true \\ \\ categorial(0.25,0.57) & R=false \\ \end{cases}](https://latex.codecogs.com/svg.latex?%5C%5C%20T%5Csim%20%5Cbegin%7Bcases%7Dcategorial(0.5%2C0.5)%20%26%20R%3Dtrue%20%5C%5C%20%5C%5C%20categorial(0.25%2C0.57)%20%26%20R%3Dfalse%20%5C%5C%20%5Cend%7Bcases%7D)](#_)

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

Mi a joint valószínűség?

**b)** Tudjuk, hogy annak a valószínűsége, hogy késem, 1/2 ha nincs dugó, ha viszont dugó van, akkor 90%. Mennyi a késésem eloszlása? 

Alakítsuk át a programot és marginalizáljunk L-re!

**Megjegyzés.** Vegyük észre, hogy a P (X | Y = y<sub>j</sub> ) = P( X = x<sub>i</sub> | Y = y<sub>j</sub> ) rögzített y<sub>j</sub>-re szintén az **X változó** egy valószínűségi eloszlása (pl. egyre összegződik: 

Mindez Y-ra nem igaz: az Y értékben változó P(X = x<sub>i</sub> | Y ) kifejezés csak egy egyszerű függvény, pl. nem feltétlenül összegződik 1-re.



