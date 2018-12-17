import QtQuick 2.5

Item {
    id:root
    signal bntClicked()
    property string bntText;
    property bool selected:false
    clip:true
    width: 120
    height: 40

    Rectangle{
        id:cap
        anchors.fill: parent
        color:"#303030"
        visible: selected
        opacity: selected?1:0
        Behavior on opacity{
            PropertyAnimation{
                properties: "opacity"
                duration: 200
            }
        }
    }
    Rectangle{
        id:cap1
        width: 3
        height: parent.height-4
        anchors.verticalCenter: parent.verticalCenter
        color:"#12aadf"
        visible: selected
        anchors.right: parent.right
        opacity: selected?1:0
        Behavior on opacity{
            PropertyAnimation{
                properties: "opacity"
                duration: 200
            }
        }
    }
    Rectangle{
        anchors.centerIn: parent
        width:parent.width-10
        height: parent.height-10
        color:"#606060"
        radius: 3
        opacity: !selected?1:0
        Behavior on opacity{
            PropertyAnimation{
                properties: "opacity"
                duration: 200
            }
        }
    }

    Text{
        color:"#ffffff"
        anchors.centerIn: parent
        text:bntText
        font.pointSize: 18
    }
    MouseArea{
        anchors.fill: parent
        onClicked: bntClicked();
    }

}
