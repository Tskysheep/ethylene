import QtQuick 2.0

Rectangle{
    width: 20
    height: 40
    radius: 3
    border.width: 1
    border.color: "#666666"
    property bool upEnable: true
    property bool downEnable: true
    signal aboutToUp();
    signal aboutToDown();
    Rectangle{
        width: parent.width
        height: 1
        anchors.centerIn: parent
        color: "#666666"
        Image {
            source: "qrc:/imgs/icons/etc_up.png.png"
            anchors.horizontalCenter: parent.horizontalCenter
            y:5
            opacity: downEnable?1:0.5
        }
        Image {
            source: "qrc:/imgs/icons/etc_down.png.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            opacity: upEnable?1:0.5
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            if(mouseY>height/2&&downEnable)
                aboutToDown();
            else if(mouseY<height/2&&upEnable)
                aboutToUp();
        }
    }
}
