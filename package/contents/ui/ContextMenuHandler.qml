/***************************************************************************
 *   Copyright (C) 2024 Jurgen Cruz                                        *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 3 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, see <https://www.gnu.org/licenses/>. *
 ***************************************************************************/

import QtQuick 2.15
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.15
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: contextMenuHandler
    property var contextMenu
    property var margin

    function buildAndShowMenu(itemIndex: int, actions: list, x: real, y: real, handler: Item) {
        if (contextMenu) {
            contextMenu.close()
            contextMenu.destroy()
        }
        contextMenu = contextMenuComponent.createObject(contextMenuHandler);
        fillMenu(contextMenu, itemIndex, actions, handler);
        contextMenu.popup(x, y);
    }

    function fillMenu(menu: PlasmaComponents.Menu, itemIndex: int, actions: list, handler: Item) {
        let isSeparatorAdded = false;
        actions.forEach(function (action) {
            if (action.subActions) {
                const submenuItem = submenuComponent.createObject(menu.contentItem, {
                    "actionItem": action,
                });
                fillMenu(submenuItem.submenu, itemIndex, action.subActions, handler);
                menu.addMenu(submenuItem);
                isSeparatorAdded = false;
            } else if (action.type === "separator" || action.type === "title") {
                if (!isSeparatorAdded) {
                    const separator = separatorComponent.createObject(menu.contentItem, {
                        "title": action.text
                    });
                    menu.addItem(separator);
                    isSeparatorAdded = true;
                }
            } else {
                const menuItem = menuItemComponent.createObject(menu.contentItem, {
                    "actionItem": action,
                    "handler": handler,
                    "itemIndex": itemIndex
                });
                menu.addItem(menuItem);
                isSeparatorAdded = false;
            }
        });
    }

    Component {
        id: contextMenuComponent

        Menu {
            modal: true
        }
    }

    Component {
        id: submenuComponent

        MenuItem {
            id: submenuItem
            property var actionItem
            text: actionItem.text ? actionItem.text : ""
            icon.name: actionItem.icon ? actionItem.icon : null

            property var submenu: Menu
            {
            }
        }
    }

    Component {
        id: menuItemComponent

        MenuItem {
            property var actionItem
            property Item handler
            property int itemIndex
            text: actionItem.text ? actionItem.text : ""
            enabled: actionItem.type != "title" && ("enabled" in actionItem ? actionItem.enabled : true)
            icon.name: actionItem.icon ? actionItem.icon : null
            checkable: actionItem.checkable ? actionItem.checkable : false
            checked: actionItem.checked ? actionItem.checked : false
            onClicked: {
                handler.click(itemIndex, actionItem.actionId, actionItem.actionArgument);
            }
        }
    }

    Component {
        id: separatorComponent

        MenuSeparator {
            property string title
            contentItem: RowLayout {
                FontMetrics {
                    id: fontMetrics
                    font: label.font
                }

                Rectangle {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    height: title == "" ? undefined : 12
                    width: fontMetrics.advanceWidth(label.text) + (2 * contextMenuHandler.margin)
                    color: 'transparent'

                    PlasmaComponents.Label {
                        id: label
                        font.pointSize: 9
                        anchors.fill: parent
                        anchors.margins: contextMenuHandler.margin
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        wrapMode: Text.Wrap
                        color: theme.textColor
                        text: title
                    }
                }

                Rectangle {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    Layout.fillWidth: true
                    height: 1
                    color: '#888888'
                }
            }
        }
    }
}