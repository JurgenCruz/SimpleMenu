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
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.private.kicker
import org.kde.coreaddons as KCoreAddons
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

FocusScope {
    RowLayout {
        anchors.fill: parent
        spacing: launcherMenu.margin

        SystemModel {
            id: systemModel
        }

        KCoreAddons.KUser {
            id: kuser
        }

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            color: 'transparent'
            width: Kirigami.Units.iconSizes.smallMedium
            height: width

            Kirigami.Icon {
                id: iconUser
                source: kuser.faceIconUrl.toString() || "user-identity"
                anchors.fill: parent
            }
        }

        Kirigami.Heading {
            wrapMode: Text.NoWrap
            color: Kirigami.Theme.textColor
            level: 3
            text: qsTr(kuser.fullName)
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: 'transparent'

            PlasmaExtras.Menu {
                id: contextMenu

                PlasmaExtras.MenuItem {
                    action: plasmoid.internalAction("configure")
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked: (mouse) => {
                    if (mouse.button == Qt.RightButton) {
                        contextMenu.open(mouse.x, mouse.y);
                    }
                }
            }
        }

        Repeater {
            model: systemModel
            PlasmaComponents3.ToolButton {
                activeFocusOnTab: true
                focus: index === 0
                icon.name: model.decoration
                onClicked: systemModel.trigger(index, "", null)
                ToolTip.delay: 300
                ToolTip.visible: hovered
                ToolTip.text: model.display
            }

            onCountChanged: {
                let child = itemAt(0);
                for (let i = 1; i < count; i++) {
                    let sibling = itemAt(i);
                    child.KeyNavigation.right = sibling;
                    child = sibling;
                }
            }
        }
    }
}