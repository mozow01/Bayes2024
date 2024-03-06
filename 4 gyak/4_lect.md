# Kombinatorikai, valószínűségi kísérletek modellezése

## Kockadobás

<img src="https://github.com/mozow01/cog_compsci/blob/main/SciCamp/1200px-2-Dice-Icon.svg.png" width=100>

A webppl-ben egy kockadobás kimenetelét egy _függvény_ megírásával lehet előidézni. 

var ... = ... a függvény (vagy érték) definiálása. 

Érdekes, hogy ez egy olyan függvény lesz, aminek a zárójelében nincs semmi :) 

Ez azért van, mert a bemenetét random módon generált értékek fogják szolgáltatni. 

Milyen gyakorisággal jönnek elő ezek az értékek? A ````var kocka1 = categorical({ps: [1/6, 1/6, 1/6, 1/6, 1/6, 1/6], vs: [1, 2, 3, 4, 5, 6]});```` például 1-től 6-ig ad értéket az "első kocka" dobása után leolvasott értéknek 1/6-1/6- stb. valószínűségekkel. A "categorical" azt jelenti, hogy "ps" valószínűségellek jönnek elő a "vs" értékek, véges sok. Amit a "dobás" függvény visszaad (return), az egy rendezett pár ````[kocka1,kocka2]````, ami két dobás eredményét tartalmazza. Ha egy dobás eredményét akarajuk kiíratni, akkor ez a ````print(dobás());```` paranccsal tesszük. Sok dobásnál ez megjeleníhető pl. így: ````var sokdobás = repeat(10, dobás); viz.auto(sokdobás);```` vagy így ````var sokdobás = repeat(10, dobás); print(sokdobás);````. Ill. még sok verzióban (lásd a viz. utáni opciókat). Bővebben: dokumentáció itt: https://webppl.readthedocs.io/en/master/ , vizualizáció itt: http://probmods.github.io/webppl-viz/ és itt: https://github.com/probmods/webppl-viz .


````javascript
// Két kocka

var dobás = function () {
  var kocka1 = categorical({ps: [1/6, 1/6, 1/6, 1/6, 1/6, 1/6], 
                            vs: [1, 2, 3, 4, 5, 6]});
  var kocka2 = categorical({ps: [1/6, 1/6, 1/6, 1/6, 1/6, 1/6], 
                            vs: [1, 2, 3, 4, 5, 6]});
  return  { kockapár: [kocka1,kocka2] };
}

// Egy dobás, a dobás() fv. egy futtatása.

// Sok dobás és gyakorisági táblázata

var sokdobás = repeat(10, dobás); 

print(sokdobás);

viz.auto(sokdobás);

// A [kocka1,kocka2] változó "elméleti" (egzakt) eloszlása az esetek felsorolásával.

var output = Enumerate(dobás);

// A kimenet eloszlásának generálása felsorolással
// var output = Infer({method: 'enumerate', model: dobás});

// Közelítő eloszlás samples db-szori lefuttatással és abból histogram építésével 
// var output = Infer({method: 'forward', samples: 10000, model: dobás});

print("1/36 = " + 1/36);

viz.auto(output);
// viz.hist(output);
// viz.table(output);
````

## Kockadobás kedvező esetekkel

<img src="https://github.com/mozow01/cog_compsci/blob/main/SciCamp/2381778-200.png" width=100>

Mi annak a valószínűsége, hogy két kockával dobva legalább az egyik hatos?

````javascript
var dobás = function () {
  var kocka1 = categorical({ps: [1/6, 1/6, 1/6, 1/6, 1/6, 1/6], 
                            vs: [1, 2, 3, 4, 5, 6]});
  var kocka2 = categorical({ps: [1/6, 1/6, 1/6, 1/6, 1/6, 1/6], 
                            vs: [1, 2, 3, 4, 5, 6]});
  return [kocka1,kocka2];
}

var kedvező_dobás = function () {
  var kocka1 = categorical({ps: [1/6, 1/6, 1/6, 1/6, 1/6, 1/6], 
                            vs: [1, 2, 3, 4, 5, 6]});
  var kocka2 = categorical({ps: [1/6, 1/6, 1/6, 1/6, 1/6, 1/6], 
                            vs: [1, 2, 3, 4, 5, 6]});
  condition((kocka1 == 6 || kocka2 == 6));
  
  return  [kocka1,kocka2];
}

var összes = Infer({method: 'enumerate'}, dobás);

var kedvező = Infer({method: 'enumerate'}, kedvező_dobás);

viz.auto(összes);

viz.auto(kedvező);

print("11/36 = " 
      + 11/36);

print("p = kedvező/összes = " 
      + Math.exp((összes.score)([6,6]))/Math.exp((kedvező.score)([6,6])));
````
//-vel tudjuk kommentbe tolni azokat a sorokat, amiket nem akarunk futtatni. 

Az Infer parancsról majd később, mindenesetre ````var output = Infer({method: 'enumerate', model: dobás});```` ugyanazt csinálja, mint Enumerate. De ````var output = Infer({method: 'forward', samples: 10000, model: dobás});```` már kicsit izgibb: egymás után 10000-szer kiszámolja a dobás függvényt és az adatokból gyakorisági táblázatot készít, majd a gyakoriságokból arányt és így ebből a 10000-es mintából elkészít egy közelítő valószínűségi eloszlást, ami az Enumerate-hez közelít, amennyiben a samples érték feltoljuk. A program valahol a Stanford Egyetemen égeti a szervereket, ne sajnáljuk őket, legfeljebb nem jönnek meg az adatok a Föld kihüléséig. Fizessenek a gazdagok!

Világos, hogy itt egy új parancs készítette el a kedvező esetek leválogatását: ````condition((kocka1 == 6 || kocka2 == 6));````. || a vagy jele a JavaScript-ben, == az értékazonosság, azaz nem értékadó, definiáló egyenlőség (ami a =), hanem állítás-egyenlőség. Ha aziránt érdeklődünk, hogy mikor mindkettő 6-os, akkor ````condition((kocka1 == 6 && kocka2 == 6));```` && hagyományosan az és jele. ````condition((kocka1 == 6 && !(kocka2 == 6) ));```` azt jelenti, hogy az első hatos, a második kifejezetten **nem** hatos. ! a tagadás jele.

<img src="https://github.com/mozow01/cog_compsci/blob/main/SciCamp/277680373_341339591289591_2928453617509407729_n.jpg" width=200>

## Golyók

Lerakunk 5 helyre 2 golyót, úgy, hogy egy helyen, csak 1 golyó lehet egyszerre. Adjuk meg az elemi eseménytér két modelljét és mondjuk meg, hogy mennyi annak az eseménynek a valószínűsége, hogy a) mindkét golyó az első három hely valamelyikén van, b) valamelyik golyó az utolsó 2 hely valamelyikén van.

````javascript
var lerakas1= function () {
  var golyo1_helye = randomInteger(5) + 1;
  var golyo2_helye = randomInteger(5) + 1;
  condition(golyo1_helye !== golyo2_helye);
  return [golyo1_helye,golyo2_helye];
}

var lerakas2 = function () {
  var hely1 = randomInteger(2);
  var hely2 = randomInteger(2);
  var hely3 = randomInteger(2);
  var hely4 = randomInteger(2);
  var hely5 = randomInteger(2);
  condition(hely1+hely2+hely3+hely4+hely5 == 2);
  return [hely1,hely2,hely3,hely4,hely5];
}

var eloszlas_1 = Enumerate(lerakas1)

var eloszlas_2 = Enumerate(lerakas2);

//var inf = Infer({method: 'enumerate'}, dobas);
//print(inf);
//viz.hist(inf);

viz.hist(eloszlas_1);
viz.hist(eloszlas_2)
````


## Kolmogorov-axiómák

(Ω, Σ, P) valószínűségi mező, ha Ω nemüres (elemi események tere), Σ egy σ-algebra (eseménytér), és
1. P : Σ → ℝ, P(A) ≧ 0
2. P(Ω)=1, P(∅)=0
3. ha A, B ∊ Σ egymást _kizáró események_ (A ⋂ B = ∅), akkor P(A ⋃ B) = P(A) + P(B).

További fontos szabályok:

4. _Komplementer-szabály_: P(comp(A)) = 1-P(A)

5. Független események: P(A ⋂ B) = P(A) ⋅ P(B)

6. Logikai szita:  P(A+B) = P(A) + P(B) - P(AB). (néha unió: +, metszet: ⋅)

Eloszlásnak azt nevezzük, ahogy megadjuk P-t. Ez sokféle lehet, de pl. véges esetben az elemi események felsorolása, végtelen esetben sűrűség vagy kumulatív eloszlásfüggvénnyel (később).

## Kártyák

Egy 52 lapos francia kártyapakliból kihúzunk 2 lapot. Mi annak a valószínűsége, hogy a kőr király van a kihúzott lapok között van?

_Rendezetlen modell._ Összes eset: (52 choose 2)

Kedvező esetek: nincsenek a helyek (húzások) megülönböztetve. De szorzás, mert függetlenül választunk az egyetlen kőr király és a többi közül: (1 choose 1)*(51 choose 1)

_Rendezett modell._ Ebben az esetben párokhoz rendelünk valószínűséget, ezt **joint** vagy **többváltozós eloszlásnak** nevezzük. Z = (X,Y), ahol X, Y a két külön kártya tere, amik feletti eloszlás azonban vészesen _összefügg_, mert nem tesszük vissza a kártyát.

|   P(X,Y)   | Y=1 | 2 | ... | 52 | marginális P(X) |
| --- | --- | --- | --- | --- | --- | 
| X= 1           | 0 | 1/(51⋅52) | ... | 1/(51⋅52) | 1/52 |
| 2           | 1/(51⋅52) | 0 | ... | 1/(51⋅52) | 1/52 |
| 3           | 1/(51⋅52) | 1/(51⋅52) | ... | 1/(51⋅52) | 1/52 |
|    ...      | 1/(51⋅52) | 1/(51⋅52) | ... | 1/(51⋅52) | 1/52 |
| 52         | 1/(51⋅52) | 1/(51⋅52) | ... | 0 | 1/52 |
| marginális P(Y)   |  1/52 |  1/52 | 1/52 | 1/52 |  1  |

A kedvező esetek: (X,Y) = (♥K,_ ) vagy (_ ,♥K), így a valószínűség: 1/52 + 1/52 = 1/26. 

Ugyanez webppl-lel:

````javascript
var kartya = function () {
  var szin1 = randomInteger(4) + 1;
  var figura1 = randomInteger(13) + 1;
  var szin2 = randomInteger(4) + 1;
  var figura2 = randomInteger(13) + 1;
  var huzas1 = [szin1,figura1];
  var huzas2 = [szin2,figura2];
  condition(szin1 !== szin2 || figura1 !== figura2);
  return [huzas1,huzas2];
  }

var kedvezo_kartya = function () {
  var szin1 = randomInteger(4) + 1;
  var figura1 = randomInteger(13) + 1;
  var szin2 = randomInteger(4) + 1;
  var figura2 = randomInteger(13) + 1;
  var huzas1 = [szin1,figura1];
  var huzas2 = [szin2,figura2];
  condition((szin1 !== szin2 || figura1 !== figura2) &&
            ((figura1 == 13 && szin1 == 1 ) || (figura2 == 13 && szin2 == 1 )
              ) 
            );
  return [huzas1,huzas2];
}
  
var eloszlas = Enumerate(kedvezo_kartya);

print(eloszlas);

viz.hist(eloszlas);
````

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

Ha tudunk valamit a szituációból, ez az eloszlás változni fog. Pl.: mi akkor X eloszlása, **ha tudjuk,** hogy az első esetben kőrt húzunk. 

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


**2.** Hipergeometrikus eloszlás. 52 lapos francia kártyából húzunk 5 lapot. Mi annak a valószínűsége, hogy a) lesz benne pontosan egy treff, b) legalább egy király?

**3.** Egy iskolában 1000 gyerek tanul és a kompetenciamérésen mindig ugyanaz a 10 gyerek lesz rosszul. A termekbe sorsolják a diákokat. Mi annak a valószínűsége, hogy a Földszint VI-ban kompetenciázó 20 diákból legfeljebb három rosál be (ezek közül)?

**3.** Sokéves átlagban p = 0.02 valószínűséggel lesz egy érettségiző az írásbelin rosszul. Mi annak a valószínűsége, hogy a Soroksári Wass Albert Két-tannyelvű Gimnázium 30 fős 12. C. osztályában legfeljebb 1 ember lesz rosszul.

(Cinkelt és cinkeletlen érmék.)

