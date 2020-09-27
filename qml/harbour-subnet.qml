import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow
{
    id: app

    property var network: "0.0.0.0/0"
    property int subnetmask: 0
    property bool resultsReady: false

    initialPage: Component { NetworkPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
