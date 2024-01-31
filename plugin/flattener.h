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

#pragma once

#include <QAbstractListModel>
#include <QmlTypeAndRevisionsRegistration>
#include "proxylistmodel.h"

class Flattener : public QObject {
Q_OBJECT
    QML_ELEMENT
public:
    explicit Flattener(QObject *parent = nullptr);

    ~Flattener() override;

    Q_INVOKABLE ProxyListModel *flatten(const QList<QAbstractListModel *> &models, const QList<QString> &categories);

private:
    QAbstractListModel *createCategoryList(const QString &name);
};