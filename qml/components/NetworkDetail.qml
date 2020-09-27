import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/ipcalc.js" as IPcalc

Column {
    property var network

    DetailItem {
        id: addressDetail
        label: qsTr("Address")
        value: IPcalc.getNetwork(network)
    }
    DetailItem {
        id: netmaskDetail
        label: qsTr("Netmask")
        value: IPcalc.getMask(network) + " (" + IPcalc.getMaskLength(network) + ")"
    }
    DetailItem {
        id: broadcastDetail
        label: qsTr("Broadcast")
        value: IPcalc.getBroadcast(network)
    }
    DetailItem {
        id: minHostDetai
        visible: numHostsDetail.value > 1
        label: qsTr("First Host")
        value: IPcalc.getMinHost(network)
    }
    DetailItem {
        id: maxHostDetail
        visible: numHostsDetail.value > 1
        label: qsTr("Last Host")
        value: IPcalc.getMaxHost(network)
    }
    DetailItem {
        id: numHostsDetail
        label: qsTr("Number of Hosts")
        value: IPcalc.getNumHosts(network)
    }
}
