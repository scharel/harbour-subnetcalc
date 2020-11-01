import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property int firstNetwork: 1
    property int lastNetwork: 1
    property int numNetworks: 1

    Column {
        width: parent.width

        DialogHeader {
            title: qsTr("Select the range of networks to show")
        }

        Slider {
            id: firstNetworkSlider
            width: parent.width
            minimumValue: 1
            maximumValue: numNetworks
            stepSize: 1
            label: qsTr("First network to show")
            value: firstNetwork
            valueText: value
            onValueChanged: firstNetwork = value
        }

        Slider {
            id: lastNetworkSlider
            width: parent.width
            minimumValue: firstNetworkSlider.value
            maximumValue: numNetworks
            stepSize: 1
            label: qsTr("Last network to show")
            value: lastNetwork
            valueText: value
            onMinimumValueChanged: if (value < minimumValue) value = minimumValue
            onValueChanged: lastNetwork = value
        }
    }
}
