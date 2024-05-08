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

## "Vanila" RSA scalar implicature generative model:

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
