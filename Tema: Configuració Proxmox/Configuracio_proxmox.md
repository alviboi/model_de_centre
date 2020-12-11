---
title: "CONFIGURACIÓ DE XARXA"
author: [Alfredo Rafael Vicente Boix i Javier Estellés Dasi]
date: "2020-11-25"
subject: "Proxmox"
keywords: [Xarxa, Instal·lació]
subtitle: "Exemple d'esquema de xarxa en el model de centre"
lang: "es"
page-background: "background10.pdf"
titlepage: true,
titlepage-rule-color: "360049"
titlepage-background: "background10.pdf"
colorlinks: true
header-includes:
- |
  ```{=latex}
  \usepackage{awesomebox}
  \usepackage{caption}
  \usepackage{array}
  \usepackage{tabularx}
  \usepackage{ragged2e}
  \usepackage{multirow}


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

En aquesta Unitat configurarem l'hipervisor amb Proxmox. Muntarem 3 servidors amb les següents característiques.

| Servidor | Característiques |
| -- | -- |
| MASTER | Tindrà el LDAP i guarda el /net |
| CENTRE | DHCP als ordinadors del centre |
| AULA1 | DHCP als ordinadors de l'aula d'informàtica |
| WIFI |No muntarem el servidor WIFI en aquesta unitat |

Donarem com a exemple dos esquemes clàssics de muntatge del centre. Ambós són totalment vàlids i funcionen perfectament.

:::info
La majoria de captures de pantalla están en anglès, ja que no tinc el costum de canviat el llenguatge original dels programes. Òbviament si algú vol configurar els paràmetres en la finestra de login al català o al español ho pot fer sense problemes.
:::

## Esquema 1

En aquest esquema que posem com a exemple dos switchs tenim 3 LAG configurats al switch principal per si volem muntar un cluster amb Proxmox fins a 3 ordinadors. Són 3 ordinadors ja que 3 ordinadors permeten ja fer un muntatge d'Alta disponibilitat, però és un tema que explicarem en cursos més avançats.
Aquest esquema és típic de centres molts grans que tenen varies sales d'informàtica i el switch principal pràcticament l'utilitzen per a redistribuir les VLANs i només que té muntats LAGs que van a cadascun dels switch del centre.

:::info
La Alta disponibilitat (HA) permet que quan un hipervisor s'espatlla els altres agafen les màquines virtuals del mateix i seguix donant servei sense que l'usuari ho note. Així permet canviar l'hipervisor o arreglar-lo i el servei no és interromput en cap moment. Per a fer això és necessari muntar un CEPH o una cabina externa amb molta fiabilitat.
:::

L'esquema seria de la següent manera:

![Esquema orientatiu 1](Esquemes/esquemabond.png)

## Esquema 2

Un dels principals avantatges del següent esquema és que no utilitza VLANs, cada targeta de de l'hipervisor va a un switch diferent. Aquest muntatge s'utilitza principalment en centre xicotets. Igualment permet el muntatge d'un cluster que podríem connectar al router del centre a les boques de la xarxa VLAN. L'equema seria de la següent manera:

![Esquema orientatiu 2](Esquemes/esquemasense.png)

## Esquema de màquines virtuals

A la fi els dos esquemes comparteixen el muntatge de les màquines virtuals ja que la configuració d'on es connecten les targetes virtuals ho fem des del proxmox. Hem respectat els noms de les targetes en ambdós casos (vmbrX), però es pot donar el nom que vullgues.

![Esquema connexions màquines virtuals](Esquemes/Conexions hipervisor.png)

## Configuració del proxmox

Una vegada tenim instal·lat el proxmox i haja reiniciat, podrem accedir a ell. Tota la configuració del proxmox es realitza a través d'un servidor web que porta muntat. Per a accedir hem de fer-ho a través del port 8006 amb certificació ssl. Senzillament escrivim a una navegador d'una estació de treball que estiga a la mateixa xarxa el següent:

```tcsh
https://"IP_HIPERVISOR:8006
```

::: info
Este és un dels motius pels quals deixem ports en cada switch amb la VLAN 1, per a poder accedir a través d'eixos ports sempre al proxmox. També es pot fer des de qualsevol ordinador del centre o l'aula d'informàtica, però cal habilitar el NAT en cada servidor LliureX. I estos han d'estar funcionant. Per tant en aquest pas és necessari estar connectat a la xarxa del centre.
:::

### Accés a proxmox

El primer que ens demana és l'usuari i contrasenya que hem configurat quan hem fet la instal·lació:

![Esquema orientatiu 2](ConProxmox/prox1.png)

I una vegada dins podem veure l'espai de treball del proxmox:

![Esquema orientatiu 2](ConProxmox/prox2.png)

:::info
Els següents passos són opcionals, però aconsellables. És per a accedir a les últimes actualitzacions de proxmox.
:::

Una vegada hem accedit podem configurar la llista dels repositoris de proxmox accedint, en primer lloc al shell del hipervisor i escrivim el següent:

```tcsh
nano /etc/apt/sources.list.d/pve-enterprise.list
```
Tin en compte que has accedit com a root, així que has d'anar molt amb compte amb el que fas. Una vegada obris el fitxer canvies el repositori pel següent:

```tcsh
deb http://download.proxmox.com/debian/pve buster pve-no-subscription
```

Es quedaría així:

![Repositori de proxmox](ConProxmox/prox3.png)

Ara ja pots actualitzar des de la terminal el proxmox per a tenir l'última versió:

```tcsh
apt update
apt upgrade
```

### Crear màquina virtual

Abans de crear una màquina virtual hem de pujar un iso de LliureX Server, podem descarregar-la [d'ací](http://releases.lliurex.net/isos/19.07_64bits/). Tractem de buscar l'última versió editada.

Una vegada la tenim descarrega hem de pujar-la al proxmox seleccionant l'espai **local** i fent click en upload:

![Pujar iso a proxmox](ConProxmox/prox5.png)

![Pujar iso a proxmox](ConProxmox/prox6.png)

Una vegada tenim fet això, ja podem crear la primera maquina virtual. Anem de fer d'exemple el servidor MASTER i els altres es fan de manera similar. Fem click sobre **Create VM**

![Crear màquina virtual](ConProxmox/prox7.png)

S'obrirà una finestra per a especificar els paràmetres de configuració. En la primera finestra no cal canviar res, anem a **Next**:

![Polsem next](ConProxmox/prox8.png)

En aquest punt hem de seleccionar la iso que acabem de pujar:

![Seleccionem ISO](ConProxmox/prox9.png)

Posteriorment donem a next:

![Opcions del sistema](ConProxmox/prox10.png)

Escollim el disc dur a utilitzar, i opcionalment canviem la cache a write back. 

:::info
Write-back pot donar un poc més de rendiment al disc però és més propens a perdre dades si hi ha un tall. Queda a criteri de cadascú escollir.
:::

![Opcions del disc dur](ConProxmox/prox11.png)

Canviem els paràmetres de la CPU, 4 cores en total és suficient, en principi per a les tasques a realitzar.

![Opcions del disc dur](ConProxmox/prox12.png)

Donem 6Gb de memòria RAM. Aquest paràmetre anirà sempre en funció de la quantitat de màquines que anem a tindre.

:::caution
La suma de la memòria RAM de totes les màquines pot ser sense problemes major que la quantitat de memòria RAM disponible. Això sí, si totes les màquines comencen a demanar molta memòria, el sistema es pot tornar molt lent.
:::

![Memòria RAM](ConProxmox/prox13.png)

Finalment, no canviem res als paràmetre de xarxa i una vegada instal·lada la màquina ja afegirem les targetes virtuals. Podem activar el checkbox de **Start after created** per a poder iniciar la màquina una vegada li donem a **Finish**.

![Resum d'opcions](ConProxmox/prox14.png)

### Instal·lació de la màquina virtual

Una vegada configurada la màquina virtual i haja arrancat podem veure com ens apareix una icona en la franja esquerra i es posa de color, podem desplegar el menú contextual i polsem sobre Console:

![Menú contextual de la VM en funcionament](ConProxmox/prox15.png)

Podem veure com ha arrancat la màquina:

![Inici de màquina virtual](ConProxmox/prox17.png)

I procedim a la seua instal·lació tal i com hem vist a la Unitat 1.

De manera similar, si volem seguir tot el procés caldria instal·lar els altres dos servidors amb le mateix procediment. L'única cosa que cal canviar entre ells seria el nom de cadascún d'ells, nosaltres hem escollit la següent nomenclatura:

| Nom | Servidor |
| -- | -- |
| 4600xxxx.MAS | Servidor Master |
| 4600xxxx.CEN | Servidor de centre |
| 4600xxxx.AU1 | Servidor Aula informàtica |

I per a l'administrador de cadascun dels servidor hem escollit **admin0**. 

## Configuració de la xarxa

Una vegada tenim instal·lats tots els servidors procedim a configurar la xarxa. Per a accedir a la configuració de l'hipervisor hem de seleccionar el mateix (No la màquina virtual ni el Datacenter), i anem a les opcions **Network**.

### Esquema 1

Recordem que aquest esquema té un bond al switch. Polsem sobre **Create** i seleccionem l'opció **Linux Bond**.

![Selecció de bond](ConProxmox/prox18.png)

S'ens obrirà la finestra següent i hem d'escriure totes les targetes on posa **Slaves**, seguides d'un espai. La configuració quedaria de las següent manera:

| Paràmetre | Opció |
| -- | -- |
| Slaves | enp1s0 enp2s0 enp3s0 enp4s0 |
| Mode | LACP |
| hash-policy | layer2+3 |

I polsem sobre **Create**.

![Configuració del bond](ConProxmox/prox21.png)

na vegada tenim configurat el bond anem altra vegada a **Create** i seleccionem **Linux Bridge**. A l'opció **Bridge ports** hem d'escriure el bond0 seguit d'un punt i el número de VLAN que volen configurar a la connexió pont.

![Configuració de la connexió pont](ConProxmox/prox22.png)

De manera anàloga realitzem totes les altres configuracions i ens quedaria de la següent manera:

![Configuració de xarxes al proxmox](ConProxmox/prox23.png)

### Esquema 2

Aquest esquema que no presenta cap VLAN es faria de manera anàloga a l'anterior, però sense configurar el bond. Agafaríem cada targeta virtual **Linux bridge** i l'enllacem a la targeta de sortida. L'esquema quedaria de la següent manera:

![Configuració de xarxes al proxmox](ConProxmox/prox46xxx.png)

:::caution
Un dels problemes que presenta aquesta configuració és saber quina targeta es quina, podem anar provant i veure quina està activa amb la ferramenta **ip** per a saber quina és quina. Podem anar desconectant els cables veure que apareix **state DOWN** i associar la connexió.
:::

```tcsh
root@cefirevalencia:~# ip link show enp4s0
5: enp4s0: <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP> mtu 1500 qdisc pfifo_fast master bond0 state DOWN mode DEFAULT group default qlen 1000
``` 

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


