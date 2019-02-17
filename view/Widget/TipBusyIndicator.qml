import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle{
    //id:analyze_dialog
    implicitWidth: 200
    implicitHeight: 180
    z:2
    color: "#00000000"
    property string tip: ""

    Text{
        id:tip_title
        text: tip
        font.pixelSize: 20
        font.family: "宋体"
        x:(parent.width - tip_title.width)/2
    }

    BusyIndicator{
        width: 80
        height: 80
        id:busy
        running: true
        anchors.centerIn: parent
    }
}
