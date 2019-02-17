import QtQuick 2.0
import QtGraphicalEffects 1.0

//版本信息页(相当于一般软件的关于)
Rectangle {
    id:root
    anchors.fill: parent

    Image {
        id: bgimage
        z:1
        anchors.fill: parent
        source: "qrc:/imgs/icons/login_bg.jpg"
    }

    Rectangle{
        id:midpanel
        z:2
        anchors.fill: parent
        color: "white"
        opacity: 0.5

    }

    Rectangle{
        anchors.centerIn: parent
        width: 600
        height: 396//mainCol.height +60
        border.width: 1
        border.color: "#dddddd"
        radius: 5
        z:3

        Glow{
            anchors.fill: mainCol
            color: "#ffffff"
            spread: 0.5
            radius: 8
            source: mainCol
            transparentBorder: true
            fast: true
            cached: true
            samples: 15

        }

        Column{
            id:mainCol
            anchors.centerIn: parent
            spacing: 20

            Text{
                text:"软件名称: 乙烯裂解炉管外表面温度监测与智能分析系统"
                font.pixelSize: 20
                font.family: "微软雅黑"
                color: "#000000"
            }

            Text{
                text:"版  本  号: V1.0.1"
                font.pixelSize: 20
                font.family: "微软雅黑"
                color: "#000000"
            }

            Text{
                text:"公司名称：北京泓泰天诚科技有限公司"
                font.pixelSize: 20
                font.family: "微软雅黑"
                color: "#000000"
            }

            Text{
                text:"联系方式：(0086)- (010)-64737112"
                font.pixelSize: 20
                font.family: "微软雅黑"
                color: "#000000"
            }

            Text{
                text:"反馈信息：Httchr@hontye.com"
                font.pixelSize: 20
                font.family: "微软雅黑"
                color: "#000000"
            }

            Text{
                text:"公司网址：http://www.hontye.com"
                font.pixelSize: 20
                font.family: "微软雅黑"
                color: "#000000"
            }


        }
    }

}
