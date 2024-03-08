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
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.core as PlasmaCore
import org.kde.iconthemes as KIconThemes
import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg

KCM.SimpleKCM {
    property alias cfg_icon: iconButton.value
    property alias cfg_showLetterSeparator: showLettersCheck.checked
    property string cfg_iconSize
    anchors.fill: parent

    Kirigami.FormLayout {
        anchors.fill: parent

        QQC2.Button {
            id: iconButton
            Kirigami.FormData.label: i18n("Icon:")
            property string value: ''
            implicitWidth: previewFrame.width + Kirigami.Units.smallSpacing * 2
            implicitHeight: previewFrame.height + Kirigami.Units.smallSpacing * 2

            KIconThemes.IconDialog {
                id: iconDialog
                onIconNameChanged: iconButton.value = iconName || "start-here-kde"
            }

            onClicked: {
                iconDialog.open()
            }

            KSvg.FrameSvgItem {
                id: previewFrame
                anchors.centerIn: parent
                imagePath: plasmoid.location === PlasmaCore.Types.Vertical || plasmoid.location === PlasmaCore.Types.Horizontal ? "widgets/panel-background" : "widgets/background"
                width: Kirigami.Units.iconSizes.large + fixedMargins.left + fixedMargins.right
                height: Kirigami.Units.iconSizes.large + fixedMargins.top + fixedMargins.bottom

                Kirigami.Icon {
                    anchors.centerIn: parent
                    width: Kirigami.Units.iconSizes.large
                    height: width
                    source: iconButton.value
                }
            }
        }

        QQC2.ComboBox {
            id: iconSizeCombo
            Kirigami.FormData.label: i18n("Size of icons:")
            textRole: "text"
            valueRole: "value"
            model: [
                {
                    value: Kirigami.Units.iconSizes.smallMedium,
                    text: i18n("Small")
                },
                {
                    value: Kirigami.Units.iconSizes.medium,
                    text: i18n("Medium")
                },
                {
                    value: Kirigami.Units.iconSizes.large,
                    text: i18n("Large")
                },
                {
                    value: Kirigami.Units.iconSizes.huge,
                    text: i18n("Huge")
                },
            ]
            Component.onCompleted: currentIndex = indexOfValue(cfg_iconSize)
            onActivated: cfg_iconSize = currentValue
        }

        QQC2.CheckBox {
            id: showLettersCheck
            Kirigami.FormData.label: i18n("Show separators for All Apps Menu:")
            text: i18n("Enabled")
        }
    }
}