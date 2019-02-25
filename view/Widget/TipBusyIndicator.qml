import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: root
    width: 200
    height: 180
    anchors.centerIn: parent
    visible: false
    z:2

    function show(title){
        tip_title.text = title
        visible = true
    }

    function hide(title){
        tip_title.text = title
        visible = false
    }

    Rectangle{
        id:rec
        anchors.fill: parent

        //z:2
        //visible: false
        color: "#00000000"

        Text{
            id:tip_title
            text: "正在分析中，请稍等...."
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
}
