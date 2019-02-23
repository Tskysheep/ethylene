import QtQuick 2.0

Item {
    id:root
    property bool checked : false
    property string text;
    property string imgSource;
    property var subModel;
    property bool submenuVisible: false
    signal bntClicked();
    signal btnHoveredChanged();//sky 子菜单展示与隐藏
    signal subbtnClicked(int subbtn_index);//sky 子按钮点击触发


    Rectangle{
        anchors.fill: parent
        color: root.checked?"#41ccdc":"#00000000"
    }
    Column{
        id:col
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
                //color:"#000000"
            }
        }
    }
    MouseArea{
        id:ma
        anchors.fill: parent
        hoverEnabled: true

        onClicked:{
             bntClicked();
        }

        onEntered: {
            btnHoveredChanged()

        }

    }
//sky子菜单
    Item{
        width: parent.width
        height: 80
        x:parent.width
        //anchors.left: col.right
        id:submenu
        visible: submenuVisible
        Column{
            anchors.fill: parent
            spacing: 5
            Repeater{
                model: subModel
                delegate: Rectangle{
                    width: parent.width
                    height: 35
                    color:selected ? "#FF4E3E" : "#344750"//(subma.containsMouse ? "#41ccdc" : "#344750")
                    //color:selected ? "#FF4E3E" : "#d3d3d4"
//                    scale: subma.containsMouse ? 1.1 : 1
                    x: subma.containsMouse ? 10 : 0

                    Behavior on x{
                        NumberAnimation{
                            easing.type: Easing.OutQuad
                        }
                    }

                    Row{
                        anchors.centerIn: parent
                        spacing: 2
                        Text {
                            id:subtext
                           text: subtitle
                           font.pixelSize: 18
                           //font.family: "微软雅黑"
                           color: "#FFFFFF"
                           //color:"#000000"
                        }
                        Image {
                            id: subimg
                            height: subtext.height
                            width: 20
                            source: subimgSrc
                        }
                   }
                    MouseArea{
                        id:subma
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: subbtnClicked(index)
                    }
                }
            }

        }

    }



}
