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

# Configuració del proxmox

Una vegada tenim instal·lat el proxmox i haja reiniciat, podrem accedir a ell. Tota la configuració del proxmox es realitza a través d'un servidor web que porta muntat. Per a accedir hem de fer-ho a través del port 8006 amb certificació ssl. Senzillament escrivim a una navegador d'una estació de treball que estiga a la mateixa xarxa el següent:

```tcsh
https://"IP_HIPERVISOR:8006
```

::: info
Este és un dels motius pels quals deixem ports en cada switch amb la VLAN 1, per a poder accedir a través d'eixos ports sempre al proxmox. També es pot fer des de qualsevol ordinador del centre o l'aula d'informàtica, però cal habilitar el NAT en cada servidor LliureX. I estos han d'estar funcionant. Per tant en aquest pas és necessari estar connectat a la xarxa del centre.
:::

## Màquines virtuals

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

## Crear màquina virtual

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

## Instal·lació de la màquina virtual

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

# Configuració de la xarxa

Una vegada tenim instal·lats tots els servidors procedim a configurar la xarxa. Per a accedir a la configuració de l'hipervisor hem de seleccionar el mateix (No la màquina virtual ni el Datacenter), i anem a les opcions **Network**.

## Esquema 1

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

## Esquema 2

Aquest esquema que no presenta cap VLAN es faria de manera anàloga a l'anterior, però sense configurar el bond. Agafaríem cada targeta virtual **Linux bridge** i l'enllacem a la targeta de sortida. L'esquema quedaria de la següent manera:

![Configuració de xarxes al proxmox](ConProxmox/prox46xxx.png)

:::caution
Un dels problemes que presenta aquesta configuració és saber quina targeta es quina, podem anar provant i veure quina està activa amb la ferramenta **ip** per a saber quina és quina. Podem anar desconectant els cables veure que apareix **state DOWN** i associar la connexió.
:::

```tcsh
root@cefirevalencia:~# ip link show enp4s0
5: enp4s0: <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP> mtu 1500 qdisc pfifo_fast master bond0 state DOWN mode DEFAULT group default qlen 1000
``` 

# Configuració de la xarxa en cada màquina virtual

Hem de recordar que cada servidor LliureX ha de tenir 3 targetes:

| Targeta | Característiques |
| -- | -- |
| Targeta externa | És la que es connectarà a la xarxa d'Aules |
| Targeta interna | La que dona servei als ordinadors de l'Aula o les classes |
| Targeta de replicació | Per a muntar el /net entre els servidors |

En el nostre cas recordem que les tenim configurades de la següent manera:

| Targeta | nom |
| -- | -- |
| Targeta externa | vmbr0 |
| Targeta interna | vmbr2, vmbr3, vmbr4, vmbr5 |
| Targeta de replicació | vmbr10 |

Per a configurar cada màquina virtual seleccionem la màquina i anem a les opcions de **Hardware**, fem click sobre **Add** i escollim **Network device**.

![Configuració de xarxa de VM](ConProxmox/prox24.png)

Com quan hem instal·lat la màquina virtual ja ens ha agafat la vmbr0, eixa la deixem com la externa. I configurem ja la interna.

![Configuració de targeta virtual](ConProxmox/prox25.png)

Aquest procediment l'hem de repetir en tots els servidors. Recorda que l'esquema de xarxa és el següent:

| IP | Servidor |
| -- | -- |
| 172.X.Y.254 | Servidor Maestro |
| 172.X.Y.253 | Servidor de Centro |
| 172.X.Y.252 | Servidor de Aula 1 |
| 172.X.Y.251 | Servidor de Aula 2 |
| 172.X.Y.250 | Servidor de Aula 3 |

## Targetes virtuals

:::warning
És important que ens assegurem abans d'inicialitzar el servidor quina targeta és quina, per a que no ens confonen. El servidor podria començar a donar DHCP a través de targeta connectada a la VLAN1 o router (depenent de l'esquema) i podria deixar sense servei a tot el centre.
:::

Podem comprovar quina és cada targeta amb el comandament ip fet al servidor i comparar les MAC.

![Configuració de xarxa de VM](ConProxmox/prox26.png)

## Inicialització servidors

Quan iniciem el servidor, en aquest cas el màster, escollim les següents opcions:

![Inicialitzar el servidor](ConProxmox/prox27.png)

:::warning
És molt important que habilites l'opció d'exportar el /net al servidor mestre.
:::

Un procediment extra que no ens ha d'oblidar en cap servidor és actualitzar-los sempre abans de fer res. I en el màster hem de configurar el lliurex mirror:

![Mirror](ConProxmox/prox29.png)

![Mirror](ConProxmox/prox30.png)

![Mirror](ConProxmox/prox31.png)

De manera similar inicialitzem els altres servidors:

![Inicialitzar el servidor](ConProxmox/prox32.png)

:::warning
És molt important que habilites l'opció munta el /net des del mestre.
:::

# Configuracions addicionals

## Arrancar les màquines virtuals quan inicia el servidor

És important que quan es reinicie l'hipervisor les màquines virtuals arranquen automàticament per a no tindre que connectar-se al proxmox per engegar-les una a una. Per a configurar aquesta opció seleccionarem una màquina virtual i seleccionarem l'opció de configuració **Options** i canviarem els paràmetres **Start at boot** a **Yes** i **Start/Shutdown order** a 1 en el cas del servidor mestre.

:::caution
És recomanable arrancar primer el mestre i deixar un temps per a que arranque i posteriorment arrancar els esclaus. Així, als servidors esclaus afegirem un temps a **Startup delay**.
:::

![Configuració d'orde d'arrancada](ConProxmox/prox33.png)

![Configuració d'orde d'arrancada](ConProxmox/prox34.png)

Al servidor de centre i esclau les opcions quedarien de la següent manera:

![Configuració d'orde d'arrancada al servidor de centre](ConProxmox/prox35.png)

![Configuració d'orde d'arrancada al servidor de l'Aula d'informàtica](ConProxmox/prox36.png)

## Muntatge de cabina externa (Opcional)

És possible que ens interesse l'opció d'una cabina externa. Té nombrosos avantatges, a l'espai de la cabina externa podem tindre emmagatzemat isos, discs durs de màquines virtuals, còpies de seguretat...

:::warning
Si decidiu muntar el /net a una cabina externa. Aneu amb compte amb les ACL!!!. Ja que solen donar problemes. L'opció en aquest cas més segura per a que funcione és tenir el /net en un disc dur virtual.
A més, si aneu a tenir espai emmagatzemat a una cabina, la cabina ha de tenir unes característiques adeqüades. Jo recomanaria com a mínim:
* Possibilitat de crear un bond amb 4 targetes de xarxa, o targeta de 10G (caldria un switch que ho suporte)
* Al menys 4 discs durs per muntar un RAID10
* Cache de disc SSD
D'aquesta manera es podria muntar un sistema amb Alta disponibilitat.
:::

:::info
En aquest curs no explicarem com configurar una cabina per a que funcione al model de xarxa. Les cabines no entren dins de la dotació de centre, per tant seria una adquisició pròpia del centre
:::

Una vegada tenim la cabina configurada podem afegir-la al nostre **Datacenter** seleccionant-lo i anant a l'opció de **Storage**. Fem click sobre **Add** i escollim **NFS**.

![Configuració de cabina](ConProxmox/prox37.png)

I seleccionem les diferents opcions de configuració:

![Configuració de cabina](ConProxmox/prox38.png)

## Creació de backup (Opcional)

En principi no seria necessari crear un backup de les màquines virtuals ja que hem muntat un RAID1. Però hi han varies configuracions que podem recomanar l'opció del backup. Per a configurar la còpia de seguretat seleccionem el datacenter, anem a l'opció de Backup i fem click sobre **Add**.

![Configuració de cabina](ConProxmox/prox39.png)

Ens apareixerà la següent finestra, hem de tenir en compte en quin lloc volem fer el backup (**Storage**). I seleccionem la/les màquines virtuals que volem fer còpia de seguretat, en un principi, en el nostre cas només caldria fer la còpia de seguretat del Màster, ja que és on es guarda el /net i LDAP. La còpia de seguretat queda programada per a una data determinada, en principi, en un centre, un dissabte a les 12 de la nit no hi ha cap usuari connectat.

![Configuració de la còpia de seguretat](ConProxmox/prox40.png)

També és pot fer una còpia de seguretat en qualsevol moment. Les còpies de seguretat porten temps, per tant no és recomanable fer-ho en hores on s'estiguen utilitzant els servidors.

![Creació de la còpia de seguretat](ConProxmox/prox41.png)

![Creació de la còpia de seguretat](ConProxmox/prox42.png)

Una vegada tenim la còpia de seguretat feta podem restaurar-la amb **Restore**.

:::caution
Quan es restaura la còpia de seguretat es crearà una nova màquina virtual amb les mateixes característiques que la màquina antiga i ens preguntarà en quin espai volem instal·lar la nova màquina. Hem d'anar amb compte de no tenir les dues màquines funcionant al mateix temps (després de restaurar-la) ja que crearà problemes de xarxa. També hem de recordar deshabilitar l'opció de **Start at boot**, sinó al reiniciar l'hipervisor arrancaran les dues màquines.

![Restaurar la còpia de seguretat](ConProxmox/prox43.png)

![Restaurar la còpia de seguretat](ConProxmox/prox44.png)


# Bibliografia i referències

(@) https://es.wikipedia.org/wiki/VLAN


