pir-wikikonv
============

Denne repoen inneholder filer for å renske opp i PIR-wikien. Planen er å 
lage konverteringsscripts som skal utvikles, finpusses og prøvekjøres 
flere ganger før den store dagen opprinner. Selve konverteringen kjøres 
med en standard `make`. Den fortsetter fra der konverteringen ble 
avbrutt sist, og avbrytes ved første feil eller tegn på at det er noe 
som ikke stemmer. Disse make-kommandoene er tilgjengelige:

- **make**<br />
  Kjør konverteringen.
- **make clean**<br />
  Slett alle genererte filer og sett alt tilbake til en jomfruelig 
  tilstand, klar for en ny konvertering.
- **make test**<br />
  Kjør diverse tester for å se at systemet fungerer greit nok. Sjekker 
  at alle forutsetninger er til stede, som f.eks. installert programvare 
  osv.

Status
------

Ja, dette blir jo interessant...

Foreløpig plan
--------------

### Før konverteringen

- Sjekk opp hvordan XML-eksporten fungerer
- Installer webserver, Apache eller NGINX
- Installer Mediawiki
  - Fra Git, eller skal den fra apt-get brukes?

### Det konverteres, søk dekning

- Sett opp v2-wikien med MySQL, evt bruk den som kjører hos 1984.is i 
  dag.
- Lag en liste over nye/endrede sider på wikien siden februar. Det kan 
  bli problematisk med Special:Recentchanges, det ser ut som den bare 
  går 14 dager bak i tid eller noe. Ser ut som databasen prunes med 
  jevne mellomrom så gamle entryer blir slettet. Jepp, WTF. Det som da 
  sikkert må gjøres, er å aksessere databasen direkte og finne ut av 
  nye/endrede sider med en dose SELECT-magi.
- Sjekk at slettede sider og revisjoner også kommer med i XML-dataene.
- Eksporter alle disse sidene til XML. Tror det går an å spesifisere 
  mange sider samtidig, så vidt jeg husker er det et stort TEXTAREA-felt 
  der det skjer. Forhåpentligvis leveres XML-en med fullstendige sider 
  for hver versjon, og ikke bare som en delta mot forrige versjon av 
  siden.
- Sjekk at XML-en ser grei ut:
  - Tegnsett, UTF-8 brukes over hele linja
  - Det er sikkert uregelmessigheter i brukerne. Mye av det er visst 
    tegnsettrelatert, virker som de ligger lagret med ISO-8859-1 i 
    databasen. Jeg mangler, for eksempel. Snufs. Laget en ny bruker der 
    med samme navn, så denslags konflikter kommer sikkert også.
- Importer XML-en på toppen av v1-wikien.
- Sigarer fyres opp for å feire fødselen av v3-wikien.

### Etter konverteringen når støvet har lagt seg

- Oppdater brukerrettigheter. F.eks. opprydding i alle byråkratene. Det 
  bør være så få byråkrater som mulig fordi de har stor makt, og hvis 
  f.eks. en av disse blir cracket, kan synderen gjøre mye skade. To-tre 
  byråkrater holder, kanskje. Det er et greit kompromiss mellom 
  bussfaktor og anarki.
- Installer CAPTCHA for å unngå spambots.
- Skrivebeskytt alle referater og andre dokumenter som er arkivert og 
  ikke skal oppdateres mer. Historien bør også sjekkes for å se at ingen 
  ureglementære endringer er gjort.
- Fjern spam
  - Lag liste over alle brukerne.
  - Fjern alle som ser fornuftige ut, la åpenbare spambrukere ligge 
    igjen.
  - Kjør denne listen gjennom et eller annet genialt program som sletter 
    alle disse spambrukerne og all møkka de har dratt inn på teppet.
- Profit!

Lisens
------

Alle filene er lisensiert under GNU General Public License v2 eller 
senere, tilgjengelig fra <http://www.gnu.org/licenses/gpl-2.0.txt>.
