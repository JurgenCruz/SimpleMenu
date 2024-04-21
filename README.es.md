# Simple Menu

[![en](https://img.shields.io/badge/lang-en-blue.svg)](https://github.com/jurgencruz/simplemenu/blob/master/README.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](https://github.com/jurgencruz/simplemenu/blob/master/README.es.md)

Un menú de inicio simple para KDE Plasma.

## Características

- Enumere sus aplicaciones favoritas en orden alfabético.
- Enumere todas sus aplicaciones en orden alfabético, sin categorías.
- Barra de búsqueda.
- Opciones de energía y sesión.

¡Eso es todo! manteniéndolo simple.

## Capturas de pantalla

### Favoritos

![Favoritos](https://github.com/jurgencruz/simplemenu/blob/master/img/favorites.png?raw=true)

### Todas las aplicaciones

![Todas las aplicaciones](https://github.com/jurgencruz/simplemenu/blob/master/img/all-apps.png?raw=true)

### Buscar

![Buscar](https://github.com/jurgencruz/simplemenu/blob/master/img/search.png?raw=true)

### Menú contextual

![Menú contextual](https://github.com/jurgencruz/simplemenu/blob/master/img/context-menu.png?raw=true)

### Configuración

![Configuración](https://github.com/jurgencruz/simplemenu/blob/master/img/config.png?raw=true)

## Instalación

Este plasmoide requiere que los complementos de plasma de su distribución de Linux estén instalados para ejecutarse.

Para Ubuntu:

```bash
sudo apt install plasma-widgets-complementos
```

Para Arch:

```bash
sudo pacman -S kdeplasma-addons
```

Para compilarlo, también necesita tener CMAKE instalado.

Luego puede instalar este plasmoide con los siguientes pasos:

- Desde su emulador de consola favorito, `git clone` este repositorio.
- `cd` al repositorio recién clonado.
- Ejecute `cd ./build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr && make && sudo make install`.
- Después de la instalación, es posible que tenga que cerrar e iniciar sesión para que el widget aparezca disponible.

Si desea modificar el código, puede utilizar este comando para probar sus cambios en Plasmoid Viewer:

`(cd ./build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr && make && sudo make install) && plasmoidviewer -a com.github.jurgencruz.simplemenu`

## Licencia

Este proyecto está bajo la licencia [GNU GPL-3.0](https://choosealicense.com/licenses/gpl-3.0/).

## Contribuyendo

- Si tiene problemas con Simple Menu, abra un informe de error con información detallada sobre cómo reproducir el
  problema e intentaré solucionarlo.
- Si desea mejorar Simple Menu, envíe un PR con sus cambios y los revisaré. Aquí hay una guía sobre cómo desarrollar
  plasmoides de KDE: https://develop.kde.org/docs/plasma/widget/setup/.
- Si desea ayudar con una traducción, copie el archivo `package/translate/template.pot` y cambie el nombre a su código
  de localización (por ejemplo, en, de, fr, etc.) y la extensión a `.po`. Luego simplemente agregue su traducción en el
  campo `msgstr`. Para obtener más información, puede
  consultar https://zren.github.io/kde/docs/widget/#translations-i18n.

## Cómprame un café

Siempre puede invitarme un café aquí:

[![PayPal](https://img.shields.io/badge/PayPal-Donate-blue.svg?logo=paypal&style=for-the-badge)](https://www.paypal.com/donate/?business=AKVCM878H36R6&no_recurring=0&item_name=Cómprame+un+café¤cy_code=USD)
[![Ko-Fi](https://img.shields.io/badge/Ko--fi-Donate-blue.svg?logo=kofi&style=for-the-badge)](https://ko-fi.com/jurgencruz)
