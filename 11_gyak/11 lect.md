# Bayes-faktor

## Modell összehasonlítás és esetei

Modellek összehasonlítását egyszerűen úgy csináljuk, hogy építünk egy nagy hierarchikus modellt, ahol a modell paramétere az egyik hiperprior. Ez nagyon hasznos lesz a Bayes-faktor kiszámításánál

<img src="https://github.com/mozow01/Bayes2024/blob/main/modcomp_1.png" height=300>

## Bayes-faktor

Két modell versengésének eredményét úgy mérhetjük, ha megnézzük, hogy az adatok milyen valószínűek a két modellben:

$$BF_{12}=\dfrac{\Pr(D\mid m_1)}{\Pr(D\mid m_2)}$$

Ha azt az értelmezés vesszük, hogy a $(\vartheta, X, m)$ jointtal van dolgunk, ahol $\vartheta$ a látens paraméter, $X$ a megfigyelt változó, $m$ a modell hiperparaméter, akkor a fenti mennyiségek:

$$\Pr(D\mid m_i)=\sum\limits_{\vartheta}\Pr(D,\vartheta\mid m_i)=\sum\limits_{\vartheta}\Pr(D\mid\vartheta,m_i)\Pr(\vartheta\mid m_i)$$

az adatoknak a "prediktív priorokba" való behelyettesíése (emlékezzünk: a prior eloszlás a látens értékeit adja vissza, a prediktív prior a megfigyelt értékek eloszlását adda vissza az adott látens eloszlás mellett). A BF számítás úgy nevezett _ex ante_ ("az előzetesből") kiszámított mennyiség, azaz a posterior kiszámítása előtti mennyiség.

A generatív modellből a látens m-et inferálhatjuk a D adat mellett. Ez a szokásos út, de akkor hogyan lesz ebből BF? A Bayes-faktort a generatív modell programjának lefutása utáni adatokból is kiszámíhtahjuk, ha felhasználjuk a Bayes-tételt:

$$\Pr(m_i\mid D)=\frac{\Pr(D\mid m_i)\Pr(m_i)}{\Pr(D)}\;\left(=\frac{\Pr(D\mid m_i)\Pr(m_i)}{\sum\limits_{m_i}\Pr(D \mid m_i)\Pr(m_i)}\right)$$

Innen, a $\Pr(D)$-t kiejtve:

$$\frac{\Pr(m_1\mid D)}{\Pr(m_1\mid D)}=\underset{\text{BF_{12}}}{\underbrace{\frac{\Pr(D\mid m_1)}{\Pr(D\mid m_2)}}}\frac{\Pr(m_1)}{\Pr(m_2)}$$

Tehát ha a modellek priorjait 50-50%-ra állítjuk be, akkor a modellek poszterior eloszlása (arányként kifejezve), a BF-et adja.
