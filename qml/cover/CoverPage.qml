import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../js/ipcalc.js" as IPcalc

CoverBackground {
    id: cover
    property int subnetNumber: -1
    property int numSubnets: Math.pow(2, app.subnetmask - IPcalc.getMaskLength(app.network))
    property var adoptedNetwork: IPcalc.networkMath(IPcalc.getNetwork(app.network) + "/" + app.subnetmask, subnetNumber)
    onSubnetNumberChanged: {
        if (subnetNumber < -1) {
            subnetNumber = -1
        }
        if (subnetNumber >= numSubnets) {
            subnetNumber = numSubnets-1
        }

        //pageStack.push(Qt.resolvedUrl("../pag<es/SubnetsPage.qml"), { }, PageStackAction.Immediate)
        //pageStack.pop(null, PageStackAction.Immediate)
        //pageStack.push(Qt.resolvedUrl("../pages/SubnetsPage.qml"), { offset: pageStack.currentPage.offset + (pageStack.currentPage.numSubnets > 256 ? 256 : pageStack.currentPage.numSubnets) }, PageStackAction.Immediate )
        //pageStack.pop(null, PageStackAction.Immediate)
    }
    Connections {
        target: app
        onNetworkChanged: subnetNumber = -1
        onSubnetmaskChanged: subnetNumber = -1
    }

    CoverPlaceholder {
        visible: !resultsReady
        text: qsTr("Subnet calculator")
    }
    Column {
        visible: resultsReady && subnetNumber < 0
        anchors.centerIn: parent
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryColor
            text: qsTr("Network")
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeLarge
            text: app.network
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryColor
            text: qsTr("Subnet mask")
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeLarge
            text: app.subnetmask
        }
        Label {
            visible: cover.size != Cover.Small
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeSmall
            text: qsTr("Networks: %1").arg(numSubnets)
        }
        Label {
            visible: cover.size != Cover.Small
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeSmall
            text: qsTr("Hosts: %1").arg(IPcalc.getNumHosts(adoptedNetwork))
        }
    }
    Column {
        visible: resultsReady && subnetNumber >= 0
        anchors.fill: parent
        Label {
            visible: cover.size != Cover.Small
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.highlightColor
            text: qsTr("Subnet %1 / %2").arg(subnetNumber + 1).arg(numSubnets)
        }
        Separator {
            visible: cover.size != Cover.Small
            width: parent.width
            horizontalAlignment: Qt.AlignHCenter
            color: Theme.primaryColor
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeExtraSmall
            text: qsTr("Network")
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: IPcalc.getNetwork(adoptedNetwork)
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeExtraSmall
            text: qsTr("Netmask")
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: IPcalc.getMask(adoptedNetwork) + " (" + IPcalc.getMaskLength(adoptedNetwork) + ")"
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeExtraSmall
            text: qsTr("First Host")
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: IPcalc.getMinHost(adoptedNetwork)
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeExtraSmall
            text: qsTr("Last Host")
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: IPcalc.getMaxHost(adoptedNetwork)
        }
    }

    CoverActionList {
        id: viewSubnetsAction
        enabled: resultsReady && subnetNumber < 0

        CoverAction {
            iconSource: "image://theme/icon-cover-subview"
            onTriggered: subnetNumber++
        }
    }
    CoverActionList {
        id: navigateSubnetsAction
        enabled: resultsReady && subnetNumber >= 0

        CoverAction {
            iconSource: "image://theme/icon-cover-previous"
            onTriggered: subnetNumber--
        }
        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: subnetNumber++
        }
    }
}
