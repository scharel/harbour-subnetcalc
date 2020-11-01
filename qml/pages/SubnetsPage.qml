import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../js/ipcalc.js" as IPcalc

Page {
    id: page
    allowedOrientations: Orientation.PortraitMask

    property int offset: 0
    property int maxSubnets: 32
    property int numSubnets: Math.pow(2, app.subnetmask - IPcalc.getMaskLength(app.network))
    onStatusChanged: {
        if (status === PageStatus.Active) {
            if (numSubnets - offset > maxSubnets) {
                pageStack.pushAttached(Qt.resolvedUrl("SubnetsPage.qml"), { offset: offset + subnetList.model })
            }
        }
    }
    /*forwardNavigation: numSubnets - offset > maxSubnets
    onStateChanged: {
        if (status === PageStatus.Deactivating) console.log("Deactivating")
    }*/

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Back to the calculator")
                onClicked: pageStack.pop(pageStack.find(function(page) { return page.startPage === true } ))
            }
            /*MenuItem {
                text: qsTr("Select network range")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("NetworkRangeDialog.qml"), { firstNetwork: offset + 1, lastNetwork: maxSubnets, numNetworks: numSubnets })
                    dialog.accepted.connect(function() {

                    })
                }
            }*/
        }

        Column {
            anchors.fill: parent

            PageHeader {
                id: pageHeader
                title: app.network + " " + qsTr("to") + " " + IPcalc.getNetwork(app.network) + "/" + app.subnetmask
                description: qsTr("Subnets %1 to %2 out of %3").arg(offset + 1).arg(offset + subnetList.model).arg(numSubnets)
            }

            SilicaListView {
                id: subnetList
                width: parent.width
                height: page.height - pageHeader.height - subnetSlider.height
                spacing: Theme.paddingLarge
                clip: true
                highlightFollowsCurrentItem: true

                currentIndex: 0
                model: numSubnets > maxSubnets ? maxSubnets : numSubnets
                delegate: BackgroundItem {
                    id: delegate
                    property var adoptedNetwork: IPcalc.networkMath(IPcalc.getNetwork(app.network) + "/" + app.subnetmask, index + offset)
                    width: parent.width
                    height: networkDetail.height + menu.height
                    highlighted: index == subnetList.currentIndex
                    NetworkDetail {
                        id: networkDetail
                        width: parent.width
                        network: adoptedNetwork
                    }

                    onDownChanged: if (down) subnetSlider.value = index + offset + 1
                    onPressAndHold: menu.open(delegate)

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

                VerticalScrollDecorator { flickable: subnetList }
            }

            Slider {
                id: subnetSlider
                width: parent.width
                minimumValue: offset + 1
                maximumValue: offset + subnetList.model
                stepSize: 1
                label: qsTr("Network number")
                value: minimumValue
                valueText: value
                onValueChanged: subnetList.currentIndex = value - offset - 1
            }
        }
    }
}
