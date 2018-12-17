import QtQuick 2.0

Item {
    id:root
    property int value;
    width: 10
    height: 10
    Rectangle{
        anchors.fill: parent
        radius: width/2
        border.width: 2
        border.color: "#444444"
    }

    MouseArea{
        id:ma
        hoverEnabled: true
    }

    Rectangle{
        anchors.bottom: parent.top
        anchors.bottomMargin: 5
        width: 100
        height: 20
        anchors.horizontalCenter: parent.horizontalCenter
        border.width: 1
        border.color: "#444444"
        opacity: ma.containsMouse?1:0
        Behavior on opacity{
            PropertyAnimation{
                properties: "opacity"
                duration: 100
            }
        }

        Text{
            anchors.centerIn: parent
            text: root.value
            color: "#555555"
        }
    }

}
