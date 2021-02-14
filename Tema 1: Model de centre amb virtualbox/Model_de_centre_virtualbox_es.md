---
title: "MODELO DE CENTRO CON VIRTUALBOX"
author: [Alfredo Rafael Vicente Boix y Javier Estellés Dasi]
dato: "2021-02-24"
subject: "Proxmox"
keywords: [Red, Instalación]
subtitle: "Ejemplo de un centro con Virtualbox sin Proxmox"
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
  noteblock: [noto]
  tipblock: [tip]
  warningblock: [warning]
  cautionblock: [caution]
  importantblock: [importando]
...

<!-- \awesomebox[violet]{2pt}{\faRocket}{violet}{Lorem ipsum…} -->

# Introducción

En esta unidad veremos como montar el modelo de centro virtualitzat. Esto nos servirá para entender como funciona el modelo de centro de LliureX, qué es un servidor maestro.

# Modelo de centro

El modelo de centro se uno configuración que combina red y servidores para dar unos servicios a todos los ordenadores dentro del centro. Entre otras cosas el modelo de centro puede dar los siguientes servicios de red:

- Páginas web internet del centros
- Jitsi para reuniones a la intranet
- Moodle para sesiones internas
- Videoconferencias
- LDAP para autentificar-se los usuarios a cualquier ordenador del centro
- Carpetas compartidas en todo el centro
- Mirror compartido por todos los servidores
- Servidor de imágenes para clientes ligeros
- Nextcloud para compartir ficheros a la intranet
- DHCP para cada aula

Además de todas estas características, LliureX presenta numerosas herramientas que facilitan la instalación y configuración del software.

Pero la principal ventaja de todo es que LliureX permite configurarlo todo sin tocar la terminal y sin tener conocimientos avanzados de informática. La puesta a punto del modelo de centro es rápida y sencilla.
Para entender mejor el modelo de centro hablaremos de cada elemento por separado.

# Sabores de LliureX

LliureX se presenta  varios sabores y cada cual tiene sus características diferenciadas. Dentro del modelo de centro tenemos dos sabores principales:

| Sabor | Características |
| -- | -- |
| Servidor | Puerta todo los paquetes para montar el modelo de centro |
| Cliente | Es la versión que tenemos que instalar en el centro |
| Escritorio | Puede funcionar de manera independiente |

Los sabores música, infantil, fp, etc... son una versión de escritorio con paquetes característicos de cada una de las especialidades.

# Servidor

El servidor de LliureX puede trabajar de 3 maneras.

| Servidor | Características |
| -- | -- |
| Independiente | El servidor trabaja de manera independiente |
| Mestre | Mujer servicios a los esclavos |
| Esclavo | Puede trabajar de manera independiente, sincroniza con MASTER |

El servidor tiene como mínimo 2 tarjetas de red:

- La red interna: a esta tarjeta se conectará uno switch donde se conectarán los clientes.
- La red externa: se conectará directamente en la red de Aulas del router (antigua macrolan).

Para que el servidor funciono dentro del modelo de centro hay que configurarlo e inicializarlo con el *zero-server-wizard** que vorem más adelante.



## Esquema de red

Un esquema bastante habitual que nos encontramos en los centros es el siguiente:

![Esquema orientativo 1](Esquemes/model1.png)

:::warning
Al esquema se muestra un servidor NFS de archivos. Al último daremos unas recomendaciones de cómo  se monta un servidor NFS, pero tienes que tener en cuenta que este tipo de servidores dan muchos problemas para montar el /limpio, dado un problema amn las ACLs y lo NFS v3, por lo tanto se recomienda dejar el /limpio al MASTER. Se puede montar al servidor NFS como un disco del PROXMOX (qcow por ejemplo), las ACLs no darán problemas en ese caso.
:::

En este esquema nos encontramos 3 servidores, donde el servidor maestro guarda la base de de datos para autentificar-se todos los usuarios (LDAP), y puede dar servicio en la red de profesorado.

Un esquema más adecuado sería este:

![Esquema orientativo 2](Esquemes/Modelaula2val.png)

Tenemos que tener en cuenta los siguiente elementos. Cada uno de los servidor tiene que tener como mínimo 3 tarjetas de red:

 | Tarjeta | Características |
 | -- | -- |
 | eth0 | Tarjeta interna que mujer DHCP en el aula |
 | eth1 | Tarjeta externa que se conecta en la red de Aulas |
 | eth2 | Tarjeta de replicación de servicios comunes |

# Instalación del modelo de centro

Vayamos a realizar el montaje de un modelo de centro paso a paso con todas sus funcionalidades, para tener claro sus conceptos. En esta unidad utilizaremos el software de Virtualbox para montar el modelo de centro.

:::warning
Tenéis que tener en cuenta que aquí no hablaremos de todo el software que viene con LliureX, como lo harvester, libreoffice, programas de diseño, etc... En este curso nos centraremos exclusivamente en el montaje y configuración del modelo de centro
::: 

## Instalación de Lliurex

:::noto
Podéis encontrar la última ISO para descargar [aquí](http://releases.lliurex.net/isos/19.07_64bits/lliurex-servidor_64bits_19_latest.iso).
:::

Podéis instalar virtualbox con:

```
sudo apt install virtualbox-dkms virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso
```

Una vez tenéis instalado lo virtualbox, lo ejecutáis y os aparecerá la siguiente pantalla:

![Virtualbox](model/1.png)

Clickem sobre **Nueva** y seguimos el siguiente ejemplo:

![Versión: Ubuntu 64](model/2.png)

![Nombre: 4600xxxx.MAS](model/3.png)

![RAM: con 2-2,5 GB será suficiente para probar cosas](model/4.png)

![Por defecto el que hay](model/5.png)

![Por defecto el que hay](model/6.png)

![Reservado dinámicamente](model/7.png)

![Lo tamany recomendado para el MASTER es 90 GB](model/7.1.png)

:::caution
Si es un servidor MASTER que va a alojar lo mirror, tienes que dar bastante espacio para que quepa lo mirror (mínimo 70GB, en las pruebas se han utilizado 90GB).
:::

![Máquina creada](model/8.png)

Ahora clickem sobre configuración y name a la sección de almacenamiento (almacenamiento), clickem sobre "Vacío" y seleccionamos la iso de LliureX 19 descargada (desde el recuadro rojo)

![Vayamos a almacenamiento](model/9.png)

![Almacenamiento](model/10.png)

![Seleccionamos el CD](model/11.png)

![Seleccionamos la imagen](model/12.png)

Después vayamos a la sección de red y seleccionamos 3 adaptadores:

![Adaptador 1](model/13.png)

![Adaptador 2](model/15.png)

![Adaptador 3](model/16.png)

Después vayamos a pantalla y seleccionamos 128Mb de memoria de video.

![Pantalla](model/17.png)

Y le damos a Iniciar:

![Modelo](model/18.png)

Después hacemos click sobre **Instala versión de LliureX*

![Instala versión de LliureX](model/19.png)

![Basura click  continúa](model/20.png)

![Basura click  continúa](model/21.png)

![Basura click  continúa](model/22.png)

![Basura click  continúa](model/23.png)

![Basura click  Instal·la ahora](model/24.png)

![Basura click  continúa](model/25.0.png)

![Basura click  continúa](model/25.1.png)

Rellenamos los siguientes parámetros:

| Parámetro | Opción |
| -- | -- |
| Nombre | admin0 |
| Contraseña | Una segura, no lliurex |
| Nombre del ordenador | 4600xxxx.MAS |

![Basura click  continúa](model/26.png)

Y se procede a la instalación:

![Instalación](model/27.png)

Podemos hacer click  Reinicia o apagar el ordenador con el menú parar:

![Basura click  Reinicia](model/28.png)

Una vez tenemos el ordenador apagado podemos clonar la máquina:

![Clonación de la máquina](model/29.png)

Le damos el nombre a la máquina: 46000xxxx.CEN:

![Nuevo Nombre](model/30.png)

Y seleccionamos clonación completa:

![Clonación](model/31.png)

:::warning
A pesar de que aquí se explica la clonación completa. NO es recomendable hacerla, puesto que después va a requerir unas tareas de mantenimiento en la carpeta /etc/netplan para asegurarte que no se duplican ips. Si se hace la clonación completa se tiene que tratar de hacer siempre antes de inicializar el servidor y reiniciar las macs.
:::

El adaptador 2 lo cambiamos a centro en lugar de maestro:

![Adaptador 2](model/32.png)

![Adaptador 2](model/33.png)

Para simular la red del centro en virtualbox vayamos a hacer uso del administrador de red de virtualbox. Anema a **Archivo > Administrador de red anfitrión** y llenamos los parámetros como los de la figura (podéis utilizar la red de vuestro centro)

![Administrador de red anfitrión](model/34.1.png)

Emularemos también lo DHCP del router a pesar de que no me hacemos uso:

![Servidor DHCP](model/35.1.png)

:::warning
Lo router de Telefónica que tenemos en los centros nos proporciona DHCP y la salida a internet, si queremos emular el centro como es debido, podríamos instalar dnsmasq en nuestro ordenador (el hueste de virtualbox). Pero como se trata solo de probar cosas, dejamos que lo virtualbox doy DHCP a través de la 172.254.254.100 (aunque no es necesario puesto que vayamos a dar direcciones estáticas). Y utilizamos la dirección 172.254.254.1 para nuestro ordenador (hueste), para poder conectarnos remotamente si fuera necesario.
:::

Si queréis tener acceso a internet desde los servidores de virtualbox tenéis que hacer el siguiente:

```
sysctl limpio.ipv4.ip_forward
// Si se 0 entonces hay que aplicar la siguiente línea
sudo sysctl -w limpio.ipv4.ip_forward=1

sudo iptables -t nato -A POSTROUTING -o eth0 -j MASQUERADE

sudo iptables -A FORWARD -y vboxnet0 -j ACCEPT
```

# Inicialización del servidor

Para poder tener el modelo de centro es importante inicializar el servidor, dependiendo de la configuración que queremos tener tenemos que hacerlo de una manera u otra.

* Si solo volamos un servidor de aula, el servidor se inicia como *independiente**. 
* Si queremos tener un servidor *maestro** donde se hace la autenticación (LDAP), lo mirror, las carpetas de usuario y todos los servicios que vullguem dar hay que configurar el maestro y los servidor que se conectan a él, como *esclavos**.

Esta última es la configuración que más nos interesa. Para poder iniciar el servidor haremos uso del programa *zero-server-wizard**. Podemos iniciarlo bés desde la terminal con:

```
zero-server-wizard
```
:::info
El cero-center es un apartado exclusivo de lliurex donde se puede encontrar todo aquel software específico de la distribución o instaladores de software que bien porque requieren configuraciones especiales o bien porque son complicados de instalar, facilitan la tarea enormemente.
:::

Dónde amem al **zero-center** y buscamos el zero-server-wizard:

![Cero-center](model/36.png)

Iniciamos el zero-server-wizard

![zero-server-wizard](model/37.png)

En nuestro caso, vamos a iniciar este servidor como maestro. Tenemos que tener especial cura al incluir *exporta el /limpio**, para  tener solo uno mirror. La *IP interna** nos interesa tenerla controlada para saber cuál es cada servidor. Y la interfaz de replicación que es por donde se montará el /limpio entre los servidores.

![Configuración del servidor maestro](model/39.png)

:::caution
Si estás haciendo pruebas al virtualbox en tu casa tienes que tener en cuenta que no estás conectado en la red de Aulas, por lo tanto tienes que posar unos DNS diferentes. Se podan utilizado a modo de ejemplo 1.1.1.1 y 8.8.8.8.
:::

## Inicialización del servidor esclavo

Una vez iniciamos el servidor maestro, los esclavos los iniciamos del mismo modo, pero teniendo en cuenta que la ip será diferente y montaremos lo mirror del servidor maestro.

![Configuración del servidor esclavo](model/41.png)

Después de reiniciar volvemos al rape-center (recuerda que siempre al servidor esclavo) y ejecutamos lo **lliurex-mirror-redirect**.

![liurex-mirror-redirect](model/42.png)

Escribimos nuestro usuario y contraseña. La última entrada la dejamos en blanco.

![Usuario y contraseña](model/43.png)

Y activamos la opción del lliurex-mirror-redirect. Puedes ir después a la carpeta */limpio/mirror** o escribir a la terminal **mount | grep mirror** para asegurarte que está montado.

![Activar la opción](model/44.png)

# Instalación de clientes

De hace un tiempo Consellería ha decidido prescindir de los clientes ligero, y ya no se realizan compras de los mismos. Aunque en los centros  han muchos y LliureX continuará apoyando.

## Clientes ligeros

Para utilizar clientes ligeros utilizaremos *lo admin-center** que podemos encontrar tan en el cero-center como en la página de inicio del firefox. Al entrar a lo admin-center nos encontraremos este menú.

![Menú Admin Center](model/45.png)

Haremos click sobre LliureX LTSP y veremos el menú de Gestión de Clientes LTSP, haremos click sobre Gestión de Imágenes de cliente.

![Gestión de Clientes LTSP](model/46.png)

 Una vez ahí Crearemos una nueva imagen.
 
:::info
Puedes tener tantas imágenes como vullgues. Si tienes diferentes modelos de clientes ligeros, tal vez te interese tener varías. Además, si tienes una pizarra digital, es conveniente tener una imagen para el ordenador en pizarra y otra para el resto de ordenadores.
:::

![Creación de una nueva imagen](model/47.png)

Escogemos la opción de cliente puesto que esta es la que nos permite logar-noes con LDAP del servidor del servidor maestro.

![Cliente](model/48.png)

![Cliente - parámetros](model/49.png)

### Asociar cliente a imagen

Podemos asociar la imagen de un cliente para que se inicie siempre con esa imagen. Esta situación nos interesarà principalmente al ordenador del profesor si tiene una pizarra digital. Vamos a Gestión de cliente del aula:

![Gestión de clientes del aula](model/54.png)

Para poder ver los clientes es necesario que se hayan puesto en marcha al menos una vez y sea lo mismo servidor quién los haya dado una ip (Las ips se agafan de la tabla del dnsmasq).

![Listado de ordenadores en el aula](model/55.png)

Haces doble click sobre un ordenador (estos vienen identificados con la ip y la MAC). Y nos aparecerá el siguiente menú:

![Configuración de cliente](model/56.png)

En el último apartado podemos ver un menú desplegable para escoger la imagen con la cual queremos arrancar.

:::info
Hace falta actualizado la página de lo admin-center una vez se han detectado los clientes para que funciono la ventana de parámetros.
:::

## Instalar nuevo software en una imagen



## Clientes pesados

Para instalar clientes pesados la mejor opción es habilitar la instalación por red. Por lo tanto, vamos  a LliureX Netinstall y configuramos los parámetros para hacer una instalación desatendida. 

![LliureX Netinstall](model/50.1.png)

Ejemplo de intal·lació.

![Parámetros instalación desatendida 1](model/50.png)

![Parámetros instalación desatendida 2](model/51.png)


## Boot Manager

Para escoger la imagen que se ejecuta por defecto podemos ir al menú principal a **Boot Manager** y cambiar qué opciones por defecto volamos para iniciar el servidor.

![Menú boot manager](model/53.png)

# Creación de usuarios con Llum

Llum es al herramienta que nos va a permitir gestionar los usuarios de nuestro centro. Podemos acceder a la luz desde el cero-center. Podemos crear todos los usuarios del centro importando los usuarios de Itaca, para hacer esto hay que ir a la pestaña de "Centro" y escoger la entrada "Importación/Exportación" donde seleccionaremos la opción Aula LliureX.

![Itaca](model/usuarios29.png)

Y después iniciamos llum:

![Llum](model/57.png)

Una vez hemos iniciado Llum vamos a la opción de importar/exportar de Itaca e importamos los usuarios.

:::warning
Se podría tener un modelo de centro funcionando con servidores virtualitzats sobre una misma LliureX? Sí, en ninguna parte de PROXMOX, podríamos tener como sistema base una LliureX y enlazar la tarjeta externa de cada servidor a la tarjeta física donde está conectado lo switch para el aula de informática, para los ordenadores del centro, etc... Pero no tendríamos gestión remota (o sería más complicado). Y LliureX no se un sistema pensado para tal fin. PROXMOX sí.
:::