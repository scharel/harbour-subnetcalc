import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.PortraitMask

    SilicaFlickable {
        anchors.fill: parent

        Column {
            width: parent.width
            PageHeader {
                title: qsTr("About")
            }

            Column {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                LinkedLabel {
                    text: qsTr("Autor: Scharel Clemens<br />
<a href=\"mailto:harbour@scharel.rocks\">harbour@scharel.rocks</a>")
                }
            }
        }

        VerticalScrollDecorator {}
    }
}
