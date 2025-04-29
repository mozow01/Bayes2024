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

A fentiek komputációs modellezéséhez az úgy nevezett RSA elméletet használják, azaz a Rational Speech Act Theory-t (Noah Goodman--Michael Frank, Stanford CoCoLab, inventors of webppl), ami a speech act elmélet egy komputációs bayesiánus változata. 

[https://www.problang.org/chapters/01-introduction.html]

Az RSA modell három hierarcikus feltételes valószínűségi eloszlást tartalmaz a beszélő nyelvprodukciójára és a hallgató interpretációjára. A **pragmatikus beszélő (pragmatic speaker)** ($S_1$) kiválaszt egy szót $u$, hogy kommunikációs hatékonyság szemponthából a legjobban tudjon referálni egy $s$ (state) objektumra a **szó szerinti hallgatónak (literal listener)** $L_0$. Ő $u$-t igazként értelmezi, megtalálja azokat az objektumokat, amelyek megfelelnek $u$ jelentésnek és ezekre egy (egyszerű) eloszlást inferál. A **pragmatikus hallgató (pragmatic listener)** ($L_1$) a beszélő racionális gondolatairól következtet, és ennek megfelelően értelmezi $u$-t a Bayes-tételt használva. $L_11$ figyelembe veszi az objektumok prior valószínűségét ($P(s)$). Az RSA keretrendszer információ-elméleti módon írja le a racionális beszédaktus pragmatikájának jelenségét.

<img src="https://github.com/mozow01/Bayes2024/blob/main/Screenshot%20from%202024-05-08%2012-40-42.png" height=300>

Pragmatic listener:

$$P_{L_1}(s,u)=P(s\mid u)\propto P(u\mid s)\cdot P(s)$$

Pragmatic speaker: 

$$P_{S_1}(u,s)=P(u\mid s)\propto e^{-\alpha U_{S_1}(u,s)}$$

(itt $U_{S_1}(u,s)$ a utility (jutalom) függvény)

Literal listener:

$$P_{L_0}(s,u)=P(s\mid u)\propto 1_{[[u]],s}\cdot P(s)$$

(itt $1_{[[u]],s}$ a Kronecker-delta függvény, ami 1, ha $u$ jelentése $[[u]]=s$ és nulla, ha nem.)

Nulladik lépésben, a jelenség detektálásánál, a literal és a pragmatic listener viselkesésének leírás a feladat. Összetettebb feladatban ez bonyolultabb jelenségek leírására is alkalmas.

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

Erről szól például az a döntési eljárás, amit korábban a "melyik kajáldába menjek, ha pizzát akarok enni" fantázianév alatt tanultunk (4. gyak matlab).

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
