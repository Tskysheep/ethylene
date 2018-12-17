import QtQuick 2.0

Item {
    anchors.fill: parent
    z:2
    default property alias content: detialContent.children
    property string title;
    property string titleBarColor: "#344750"
    property string titleTextColor: "white"
    visible: false
    enabled: false
    id:root
    MouseArea{
        anchors.fill: parent
    }

    signal accepted();
    signal rejected();
    function open(){
        visible = true;
        enabled = true;
    }

    function close(){
        visible = false;
        enabled = false;
    }

    Rectangle{
        id:cap
        anchors.fill: parent
        color: "#33000000"

    }

    //content
    Rectangle{
        id:_content
        width: detialContent.width
        height: contentCol.height
//        anchors.centerIn: parent
        x:parent.width/2-width/2
        y:parent.height/2-height/2

        Column{
            id:contentCol

            //title bar
            Rectangle{
                width: parent.width
                height: 60
                id:titlebar
                color: titleBarColor
                Text{
                    anchors.centerIn: parent
                    text: title
                    color: titleTextColor
                    font.pixelSize: 20
                }
                MouseArea{
                    anchors.fill: parent
                    drag.target: _content
                    drag.axis: Drag.XAndYAxis
                    drag.maximumX: root.width-_content.width
                    drag.minimumX: 0
                    drag.minimumY: 0
                    drag.maximumY: root.height-_content.height
                }
            }

            //detial content
            Item{
                id:detialContent
                width: 500
                height: 500
            }

            //bottom
            Item{
                width: parent.width
                height: 80
                Row{
                    anchors.centerIn: parent
                    spacing: 50
                    Rectangle{
                        width: 150
                        height: 40
                        radius: height/2
                        color: "#12eaff"
                        Text{
                            anchors.centerIn: parent
                            text: "确定"
                            font.pixelSize: 22
                            color: "white"
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                accepted();
                                close();
                            }
                        }
                    }

                    Rectangle{
                        width: 150
                        height: 40
                        radius: height/2
                        color: "#344775"
                        Text{
                            anchors.centerIn: parent
                            text: "取消"
                            font.pixelSize: 22
                            color: "white"
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                rejected();
                                close();
                            }
                        }
                    }
                }
            }
        }
    }

}
