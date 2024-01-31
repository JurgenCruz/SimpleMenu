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
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.kirigami 2.10 as Kirigami
import "code/tools.js" as Tools
import com.github.jurgencruz.simplemenu 1.0 as SimpleMenu

Item {
    id: launcherMenu
    Layout.minimumWidth: 500
    Layout.maximumWidth: 500
    Layout.preferredWidth: 500
    Layout.preferredHeight: plasmoid.screenGeometry.height - 100
    property bool showLetterSeparator: plasmoid.configuration.showLetterSeparator
    property bool searching: searchField.text != ""
    property bool forceAllApps: false
    property bool favoritesVisible: !searching && !forceAllApps
    property int margin: 5
    property Item root

    function reset() {
        searchField.clear();
        forceAllApps = false;
        searchField.focus = true;
        contextMenuHandler.close();
    }

    function colorWithAlpha(color: color, alpha: real): color {
        return Qt.rgba(color.r, color.g, color.b, alpha);
    }

    function setAllAppsModel() {
        allAppsList.model = flattenModels(rootModel.modelForRow(0), plasmoid.configuration.showLetterSeparator);
    }

    function setSearchModel() {
        searchList.model = flattenModels(runnerModel, true);
    }

    function flattenModels(model, includeCategories: boolean) {
        const result = [];
        const categories = [];
        for (let i = 0; i < model.rowCount(); i++) {
            const childModel = model.modelForRow(i);
            result.push(childModel);
            categories.push(childModel.description);
        }
        return flattener.flatten(result, includeCategories ? categories : []);
    }

    onFavoritesVisibleChanged: {
        searchField.focus = true;
    }

    ContextMenuHandler {
        id: contextMenuHandler
        margin: launcherMenu.margin
    }

    SimpleMenu.Flattener {
        id: flattener
    }

    //Actual Menu
    ColumnLayout {
        anchors.fill: parent
        //focus: true
        state: 'favorites'
        states: [
            State {
                name: "favorites"
                when: favoritesVisible
                PropertyChanges {
                    target: favoritesPage
                    visible: 1
                    opacity: 1
                    x: 0
                }
                PropertyChanges {
                    target: allAppsPage
                    opacity: 0
                    x: allAppsPage.width
                    visible: 0
                }
            }, State {
                name: "allApps"
                when: !favoritesVisible
                PropertyChanges {
                    target: favoritesPage
                    opacity: 0
                    x: -favoritesPage.width
                    visible: 0
                }
                PropertyChanges {
                    target: allAppsPage
                    visible: 1
                    opacity: 1
                    x: 0
                }
            }]
        transitions: [
            Transition {
                from: "favorites"
                to: "allApps"
                SequentialAnimation {
                    PropertyAnimation {
                        target: favoritesPage
                        properties: "opacity,x"
                        duration: PlasmaCore.Units.shortDuration * 2
                    }
                    PropertyAction {
                        target: favoritesPage
                        property: "visible"
                        value: false
                    }
                    PropertyAction {
                        target: allAppsPage
                        property: "visible"
                        value: true
                    }
                    PropertyAnimation {
                        target: allAppsPage
                        properties: "opacity,x"
                        duration: PlasmaCore.Units.shortDuration * 2
                    }
                }
            }, Transition {
                from: "allApps"
                to: "favorites"
                SequentialAnimation {
                    PropertyAnimation {
                        target: allAppsPage
                        properties: "opacity,x"
                        duration: PlasmaCore.Units.shortDuration * 2
                    }
                    PropertyAction {
                        target: allAppsPage
                        property: "visible"
                        value: false
                    }
                    PropertyAction {
                        target: favoritesPage
                        property: "visible"
                        value: true
                    }
                    PropertyAnimation {
                        target: favoritesPage
                        properties: "opacity,x"
                        duration: PlasmaCore.Units.shortDuration * 2
                    }
                }
            }]

        //Search Panel
        Rectangle {
            Layout.fillWidth: true
            color: 'transparent'
            height: searchField.implicitHeight + (launcherMenu.margin * 2)

            RowLayout {
                anchors.fill: parent
                anchors.topMargin: launcherMenu.margin
                anchors.bottomMargin: launcherMenu.margin
                anchors.leftMargin: launcherMenu.margin
                anchors.rightMargin: launcherMenu.margin
                spacing: launcherMenu.margin

                Rectangle {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    width: PlasmaCore.Units.iconSizes.small
                    height: width
                    color: 'transparent'

                    Kirigami.Icon {
                        anchors.fill: parent
                        source: 'search'
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    color: 'transparent'
                    height: searchField.implicitHeight

                    PlasmaComponents3.TextField {
                        id: searchField
                        anchors.fill: parent
                        activeFocusOnTab: true
                        focus: true
                        placeholderText: i18n("Search...")
                        placeholderTextColor: colorWithAlpha(theme.textColor, 0.6)
                        onTextChanged: runnerModel.query = text;

                        function clear() {
                            text = "";
                        }

                        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Escape) {
                                event.accepted = true
                                if (text != "") {
                                    clear()
                                } else {
                                    root.close();
                                }
                            }
                        }
                    }
                }
            }
        }

        //Favorites Page
        Rectangle {
            id: favoritesPage
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: 'transparent'

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: launcherMenu.margin
                anchors.bottomMargin: launcherMenu.margin
                anchors.leftMargin: launcherMenu.margin
                anchors.rightMargin: launcherMenu.margin
                spacing: launcherMenu.margin

                Item {
                    id: favoriteHandler

                    function click(itemIndex: int, actionId: string, actionArgument) {
                        if (Tools.triggerAction(favoritesList.model, itemIndex, actionId, actionArgument) === true) {
                            plasmoid.expanded = false;
                        }
                    }
                }

                HoverableListView {
                    id: favoritesList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    model: favoritesModel
                    delegate: FavoritesItemDelegate {
                        margin: launcherMenu.margin
                    }
                    onClick: (item, index) => {
                        model.trigger(index, "", null);
                    }
                    onRightClick: (item, index, x, y) => {
                        const hasActionList = item.favoriteId != null || ("hasActionList" in item && item.hasActionList === true);
                        const actionList = hasActionList ? item.actionList : [];
                        const actions = Tools.getActions(i18n, actionList, rootModel.favoritesModel, item.favoriteId);
                        contextMenuHandler.buildAndShowMenu(index, actions, x, y, favoriteHandler);
                    }
                }

                //All Apps Button
                Rectangle {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    color: 'transparent'
                    height: btnGoAllApps.height

                    PlasmaComponents3.Button {
                        anchors.fill: parent
                        id: btnGoAllApps
                        icon.name: "go-next"
                        text: i18n("All apps")
                        onClicked: {
                            forceAllApps = true
                        }
                    }
                }
            }
        }

        //All Apps Page
        Rectangle {
            id: allAppsPage
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: 'transparent'

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: launcherMenu.margin
                anchors.bottomMargin: launcherMenu.margin
                anchors.leftMargin: launcherMenu.margin
                anchors.rightMargin: launcherMenu.margin
                spacing: launcherMenu.margin

                Item {
                    id: allAppsHandler

                    function click(itemIndex: int, actionId: string, actionArgument) {
                        const info = allAppsList.model.getInfo(itemIndex);
                        if (Tools.triggerAction(info.model, info.index, actionId, actionArgument) === true) {
                            plasmoid.expanded = false;
                        }
                    }
                }

                //All Apps List
                HoverableListView {
                    id: allAppsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    visible: searching ? 0 : 1
                    delegate: FavoritesItemDelegate {
                        margin: launcherMenu.margin
                    }
                    onClick: (item, index) => {
                        const info = model.getInfo(index);
                        info.model.trigger(info.index, "", null);
                    }
                    onRightClick: (item, index, x, y) => {
                        const info = model.getInfo(index);
                        const hasActionList = item.favoriteId != null || ("hasActionList" in item && item.hasActionList === true);
                        const actionList = hasActionList ? item.actionList : [];
                        const actions = Tools.getActions(i18n, actionList, info.model.favoritesModel, item.favoriteId);
                        contextMenuHandler.buildAndShowMenu(index, actions, x, y, allAppsHandler);
                    }
                }

                Item {
                    id: searchHandler

                    function click(itemIndex: int, actionId: string, actionArgument) {
                        const info = searchList.model.getInfo(itemIndex);
                        if (Tools.triggerAction(info.model, info.index, actionId, actionArgument) === true) {
                            plasmoid.expanded = false;
                        }
                    }
                }

                //Search List
                HoverableListView {
                    id: searchList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    visible: searching ? 1 : 0
                    delegate: FavoritesItemDelegate {
                        margin: launcherMenu.margin
                    }
                    onClick: (item, index) => {
                        const info = model.getInfo(index);
                        info.model.trigger(info.index, "", null);
                    }
                    onRightClick: (item, index, x, y) => {
                        const info = model.getInfo(index);
                        const hasActionList = item.favoriteId != null || ("hasActionList" in item && item.hasActionList === true);
                        const actionList = hasActionList ? item.actionList : [];
                        const actions = Tools.getActions(i18n, actionList, info.model.favoritesModel, item.favoriteId);
                        contextMenuHandler.buildAndShowMenu(index, actions, x, y, searchHandler);
                    }
                }

                //Go to Favorites Button
                Rectangle {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    color: 'transparent'
                    height: btnGoFavorites.height

                    PlasmaComponents3.Button {
                        anchors.fill: parent
                        id: btnGoFavorites
                        icon.name: 'go-previous'
                        text: i18n("Favorites")

                        onClicked: {
                            forceAllApps = false
                            searchField.text = ''
                        }
                    }
                }
            }
        }

        //Footer
        PlasmaExtras.PlasmoidHeading {
            id: footer
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            position: PlasmaComponents3.ToolBar.Footer

            Footer {
                anchors.fill: parent
            }
        }

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                event.accepted = true;
                root.close();
            }
        }
    }

    Component.onCompleted: {
        rootModel.refreshed.connect(setAllAppsModel);
        runnerModel.queryFinished.connect(setSearchModel);
        showLetterSeparatorChanged.connect(setAllAppsModel);
        reset();
        rootModel.refresh();
        root.reset.connect(reset);
    }
}