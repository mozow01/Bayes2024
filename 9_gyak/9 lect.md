# Gráfmodellek

A gráfmodell alapjául szolgáló _G_ irányított körmentes gráf (DAG) egy spéci címkézett osztályba tarozik. A **bekarikázott** csúcsok valószínűségi változókat reprezentálnak (és elég ezeket feltüntetni, de nem kell csak ezeket), a **bekarikázatlanok** determinisztikus változókat. A **nyilak** a p(x<sub>0</sub>,...,x<sub>K</sub>) joint valószínűség alábbi alakú szorzattá bonthatóságát fejezi ki valamilyen értelemben:

[![\\ \Pr(x_1,\ldots,x_K)=\prod_{i=1}^K \Pr(x_i\mid\text{pare}(x_i)) \\ ](https://latex.codecogs.com/svg.latex?%5C%5C%20%5CPr(x_1%2C%5Cldots%2Cx_K)%3D%5Cprod_%7Bi%3D1%7D%5EK%20%5CPr(x_i%5Cmid%5Ctext%7Bpare%7D(x_i))%20%5C%5C%20)](#_)

ahol pa<sub>k</sub> az x<sub>k</sub> csúcs (közvetlen) szülei. A szorzatban pontosan akkor szerepel a p(x<sub>k</sub> | x<sub>i</sub>,...,x<sub>j</sub>) tényező, ha a G-ben van x<sub>i</sub>,...,x<sub>j</sub> pontjaiból x<sub>k</sub>-ba mutató nyíl. A **besatírozott** csúcsok olyan valószínűségi változók, amelyek a **megfigyelt változókat reprezentálják.** A **nem besatírozott** változók a **látens paraméterek.** Tehát G gráfmondellje a p(x<sub>0</sub>,...x<sub>K</sub>) joint valószínűségnek, ha a fenti faktorizációs tulajdonság teljesül.

A faktoritációs tulajdoságot ténylegesen jeleznii tudjuk a **faktorpontokkal.** Ekkor pontosan akkor köti össze egy faktorpont egy gyerekeket és szülőket, ha ezektől függ a gyerek.

## Diszkrét hierarchikus modell (évszak és vizes fű)

A _generatív modell_ (azaz egy "randomoutput(randominput)" algoritmikus függvény) négy valószínűségi változóból áll elő, "évszak" (h) (tavasz/nyár/ősz/tél) , "felhős" (f) (derűs/enyhén felhős/erősen felhős), "locsolórendszer" (l) (megy/nem megy), "eső" (e) (esik/nem esik), "vizes a fű" (v) (vizes/nem vizes). Ezek az alábbi gráf alapján függnek egymástól (a faktorok valóban azt jelzik, hogy a joint valószínűség hogyan bomlik szorzatá).

<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/locsolo_1.png" width=600>

És a webppl kód:

````javascript
var vizesModel = Infer({ method: 'enumerate' }, function(){
  var évszak = categorical({ps:[0.25,0.25,0.25,0.25], 
                            vs: ['tavasz', 'nyár', 'ősz', 'tél'] });
  
  var felhős = ((évszak === 'tavasz') || (évszak === 'ősz' )) ? flip(0.9) : flip(0.5);
  
  var esik = felhős ? flip(0.8) : flip(0.0);
 
  var locsoló = felhős ? flip(0.1) : flip(0.9);
  
  var vizes = esik && locsoló 
                   ? flip(.99)  
                   : (esik && !locsoló ) || (esik && !locsoló ) 
                        ? flip(0.9) 
                        : flip(0.1);
       condition(vizes === true);
  
  var évszakPrior = categorical({ps:[0.25,0.25,0.25,0.25], 
                            vs: ['tavasz', 'nyár', 'ősz', 'tél'] });
  
  var felhősPrior = ((évszakPrior === 'tavasz') || (évszakPrior === 'ősz' )) ? 
      flip(0.9) : flip(0.5);
  
       return {évszakPrior: évszakPrior, felhősPrior: felhősPrior,
               évszakPost: évszak, felhősPost: felhős  };
});

viz.marginals(vizesModel)
````

Itt "évszak" előtt van egy konstans csúcs, ami a kategorikus változó eloszlásának adatait (hogy egyenletes) tartalmazza. Ezek a paraméterek azonban rögzítettek.

A generatív modell programozott verziója a fenti kódban ez (A pszeudokódját az ábrán látjuk.)

````javascript
var évszak = categorical({ps:[0.25,0.25,0.25,0.25], vs: ['tavasz', 'nyár', 'ősz', 'tél'] });

var felhős = ((évszak === 'tavasz') || (évszak === 'ősz' )) ? flip(0.9) : flip(0.5);
  
var esik = felhős ? flip(0.8) : flip(0.0);
 
var locsoló = felhős ? flip(0.1) : flip(0.9);
  
var vizes = esik && locsoló 
                   ? flip(.99)  
                   : (esik && !locsoló ) || (esik && !locsoló ) 
                        ? flip(0.9) 
                        : flip(0.1);
````
Múlhatatlanul fontos a Bayes-tétel:

[![\\ \Pr(\vartheta)\;\leadsto\;\Pr(\vartheta\mid X )=\dfrac{\Pr(X\mid \vartheta)\cdot \Pr(\vartheta)}{\Pr(X)}\;;\Pr(\vartheta=t\mid X=d )=\dfrac{\Pr(X=d\mid \vartheta=t)\cdot \Pr(\vartheta=t)}{\Pr(X=d)}](https://latex.codecogs.com/svg.latex?%5C%5C%20%5CPr(%5Cvartheta)%5C%3B%5Cleadsto%5C%3B%5CPr(%5Cvartheta%5Cmid%20X%20)%3D%5Cdfrac%7B%5CPr(X%5Cmid%20%5Cvartheta)%5Ccdot%20%5CPr(%5Cvartheta)%7D%7B%5CPr(X)%7D%5C%3B%3B%5CPr(%5Cvartheta%3Dt%5Cmid%20X%3Dd%20)%3D%5Cdfrac%7B%5CPr(X%3Dd%5Cmid%20%5Cvartheta%3Dt)%5Ccdot%20%5CPr(%5Cvartheta%3Dt)%7D%7B%5CPr(X%3Dd)%7D)](#_)

Itt 

P(𝜗|X) a **poszterior eloszlás,** 

P(X|𝜗) a **likelihood függvény,**

P(𝜗) a **prior eloszlás,**

P(X) az **adat valószínűsége**.

Ez utóbbi kettő marginális eloszlások: 

[![\\ \Pr(\vartheta=t)=\sum\limits_{X=d}\Pr(\vartheta=t,X=d)](https://latex.codecogs.com/svg.latex?%5C%5C%20%5CPr(%5Cvartheta%3Dt)%3D%5Csum%5Climits_%7BX%3Dd%7D%5CPr(%5Cvartheta%3Dt%2CX%3Dd))](#_)

[![\\ \Pr(X=d)=\sum\limits_{\vartheta=t}\Pr(\vartheta=t,X=d)](https://latex.codecogs.com/svg.latex?%5C%5C%20%5CPr(X%3Dd)%3D%5Csum%5Climits_%7B%5Cvartheta%3Dt%7D%5CPr(%5Cvartheta%3Dt%2CX%3Dd))](#_)
 
Bizonyítás:

[![\\ \Pr(\vartheta=t,X=d)=\Pr(\vartheta=t\mid X=d )\cdot \Pr(X=d)\\ \\ \Pr(X=d,\vartheta=t)=\Pr(X=d\mid \vartheta=t )\cdot \Pr(\vartheta=t\)](https://latex.codecogs.com/svg.latex?%5C%5C%20%5CPr(%5Cvartheta%3Dt%2CX%3Dd)%3D%5CPr(%5Cvartheta%3Dt%5Cmid%20X%3Dd%20)%5Ccdot%20%5CPr(X%3Dd)%5C%5C%20%5C%5C%20%5CPr(X%3Dd%2C%5Cvartheta%3Dt)%3D%5CPr(X%3Dd%5Cmid%20%5Cvartheta%3Dt%20)%5Ccdot%20%5CPr(%5Cvartheta%3Dt%5C))](#_)

És persze a joint eloszlásokra: P(X,𝜗)=P(𝜗,X). Qed.

A **példabeli** joint eloszlás faktorizációja tehát a következő: 

[![\\ \\ \begin{align*} \\ p(h,f,l,e,v) &=p(v|l,e)\cdot p(l,e)= \qquad (\;p(h,l,f,e|v)\cdot p(v)\;)\\ \\ &= p(v|f,e)\cdot p(l,e|f)\cdot p(f)=\\ \\ &=p(v|f,e)\cdot p(l|f)\cdot p(e|f)\cdot p(f|h) \cdot p(h) \\ \end{alogn*}](https://latex.codecogs.com/svg.latex?%5C%5C%20%5C%5C%20%5Cbegin%7Balign*%7D%20%5C%5C%20p(h%2Cf%2Cl%2Ce%2Cv)%20%26%3Dp(v%7Cl%2Ce)%5Ccdot%20p(l%2Ce)%3D%20%5Cqquad%20(%5C%3Bp(h%2Cl%2Cf%2Ce%7Cv)%5Ccdot%20p(v)%5C%3B)%5C%5C%20%5C%5C%20%26%3D%20p(v%7Cf%2Ce)%5Ccdot%20p(l%2Ce%7Cf)%5Ccdot%20p(f)%3D%5C%5C%20%5C%5C%20%26%3Dp(v%7Cf%2Ce)%5Ccdot%20p(l%7Cf)%5Ccdot%20p(e%7Cf)%5Ccdot%20p(f%7Ch)%20%5Ccdot%20p(h)%20%5C%5C%20%5Cend%7Balogn*%7D)](#_)

A p(l,e,f,h) ~> p(l,e,f,h|v) **Bayes-frissítés** végeredménye, azaz a poszterior eloszlást a Bayes-tétel alapján kapjuk:
 
[![\\ \;p(l,e,f,h|v)=\dfrac{p(v|l,e)\cdot p(l|f)\cdot p(e|f)\cdot p(f|h)\cdot p(h)}{p(v)}](https://latex.codecogs.com/svg.latex?%5C%5C%20%5C%3Bp(l%2Ce%2Cf%2Ch%7Cv)%3D%5Cdfrac%7Bp(v%7Cl%2Ce)%5Ccdot%20p(l%7Cf)%5Ccdot%20p(e%7Cf)%5Ccdot%20p(f%7Ch)%5Ccdot%20p(h)%7D%7Bp(v)%7D)](#_)

Itt a **likelihood függvény,** p(v|l,e) p(l|f) p(e|f) p(f|h) (mondjuk), vagyis az a függvény, megadja a generatív modellt, és ez még a priorral való szorzás után sem lesz igazi valószínűségi eloszlás, de az adat rögzítésével (márpedig az adatok rögzítettek), arányos lesz ezzel. Az arányossági tényező 1/p(v), amivel normáljuk a likelihood-prior szorzatot, és az már eloszlás lesz.

(A Bayes-inferencia most "kimerítéssel" (enumerate) és "az adat feltételezésével" (condition) működik: a hónap változó marginális eloszlását számolja ki azzal a feltétellel, hogy adat = vizes, az összes eset végigszámolásával.)

## Konjugált prior

Nyilvánvaló, hogy a **jelenséget** a generatív modell tartalmazza, ami pedig a likelihood függvényt számolja ki valamilyen módon. Ez most az egyszerűségében is elég bonyi, de maradjunk annyiban, hogy valami kategorikus változó a bemenet és Boole-értékű a kimenet. Az elemzést tovább finomíthatjuk úgy, hogy a prior paramétereit variáljuk. Most a prior egy egyszerű **kategorikus** változó: egy zsákban színes golyók vannak rögzített arányban és egy golyót húzunk belőle. A prior paramétereire tett elméleti feltételezést hiperpriornak nevezzük. 

Hogyan választunk hiperpriort (vagy általában priort)?  

Bárhogy. De ha szép eredményt akarunk, akkor a likelihoodhoz (vagyis az alapjelenséghez) olyan hiperprior eloszlást (másik jelenséget) kell választanunk, amivel ha a likelihood-ot megszorozzuk ugyanolyan jelenséget kapunk, mint a hiperprior. Ez azért van, mert azt gondoljuk, hogy a Bayes-i update-elés valóban élesítés: egy y |----> f(p,y) (prior) függvénycsaládból választja ki azt a p paramétert, amit az adatok mellett a legvalószínűbb. Nem kell feltétlenül így tennünk, mert úgy is numerikus a számítás és a gép kidobja az eloszlást mindenképpen. De ez az ajánlás, nem teljesen hülyeség. 

[https://en.wikipedia.org/wiki/Conjugate_prior]

Például a kategorikus változó számára a konjugált prior a _Dirichlet-eloszlás._ A binomiális ("hányan hibáztak rá a jó válaszra") változóhoz a beta. A beta általánosítása a Dirichlet. A gauss-nak a gauss.

A locsolós példa ezzel módosítva:

<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/locsolo_2.png" width=600>

És a kód:

````javascript
var vizesmasikModel = Infer({ method: 'rejection' }, function(){
  
  var x = dirichlet({alpha: Vector([1/10,2/10,7/10])});

    var x1 = (x.data)[0];

    var x2 = (x.data)[1];

    var x3 = (x.data)[2];
  
  var felhős =  categorical({ps:[x1,x2,x3], 
                            vs: ['derült', 'enyhén felhős', 'erősen felhős'] });
  
  var esik = (felhős === 'derült')
                   ? flip(.1)  
                   : (felhős === 'enyhén felhős')
                        ? flip(0.6) 
                        : flip(0.9);
 
  var locsoló = (felhős === 'derült')
                   ? flip(.9)  
                   : (felhős === 'enyhén felhős')
                        ? flip(0.2) 
                        : flip(0);
  
  var vizes = esik && locsoló 
                   ? flip(.99)  
                   : (esik && !locsoló ) || (esik && !locsoló ) 
                        ? flip(0.9) 
                        : flip(0.1);
       condition(vizes === true);
  
  var y = dirichlet({alpha: Vector([1/10,2/10,7/10])});
   
    var y1 = (y.data)[0];

    var y2 = (y.data)[1];

    var y3 = (y.data)[2];
  
  var felhősPrior = categorical({ps:[y1,y2,y3], 
                            vs: ['derült', 'enyhén felhős', 'erősen felhős'] });
  
  
       return {derűsHyperPrior: y1, enyhenHyperPrior2: y2, erösenHyperPrior: y3, 
               felhősPrior: felhősPrior,
               felhősPosterior: felhős  };
});

viz.marginals(vizesmasikModel)
````

# Példák

## Binomiális kísérlet különböző méretű csoportokkal

Három különböző csoportban kérdezték meg, hogy a pillangó virág-e, a mért változó értékei a data változó alatt találhatók. A két modellben a priorok a non-informative és a dogmatikus volt. 

### Egyenletes prior

<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/binom_1.png" width=500>

````javascript
var data = [{name: 'napocskas', n:20, k:5},
            {name: 'holdacskas', n:23, k:8},
            {name: 'napraforgo', n:19, k:17},
           ]

var simpleModel = function() {
  
  var p = uniform(0,1);
  
  map(function(d){observe(Binomial({p: p, n: d.n}), d.k)}, data);
  
  var prior = uniform(0,1);
  
  // 20 fős csoportokra normálva
  
  var predictivePosterior = binomial({p: p, n: 20});
  
  var predictivePrior = binomial({p: prior, n: 20});
  
  return {Prior: prior, 
          PredictivePrior: predictivePrior, 
          Posterior: p, 
          PredictivePosterior: predictivePosterior};
}

var opts = {method: 'MCMC', samples: 20000}

var output_1 = Infer(opts, simpleModel)

viz.marginals(output_1)
````

Tehát az adatot a **map** környezetbe ágyazva illesztjük be a feltételbe.

<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/1559f8.svg" height=200><img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/30810f.svg" height=200><img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/bab66f.svg" height=200><img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/d0c66b.svg" height=200>

### Beta prior


<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/binom_2.png" width=500>

````javascript
var data = [{name: 'napocskas', n:20, k:5},
            {name: 'holdacskas', n:23, k:8},
            {name: 'napraforgo', n:19, k:17},
           ]

var complexModel = function() {
  
  var p = beta(30,90);
  
  map(function(d){observe(Binomial({p: p, n: d.n}), d.k)}, data);
  
  var prior = beta(30,90);
  
    // 20 fős csoportokra normálva
  
  var predictivePosterior = binomial({p: p, n: 20});
  
  var predictivePrior = binomial({p: prior, n: 20});
  
  return {Prior: prior, 
          PredictivePrior: predictivePrior, 
          Posterior: p, 
          PredictivePosterior: predictivePosterior};
}

var opts = {method: 'MCMC', samples: 20000}

var output_2 = Infer(opts, complexModel)

viz.marginals(output_2)
````

<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/641286.svg" height=200><img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/6af94a.svg" height=200><img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/28e8ec.svg" height=200><img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/af2eb4.svg" height=200>


## Aranyhal

Egy aranyhal súlyadatai: 5, 16 és 17 g, három mérés után. Úgy döntünk, hogy ha az átlag a 15-17 sávba esik, akkor átlagos mennységet adunk neki, ha kevesebb, akkor többet, ha több, akkor kevesebbet. A kérdés, hogy számtani közepet számoljunk-e (12.7 g) vagy (informatív) priorból dolgozzunk-e. A komplexebb megközelítéshez tudjuk, hogy ezen halfajta súlya (x) normál eloszlást mutat, az átlaga 16 g, ennek az adatnak a szórása 0.2 g, továbbá az x normál elszolásának szórása 1 g. 

Ebben a példában, lévén a likelihood folytonos eloszlás, **nem használhatjuk a diszkrét eloszlások feltételeit tartalamzó condition-t,** mert az hajszálpontos értéket ütköztet. Helyette az **observe** parancs lazít az adatok ütköztetésén. Ekkor elég, ha a generált adatok a megfigyelt adatok egy kis környezetében vannak. Lásd: [https://webppl.readthedocs.io/en/master/inference/conditioning.html]

### Megoldás. 

#### Ha a prior uniform: 

<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/gaussunif_1.png" width=500>

````javascript
var data = [{k: 5},
            {k: 16},
            {k: 17},
           ]

var simpleModel = function() {
  
  var m = uniform(4,18);
   
  map(function(d){observe(Gaussian({mu: m, sigma: 1}),d.k)},data);
  
  var Prior = uniform(4,18);
  
  var PredictivePosterior = gaussian(m,1);
  
  return {
          Prior: Prior, 
          Posterior: m,
          PosteriorPredictive: PredictivePosterior
         };
}

var opts = {method: 'SMC', particles: 2000, rejuvSteps: 5}

var output_1 = Infer(opts, simpleModel)

viz.marginals(output_1)
````
<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/260332.svg" height=200><img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/3777e1.svg" height=200><img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/7e1f19.svg" height=200>

#### Komplexebb modell:

<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/gauss_dogm.png" width=500>


````javascript
var data = [{k: 5},
            {k: 16},
            {k: 17},
           ]

var complexModel = function() {
  
  var m = gaussian(16,0.2);
  
  map(function(d){observe(Gaussian({mu: m, sigma: 1}),d.k)},data);
  
  var Prior = gaussian(16,0.2);
  
  var PredictivePosterior = gaussian(m,1);
  
  return {
           Prior: Prior, 
           Posterior: m,
           PosteriorPredictive: PredictivePosterior};
}

var opts = {method: 'SMC', particles: 2000, rejuvSteps: 5}

var output_2 = Infer(opts, complexModel)

viz.marginals(output_2)

````

<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/8628b1.jpg" height=200><img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/28c592.jpg" height=200><img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/1f1af8.jpg" height=200>

Közös házi:

1.) Készítsük el az alábbiak webppl kódját!

<img src="https://github.com/mozow01/Bayes2024/blob/main/japan.png" height=200>

2.) Egy tengerparton homokos és sóderos partszakasz is van. A sirályok szívesebben időznek a sóderoson. Készítsünk generatív modellt, amelyik generálja az adatokat! Ha el kéne dönteni, hogy egy létező jelenség-e, akkor milyen két modellt ütköztetnénk?

````
var model = function() {
  
  var i = categorical({ps:[0.5,0.5], 
                            vs: ['modell', 'null modell']});
   
  
  var p = (i==="modell") ? beta(10,1) : beta(50,50);
  
    observe(Binomial({p : p, n: 20}), 15);

return {i: i, p : p};
};

var output = Infer({model: model, samples: 1000, method: 'MCMC'});

viz.marginals(output);
````

