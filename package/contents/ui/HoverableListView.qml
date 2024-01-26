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
import org.kde.plasma.components 2.0 as PlasmaComponents

Rectangle {
    color: 'transparent'
    property alias model: listView.model
    property alias delegate: listView.delegate

    signal click(item: var, index: int)

    signal rightClick(item: var, index: int, x: real, y: real)

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        property real pressX: -1
        property real pressY: -1
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        z: 2

        onPositionChanged: mouse => {
            selectItem(mouse.x, mouse.y);
        }

        onPressed: mouse => {
            mouse.accepted = true
            selectItem(mouse.x, mouse.y);
            pressX = mouse.x;
            pressY = mouse.y;
        }

        onReleased: mouse => {
            mouse.accepted = true
            selectItem(mouse.x, mouse.y);
            if (!listView.currentItem.enabled) {
                return;
            }
            if (Math.abs(pressX - mouse.x) < 10.0 && Math.abs(pressY - mouse.y) < 10.0) {
                //There was no drag, continue
                if (mouse.button === Qt.LeftButton) {
                    click(listView.currentItem.onClick(), listView.currentIndex);
                } else if (mouse.button === Qt.RightButton) {
                    rightClick(listView.currentItem.onClick(), listView.currentIndex, mouse.x, mouse.y);
                }
            }
        }

        function selectItem(x: real, y: real) {
            const pos = mapToItem(listView.contentItem, x, y);
            listView.currentIndex = listView.indexAt(pos.x, pos.y);
        }
    }

    ListView {
        id: listView
        anchors.fill: parent
        clip: true
        activeFocusOnTab: true
        boundsBehavior: Flickable.StopAtBounds
        highlight: PlasmaComponents.Highlight
        {
            visible: listView.currentItem ? listView.currentItem.enabled : false
        }
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 0
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                event.accepted = true;
                click(currentItem, currentIndex);
            }
        }
    }
}