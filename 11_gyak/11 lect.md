# Bayes-faktor

## Modell összehasonlítás és esetei

Modellek összehasonlítását egyszerűen úgy csináljuk, hogy építünk egy nagy hierarchikus modellt, ahol a modell paramétere az egyik hiperprior. Ez nagyon hasznos lesz a Bayes-faktor kiszámításánál

<img src="https://github.com/mozow01/Bayes2024/blob/main/modcomp_1.png" height=300>

## Bayes-faktor

Két modell versengésének eredményét úgy mérhetjük, ha megnézzük, hogy az adatok milyen valószínűek a két modellben:

$$BF_{12}=\dfrac{\Pr(D\mid m_1)}{\Pr(D\mid m_2)}$$

Ha azt az értelmezés vesszük, hogy a $(\vartheta, X, m)$ jointtal van dolgunk, ahol $\vartheta$ a látens paraméter, $X$ a megfigyelt változó, $m$ a modell hiperparaméter, akkor a fenti mennyiségek:

$$\Pr(D\mid m_i)=\sum\limits_{\vartheta}\Pr(D,\vartheta\mid m_i)=\sum\limits_{\vartheta}\Pr(D\mid\vartheta,m_i)\Pr(\vartheta\mid m_i)$$

az adatoknak a "prediktív priorokba" való behelyettesíése (emlékezzünk: a prior eloszlás a látens értékeit adja vissza, a prediktív prior a megfigyelt értékek eloszlását adda vissza az adott látens eloszlás mellett). A BF számítás úgy nevezett _ex ante_ ("az előzetesből") kiszámított mennyiség, azaz a posterior kiszámítása előtti mennyiség.

A generatív modellből a látens m-et inferálhatjuk a D adat mellett. Ez a szokásos út, de akkor hogyan lesz ebből BF? A Bayes-faktort a generatív modell programjának lefutása utáni adatokból is kiszámíhtahjuk, ha felhasználjuk a Bayes-tételt:

$$\Pr(m_i\mid D)=\frac{\Pr(D\mid m_i)\Pr(m_i)}{\Pr(D)}\quad\left(=\frac{\Pr(D\mid m_i)\Pr(m_i)}{\sum\limits_{m_i}\Pr(D \mid m_i)\Pr(m_i)}\right)$$

Innen, a $\Pr(D)$ közös normálási faktort kiejtve:

$$\frac{\Pr(m_1\mid D)}{\Pr(m_2\mid D)}=\underset{BF_{12}}{\underbrace{\frac{\Pr(D\mid m_1)}{\Pr(D\mid m_2)}}}\frac{\Pr(m_1)}{\Pr(m_2)}$$

Tehát ha a modellek priorjait 50-50%-ra állítjuk be, akkor a modellek poszterior eloszlása (arányként kifejezve), a BF-et adja.

Az alábbi táblázat (az egyik olyan amiben) a BF értékek szerint látható, hogy m<sub>1</sub> mennyire magyarázza a jelenséget a megfigyelt változó ismeretében, mint m<sub>2</sub>.

|K|Az m<sub>1</sub> melletti bizonyíték erőssége|
|---|---|
|... < 10<sup>0</sup>= 1| Negatív: m<sub>1</sub> elvetendő|
|10<sup>0</sup> < ... < 10<sup>1/2</sup>=3.16| Alig érdemes említeni| 
|10<sup>1/2</sup> < ... < 10<sup>3/4</sup>=6| Anekdotikus| 
|10<sup>3/4</sup> < ... < 10<sup>1</sup>=10| Szubsztanciális (létező) |
|10<sup>1</sup> < ... < 10<sup>3/2</sup>=31.62| Erős|
|10<sup>3/2</sup> < ... < 10<sup>2</sup>=100 | Nagyon erős|
|10<sup>2</sup> < ... | Döntő |

### Egy erős döntési helyzet

* Egy 24 fős átlagos gimnáziumi osztályban a diákok közül 6 válaszolta (25%), hogy nem volt gondja a matekkal. Egy elitgimnáziumban ugyanez a szám 31-ből 17. Két binomiális eloszlást szimuláló modellel élünk. m<sub>1</sub> szerint a prior 0.25 várható értékű (E(X)=a/(a+b)) dogmatikus beta eloszlás (beta(30,90), kis szórás), amellyel azt feltételezzük, hogy tényleg az átlagos gimnázium adja az átlagot, m<sub>2</sub> pedig egyenletes és bármi kijöhetett volna, mert a gimnáziumok között igen nagy eltérések is lehetnek. Melyik modell magyarázza jobban a megfigyelt 7/31 értéket?

Az ordinális skálán működő klasszikus Mann--Whitney-próba p = 0.06-ot ad, azaz határeset, pedig a vak is látja, hogy lényeges eltérés van a két diákcsoport között.

````javascript
var model = function() {
   // var p = uniform(0,1);          //m_2 modell: bármi lehet a p prior eloszlása
var p = beta(30,90);                 //m_1 modell: az átlagos diákok a prior
  observe(Binomial({p : p, n: 31}), 17);

var poszterior_predikativ = binomial(p,31); // ezzel az új p-vel a szimulált adatok

   //var prior_p = uniform(0,1);
   var prior_p =  beta(30,90); // érintetlen paraméter

var prior_predikativ = binomial(prior_p,31); // érintetlen paraméterből szimulált adatok

return {
       Prior: prior_p, 
       Posterior : p,
       PredictivePrior : prior_predikativ,
       PredictivePosterior : poszterior_predikativ};
};

var output = Infer({model: model, samples: 10000, method: 'MCMC'});

viz.marginals(output);
````

A konkrét példába, a program lefutását követően, az adatokból: P(17|M<sub>1</sub>), P(17|M<sub>2</sub>) kiszámítása után: BF=P(17|m<sub>2</sub>)/P(17|m<sub>1</sub>)=

BF = 15,47 > 10

azaz a próba **erősen** m<sub>2</sub>-t részesíti előnyben és az m<sub>1</sub> erősen elvetendő. Tehát az elitgimnáziumi érték nagyon nem vehető olyannak, ami egy véletlenül adódó átlagos gimnáziumi osztály eredménye lehetne.

<img src="https://github.com/mozow01/cog_compsci/blob/main/orak/files/ketevi_1.png" width=600>

### Anekdotikus döntési helyzet

* A fenti kérdés az absztrakt matematikai jelölések megértésére vonatkozott. Ugyanebben a mérésben a 24 átlagos gimnazista közül 11 mondta, hogy a "hagyományos" matekkal nem volt gondja. A 31 elitgimnazista között ez a szám 19. Mennyire tartható a m<sub>1</sub> (mutatis mutandis)?

Ebben az esetben legyen m<sub>1</sub> priorja beta(30,55), ami a 11/24 várható értéknek felel meg. Az adatok alapján:

P(19|m<sub>2</sub>)/P(19|m<sub>1</sub>) = 4.32

azaz az egyenletes eloszlás még mindig jobban magyaráz, de már csak **anekdotikusan**, a 3.16 <BF < 6. Különbség tehát kimutatható, de már messze nem olyan hihetően, mint az előbb.


## Kullback--Leibler-divergencia

Az **információ** intuitív értelmezése a "meglepettség" (surprisal, információtartam). Egy esetmény információtartalma annál nagyobb, minél kevesebbszer forul elő. Ha még azt is feltesszük, hogy ez a mennyiség a p(x) vsz-eken folytonosan operáljon egy f függvény által és teljesítse független A és B események esetén az

$$I(A\cdot B)=f(\Pr(A\cdot B))=f(\Pr(A))+f(\Pr(B))=I(A)+I(B)$$

összefüggést, akkor f-nek a logaritmussal arányosnak kell lennie, mert a logaritmus csinál összegből szorzatot (a "csak akkor" rész is igazolható). Tehát:

$$I(X=x)=-\log_2 \Pr(X=x)=\log_2\frac{1}{\Pr(X=x)}$$

Ennek várható értéke, azaz az eloszlás átlagos információtartalma az **entrópia**

$$H(X)=-\sum\limits_x \Pr(X=x)\cdot \log \Pr(X=x)$$

Hogy az átlagos információtartalom az egyik eloszlásról a másikra áttérve hogyan változik, azt a relatív entrópia vagy más néven a Kullback--Leibler-divergencia határozza meg:

$$D_\text{KL}(P \parallel Q) = -\sum\limits_x P(x)\log\left(\frac{Q(x) }{P(x)}\right)=-\sum\limits_x P(x) \log\left(Q(x)\right)-$$

$$\sum\limits_x P(x)\log\left(\frac{1 }{P(x)}\right)=$$

$$=-\sum\limits_x P(x) \log\left(\frac{Q(x)}{P(x)}\right)-H(P)=H(P,Q)-H(P)$$

Bayesiánus nyelven kifejezve $D_\text{KL}(P \parallel Q)$ az a mérőszám, amely azt mutatja meg, hogy mennyi információ keletkezik abból, hogy a prior $Q$-t frissítve áttérünk a poszterior $P$-re. Más szóval ez az információmennyiség mutatja, mennyi információ veszett el, amikor a $Q$-t használtuk a $P$ korábbi közelítésére.
