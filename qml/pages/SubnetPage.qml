import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../js/ipcalc.js" as IPcalc

Page {
    id: page
    allowedOrientations: Orientation.PortraitMask

    property int numSubnets: Math.pow(2, app.subnetmask - IPcalc.getMaskLength(app.network))

    SilicaFlickable {
        anchors.fill: parent

        Column {
            anchors.fill: parent
            spacing: Theme.paddingLarge

            PageHeader {
                title: app.network + " " + qsTr("to") + " " + IPcalc.getNetwork(app.network) + "/" + app.subnetmask
                //description: qsTr("Subnets %1 to %2 out of %3").arg(offset + 1).arg(offset + subnetList.model).arg(numSubnets)
            }

            NetworkDetail {
                width: parent.width
                network: IPcalc.networkMath(IPcalc.getNetwork(app.network) + "/" + app.subnetmask, networkNumberInput.number-1)
            }

            Row {
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                IconButton {
                    icon.source: "image://theme/icon-m-previous?" + (pressed ? Theme.highlightColor : Theme.primaryColor)
                    enabled: Number(networkNumberInput.number) > 1
                    onClicked: networkNumberInput.number--
                }
                TextField {
                    id: networkNumberInput
                    property int number: 1
                    width: page.width / 2
                    label: qsTr("Network number")
                    labelVisible: true
                    font.pixelSize: Theme.fontSizeLarge
                    horizontalAlignment: TextInput.AlignHCenter
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator{ bottom: 1; top: numSubnets; }
                    placeholderText: "1"
                    text: number
                    onTextChanged: {
                        if (Number(text) >= 1 && Number(text) <= numSubnets) {
                            number = Number(text)
                        }
                        else {
                            number = 1
                            text = ""
                        }
                    }
                }
                IconButton {
                    icon.source: "image://theme/icon-m-next?" + (pressed ? Theme.highlightColor : Theme.primaryColor)
                    enabled: Number(networkNumberInput.number) < numSubnets
                    onClicked: networkNumberInput.number++
                }
            }
        }
    }
}
