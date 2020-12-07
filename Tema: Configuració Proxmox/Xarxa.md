---
title: "CONFIGURACIÓ DE XARXA"
author: [Alfredo Rafael Vicente Boix i Javier Estellés Dasi]
date: "2020-11-25"
subject: "Proxmox"
keywords: [Xarxa, Instal·lació]
subtitle: "Exemple d'esquema de xarxa en el model de centre"
lang: "ca"
page-background: "background10.pdf"
titlepage: true,
titlepage-rule-color: "360049"
titlepage-background: "background10.pdf"
colorlinks: true
header-includes:
- |
  ```{=latex}
  \usepackage{awesomebox}
  ```
pandoc-latex-environment:
  noteblock: [note]
  tipblock: [tip]
  warningblock: [warning]
  cautionblock: [caution]
  importantblock: [important]
...

<!-- \awesomebox[violet]{2pt}{\faRocket}{violet}{Lorem ipsum…} -->

# Introducció

Fins ara hem vist que en el model clàssic de centre existia un servidor en cadascuna de les aules d'informàtica. Per tant, per a gestionar-lo calia anar a l'aula d'informàtica, o connectar-se bé via ssh o per vnc. 
Amb el nou model de centre canviem el paradigma i tindrem tots els servidors virtualitzats en un hipervisor o en un cluster d'hipervisors.
A mode d'exemple tenim el següent esquema de model clàssic.

![Esquema simplificat model clàssic](models/classic.png) 

I hem de passar al següent al nou esquema.

![Esquema simplificat nou model](models/prox.png)

Per tant, és necessari que cada ordinador bé siga del centre, de l'Aula d'informàtica o la wifi sàpiga quina és la seua xarxa i/o el seu servidor. Per a aconseguir-ho utilitzarem Xarxes virtuals (VLAN).

:::info
La VLAN que utilitzarem en es una VLAN de nivell 1 o per port, existeixen altres tipus de VLAN, per mac, subxarxa, protocol... Que poden tindre interès en un entorn empresarial o siga necessària la mobilitat del lloc de treball.
:::

# Conceptes de xarxa

En aquesta unitat configurarem un esquema de xarxa mode amb dos switchs a mena d'exemple. Coneixent com es configuren dos swiths, configurar-ne'n més es fa de manera similar. Però abans anem a veure un poc de terminologia i tecnologia que anem a utilitzar.

:::warning
Es pressuposa certa expertesa en tema de xarxes com saber què és una IP, un switch o un router, com es connecten els ordinadors en xarxa o configurar una estació de treball en una xarxa.
:::

## VLAN i LAG

Tractarem de fer una breu explicació per entendre les VLANS sense entrar en detalls tècnics que no corresponen a aquest curs. A les xarxes virtuals per port, tal i com diu el nom, hem de configurar cadascun dels ports segons la xarxa virtual que nosaltres volem tindre. Es poden configurar tantes VLANS com el switch ho permeta. En el nostre cas, la quantitat màxima és de 256, més que suficient per al que anem a fer. A mode d'exemple podríem tenir el següent switch on cada port pertany a una o més VLANS.

![Esquema d'un switch amb diferents VLANS](switch/vlan.png)

Hem de tenir en compte que:

* Hem de configurar cadascun dels ports del switch amb la VLAN corresponent. És per això que es necessari tenir **switchs gestionables** per a poder configurar la xarxa.
* Si en fixem en la VLAN 110 en roig, podem veure que la VLAN que entra és la 110 i la que ix és la mateixa.
* En canvi, al port 12 podem veure com la VLAN que ix és la 60 i la 110, ja que el port està configurat per a pertànyer a 2 VLANS.
* Al port 16 passa el mateix però amb 4 VLANS, els port de la zona taronja estan configurats per a tenir 4 VLANS.
* Si a un port arriba una connexió sense cap VLAN i el port està configurat amb la VLAN 10, la connexió que surt és de la VLAN 10.

Per a fer-vos una idea senzilla simplement heu de tenir en compte cadascun dels quadrats. Quan penseu en la VLAN 110, penseu en els port que pertanyen a eixa VLAN. Però ara se'ns planteja la següent qüestió.

### Com sap un ordinador amb diferents VLANS quina xarxa ha d'escollir?

Si l'ordinador suporta VLANS que no és el més habitual, es deurà de configurar a l'arxiu corresponent. Però com normalment es tracta d'una màquina de treball, li direm al port del switch on va a connectar-se l'ordinador que va a connectar-se una màquina que no entén de VLANS. A aquesta opció l'anomenem **UNTAGGED**.
Si en lloc d'un ordinador connectem un switch (que sí entén de VLANS). Entendrà que la VLAN untagged és per a ell (per exemple un DHCP que li oferix una ip, o la xarxa per a poder accedir per a gestionar-lo) i les **TAGGED** serán aquelles que passaran als ports configurats amb les respectives VLANS.
A mode d'exemple podem veure.

![Esquema d'un switch amb diferents VLANS](switch/vlans2.png)

Aquesta és la situació que ens trobarem normalment al centres. En aquest cas podem veure que, arriben 4 VLANS, la 1 arriba untagged, el que significa que el switch haurà de tindre una ip de la VLAN 1. La VLAN 2+3+4 com estàn tagged, estaran connectades a la xarxa 2,3 i 4 respectivament. Com que anem a connectar un ordinador a eixe port les hem posades unttagged.
Podem veure com seria la connexió entre dos ordinador connectats a la mateixa VLAN:

![Recorregut entre dos ordinadors](switch/vlanmoviment.png)

:::caution
Aquesta explicació no pretén ser tècnica ja aquest curs no va adreçat únicament a gent amb una formació tècnica, sinó de generar una idea sobre com funcionen les VLANs sense entrar en com es marquen les VLANS a nivell de connexió. Hi ha molta informació al respecte a la web. Això sí, és important tindre una idea de com funciona. A mesura que practiqueu amb algun switch anireu agafant soltesa.
:::

## Bonding/Link Aggregation

El bonding és una manera de poder ampliar la velocitat de connexió entre dos màquines, poden ser bé dos ordinadors, dos switchs, o un ordinador i un switch, etc...

![Exemple de bonding](switch/bond.png)

Els avantatges i consideracions que té fer un bonding entre dos màquines són:

* Augmentes la velocitat.
* Si un cable deixa de funcionar, la connexió es manté.
* Utilitzant el protocol **LACP** augmenta la compatibilitat entre diferents màquines.
* Simplifica les connexions. 


:::caution
De la mateixa manera que l'apartat anterior aquesta explicació no pretén ser tècnica sinó donar una idea. Cal incidir que per al cas que estem tractant i en funció de marques, moltes vegades s'utilitzen indistintament els termes, **bonding**, **trunking**, **LAG**, **bundling** o **channeling**. I segur que s'utilitzen altres terminologies que no coneguem.
:::



# Model d'exemple

Partirem de l'exemple del següent model. Per a poder fer-lo hem utilitzat:

| Dispositiu | Característiques |
| -- | -- |
| Dlink DGS-12-10-48 | Switch de 48 ports a 1Gb |
| Netgear GS724T | Switch de 24 ports a 1 Gb |
| Servidor SEH1 | Ordinador de 32 Gb i processador i7 | 

L'esquema es quedaria de la seqüent manera. Una vegada tinguem dissenyat el esquema del nostre centre podem passar a configurar cadascun del switchs.

![Exemple de model de centre per a treballar](models/Model_ex.png)

## Configuració dels switchs

Abans de començar cal que ens creem una taula per a definir, les adreces ip dels switch i quins ports van a tenir cadascuna de les VLANs. El rang del centre fictici que tenim creat al nostre exemple és el 172.254.254.X

Les adreces IP dels switchs seran:

| Switch | Adreça |
| -- | -- |
| Dlink DGS-12-10-48 | 172.254.254.11 |
| Netgear GS724T | 172.254.254.10 |


### Configuració de Switch principal amb el Netgear GS724T

Basant-nos en l'exemple que este seguint l'esquema del switch quedaria de la següent manera:

| Ports | VLAN | Bond |
| -- | -- | -- |
| P1 a P4 | 1 | No |
| P5 a P10 | 110 | No |
| P11 a P12 | 1,110,120,130 | Si LAG1 |
| P13 a P16 | 1,110,120,130 | Si LAG4 |
| P17 a P20 | 1,110,120,130 | Si LAG3 |
| P21 a P24 | 1,110,120,130 | Si LAG2 |

\* LAG = Link Aggregation group. És el que nosaltres estem anomenant **bond**. 

Encara que per a configurar el switch és millor traure't un esquema de la següent manera:

| VLANs | Ports | 
| -- | -- | 
| 1 | U-P1, U-P2, U-P3, U-P4, U-LAG1, T-LAG2, T-LAG3, T-LAG4| 
| 110 | U-P5, U-P6, U-P7, U-P8, U-P9, U-P10 T-LAG1, T-LAG2, T-LAG3, T-LAG4 | 
| 120 | T-LAG1, T-LAG2, T-LAG3, T-LAG4 | 
| 130 | T-LAG1, T-LAG2, T-LAG3, T-LAG4 | 
| 200 | T-LAG2, T-LAG3, T-LAG4 |

La VLAN 200 l'utilitzem per a la **xarxa de replicació de LliureX**.  Concepte que tractarem en l'última unitat.

:::info
És possible que vos pregunteu el perquè del T2 i T3. Hem deixat preparat el switch per si volem crear un cluster amb altres hipervisors.
:::

Abans que res per a accedir al switch hem de tindre'l dins de la mateixa xarxa. Si el switch ja està configurat i coneguem l'adreça ip i la contrasenya ens podem votar el següent pas.

#### Reinicialitzar switch

Per a reinicialitzar el switch hem d'utilitzar un clip i mantindre durant 10 segons el clip al botó de la imatge. L'adreça per defecte per a accedir és la 192.168.0.139 (depèn sempre de marques i models)

![Reset del switch Netgear](switch/netgearreset.png)

:::warning
**Tinc en compte** que si el switch ja està connectat a una xarxa aquest agafarà una adreça per DHCP.
:::

Si el switch ha agafat una adreça per DHCP pots tractar d'esbrinar la seua ip amb el comandament:

```tcsh
sudo nmap -sP 172.254.254.*
``` 

Utilitzem **sudo** ja que ens un poc més d'informació.

#### Accedir a switch

Per a poder accedir al switch has de tenir configurada la xarxa de l'ordinador dins del mateix rang que el switch. Podem configurar la xarxa de la següent manera:
Anem al panell de ferramentes i clickem sobre la icona del pc.

![Configuració de xarxa amb lliurex](Switchs/lliuxarxa1.png)

Allí canviem la configuració. Podem crear-ne una nova fent click sobre el més. En aquest cas hem configurat l'adreça 10.90.90.100, però per al switch Netgear seria la 192.168.0.100, o qualsevol que no siga la 192.168.0.239.

![Configuració de xarxa amb lliurex](Switchs/lliuxarxa2.png)

:::caution
Una vegada canviada la configuració heu de desconnectar-vos i tornar-vos a connectar sinó no vos canviarà la ip.
:::

#### Configuració del Switch

Una vegada ja teniu la ip al mateix rang, ja podeu accedir al switch a través del navegador:

![Switch Netgear](Switchs/netgear1.png)

El primer que caldria fer es accedir al switch per a canviar la seua ip i posar-la dins del rang de la nostra xarxa de Aules.

![Anem a IP Configuration](Switchs/netgear2.png)

![Actualitzem la IP](Switchs/netgear3.png)

Una vegada actualitzada la IP del switch recorda canviar la IP del teu ordinador per a poder tornar a accedir. Després anem a la secció de LAG, per a configurar cadascun dels LAG segons la imatge.

![Secció LAG](Switchs/netgear4.png)

Quan tenim definits tots els LAGs, anem a LAG membership i afegim els ports als quals pertanyen cadascun dels switchs.

![LAG membership ](Switchs/netgear5.png)

Ens ha de quedar una cosa així:

![Relació de LAGs a Netgear](Switchs/netgear6.png)

Després hem de definir les VLANS, anem a la pestanya de VLAN i configurem les nostres VLAN.

![Configuració VLANs](Switchs/netgear7.png)

Ens ha de quedar una cosa així:

![Relació VLANs](Switchs/netgear8.png)

I afegim els ports untagged de cadascuna de els VLAN en l'apartat VLAN membership.

![Paràmetres de cada port](Switchs/netgear9.png)

Després canviem del menú VLAN ID cadascuna de les VLAN i anem configurant-les una a una. 

:::warning
Recorda donar-li al botó Apply cadascuna de les vegades que acabes la configuració d'una VLAN.
:::

![Canvi de VLAN](Switchs/netgear10.png)

El mateix amb la VLAN 120.

![Paràmetres VLAN 120](Switchs/netgear11.png)

La 130.

![Paràmetres VLAN 130](Switchs/netgear12.png)

I la de replicació.

![VLAN de replicació](Switchs/netgear13.png)

:::warning
Finalment i és molt important, als switchs Netgear (no amb els d'altres marques) és necessari canviar el paràmetre PVID, pel que cal anar a l'apartat PVID configuration i canviar-lo en aquells ports untagged al valor que hem donat untagged. Altres marques aquest pas es fan automàticament.
:::

![Configuració PVID](Switchs/netgear14.png)


### Configuració de Switch de Aula D-LINK DGS1210-48

Cal dir que, tot i que anomenem aquest switch, switch de Aula, podria ser perfectament uns witch que dona servei a les aules del voltant i a l'aula d'informàtica. La configuració d'aquest switch quedaria de la següent manera:

| VLANs | Ports | 
| -- | -- | 
| 1 | U-P1, U-P2, U-P3, U-P4, U-LAG1 (U-P47,U-P48) | 
| 110 | U-P5 a U-P16 T-LAG1 (T-P47,T-P48) | 
| 120 | U-P17 a U-P46 T-LAG1 (T-P47,T-P48) | 
| 130 | T-LAG1 (T-P47,T-P48) | 

Hem indicat els ports entre parèntesis, ja que, al contrari en el Netgear, en este switch sí que has de configurar els ports pertanyents al LAG.

#### Reinicialitzar switch

Per a reinicialitzar el switch D-link hi ha que procedir de manera similar al Netgear, cal polsar el botó *reset* durant 10s aproximadament.

![Reinicialització del switch D-link](switch/dlinkreset.png)

:::warning
**Tinc en compte** que, al igual que el Netgear si el switch ja està connectat a una xarxa aquest agafarà una adreça per DHCP. Per a fer el reset és recomanable no tenir cap cable connectat al switch.
:::

Si el switch ha agafat una adreça per DHCP pots tractar d'esbrinar la seua ip amb el comandament:

```tcsh
sudo nmap -sP 172.254.254.*
``` 
#### Configuració del Switch

Una vegada tingues la ip al mateix rang, ja pots accedir a ell, la ip per defecte del switch D-link és 10.90.90.90, per tant canviarem la ip del nostre ordinador i accedirem a ell. Igualment podem utilitzar la terminal per a crear un alias. Depenent de si tens instal·lat el ifconfig o no pots utilitzar qualsevol dels següents comandaments

```tcsh
sudo ip addr addr add 10.90.90.100/24 dev eth0 label eth0:1
```

```tcsh
sudo ifconfig eth0:1 10.90.90.100 netmask 255.255.255.0 up
```
Després ja podem entrar al switch, la contrasenya per a poder entrar és *admin*. 

![Login a switch D-link](Switchs/dlink1.png)

Posteriorment configurem la IP del switch.

![Configuració IP](Switchs/dlink2.png)

I canviem la contrasenya genèrica

![Canvi contrasenya](Switchs/dlink3.png)

Si anem a gestionar el switch a través de SNMP caldrà habilitar aquesta opció.

![SNMP](Switchs/dlink4.png)

També es pot canviar la configuració de la ip desde les opcions de configuració.

![Configuració de IP](Switchs/dlink5.png)

Per a configurar el LAG fem el següent procediment.

![Configuració del LAG](Switchs/dlink7.png)

Cal configurar el switch per a la VLAN de gestió. En el nostre cas es la 1.

![Habilitar VLAN de gestió](Switchs/dlink8.png)

Habilitem el Spanning tree.

:::info
El spanning tree es un protocol que detecta bucles en la xarxa i pot desactivar ports si en detecta algun.
:::

![Spanning tree](Switchs/dlink9.png)

Ara es quan hem de configurar les VLAN, a la imatge podem veure ja totes les VLAN configurades. En un principi només ens apareixerà la VLAN 1, a la qual és necessari entrar ja que tots els ports están configurats en eixa VLAN. Es procedirà a passar-los a *Not member* ja que no et permetrà assignar-los a altra VLAN si ja estan configurats.
Per a afegir noves VLAN hem de donar-li al botó Add.

![VLANs del switch](Switchs/dlink10.png)

![Canvi d'estat de ports i donem a Apply](Switchs/dlink12.png)

Una vegada hem donat al botó Add, configurem la VID i la VLAN Name, seleccionem els ports que pertanyen a eixa VLAN i li donem a Apply.

![Switch D-link](Switchs/dlink13.png)

:::caution
Finalment, i en alguns switchs és de vital importància, cal salvar la configuració ja que, si hi ha un tall de subministrament elèctric el switch torna a la configuració d'abans. En aquest cas, donat que tenim un switch amb un LAG, probablement provocaríem un bucle en la xarxa i deixaria de funcionar tot el centre. Per tant hi ha que anar molt amb compte en aquests detalls.
:::

Procedim a salvar la configuració:

![Salvem la configuració del switch](Switchs/dlink14.png)

![Confirmem que volem guardar la configuració](Switchs/dlink15.png)

Ara en aquests moments ja tenim tots els switch preparats per a posar en funcionament el nostre centre. Al proper tema instal·larem el Proxmox de les diferents maneres possibles i configurarem els paràmetres del servidor.

<!-- 
![Proxmox és la ferramenta que utilitzarem per a virtualitzar els servidors](Proxmox-logo.png)

És important tenir clar els següents conceptes abans de començar la instal·lació.

* **AMT** funciona com un sistema independent, per tant tindrà la seua pròpia ip.
* Els suports físics cada vegada s'utilitzen menys. Recorda quan va ser última vegada que utilitzares un CD-ROM.
* Anem a fer una instal·lació de proxmox. No és necessari tenir accés a la consola de Proxmox en cap moment, per tant si ja tens l'hipervisor muntat al rack, no el desmuntes.
* Les IPs utilitzades no corresponen amb les indicades al que recomana el SAI. És la tasca que se vos manarà!

![Esquema orientatiu](Esquema.png)

\newpage

# Posada a punt del servidor

Per a posar a punt el servidor, és recomanable, encara que no imprescindible habilitar el AMT, per a posteriorment utilitzar la ferramenta meshcomander per a fer una instal·lació remota.

## Habilitar AMT de Intel

Els servidors distribuïts als centres disposen de la ferramenta AMT de Intel per a poder connectar-se remotament, no sols ens permetrà arrancar l'hipervisor sinó que també ens permetrà configurar certes funcionalitats bàsiques. Però abans que res, caldrà entrar a la BIOS.
Per a accedir a la BIOS (Model SEH1) polsem F2 en el setup de l'ordinador.

![BIOS del sistema](amt-conf/Desktop--2020-11-25-18-25.png)

\newpage

Una vegada dins anem a la pestanya *Advanced*.

![Proxmox és la ferramenta que utilitzarem per a virtualitzar els servidors](amt-conf/Desktop--2020-11-25-18-26.png)

\newpage

I seleccionem *AMT Configuration*.

![Proxmox és la ferramenta que utilitzarem per a virtualitzar els servidors](amt-conf/Desktop--2020-11-25-18-262.png)

\newpage

Canviem *MEBx Mode* i seleccionem l'opció Enter MEBx Setup

![Proxmox és la ferramenta que utilitzarem per a virtualitzar els servidors](amt-conf/Desktop--2020-11-25-18-26-2.png)

\newpage

Finalment salvem els paràmetres i reiniciem.

![Proxmox és la ferramenta que utilitzarem per a virtualitzar els servidors](amt-conf/Desktop--2020-11-25-18-27.png)

## Configuració del AMT

Una vegada hem habilitat el AMT, entrem en la configuració del mateix i configurem els següents paràmetres.

::: tip
**Info**: Per obvis motius de seguretat no es permet entrar a la configuració del AMT per VNC, pel que algunes de les següents imatges están fotografiades de la pantalla.
:::

Quan entren a la ferramenta de configuració del AMT, hem de logar-nos. La contrasenya d'administrador és **admin**. Posteriorment ens demanarà que canviem la contrasenya per una nova.

::: warning
**Contrasenya**: Hem de respectar la política de contrasenyes, amb majúscula, minúscula i caràcter especial.
:::

![Entrem a la ferramenta de configuració](mebx/-000.png)

![Introduïm la contrasenya](mebx/-001.png)

Hem d'accedir a les següents opcions per a fer una configuració bàsica.

| Opció | Funcionalitat |
| -- | -- |
| **User Consent** | Ens permetrà poder connectar-nos al servidor per VNC sense donar permís |
| **Network Setup** | Per a configurar les opcions de xarxa |
| **Activate Network Access** | Hem de fer click sobre aquesta opció per a poder accedir a l'hipervisor |

![Opcions que hem de configurar](mebx/-002.png)

Dins de la opció de **User Content** hem de canviar l'opció assenyalada a *NONE*.

![Canvi d'opció](mebx/-003.png)

Per a configurar la xarxa anem a l'opció de Network Setup. 

![Network Setup](mebx/-004.png)

Després anem a **TCP/IP Settings**

![Seleccionar l'opció](mebx/-005.png)

I configurem la AMT segons els següents paràmetres

::: caution
**Vés amb compte**: L'adreça de l'AMT és diferent a l'adreça de l'hipervisor. A més has de tenir en compte que el AMT no té el ICMP activitat, pel que si fas un *ping* no et donarà resposta.
:::

Els paràmetres que mostrem són uns paràmetres d'exemple que anem a utilitzar dins del nostre banc de proves.

| Opció | IP |
| -- | -- |
| IP | 172.x.y.2 – 172.x.y.254 |
| Máscara | 255.255.255.0 |
| Puerta de Enlace | 172.x.y.1 |
| DNS | 172.27.111.5 y 172.27.111.6 |

![Configuració xarxa](mebx/-006.png)

::: important
**Accés**: Una vegada ja tingues funcionant el AMT, podràs accedir a través del navegador amb l'adreça http://172.x.y.238:16992 ó https://172.x.y.238:16993. Hauràs de canviar l'adreça segons la que hages escollit.
:::

# Meshcomander

> En aquest punt hem de tenir en compte que hem d'utilitzar Windows. Si algú coneix algun programari que permeta servir una imatge .iso a través de IDE-R en LliureX seria molt interessant que ho comentara als fòrums.

El AMT ens permetrà tenir el servidor muntat dins del rack principal sense necessitat de tenir ni un monitor ni un teclat connectat. Tot i que es una ferramenta tremendament útil. Aquesta no està disponible per a cap distribució de linux, o al menys, no una versió que disposa de totes les funcionalitats que ens oferix AMT de Intel com el IDE-R.

::: note
**Info**: IDE Redirect (IDE-R) permet muntar una imatge ISO remotament des d'un client. Aquesta opció és molt interessant ja que evita que necessàriament estiguem físicament presents a d'instal·lar o reinstal·lar el Proxmox. Podeu trobar més informació [ací](https://software.intel.com/content/www/us/en/develop/blogs/meshcommander-javascript-ider.html).
:::

Hem de descarregar el programari de la seua [pàgina web](https://www.meshcommander.com/meshcommander) i fer la instal·lació.

![Pàgina per a descarregar el meshcomander](mesh/1.png)

::: caution
**Vés amb compte**: Recorda que has d'estar a la mateixa xarxa que l'hipervisor (la xarxa d'Aules en el nostre cas). L'hipervisor no té el perquè d'estar encés per a poder accedir.
:::

Una vegada instal·lat i funcionant el mesh comander veurem una cosa com la següent.

![Meshcomander captura de pantalla](mesh/2.png)

Farem click sobre *Add computer...* I configurarem el servidor amb els paràmetres del AMT que hem configurat prèviament. Podem accedir de dues maneres:

* Amb TLS, pel que utilitzarem el port **16993**
* Sense seguretat, utilitzarem el port **16992**

![Configuració del meshcomander 1](mesh/3.png)

![Configuració del meshcomander 2](mesh/4.png)

Una vegada configurat el servidor veurem la pantalla de la següent manera. Ja només en cal, donar a **connect** i podrem accedir a la configuració del nostre servidor de manera remota.

![Pantalla on es mostra el hipervisor](mesh/5.png)

Si has escollit la connexió amb TLS, probablement t'apareixerà una advertència.

![Indicació](mesh/6.png)

Una vegada connectat veurem la següent pantalla. No anem a parar a explicar totes les funcionalitats que disposes, sinó que ens centrarem en la instal·lació remota. Per a això cal anar a Serial-over-LAN.

![Pantalla d'opcions de l'hipervisor](mesh/7.png)

En aquest punt hem de descarregar la ISO de Proxmox desde la seua [pàgina web](https://proxmox.com/en/downloads).

![Opció per a descarregar el proxmox VE](mesh/proxmox.png)

Aquí farem click sobre l'opció **IDER** i seleccionarem la imatge descarregada.

![Selecció d'imatge de Proxmox](mesh/10.png)

Una vegada seleccionada l'opció de Proxmox anirem  **Remote Desktop** i seleccionarem l'opció de **Power Actions**. Allí, hem d'escollir l'opció de *Power on to IDE-R CDROM*. Veurem que l'hipervisor es reinicia i començarà la instal·lació.

![Remote Desktop](mesh/11.png)

![Opció per a iniciar desde la ISO](mesh/12.png)

Finalment veurem com comença la instal·lació de Proxmox.

![Canvi d'opció](mesh/13.png)

:::important
És altament recomanable tenir una connexió al menys de 1Gb, ja que sinó la instal·lació es pot fer molt pesada i poden aparèixer errades de *timeout*.
:::

# Instal·lació de Proxmox

Per a instal·lar Proxmox podem utilitzar l'opció explicada. És la més recomanable si ja tens el servidor muntat al rack. De tota manera, també es pot instal·lar amb una memòria usb.


## Creació de usb d'arrancada de proxmox

Per a fer la instal·lació de la iso de proxmox, la millor opció és utilitzar **dd**. Per a detectar on està muntat el usb podem executar abans i després lsblk i podem veure on s'ha muntat la partició.

```tcsh
lsblk
```

En el nostre exemple (ja que tenim un disc dur m2 no sata, s'ha muntat en sda). Per tant el nostre comandament seria:

```tcsh
dd if=./proxmox-ve_6.2-1.iso of=/dev/sda status=progress
```

\awesomebox[violet]{2pt}{\faUsb}{violet}{Es recomana fugir de d'aquelles opcions que creen un usb de manera gràfica. Ja que no solen crear bé les particions. Utilitzeu sempre dd.}

## Instal·lació de proxmox

Una vegada tenim creat el disc usb d'arrancada i iniciem amb l'usb, o a través de IDER. Veurem la següent imatge. Polsem *enter* i continuem. 

![Pantalla inicial de la instal·lació de Proxmox](inst_proxmox/1.jpg)

Tots sabem que és important llegir-se la llicència :smirk:.

![Llicència de Proxmox](inst_proxmox/2.jpg)

Aquesta és una de les parts més delicades i depèn del que vullgueu tenir muntat al vostre centre, també depèn de la quantitat de discs durs que tingueu instal·lats i de si voleu invertir diners en una cabina de discs durs.

![Opcions d'instal·lació](inst_proxmox/3.jpg)

Si voleu deixar-ho en ext4. I utilitzar un únic disc per a utilitzar Proxmox i les màquines virtuals no va a donar mals resultats. L'altre disc dur el podeu utilitzar per a fer còpies de seguretat.

:::info
Proxmox utilitza ZFS que és una combinació d'administrador de volums i sistema de fitxers.
:::

![Selecció d'opcions](inst_proxmox/4.jpg)

Les opcions que tenim són les següents:

| Sistema | Característiques  |
| -- | -- |
| RAID0 | La capacitat de tal volum és la suma de les capacitats dels discos. La fallada d'una unitat fa el volum inservible. |
| RAID1 | La dada és escrita idènticament a tots els discos. Aquest mode requereix com a mínim 2 discos amb la mateixa mida. |
| RAID10 | Una combinació de RAID0 i RAID1. Requereix com a mínim 4 discos. |
| RAIDZ-1 | Una variació de RAID-5, paritat sola. Requereix com a mínim 3 discos. |
| RAIDZ-2 | Una variació de RAID-5, paritat doble. Requereix com a mínim 4 discos. |
| RAIDZ-3 | Una variació damunt RAID-5, paritat triple. Requereix com a mínim 5 discos |

:::warning
Si heu optat per adquirir una targeta controladora per a muntar el RAID, aquesta opció no l'heu de fer servir. Sempre i quan la targeta siga reconeguda per Proxmox, es veurà com un únic disc. Les opcions que estem configurant és RAID per via software.
:::

L'opció més anivellada entre tots els paràmetres a tenir en compte seria l'opció de RAID1.

![Opció recomanada](inst_proxmox/5.jpg)

Configurem la zona geogràfica.

![Zona geogràfica](inst_proxmox/6.jpg)

Configurem el password i la contrasenya.

:::caution
Si estàs fent la instal·lació per IDER utilitza la arroba del camp de text ja que és possible que no la pugues escriure amb Alt Gr+2.
:::

![Configuració de contrasenya](inst_proxmox/7.jpg)

Configura la xarxa segons els paràmetres del teu centre. L'exemple donat no és el corresponent al que deuries utilitzar.

![Configuració de xarxa](inst_proxmox/8.jpg)

Comprovem que tots els paràmetres que hem configurat són els correctes i li donem a Install. De seguida començarà la instal·lació que sol ser bastant ràpida.

![Instal·lació de proxmox](inst_proxmox/9.jpg)

Una vegada finalitzada la instal·lació. Reiniciem el sistema i passarem a la següent unitat. Configuració del Proxmox.

![Instal·lació de proxmox](inst_proxmox/10.jpg)


 -->


# Bibliografia i referències

(@) https://es.wikipedia.org/wiki/VLAN


