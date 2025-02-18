# WebPPL Bevezető

WebPPL egy funkcionális probabilisztikus programozási nyelv. Valószínűségi modellezést és a statisztikai következtetést végez, furcsasága, hogy funkcionális programozási nyelv, azaz függvényeket definiálunk benne és nincsenek állapotjelzők. Az alapvető szintaxis hasonló a JavaScript-hez (a JS kulcsszavak nagy része nem működik!) de beépített probabilisztikus függvényekkel (kvázi-random-változókkal) dolgozik.

http://webppl.org/

https://webppl.readthedocs.io/en/master/

### **Változók és függvények WebPPL-ben**

- **`var`**: Ez a kulcsszó változók deklarálására szolgál. WebPPL-ben a változók értéke lehet determinisztikus vagy valószínűségi. (Ezek a változók globálisan, mindenhol lehet rájuk hivatkozni egy szakaszon belül)
- **`function`**: Függvények definiálására használjuk, amelyek visszaadhatnak értéket és más kódokat futtathatnak, ennek a változója lokális.

#### **Példa egy változó deklarálására**
```javascript
var x = 5;
print(x); // 5
```

#### **Példa egy függvény definiálására**
```javascript
var add = function(a, b) {
    return a + b;
};

print(add(3, 4)); // 7
```

---

## Pénzfeldobás különböző kiírási módokkal

### 1 Egyetlen pénzfeldobás kiírása
```javascript
var coin = flip(0.5);
print(coin);
```
**Kimenet:** `true` vagy `false` (fej vagy írás)

---

### 2 Több pénzfeldobás egy listában
```javascript
var flips = repeat(10, function() { return flip(0.5); });
print(flips);
```
**Kimenet:** `[true, false, true, false, true, true, false, false, true, true]`

---

### 3 Az eredmények vizualizálása – hisztogrammal
```javascript
viz.hist(
    repeat(1000, function() { return flip(0.5) ? "Fej" : "Írás"; })
);
```
A kimenet egy **hisztogram**, amelyen látható, hogy a két kimenetel **nagyjából egyforma gyakorisággal fordul elő**.

---

## Dobókocka dobás különböző kiírási módokkal

### 1 Egyetlen dobás egyszerű kiírása
```javascript
var dice = sample(Discrete({ps: [1/6,1/6,1/6,1/6,1/6,1/6], vs: [1,2,3,4,5,6]}));
print(dice);
```
**Kimenet:** `4` (vagy más szám 1-6 között)

---

### 2 Több dobás listába gyűjtése és kiírása
```javascript
var rolls = repeat(10, function() {
    return sample(Discrete({ps: [1/6,1/6,1/6,1/6,1/6,1/6], vs: [1,2,3,4,5,6]}));
});

print(rolls);
```
**Kimenet (példa):** `[2, 4, 1, 6, 3, 5, 2, 2, 6, 4]`

---

### 3 Az eloszlás vizualizálása – hisztogrammal
```javascript
viz.hist(
    repeat(1000, function() {
        return sample(Discrete({ps: [1/6,1/6,1/6,1/6,1/6,1/6], vs: [1,2,3,4,5,6]}));
    })
);
```
Ez egy **hisztogramot** készít, amelyen látható, hogy **minden szám kb. 1/6-os valószínűséggel jelenik meg**.

---

## Összegzés: Hogyan ismételjünk WebPPL-ben `_.range(n)` nélkül?
| Módszer | Előnyei | Példa |
|---------|---------|------|
| **Rekurzió** | Nem kell külső függvény, tisztán funkcionális | `coinFlips(10)` |
| **`repeat(n, f)`** | Egyszerűbb és WebPPL-kompatibilis | `repeat(10, function() { return flip(0.5); })` |
| **Előre generált lista + `map()`** | Kombinálható más technikákkal | `repeat(10, function() { return null; })` + `map()` |
| **Vizualizáció hisztogrammal** | Adatokat könnyen ábrázolhatóvá teszi | `viz.hist(repeat(1000, f))` |

---

## Alkalmazott WebPPL parancsok magyarázata

- **`var`** – Változók deklarálására szolgál WebPPL-ben.
- **`function`** – Függvények definiálására használt kulcsszó.
- **`flip(p)`** – Valószínűségi változó, amely `true` vagy `false` értéket vesz fel `p` valószínűséggel.
- **`sample(distribution)`** – Véletlenszerű mintavétel egy adott eloszlásból.
- **`repeat(n, f)`** – `f` függvényt `n` alkalommal meghívja és listát épít belőle.
- **`map(f, lista)`** – Egy adott `lista` minden elemére alkalmazza az `f` függvényt.
- **`viz.hist(lista)`** – Hisztogram rajzolása a `lista` elemeinek gyakorisága alapján.

---

## Házi feladat
1. Készíts egy programot, amely három pénzfeldobás eredményét összegyűjti egy listába, majd kiírja a listát.
2. Írj egy WebPPL programot, amely 100-szor dob egy dobókockával, és kirajzolja az eredmények hisztogramját.
3. Hozz létre egy függvényt, amely 5 pénzfeldobásból megszámolja, hány `true` érték lett, és ezt adja vissza.

