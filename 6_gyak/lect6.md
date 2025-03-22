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

````flip(0.25)```` most a categorical egy spéci, spórolós változata. Boole-értéket ad vissza (azaz 0-t vagy 1-et) mégpedig 0.25 arányban az 1 javára. Húzás után visszatesszük a lapokat, tudjuk jól, ez a binomiális eloszlás és ezért a ````binom```` változó ugyanolyan eloszlású lesz. Lásd még a webppl dokumentációját! 

### Visszafelé következtetés ### 

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

Még érdekezebb a dolog, ha az X-et tudjuk, vagyis ő a megfigyelt változó:

````javascript

var model3 = function() {
  var H1 = flip(0.25)
  var H2 = flip(0.25)
  var H3 = flip(0.25)
  var X = H1 + H2 + H3
  condition( X == 1 )
  return {'H1': H1, 'H2': H2, 'H3': H3 }
}
var eloszlás3 = Enumerate(model3)

viz.auto(eloszlás3)
````

Ez már egy inferálás: a H1, H2, H3 látens változókat inferáljuk (következtetjük ki) az ismert X változóból.  

### Általában egy _X_ binomiális változó eloszlása ###

[![\\ \Pr(X = k) = \binom{n}{k}p^k(1-p)^{n-k}](https://latex.codecogs.com/svg.latex?%5C%5C%20%5CPr(X%20%3D%20k)%20%3D%20%5Cbinom%7Bn%7D%7Bk%7Dp%5Ek(1-p)%5E%7Bn-k%7D)](#_)

Tehát van egy _p_ valószínűségű Boole-változó (Bernoulli-változó) és definiálunk egy új változót: _X_ jelentse azt, hogy ha _n_-szer egy ilyen ($p$ szerint igazat vagy hamisat adó) kísérletet végrehajtunk (egymástól **függetlenül**), akkor ebből hányszor lesz _igaz_.

A képlet magyarázata röviden a következő. Ha pontosan tudnánk, hogy az $n$ hosszú kísérletsorozatból az első $k$-ban teljesül ($p$ valószínűséggel) a vizsgált tulajdonság, a többiben nem, akkor ennek a sorozatban a valószínűsége: $p^k(1-p)^{n-k}$, hiszen az elemi kimenetelek függetlenek és a komplementer esemény valószínűsége $1-p$, amiből $n-k$ van. No, most már képzeljünk el $n$ helyet egymás mellett, amelyekre az igaz szót tesszük le. Amikor az a kérdés, hogy $k$ igazat hányféleképpen tudunk erre az $n$ helyre letenni, akkor a válasz $\binom{n}{k}$. Mindegyik elrendezés megfelel a $k$ db igaz feltételnek, továbbá az ilyen lerakások kölcsönösen kizárják egymást, ezért ezeket csak össze kell adni, ezt megteszi az n-alatt a k szorzó. 

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

## Feltételes valószínűség, függő változók

Valószínűségi változók függhetnek egymástól.

**Példa**

X = pénzérmével fej vagy írás (boole (1|0) értékű változó (0.5, 0.5) kategorikus eloszással)

Y | X = királyt húzása (1|0) magyar kártyából, ha X = 1, és francia kártyából, ha X = 0.

|      |  X=1   | X=0 |  
| ---  | --- | --- | 
|  Y=1, ha X = ... |  1/8 | 1/13 | 
|  Y=0, ha X = ... | 7/8 | 12/13  | 

**Megjegyzés.** Világos, hogy ez a táblázat NEM valószínűségi változó eloszlása. CSAK X rögzítésével lesz "igazi" eloszlás. A mögöttes eloszlás Y, azaz a "király húzása" csak közvetetten tudható. 

(Feltételes: leszűkítjük az elemi események terét a feltételre, az A eseményt teljesítő elemi részeseményekre, azaz innentől nem Ω, hanem A az összes elemi események tere.)

"Awkward" jelölés:

[![\\ \Pr(Y\mid X)=\frac{\Pr (Y\cdot X)}{\Pr (X)},\quad \Pr (X)\ne 0](https://latex.codecogs.com/svg.latex?%5C%5C%20%5CPr(Y%5Cmid%20X)%3D%5Cfrac%7B%5CPr%20(Y%5Ccdot%20X)%7D%7B%5CPr%20(X)%7D%2C%5Cquad%20%5CPr%20(X)%5Cne%200)](#_)

... és amit jelent valójában: rögzített x1,x2,... y1,y2,... elemi kimenetelekkel:

[![\\ \Pr(Y=y_j\mid X=x_i)=\frac{\Pr (Y=y_j\;\&\; X=x_i)}{\Pr (X=x_i)},\quad \Pr (X=x_i)\ne 0](https://latex.codecogs.com/svg.latex?%5C%5C%20%5CPr(Y%3Dy_j%5Cmid%20X%3Dx_i)%3D%5Cfrac%7B%5CPr%20(Y%3Dy_j%5C%3B%5C%26%5C%3B%20X%3Dx_i)%7D%7B%5CPr%20(X%3Dx_i)%7D%2C%5Cquad%20%5CPr%20(X%3Dx_i)%5Cne%200)](#_)

P(Y|X) -t úgy mondjuk ki, hogy Y valószínűsége feltéve, hogy X adott (probability of Y given X).

````javascript
var model5 = function () {
    var X = flip()
    var Y = flip( X ? 1/8 : 1/13)
    
    // condition (Y==1);
    // return  {'X,Y': [X , Y]}
    return  {'X' : X, 'Y': Y}
}

var Z = Infer({method: 'enumerate', model: model5})

viz.table(Z)
````
Tehát a 

[![\\ j\mapsto \Pr(Y=y_j\mid X=x_i),\qquad X=x_i\quad const.](https://latex.codecogs.com/svg.latex?%5C%5C%20j%5Cmapsto%20%5CPr(Y%3Dy_j%5Cmid%20X%3Dx_i)%2C%5Cqquad%20X%3Dx_i%5Cquad%20const.)](#_)

függvény valószínűségi eloszlás és **feltételes valószínűségi eloszlásnak** hívjuk. És valóban, az oszlopok összege kiadja az 1-et:

[![\\ \sum\limits_{j=1}^k\Pr(Y=y_i\;\mid\; X=x_i)= 1](https://latex.codecogs.com/svg.latex?%5C%5C%20%5Csum%5Climits_%7Bj%3D1%7D%5Ek%5CPr(Y%3Dy_i%5C%3B%5Cmid%5C%3B%20X%3Dx_i)%3D%201)](#_)

Az X*Y szintén eloszlás:

[![\\ (i,j)\mapsto \Pr(Y=y_j\;\&\; X=x_i)](https://latex.codecogs.com/svg.latex?%5C%5C%20(i%2Cj)%5Cmapsto%20%5CPr(Y%3Dy_j%5C%3B%5C%26%5C%3B%20X%3Dx_i))](#_)

az úgy nevezett **joint eloszlás.** Ez írja le teljes pontossággal a változók egymástól való függését. 

A **szorzatszabály** szerint P(X=i,Y=j) = P(Y=j|X=i) P(X=i), azaz pl.: P(X=1,Y=1) = 1/8 * 1/2.

[![\\ (i,j)\mapsto \Pr(Y=y_j\;\&\; X=x_i)= \Pr(Y=y_j\mid X=x_i)\cdot \Pr(X=x_i)](https://latex.codecogs.com/svg.latex?%5C%5C%20(i%2Cj)%5Cmapsto%20%5CPr(Y%3Dy_j%5C%3B%5C%26%5C%3B%20X%3Dx_i)%3D%20%5CPr(Y%3Dy_j%5Cmid%20X%3Dx_i)%5Ccdot%20%5CPr(X%3Dx_i))](#_)

vagy az awkward jelöléssel: 

[![\\ \Pr(Y\;\cdot\; X)= \Pr(Y\mid X)\cdot \Pr(X)](https://latex.codecogs.com/svg.latex?%5C%5C%20%5CPr(Y%5C%3B%5Ccdot%5C%3B%20X)%3D%20%5CPr(Y%5Cmid%20X)%5Ccdot%20%5CPr(X))](#_)

Ekkor (X,Y) eloszlása már igazi, együttes, "joint" eloszlás. 

|      |  X=1   | X=0 |  
| ---  | --- | --- | 
|  Y=1 |  1/16 | 1/26 | 
|  Y=0 | 7/16 | 6/13  | 

Viszont ha Y-t rögzítjük, akkor P(Y|X) nem lesz valószínűségi eloszlás, akkor az az úgy nevezett **likelihood függvény:**

[![\\ x_i\mapsto\Pr(Y=y_i\;\mid\; X=x_i)\ne 1, \qquad y_j=const.](https://latex.codecogs.com/svg.latex?%5C%5C%20x_i%5Cmapsto%5CPr(Y%3Dy_i%5C%3B%5Cmid%5C%3B%20X%3Dx_i)%5Cne%201%2C%20%5Cqquad%20y_j%3Dconst.)](#_)

Valóban, általában a sorok összege nem 1:

[![\\ \sum\limits_{i=1}^k\Pr(Y=y_i\;\mid\; X=x_i)\ne 1, \qquad y_j=const.](https://latex.codecogs.com/svg.latex?%5C%5C%20%5Csum%5Climits_%7Bi%3D1%7D%5Ek%5CPr(Y%3Dy_i%5C%3B%5Cmid%5C%3B%20X%3Dx_i)%5Cne%201%2C%20%5Cqquad%20y_j%3Dconst.)](#_)

DE ez is egy nagyon hasznos függvény. Egy interperetáció, ezt ez a szám azt mondja, meg, hogy az adat milyen valószínű a különböző lehetséges világokban. Pl. fent az egyik világban magyar, a másikban francia kártya van. Az egyik világban a király valószínűsége nagyobb, mint a másikban. Ezért ha királyt húzunk, akkor nagyobb valószínűséggel vagyunk a "magyar" világban. Ezt a módszert hívjuk **maximum likelihood** módszernek. A Bayes-féle modellkiválasztás ennek egy spéci verziója és Pearson majdnem kitalálta az 1890-es években. 

## Monty Hall- (vos Savant-) paradoxon

<img src="https://github.com/mozow01/cog_compsci/blob/main/SciCamp/The-Monty-Hall-Problem-e1623680322430.png" width=200>

Adott 3 csukott ajtó mögött egy-egy nyeremény: 1 autó és 1-1 plüsskecske. Monty, a showman megkér minket arra, hogy tippeljük meg, hol az autó (ha eltaláljuk, a miénk lesz). Amikor ez megtörtént, akkor Monty kinyit egy ajtót, éspedig szigorúan azok közül egyet, amelyek mögött egy kecske van és nem mutattunk rá. Majd felteszi újra a kérdést: hol az autó. Érdemes-e megmásítanunk a döntésünket?

A feladatot a joint eloszlás feltérképezésével oldjuk meg.

X a tippünk, Y az autó helye, Z az, hogy Monty melyik ajtót nyitja ki.

|      |     | Y=1 |     |     | Y=2 |     |     | Y=3 |     | P(X) |
| ---  | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|      | Z=1 | Z=2 | Z=3 | Z=1 | Z=2 | Z=3 | Z=1 | Z=2 | Z=3 |     | 
| X=1  | 0   | 1/18| 1/18| 0   | 0   | 1/9 | 0   | 1/9 |   0 | 1/3 | 
| X=2  | 0   |  0  |1/9  | 1/18   | 0   |  1/18  | 1/9 | 0 |   0 |  1/3| 
| X=3  | 0   | 1/9 |  0 | 1/9   | 0   | 0 | 1/18 | 0  |   1/18 |  1/3 | 
| P(Y) |    | 1/3 |    |    | 1/3 |   |   | 1/3 |    |   1  | 

**A táblázat kitöltéséhez** érdemes végiggondolni, hogy mi függ mitől. Pl. **X és Y biztosan független:** P(X*Y)=P(X)*P(Y). Ezt fel fogjuk a számolásban használni. Itt persze P(X) egy _marginális eloszlás,_ amikor összegzünk (kilőjük) mind Y-t, mind Z-t.  

Aztán azt is feltehetjük, hogy X, Y is egyenletes, azaz nem részesít előnyben egy ajtót se egy berendező se. És mi is úgy választunk, hogy az találomra megy.

Monty egyenletes eloszlással (találomra?) választ ajtót, azaz P(X=1,Y=1,Z=2) = P(X=1,Y=1,Z=3), csak arra vigyáz, hogy se a mi jelöltünket, se az autót ne fedje fel. Monty mindig kecskét mutat meg!!!

**Számoljuk ki egy esetben, mi annak a valószínűsége, hogy ugyanazon ajtó mögött van a nyeremény, amire mutattunk.** Pl.: P(X=1 és Y=1) = 1/9. Persze ezt mindhárom esetben ki tudjuk számolni, és az eredmény (a független lehetőségek összeadási szabály amiatt)

P(X=Y) = 1/3

Ez annak az esélye, hogy elsőre eltaláljuk a kedvező ajtót (ez világos is). Annak a valószínűsége, hogy nem a választottunk mögött van az autó, a komplementer szabály szerint:

P(X=/=Y) = 1 - 1/3 = 2/3

Monty kinyitja a megmaradó kettő közül azt az ajtót, ami mögött nincs autó és nem is mutattunk rá, ezért utólag behatárolja azt a _két_ ajtót, ami mögött az autó van. Nyilván eredetileg nem bökhettünk volna rá két ajtóra, amelyek persze kétszer annyi valószínűséggel rejtik az autót. De most, hogy ebből a kettőből mutatott Monty egy rossz ajtót, már érvényesíthetjük a P(X=/=Y) = 2/3 valószínűségű nyerést egyetlen ajtóra való rámutatással. Ami persze nem jelenti, hogy ott is lesz az autó, de kétszer akkora eséllyel lesz ott, mint nem. 

Marilyn vos Savant egy szellemes példán mutatta be, hogy miért igaz az, hogy messze jobb váltani. Az érvelése analógiás és a következő. Lefordítunk 1000 kagylót egy parkolóban és az egyik alá rejt Marilyn egy gyöngyöt. Rámutatunk az egyikre azzal, hogy ott van a gyöngy. Találatot ezzel 1/1000 eséllyel érünk el. 

                    ✨

    📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀📀

Most Marilyn pontosan kettő kivételével az összes kagylót elveszi, éspedig az igaz erre a fel nem fordított kettőre, hogy közte van az is, amire mutattam, és az is, ahol a gyöngy van. 

                    ✨
  
    📀               📀


Érdemes-e váltani? Természetesen, hiszen így 999/1000 az esélye, hogy azalatt van a gyöngy, amire nem szavaztunk. Gyakorlatilag Marilyn megmutatta, hogy hol a gyöngy és 1000-ből 1-szer lesz csak pechünk, amikor is eredetileg jól választottunk.

````javascript
var vosSavantProblem = function () {
    var Autó = categorical({ps:[1/3,1/3,1/3], vs:[1, 2, 3]})
    var Tipp = categorical({ps:[1/3,1/3,1/3], vs:[1, 2, 3]})
    var Monty = (Autó == Tipp) 
                ? ( (Autó == 1) 
                   ? categorical({ps:[1/2,1/2], vs:[2, 3]}) : 
                   ( (Autó == 2) ? categorical({ps:[1/2,1/2], vs:[1, 3]}) :
                    categorical({ps:[1/2,1/2], vs:[1, 2]}) ) )
                : ( (1 !== Autó && 1 !== Tipp ) ? 1 :
                   ( (2 !== Autó && 2 !== Tipp ) ) ? 2 : 3 )
    
    var stratégia_maradás = (Autó == Tipp) ? 'nyer' : 'veszít'
    
    var ÚjTipp = (Autó !== Tipp) 
                ? Autó
                : ( (Tipp == 1 && Monty == 2) ? 3 : 
                   ( (Tipp == 1 && Monty == 3) ? 2 : 
                   ( (Tipp == 2 && Monty == 1) ? 3 :
                   ( (Tipp == 2 && Monty == 3) ? 1 :
                   ( (Tipp == 3 && Monty == 1) ? 2 : 1 ) ) ) ) ) 
    
    var stratégia_váltás = (Autó == ÚjTipp) ? 'nyer' : 'veszít'
    
    return  {
             stratégia_maradás: stratégia_maradás, 
             stratégia_váltás: stratégia_váltás } 
}

var eloszlás = Enumerate(vosSavantProblem)

viz.marginals(eloszlás)
````

Láthatóan a váltás a nyerő stratégia.




