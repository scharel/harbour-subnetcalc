import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: column

    width: parent.width
    clip: panel.expanded
    add: Transition {
        AddAnimation{}
    }
    onFocusChanged: networkByte1.focus = focus
    property int byte1: 0
    property int byte2: 0
    property int byte3: 0
    property int byte4: 0
    property int mask: 0
    property bool valid: byte1 >= 0 && byte1 <= 255 && byte2 >= 0 && byte2 <= 255 && byte3 >= 0 && byte3 <= 255 && byte4 >= 0 && byte4 <= 255 && mask >= 0 && mask <= 32
    property string ipaddress: byte1 + '.' + byte2 + '.' + byte3 + '.' + byte4 + '/' + mask
    property bool editable: true
    property var fieldSize: Theme.fontSizeMedium
    property var acceptFunction: null

    function clear() {
        byte1 = byte2 = byte3 = byte4 = 0
        mask = 0
        networkByte1.text = networkByte2.text = networkByte3.text = networkByte4.text = ""
        networkMask.text = ""
        networkByte1.focus = true
    }

    function calculateMask() {
        var tmpMask = 32
        if (byte4 === 0) {
            tmpMask -= 8
            if (byte3 === 0) {
                tmpMask -= 8
                if (byte2 === 0) {
                    tmpMask -= 8
                }
                else if (byte2 === 16 && byte1 === 172) {
                    tmpMask = 12
                }
            }
        }
        mask = tmpMask
    }

    //add: Transition {
    //    FadeAnimator {}
    //}

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: -Theme.paddingSmall
        TextField {
            id: networkByte1
            labelVisible: false
            readOnly: !editable
            font.pixelSize: fieldSize
            placeholderText: "0"
            inputMethodHints: Qt.ImhDigitsOnly
            EnterKey.enabled: acceptableInput
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: {
                networkByte2.text = "0"
                networkByte2.focus = true
            }
            validator: IntValidator { bottom: 0; top: 255 }
            onTextChanged: {
                if (text.indexOf(',') > 0) {
                    text = Number(text.split(',')[0])
                    networkByte2.focus = true
                }
                text = byte1 = Number(text)
                if (text == "NaN") text = ""
            }
        }
        Label { text: "."; anchors.verticalCenter: parent.verticalCenter }
        TextField {
            id: networkByte2
            labelVisible: false
            readOnly: !editable
            font.pixelSize: fieldSize
            placeholderText: "0"
            inputMethodHints: Qt.ImhDigitsOnly
            EnterKey.enabled: acceptableInput
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: {
                networkByte3.text = "0"
                networkByte3.focus = true
            }
            validator: IntValidator { bottom: 0; top: 255 }
            onTextChanged: {
                if (text.indexOf(',') > 0) {
                    text = Number(text.split(',')[0])
                    networkByte3.focus = true
                }
                text = byte2 = Number(text)
                if (text == "NaN") text = ""
            }
        }
        Label { text: "."; anchors.verticalCenter: parent.verticalCenter }
        TextField {
            id: networkByte3
            labelVisible: false
            readOnly: !editable
            font.pixelSize: fieldSize
            placeholderText: "0"
            inputMethodHints: Qt.ImhDigitsOnly
            EnterKey.enabled: acceptableInput
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: {
                networkByte4.text = "0"
                networkByte4.focus = true
            }
            validator: IntValidator { bottom: 0; top: 255 }
            onTextChanged: {
                if (text.indexOf(',') > 0) {
                    text = Number(text.split(',')[0])
                    networkByte4.focus = true
                }
                text = byte3 = Number(text)
                if (text == "NaN") text = ""
            }
        }
        Label { text: "."; anchors.verticalCenter: parent.verticalCenter }
        TextField {
            id: networkByte4
            labelVisible: false
            readOnly: !editable
            font.pixelSize: fieldSize
            placeholderText: "0"
            inputMethodHints: Qt.ImhDigitsOnly
            EnterKey.enabled: acceptableInput
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: {
                calculateMask()
                networkMask.focus = true
            }
            validator: IntValidator { bottom: 0; top: 255 }
            onTextChanged: {
                if (text.indexOf(',') > 0) {
                    text = Number(text.split(',')[0])
                    networkMask.focus = true
                }
                text = byte4 = Number(text)
                if (text == "NaN") text = ""
            }
        }
        Label { text: "/"; anchors.verticalCenter: parent.verticalCenter }
        TextField {
            id: networkMask
            labelVisible: false
            readOnly: !editable
            font.pixelSize: fieldSize
            placeholderText: "0"
            Connections {
                target: column
                onMaskChanged: networkMask.text = mask
            }
            inputMethodHints: Qt.ImhDigitsOnly
            EnterKey.enabled: acceptableInput
            EnterKey.iconSource: acceptFunction != null ? "image://theme/icon-m-enter-accept" : "image://theme/icon-m-enter-close"
            EnterKey.onClicked: focus = false
            validator: IntValidator { bottom: networkMaskSlider.minimumValue; top: networkMaskSlider.maximumValue }
            onTextChanged: text = mask = Number(text)
            onFocusChanged: {
                if (focus === true) {
                    panel.show()
                }
                else {
                    panel.hide()
                    if (acceptFunction != null) acceptFunction()
                }
            }
        }
    }

    DockedPanel {
        id: panel
        width: parent.width
        height: Theme.itemSizeExtraLarge + Theme.paddingLarge
        dock: Dock.Bottom

        Slider {
            id: networkMaskSlider
            width: parent.width
            minimumValue: 0
            maximumValue: 32
            stepSize: 1
            Connections {
                target: column
                onMaskChanged: networkMaskSlider.value = mask
            }
            onValueChanged: mask = value
            valueText: value + " bit"
            label: qsTr("Netmask length")
            onDownChanged: if (down === false) networkMask.focus = false
        }
    }
}
