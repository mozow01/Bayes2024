# Frekventizmus és bayesianizmus

## Előzetes összevetés

### Mintapélda (törpehörcsi)

Van egy törpehörcsögünk, amelyikről azt gyanítjuk, hogy rendellenesen fogy. A súlya (tömege :) ) elméletileg egy 22 g közepű 1 g-os szórású normál eloszlás (haranggörbe). El kéne dönteni, hogy orvoshoz kell-e vinni. 

![Csofi](https://github.com/mozow01/Bayes2024/blob/main/1_gyak/horcsi.jpeg)

#### Klasszikus frekventista megközelítés

- **Nullhipotézis (H0):** A törpehörcsög egészséges, vagyis súlya [![\\ \mu = \mu_0](https://latex.codecogs.com/svg.latex?%5C%5C%20%5Cmu%20%3D%20%5Cmu_0)](#_) (ahol [![\\ \mu_0](https://latex.codecogs.com/svg.latex?%5C%5C%20%5Cmu_0)](#_) az elvárt átlagos súly).
  
- **Alternatív hipotézis (H1):** A törpehörcsög súlya rendellenesen alacsony, tehát [![\\ \mu < \mu_0](https://latex.codecogs.com/svg.latex?%5C%5C%20%5Cmu%20%3C%20%5Cmu_0)](#_).

Ez egy egyoldali próba, mivel csak az érdekel bennünket, hogy a súly rendellenesen alacsony-e.

- **Statisztikai teszt típusa:**

t-próbát választunk, mert a populációs szórás ismeretlen, és a minta mérete kisebb mint 30. A tesztstatisztika a következő lenne:

[![\\ t = \frac{\bar{x} - \mu_0}{s/\sqrt{n}}](https://latex.codecogs.com/svg.latex?%5C%5C%20t%20%3D%20%5Cfrac%7B%5Cbar%7Bx%7D%20-%20%5Cmu_0%7D%7Bs%2F%5Csqrt%7Bn%7D%7D)](#_)

ahol:
- [![\\  \overline{x}](https://latex.codecogs.com/svg.latex?%5C%5C%20%20%5Coverline%7Bx%7D)](#_) a mintaátlag,
- [![\\ \mu_0](https://latex.codecogs.com/svg.latex?%5C%5C%20%5Cmu_0)](#_) az elvárt populációs átlag,
- _s_ a mintaszórás,
- _n_ a minta mérete (javasolt mérési szám: 10 mérés).

Ezt a tesztstatisztikát hasonlítjuk össze a t-eloszlás kritikus értékével az alfa szignifikanciaszinten (0.05). Ha a t-eloszlás kritikus értéke alacsonyabb a számított t-értéknél (p < alfa), akkor elutasítjuk a nullhipotézist, tehát megállapítjuk, hogy a törpehörcsög súlya kívül esik az elfogadható határon (rendellenesen alacsony). Ellenkező esetben nem áll fenn rendellenesség a súlyával kapcsolatban.

#### Naiv, álnaiv kérdések

1. Értem, hogy a súly haranggörbe, mert nem vagyok hülye, de akkor mi az a t statisztika? (Hogy kerül a csizma az asztalra?) 
2. Mennyiben "betegesen" rendellenes egy [![\\ \mu < \mu_0](https://latex.codecogs.com/svg.latex?%5C%5C%20%5Cmu%20%3C%20%5Cmu_0)](#_) érték? Miért ez az alternatív hipotézis? Miért nem mondjuk az, hogy 17 g +- 1 g ? 
3. A próba alapján két választ kaphatok: A) nem vethető el a nullhipotézis, B) elvethető a nullhipotézis. Egyik esetben sem a minket érdeklő "kérdésre" kapunk választ.
4. Mi az a képlet? Jelent valamit vagy nem jelent semmit? (Miért kell statisztikusnak lennem?)
5. Tudom, hogy a próba annál jobb, minél többször mérem a hörcsit. Miért kéne nyaggatni szegényt mondjuk 100 méréssel egy értelmezhetetlen eredmény miatt?

### Bayes-féle megközelítés

Csofi súlya egy bizonytalan érték és ezt komolyan kell venni. Két dolgot tudunk, hogy Gauss(22,1) egy egészséges állat súlya, Gauss(17,1) egy betegé. Csofi a mérések alapján 19, 18, 18 g. Ez eléggé leszűkíti a lehetősőgeket. Ha kiszórjuk azokat a szcenáriókat, amelyekben ezek a számok nagyon pici valószínűségűek, akkor egy olyan eloszlást kapunk a súlyára, amelyik közel állhat a valósághoz. 

````javascript
var data = [{k: 19},
            {k: 18},
            {k: 18},
           ]

var Model = function() {
  
  var m = gaussian(22,10)
  
  map(function(d){observe(Gaussian({mu: m, sigma: 1}),d.k)},data);
  
  var PriorPredictive1 = gaussian(22,1);
  var PriorPredictive2 = gaussian(17,1);
  var PosteriorPredictive = gaussian(m,1);
  
  return { 
          PriorPredictive1: PriorPredictive1, 
          PriorPredictive2: PriorPredictive2, 
          Posterior: m,
          PosteriorPredictive: PosteriorPredictive
         };
}

var opts = {method: 'SMC', particles: 1000, rejuvSteps: 5}

var output_1 = Infer(opts, Model)

viz.marginals(output_1)
````

![CsofiPriorPred1](https://github.com/mozow01/Bayes2024/blob/main/1_gyak/a43e23.svg)

![CsofiPriorPred2](https://github.com/mozow01/Bayes2024/blob/main/1_gyak/ab9c7c.svg)

![CsofiProsteriorPred](https://github.com/mozow01/Bayes2024/blob/main/1_gyak/b4c381.svg)

![CsofiPosterior](https://github.com/mozow01/Bayes2024/blob/main/1_gyak/98af7d.svg)


### Összevetés

|                   | Frekventista statisztika                             | Bayesiánus statisztika                                 |
|-----------------------------|------------------------------------------------------|------------------------------------------------------|
| Alapelvek                   | Egyetlen matematikailag kifundált mintatérből vesz mintákat és ezek alapján következtet. | Előzetes tudással (prior), adattal (megfigyelt változó) és adatfelvétel után levont (poszterior)  következtetésekkel dolgozik. |
| Előzetes elvárások          | Nem utal előzetes tudásra, csak a mintavételezéskor keletkező mintára összpontosít. Az előzetes tudás tacit. | Bevezeti a prior elvárásokat, amelyek a kezdeti ismereteket és hozzáértést tükrözik. Explicit előzetes tudással dolgozik.                |
| Paraméterek értelmezése     | A paraméterek fix értékek, amelyek ismeretlenek, de konstansok.                                | A paraméterek valószínűségi eloszlások formájában jelennek meg.  |
| Bizonytalanság kezelése      | A bizonytalanságot konfidencia intervallumokkal fejezi ki, az intervallum végpontjai egyfajta kétpontú pontbecslés. A 95%-os konfidenciaintervallum azt jelenti, hogy az ismeretlen paraméter 95%-os valószínűséggel található meg a kiszámított tartományban.                                             | A paraméternek inherens bizonytalansága van, amit valószínűségi eloszlásos formájában feltételez. Így egy ilyen következtetés nem pontszerű, hanem eloszlást ad vissza. Ennek legsűrűbb intervalluma a 95%-os HDI.   |
| Adatkövetelmény              | Gyakran nagy mintaméretet igényel, hogy az eredmények stabilak legyenek.                                  | Használható kis minta esetén is, mivel a prior tudás rásegít az adatokra. |       
| Adatfeldolgozás              | Kész analitikusan levezetett képletek a számítógép előtti korból, normalitási, függetlenségi feltételekkel. Táblázatokra, statisztikusi tapasztalatra hivatkozik.                            | Egységes elméleti keretrendszert ajánl fel: előzetes tudás + aktuális adat -> aktuális tudás, számítógéppel számolja a következtetéseket. |                        |
|  Jelenségek modellezése              | Mintavételzési eljárásokkal dolgozik.  | Igazodik a természettudományos, valódi kísérletekhez, ezeket formalizálja, explicitté teszi.    |               
| Interpretáció               | Gyakran konfidencia intervallumokkal és hipotézisvizsgálatal dolgozik, amelyek értelmezése nehézkes, körmönfont.  | A valószínűségi értelmezés miatt könnyebb értelmezni a statisztikai eredményeket.                   |

## Sample space vs. possibilities - tudománymódszertani-filozófiai kérdések

Adott egy érme, amelyikről meg szeretnénk állapítani, hogy cinkelt-e. A frekventista megközelítésben legalább két módon tudjuk megállapítani, hogy ez fennáll-e.

A) Dobunk N-szer és megszámoljuk a fejek számát (z). (Ez a binomiális elképzelés.) Ekkor a kimenetelek valószínűségére egy képletet feltételezhetünk (később bebizonyítjuk). Legyen pl. N=24 és z=7. 

![Binom1](https://github.com/mozow01/Bayes2024/blob/main/1_gyak/binom_1.png)

Ez alapján kiszámoljuk a p értékét az adott adatra és a következőt találjuk:

![Binom1](https://github.com/mozow01/Bayes2024/blob/main/1_gyak/binom_2.png)

alfa = 0.05-re (alfa/2 = 0.025) ez még OK! 

B) Annyiszor dobunk, hogy a fejek száma elérje a z-t. (Ez a negatív binomiális elképzelés.) Ekkor a kimenetelek valószínűségére egy képletet feltételezhetünk (ezt nem fogjuk bizonyítani :) ):

![Binom1](https://github.com/mozow01/Bayes2024/blob/main/1_gyak/negbin_1.png)

Ez alapján kiszámolhatjuk a p értékét az adott adatra és a következőt találjuk:

![Binom1](https://github.com/mozow01/Bayes2024/blob/main/1_gyak/negbin_2.png
alfa = 0.05-re ez már nem OK! 

PEDIG! Az adatok nem tudják, milyen SZÁNDÉKKAL dobtuk őket... Nem kell velük közölnünk... Az érme attól függően cinkelt vagy nem cinkelt, hogy mit GONDOLUNK arról, hogy mi a minták tere... Ez abszurd! 

Konklúzió: nincs olyan, hogy "a" p érték; olyan van, hogy őszintén meg kell mondani, hogy mi a minták tere, de ilyet nem mindig látunk, csak a próbát és a p értéket adják meg, ami inkorrekt.

![Binom1](https://github.com/mozow01/Bayes2024/blob/main/1_gyak/bin.png)

