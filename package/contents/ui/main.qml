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
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.private.kicker 0.1
import org.kde.kitemmodels 1.0

Item {
    id: simpleMenu
    anchors.fill: parent
    Plasmoid.icon: plasmoid.configuration.icon
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.fullRepresentation: SimpleMenu {
        root: simpleMenu
    }

    readonly property RootModel rootModel: RootModel
    {
        id: rootModel
        autoPopulate: false
        appletInterface: plasmoid
        flat: true
        sorted: true
        showSeparators: false
        showTopLevelItems: false
        showAllApps: true
        showAllAppsCategorized: true
        showRecentApps: false
        showRecentDocs: false
        showRecentContacts: false
        showPowerSession: false

        Component.onCompleted: {
            favoritesModel.initForClient("org.kde.plasma.kickoff.favorites.instance-" + plasmoid.id)
            if (!plasmoid.configuration.favoritesPortedToKAstats) {
                if (favoritesModel.count < 1) {
                    favoritesModel.portOldFavorites(plasmoid.configuration.favorites);
                }
                plasmoid.configuration.favoritesPortedToKAstats = true;
            }
        }
    }

    readonly property RunnerModel runnerModel: RunnerModel
    {
        id: runnerModel
        appletInterface: plasmoid
        favoritesModel: rootModel.favoritesModel
        mergeResults: false
        deleteWhenEmpty: true
    }

    readonly property KSortFilterProxyModel favoritesModel: KSortFilterProxyModel
    {
        sourceModel: rootModel.favoritesModel
        sortRole: "name"

        function trigger(i: int, actionId: string, arguments) {
            var index = mapToSource(this.index(i, 0));
            sourceModel.trigger(index.row, actionId, arguments);
        }
    }

    signal reset()

    Plasmoid.onExpandedChanged: {
        reset();
    }

    Component.onCompleted: {
        if (plasmoid.hasOwnProperty("activationTogglesExpanded")) {
            plasmoid.activationTogglesExpanded = true
        }
        plasmoid.hideOnWindowDeactivate = true;
    }

    function close() {
        Plasmoid.expanded = false
    }
}