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
import org.kde.plasma.extras as PlasmaExtras

FocusScope {
    property alias model: listView.model
    property alias delegate: listView.delegate

    signal click(item: var, index: int)

    signal rightClick(item: var, index: int, x: real, y: real)

    signal upKeyLimit()

    signal downKeyLimit()

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
        focus: true
        flickDeceleration: 0.000001
        maximumFlickVelocity: 100000
        boundsBehavior: Flickable.StopAtBounds
        highlight: PlasmaExtras.Highlight
        {
            visible: listView.currentItem ? listView.currentItem.enabled : false
        }
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 0
        Keys.onPressed: event => {
            switch (event.key) {
                case Qt.Key_Enter:
                case Qt.Key_Return:
                    click(currentItem, currentIndex);
                    break;
                case Qt.Key_Up:
                    if (!tryNavigateUp()) {
                        upKeyLimit();
                        // return;
                    }
                    break;
                case Qt.Key_Down:
                    if (!tryNavigateDown()) {
                        downKeyLimit();
                        return;
                    }
                    break;
                default:
                    return;
            }
            event.accepted = true;
        }

        function tryNavigateUp(): bool {
            const newIndex = getNextAvailable(currentIndex, false);
            if (newIndex === currentIndex) {
                return false;
            }

            currentIndex = newIndex;
            return true;
        }

        function tryNavigateDown(): bool {
            const newIndex = getNextAvailable(currentIndex, true);
            if (newIndex === currentIndex) {
                return false;
            }

            currentIndex = newIndex;
            return true;
        }

        function getNextAvailable(ind, forward): int {
            let i = ind;
            while (true) {
                if (forward) {
                    if (i >= count - 1) {
                        break;
                    }
                    ++i;
                } else {
                    if (i <= 0) {
                        break;
                    }
                    --i;
                }

                if (getIsItemAvailable(i)) {
                    return i;
                }
            }

            return ind;
        }

        function getIsItemAvailable(ind): bool {
            if (ind < 0 || ind > count - 1) {
                return false;
            }

            return itemAtIndex(ind).enabled;
        }

        function selectAvailableItem() {
            if (!getIsItemAvailable(currentIndex)) {
                currentIndex = getNextAvailable(currentIndex, true);
            }
        }

        Component.onCompleted: {
            selectAvailableItem();
        }

        onActiveFocusChanged: {
            selectAvailableItem();
        }
    }
}