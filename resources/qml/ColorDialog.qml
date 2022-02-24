import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1

import UM 1.5 as UM
import Cura 1.1 as Cura


/*
*   A dialog that provides the option to pick a color. Currently it only asks for a hex code and shows the color
*   in a color swath
*/
UM.Dialog
{
    id: base

    property variant catalog: UM.I18nCatalog { name: "cura" }

    margin: UM.Theme.getSize("wide_margin").width

    property alias color: colorInput.text
    property var swatchColors: [
        "#2161AF", "#57AFB2", "#F7B32D", "#E33D4A", "#C088AD",
        "#5D88BE", "#5ABD0E", "#E17239", "#F74E46", "#874AF9",
        "#50C2EC", "#8DC15A", "#C3977A", "#CD7776", "#9086BA",
        "#FFFFFF", "#D3D3D3", "#9E9E9E", "#5A5A5A", "#000000",
    ]

    Component.onCompleted: updateSwatches()
    onSwatchColorsChanged: updateSwatches()

    function updateSwatches()
    {
        swatchColorsModel.clear();
        for (const swatchColor of base.swatchColors)
        {
            swatchColorsModel.append({ swatchColor });
        }
    }

    Column
    {
        id: content
        width: childrenRect.width
        height: childrenRect.height
        spacing: UM.Theme.getSize("wide_margin").height

        GridLayout {
            columns: 5
            width: childrenRect.width
            height: childrenRect.height
            columnSpacing: UM.Theme.getSize("thick_margin").width
            rowSpacing: UM.Theme.getSize("thick_margin").height

            Repeater
            {
                model: ListModel
                {
                    id: swatchColorsModel
                }

                delegate: Rectangle
                {
                    color: swatchColor
                    width: 24
                    height: 24
                    radius: width / 2

                    UM.RecolorImage
                    {
                        anchors.fill: parent
                        visible: swatchColor == base.color
                        source: UM.Theme.getIcon("Check", "low")
                        color: UM.Theme.getColor("checkbox")
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            base.color = swatchColor;
                        }
                    }
                }
            }
        }

        RowLayout
        {
            width: parent.width
            spacing: UM.Theme.getSize("default_margin").width

            UM.Label
            {
                text: catalog.i18nc("@label", "Hex")
            }

            TextField
            {
                id: colorInput
                Layout.fillWidth: true
                text: "#FFFFFF"
                selectByMouse: true
                onTextChanged: {
                    if (!text.startsWith("#"))
                    {
                        text = `#${text}`;
                    }
                }
                validator: RegExpValidator { regExp: /^#([a-fA-F0-9]{0,6})$/ }
            }

            Rectangle
            {
                color: base.color
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: height
            }
        }
    }

    buttonSpacing: UM.Theme.getSize("default_margin").width

    rightButtons:
    [
        Cura.TertiaryButton {
            text: catalog.i18nc("@action:button", "Cancel")
            onClicked: base.close()
        },
        Cura.PrimaryButton {
            text: catalog.i18nc("@action:button", "OK")
            onClicked: base.accept()
        }
    ]
}