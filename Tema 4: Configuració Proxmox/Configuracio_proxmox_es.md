---
title: "CONFIGURACIÓN DE RED"
author: [Alfredo Rafael Vicente Boix y Javier Estellés Dasi]
dato: "2020-11-25"
subject: "Proxmox"
keywords: [Red, Instalación]
subtitle: "Ejemplo de esquema de red en el modelo de centro"
lang: "se"
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

En esta Unidad configuraremos la hipervisor con Proxmox. Montaremos 3 servidores con las siguientes características.

| Servidor | Características |
| -- | -- |
| MASTER | Tendrá el LDAP y guarda el /net |
| CENTRO | DHCP a los ordenadores del centro |
| AULA1 | DHCP a los ordenadores del aula de informática |
| WIFI |No montaremos el servidor WIFI en esta unidad |

Daremos como ejemplo dos esquemas clásicos de montaje del centro. Ambós son totalmente válidos y funcionan perfectamente.

:::info
La mayoría de pantallazos están en inglés, puesto que no tengo la costumbre de cambiado el lenguaje original de los programas. Obviamente si alguien quiere configurar los parámetros en la ventana de login al catalán o al español lo puede hacer sin problemas.
:::

## Esquema 1

En este esquema que posamos como ejemplo dos switchs tenemos 3 LAG configurados al switch principal por sí queremos montar un cluster con Proxmox hasta 3 ordenadores. Son 3 ordenadores puesto que 3 ordenadores permiten ya hacer un montaje de Alta disponibilidad, pero es un tema que explicaremos en cursos más avanzados.
Este esquema es típico de centros muchos grandes que tienen varías salas de informática y lo switch principal prácticamente lo utilizan para redistribuir las VLANs y con solo que tiene montados LAGs que van a cada uno de los switch del centro.

:::info
El alta disponibilidad (HA) permite que cuando uno hipervisor se estropea los otros cogen las máquinas virtuales del mismo y sigue dando servicio sin que el usuario lo noto. Así permite cambiar el hipervisor o arreglarlo y el servicio no es interrumpido en ningún momento. Para hacer esto es necesario montar un CEPH o una cabina externa con mucha fiabilidad.
:::

El esquema seria de la siguiente manera:

![Esquema orientativo 1](Esquemes/esquemabond.png)

## Esquema 2

Uno de las principales ventajas del siguiente esquema es que no utiliza VLANs, cada tarjeta de de la hipervisor va a un switch diferente. Este montaje se utiliza principalmente en centro pequeños. Igualmente permite el montaje de un cluster que podríamos conectar al router del centro en las bocas de la red VLAN. El equema seria de la siguiente manera:

![Esquema orientativo 2](Esquemes/esquemasense.png)

## Esquema de máquinas virtuales

Al fin los dos esquemas comparten el montaje de las máquinas virtuales puesto que la configuración de donde se conectan las tarjetas virtuales lo hacemos desde el proxmox. Hemos respetado los nombres de las tarjetas en ambos casos (vmbrX), pero se puede dar el nombre que vullgues.

![Esquema conexiones máquinas virtuales](Esquemes/Conexions hipervisor.png)

# Configuración del proxmox

Una vez tenemos instalado lo proxmox y haya reiniciado, podremos acceder en él. Toda la configuración del proxmox se realiza a través de un servidor web que puerta montado. Para acceder tenemos que hacerlo a través del puerto 8006 con certificación ssl. Sencillamente escribimos a una navegador de una estación de trabajo que esté en la misma red el siguiente:

```tcsh
https://"IP_HIPERVISOR:8006
```

::: info
Este es uno de los motivos por los cuales dejamos puertos en cada switch con la VLAN 1, para poder acceder a través de esos puertos siempre al proxmox. También se puede hacer desde cualquier ordenador del centro o el aula de informática, pero hay que habilitar el NATO en cada servidor LliureX. Y estos tienen que estar funcionando. Por lo tanto en este paso es necesario estar conectado en la red del centro.
:::

## Máquinas virtuales

Lo primero que nos pide es el usuario y contraseña que hemos configurado cuando hemos hecho la instalación:

![Esquema orientativo 2](ConProxmox/prox1.png)

Y una vez dentro podemos ver el espacio de trabajo del proxmox:

![Esquema orientativo 2](ConProxmox/prox2.png)

:::info
Los siguientes pasos son opcionales, pero aconsejables. Es para acceder a las últimas actualizaciones de proxmox.
:::

Una vez hemos accedido podemos configurar la lista de los repositorios de proxmox accediendo, en primer lugar al shell del hipervisor y escribimos el siguiente:

```tcsh
nano /etc/apt/sources.list.d/pve-enterprise.list
```
Ten en cuenta que has accedido como root, así que tienes que ir mucho con cuenta con el que haces. Una vez abres el fichero cambias el repositorio por el siguiente:

```tcsh
deb http://download.proxmox.com/debian/pve buster pve-no-subscription
```

Se quedaría así:

![Repositorio de proxmox](ConProxmox/prox3.png)

Ahora ya puedes actualizar desde la terminal lo proxmox para tener la última versión:

```tcsh
apt update
apt upgrade
```

## Crear máquina virtual

Antes de crear una máquina virtual tenemos que subir un iso de LliureX Server, podemos descargarla [de aquí](http://releases.lliurex.net/isos/19.07_64bits/). Tratamos de buscar la última versión editada.

Una vez la tenemos descarga tenemos que subirla al proxmox seleccionando el espacio *local** y haciendo click en upload:

![Subir iso a proxmox](ConProxmox/prox5.png)

![Subir iso a proxmox](ConProxmox/prox6.png)

Una vez tenemos hecho esto, ya podemos crear la primera maquina virtual. Vamos de hacer de ejemplo el servidor MASTER y los otros se hacen de manera similar. Hagamos click sobre **Create VM*

![Crear máquina virtual](ConProxmox/prox7.png)

Se abrirá una ventana para especificar los parámetros de configuración. En la primera ventana no hay que cambiar nada, vamos a **Next**:

![Polsem next](ConProxmox/prox8.png)

En este punto tenemos que seleccionar la iso que acabamos de subir:

![Seleccionamos ISO](ConProxmox/prox9.png)

Posteriormente damos a next:

![Opciones del sistema](ConProxmox/prox10.png)

Escogemos el disco llevar a utilizar, y opcionalmente cambiamos la cache a write back. 

:::info
Write-back puede dar un poco más de rendimiento al disco pero es más propenos a perder datos si hay un corte. Queda a criterio de cada cual escoger.
:::

![Opciones del disco llevar](ConProxmox/prox11.png)

Cambiamos los parámetros de la CPU, 4 cores en total es suficiente, en principio para las tareas a realizar.

![Opciones del disco llevar](ConProxmox/prox12.png)

Damos 6Gb de memoria RAM. Este parámetro irá siempre en función de la cantidad de máquinas que vayamos a tener.

:::caution
La suma de la memoria RAM de todas las máquinas puede ser sin problemas mayor que la cantidad de memoria RAM disponible. Eso sí, si todas las máquinas empiezan a pedir mucha memoria, el sistema se puede volver muy lento.
:::

![Memoria RAM](ConProxmox/prox13.png)

Finalmente, no cambiamos nada a los parámetro de red y una vez instalada la máquina ya añadiremos las tarjetas virtuales. Podemos activar el checkbox de **Start after created** para poder iniciar la máquina una vez le damos a **Finish**.

![Resumen de opciones](ConProxmox/prox14.png)

## Instalación de la máquina virtual

Una vez configurada la máquina virtual y haya arrancado podemos ver como nos aparece un icono en la franja izquierda y se posa de color, podemos desplegar el menú contextual y polsem sobre Console:

![Menú contextual de la VM en funcionamiento](ConProxmox/prox15.png)

Podemos ver cómo ha arrancado la máquina:

![Inicio de máquina virtual](ConProxmox/prox17.png)

Y procedemos a su instalación tal y como hemos visto a la Unidad 1.

De manera similar, si queremos seguir todo el proceso habría que instalar los otros dos servidores con le mismo procedimiento. Lo único que hay que cambiar entre ellos sería el nombre de cadascún de ellos, nosotros hemos escogido la siguiente nomenclatura:

| Nombre | Servidor |
| -- | -- |
| 4600xxxx.MAS | Servidor Master |
| 4600xxxx.CEN | Servidor de centro |
| 4600xxxx.AU1 | Servidor Aula informática |

Y para el administrador de cada uno de los servidor hemos escogido **admin0**. 

# Configuración de la red

Una vez tenemos instalados todos los servidores procedemos a configurar la red. Para acceder a la configuración de la hipervisor tenemos que seleccionar el mismo (No la máquina virtual ni lo Datacenter), y vamos a las opciones **Network**.

## Esquema 1

Recordamos que este esquema tiene un bond al switch. Polsem sobre **Create** y seleccionamos la opción *Linux Bond**.

![Selección de bond](ConProxmox/prox18.png)

Se nos abrirá la ventana siguiente y tenemos que escribir todas las tarjetas donde pose **Slaves**, seguidas de un espacio. La configuración quedaría de las siguiente manera:

| Parámetro | Opción |
| -- | -- |
| Slaves | enp1s0 enp2s0 enp3s0 enp4s0 |
| Modo | LACP |
| hash-policy | layer2+3 |

Y polsem sobre **Create**.

![Configuración del bond](ConProxmox/prox21.png)

na vez tenemos configurado lo bond vayamos otra vez a **Create** y seleccionamos *Linux Bridge**. A la opción *Bridge puertos** tenemos que escribir el bond0 seguido de un punto y el número de VLAN que quieren configurar a la conexión puente.

![Configuración de la conexión puente](ConProxmox/prox22.png)

De manera análoga realizamos todas las otras configuraciones y nos quedaría de la siguiente manera:

![Configuración de redes al proxmox](ConProxmox/prox23.png)

## Esquema 2

Este esquema que no presenta jefe VLAN se haría de manera análoga al anterior, pero sin configurar el bond. Cogeríamos cada tarjeta virtual *Linux bridge** y lo enlazamos a la tarjeta de salida. El esquema quedaría de la siguiente manera:

![Configuración de redes al proxmox](ConProxmox/prox46xxx.png)

:::caution
Uno de los problemas que presenta esta configuración es saber qué tarjeta se qué, podemos ir probando y ver cuál está activa con la herramienta **ip** para saber cuál es qué. Podemos ir desconectant los cables ver que aparece **state DOWN** y asociar la conexión.
:::

```tcsh
root@cefirevalencia:~# ip link show enp4s0
5: enp4s0: <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP> mtu 1500 qdisc pfifo_fasto master bond0 state DOWN modo DEFAULT group default qlen 1000
``` 

# Configuración de la red en cada máquina virtual

Tenemos que recordar que cada servidor LliureX tiene que tener 3 tarjetas:

| Tarjeta | Características |
| -- | -- |
| Tarjeta externa | Es la que se conectará en la red de Aulas |
| Tarjeta interna | Conectada a los ordenadores del aula o las clases |
| Tarjeta de replicación | Para montar el /net entre los servidores |

En nuestro caso recordamos que las tenemos configuradas de la siguiente manera:

| Tarjeta | nombre |
| -- | -- |
| Tarjeta externa | vmbr0 |
| Tarjeta interna | vmbr2, vmbr3, vmbr4, vmbr5 |
| Tarjeta de replicación | vmbr10 |

Para configurar cada máquina virtual seleccionamos la máquina y vamos a las opciones de *Hardware**, basura click sobre **Add** y escogemos **Network device**.

![Configuración de red de VM](ConProxmox/prox24.png)

Como cuando hemos instalado la máquina virtual ya nos ha cogido la vmbr0, esa la dejamos como la externa. Y configuramos ya la interna.

![Configuración de tarjeta virtual](ConProxmox/prox25.png)

Este procedimiento lo tenemos que repetir en todos los servidores. Recuerda que el esquema de red es el siguiente:

| IP | Servidor |
| -- | -- |
| 172.X.Y.254 | Servidor Maestro |
| 172.X.Y.253 | Servidor de Centro |
| 172.X.Y.252 | Servidor de Aula 1 |
| 172.X.Y.251 | Servidor de Aula 2 |
| 172.X.Y.250 | Servidor de Aula 3 |

## Tarjetas virtuales

:::warning
Es importante que nos aseguremos antes de inicializar el servidor qué tarjeta es qué, para que no nos confunden. El servidor podría empezar a dar DHCP a través de tarjeta conectada a la VLAN1 o router (dependiente del esquema) y podría dejar sin servicio en todo el centro.
:::

Podemos comprobar cuál es cada tarjeta con el mando ip hecho al servidor y comparar las MAC.

![Configuración de red de VM](ConProxmox/prox26.png)

## Inicialización servidores

Cuando iniciamos el servidor, en este caso el máster, escogemos las siguientes opciones:

![Inicializar el servidor](ConProxmox/prox27.png)

:::warning
Es muy importante que habilites la opción de exportar el /net al servidor maestro.
:::

Un procedimiento extra que no nos tiene que olvidar en ningún servidor es actualizarlos siempre antes de hacer nada. Y en el máster tenemos que configurar el lliurex mirror:

![Mirror](ConProxmox/prox29.png)

![Mirror](ConProxmox/prox30.png)

![Mirror](ConProxmox/prox31.png)

De manera similar inicializamos los otros servidores:

![Inicializar el servidor](ConProxmox/prox32.png)

:::warning
Es muy importante que habilites la opción monta el /net desde el maestro.
:::

# Configuraciones adicionales

## Arrancar las máquinas virtuales cuando inicia el servidor

Es importante que cuando se reinicie el hipervisor las máquinas virtuales arranquen automáticamente para no tener que conectarse al proxmox para ponerlas en marcha una a una. Para configurar esta opción seleccionaremos una máquina virtual y seleccionaremos la opción de configuración **Options** y cambiaremos los parámetros **Start at boot** a **Yes** y **Start/Shutdown order** a 1 en el caso del servidor maestro.

:::caution
Es recomendable arrancar primero el maestro y dejar un tiempo para que arranco y posteriormente arrancar los esclavos. Así, a los servidores esclavos añadiremos un tiempo a **Startup delay**.
:::

![Configuración de orden de arrancada](ConProxmox/prox33.png)

![Configuración de orden de arrancada](ConProxmox/prox34.png)

Al servidor de centro y esclavo las opciones quedarían de la siguiente manera:

![Configuración de orden de arrancada al servidor de centro](ConProxmox/prox35.png)

![Configuración de orden de arrancada al servidor del aula de informática](ConProxmox/prox36.png)

## Montaje de cabina externa (Opcional)

Es posible que nos interese la opción de una cabina externa. Tiene numerosas ventajas, en el espacio de la cabina externa podemos tener almacenado isos, discos duros de máquinas virtuales, copias de seguridad...

:::warning
Si decidís montar el /net a una cabina externa. Tenéis cuidado con las ACL!!!. Puesto que suelen dar problemas. La opción en este caso más segura para que funciono es tener el /net en un disco duro virtual.
Además, si vayáis a tener espacio almacenado a una cabina, la cabina tiene que tener unas características adeqüades. Yo recomendaría como mínimo:
* Posibilidad de crear un bond con 4 tarjetas de red, o tarjeta de 10G (haría falta uno switch que lo soporto)
* Al menos 4 discos duros para montar un RAID10
* Cache de disco SSD
De este modo se podría montar un sistema con Alta disponibilidad.
:::

:::info
En este curso no explicaremos como configurar una cabina para que funciono al modelo de red. Las cabinas no entran dentro de la dotación de centro, por lo tanto sería una adquisición propia del centro
:::

Una vez tenemos la cabina configurada podemos añadirla a nuestro **Datacenter** seleccionándolo y yendo a la opción de **Storage**. Hagamos click sobre **Add** y escogemos **NFS**.

![Configuración de cabina](ConProxmox/prox37.png)

Y seleccionamos las diferentes opciones de configuración:

![Configuración de cabina](ConProxmox/prox38.png)

## Creación de backup (Opcional)

En principio no sería necesario crear un backup de las máquinas virtuales puesto que hemos montado un RAID1. Pero  han varías configuraciones que podemos recomendar la opción del backup. Para configurar la copia de seguridad seleccionamos el datacenter, vamos a la opción de Backup y basura click sobre **Add**.

![Configuración de cabina](ConProxmox/prox39.png)

Nos aparecerá la siguiente ventana, tenemos que tener en cuenta en qué lugar queremos hacer el backup (**Storage*). Y seleccionamos la/las máquinas virtuales que queremos hacer copia de seguridad, en un principio, en nuestro caso solo habría que hacer la copia de seguridad del Máster, puesto que es donde se guarda el /net y LDAP. La copia de seguridad queda programada para una fecha determinada, en principio, en un centro, un sábado a las 12 de la noche no hay ningún usuario conectado.

![Configuración de la copia de seguridad](ConProxmox/prox40.png)

También es puede hacer una copia de seguridad en cualquier momento. Las copias de seguridad llevan tiempos, por lo tanto no es recomendable hacerlo en horas donde se estén utilizando los servidores.

![Creación de la copia de seguridad](ConProxmox/prox41.png)

![Creación de la copia de seguridad](ConProxmox/prox42.png)

Una vez tenemos la copia de seguridad hecha podemos restaurarla con **Restore**.

:::caution
Cuando se restaura la copia de seguridad se creará una nueva máquina virtual con las mismas características que la máquina antigua y nos preguntará en qué espacio queremos instalar la nueva máquina. Tenemos que tener cuidado de no tener las dos máquinas funcionando al mismo tiempo (después de restaurarla) puesto que creará problemas de red. También tenemos que recordar deshabilitar la opción de **Start at boot**, sino al reiniciar el hipervisor arrancarán las dos máquinas.

![Restaurar la copia de seguridad](ConProxmox/prox43.png)

![Restaurar la copia de seguridad](ConProxmox/prox44.png)


# Bibliografía y referencias

(@) https://es.wikipedia.org/wiki/vlan
