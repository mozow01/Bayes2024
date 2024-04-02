## 1.

````javascript
var feature1 = ['könyvtáros','tanár'];
var feature2 = ['csendes','cserfes'];
var operator = [' és ',' vagy '];

var SimpleModel = function() {
    var word1 = uniformDraw(feature1)
    var op = uniformDraw(operator)
  
    var word2  = uniformDraw(feature2)
    print('Premissza: Anna ' + word1 + op + word2 + '.'); 
    var word3 = uniformDraw(feature2)
    print('Konklúzió: Anna ' + word3 + '.'); 
    var ervenyes = (op == ' és ')
                   ? ((word2 == word3) ? 'érvényes' : 'nem érvényes') 
                   : 'nem érvényes'
    print(ervenyes); 
    return ervenyes
}
 
var output = 
  Infer({model: SimpleModel, method:'rejection', samples: 1})
````

**1.1** Írj következtetésre olyan ````ComplexModel1````-et, ami ilyen premisszákat generál véletlenszerűen: Panni "könyvtáros/tanár" "és/vagy" "csendes/cserfes" és ebből logikailag helyesen következtetne olyan konklúzióra, hogy "Panni csendes/cserfes", DE! sajnos diszlexiás az ágens és a "csendes/cserfes"-t valamilyen valószínűséggel felcseréli.

**1.2** Írj következtetésre olyan ````ComplexModel2````-t, ami ilyen premisszákat tartalmaz: Panni "könyvtáros/tanár" "és/vagy" "csendes/cserfes" és ebből logikailag helyesen következtetne olyan konklúzióra, hogy "Panni csendes/cserfes" ill. "Panni könyvtáros/tanár", DE! az "és"-t 95%-ban a klasszikus logikának megfelelően használja, de elég gyakran, 80%-os valószínűséggel néha a vagy-ot és-nek olvassa. Vö.: "Jaj! valami ördög... vagy ha nem, hát... kis nyúl!".

**1.3** Programozz be egy olyan modellt, ami kiszámolja, hogy mi annak a valószínűsége, hogy ha két kockával dobunk, akkor az összeg legalább 4 lesz!

**1.4** (King-Ace Paradox, bemelegítő) Tudjuk, hogy a klasszikus logikában a "Ha ász van a kezemben, akkor király van, **vagy** ha nincs ász a kezemben, akkor király van a kezemben" mondatból nem következik feltétlenül, hogy király van a kezemben (miért?), sőt, ha a mondatban szereplő "vagy"-ot kizáró vagy értelemében használjuk, akkor kifejezetten az következik belőle, hogy nincs király a kezemben. Írj programot, ami a helyzetet modellezi úgy, hogy a mondatbeli "vagy" **jelentése** néha "és" néha "vagy" néha "kizáró vagy". Vö.: The Cambridge Handbook of Computational Psychology, ed.: Ron Sun, 2008, Cambrigde, p. 137.

## 2.

Programozd le Coq-ban a következő állítások bizonyítását:

**2.1.**  

````coq
Lemma problem_1 : forall A B C : Prop, A /\ (B \/ C) -> (A /\ B) \/ (A /\ C).
````

**2.2.**  

````coq
Lemma problem_2 : forall A B C : Prop, ((B -> A) /\ (C -> A)) -> ((B \/ C -> A)).
````

**2.3.** 

````coq
Lemma problem_3 : forall A B : Prop, (A \/ ~A) -> ((A -> B) -> A) -> A.
````

**2.4.** 

````coq
Lemma problem_4 : forall (U : Type) (A B : U -> Prop), (exists x, A x /\ B x) -> (exists x, A x) /\ (exists x, B x).
````

## 3.

**3.1** Írj programot, amelyik kiszámolja, hogy mi annak a valószínűsége, hogy 52 lapos francia kártyából 2 kártyát választva az egyik király, a másik nem király! 

**3.2** Legyen az X Y és Z valószínűség változó olyan, ami az {0, 1, 2, 3} számok közül választ egyenletes valószínűséggel. Legyen W = X + Y + Z, mi az X változó eloszlása, ha tudjuk, hogy W = 7? (Írj programot!)

**3.3** Értsd meg a Monty Hall/vos Savant paradoxon programját!

**3.4** Van egy beépített emberünk a Monty Hall/vos Savant szituációban, aki 50% százalékban helyesen mutogatja el nekünk a színfalak mögül, hogy melyik ajtó mögött van az autó. Szót fogadunk neki, és azt az ajtót választjuk, amit ő javasol. Még mindig érdemes-e azután váltani, hogy Monty megmutatot egy kecskét? A választ támasszuk alá webppl programmal!

