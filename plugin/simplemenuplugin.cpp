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

#include <QQmlEngine>
#include "simplemenuplugin.h"
#include "flattener.h"
#include "proxylistmodel.h"
#include "delegateinfo.h"
#include "categorylistmodel.h"

void SimpleMenuPlugin::registerTypes(const char *uri) {
    Q_ASSERT(uri == QLatin1String("com.github.jurgencruz.simplemenu"));
    qmlRegisterType<Flattener>(uri, 1, 0, "Flattener");
    qmlRegisterType<ProxyListModel>(uri, 1, 0, "ProxyListModel");
    qmlRegisterType<DelegateInfo>(uri, 1, 0, "DelegateInfo");
    qmlRegisterType<CategoryListModel>(uri, 1, 0, "CategoryListModel");
}
