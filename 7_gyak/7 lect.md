## Feltételes valószínűség

Valószínűségi változók függhetnek egymástól.

**Példa**

X = pénzérmével fej vagy írás (boole (1|0) értékű változó (0.5, 0.5) kategorikus eloszással)

Y = királyt húzása (1|0) magyar kártyávól, akkor és csak akkor, ha X = 1, és francia kártyából, ha X = 0.

|      |  X=1   | X=0 |  
| ---  | --- | --- | 
|  Y=1, ha X = ... |  1/8 | 1/13 | 
|  Y=0, ha X = ... | 7/8 | 12/13  | 

**Megjegyzés.** Ez a táblázat ilyenkor csak X rögzítésével lesz "igazi" eloszlás. A mögöttes eloszlás Y, azaz a "király húzása" csak közvetetten tudható. 

**Definíció** (Leszűkítjük az elemi események terét a feltételre, az A eseményt teljesítő elemi részeseményekre, azaz innentől nem Ω, hanem A az összes elemi események tere: )

<img src="https://render.githubusercontent.com/render/math?math=P(B%7CA)%5Coverset%7B%5Cmathrm%7Bdef.%7D%7D%7B%3D%7D%5Cdfrac%7BP(A%5Ccap%20B)%7D%7BP(A)%7D%5Cquad%20%5Cquad%20P(A)%5Cneq%200">

P(B|A) -t úgy mondjuk ki, hogy B valószínűsége feltéve, hogy A (probability of B given A).

````javascript
var model5 = function () {
    var X = flip()
    var Y = flip( X ? 1/8 : 1/13)
    return  {'X,Y': [X , Y]}
}

var Z = Infer({method: 'enumerate', model: model5})

viz(Z)
````

Ekkor P(X=i,Y=j) = P(Y=j|X=i) P(X=i), azaz pl.: P(X=1,Y=1) = 1/8 * 1/2.

Ekkor (X,Y) eloszlása már igazi, együttes, "joint". 

|      |  X=1   | X=0 |  
| ---  | --- | --- | 
|  Y=1 |  1/16 | 1/26 | 
|  Y=0 | 7/16 | 6/13  | 

## Monty Hall- (vos Savant-) paradoxon

Adott 3 csukott ajtó mögött egy-egy nyeremény: 1 autó és 1-1 plüsskecske. Monty, a showman megkér minket arra, hogy tippeljük meg, hol az autó (ha eltaláljuk, a miénk lesz). Amikor ez megtörtént, akkor Monty kinyit egy ajtót, éspedig szigorúan azok közül egyet, amelyek mögött egy kecske van és nem mutattunk rá. Majd felteszi újra a kérdést: hol az autó. Érdemes-e megmásítanunk a döntésünket?

🐑 🐑 🏎

🚪 🚪 🚪

🕺 👋

A feladatot a joint eloszlás feltérképezésével oldjuk meg.
|      |     | Y=1 |     |     | Y=2 |     |     | Y=3 |     | P(X) |
| ---  | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|      | Z=1 | Z=2 | Z=3 | Z=1 | Z=2 | Z=3 | Z=1 | Z=2 | Z=3 |     | 
| X=1  | 0   | 1/18| 1/18| 0   | 0   | 1/9 | 0   | 1/9 |   0 | 1/3 | 
| X=2  | 0   |  0  |1/9  | 1/18   | 0   |  1/18  | 1/9 | 0 |   0 |  1/3| 
| X=3  | 0   | 1/9 |  0 | 1/9   | 0   | 0 | 1/18 | 0  |   1/18 |  1/3 | 
| P(Y) | 0   | 1/3 | 0   | 0   | 1/3 | 0   | 0   | 1/3 |   0 |   1  | 

X a tippünk, Y az autó helye. Először számoljuk ki egy esetben, mi annak a valószínűsége, hogy ugyanazon ajtó mögött van a nyeremény, amire mutattunk. Pl.: P(X=1 és Y=1) = 1/9. Persze ezt mindhárom esetben ki tudjuk számolni, és az eredmény:

P(X=Y) = 1/3

Ez annak az esélye, hogy elsőre eltaláljuk a kedvező ajtót (ez világos is). Annak a valószínűsége, hogy nem a választottunk mögött van az autó:

P(X=/=Y) = 1 - 1/3 = 2/3

De mivel Monty kinyitja a megmaradó kettő közül azt az ajtót, ami mögött nincs autó és nem is mutattunk rá, ezért utólag behatárolja azt a _két_ ajtót, ami mögött az autó van. Nyilván eredetileg nem bökhettünk volna rá két ajtóra, amelyek persze kétszer annyi valószínűséggel rejtik az autót. De most, hogy ebből a kettőből mutatott Monty egy rossz ajtót, már érvényesíthetjük a P(X=/=Y) = 2/3 valószínűségű nyerést egyetlen ajtóra való rámutatással. Ami persze nem jelenti, hogy ott is lesz az autó, de kétszer akkora eséllyel lesz ott, mint nem. 

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




