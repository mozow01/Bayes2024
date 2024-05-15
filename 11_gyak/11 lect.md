# Bayes-faktor

## Modell összehasonlítás és esetei

Modellek összehasonlítását egyszerűen úgy csináljuk, hogy építünk egy nagy hierarchikus modellt, ahol a modell paramétere az egyik hiperprior. Ez nagyon hasznos lesz a Bayes-faktor kiszámításánál

<img src="https://github.com/mozow01/Bayes2024/blob/main/modcomp_1.png" height=300>

## Bayes-faktor

Két modell versengésének eredményét úgy mérhetjük, ha megnézzük, hogy az adatok milyen valószínűek a két modellben:

$$BF_{12}=\dfrac{\Pr(D\mid m_1)}{\Pr(D\mid m_2)}$$

Ha azt az értelmezés vesszük, hogy a $(\vartheta, X, m)$ jointtal van dolgunk, ahol $\vartheta$ a látens paraméter, $X$ a megfigyelt változó, $m$ a modell hiperparaméter, akkor a fenti mennyiségek:

$$\Pr(D\mid m_i)=\sum\limits_{t}\Pr(D,\vartheta\mid m_i)=\sum\limits_{t}\Pr(D\mid\vartheta=t,m_i)\Pr(\vartheta\mid m_i)$$

az adatoknak a "prediktív priorokba" való behelyettesíése (emlékezzünk: a prior eloszlás a látens értékeit adja vissza, a prediktív prior a megfigyelt értékek eloszlását adda vissza az adott látens eloszlás mellett). A BF számítás úgy nevezett _ex ante_ ("az előzetesből") kiszámított mennyiség, azaz a posterior kiszámítása előtti mennyiség.
