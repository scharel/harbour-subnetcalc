import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../js/ipcalc.js" as IPcalc

Page {
    id: page
    allowedOrientations: Orientation.PortraitMask
    property bool startPage: true

    Component.onCompleted: {
        ipField.focus = true
    }
    Connections {
        target: ipField
        onIpaddressChanged: app.network = ipField.ipaddress
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Reset")
                onClicked: {
                    ipField.clear()
                    subnetSlider.value = 0
                    resultsReady = false
               }
            }
        }

        contentHeight: contentColumn.height + Theme.paddingLarge

        Column {
            id: contentColumn

            width: page.width

            add: Transition {
                AddAnimation{}
            }
            PageHeader {
                title: qsTr("Subnet calculator")
            }

            SectionHeader {
                text: qsTr("Network")
            }
            IPTextField {
                id: ipField
                anchors.horizontalCenter: parent.horizontalCenter
                fontSize: Theme.fontSizeLarge
                acceptFunction: function() {
                    resultsReady = true
                }
            }
            Column {
                width: parent.width

                SectionHeader {
                    text: qsTr("Network Indormation")
                }
                BackgroundItem {
                    id: detailBackground
                    width: parent.width
                    height: networkDetail.height + menu.height
                    NetworkDetail {
                        id: networkDetail
                        width: parent.width
                        network: IPcalc.getNetwork(ipField.ipaddress) + "/" + ipField.mask
                    }
                    onPressAndHold: menu.open(detailBackground)
                    ContextMenu {
                        id: menu
                        MenuItem {
                            text: qsTr("Copy to clipboard")
                            onClicked: {
                                var text = ""
                                for (var i = 0; i < networkDetail.children.length; i++) {
                                    text += networkDetail.children[i].label + ": " + networkDetail.children[i].value + "\n"
                                }
                                Clipboard.text = text
                            }
                        }
                    }
                }

                Column {
                    visible: resultsReady
                    width: parent.width
                    spacing: Theme.paddingLarge

                    SectionHeader {
                        text: qsTr("Subnets")
                    }
                    Slider {
                        id: subnetSlider
                        width: parent.width
                        minimumValue: ipField.mask
                        maximumValue: 32
                        stepSize: 1
                        value: ipField.mask
                        valueText: value + " bit"
                        label: qsTr("Subnet Mask length")
                        onValueChanged: app.subnetmask = value
                    }
                    DetailItem {
                        id: numSubnetsDetail
                        label: qsTr("Number of subnetworks")
                        value: Math.pow(2, app.subnetmask - IPcalc.getMaskLength(app.network))
                    }
                    DetailItem {
                        id: numHostsDetail
                        label: qsTr("Number of hosts per network")
                        value: IPcalc.getNumHosts(IPcalc.getNetwork(app.network) + "/" + app.subnetmask)
                    }

                    Button {
                        enabled: numSubnetsDetail.value > 1
                        text: qsTr("View Subnets")
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: pageStack.push(Qt.resolvedUrl("SubnetPage.qml"))
                    }
                }
            }
            ViewPlaceholder {
                enabled: false // Does not work as expected // !resultsReady
                verticalOffset: Theme.iconSizeExtraLarge
                text: qsTr("No Network")
                hintText: qsTr("Enter a valid Network Address")
            }
        }
    }
}
