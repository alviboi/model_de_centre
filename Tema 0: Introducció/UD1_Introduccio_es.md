---
title: "INTRODUCCIÓN A LLIUREX"
author: [Creado por José A. Murcia, Àngels Piera i Albert Fletes \newline Adaptado por Alfredo Vicente]
dato: "2021-02-24"
subject: "Proxmox"
keywords: [Red, Instalación]
subtitle: "Introducción a conceptos básicos de LliureX"
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


# Qué es LliureX

*LliureX* es la distribución GNU/Linux desarrollada por la Generalitat Valenciana para facilitar el acceso a las TIC en la comunidad educativa.

El proyecto LliureX nació el 2004, y actualmente se encuentra presente en todos los centros públicos del País valenciano, en más de 120.000 equipos y servidores. El año 2019 recibió el premio *Open Awards* a la innovación tecnológica en el campo de la educación[^1], y se ha convertido en un referente respecto a distribuciones educativas basadas en software libre* a escala mundial.

[^1]: https://portal.edu.gva.es/lliurex/?p=1433

## Software libre?

Cuando hablamos de software libre*, hacemos referencia a todo aquel software* del cual podemos estudiar el código fuente*, modificarlo, utilizarlo con cualquier finalidad y redistribuïr-lo.

Para entender mejor estos conceptos, podemos hacer un símil con el mundo de la cocina. El software o software* en inglés, podría ser un plato, y el código fuente* sería la receta para elaborar este. Con estas premisas, podemos tener dos visiones de qué sería la cocina:

* Aquella que guarda en secreto la receta, para que nadie la pueda copiar* y mantener la exclusividad del plato, o bien
* Aquella que publica los ingredientes y el procedimiento pe hacerla, de forma que nosotros la podemos cocinar en casa, la podemos adaptar o modificar a nuestro gusto, y la podemos redistribuir para hacerla llegar a otras para que la prueban o mejoran. Además, como que tenemos la lista de ingredientes, podemos saber si hay algún alérgeno presente.

Volviendo al mundo del software, la primera visión sería aquella que se corresponde en el software propietario, del que no  conocemos el código fuente, y del que no podemos saber como trabaja ni que hace con nuestros datos personales. El segundo punto de vista sería el que se correspondería en el software libre, donde todo el código es público y abierto, de forma que sabemos como trabaja, que hace con nuestros datos, y podemos aplicarle cualquier mejora o adaptación.

> *Las cuatro libertades del software libre** 
>
> Todo software es libre si nos aporta las siguientes libertades*:
> 
> * Libertad de utilizar el software con cualquier finalidad,
> * Libertad de estudiar el código fuente y modificarlo para adaptarlo en las propias necesidades,
> * Libertad para distribuirlo cómo y a quién vullguem,
> * Libertad para hacer mejoras y hacerlas públicas, de forma que se beneficie toda la comunidad.

## Qué aporta LliureX

LliureX es una variante del sistema operativo GNU/Linux Ubuntu, modificada, mejorada y adaptada al ecosistema educativo valenciano. LliureX es código libre, y además del sistema operativo de base, incorpora una gran variedad de aplicaciones educativas, adaptaciones y desarrollos propios, para facilitar la tarea docente, de mantenimiento y de administración de equipos a los docentes.

De entre las principales características que aporta LliureX, podemos destacar:

* Es fácil de utilizar y configurar, 
* Soporta varios idiomas, con el valenciano como lengua destacada. En este punto, hay que decir que además de la traducción al valenciano del mismo sistema se ha colaborado con la traducción de partes de Ubuntu, se ha trabajado conjuntamente con Softvalencià para la traducción de varias aplicaciones, entre ellas LibreOffice, y se ha colaborado también con instituciones como ARASAAC, en la traducción del banco de pictogramas y la futura web.
* Incluye una buena colección de aplicaciones educativas organizadas por niveles y para todos los ámbitos.
* Incluye recursos educativos: actividades jclic, html, etc.
* Incorpora herramientas de creación de Objetos Digitales Educativos (ODE): para crear actividades con diferentes formatos.
* Ahorra los costes de las licencias de software y muchas horas de mantenimiento, al ser un sistema menos vulnerable a malware y piratas informáticos,
* Optimiza de la dotación informática de centro, y nos puede aprovechar para reutilizar equipos viejos, puesto que está diseñado para consumir menos recursos que otros sistemas operativos propietarios
* Además del sistema operativo por equipos individuales, aporta todo un modelo de aula y de centro, de forma que centraliza en servidores todos los datos del centro, y facilita la gestión remota de los equipos.

## Versiones y sabores de LliureX

LliureX tira actualizaciones completas del sistema aproximadamente cada dos años, basándose en la última versión LTS (*Long Term Support* de Ubuntu). La última versión completa, basada en Ubuntu 18.04 es LliureX 19. Además, los años que no se actualiza completamente el sistema de base, se realiza una actualización completa del software, y se añaden mejoras, pero sin cambiar este sistema de base. La última versión, LliureX 20, utiliza pues la misma base que LliureX 19, pero con muchas mejoras añadidas.

Por otro lado, cada versión tiene diferentes Sabores*. Podemos decir que los sabores* son adaptaciones de LliureX a los diferentes contextos educativos en que se vayan a implantar. Así, los diferentes sabores que presenta LliureX son:

* **LliureX Escritorio**: Pensada para ordenadores autónomos (no conectados a ningún servidor), y con un subconjunto de aplicaciones orientadas principalmente a secundaria y bachillerato.
* **LliureX Infantil**: Pensada también para ordenadores autónomos, pero con una selección de software por defecto más orientada a alumnos de infantil y los primeros cursos de primaria.
* **LliureX Música**: Versión de escritorio pensada para los ordenadores del aula de música, con software específico para el tratamiento, la edición y la composición de audio.
* **LliureX Pyme**: Versión de escritorio reducida, sin aplicaciones educativas, y pensada para pequeñas y medias emprendidas que desean introducirse en el mundo del software libre.
* **LliureX Servidor**: Pensada para los servidores del centro, que centralizan la gestión, apoyan a clientes ligeros (como los ordenadores de la biblioteca), y almacenan la información de los usuarios del centro.
* *Cliente**: Versión de escritorio que depende de un servidor, de forma que se conecta a este para validar los usuarios y guardar en él los datos. La versión Servidor y Cliente están pensadas para implantarse al modelo de centro, donde se dependerá de uno o varios servidores centrales, y el resto de ordenadores del centro serán clientes. De este modo, nos conectamos desde donde nos conectamos, tenemos disponibles nuestros datos.
* *FP**: Desde la versión de LliureX 19.07 (Julio 2020) también se dispone de un sabor pensado para ciclos formativos, sin las aplicaciones educativas orientadas a primaria y secundaria, y con una selección de software de gestión empresarial.

En este curso, utilizaremos la versión de Escritorio, y si tenemos que utilizar software preinstalado en otro sabor, veremos como hacerlo a nuestra instalación.

## LliureX y la inclusión

Desde sus inicios hasta el día de hoy, LliureX ha acompañado los centras en su transformación digital, y teniendo en especial consideración aquella parte del alumnado que presenta necesidades educativas especiales o dificultades de aprendizaje. 

Con el fin de acercar las Tecnologías de la Información y la Comunicación al alumnado con necesidades educativas especiales, y convertirlas en un elemento integrador e innovador, la Consellería de Educación, a través de la D.G. de Innovación Tecnológica Educativa, puso en marcha el plan INTEGRA-TIC entre los años 2008-2010. Este plan contemplaba dotar las aulas de los centros de Educación Especial de pizarra digital, cañón proyector y ordenador con LliureX. Las dimensiones de la pizarra, facilitan el trabajo a los alumnos con problemas motores o dificultades grafomotrices, o bien alumnas que por sus características cognitivas, no saben utilizar el ratón. Además, la PDI también presentaba muchas posibilidades de trabajo: desde las rutinas diarias, hasta actividades de aprendizaje más activas y participativas.

LliureX estuvo presente durante todo este proceso con la adaptación y mejora de herramientas para el trabajo con pizarras digitales como lo Notebook o el desarrollo de aplicaciones propias de accesibilidad como la herramienta MiniScreen para el control de la PDI por parte de alumnas con problemas de movilidad.

A pesar de aportar una gran mejora, el sistema no era perfecto. Con el tiempo, se ha tenido que mejorar y adaptar a las nuevas circunstancias con la aplicación del modelo de centro y han aparecido nuevos retos, como la integración de las tabletas digitales al aula.

Por ahora, las posibilidades que ofrece LliureX en cuanto al mundo de la inclusión se pueden resumir en:

* Aplicaciones del sistema y de terceros adaptadas e incluidas a LliureX:
    * En torno a escritorio Accesible,
    * Herramienta *Eviacam* para controlar el ratón con el movimiento del jefe,
    * *AraSuite*, que incluye el AraWord y lo Tico, con los pictogramas de ARASAAC

* Herramientas desarrolladas específicamente para LliureX:
    * *LliureX Miniscreen*, para el control de la PDI para alumnos con movilidad reducida,
    * *Casimir Editor*, editor de texto para alumnos con dificultades de aprendizaje como la dislexia,
    * *ClassJam*, o la Asamblea de aula*, para trabajar la Asamblea del aula con la PDI
    * *CloudBook*, para realizar todo tipo de recurso educativo, 

* Además, se ha colaborado con otros proyectos, entre ellos:
    * Portal Aragonés de Comunicación Alternativa y Aumentativa* (*ARASAAC), con la adaptación al valenciano de su banco de pictogramas y el sitio web,
    * *joComunico*, de Joan Pahisa, un comunicador pictográfico que procesa el lenguaje de forma natural,

Actualmente, el principal reto es mejorar el uso conjunto de las tabletas digitales con LliureX.

## Recursos en linea

Para conocer un poquito mejor el proyecto, tenemos a nuestro alcance diferentes recursos en linea que podemos consultar, a través de la página web del proyecto [https://portal.edu.gva.es/lliurex/](https://portal.edu.gva.es/lliurex/), desde donde podréis conocer las últimas noticias, la historia y las motivaciones del proyecto, y acceder a:

* La página de *Descargas**, desde donde podréis descargaros diferentes versiones y sabores de LliureX,
* *Recursos**, como explicaciones del modelo de centro o acceso al material de diferentes cursos de formación, 
* El *Foro** de LliureX, que supone una gran base de conocimiento de dudas que han planteado otros compañeros y que os permite preguntar qualevol duda que tengáis al equipo,
* La *Wiki de LliureX**, que podéis acceder también a través de la dirección web [https://wiki.edu.gva.es/lliurex/tiki-index.php](https://wiki.edu.gva.es/lliurex/tiki-index.php), y donde podéis encontrar muchísima información sobre las aplicaciones incluidas a LliureX, el modelo de centro, etc.

# Obtención e instalación de LliureX

La mejor forma de trabajar con LliureX es tenerlo instalado al ordenador, puesto que aprovechamos todos los recursos de este. Desde la versión 19.07 de LliureX (julio 2020), también tenemos disponible LliuWin, un instalador de LliureX como si  se tratara de una aplicación para Windows. Otra opción, a pesar de que con las limitaciones esperables de compartir los recursos del ordenador es hacer uso de máquinas virtuales.

Para realizar este curso, necesitaréis una instalación de LliureX a vuestros ordenadores. Vamos a ver las diferentes opciones que tenéis a vuestro alcance porque escogéis la que más os convenga.

## Instalación de LliureX al ordenador

Como hemos comentado, la mejor manera de trabajar con LliureX es tenerlo instalado a nuestro ordenador. El proceso general para lo cual será el siguiente:

1. Obtención de una imagen ISO* de LliureX desde la web
2. Creación de un USB de arranque con LliureX
3. Arranque desde USB e instalación del sistema

Hay que tener en cuenta que si queremos instalar LliureX en un ordenador que ya tiene un sistema operativo previamente instalado, como pueda ser Windows, nos tendremos que asegurar de tener espacio suficiente en disco para instalar LliureX. A pesar de que una instalación limpia ocupa unos 13 GB, sería conveniente disponer de un mínimo de 20-30 GB libres al disco.

### Obtención de la ISO de LliureX

Para descargar LliureX, accederemos a la sección de descargas de la página web de LliureX:

![Acceso a las descargas de LliureX](img/descarregues_1.png){ width=450px }

En esta página, veremos que podemos descargar cualquier Sabor* de las diferentes versiones de LliureX.

Para descargar la versión de escritorio, abriremos el desplegale corresponden al sabor (la barra con el texto Escritorio* y el signo +), y después en el botón de decàrrega del sistema en 64 bits:

![Acceso a las descargas de LliureX](img/descarregues_2.png){ width=450px }

Una vez hacemos clic, se iniciará la descarga a nuestro ordenador. Esto puede tardar un tiempo, puesto que se trata de un fichero de un peso considerable.

El fichero descargado, será un fichero con extensión *.iso*, que tendremos que volcar sobre una memoria USB con espacio suficiente, para arrancar nuestro ordenador con él.

### Creación de un USB de arranque

Una vez disponemos de la imagen *.iso* descargada, tendremos que volcarla a un dispositivo de memoria USB. Como que este fichero ocupa 3.3 Gb, con una memoria USB de 4 GB debería de ser suficiente, pero podemos utilizar una de mayor capacidad. *Hay que tener en cuenta que esta memoria USB se utilizará de forma exclussiva para el volcado de la imagen, por el que cualquier fichero que contenga será borrado.*

A los siguientes puntos, vamos a ver como generar este USB de arranque tanto desde LliureX como desde Windows.

*Creación del USB de arranque con LliureX/Ubuntu*

Si queremos crear el USB de arranque desde un ordenador con LliureX o Ubuntu, lo haremos a través de la herramienta *Startup Disk Creator*. A la [wiki de LliureX](https://wiki.edu.gva.es/lliurex/tiki-index.php?page=creaci%C3%B3+d%27un+USB+d%27arrancada) tenemos descrito este proceso. 

El que tendremos que hacer es buscar esta aplicación desde el menú de inicio (Sistema* > *Startup Disk Creator) y ejecutarla:

![Acceso a Startup Disk Creator desde Ubuntu](img/usb1.png){ width=400px }

La pantalla principal de esta aplicación nos muestra dos secciones: la parte superior, con la lista de imágenes *iso* que conoce la aplicación (Imagen de Disco Font), y la parte inferior (Disco a utilizar), con la lista de memorias USB conectadas en ese momento. Para crear el USB de arranque, tendremos que tenerlo conectado antes de iniciar la aplicación para qué esta lo detecto.

![Startup Disk Creator desde Ubuntu](img/usb2.png){ width=450px }

Inicialmente, si no nos aparece el fichero *.iso* que hemos descargado en la lista superior, haremos clic en Otros*, y buscaremos dentro de nuestro ordenador la imagen que hemos descargado (generalmente en la carpeta de Descargas).

Hecho esto, nos tendremos que asegurar que tenemos a la parte superior seleccionada la imagen de LliureX que hemos descargado, y a la parte inferior seleccionado el dispositivo sobre el qué queremos crear la imarge. Si todo es correcto, tendremos que hacer clic al botón Crea un disco de arranque* para iniciar el proceso.

En este momento, después de un posible misstge advirtiendo de la pérdida de datos de la memoria USB, se nos mostrará una barra con el progreso de la creación. Cuando esté finalizando, es posible que hajam de introduïr la contrassenya del usuario administrador, para hacer el USB arrancable.

Finalmente, nos mostrará la siguiente ventana indicando que ha finalizado el proceso.

![Startup Disk Creator desde Ubuntu](img/usb3.png){ width=350px }

Con esto ya tendremos el USB preparado para arrancar el ordenador con un sistema *live* de LliureX. 

En el artículo de la wiki se nos comenta también, como alternativa, como realizar este proceso desde la línea de órdenes. Este proceso se basa en orden desde la terminal, y requiere de algunos conocimientos más avanzados, pero en ocasiones, puede sernos útil en casos en que la creación de la usb de forma gráfica dóne problemas (bien por el formato de algunas imágenes *iso*, o bien por cuestiones de espacio a la memoria).

*Creación del USB de arranque desde Windows o Mac*

Para crear el disco de arranque USB desde otros sistemas, como Windows, Guapos, o incluso GNU/Linux (si no queremos utilizar el Startup Disco Creator), haremos uso de la herramienta *Etcher*.

Para lo cual, el primero que tendremos que hacer es acceder en su web https://www.balena.io/etcher/, y descargarlo para nuestro sistema.

![Página web de Etcher](img/etcher1.png){ width=300px }

Una vez descargado, excutem el instalador, aceptamos la licencia y en breve tendremos el acceso directo a Etche a nuestro escritorio.

![Instalación de Etcher](img/etcher2.png){ width=300px }

El uso de esta herramienta es bastante sencillo, y consta de tres sencillos pasos:

1. Hagamos clic a la prmiera icono *Flash from image* y seleccionamos el fichero *.iso* que hemos descargado.

![Selección de la ISO](img/etcher3.png){ width=300px }

2. Hagamos clic sobre *Select Drive*, para escoger el dispositivo USB sobre el que queremos volcar la imagen.

![Selección del dispositivo](img/etcher4.png){ width=300px }

3. Finalmente hacemos clic al botón *Flash* para hacer volcar la imagen que hemos seleccionado sobre el dispositivo escogido.

Con esto, ya tendremos un dispositivo USB preparado para arrancar en modo Live y probar o instalar LliureX con él.

### Arranc desde el USB e instalación de LliureX

Lo siguiente paso es arrancar nuestro ordenador desde el dispositivo USB qué hemos creado. Para lo cual tendremos que poner en marcha nuestro ordenador con la memporia USB conectada, y acceder al menú de arranque del sistema.

Cada fabricante utiliza una tecla diferente para acceder al menú de arranque. A la siguiente tabla se muestran las teclas más habituales para acceder al menú de arranque para diferentes fabricantes:

| Marca del ordenador | Tecla Boot Menu |
|-------------------------|-----------------------------------|
| Acero | F12 |
| Asus | Esc o F8, según modelos |
| Dell | F12 |
| Fujitsu | F12 |
| Gateway | F12 |
| HP | Esc |
| Huawei | F12 |
| Intel NUDO | F10 |
| Lenonvo | F12 |
| Samsung | Esc |
| Sony | F11, Esc, F10 según modelos |
| Toshiba | F12 | 
 
Cuando reiniciamos el ordenador y pulsamos la tecla correspondiente a nuestro equipo, se nos mostrará un menú similar al siguiente, al qué tendremos que indicar que queremos arrancar desde el USB que hemos creado:

![Menú de arrancada](img/boot_menu.png){ width=300px }

Una vez seleccionada la opción, arrancaremos desde el USB, que nos cargará una versión *Live* de LliureX para poder probarlo e instalarlo.

Vemos a continuación las diferentes pantallas que se nos presentan y las diferentes opciones de instalación que tenemos:

1. *Pantalla de arrancada de LliureX Live:** En esta primera pantalla cuando arrancamos desde el USB tendremos que pulsar una tecla para iniciar la sesión Live de LliureX. Si no polsem ninguna tecla, el sistema se iniciará desde el disco llevar del ordenador.

![Pantalla de arranc de LliureX Live](img/instllx1.png){ width=350px }


2. *Menú de inicio del sistema Live**, con diferentes opciones, como hacer un testeig de memoria o comproar si el CD/USB de instalación tiene defectos. Elegiremos la opción *Probáis LliureX sin instalarlo**, para iniciar el modo live y desde él empezar la instalación.

![Menú de inicio del sistema Live](img/instllx2.png){ width=350px }

En caso de que tengamos el modo UEFI activado a nuestro ordenador, es posible que estas opciones de arranque cambien, dando opción a iniciar LliureX Live en modo UEFI o bien a instalar directamente el sistema. En este caso, podamos bien lanzar directamente el instalador o bien arrancar la sesión Live, y desde esta instalar LliureX directamente. Disponéis de uno [extenso artículo](https://wiki.edu.gva.es/lliurex/tiki-index.php?page=uefi) a la wiki de LliureX sobre qué es UEFI y como activarlo y desactivarlo al ordenador.

3. **LliureX Live**: Se iniciará LliureX en modo Live desde el USB, y a partir de aci podremos iniciar la instalación. Para lo cual *haremos doble clic al icono Instala la versión LliureX*** que aparece a la escrptori. 

![LliureX Live](img/instllx3.png){ width=350px }

4. *Instalador de LliureX**: Ahora se iniciará el instalador de LliureX. La primera ventana de este asistente de instalación nos pedirá qué idioma deseamos para la instalación y el sistema.

![Selección de idioma](img/instllx4.png){ width=350px }

5. *Selección de la distribución del teclado**, en este caso, elegiremos la Disposición en Espanyol* y la variante del catalán para tener habilitado el punto volado (lo de la ele geminada *l·l).

![Selección de la distribución del teclado](img/instllx5.png){ width=350px }

6. *Selección de la distribución del escritorio**, donde podremos elegir qué apariencia queremos darle a nuestro escritorio LliureX. Tenemos dos opciones. La primero es la distribución por defecto* (*Default Layout), con una barra superior y lo *dock* a la parte inferior, tal y como se ha estado trabajando en las últimas versiones de LliureX. La segunda opción es una distribución más clásica (*Classic Layout) con una única barra a la parte inferior. *En principio escogeremos la distribución por defecto**.

![Distriubució del escritorio](img/instllx6.png){ width=350px }

7. *Elige de software adicional**, en principio no tendremos que instalar este software por defecto, por el que *no marcaremos nada y polsarem en Continua**.

![Software adicional](img/instllx7.png){ width=350px }

8. *Complementos del sistema**, desde donde podremos habilitar el apoyo de flash, así como el envío de estadísticas de uso de LliureX de forma anónima y el servicio de inventario, para recoger información del hardware. A nuestro caso, dejaremos marcado el apoyo de flash y el uso de estadítiques.

![Complementos del sistema](img/instllx8.png){ width=350px }

9. *Tipo de instalación**. Este es uno de los puntos más delicados de la instalación, y es donde decidiremos la parte de disco llevar que vayamos a dedicar a LliureX. El propio particionador ya nos sugerirá la distribución que considero más adecuada según el espacio que encuentro disponible en el disco duro bajo la opción de *particionament guiado*.

![Tipo de instalación](img/instllx9.png){ width=500px }

Cuando hablamos de particiones* hagamos referencia a las partes en que dividimos, de forma lógica un disco llevar, de forma que es cómo si tuvimos tantos discos duros como particiones. Cada sistema operativo necesita ubicar su sistema de ficheros en una de estas particiones. En esta ventana de Tipo de instalación* tenemos varias opciones para hacer estas particiones:

* Guiado - redimensiona disco y utiliza el espacio libre*, que será la opción recomendada, siempre que lo particionador encuentro espacio suficiente en el disco como para hacer la instalación. A la instalación de ejemplo que estamos haciendo se ha utilizado este sistema, sobre un disco que ya tenía varias particiones. El sistema ha detectado la partición donde más espacio disponible había y nos ha sugerido reducir esta y crear una nueva para instalar LliureX. Cómo vemos a la imagen, se nos muestra el estado actual del disco, y como quedaría después de hacer la nueva partición. En esta barra de bajo, fijaos que aparece una flecha doble entre la partición que vayamos a redimensionar y la nueva por sí queremos ajustar los espacios. Si deseáis ajustar el espacio, recordaos de dejar unos 20GB para la partición con LliureX.

* Guiado - utiliza el disco entero*. En este caso, se borraría todo el contenido que tuvimos al disco, y lo utilizaría completamente para LliureX.

* Guiado - utiliza el disco entero y configura LVM*, es parecido al anterior pero utilizando volúmenes lógicos ( *LVM, Logical Volume Manager), que gestiona varias particiones como si se tratara de una.

* Guiado - utiliza el disco entero y configura LVM cifrado*, que seria como el anterior, pero cifrando el disco.

* Manual*, es la opción más versátil y potente, puesto que nos permite gestionar las particiones a nuestro gusto, y por tanto, la más peligrosa si no sabemos muy bien qué estamos haciendo.

El más recomendable, será pues, seguir el modo guiado que nos sugiere el reparticionament del disco.

Una vez elegimos el tipo de instalación nos mostrará el siguiente mensaje advirtiendo que se van a hacer cambios al disco, y pidiendo confirmación:

![Confirmación de los cambios al disco](img/instllx10.png){ width=300px }

Una vez le damos a Continuar* el sistema empezará a instalarse, mientras sigue el asistente para configurar el sistema.

10. *Selección de la ubicación**. La siguiente ventana nos pregunta la región donde estamos, para establecer el huso horario correctamente. A la parte inferior de la ventana, podremos ver el progreso de la instalación.

![Configuración regional](img/instllx11.png){ width=350px }

11. *Configuración del usuario primario**. En la siguiente ventana configuraremos el nombre del usuario primario (que tendrá permiso de administrador), su contraseña y así como el nombre del sistema. Además, determinaremos si hace falta una contrassenya para entrar al ordenador. Indicaremos nuestro nombre, el nombre de usuario que utilizaremos, nuestra contraseña (dos veces) y que sí que volamos una contraseña para entrar.

![Creación del usuario](img/instllx12.png){ width=350px }

12 . *Últimos pasos de la instalación**. Una vez configurado el sistema, este sigue con su instalación. Mientras lo hace, nos muestra las principales novedades de la versión. Ahora tendremos que esperar un rato para que el sistema esté instalado por completo.

![Proceso de instalación](img/instllx13.png){ width=350px }

13. Cuando finaliza la instalación por completo, nos muestra la siguiente ventana informándonos, y pidiéndonos si queremos reiniciar el equipo o seguir con la prueba. Elegimos la opción de reiniciar, y quitamos el USB cuando nos diga el sistema. Cuando el ordenador se inicie de nuevo, nos mostrará el menú de inicio, al cual podremos elegir qué sistema operativo iniciar.

![Fin de la instalación](img/instllx14.png){ width=300px }

* Página de la wiki de LliureX sobre la instalación:
https://wiki.edu.gva.es/lliurex/tiki-index.php?page=instal%C2%B7laci%C3%B3+de+LliureX+16&highlight=instal%C2%B7laci%C3%B3+lliurex


## Instalación de LliureX sobre Windows: LliuWin

Si no deseamos dedicar una partición del disco a LliureX, desde LliureX 19.07 podemos hacer uso de LliuWin. 

LliuWin es un instalador de LliureX para Windows, de forma que se pueda probar sin correr el riesgo de perder información durante el formateado o particionament. La idea es instalar LliureX y poder desinstalarlo cómo si se tratara de una aplicación más de Windows. Para lo cual hace uso de una imagen de LliureX ubicada como un fichero sobre el mismo sistema de ficheros de Windows. No se trata por lo tanto de una virtualización de LliureX, sinò de una instalación en sí, con la diferencia que en lugar de dedicar una partición del disco, esta se instala sobre un fichero de Windows, y es este quien se encarga de ponerla en marcha o de poner en marcha Windows. La principal diferencia en cuanto al rendimiento frente a un sistema instalado es que este último descansa sobre el sistema de ficheros de Windows, el que hace que no sea óptimo.

El proceso de instalación de LliuWin consta de dos pasos genéricos:

1. Descarga e instalación de *LliuWin Installer
2. Ejecución de *LliuWin Installer* para descargar la imagen de LliureX

### Descarga e instalación de LliuWin

Para obtener el instalador de *LliuWin*, tendremos que acceder a la [suya página a Github](https://github.com/lliurex/lliuwin/releases), y descargar el fichero instalador `lliuwin_installer_x64.msi`:

![Página de descarga de LliuWin](img/lliuwin1.png){ width=450px }

Una vez descargado, ejecutamos el instalador. Si nos aparece un misstge de protección de Windows pareciendo al siguiente, elegiremos *Ejecutar de todas formas*, que nos aparece cuando hacemos clic en Más información*.

![Mensaje de protección de Windows](img/lliuwin2.png){ width=300px }

Ahora dejamos que el programa realizo cambios al equipo:

![Dando permissos al instalador](img/lliuwin3.png){ width=300px }

Y nos aparecerá el siguiente icono al escritorio (y también al menú de aplicaciones):

![Icono de LliuWin](img/lliuwin4.png){ width=100px }

Con esto tendremos instalado *LliuWin Installer*, que nos permitirá instalar LliureX sobre Windows.

### Descarga e instalación de LliureX con LliuWin Installer

Para iniciar el instalador, basura doble clic al acceso directo de LliuWin, y seleccionamos, cuando nos pregunto, que queremos permitir que la aplicación realize cambios al dispositivo:

![Permiso para LliuWin](img/lliuwin5.png){ width=300px }

La ventana principal del instalador nos mostrará algunas opciones sobre la instalación de LliureX, como son la unidad de disco sobre la que queremos descargar la imagen (a nuestro caso `C:`), el idioma en que queremos LliureX, que ocupa la instalación, y qué en torno a escritorio queremos (LliureX)

![Opciones para la descarga de LliuWin](img/lliuwin6.png){ width=400px }

Haremos clic al instalar para empezar la instalación. Este proceso puede ser bastante lento, puesto que tiene que descarrgar todo el sistema. 

![Proceso de descarga](img/lliuwin7.png){ width=300px }

Cuando acabo la descarga tendremos que reiniciar para finalizar el asistente de configuración:

![Proceso de descarga](img/lliuwin8.png){ width=300px }

Y cuando arrancamos Windows, nos pedirá qué de los dos sistemas arrancar:

![Selección del sistema operativo desde Windows](img/lliuwin10.png){ width=400px }

![LliureX sobre Windows](img/lliuwin9.png){ width=400px }

Con esto hemos conseguido realizar una instalación de LliureX sobre un ordenador sin necesidad de hacer particiones del disco llevar, como si se tratara de una aplicación más. En el momento en que queramos desinstalarlo, lo hicimos de igual manera como si se tratara de una aplicación Windows.

# Un paseo por el en torno a LliureX

Desde la versión 19 de LliureX, se utiliza la en torno a escritorio Plasma, de KDE en lugar de Mate o Gnome que se ha utilizado en versiones anteriores. Se trata de un escritorio que respeta los recursos del sistema y le da un aspecto más moderno y útil.

A pesar de que no entraremos a verlo en detalle, vamos a hacer una breve paseada por el escritorio para conocer, cuál será el nuestro en torno a trabajo.


## El escriptiori

A la Wiki de LliureX tenéis disponible [el artículo Primeros pasos en el nuez en torno a LliureX 19](https://wiki.edu.gva.es/lliurex/tiki-index.php?page=primers-passos-en-el-nou-entorn-de-lliurex-19) donde se os habla más extensamente del escritorio de LliureX 19. En este apartado vayamos a hacer un resumen, *basándonos en la configuración de escritorio por defecto** y posando atención a aquellos aspectos que más nos interesarán para el desarrollo del curso.

Cuando iniciamos sesión, el aspecto de nuestro escritorio es el que se muestra a la imagen siguiente, donde podemos distinguir tres áreas muy diferenciadas:

* El *Escritorio**, 
* La *barra superior** o *barra de menú**,
* El ***Dock*** inferior o *barra de tareas**.

![Escritorio de LliureX](img/escriptori1.png){ width=500px }

Como podemos ver, la barra de menú consta de varias partes:

* El *Menú de inicio**, a través del cual podremos acceder a las aplicaciones, organizadas por categorías, o buscarlas a través del cuadro de busca, así como gestionar la sesión y la parada del ordenador a través de la opción Energía/Sesión*. Además, a la parte izquierda dispondremos de una barra de Preferidos*, con accesos directos a las aplicaciones más importantes, tales como el navegador Firefox, el centro de control, el Cero Center, el gestor de ficheros Dolphin, la LliureX Store o la terminal. A la parte superior de esta barra de accesos directos tendremos también tres accesos para salir de la sesión, reiniciar el equipo o apagarlo.
* *Lugares** o *Directorios Habituales**, nos mostrará aquellas ubicaciones más usuales de nuestro equipo, como nuestra carpeta personal (Inicio), la carpeta del Escritorio, los Documentos o las Bajadas, entre otros.
* Botón para *Limpiar el esriptori**, minimizando todas las ventanas de las aplicaciones que tengamos en ejecución,
* La *Bandeja del Sistema**, que muestra los widgets* o *widgets* de aplicaciones que tengan bueno notificaciones disponibles (como por ejemplo qué hay actualizaciones disponibles), o acceso a algunas funcionalidades, como gestionar el volumen, la red, el Bluetooth o lo lleva-recortes. Si pasamos el ratón sobre los widgets, nos mostrará la información sobre este. Algunos de estos widgets* nos permiten también realizar ciertas acciones, al hacer clic sobre ellas. 
* El *Calendario**, donde por defecto se muestra la hora del sisema, y nos muestra el calendario completo si hagamos clic sobre él.
* El *Selector de usuario**, donde se nos muestra nuestro nombre de usuario. Si hagamos clic sobre él, se nos mostrarán opciones para iniciar una nueva sesión, bloquear la pantalla, o salir de la sesión actual.

Por su parte, a la parte inferior se encuentra el *Dock* o Gestor de tareas*, a través del cual podremos acceder de manera rápida a las diferentes aplicaciones que tengamos en ejecución. Esta barra también dispone de algunos accesos directos a las aplicaciones más comunes, como el Firefox, el gestor de ficheros o las preferencias del sistema. Si queremos añadir alguna aplicación a esta barra, para iniciarla con un solo clic desde el escritorio, solo tenemos que localizarla al menú y arrastrarla hasta aci.

## Donde están mis cosas?

Nuestros documentos, y ficheros en general se guardan en nuestra carpeta de usuario. Es conveniente conocer como se organiza esta para mantener una organización coherente, y saber donde guardamos todo aquello que basura.

### El sistema de ficheros de LliureX

Como sabemos, tanto los documentos como los programas se almacenan a una partición del disco llevar, y dentro de esta, se organizan el que se conoce como directorios*, o más habitualmente **carpetas***. Estos directorios se organizan de forma jerárquica, es decir, unas carpetas dentro de otras. Vamos a ver en general como se organizan estas carpetas a nivel de sistema, y después como lo hacen en nuestra carpeta de usuario.

A escala de sistema, existe un directorio (carpeta), llamado directorio raíz* a partir del cual cuelgan* el resto de directorios. Es decir, es la carpeta* que contiene el resto de carpetas. LliureX sigue la estructura de carpetas recomendada por el estándar FHS (*Filesystem Hierarchy Standard), una norma que define los directorios principales y sus contenidos en el sistema operativo GNU/Linux. 

![Carpeta raíz del sistema](img/carpeta_arrel.png){ width=400px }

Algunas de las carpetas más importantes de esta organización son:

*  */bin**: Con los programas esenciales de la línea de órdenes necesarios para una sesión de usuario (copia de ficheros, listar directorios, etc.)
*  */boot**: Encargada de la puesta en marcha del sistema,
*  */etc**: Que contiene ficheros de configuración del sistema,
*  */hombre**: Con las carpetas de trabajo de los usuarios. Dentro de esta carpeta habrá una carpeta de trabajo para cada usuario del sistema./ 
*  *media**: Carpeta donde se montarán* los dispositivos que conectamos al ordenador, como puedan ser las memorias USB. Los sistemas Linux, a diferencia de Windows, no generan una nueva unidad (D:, E:, etc.) cuando conectamos un dispositivo, sino que añaden carpetas dentro de esta carpeta. Los accesos que  tendremos a Dispositivos*, harán referencia en estas carpetas.
*  */opt**: Carpeta con programas opcionales que tienen una configuración personalizada pera cada usuario.
* */root**: Carpeta personal del administrador del sistema. Por motivos de seguridad, esta no se encuentra dentro del directorio /hombre*.
* */sbin**: Con los programas esenciales de la línea de órdenes que solo puede utilizar el usuario administrador,
* */usr**: Con la mayoría de aplicaciones y utilidades multiusuari del sistema.

Cómo hemos comentado, hay más carpetas a la raíz del sistema, pero con las qué hemos comentado nos es suficiente para hacernos una idea de las más importantes.

### La carpeta de Inicio

Nos centramos ahora al directorio /hombre*, que contendrá una carpeta con el nombre de cada usuario. Esta será la carpeta que, desde el punto de vista de nuestro usuario se nos mostrará como la carpeta de Inicio*:

![Carpeta del usuario](img/carpeta_usuari.png){ width=400px }

La ventana anterior muestra la aplicación *Dolphin*, que es el explorador de ficheros del entorno KDE. Para acceder a ella, lo hemos hecho a través del acceso directo que hay a la barra de tareas inferior, con el icono de una carpeta. También  podemos acceder a través del menú de inicio* y su barra lateral de Preferidos*, o bien a través de los Directorios Habituales* o Lugares*.

Cómo vemos, esta carpeta de inicio contiene otras carpetas, tales como:

* *Bajadas**, donde se guardarán de forma predeterminada los ficheros que descargamos desde el navegador u otras aplicaciones,
* *Documentos**, donde se guardan de forma predeterminada los documentos,
* *Escritorio**, que contiene los ficheros que tenemos a nuestro escritorio, es decir, los ficheros y carpetas que dejamos al escritorio, se almacenará realmente en esta carpeta.
* *Imágenes**, donde se guardan de forma predeterminada nuestras imágenes,
* *Música**, donde se guardarán los ficheros de audio de forma predeterminada,
* *Videos**, donde se guardan nuestros videos.

Dentro de esta carpeta personal, podemos crear tantas carpetas y ficheros como deseamos, pero conviene mantener una mínima organización por saber en el jefe del tiempo donde tenemos nuestros ficheros.

El sistema operativo y las aplicaciones también almacenan algunas carpetas dentro de nuestra carpeta de inicio, con información personalizada para nuestro usuario. Estas carpetas y ficheros empezarán por un punto (.), y serán invisibles* al Dolphin.

> **La carpeta de Inicio al modelo de centro**
> 
> Cuando trabajamos con el modelo de centro, hay que tener en cuenta que tanto la carpeta de **Documentos*** como la de **Escritorio***, se almacenan al servidor, y son enlazadas en nuestra carpeta de Inicio cuando iniciamos sesión. De este modo, nos ubicamos al ordenador qué nos ubicamos, tendremos siempre disponible el contenido de nuestro escritorio y nuestros documentos. Por otro lado, ni las descargas, ni las imágenes ni otras carpetas que creamos en nuestra carpeta de inicio se guardarán al servidor. Por lo tanto, todo aquello que deseamos conservar y tener accesible en cada ordenador donde sentamos tendrá que guardarse bien al escritorio o bien en la carpeta de Documentos.

A continuación, podemos ver, de forma gráfica la relación entre todos los elementos que acabamos de comentar, así como su relación con el menú de Lugares* o Directorios Habituales*:

![Escritorio de LliureX](img/escriptori2.png){ width=500px }


# Gestión de software

Las aplicaciones se componen de varios ficheros, tanto ejecutables como de configuración o recursos, como puedan ser las imágenes, iconos, o documentos. Cuando instalamos una aplicación, todos estos recursos se ubican a su lugar respectivo dentro del sistema.