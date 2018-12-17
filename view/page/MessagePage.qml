import QtQuick 2.0

//版本信息页(相当于一般软件的关于)
Rectangle {
    id:root
    anchors.fill: parent

    Rectangle{
        anchors.centerIn: parent
        width: 600
        height: mainCol.height +60
        border.width: 1
        border.color: "#dddddd"

        Column{
            id:mainCol
            anchors.centerIn: parent
            spacing: 20

            Text{
                text:"软件名称: 乙烯裂解炉管外表面温度监测与智能分析系统"
                font.pixelSize: 20
                color: "#454545"
            }

            Text{
                text:"版本号: V1.0.1"
                font.pixelSize: 20
                color: "#454545"
            }

            Text{
                text:"QQ: 790277935"
                font.pixelSize: 20
                color: "#454545"
            }

            Text{
                text:"邮箱: xiaoluzhe@gmail.com"
                font.pixelSize: 20
                color: "#454545"
            }

            Text{
                text:"电话: 13620453854"
                font.pixelSize: 20
                color: "#454545"
            }
        }
    }

}
