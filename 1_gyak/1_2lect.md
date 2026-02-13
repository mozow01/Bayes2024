# 1. előadás – törpehörcsög példa (Bayes elemzésig)

## Cél (2 perc)
Ma ugyanarra a helyzetre két kérdésformát tanulunk meg:

- **Frekventista:** *„Ha a hörcsög egészséges, milyen ritka lenne ilyen (vagy ennél szélsőségesebb) adat?”*  
  (adat | modell)
- **Bayes-i:** *„Az adatok után mennyire valószínű, hogy a hörcsög tényleg alulsúlyos?”*  
  (modell/paraméter | adat)

Az egész óra arról szól, hogy **melyik módszer milyen kérdésre ad választ**.

---

## A történet (5 perc)
Van egy törpehörcsögünk (Csofi), és azt gyanítjuk, hogy rendellenesen fogy.

„Egészséges” súlymodell (ideálisítve):

- haranggörbe (normális eloszlás)
- **átlag**: 22 g
- **szórás**: 1 g

Írhatjuk így: \(X \sim \mathcal{N}(22, 1^2)\)

Mérés: csinálunk mondjuk **n = 10** súlymérést.

---

## A döntési kérdés (1 perc)
Nem filozófiai kérdés, hanem gyakorlati:

**„Elvigyük-e orvoshoz?”**

Ehhez ki kell mondani:
- mi számít „rendellenesen alacsonynak”,
- mennyi bizonyíték kell ahhoz, hogy lépjünk.

---

## Bemelegítő kérdések (3 perc)
- Ha az első három mérés: 19, 18, 18 g – mit csinálsz?
- Hány mérés után lennél „biztos”?
- Mit jelent itt az, hogy „biztos”?

Ezek a naiv kérdések *valójában* a kurzus lényegét célozzák.

---

## Frekventista megközelítés (15–20 perc)
### Mit csinálunk intuitívan?
Felveszünk egy „egészséges világot”, és azt kérdezzük:

> **Ha a hörcsög tényleg egészséges, mennyire valószínű ilyen kicsi adatot kapni?**

Itt jön be (implicit módon) a hipotézisvizsgálat nyelve:

- „egészséges story” = \( \mu = 22 \)
- „alulsúly story” = \( \mu < 22 \) (egyoldali, mert csak a túl alacsony érdekel)

A klasszikus út: **egyoldali t-próba** (kis minta, ismeretlen szórás).

A tesztstatisztika (nem kell túltolni, csak hogy legyen kapaszkodó):

\[
t = \frac{\bar{x} - \mu_0}{s/\sqrt{n}}
\]

**Intuíció:** azt méri, mennyire van a mintaátlag 22 alatt „a saját zajához képest”.

---

## A p-érték – a kulcsmondat (8 perc)
A p-érték NEM ezt jelenti:
- „mekkora az esélye, hogy egészséges”
- „mekkora az esélye, hogy a nullhipotézis igaz”

A p-érték ezt jelenti:
> **Ha a hörcsög egészséges (H0), milyen gyakran kapnánk ilyen alacsony (vagy még alacsonyabb) eredményt?**

Tehát: **adat-ritkaság H0 alatt**, nem „betegség valószínűsége”.

A kognitívok itt megnyugszanak: „igen, sampling-distribution, reference class, oké”.
A mérnökök itt robbannak: „de én azt akarom tudni, hogy beteg-e!”

Mindkettő jogos reakció, mert **más kérdést akarnak**.

---

## Naiv kérdések (mérnök-kompatibilis, jogos) (10 perc)
1) „Oké, de akkor mennyi a valószínűsége, hogy tényleg alulsúlyos?”
2) „Mennyi \(P(\mu < 22 \mid \text{adat})\)?”
3) „Miért nem lehet 3 mérés után dönteni?”
4) „Ha p = 0.06, akkor ‘majdnem beteg’?”
5) „Mi az esélye, hogy holnap is ugyanez jön ki?”

Ezek nem buta kérdések. Ezek azt jelzik, hogy a hallgató **a modellt szeretné valószínűsíteni**, nem az adatot.

---

## Átkötés Bayesre (2 perc)
Most váltunk irányt:

- Frekventista: **feltesszük** \( \mu = 22 \)-t, és kérdezünk az adatról.
- Bayes: \( \mu \)-t **ismeretlennek** kezeljük, prior → adatok → posterior.

A Bayes-szakaszban azt fogjuk kiszámolni, amit a mérnök kérdez:

- \(P(\mu < 22 \mid \text{adat})\)
- és még jobb: \(P(\mu < 21 \mid \text{adat})\) (klinikailag értelmes küszöb)

**Itt állunk meg; innen jön a Bayes elemzés.**
