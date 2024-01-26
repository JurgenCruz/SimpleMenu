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
#include <QUrl>
#include "categorylistmodel.h"
#include "proxylistmodel.h"

CategoryListModel::CategoryListModel(const QString &name, QObject *parent) : QAbstractListModel(parent), m_name(name) {}

CategoryListModel::~CategoryListModel() = default;

QVariant CategoryListModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid()) {
        return QVariant();
    }
    int itemIndex = index.row();
    if (itemIndex > 0) {
        return QVariant();
    }
    if (role == Qt::DisplayRole || role == DescriptionRole) {
        return m_name;
    } else if (role == Qt::DecorationRole || role == GroupRole) {
        return QString();
    } else if (role == IsSeparatorRole) {
        return true;
    } else if (role == IsParentRole || role == HasChildrenRole || role == HasActionListRole) {
        return false;
    } else if (role == ActionListRole) {
        return QVariantList();
    } else if (role == UrlRole) {
        return QUrl();
    }
    return QVariant();
}

int CategoryListModel::rowCount(const QModelIndex &parent) const {
    return 1;
}