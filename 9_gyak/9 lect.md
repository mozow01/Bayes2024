# Gráfmodellek

A gráfmodell alapjául szolgáló $G$ irányított körmentes gráf (DAG) egy speciális címkézett osztályba tartozik. A **bekarikázott** csúcsok valószínűségi változókat reprezentálnak (általában elég ezeket feltüntetni), a **bekarikázatlanok** (vagy pontok) determinisztikus paramétereket. A **nyilak** a $p(x_1,\ldots,x_K)$ együttes (joint) valószínűség alábbi alakú szorzattá bonthatóságát fejezik ki:

$$\Pr(x_1,\ldots,x_K)=\prod_{i=1}^K \Pr(x_i\mid\text{pa}(x_i))$$

ahol $\text{pa}(x_i)$ az $x_i$ csúcs (közvetlen) szülei. A szorzatban pontosan akkor szerepel a $p(x_k \mid x_i,\ldots,x_j)$ tényező, ha a $G$-ben van $x_i,\ldots,x_j$ pontjaiból $x_k$-ba mutató nyíl. A **besatírozott** csúcsok olyan valószínűségi változók, amelyek a **megfigyelt változókat (adatokat) reprezentálják.** A **nem besatírozott** változók a **látens paraméterek.** Tehát $G$ gráfmodellje a $p(x_1,\ldots,x_K)$ joint valószínűségnek, ha a fenti faktorizációs tulajdonság teljesül.

A faktorizációs tulajdonságot ténylegesen jelezni tudjuk a **faktorpontokkal.** Ekkor pontosan akkor köti össze egy faktorpont a gyerekeket és szülőket, ha ezektől függ a gyerek.

## Diszkrét hierarchikus modell (évszak és vizes fű)

A *generatív modell* (azaz egy "randomoutput(randominput)" algoritmikus függvény) öt valószínűségi változóból áll elő: "évszak" ($h$) (tavasz/nyár/ősz/tél), "felhős" ($f$) (derűs/enyhén felhős/erősen felhős), "locsolórendszer" ($l$) (megy/nem megy), "eső" ($e$) (esik/nem esik), "vizes a fű" ($v$) (vizes/nem vizes). Ezek az alábbi gráf alapján függnek egymástól (a faktorok valóban azt jelzik, hogy a joint valószínűség hogyan bomlik szorzattá).

<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/locsolo_1.png" width=600>

És a WebPPL kód:

```javascript
var vizesModel = Infer({ method: 'enumerate' }, function(){
  var évszak = categorical({ps:[0.25,0.25,0.25,0.25], 
                            vs: ['tavasz', 'nyár', 'ősz', 'tél'] });
  
  var felhős = ((évszak === 'tavasz') || (évszak === 'ősz' )) ? flip(0.9) : flip(0.5);
  
  var esik = felhős ? flip(0.8) : flip(0.0);
 
  var locsoló = felhős ? flip(0.1) : flip(0.9);
  
  var vizes = (esik && locsoló) 
                   ? flip(0.99)  
                   : ((esik && !locsoló) || (!esik && locsoló)) 
                        ? flip(0.9) 
                        : flip(0.1);
                        
  condition(vizes === true);
  
  var évszakPrior = categorical({ps:[0.25,0.25,0.25,0.25], 
                            vs: ['tavasz', 'nyár', 'ősz', 'tél'] });
  
  var felhősPrior = ((évszakPrior === 'tavasz') || (évszakPrior === 'ősz' )) ? 
      flip(0.9) : flip(0.5);
  
  return {
      évszakPrior: évszakPrior, 
      felhősPrior: felhősPrior,
      évszakPost: évszak, 
      felhősPost: felhős  
  };
});

viz.marginals(vizesModel)
```

Itt "évszak" előtt van egy konstans csúcs, ami a kategorikus változó eloszlásának adatait (hogy egyenletes) tartalmazza. Ezek a paraméterek azonban rögzítettek.

Múlhatatlanul fontos a Bayes-tétel:

$$\Pr(\vartheta)\;\leadsto\;\Pr(\vartheta\mid X )=\frac{\Pr(X\mid \vartheta)\cdot \Pr(\vartheta)}{\Pr(X)}$$

Vagy konkrét értékekre:

$$\Pr(\vartheta=t\mid X=d )=\frac{\Pr(X=d\mid \vartheta=t)\cdot \Pr(\vartheta=t)}{\Pr(X=d)}$$

Itt:
* $\Pr(\vartheta \mid X)$ a **poszterior eloszlás,** * $\Pr(X \mid \vartheta)$ a **likelihood függvény,**
* $\Pr(\vartheta)$ a **prior eloszlás,**
* $\Pr(X)$ az **adat valószínűsége** (evidencia).

Ez utóbbi kettő marginális eloszlás: 

$$\Pr(\vartheta=t) = \sum_x \Pr(\vartheta=t, X=x)$$
$$\Pr(X=d) = \sum_t \Pr(\vartheta=t, X=d)$$
 
Bizonyítás:

$$\Pr(\vartheta=t,X=d)=\Pr(\vartheta=t\mid X=d )\cdot \Pr(X=d)$$
$$\Pr(X=d,\vartheta=t)=\Pr(X=d\mid \vartheta=t )\cdot \Pr(\vartheta=t)$$

És persze az együttes (joint) eloszlásokra igaz, hogy: $\Pr(X,\vartheta)=\Pr(\vartheta,X)$. Q.E.D.

A **példabeli** joint eloszlás faktorizációja tehát a következő (a gráf alapján a feltételes függetlenségeket kihasználva): 

$$p(h,f,l,e,v) = p(v \mid l,e) \cdot p(l,e,f,h)$$
$$= p(v \mid l,e) \cdot p(l \mid f) \cdot p(e \mid f) \cdot p(f \mid h) \cdot p(h)$$

A $p(l,e,f,h) \leadsto p(l,e,f,h \mid v)$ **Bayes-frissítés** végeredménye, azaz a poszterior eloszlást a Bayes-tétel alapján kapjuk:
 
$$p(l,e,f,h \mid v)=\frac{p(v \mid l,e)\cdot p(l \mid f)\cdot p(e \mid f)\cdot p(f \mid h)\cdot p(h)}{p(v)}$$

Itt a **likelihood függvény** $p(v \mid l,e) \cdot p(l \mid f) \cdot p(e \mid f) \cdot p(f \mid h)$ (megadja a generatív modellt), és ez még a priorral való szorzás után sem lesz igazi valószínűségi eloszlás, de az adat rögzítésével arányos lesz azzal. Az arányossági tényező $1/p(v)$, amivel normáljuk a likelihood-prior szorzatot, hogy az eloszlás (tehát 1-re szummázódó) lehessen.

*(A Bayes-inferencia most "kimerítéssel" (enumerate) és "az adat feltételezésével" (condition) működik: a modell az összes eset végigszámolásával számolja ki a marginális eloszlást azzal a feltétellel, hogy adat = vizes.)*

## Konjugált prior

Nyilvánvaló, hogy a **jelenséget** a generatív modell tartalmazza, ami pedig a likelihood függvényt számolja ki valamilyen módon. Az elemzést tovább finomíthatjuk úgy, hogy a prior paramétereit variáljuk. Most a prior egy egyszerű **kategorikus** változó: egy zsákban színes golyók vannak rögzített arányban és egy golyót húzunk belőle. A prior paramétereire tett elméleti feltételezést **hiperpriornak** nevezzük. 

Hogyan választunk hiperpriort (vagy általában priort)?  

Elméletben bárhogy. De ha szép eredményt akarunk, akkor a likelihoodhoz (vagyis az alapjelenséghez) olyan hiperprior eloszlást érdemes választanunk, amivel ha a likelihoodot megszorozzuk, *ugyanolyan családba tartozó* eloszlást kapunk, mint a prior. Ezt hívjuk konjugált priornak. Ez analitikus számításoknál fontos, bár a modern valószínűségi programozásnál (MCMC, SMC) a numerikus közelítések miatt el is térhetünk tőle. 

Például a kategorikus változó számára a konjugált prior a *Dirichlet-eloszlás.* A binomiális változóhoz a *Béta-eloszlás*. A Béta általánosítása a Dirichlet. A Gauss-nak a Gauss.

A locsolós példa ezzel módosítva:

<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/locsolo_2.png" width=600>

És a kód:

```javascript
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
  
  var vizes = (esik && locsoló) 
                   ? flip(0.99)  
                   : ((esik && !locsoló) || (!esik && locsoló)) 
                        ? flip(0.9) 
                        : flip(0.1);
                        
  condition(vizes === true);
  
  var y = dirichlet({alpha: Vector([1/10,2/10,7/10])});
  var y1 = (y.data)[0];
  var y2 = (y.data)[1];
  var y3 = (y.data)[2];
  
  var felhősPrior = categorical({ps:[y1,y2,y3], 
                             vs: ['derült', 'enyhén felhős', 'erősen felhős'] });
  
  return {
      derűsHyperPrior: y1, 
      enyhenHyperPrior2: y2, 
      erösenHyperPrior: y3, 
      felhősPrior: felhősPrior,
      felhősPosterior: felhős  
  };
});

viz.marginals(vizesmasikModel)
```

# Példák

## Binomiális kísérlet különböző méretű csoportokkal

Három különböző csoportban kérdezték meg, hogy a pillangó virág-e, a mért változó értékei a `data` változó alatt találhatók. A két modellben a priorok uniform (nem informatív) és dogmatikus (Béta) eloszlások voltak. 

### Egyenletes prior

<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/binom_1.png" width=500>

```javascript
var data = [{name: 'napocskas', n:20, k:5},
            {name: 'holdacskas', n:23, k:8},
            {name: 'napraforgo', n:19, k:17}
           ];

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
```

Tehát az adatot a **map** környezetbe ágyazva illesztjük be a feltételbe (observe).

### Beta prior

<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/binom_2.png" width=500>

```javascript
var data = [{name: 'napocskas', n:20, k:5},
            {name: 'holdacskas', n:23, k:8},
            {name: 'napraforgo', n:19, k:17}
           ];

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
```

## Aranyhal

Egy aranyhal súlyadatai: $5$, $16$ és $17$ g, három mérés után. Úgy döntünk, hogy ha az átlag a 15-17 sávba esik, akkor átlagos mennyiséget adunk neki, ha kevesebb, akkor többet, ha több, akkor kevesebbet. A kérdés, hogy számtani közepet számoljunk-e (12.7 g) vagy (informatív) priorból dolgozzunk-e. A komplexebb megközelítéshez tudjuk, hogy ezen halfajta súlya ($x$) normál eloszlást mutat, az átlaga 16 g, ennek az adatnak a szórása 0.2 g, továbbá az $x$ normál elszolásának szórása 1 g. 

Ebben a példában, lévén a likelihood folytonos eloszlás, **nem használhatjuk a diszkrét eloszlások feltételeit tartalmazó condition-t,** mert az hajszálpontos értéket ütköztetne egy folytonos sűrűségfüggvénnyel (ami nullával egyenlő). Helyette az **observe** parancs lazít az adatok ütköztetésén (a sűrűségfüggvény adott pontbeli értékét adja a likelihoodhoz). Lásd: [https://webppl.readthedocs.io/en/master/inference/conditioning.html](https://webppl.readthedocs.io/en/master/inference/conditioning.html)

### Megoldás. 

#### Ha a prior uniform: 

<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/gaussunif_1.png" width=500>

```javascript
var data = [{k: 5},
            {k: 16},
            {k: 17}
           ];

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
```

#### Komplexebb modell:

<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/gauss_dogm.png" width=500>

```javascript
var data = [{k: 5},
            {k: 16},
            {k: 17}
           ];

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
```

Közös házi:

1.) Készítsük el az alábbiak webppl kódját!

<img src="https://github.com/mozow01/Bayes2024/blob/main/japan.png" height=200>

```javascript
var earthquakeModel = Infer({ method: 'enumerate' }, function(){
  var earthquake = categorical({ps:[0.1,0.9],
                                vs: ['ex', 'non'] });
 
  // Javítva: A stringek (pl. 'non') önmagukban mind igaz értéknek számítanak JS-ben!
  var radio = (earthquake === 'ex') ? flip(0.8) : flip(0.0);
  var alarm = radio ? flip(0.9461) : flip(0.9);
 
  // condition(alarm == true);
 
  return {earthquake: earthquake, radio: radio, alarm: alarm};
});

viz.marginals(earthquakeModel)
```

2.) Egy tengerparton homokos és sóderos partszakasz is van. A sirályok szívesebben időznek a sóderoson. Készítsünk generatív modellt, amelyik generálja az adatokat! Ha el kéne dönteni, hogy egy létező jelenség-e, akkor milyen két modellt ütköztetnénk?

```javascript
var model = function() {
  
  var i = categorical({ps:[0.5,0.5], 
                       vs: ['modell', 'null modell']});
   
  var p = (i === "modell") ? beta(10,1) : beta(50,50);
  
  observe(Binomial({p : p, n: 20}), 15);

  return {i: i, p : p};
};

var output = Infer({model: model, samples: 1000, method: 'MCMC'});

viz.marginals(output);
```

## Földrengéses feladat (feltételes függetlenség):

<img src="https://github.com/mozow01/Bayes2024/blob/main/earth_1.png" height=300>

```javascript
print('The Earthquake Model')
var earthquakeModel = function() {
  var earthquake = flip(0.1);
  var Alarm = earthquake ? flip(0.4) : flip(0.05);
  var Radio = earthquake ? flip(0.9) : flip(0.01);
  return {
    Earthquake: earthquake,
    Radio: Radio,
    Alarm: Alarm
  };
};

var distribution = Infer({method: 'enumerate'}, earthquakeModel);
viz.table(distribution);
print('')
viz.auto(distribution);
viz.marginals(distribution);

print('¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨')
print('Conditional Independence Analysis')
print('¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨')
print('Radio-Alarm:')

var probR = Infer({method: 'enumerate'}, function() {
  var outcome = earthquakeModel();
  return {Radio: outcome.Radio};
});
viz.table(probR)

var probR_val = Infer({method: 'enumerate'}, function() {
  var outcome = earthquakeModel();
  return outcome.Radio
});

var probA = Infer({method: 'enumerate'}, function() {
  var outcome = earthquakeModel();
   return {Alarm: outcome.Alarm};
});
viz.table(probA)

var probA_val = Infer({method: 'enumerate'}, function() {
  var outcome = earthquakeModel();
   return outcome.Alarm
});

var jointRA = Infer({method: 'enumerate'}, function() {
  var outcome = earthquakeModel();
  return {JointRA: outcome.Radio && outcome.Alarm}
});
viz.table(jointRA)

print('')
print('P(R=1) = ' + expectation(probR_val).toFixed(6));
print('P(A=1) = ' + expectation(probA_val).toFixed(6));
// Zárójel javítva a műveleti sorrend miatt!
print('P(R=1) * P(A=1) = ' + (expectation(probR_val) * expectation(probA_val)).toFixed(6));
print('JointRA = ' + 0.03645); // P(R=1, A=1)|P(E=1) + P(R=1, A=1)|P(E=0)

var probjointRA = 0.03645;
var probRadio = 0.099;
var probAlarm = 0.085;
var productOfMarginals = probRadio * probAlarm;

print('Checking if P(JointRA) = P(R=1) * P(A=1): ' + probjointRA + ' = ' + probRadio + ' * ' + probAlarm + ' ≠ ' + productOfMarginals.toFixed(6));
var conditionalIndependence = (probjointRA === productOfMarginals) ? "Yes" : "No";
print('Conditional Independence between Radio and Alarm? ' + conditionalIndependence);

print('¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨')
print('Earthquake-Radio-Alarm:');

var distributionERA = Infer({method: 'enumerate'}, earthquakeModel);
var pE1 = expectation(distributionERA, function(s) { return s.Earthquake ? 1 : 0; });
var pE1R1A1 = expectation(distributionERA, function(s) { return s.Earthquake && s.Radio && s.Alarm ? 1 : 0; }) / pE1;
var pE1R1A0 = expectation(distributionERA, function(s) { return s.Earthquake && s.Radio && !s.Alarm ? 1 : 0; }) / pE1;
var pE1R0A1 = expectation(distributionERA, function(s) { return s.Earthquake && !s.Radio && s.Alarm ? 1 : 0; }) / pE1;

var results =  [
    { Scenario: 'P(E=1, R=1, A=1)', Probability: pE1R1A1.toFixed(2) },
    { Scenario: 'P(E=1, R=1, A=0)', Probability: (pE1R1A1 + pE1R1A0).toFixed(2) },
    { Scenario: 'P(E=1, R=0, A=1)', Probability: (pE1R1A1 + pE1R0A1).toFixed(2) }
];
viz.bar(results);  

print('')
print('P(R=1, A=1 | E=1) = ' + pE1R1A1.toFixed(2));
var probR_cond = (expectation(distributionERA, function(s) { return s.Earthquake && s.Radio ? 1 : 0; }) / pE1).toFixed(2);
var probA_cond = (expectation(distributionERA, function(s) { return s.Earthquake && s.Alarm ? 1 : 0; }) / pE1).toFixed(2);

var productOfMarginalsCond = probR_cond * probA_cond;
print('Checking if P(R=1,A=1|E=1) = P(R=1|E=1) * P(A=1|E=1): ' + pE1R1A1.toFixed(2) + ' = ' + probR_cond + ' * ' + probA_cond + ' = ' + productOfMarginalsCond.toFixed(2));
var condIndepE = pE1R1A1.toFixed(2) === productOfMarginalsCond.toFixed(2) ? "Yes" : "No";
print('Conditional Independence between Radio and Alarm given Earthquake? ' + condIndepE);
```

## Közös mu, sigma inferencia

```javascript
// Megfigyelt adatok
var data = [8.0, 9.5, 10.1, 9.8, 9.9];

var model = function() {
  var mu = gaussian(0, 10);

  // Precízió (prior), majd szórás számítása
  var tau = gamma(1, 1);                  // prior a precízióra
  var sigma = 1 / Math.sqrt(tau);         // ebből számoljuk a szórást

  // Megfigyelések
  map(function(x) {
    observe(Gaussian({mu: mu, sigma: sigma}), x); // csak sigma megengedett!
  }, data);

  return {mu: mu, sigma: sigma, tau: tau};
};

viz(Infer({method: 'MCMC', samples: 1000}, model));
```
