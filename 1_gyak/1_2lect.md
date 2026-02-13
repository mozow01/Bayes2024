# Hipotézisvizsgálat (frekventista) – vázlatosan, de korrektül

> **Fő üzenet:** a frekventista hipotézisvizsgálat *hosszú távú ismétlés* (sokszor mérünk) világában értelmezett.  
> A p-érték **nem** “a hipotézis valószínűsége”, hanem **adat-ritkaság** egy rögzített hipotézis alatt.

---

## 0) Frekventista doktrína 5 pontban (a “sokszor mérünk” világ)
1) **A paraméter(ek) fixek, nem véletlenek.**  
   Példa: a “valódi” átlag súly \(\mu\) egy fix szám (csak mi nem tudjuk).

2) **A véletlen az adatban van.**  
   Ha ugyanazt az eljárást (mérés, mintavétel) újra és újra megismételnénk, az adatok változnának.

3) **A módszerek minőségét hosszú távú teljesítménnyel mérjük.**  
   Pl. “ha a nullhipotézis igaz, akkor a téves riasztás aránya legyen legfeljebb 5%”.

4) **A döntési szabály része a “mintavételi terv” (stopping rule).**  
   Nem mindegy, mikor állunk meg mérni; ez a frekventista világban számít.

5) **A p-érték és az alfa egy “ismételhetőségi” garanciához kötött fogalom.**  
   Nem azt mondja meg, mi az igaz, hanem hogy egy eljárás milyen gyakran riaszt tévesen H0 mellett.

---

## 1) A hipotézisvizsgálat elemei (mit kell mindig megadni?)
### 1.1. A modell / valószínűségi feltevések
- Mit tekintünk véletlennek? (pl. mérések zajosak)
- Milyen eloszlást feltételezünk? (pl. normális, ismeretlen szórással)
- Függetlenség? azonos eloszlás? (i.i.d. mérés)
- Mintaelemszám \(n\) és a mintavétel módja (előre rögzített \(n\)?)

### 1.2. Hipotézisek (H0 és H1)
- **H0 (nullhipotézis):** az “alapállapot” / “nincs eltérés” / “egészséges story”  
  Példa: $$H_0: \mu = 22$$
- **H1 (alternatív):** amitől tartunk / amit kimutatnánk  
  Példa (egyoldali): $$H_1: \mu < 22$$
- Döntsd el: egyoldali vagy kétoldali?  
  - egyoldali: csak “túl kicsi” érdekel  
  - kétoldali: “túl kicsi vagy túl nagy” is érdekel

### 1.3. Tesztstatisztika \(T(X)\)
Olyan függvény az adatokból, ami “mennyire eltérés”-t mér.

- Példa (egy-mintás t-statisztika):
  $$t = \frac{\bar{x} - \mu_0}{s/\sqrt{n}}$$
- Intuíció: “hány standard error-rel vagyunk a nullától”.

### 1.4. A tesztstatisztika eloszlása H0 alatt (null eloszlás)
A frekventista lényeg itt van:

- Feltesszük, hogy **H0 igaz**, és megkérdezzük:
  *ha H0 igaz, akkor milyen eloszlású lenne a tesztstatisztikám sok ismétlésben?*
- t-próbánál: \(t\) eloszlása H0 alatt t-eloszlás (df = n−1), ha a feltételek állnak.

### 1.5. Szignifikanciaszint \(\alpha\) (előre!)
- \(\alpha\) = megengedett **I. típusú hiba** arány (téves riasztás) H0 mellett.  
  Tipikusan: \(\alpha = 0.05\).
- Fontos: \(\alpha\)-t **előre** választjuk (nem utólag “igazítjuk” az adathoz).

### 1.6. Döntési szabály (kritikus tartomány)
- Egyoldali (alacsony irány): „utasítsd el H0-t, ha \(t\) elég kicsi”.
- Ez a “kritikus tartomány” úgy van beállítva, hogy:
  $$P(\text{elutasítjuk H0-t} \mid H0) = \alpha$$
  hosszú távon.

---

## 2) p-érték (pontosan mi?)
### 2.1. Definíció (egyoldali, “túl kicsi”)
Legyen \(t_{\text{obs}}\) a megfigyelt statisztika.

A p-érték:
$$p = P(T \le t_{\text{obs}} \mid H0)$$

Szóban:
> Ha H0 igaz lenne, milyen gyakran kapnánk a mostaninál **ilyen vagy ennél szélsőségesebb** eredményt?

### 2.2. Mit jelent a “sokszor mérünk” világban?
Képzeld el, hogy ugyanazt az eljárást (n mérés, ugyanaz a számítás, ugyanaz a szabály) **nagyon sokszor** lefuttatjuk úgy, hogy H0 igaz.

- A p-érték egy **null eloszlásbeli szélsőség** mértéke.
- Kicsi p-érték: az adat “ritka” H0 világában.
- Nagy p-érték: az adat “nem ritka” H0 világában.

### 2.3. Mit NEM jelent (a leggyakoribb félreértések)
- Nem jelenti: $$P(H0 \mid \text{adat})$$
- Nem jelenti: “mekkora az esélye, hogy a hörcsög egészséges”
- Nem jelenti: “mekkora az esélye, hogy H1 igaz”
- Nem jelenti: “mekkora a hatás” (effect size)  
  (kicsi p lehet kis hatásnál is, ha n nagy)

---

## 3) A hibák és a garanciák (miért van \(\alpha\)?)
### 3.1. I. típusú hiba (false positive)
- Elutasítod H0-t, pedig igaz.
- Garancia: ha H0 igaz, akkor ennek aránya hosszú távon legfeljebb \(\alpha\).

### 3.2. II. típusú hiba (false negative)
- Nem utasítod el H0-t, pedig hamis (valójában eltérés van).
- Ennek komplementere: **erő (power)** = a teszt “érzékenysége”.

### 3.3. Mi a frekventista “korrekt” állítás?
- “Ez az eljárás 5%-ban riaszt tévesen egészséges hörcsögre” (H0 világában)
- “Ekkora eltérésnél ennyi a power” (H1 világában)

---

## 4) A döntés vs. evidencia különválasztása (fontos tanári pont)
- A p-érték egy **evidencia-jellegű** szám (compatibility H0-val).
- A “p < 0.05 → beteg” egy **döntési szabály**, ami konvenció + költség-haszon kérdés.
- Orvosi helyzetben érdemes beszélni:
  - milyen téves riasztás tolerálható,
  - milyen téves megnyugtatás veszélyes.

---

## 5) A “mintavételi terv” és a stopping rule (miért számít?)
A frekventista p-érték a teljes eljárásra vonatkozik:

- “előre rögzített n = 10”
- “mérünk addig, amíg elég kicsi p nem lesz”
- “mérünk addig, amíg 4 siker nem lesz” (negatív binomiális jelleg)

Ezek különböző *ismétlési világok* → más null eloszlás → más p-érték.

---

## 6) Miért robbannak a mérnökök? (és miért nyugszanak meg a kognitívok?)
### Mérnöki igény (naiv, de jogos)
Ők ezt akarják:
- $$P(\mu < 22 \mid \text{adat})$$
- “mennyi az esélye, hogy beteg?”

A frekventista teszt erre *nem ad közvetlen választ*.

### Kognitív reakció
Ők azt értik, hogy:
- a p-érték a sampling-distributionból jön,
- és ezért függ az eljárástól (stopping rule),
- és nem posterior.

Ezért nekik ez “konzisztens”, csak nem ugyanaz a kérdés.

---

## 7) Átkötés Bayeshez (1 mondat)
Ha a kérdésed tényleg az, hogy “mennyire valószínű az alulsúlyosság az adatok után”,
akkor olyan keret kell, ahol a paraméter is bizonytalan:

- prior → likelihood → posterior  
- és akkor tényleg számolható: $$P(\mu < 22 \mid \text{adat})$$
