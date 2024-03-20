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

#include "flattener.h"
#include "categorylistmodel.h"

Flattener::Flattener(QObject *parent) : QObject(parent) {}

Flattener::~Flattener() = default;

ProxyListModel *Flattener::flatten(const QList<QAbstractItemModel *> &models, const QList<QString> &categories) {
    auto includeCategories = categories.count() != 0 && models.count() == categories.count();
    auto *proxy = new ProxyListModel(this);
    for (int i = 0; i < models.count(); ++i) {
        auto m = models.at(i);
        if (m->rowCount() != 0) {
            if (includeCategories) {
                proxy->addList(createCategoryList(categories.at(i)));
            }
            proxy->addList(m);
        }
    }
    return proxy;
}

QAbstractItemModel *Flattener::createCategoryList(const QString &name) {
    return new CategoryListModel(name, this);
}
