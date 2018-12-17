import QtQuick 2.0

Item {
    id:root
    property bool checked : false
    property string text;
    property string imgSource;
    signal bntClicked();

    Rectangle{
        anchors.fill: parent
        color: root.checked?"#41ccdc":"#00000000"
    }
    Column{
        anchors.centerIn: parent
        spacing: 5
        Image {
            id: img
            source: imgSource
        }
        Item{
            width: img.width
            height: 18
            Text{
                text:root.text
                font.pixelSize: 18
                anchors.centerIn: parent
                color: "#ffffff"
            }
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: bntClicked();
    }

}
