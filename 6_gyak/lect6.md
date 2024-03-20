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


