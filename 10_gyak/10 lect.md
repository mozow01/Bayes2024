# Hierarchikus modellek

## Bayesiánus belső modellezés

_Bayesiánus modellezésnek_ (vagy belső modellezésnek) nevezzük, amikor azt gondoljuk, hogy az agy egy Bayes-féle következtetést végez el valamely probléma megoldásánál és ezt a modellt építjük fel. (Ehhez képest a _bayesiánus adatelemzés_ csak statisztikai tudományág, a _bayesiánus pszichofizikai elemzés_ pedig az viselkedési jelek bayesiánus adatelemzése.)

## Implikatúrák

Az ilyen komputációs belső modellek egyik mintapéldája egy nyelvi (pszicholingviszikai vagy szociális kommunikációs kogníciós) jelenség variációit magában foglaló _implikatúra_ (implicature) jelensége. _Társalgási implikatúra_ például a következő párbeszéd:

Pisti: "Jössz Géza bulijára?"

Anna: "Dolgoznom kell."

Ez egy nagyon furcsa kommunikációs jelenség, amely a _pragmatika_ területére tartozik, amikor nem elég a szintaxisra (kérdés-válasz) és a szemantikára (szótári jelentésre) gondolnunk az értelmezéshez. 

Az ilyen pragmatikai problémák közé tartozik pl. a _beszédaktusok_ (speech act) problémája is, amelyet Ludwig Wittgenstein, John Austin és John Searl nevéhez köthető (Searl nagyon fontos filozófus az AI kutatásában is!). 

_Skaláris implikatúrnának_ nevezzük a "minden" "valahány" "egy se" ("all", "some", "none") szavak használatában rejlő problémákat.

## RSA modellek

A pragmatikai jelenségek komputációs modellezésének egyik legkorszerűbb eszköze az úgynevezett **RSA elmélet (Rational Speech Act Theory)**, amelyet Noah Goodman és Michael Frank (Stanford CoCoLab, a WebPPL megalkotói) fejlesztettek ki. Az RSA elmélet lényegében a grice-i maximákra és a speech act (beszédaktus) elméletre épülő társalgási implikatúrák komputációs, bayesiánus megfogalmazása.

[https://www.problang.org/chapters/01-introduction.html]

Az RSA modell alapja a **rekurzív (vagy hierarchikus) szociális kogníció**. A kommunikáló felek tudatában vannak annak, hogy a másik fél is racionális ágens, és ezt a tudást beépítik a saját nyelvprodukciós és -megértési folyamataikba. A modell ezt egymásba ágyazott, feltételes valószínűségi eloszlásokkal írja le, három szinten:

1. **A szó szerinti hallgató ($L_0$ - Literal listener):**
   A hierarchia legalsó, szemantikai szintje. Ez az ágens nem végez pragmatikai következtetést, csupán egy szótár alapján értelmezi az $u$ megnyilatkozást (utterance). Frissíti az $s$ világállapotokra (states) vonatkozó a priori eloszlását oly módon, hogy kizárja azokat az állapotokat, amelyekben a megnyilatkozás logikailag hamis (már ha a megnyilatkozás mondat és nem szó).

   $$P_{L_0}(s \mid u) \propto I_{ \llbracket u(s)} \cdot P(s)$$

   (Itt $P(s)$ a világállapotok a priori valószínűsége, $I_{[[u]](s)}$ pedig egy indikátorfüggvény, amelynek értéke 1, ha az $u$ megnyilatkozás szó szerinti jelentése igaz az $s$ állapotban, és 0, ha hamis.)

2. **A pragmatikus beszélő ($S_1$ - Pragmatic speaker):**
   A beszélő célvezérelt, racionális ágensként viselkedik. Ismeri a valós $s$ világállapotot, és egy olyan $u$ megnyilatkozást választ, amely maximalizálja a kommunikáció hasznosságát (utility) a szó szerinti hallgató ($L_0$) felé.

   $$P_{S_1}(u \mid s) \propto \exp\big(\alpha \cdot U(u, s)\big)$$

   (Itt az $\exp(\dots)$ a Softmax-függvény, amely folytonos valószínűségi eloszlássá alakít. Az $\alpha$ a racionalitás, vagy optimalitás paramétere: minél nagyobb, az ágens annál inkább a legoptimálisabb szót választja. A $U(u, s)$ a hasznosság függvény.)
   
   A **hasznosság** információelméleti alapon definiálható: a megnyilatkozás legyen minél informatívabb (csökkentse $L_0$ meglepettségét, azaz minimalizálja a Shannon-féle meglepetést) és egyben a legkisebb nyelvi költséggel járó:
   
   $$U(u, s) = \log P_{L_0}(s \mid u) - C(u)$$
   
   (ahol $C(u)$ a kimondott megnyilatkozás költsége).

3. **A pragmatikus hallgató ($L_1$ - Pragmatic Listener):**
   A valós társalgási partner modellje. $L_1$ megkapja az $u$ megnyilatkozást, és a Bayes-tétel alkalmazásával "megfordítja" a pragmatikus beszélő generatív modelljét, hogy a posteriori valószínűséget rendeljen a rejtett $s$ világállapotokhoz. Azt a kérdést teszi fel magának: *"Melyik az az $s$ világállapot, amelyből egy racionális beszélő a legnagyobb valószínűséggel épp ezt az $u$ kifejezést generálta volna?"*

   $$P_{L_1}(s \mid u) \propto P_{S_1}(u \mid s) \cdot P(s)$$

Ez az információelméleti és játékelméleti alapokra épülő keretrendszer az egyszerű, logikai szabályokkal nehezen leírható pragmatikai jelenségek (mint pl. a skaláris implikatúra) elegáns detektálását és modellezését teszi lehetővé.

<img src="https://github.com/mozow01/Bayes2024/blob/main/Screenshot%20from%202024-05-08%2012-40-42.png" height="300">

Nézzük meg, melyik kódsor melyik egyenletnek feleltethető meg a *Vanilla RSA generative model* implementációjában!

| Szintjelölés | Fogalom / Változó a képletben | Megfelelés a WebPPL kódban | Magyarázat |
| :--- | :--- | :--- | :--- |
| **Priorok** | $P(s)$ | `statePrior()` | A lehetséges világállapotok egyenletes eloszlása. |
| **Priorok** | $C(u)$ | `cost(utterance)` | Az adott megnyilatkozás "ára" (jelen esetben minden szó költsége egységesen 1, vagy 0, ami bünteti a felesleges szavakat). |
| **Szótár** | $\mathcal{I}_{[[u]](s)}$ | `meaning(state)` és `condition(...)` | A `literalMeanings` logikai függvényei; a `condition` gondoskodik a 0-val vagy 1-gyel való szorzásról (lenullázza a hamis ágakat). |
| **$L_0$** | $P_{L_0}(s \mid u)$ | `literalListener(utt)` | Beépített WebPPL inferencia: a lehetséges állapotok szűrése az aktuális $u$ megnyilatkozás logikai igazságértéke alapján. |
| **Utility** | $\log P_{L_0}(s \mid u)$ | `literalListener(utt).score(state)` | A WebPPL-ben a `.score()` metódus pontosan a **log-valószínűséget** (log-probability) adja vissza, ami tökéletesen fedi a $U(u,s)$ információelméleti definícióját. |
| **$S_1$** | $\alpha$ és $\exp(\dots)$ | `factor(alpha * ...)` | A `factor()` függvény módosítja a mintavételek súlyozását: exponenciális transzformációt hajt végre a megadott értéken, az $\alpha$ paraméterrel skálázva. Ezzel létrehozva a racionális szóválasztást. |
| **$L_1$** | $P_{L_1}(s \mid u)$ | `observe(speaker(state), utt)` | A Bayes-tétel alkalmazása: a priorból kiindulva (`statePrior()`) a `speaker` modellt likelihood függvényként használjuk, ráillesztve a megfigyelt $u$ (`utt`) megnyilatkozást. |

## A utility függvényről

Az úgy nevezett agent-action elméletben az ágens egy action-nel reagál a világállapotra, a state-re. Az állapottól függő jutalomfüggvény dönt arról, hogy milyen tevékenységet fog végezni.

````javascript
// define possible actions
var actions = ['a1', 'a2', 'a3'];

// define some utilities for the actions
var utility = function(action){
  var table = {
    a1: -1,
    a2: 6,
    a3: 8
  };
  return table[action];
};

// define actor optimality
var alpha = 1

// define a rational agent who chooses actions
// according to their expected utility
var agent = Infer({ model: function(){
    var action = uniformDraw(actions);
    factor(alpha * utility(action));
    return action;
}});

print("the probability that an agent will take various actions:")
viz(agent);
````

Például az a döntési eljárás, hogy a "melyik kajáldába menjek, ha pizzát akarok enni".

Jelen esetben a utility függvényt információeleméleti módon definiáljuk. A meglepettség függvényt minimalizáljuk: [https://www.problang.org/chapters/app-02-utilities.html] Ehhez pl. a Kullback--Leibler-divergencia a megfelelő mérőszám. [https://en.wikipedia.org/wiki/Kullback%E2%80%93Leibler_divergence]

## "Vanilla" RSA scalar implicature generative model

[https://www.problang.org/chapters/02-pragmatics.html]

````javascript
// possible states of the world
var states = [0, 1, 2, 3]
var statePrior = function() {
  return uniformDraw(states)
}

// possible utterances
var utterancePrior = function() {
  return uniformDraw(['all', 'some', 'none'])
}

// cost function for utterances
var cost = function(utterance){
  utterance == "all" ? 1 :
  utterance == "some" ? 1 :
  utterance == "none" ? 1 :
  0
}

// meaning function to interpret the utterances
var literalMeanings = {
  all: function(state) { return state === 3; },
  some: function(state) { return state > 0; },
  none: function(state) { return state === 0; }
}

// literal listener
var literalListener = cache(function(utt) {
  return Infer({model: function(){
    var state = uniformDraw(states)
    var meaning = literalMeanings[utt]
    condition(meaning(state))
    return state
  }})
})

// set speaker optimality
var alpha = 1;

// pragmatic speaker
var speaker = cache(function(state) {
  return Infer({model: function(){
    var utt = utterancePrior()
    factor(alpha * (literalListener(utt).score(state) ))
    return utt
  }})
})

// pragmatic listener
var pragmaticListener = cache(function(utt) {
  return Infer({model: function(){
    var state = statePrior()
    observe(speaker(state),utt)
    return state
  }})
})

var i = 'some'

display("pragmatic listener's interpretation of "+i)
viz(pragmaticListener(i))
display("literal listener's interpretation of "+i)
viz(literalListener(i))
````

## Kiértékelés

### 1

````javascript
// worldPrior: meghatározza a 
// lehetséges "világállapotokat" és azok a priori valószínűségét.
var worldPrior = function() {
  var num_nice_people = randomInteger(4); // 0, 1, 2, vagy 3 kedves ember
  return num_nice_people;
};

// utterancePrior: meghatározza a lehetséges "kijelentéseket", "megnyilatkozásokat",
// amiket a beszélő mondhat, és azok a priori valószínűségét.
var utterancePrior = function() {
  var utterances = ['some of the people are nice',
                    'all of the people are nice',
                    'none of the people are nice'];
  return uniformDraw(utterances); // Egyszerűbb módja a választásnak
};

// meaning: meghatározza egy kijelentés literális (szó szerinti) jelentését. Igaz 
// értéket ad vissza, ha a kijelentés szó szerint igaz az adott világállapotban, 
// egyébként hamisat.
var meaning = function(utt, world) {
  return (utt == 'some of the people are nice' ? world > 0 :
          utt == 'all of the people are nice' ? world == 3 :
          utt == 'none of the people are nice' ? world == 0 :
          true); // Elvileg ide nem jutunk
};

// L0 - Literális hallgató
// literalListener (L0): modellezi azt a hallgatót, aki szó szerint értelmezi 
// a hallott kijelentést. Kiszámolja a lehetséges világállapotok valószínűségi
// eloszlását adott egy kijelentés.
var literalListener = cache(function(utterance) {
  return Infer({method: 'enumerate'}, function() {
    var world = worldPrior();
    condition(meaning(utterance, world)); // Csak az igaz jelentésű világok maradnak
    return world;
  });
});


// S0 - Literális beszélő speaker
// Ez a beszélő az adott világállapotban igaz kijelentések közül választ 
// (egyenlő eséllyel).
var literalSpeakerS0 = cache(function(world) {
  return Infer({method: 'enumerate'}, function() {
    var utterance = utterancePrior();
    condition(meaning(utterance, world)); // Csak az igaz kijelentéseket vesszük
    // figyelembe
    return utterance;
  });
});

// S1 - Pragmatikus beszélő: modellezi a pragmatikus beszélőt,
// aki úgy választ kijelentést, hogy az a lehető leginformatívabb legyen
// a literális hallgató (L0) számára az adott (valós) világállapot (world)
// szempontjából.
var pragmaticSpeakerS1 = cache(function(world) {
  return Infer({method: 'enumerate'}, function() { // Válthatunk enumerate-re, 
    //mert kicsi a tér
    var utterance = utterancePrior();
    var listenerBeliefs = literalListener(utterance);
    // Optimalizálási cél: maximalizálni P(world | utterance) valószínűséget
    // az L0 szemszögéből
    // Ezt WebPPL-ben a score() adja meg (log-valószínűség)
    // A factor függvény a WebPPL-ben a valószínűségi súlyozásra/kondicionálásra szolgál. 
    // Ha m igaz (a kijelentés igaz a világban), akkor a súly e^0=1 
    // (azaz a világállapot lehetséges). Ha m hamis, a súly e^(−∞)=0 
    // (azaz ez a világállapot kizárt a hallott kijelentés alapján).
    factor(listenerBeliefs.score(world));
    return utterance;
  });
});


// --- Fő Következtetés a Beszélő Típusára ---

// Fake adatok: (világállapot, hallott kijelentés) párok
// Példa 1: Olyan adatok, amik inkább a pragmatikus beszélőre utalnak
//           (pl. world=3 esetén 'all'-t mond, nem 'some'-ot)
var observedData_PragmaticLikely = [
  { world: 1, utterance: 'some of the people are nice' },
  { world: 3, utterance: 'all of the people are nice'  },
  { world: 0, utterance: 'none of the people are nice' }
];

// Példa 2: Olyan adatok, amik inkább a literális beszélőre utalnak
//           (pl. world=3 esetén is mondhat 'some'-ot, mert az is igaz)
var observedData_LiteralLikely = [
  { world: 1, utterance: 'some of the people are nice' },
  { world: 3, utterance: 'some of the people are nice'  }, 
  { world: 0, utterance: 'none of the people are nice' }
];


// A függvény, ami megbecsüli a beszélő típusát az adatok alapján
var inferSpeakerType = function(observedData) {

  return Infer({method: 'enumerate'}, function() {

    // 1. Prior feltételezés a beszélő típusáról (legyen 50-50%)
    var speakerType = flip(0.5) ? 'pragmatic' : 'literal';

    // 2. Válaszd ki a megfelelő beszélő modellt a típus alapján
    var speakerModel = (speakerType == 'pragmatic') ? pragmaticSpeakerS1 : literalSpeakerS0;

    // 3. Kondicionálj a megfigyelt adatokra
    //    Mennyire valószínűek ezek az adatok az adott típusú beszélő esetén?
    mapData({data: observedData}, function(dataPoint) {
      // Az observe/factor súlyozza a speakerType hipotézist azzal,
      // mennyire valószínű, hogy ez a beszélő mondta volna ezt
      // a kijelentést ebben a világban.
      observe(speakerModel(dataPoint.world), dataPoint.utterance);
    });

    // 4. Add vissza a beszélő típusát (ennek az eloszlását keressük)
    return speakerType;
  });
};

// --- vizualizáció ---

print("--- Eredmény (pragmatikusra utaló adatokkal) ---");
viz.auto(inferSpeakerType(observedData_PragmaticLikely));

print("--- Eredmény (literálisra utaló adatokkal) ---");
viz.auto(inferSpeakerType(observedData_LiteralLikely));
````


### 2

````javascript
var data = [{k : '1'}, 
            {k : '1'}, {k : '2'}, {k : '2'}
           ]

var HierarchicalModel = Infer({method: 'rejection', samples: 20}, 
                       function(){
 
var model  = categorical({ps:[0.5,0.5], vs: ['pragmatic', 'literal'] }); 
  
var pragmatic = dirichlet({alpha: Vector([0.44, 0.44, 0.11])});
  
    var x1 = (pragmatic.data)[0];
    var x2 = (pragmatic.data)[1];
    var x3 = (pragmatic.data)[2]; 

var listener = dirichlet({alpha: Vector([0.33,0.33,0.33])});
  
    var y1 = (listener.data)[0];
    var y2 = (listener.data)[1];
    var y3 = (listener.data)[2]; 
  
  map(function(d){observe(Categorical({ps:[x1,x2,x3], vs:['1', '2', '3']}), d.k)},
      data);
  
  map(function(d){observe(Categorical({ps:[y1,y2,y3], vs:['1', '2', '3']}), d.k)},
      data);  
  
  var z = categorical({ps:[x1,x2,x3], vs:['1', '2', '3']})
  
  var w = categorical({ps:[y1,y2,y3], vs:['1', '2', '3']})
  
  return {pragmatic: z, 
          literal: w};
});
  

viz.marginals(HierarchicalModel)

````



## Winden vagy Hawkins?

<img src="https://github.com/mozow01/cog_compsci/blob/main/SciCamp/winden.jpg" height=200><img src="https://github.com/mozow01/cog_compsci/blob/main/SciCamp/nancy_leave_hawkins_stranger_things_netflix_ringer.jpg" height=200>

Melyik városban vagyunk, ha odacsöppenünk és csak annyit tudunk, hogy felhős-e az ég. Ha másnap nem akarunk kilépni otthonról, meg tudjuk-e jósolni, hogy fog-e eső esni?

````javascript
var HiperModel = Infer({method: 'rejection', samples: 10000 }, 
                       function(){
  
  // a látens változó a Város, amit inferálunk a modellek indexei:
  
  var Város = categorical({ps:[0.5,0.5], vs: ['Winden', 'Hawkins'] }); 
  
  // ez csak azért, hogy az "érintetlen Város" hiperpriort ábrázolni tudjuk
  
  var Város_hiper_prior = categorical({ps:[0.5,0.5], vs: ['Winden', 'Hawkins'] });
  
  // a két város priorja: milyen eloszlást feltételezünk a Felhősség priorjára, 
  // categorical változó konjugált priorja dirichlet
  
  var Winden = dirichlet({alpha: Vector([0.1,0.2,0.7])});
  
    var x1 = (Winden.data)[0];

    var x2 = (Winden.data)[1];

    var x3 = (Winden.data)[2]; 
  
  var Hawkins = dirichlet({alpha: Vector([0.5,0.3,0.2])});
    
    var y1 = (Hawkins.data)[0];

    var y2 = (Hawkins.data)[1];

    var y3 = (Hawkins.data)[2]; 
  
   // ez csak azért, hogy az "érintetlen" priort ábrázolni tudjuk
  
   var Winden_prior = dirichlet({alpha: Vector([0.1,0.2,0.7])});
    var u1 = (Winden.data)[0];
    var u2 = (Winden.data)[1];
    var u3 = (Winden.data)[2]; 
  
  var Hawking_prior = dirichlet({alpha: Vector([0.5,0.3,0.2])});
    var v1 = (Hawkins.data)[0];
    var v2 = (Hawkins.data)[1];
    var v3 = (Hawkins.data)[2]; 
  
  // ez lesz a mért változó:
  
  var Felhősség = (Város === 'Winden')
                   ? categorical({ps:[x1,x2,x3],
                                  vs: ['derült', 'enyhén felhős', 'erősen felhős'] })
                   : categorical({ps:[y1,y2,y3],
                                  vs: ['derült', 'enyhén felhős', 'erősen felhős'] })
  condition(Felhősség === 'derült');
  
  var Felhős_Winden_prior = categorical({ps:[u1,u2,u3],
                                  vs: ['derült', 'enyhén felhős', 'erősen felhős'] })
  
  var Felhős_Hawkins_prior = categorical({ps:[v1,v2,v3],
                                  vs: ['derült', 'enyhén felhős', 'erősen  felhős'] })
                     
  var Esik = (Felhősség === 'derült') 
                   ? flip(0.1)  
                   : (Felhősség === 'enyhén felhős')
                        ? flip(0.6) 
                        : flip(0.9);
  
  return {város_hiper_prior: Város_hiper_prior, 
          Winden_prior: Felhős_Winden_prior, 
          Hawkins_prior: Felhős_Hawkins_prior, 
          város_poszterior: Város, 
          felhős_poszterior: Felhősség,
          esik: Esik};
});

viz.marginals(HiperModel)
````
