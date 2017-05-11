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

Ikke så mye mer enn det å si, men lisensen er viktig:
Alle filene er lisensiert under GNU General Public License v2 eller 
senere, tilgjengelig fra <http://www.gnu.org/licenses/gpl-2.0.txt>.
