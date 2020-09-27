import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../js/ipcalc.js" as IPcalc

Page {
    id: page
    allowedOrientations: Orientation.PortraitMask

    property int offset: 0
    property int numSubnets: Math.pow(2, app.subnetmask - IPcalc.getMaskLength(app.network))
    onStatusChanged: {
        if (status === PageStatus.Active) {
            if (numSubnets - offset > 256) {
                pageStack.pushAttached(Qt.resolvedUrl("SubnetsPage.qml"), { offset: offset + subnetList.model })
            }
        }
    }

    SilicaListView {
        id: subnetList
        anchors.fill: parent
        spacing: Theme.paddingLarge

        PullDownMenu {
            MenuItem {
                text: qsTr("Back to the calculator")
                onClicked: pageStack.pop(null)
            }
        }

        header: PageHeader {
            title: app.network + " " + qsTr("to") + " " + IPcalc.getNetwork(app.network) + "/" + app.subnetmask
            description: qsTr("Subnets %1 to %2 out of %3").arg(offset).arg(offset + subnetList.model).arg(numSubnets)
        }

        currentIndex: -1
        model: numSubnets > 256 ? 256 : numSubnets
        delegate: BackgroundItem {
            id: delegate
            property var adoptedNetwork: IPcalc.networkMath(IPcalc.getNetwork(app.network) + "/" + app.subnetmask, index + offset)
            width: parent.width
            height: networkDetail.height + menu.height
            NetworkDetail {
                id: networkDetail
                width: parent.width
                network: adoptedNetwork
            }
            onClicked: menu.open(delegate)
            ContextMenu {
                id: menu
                MenuLabel {
                    text: qsTr("Network number") + " " + (index + offset + 1)
                }
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
        section.property: "adoptedNetwork"
        section.criteria: ViewSection.FullString
        section.labelPositioning: ViewSection.InlineLabels |
                                  ViewSection.CurrentLabelAtStart |
                                  ViewSection.NextLabelAtEnd
        section.delegate: SectionHeader {
            text: section
        }
        VerticalScrollDecorator { flickable: subnetList }
    }
}
