
## Aplikacja MongoDB  z wykorzystaniem Node.js Driver


### Jakub Puchalski

### Opis

Aplikacja dostarcza funkcje analityczne do badania danych [Traffic Violations](https://catalog.data.gov/dataset/traffic-violations-56dda).

Zestaw danych zawiera informacje dotyczące wykroczeń związanych z przekroczeniem prędkosci samochodów na terenie Stanów Zjednoczonych w stanie Waszyngton.

|           FILE            | Documents | Total Document Sizie| csv size            | csv.gz size |
|---------------------------|-----------|---------------------|---------------------|------|
| Traffic Violations        | 1018634 | 867,4MB                 |             369.1MB|  39.1MB|

#### Przykładowy dokument:

```
        "_id" : ObjectId("5acbe3ad8e58e86e6404151e"),
        "Time Of Stop" : "16:10:00",
        "Agency" : "MCP",
        "SubAgency" : "2nd district, Bethesda",
        "Description" : "DRIVER USING HANDS TO USE HANDHELD TELEPHONE WHILEMOTOR VEHICLE IS IN MOTION",
        "Location" : "CLARENDON RD @ ELM ST. N/",
        "Latitude" : 38.9827307333333,
        "Longitude" : -77.1007551666667,
        "Accident" : "No",
        "Belts" : "No",
        "Personal Injury" : "No",
        "Property Damage" : "No",
        "Fatal" : "No",
        "Commercial License" : "No",
        "HAZMAT" : "No",
        "Commercial Vehicle" : "No",
        "Alcohol" : "No",
        "Work Zone" : "No",
        "State" : "VA",
        "VehicleType" : "02 - Automobile",
        "Year" : 1996,
        "Make" : "HONDA",
        "Model" : "CIVIC",
        "Color" : "SILVER",
        "Violation Type" : "Citation",
        "Charge" : "21-1124.2(d2)",
        "Article" : "Transportation Article",
        "Contributed To Accident" : "No",
        "Race" : "HISPANIC",
        "Gender" : "M",
        "Driver City" : "ARLINGTON",
        "Driver State" : "VA",
        "DL State" : "VA",
        "Arrest Type" : "A - Marked Patrol",
        "Geolocation" : "(38.9827307333333, -77.1007551666667)",
        "Date_of_stop" : ISODate("2012-03-18T23:00:00Z")
```

### Wymagania

- MongoDB [installation](https://docs.mongodb.com/manual/installation/)

- Node.js [installation](https://nodejs.org/en/)

### Pliki do uruchomienia


- ``RunReplicaSet.cmd`` uruchomienie zestawu replik MongoDB

Lokalizacja: ``bin/ReplicaSet``
```
$ ./RunReplicaSet.cmd
```

- ``ImportData.cmd`` import bazy ``Traffic_Violations.csv`` do bazy ``Traffic_Violations`` i kolekcji ``tickets``

Lokalizacja: ``date``
```
$ ./Import.cmd
```

- ``field_nameChange`` zmiana nazwy pola "Date Of Stop" na "Date_of_stop" w celu ułatwienia dalszej obróbki danych.

Lokalizacja: ``bin``
```
$ ./field_nameChange.js
```

- ``field_typeChange`` zmiana typu pola "Date_of_stop" ze string na ISODate obsługiwanego przez BSON w celu ułatwienia dalszej obróbki danych.

Lokalizacja: ``bin``
```
$ ./field_typeChange.js
```
### Funkcje

Funkcje uruchamione są z poziomu interpretera poleceń z użyciem polecenia ``node``.
Zapytania zostały skonstruwoane z użyciem metody MongoDB ``db.collection.aggregate()``.

#### ticketsAmount_byYear

Uruchomienie pliku ``ticketsAmount_byYear`` spowoduję zwrócenie posortowanej ilości mandatów za przekroczenie prędkości, z podziałem na datę (rok).

```
λ node ticketsAmount_byYear.js
Liczba mandatów wd. daty
{ _id: { rok: 2011 }, liczba: 181 }
{ _id: { rok: 2012 }, liczba: 151554 }
{ _id: { rok: 2013 }, liczba: 190717 }
{ _id: { rok: 2016 }, liczba: 216927 }
{ _id: { rok: 2014 }, liczba: 223681 }
{ _id: { rok: 2015 }, liczba: 235574 }
null
```
* dane z roku 2011 niekompletne

#### ticketsAmount_byYear_drunkDriver

Uruchomienie pliku ``ticketsAmount_byYear_drunkDriver`` spowoduję zwrócenie posortowanej ilości mandatów za przekroczenie prędkości, z podziałem na datę (rok), z udziałem pijanych kierowców.

```
λ node ticketsAmount_byYear_drunkDriver.js
Zatrzymani pijani kierowcy wd. daty
{ _id: { rok: 2015 }, liczba: 287 }
{ _id: { rok: 2016 }, liczba: 322 }
{ _id: { rok: 2013 }, liczba: 388 }
{ _id: { rok: 2014 }, liczba: 409 }
{ _id: { rok: 2012 }, liczba: 577 }
null
```

#### drunkDriver_caught


Uruchomienie pliku ``drunkDriver_caught`` spowoduję zwrócenie ogólnej liczby zatrzymanych kierowców, ktorzy byli pod wpływem alkoholu.

```
λ node drunkDriver_caught.js
Zatrzymani pijani kierowcy:
{ Liczba: 1983 }
null
```

#### driver_caught_byRace

Uruchomienie pliku ``driver_caught_byRace`` spowoduję zwrócenie posortowanej ilości mandatów za przekroczenie prędkości, z podziałem na rasę sprawcy.

```
λ node driver_caught_byRace.js
Zatrzymani kierowcy wd. rasy
{ _id: { rasa: 'NATIVE AMERICAN' }, liczba: 2434 }
{ _id: { rasa: 'OTHER' }, liczba: 52516 }
{ _id: { rasa: 'ASIAN' }, liczba: 59566 }
{ _id: { rasa: 'HISPANIC' }, liczba: 210534 }
{ _id: { rasa: 'BLACK' }, liczba: 317298 }
{ _id: { rasa: 'WHITE' }, liczba: 376286 }
null
```
### Git Sizer


