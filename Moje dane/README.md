## Jakub Puchalski

  Badanie miało na celu wykonaie zapisu danych w bazie danych MongoDB na instancji standalone oraz z użyciem replikacji.
Zmierzone zostały czasy wykonywania importów przy pięciu różnych ustawieniach write concern.
Każdy import powtórzony został pięć razy. Policzone zostały średnie czasy, wielkości kolekcji, a wyniki przedstawione w tabelce.
Dla porównania powtarzono cały proces dla wzorcowych punktów adresowych dla województwa mazowieckiego.
Podczas badania skontrolowano pracę procesorów.

Specyfikacja środwiska badania:  [zobacz więcej](#enviroment)

### Treść

[Skrypty](/Moje%20dane/scripts)

[Wyniki skryptów html](/Moje%20dane/ImportTimes)

[Dane Traffic Violations](#traffic)

* [czasy importów](#ci1)

[Dane Mazowieckie](#mazowieckie)

* [czasy importów](#ci2)

[Czasy uśrednione](#averages)

[Środowisko badania](#enviroment)



### Definicje

  Opcja ``--writeConcern <document>``  opisuje pzoiom potwierdzenia MongoDB dla operacji zapisu do standalone lub replica set.
Opcja write concern została zastosowana ze względu na opcję ``w`` oraz ``j``.

Opcja ``w`` żąda potwierdzenia, że operacja zapisu została rozpropagowana do określonej liczby instancji mongo lub do instancji mongo z określonymi znacznikami.

Opcja ``j`` żąda potwierdzenia od MongoDB, że operacja zapisu została zapisana w pliku journal na podstawie którego można odtworzyć dane.


  Czas wykonywania importów do bazy danych narzędziem mongoimport został zmierzony z użyciemm polecenia ``/usr/bin/time``. Zwraca ono trzy różne czasy: real, user oraz sys. 
* Real - czas jaki musieliśmy odczekać od momentu włączenia procesu, do momenty zakończenia go (/zobaczenia jego wyników)
* User - czas poświęcony na pracę procesora "wewnątrz procesu" (tzw. user-mode)
* Sys - czas poświęcony przez procesor na komunikację z jądrem systemu (praca "na zewnątrz procesu")

### Obserwacje<a name="obserwacje"></a>

Suma czasów user oraz sys, da nam całkowity czas pracy procesora nad danym programem. 
Czas real tj. rzeczywisty jest większy od czasu pracy procesora nad danym programem ponieważ procesor obsługuje wiele innych działających procesów, dlatego czas real uwzględnia również czas oczekiwania w kolejce procesów.
Można to dostrzec na tabeli ze średnimi czasami wykonywania importów w danej konfiguracji: [Averages](#averages). Średni czas wykonywania real jest zdecydowanie wyższy od czasu sys i user.

Czas rzeczywisty wykonywania importu danych na standalone jest krótszy od importu replica set (Patrz: [Averages](#averages)). Wynika to z konieczności obsługi osobnych procesów mongod uruchomionych w ramach replica set. Procesy są połączone i wykonują swoje rolę co wpływa kolejkowanie procesów.

Badnie nie dało jednoznacznych rezultatów, które wskazywały by na korelacje ustawień ``--write concern`` na czas wykonywania importów (Patrz: [Averages](#averages)).

Praca wątków procesora podczas importów dla standalone stabilna, w okolicach 40%.
Dla replica set liczne fluktuacje, średnia praca wątków: 50%.

(patrz odnośniki "System monitor" lub [imgs](/Moje%20dane/img))

Wynika to z różnych funkcji jakie wykonują procesy mongod.


### Dane

#### Dane Traffic Violations<a name="traffic"></a>

[Traffic Violations](https://catalog.data.gov/dataset/traffic-violations-56dda).
This dataset contains traffic violation information from all electronic traffic violations issued in the County. Any information that can be used to uniquely identify the vehicle, the vehicle owner or the officer issuing the violation will not be published.


|           FILE            | Documents | Total Document Sizie| csv size            | csv.gz size |
|---------------------------|-----------|---------------------|---------------------|------|
| Traffic Violations        | 1018634 | 867,4MB                 |             369.1MB|  39.1MB|

##### Przykładowy dokument

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

##### Czasy importów<a name="ci1"></a>


|            | Standalone  |         |      |
|-------------|-------------|---------|------|
| [System monitor](/Moje%20dane/img/Standalone.png?raw=true)             | real        | user    | sys  |
| 1           | 163,79      | 3,89    | 2,26 |
| 2           | 165,29      | 4,91    | 0,84 |
| 3           | 163,88      | 5,02    | 0,76 |
| 4           | 161,89      | 4,94    | 0,74 |
| 5           | 164,96      | 5,12    | 0,76 |
| average     | 163,96      | 4,78    | 1,07 |

|            | Replica set | |      |
|-------------|-------------|---------|------|
| [System monitor](/Moje%20dane/img/RS1.png?raw=true)             | real        | user    | sys  |
| w:1         | 258,89      | 4,67    | 1,12 |
| w:1         | 241,63      | 4,69    | 1,02 |
| w:1         | 241,57      | 4,43    | 1,3  |
| w:1         | 243,72      | 4,37    | 1,32 |
| w:1         | 269,84      | 4,51    | 1,34 |
| average     | 251,13      | 4,53    | 1,22 |
|             ||         |      |
|  [System monitor](/Moje%20dane/img/RS2.png?raw=true)           | real        | user    | sys  |
| w:1,j:false | 243,23      | 4,77    | 0,95 |
| w:1,j:false | 242,4       | 4,7     | 1,04 |
| w:1,j:false | 245,99      | 4,98    | 0,81 |
| w:1,j:false | 244,49      | 5,07    | 0,77 |
| w:1,j:false | 240,17      | 4,87    | 0,87 |
| average     | 243,26      | 4,88    | 0,89 |
|             |             |         |      |
|  [System monitor](/Moje%20dane/img/RS3.png?raw=true)          | real        | user    | sys  |
| w:1,j:true  | 250,17      | 4,47    | 1,29 |
| w:1,j:true  | 246,83      | 4,32    | 1,73 |
| w:1,j:true  | 249,45      | 4,65    | 1,25 |
| w:1,j:true  | 245,71      | 4,45    | 1,25 |
| w:1,j:true  | 246,22      | 4,68    | 1,02 |
| average     | 247,68      | 4,51    | 1,31 |
|             |             |         |      |
| [System monitor](/Moje%20dane/img/RS4.png?raw=true)            | real        | user    | sys  |
| w:2,j:false | 245,39      | 4,5     | 1,13 |
| w:2,j:false | 243,01      | 4,77    | 0,94 |
| w:2,j:false | 242,31      | 4,3     | 1,46 |
| w:2,j:false | 254,64      | 4,44    | 1,42 |
| w:2,j:false | 250,58      | 4,67    | 1,22 |
| average     | 247,19      | 4,54    | 1,23 |
|             |             |         |      |
| [System monitor](/Moje%20dane/img/RS5.png?raw=true)            | real        | user    | sys  |
| w:2,j:true  | 251,36      | 4,63    | 1,24 |
| w:2,j:true  | 245,56      | 4,79    | 1,12 |
| w:2,j:true  | 243,15      | 4,19    | 1,44 |
| w:2,j:true  | 244,59      | 4,5     | 1,14 |
| w:2,j:true  | 245,04      | 4,64    | 1,08 |
| average     | 245,94      | 4,55    | 1,20 |


#### Dane Mazowieckie<a name="mazowieckie"></a>

[Mazowieckie](www.gugik.gov.pl).


|           FILE            | Documents | collection size | json size            | json.gz size |
|---------------------------|-----------|---------------------|---------------------|------|
| Mazowieckie                | 1018634 | 716MB                 |             750.4 MB|  88.9MB|


##### Przykładowy dokument

```
"_id" : ObjectId("5ad62c6f83dfae87689f4202"),
	"type" : "Feature",
	"properties" : {
		"gml_id" : "PL.ZIPIN.585.EMUiA_30000000000028199370",
		"identifier" : "http://geoportal.gov.pl/PZGIK/dane/PL.ZIPIN.585.EMUiA/30000000000028199370",
		"lokalnyId" : "1714239c-992b-4753-a8a0-c74bc8ba1506",
		"przestrzenNazw" : "PL.PZGIK.200",
		"wersjaId" : "2016-11-26T13:14:10+02:00",
		"poczatekWersjiObiektu" : "2016-11-26T13:14:10Z",
		"waznyOd" : "2006-07-12",
		"jednostkaAdmnistracyjna" : [
			"Polska",
			"mazowieckie",
			"białobrzeski",
			"Białobrzegi"
		],
		"miejscowosc" : "Brzeźce",
		"czescMiejscowosci" : null,
		"ulica" : "Żytnia",
		"numerPorzadkowy" : "6",
		"kodPocztowy" : "26-800",
		"status" : "istniejacy"
	},
	"geometry" : {
		"type" : "Point",
		"coordinates" : [
			21.00156339171123,
			51.67438289898116
		]
	}
```

##### Czasy importów<a name="ci2"></a>

|            | Standalone  |        |      |
|-------------|-------------|--------|------|
|   [System monitor](/Moje%20dane/img/MazowieckieStandalone.png?raw=true)           | real        | user   | sys  |
| 1           | 178,09      | 5,15   | 4,64 |
| 2           | 111,58      | 6,54   | 1,03 |
| 3           | 111,17      | 6,03   | 1,08 |
| 4           | 110,6       | 6,08   | 0,97 |
| 5           | 105,31      | 5,73   | 1,18 |
| average     | 123,35      | 5,91   | 1,78 |

|             | Replica set |        |      |
|-------------|-------------|--------|------|
| [System monitor](/Moje%20dane/img/RSM1.png?raw=true)            | real        | user   | sys  |
| w:1         | 208,39      | 4,21   | 3,44 |
| w:1         | 184,04      | 5,46   | 1,51 |
| w:1         | 184,19      | 5,86   | 1,06 |
| w:1         | 181,29      | 5,71   | 0,87 |
| w:1         | 189,13      | 5,72   | 0,82 |
| average     | 189,41      | 5,39   | 1,54 |
|             |   |        |      |
| [System monitor](/Moje%20dane/img/RSM2.png?raw=true)            | real        | user   | sys  |
| w:1,j:false | 187,85      | 6,24   | 0,94 |
| w:1,j:false | 181,34      | 5,6    | 1,11 |
| w:1,j:false | 183,15      | 5,76   | 0,77 |
| w:1,j:false | 181,57      | 5,72   | 0,84 |
| w:1,j:false | 183,87      | 5,74   | 0,76 |
| average     | 183,56      | 5,81   | 0,88 |
|             |  |        |      |
|[System monitor](/Moje%20dane/img/RSM3.png?raw=true)             | real        | user   | sys  |
| w:1,j:true  | 184,76      | 5,7    | 0,89 |
| w:1,j:true  | 186,79      | 5,83   | 0,69 |
| w:1,j:true  | 192,56      | 5,8    | 0,75 |
| w:1,j:true  | 185,97      | 5,63   | 0,98 |
| w:1,j:true  | 185,86      | 5,75   | 0,98 |
| average     | 187,19      | 5,74   | 0,86 |
|             |   |        |      |
| [System monitor](/Moje%20dane/img/RSM4.png?raw=true)            | real        | user   | sys  |
| w:2,j:false | 186,95      | 5,88   | 0,88 |
| w:2,j:false | 186,64      | 5,77   | 0,86 |
| w:2,j:false | 186         | 5,62   | 0,87 |
| w:2,j:false | 191,88      | 5,55   | 1,07 |
| w:2,j:false | 195,87      | 6,35   | 0,87 |
| average     | 189,47      | 5,83   | 0,91 |
|             |  |        |      |
| [System monitor](/Moje%20dane/img/RSM5.png?raw=true)            | real        | user   | sys  |
| w:2,j:true  | 187,9       | 5,87   | 1,15 |
| w:2,j:true  | 183,19      | 5,71   | 0,83 |
| w:2,j:true  | 185,32      | 5,81   | 0,76 |
| w:2,j:true  | 187,53      | 5,75   | 0,87 |
| w:2,j:true  | 183,19      | 5,66   | 0,94 |
| average     | 185,43      | 5,76   | 0,91 |

#### Averages<a name="averages"></a>
[wróć do "Obserwacje"](#obserwacje)

|             |                    |      |      |             |      |      |
|-------------|--------------------|------|------|-------------|------|------|
|             | Traffic Viloations |      |      | Mazowieckie |      |      |
|             | real               | user | sys  | real        | user | sys  |
| Standalone  | 123,35             | 5,91 | 1,78 | 163,96      | 4,78 | 1,07 |
| w:1         | 189,41             | 5,39 | 1,54 | 251,13      | 4,53 | 1,22 |
| w:1,j:false | 183,56             | 5,81 | 0,88 | 243,26      | 4,88 | 0,89 |
| w:1,j:true  | 187,19             | 5,74 | 0,86 | 247,68      | 4,51 | 1,31 |
| w:2,j:false | 189,47             | 5,83 | 0,91 | 247,19      | 4,54 | 1,23 |
| w:2,j:true  | 185,43             | 5,76 | 0,91 | 245,94      | 4,55 | 1,20 |

### Środowisko<a name="enviroment"></a>
[wróć do "Obserwacje"](#obserwacje)

|Virtual Machine : VMware| | |
|-------------|---------|-----|
| RAM: | 7.6 GiB | |
| Processor | Intel® Core™ i7-6700HQ CPU @ 2.60GHz × 4 | |
| OS type | ubuntu 16.044 LTS | |
| Disc | HDD Western Digital Blue 2.5 | SATA III (6 Gb/s) 16 MB| 
