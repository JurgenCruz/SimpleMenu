# Simple Menu

A Simple Menu launcher for plasma KDE

## Features

- List your favorite applications in alphabetical order
- List all your apps in Alphabetical order, no categories 
- Search bar
- Power and Session options

That's it! keeping it simple

## Installation

This plasmoid requires the plasma addons from your linux distribution to be installed to run.

For Ubuntu:
```bash
sudo apt install plasma-widgets-addons
```
For Arch:
```bash
sudo pacman -S kdeplasma-addons
```

To build it, you need CMAKE installed as well.

You can then install this plasmoid with the following steps:

- from your favorite console emulator, git clone this repo
- cd into the just cloned repo
- run `cd ./build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr && make && sudo make install`
- After install, you may require to log out and log in again for the widget to appear available 

If you want to tinker with the code you may use this command to test your changes in the Plasmoid Viewer:

`(cd ./build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr && make && sudo make install) && plasmoidviewer -a com.github.jurgencruz.simplemenu`

## License

This project is under the [GNU GPL-3.0](https://choosealicense.com/licenses/gpl-3.0/) license.

## Contributing

- If you have issues with Simple Menu, please open a bug report with as detailed information on how to reproduce the issue, and I'll try to fix it.
- If you wish to improve Simple Menu, please submit a PR with your changes and I will review them. Here is a guide on how to develop KDE Plasmoids: https://develop.kde.org/docs/plasma/widget/setup/
- If you wish to help with a translation, copy the `package/translate/template.pot` file and change the name to your locale's code (e.g. en, de, fr, etc.) and the extension to `.po`. Then just add your translation in the `msgstr` field. For more information you can look at https://zren.github.io/kde/docs/widget/#translations-i18n.

## Buy me a coffee

You can always buy me a coffee here:

[![PayPal](https://img.shields.io/badge/PayPal-Donate-blue.svg?logo=paypal&style=for-the-badge)](https://www.paypal.com/donate/?business=AKVCM878H36R6&no_recurring=0&item_name=Buy+me+a+coffee&currency_code=USD)
