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

#include <QAbstractItemModel>

class DelegateInfo : public QObject {
Q_OBJECT

    Q_PROPERTY(int index READ index)
    Q_PROPERTY(QAbstractItemModel *model READ model)
public:
    explicit DelegateInfo(int index = -1, QAbstractItemModel *model = nullptr, QObject *parent = nullptr);

    ~DelegateInfo() override;

    int index() const;

    QAbstractItemModel *model() const;

private:
    int m_index;
    QAbstractItemModel *m_model;
};
