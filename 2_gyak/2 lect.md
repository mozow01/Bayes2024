# Adattípusok és algoritmusok

## Bevezetés

Látható, hogy a valószínűségszámításban központi szerepe van az állítás- vagy eseményalgebrának. 

1. A frekventista megközelítésben inkább halmazalgebráról van szó, ahol az események halmazának (sample space) részhalmazai az események. 

2. A bayesiánus elképzelésben az események halmaza nem mindig elsődleges, a fő hangsúly az _állításokon_ van, amelyeknek valószínűsége van. 

Mindezek miatt indokolt, hogy az állításlogikát megtanuljuk. Ezt a Coq programmal fogjuk ezt megtenni. 

A másik lényeges téma, hogy a komputációs hipotézis -- az agy úgy viselkedik, mint egy valószínűségi programcsomag --, azt is feltételezi, hogy ismerjük a programokat (JS, webppl), ezzel is lesz dolgunk.

## Szigma algebra

Ha X halmaz és _P_(X) az összes részhalmazainak halmaza, akkor a Σ ⊆ _P_(X) halmazcsalád σ-algebra, ha

1. X ∈ Σ (biztos esemény)
2. Σ zárt a komplementerre: ha A ∈ Σ, akkor X \ A ∈ Σ is
3. Σ zárt a megszámlálható unióra: ha  A1, A2, A3, ... ∈ Σ, akkor A1 ∪ A2 ∪ A3 ∪ … ∈ Σ.

Ezekből következik, hogy ∅ is a Σ eleme és a (megszámlálható) metszet is a Σ eleme. (De Morgan azonosságok.) Tehát Σ egyben Boole-halmazalgebra is.

Ha A részhalmaza X-nek, akkor "a ∈ A" azt jelenti, hogy az a kimenetel a kedvező A esményt megvalósítja. a ∈ X tehát mindig megvalósul, mert X az összes elemi események halmaza és valahogy csak vannak a dolgok...

## Coq és állítástípusok

https://www.cs.cornell.edu/courses/cs3110/2018sp/a5/coq-tactics-cheatsheet.html

