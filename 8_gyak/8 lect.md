# Bayesiánus adatelemzés I. (Bayesian Data Analysis)

## Óvodások

Tudjuk, hogy az óvodások még nem feltétlenül tudnak különbséget tenni állat és növény között. Jó példa erre a pillangó. Elég magas kompetenciaszint egy kiscsoportostól, ha meg tudja mondani, hogy a pillangó növény vagy másféle élőlény. 20 óvodást kérdeztünk meg arról, hogy a pillangó állat-e. 5 óvodás szerint virág, a többiek szerint valami bogárkaféle. Ismerve az adatot, mi annak az eloszlásnak a várható értéke és 95%-hoz tartozó _hihetőségi_ intervalluma (credible intervall), amelyből ez az adat származhatott? 

### Generatív modell

A Bayesian Data Analysis elkezdéséhez kell: 1. egy generatív modell, 2. egy prior.

* _modellgyártás:_

1. Az adatszimuláló algoritmus _binomiális eloszlás_ kell, hogy legyen: szimulálni akarjuk az óvodások válaszait "robotovodásokkal": n=20 elemből kell kiválasztani véges sokat (akik virágnak nézik a pillangót), és ezt p valószínűséggel teszik. (Ha például súly vagy magassági adat lenne, akkor valószínűleg normáleloszlást választanánk.) 

2. A prior határozatlanabb, az alapfeltevés, hogy p-t egy egyenletes eloszlásból származtatjuk, azaz véletlenszerűen adunk neki 0 és 1 között értéket. Ez lesz a _prior._

* Hogyan generálunk p-t a priorból?

````javascript
var prior_szerint_generalt_p = function() {
  var p = uniform(0,1);   // p egy ilyen valószínűségi változó
  return p;
};

var p_eloszlása = 
    Infer({model: prior_szerint_generalt_p, samples: 1000, method: 'MCMC'});
viz(p_eloszlása);
````

* Hogyan választjuk ki a GM(p) = 5 -nek megfelelő paramétereket és mi lesz ezek eloszlása, vagyis a poszterior eloszlás? 

````javascript
var posterior_p = function() {
  var p = uniform(0,1);   // p egy ilyen valószínűségi változó
  observe(Binomial({p : p, n: 20}), 5); // itt választódnak ki az adatnak megfelelő p-k
  return p;
};

var poszterior = 
    Infer({model: posterior_p, samples: 1000, method: 'MCMC'});
    
    //Itt végezzük el az eloszlás modellezését mintavételezéssel
    
viz(poszterior);
````

* Készen is volnánk. De vajon ezzel az új paramétereloszlással milyen lehetséges (fizikai) értékek jöhetnek ki (_prediktív poszterior_) és mik voltak a korábbi eloszlás szerinti értékek (_prediktív prior_), azaz milyen volt és milyen lett, az úgy lehetséges adatok eloszlása?

````javascript
var model = function() {
  var p = uniform(0,1);
  observe(Binomial({p : p, n: 20}), 5);
  

var poszterior_prediktiv = binomial(p,20); // ezzel az új p-vel a szimulált adatok


var prior_p = uniform(0,1); // érintetlen paraméter

var prior_prediktiv = binomial(prior_p,20); // érintetlen paraméterből szimulált adatok

return {prior: prior_p, priorPredictive : prior_prediktiv,
       posterior : p, posteriorPredictive : poszterior_prediktiv};
};

var output = 
    Infer({model: model, samples: 1000, method: 'rejection'});
viz.marginals(output);
````

Érdemes hangsúlyozni, hogy a modell erősen igazodik az adott jelenséghez. Amikor óvódás valaszokat generálunk, akkor ezt annak a biztos tudatában tesszük, hogy a válaszok egy "sikerességi" (binomiális) mérés eredményei: virág vagy nem virág.

### Várható érték, kredibilitási intervallum

A maximum likelihood módszer pusztán pontbecslést ad, a legjobb paraméterértéket mondja meg. Most a  teljes posterior eloszlás megvan, ezért ki tudjuk számítani az eloszlás _várható értékét_ és a _kredibilitási (credible) intervallumot_ is, mondjuk 95%-ra.

````javascript
//óvodások folyt.
var model = function() {
  var p = uniform(0,1);
  observe(Binomial({p : p, n: 20}), 5);
  
  var poszterior_predikativ = binomial(p,20); // ezzel az új p-vel a szimulált adatok

return p;
};

var output = Infer({model: model, samples: 10000, method: 'MCMC'});
viz.auto(output);
print(expectation(output));
expectation(output,function(p){0.05<p && p<0.45})
````

Ahonnan a várható érték E(p) = 0.2797 és a 95%-os hihetőségi intervallum: (0.05,0.45), amit próbálgatással érdemes beállítani az E(p) körül. Ez azt mondja meg, hogy **a p paraméter hol helyezkedik el 95%-os valószínűséggel.** A bayesianizmusban tehát nem a p rögzített, hanem a kredibilitási intervallum.

### Modell 2: Beta prior

A binomiális eloszlásnál érdemes priornak beta(a,b) eloszlást választani, mert ez elég variábilis és sok eloszlást képes modellezni (ez részben azért van, mert a beta sok likelihood eloszláshoz konjugált, amit most nem érdemes részletezni). [https://en.wikipedia.org/wiki/Beta_distribution]

A beta(50,200) olyan eloszlás, ami jó erősen a bal lábára terhel. Ezzel, priorként, azt feltételezzük, hogy az óvodások nagyrészt jól felismeri, hogy a pillangó virág vagy másféle és ezért a k várható értéke kicsi.

````javascript
var model = function() {
  var p = beta(50,200);
  
    observe(Binomial({p : p, n: 20}), 5);

  var poszterior_predikativ = binomial(p,20); // ezzel az új p-vel a szimulált adatok
  
  var prior_p = beta(50,200); // érintetlen paraméter

  var prior_predikativ = binomial(prior_p,20); // érintetlen paraméterből szimulált adatok

return {prior: prior_p, priorPredictive : prior_predikativ,
       posterior : p, posteriorPredictive : poszterior_predikativ};
};

var output = Infer({model: model, samples: 10000, method: 'MCMC'});

viz.marginals(output);
````

Ilyen erős (dogmatikus) prior esetén a megfigyelt adat már kisebb valószínűségű, de ez inkább csak azt jelenti, hogy nagyon komolyan vesszük a feltételezést és ezért a k=5 érték már kevésbé gyakori.

Amennyiben több adat is van, mondjuk k=5, k=6 és k=19, akkor a nyilvánvalóan hibás 19-es mért értéket ez a prior ügyesen ki fogja szűrni:

````javascript
var model = function() {
  var p = beta(50,200);
  
    observe(Binomial({p : p, n: 20}), 5);
    observe(Binomial({p : p, n: 20}), 6); 
    observe(Binomial({p : p, n: 20}), 19);

  var poszterior_predikativ = binomial(p,20); // ezzel az új p-vel a szimulált adatok
  
  var prior_p = beta(50,200); // érintetlen paraméter

  var prior_predikativ = binomial(prior_p,20); // érintetlen paraméterből szimulált adatok

return {prior: prior_p, priorPredictive : prior_predikativ,
       posterior : p, posteriorPredictive : poszterior_predikativ};
};

var output = Infer({model: model, samples: 10000, method: 'MCMC'});

viz.marginals(output);
````

Szemben az egyenletes priorral, ami komolyan veszi a k=19 értéket is és ennek megfelelően valahova 10-re helyezi a k várható értékét a dogmatikus prior diszkreditálja a k=19-et.

## Bayesiánus bestiárium

**Generatív modell:**

Egy generatív modell olyan függvény, ami nagy adatmennyiséget képes algoritmikusan generálni. Az algoritmus bemenete a **paraméterek,** kimenete a **szimulált adat.** Pszeudo-random generátor, amely úgy produkálja az adatokat, hogy azok nagy átlagban egy adott valószínűségi eloszlásnak megfelelőek legyenek.

Ilyennel már találkoztunk. Nem dobáltunk kockát, nem húztunk kártyát, a gép elvégezte helyettünk. Képesek voltunk kockadobást, laphúzást szimulálni programmal.

**Bayesiánus következtetés:** Az előbbi program feladatát megfordítjuk: megpróbálunk visszakövetkeztetni arra, hogy egy valóságosan mért (tehát nem szimulált) Y = y **adat** a generatív modell milyen X = x **paraméterértékeire** tud generálódni. 

**Joint eloszlást** kapunk, ha a paratméterek X és a (szimulált vagy prediktált) adatok Y terének szorzatán feltételezünk egy P(X,Y) valószínűségi eloszlást, amelyet a _szorzatszabállyal_ számítunk ki (kétféleképpen)

(Annak a valószínűsége, hogy adott paraméter mellett az adat éppen a megfigyelt: az adat valószínűsége az X paraméterű modellben szorozva (súlyozva)  a modell valószínűségével)

: [![\\  \Pr(X\cdot Y)=\Pr(Y\mid X)\cdot \Pr(X)](https://latex.codecogs.com/svg.latex?%5C%5C%20%20%5CPr(X%5Ccdot%20Y)%3D%5CPr(Y%5Cmid%20X)%5Ccdot%20%5CPr(X))](#_)

(Annak a valószínűsége, hogy adott paraméter mellett az adat éppen a megfigyelt: az X paraméterű modell valószínűsége, fetéve, hogy az adat a megfigyelt értékű, szorzva (súlyozva) az adat valószínűségével)

: [![\\  \Pr(X\cdot Y)=\Pr(X\mid Y)\cdot \Pr(Y)](https://latex.codecogs.com/svg.latex?%5C%5C%20%20%5CPr(X%5Ccdot%20Y)%3D%5CPr(X%5Cmid%20Y)%5Ccdot%20%5CPr(Y))](#_)





Az adat és a generatív modell még nem elég, mert a paraméterteret is be kell népesíteni paraméterértékekkel és ehhez valami előzetes tudással kell rendelkeznünk arról, hogy mit gondolunk ezek eloszlásáról. Ez a joint eloszlás egy marginális eloszlása, a P(X) **prior eloszlás**.

Az általános P(X,Y) eloszlás általában nem ismert minden Y-ra, mert csak néhány Y mért adatot ismerünk (itt most y-t). 

A **likelihood függvény** az 

<img src="https://render.githubusercontent.com/render/math?math=x%5Cmapsto%20P(Y%3Dy%5Cmid%20X%3Dx)">

függvény, rögzített y adatra és arra használhatjuk, hogy a legjobb paraméterértéket meghatározzuk belőle. Világos, hogy ez nem ugyanaz, mint az 

<img src="https://render.githubusercontent.com/render/math?math=y%5Cmapsto%20P(Y%3Dy%5Cmid%20X%3Dx)">

rögzített x-re, ami egy valószínűségi eloszlás és azt mondja meg, hogy milyen predikciót tudunk tenni az adatokra, ha a paraméter értéke a rögzített x. A likelihood maximum feladat az 

<img src="https://render.githubusercontent.com/render/math?math=x_m%3D%5Cmathrm%7Bargmax%7D(x%5Cmapsto%20P(Y%3Dy%5Cmid%20X%3Dx))"> 

érték meghatározása, ami az a paraméterérték, amire a likelihood függvény maximális. Ha megvan ez az x<sub>m</sub>, akkor az y ↦ P( Y = y | X = x<sub>m</sub> ) függvény az adatokat prediktáló eloszlás. 

Vegyük észre, hogy a likelihood függvény kiszámítható az adatokból! Ha sokszor lefuttatjuk a modellt és kidobjuk a GM(x) = y egyenletet nem teljesítő adatokat, akkor megkereshető lesz az argmax.

A likelihood maximum módszer azonban semmit sem kezd a priorral, csak a generatív modellről mond valamit (bár arról elég sokat).

A P( X | Y = y ) **posteriori eloszlás** viszont a P(X) prior élesítése a mért adatok alapján, ami a likelihood függvényből és a priorból a Bayes-tételen keresztül már kiszámítható  

> A **bayesiánus eljárás** tehát 
> 
> 1. a P(X) priornak megfelelő X-eket generálva
> 
> 2. elkészíti azoknak az X-eknek az eloszlását, amire
> > GM(X) = y,
> 
> 3. ebből gyárja le a P( X | Y = y ) _poszteriort_ az 
> > P( X | Y ) = P( Y | X ) P (X) / P(Y) 
> 
> Bayest-tétel felhasználásával. Itt P(Y=y) konstans, ezért érvényes a 
> > P( X | Y=y ) α P( Y=y | X ) P (X) 
> 
> arányosság, ezért csak 
> 
> 4. normálni kell az x ↦ P( Y=y | X=x ) P (X=x)-t és máris megvan a poszterior, ami tehát azt írja le, hogy milyen az azon fizikailag is paraméterértékek _eloszlása,_ amiből az adtat származhatott. 

