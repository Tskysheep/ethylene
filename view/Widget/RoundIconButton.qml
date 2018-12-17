import QtQuick 2.0

Item {
    id:root
    property string bgColor: "#344750"
    signal bngClicked();
    property string text;
    property string imgSrc;
    property int textSize: 16
    width: 120
    height: 30
    smooth: true
    scale: ma.containsMouse?1.1:1
    Behavior on scale{
        PropertyAnimation{
            properties: "scale"
            duration: 200
            easing.type: Easing.OutBack
        }
    }

    Rectangle{
        anchors.fill: parent
        radius: height/2
        color: bgColor
        clip: true
        Row{
            anchors.centerIn: parent
            id:contentRow
            spacing: 3
            Text{
                text: root.text
                color: "#ffffff"
                font.pixelSize: textSize
                anchors.verticalCenter: parent.verticalCenter

            }
            Image {
                id:img
                source: imgSrc
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    MouseArea{
        id:ma
        anchors.fill: parent
        onClicked: bngClicked()
        hoverEnabled: true
    }

}
