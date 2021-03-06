pir-wikikonv
============

Denne repoen inneholder filer for å renske opp i PIR-wikien. Planen er å 
lage konverteringsscripts som skal utvikles, finpusses og prøvekjøres 
flere ganger før den store dagen opprinner. Selve konverteringen kjøres 
med en standard `make`. Den fortsetter fra der konverteringen ble 
avbrutt sist, og avbrytes ved første feil eller tegn på at det er noe 
som ikke stemmer.

Kommentarer og pullrequester er selvfølgelig veldig gode ting, spesielt 
hvis noen ser at det går galt avgårde. For å holde kommunikasjonen 
samlet, er det sikkert best å åpne en [issue på 
Gitlab](https://gitlab.com/piratpartiet/pir-wikikonv/issues) hvis det er 
noe som kommer opp. [Eller 
Github](https://github.com/piratpartiet/pir-wikikonv/issues), hvis du 
liker å henge rundt der istedenfor. Begge repoene på Gitlab og Github 
blir oppdatert samtidig.

Status
------

Ja, dette blir jo interessant... Har utarbeidet en slags plan for 
hvordan konverteringen kan foregå. Får vel egentlig ikke gjort noe mer 
før den nye serveren kommer. Riktige versjoner av Postgres, webserver og 
Mediawiki må installeres der så det er forutsigbare forhold.

make-kommandoer
---------------

Disse make-kommandoene er tilgjengelige:

- **make**<br />
  Kjør konverteringen.
- **make clean**<br />
  Slett alle genererte filer og sett alt tilbake til en jomfruelig 
  tilstand, klar for en ny konvertering.
- **make test**<br />
  Kjør diverse tester for å se at systemet fungerer greit nok. Sjekker 
  at alle forutsetninger er til stede, som f.eks. installert programvare 
  osv.
- **make edit**<br />
  Rediger alle filene i repoen. Bruker favoritteditoren din, det vil si 
  den som er definert i `EDITOR`.
- **make README.html**<br />
  Generer `README.html` fra `README.md`. Trenger `cmark`(1) fra 
  <http://commonmark.org>. Gjøres automatisk av `make`.
- **make view**<br />
  Kjør `make README.html` og vis den med `lynx`(1) for å se at alt ser 
  greit ut.

Foreløpig plan
--------------

Når det snakkes om v1, v2 og v3 av repoene, menes dette:

- **v1**: Den originale Postgres-wikien som var i drift fra 2012 til 
  februar 2017. Den er sunn og fin, men mangler innhold etter 
  februar/mars 2017.
- **v2**: MySQL-versjonen som lå på Island. Revisjonshistorien er totalt 
  fucked og brukere mangler, visstnok bare de som har ÅÆØåæø eller andre 
  tegn over U+7F i brukernavnet. Det er mulig at det er mer som ikke 
  stemmer der, det gjenstår å se.
- **v3**: Den nye wikien som skal brukes. Det er v1 med nye importerte 
  forandringer fra v2. I tillegg skal spam og spambrukere slettes.

### Før konverteringen

- Sjekk opp hvordan XML-eksporten fungerer
- Installer webserver, Apache eller NGINX
- Installer Mediawiki
  - Fra Git, eller skal den fra apt-get brukes?
- Ta en dump av hele v2-databasen fra 1984.is og legg den inn som lokal 
  backup.
- Lag en liste (`nyesider.txt`) over nye/endrede sider på wikien siden 
  februar. Det kan bli problematisk med Special:RecentChanges, det ser 
  ut som den bare går 14 dager bak i tid eller noe. Ser ut som databasen 
  prunes med jevne mellomrom så gamle entryer blir slettet. Helt enig, 
  WTF. Det som da sikkert må gjøres, er å aksessere databasen direkte og 
  finne ut av nye/endrede sider med en dose SELECT-magi.
- Eksporter en liste over alle brukerne i v1 og v2. Se etter 
  uregelmessigheter som f.eks. feil tegnsett.
- Sammenlign brukerlista for v1 og v2. Det er sikkert en haug med 
  spammere i v2 som kan slettes etter at konverteringen er ferdig.
- Sjekk at slettede sider og revisjoner også kommer med i XML-dataene.

### Det konverteres, søk dekning 💣

Så mye som mulig skal automatiseres for å få forutsigbare resultater, 
menneskelige variabler må elimineres så langt det lar seg gjøre.

- Send mail med minst 24 timers varsel til alle som bruker wikien om at 
  den ikke må brukes mens konverteringen foregår, nye forandringer vil 
  gå tapt. Hvis det er mulig, bør den settes til read-only mens ting 
  skjer.
- Sperr tilgangen til wikien for alle sammen.
- Sjekk `Special:RecentChanges` for å finne nye artikler som har 
  forandret seg etter at `nyesider.txt` ble laget, og legg eventuelle 
  nye inn i fila.
- Eksporter sidene i `nyesider.txt` til XML, kun historie siden februar 
  skal eksporteres. Tror det går an å spesifisere mange sider samtidig, 
  så vidt jeg husker er det et stort TEXTAREA-felt der det skjer. 
  Forhåpentligvis leveres XML-en med fullstendige sider for hver 
  versjon, og ikke bare som en delta mot forrige versjon av siden.
- XML-dataene versjonskontrolleres fra begynnelse til slutt – fra de 
  blir eksportert fra v2 til de importeres inn i v3 – med Git så alle 
  forandringer som gjøres i XML-fila blir dokumentert og finsjekket. 
  Absolutt ingen dataforandringer aksepteres, det er lett å sjekke med 
  `git diff` at ingen uønskede forandringer kommer med.
- Sjekk at XML-en ser grei ut:
  - Tegnsett, UTF-8 brukes over hele linja.
  - Det er sikkert uregelmessigheter i brukerne. Mye av det er visst 
    tegnsettrelatert, virker som de ligger lagret med ISO-8859-1 i 
    v2-databasen. Jeg mangler, for eksempel. Snufs. Laget en ny bruker 
    der med samme navn, så denslags konflikter kommer sikkert også.
- Slett spam fra XML-fila så det ikke blir importert inn i v3.
- Nye brukere med endringer siden februar må sikkert legges til i 
  v1-wikien før importen, ellers kan det kanskje bli inkonsistens når 
  revisjoner laget av ikke-eksisterende brukere blir lagt til.
- Importer XML-en på toppen av v1-wikien.
- Sjekk at importen gikk greit:
  - Sjekk at alle sider i `nyesider.txt` er lagt til og har en fornuftig 
    kronologi. Sjekk at tidspunktene ser riktige ut, for eksempel at det 
    er riktig tidssone og at UTC ikke er forskjøvet.
  - Lag en fullstendig liste over artikler fra v2 og sjekk at den 
    stemmer overens med de i v3. Det ender vel opp med en SELECT fra v2 
    og v3 som diffes mot hverandre.
  - Sjekk at alle artikler i v2 og v3 er identiske. Kan for eksempel 
    gjøres ved å kjøre SELECT fra v2 og v3 til et TAB-separert format 
    der kun relevante metadata sammenlignes: tittel, tidspunkt, 
    brukernavn og den nye versjonen av artikkelen.
  - Sjekk at nye mediafiler (`File:*`) er kommet på plass og er 
    tilgjengelige.
- Sigarer fyres opp og ganer leskes med den lekreste cognac.

### Etter konverteringen når støvet har lagt seg

- Oppdater brukerrettigheter:
  - Degrader inaktive byråkrater og administratorer til vanlige brukere.
  - Rydd opp i alle byråkratene. Det bør være så få byråkrater som mulig 
    fordi de har stor makt, og hvis f.eks. en av disse blir cracket, kan 
    synderen gjøre mye skade. To-tre byråkrater holder, kanskje. Det er 
    et greit kompromiss mellom bussfaktor og anarki.
- Installer CAPTCHA for å unngå spambots.
- Fjern spam:
  - Lag liste over alle brukerne.
  - Fjern alle som ser fornuftige ut, kun åpenbare spambrukere skal 
    ligge igjen.
  - Kjør denne listen gjennom et eller annet genialt program som sletter 
    alle disse spambrukerne og all møkka de har dratt inn på teppet.
- Skrivebeskytt alle referater og andre dokumenter som er arkivert og 
  ikke skal oppdateres mer. Historien bør også sjekkes for å se at ingen 
  ureglementære endringer er gjort.
- Ta en fullstendig backup av databasen og alle mediafilene.
- Kjør ned v2-wikien, aktiviser v3.
- Gi alle sammen tilgang til den nye v3-wikien.
- Send mail til wikibrukerne om at konverteringen er ferdig og at den er 
  klar til bruk.
- Profit!

Lisens
------

Alle filene er lisensiert under GNU General Public License v2 eller 
senere, tilgjengelig fra <http://www.gnu.org/licenses/gpl-2.0.txt>.

---

    File ID: 26cda2f0-3802-11e7-aec6-f74d993421b0
    vim: set et fenc=utf8 fo=clnqtw sts=2 sw=2 ts=2 tw=72 :
