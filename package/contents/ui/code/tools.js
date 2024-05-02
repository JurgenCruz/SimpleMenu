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

.pragma library

function getActions(i18n, actionList, favoriteModel, favoriteId) {
    const actions = createFavoriteActions(i18n, favoriteModel, favoriteId);
    if (actions) {
        if (actionList && actionList.length > 0) {
            const actionListCopy = Array.from(actionList);
            actionListCopy.push({
                "type": "separator"
            });
            actionListCopy.push.apply(actionListCopy, actions);
            actionList = actionListCopy;
        } else {
            actionList = actions;
        }
    }
    return actionList;
}

function createFavoriteActions(i18n, favoriteModel, favoriteId) {
    if (favoriteModel == null || !favoriteModel.enabled || favoriteId == null) {
        return null;
    }
    if (favoriteModel.activities === undefined || favoriteModel.activities.runningActivities.length <= 1) {
        return createSingleActivityActions(i18n, favoriteModel, favoriteId);
    } else {
        return createMultipleActivitiesActions(i18n, favoriteModel, favoriteId);
    }
}

function createSingleActivityActions(i18n, favoriteModel, favoriteId) {
    const action = {
        actionArgument: {
            favoriteModel: favoriteModel,
            favoriteId: favoriteId
        }
    };
    if (favoriteModel.isFavorite(favoriteId)) {
        action.text = i18n("Remove from Favorites");
        action.icon = "bookmark-remove";
        action.actionId = "_kicker_favorite_remove";
    } else if (favoriteModel.maxFavorites === -1 || favoriteModel.count < favoriteModel.maxFavorites) {
        action.text = i18n("Add to Favorites");
        action.icon = "bookmark-new";
        action.actionId = "_kicker_favorite_add";
    } else {
        return null;
    }
    return [action];
}

function createMultipleActivitiesActions(i18n, favoriteModel, favoriteId) {
    const actions = [];
    const linkedActivities = favoriteModel.linkedActivitiesFor(favoriteId);
    const activities = favoriteModel.activities.runningActivities;
    const linkedToAllActivities = linkedActivities.indexOf(":global") !== -1;
    actions.push({
        text: i18n("On All Activities"),
        checkable: true,
        actionId: linkedToAllActivities ? "_kicker_favorite_remove_from_activity" : "_kicker_favorite_set_to_activity",
        checked: linkedToAllActivities,
        actionArgument: {
            favoriteModel: favoriteModel,
            favoriteId: favoriteId,
            favoriteActivity: ""
        }
    });
    actions.push(createActivityItem(favoriteModel.activities.currentActivity, i18n("On the Current Activity"), linkedActivities, linkedToAllActivities, favoriteModel, favoriteId));
    actions.push({
        type: "separator"
    });
    activities.forEach(activityId => {
        actions.push(createActivityItem(activityId, favoriteModel.activityNameForId(activityId), linkedActivities, linkedToAllActivities, favoriteModel, favoriteId));
    });
    return [{
        text: i18n("Show in Favorites"),
        icon: "favorite",
        subActions: actions
    }];
}

function createActivityItem(activityId, activityName, linkedActivities, linkedToAllActivities, favoriteModel, favoriteId) {
    const linkedToThisActivity = linkedActivities.indexOf(activityId) !== -1;
    return {
        text: activityName,
        checkable: true,
        checked: linkedToThisActivity && !linkedToAllActivities,
        actionId: linkedToAllActivities
            ? "_kicker_favorite_set_to_activity"
            : linkedToThisActivity
                ? "_kicker_favorite_remove_from_activity"
                : "_kicker_favorite_add_to_activity",
        actionArgument: {
            favoriteModel: favoriteModel,
            favoriteId: favoriteId,
            favoriteActivity: activityId
        }
    };
}

function triggerAction(model, index, actionId, actionArgument) {
    if (actionId.startsWith("_kicker_favorite_")) {
        handleFavoriteAction(actionId, actionArgument);
        return true;
    }
    return model.trigger(index, actionId, actionArgument);
}

function handleFavoriteAction(actionId, actionArgument) {
    const favoriteId = actionArgument.favoriteId;
    const favoriteModel = actionArgument.favoriteModel;
    if (favoriteModel === null || favoriteId == null) {
        return;
    }
    if (actionId == "_kicker_favorite_remove") {
        favoriteModel.removeFavorite(favoriteId);
    } else if (actionId == "_kicker_favorite_add") {
        favoriteModel.addFavorite(favoriteId);
    } else if (actionId == "_kicker_favorite_remove_from_activity") {
        favoriteModel.removeFavoriteFrom(favoriteId, actionArgument.favoriteActivity);
    } else if (actionId == "_kicker_favorite_add_to_activity") {
        favoriteModel.addFavoriteTo(favoriteId, actionArgument.favoriteActivity);
    } else if (actionId == "_kicker_favorite_set_to_activity") {
        favoriteModel.setFavoriteOn(favoriteId, actionArgument.favoriteActivity);
    }
}
