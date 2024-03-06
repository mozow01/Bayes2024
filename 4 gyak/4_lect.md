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
