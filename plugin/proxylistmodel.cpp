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

#include "proxylistmodel.h"

ProxyListModel::ProxyListModel(QObject *parent)
        : QAbstractListModel(parent) {}

ProxyListModel::~ProxyListModel() = default;

QHash<int, QByteArray> ProxyListModel::staticRoleNames() {
    QHash<int, QByteArray> roles;
    roles.insert(Qt::DisplayRole, "display");
    roles.insert(Qt::DecorationRole, "decoration");
    roles.insert(GroupRole, "group");
    roles.insert(DescriptionRole, "description");
    roles.insert(FavoriteIdRole, "favoriteId");
    roles.insert(IsParentRole, "isParent");
    roles.insert(IsSeparatorRole, "isSeparator");
    roles.insert(HasChildrenRole, "hasChildren");
    roles.insert(HasActionListRole, "hasActionList");
    roles.insert(ActionListRole, "actionList");
    roles.insert(UrlRole, "url");
    roles.insert(DisabledRole, "disabled");
    roles.insert(IsMultilineTextRole, "isMultilineText");
    roles.insert(DisplayWrappedRole, "displayWrapped");

    return roles;
}

QHash<int, QByteArray> ProxyListModel::roleNames() const {
    return staticRoleNames();
}

QVariant ProxyListModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid()) {
        return QVariant();
    }
    int itemIndex = index.row();
    int listIndex = getListIndex(itemIndex);
    if (listIndex == -1) {
        return QVariant();
    }
    QAbstractItemModel *list = m_entryList.at(listIndex);
    QModelIndex newIndex = list->index(itemIndex, 0);
    return list->data(newIndex, role);
}

int ProxyListModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) {
        return 0;
    }
    int sum = 0;
    for (auto size: m_entryList) {
        sum += size->rowCount();
    }
    return sum;
}

void ProxyListModel::addList(QAbstractItemModel *list) {
    m_entryList << list;
}

DelegateInfo *ProxyListModel::getInfo(int row) {
    int itemIndex = row;
    int listIndex = getListIndex(itemIndex);
    if (listIndex == -1) {
        return nullptr;
    }
    QAbstractItemModel *list = m_entryList.at(listIndex);
    return new DelegateInfo(itemIndex, list, this);
}

int ProxyListModel::getListIndex(int &i) const {
    const int entries = m_entryList.size();
    if (entries == 0) {
        return -1;
    }
    int j = 0;
    auto list = m_entryList.at(j);
    int size = list->rowCount();
    while (i >= size) {
        i = i - size;
        j++;
        if (j == entries) {
            return -1;
        }
        list = m_entryList.at(j);
        size = list->rowCount();
    }
    return j;
}
