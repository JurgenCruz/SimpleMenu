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
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: favoriteItemDelegate
    property int margin
    property int iconSize: plasmoid.configuration.iconSize
    width: ListView.view.width
    implicitWidth: ListView.view.width
    height: model.isSeparator ? 24 : iconSize + (margin * 2)
    implicitHeight: model.isSeparator ? 24 : iconSize + (margin * 2)
    Accessible.role: model.isSeparator ? Accessible.Separator : Accessible.MenuItem
    Accessible.name: ("name" in model ? model.name : ("display" in model ? model.display : "name"))
    enabled: !model.isSeparator

    function onClick() {
        return model;
    }

    FontMetrics {
        id: fontMetrics
        font: label.font
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: iconRectangle
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Layout.fillHeight: true
            width: iconSize + (margin * 2)
            implicitWidth: iconSize + (margin * 2)
            color: 'transparent'
            visible: !model.isSeparator

            PlasmaCore.IconItem {
                anchors.fill: parent
                anchors.leftMargin: favoriteItemDelegate.margin
                anchors.topMargin: favoriteItemDelegate.margin
                anchors.bottomMargin: favoriteItemDelegate.margin
                colorGroup: PlasmaCore.Theme.ComplementaryColorGroup
                animated: false
                usesPlasmaTheme: true
                source: model.decoration !== undefined ? model.decoration : ""
                smooth: true
            }
        }

        Rectangle {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Layout.fillWidth: !model.isSeparator
            Layout.fillHeight: true
            width: model.isSeparator ? fontMetrics.advanceWidth(label.text) + (2 * favoriteItemDelegate.margin) : undefined
            color: 'transparent'

            PlasmaComponents.Label {
                id: label
                anchors.fill: parent
                anchors.margins: favoriteItemDelegate.margin
                maximumLineCount: 1
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                color: theme.textColor
                text: ("name" in model ? model.name : ("display" in model ? model.display : "name"))
            }
        }

        Rectangle {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Layout.fillWidth: true
            height: 1
            visible: !!model.isSeparator
            color: '#888888'
        }
    }
}