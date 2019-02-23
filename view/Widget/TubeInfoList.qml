import QtQuick 2.0

Item {
    id:tubeinfolist
    height: mainCol.height
    width: 600

    property var datasInfo:[]
    property int tubeNum: 1
    Rectangle{
        anchors.fill: parent
        color: "#aaaaaa"
        id:bg
    }


    Column{
        id:mainCol
        width: parent.width
        spacing: 1
        //title
        Rectangle{
            id:title
            width: parent.width-1
            height: 25
            color: "#bde9ef"
            Text{
                anchors.centerIn: parent
                text: tubeNum + "号管"
                color: "#333333"
                font.pixelSize: 16
            }
        }

        //data list
        Item{
            id:datainfoListItem
            height: dataInfoListCol.height
            width: parent.width
            Column{
                id:dataInfoListCol
                width: parent.width
                spacing: 1

                //subtitle
                Item{
                    width: parent.width
                    height: 20
                    Row{
                        anchors.fill: parent
                        spacing: 1
                        Rectangle{
                            width: parent.width/3-1
                            height: parent.height
                            Text{
                                text: "入管时间"
                                font.pixelSize: 12
                                color: "#333333"
                                anchors.verticalCenter:  parent.verticalCenter
                                x:10
                            }

                            Text{
                                text: "入管温度"
                                font.pixelSize: 12
                                color: "#333333"
                                anchors.verticalCenter:  parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                            }
                        }
                        Rectangle{
                            width: parent.width/3-1
                            height: parent.height
                            Text{
                                text: "出管时间"
                                font.pixelSize: 12
                                color: "#333333"
                                anchors.verticalCenter:  parent.verticalCenter
                                x:10
                            }

                            Text{
                                text: "出管温度"
                                font.pixelSize: 12
                                color: "#333333"
                                anchors.verticalCenter:  parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                            }
                        }
                        Rectangle{
                            width: parent.width/3-1
                            height: parent.height
                            Text{
                                text: "COT管时间"
                                font.pixelSize: 12
                                color: "#333333"
                                anchors.verticalCenter:  parent.verticalCenter
                                x:10
                            }

                            Text{
                                text: "COT管温度"
                                font.pixelSize: 12
                                color: "#333333"
                                anchors.verticalCenter:  parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                            }
                        }
                    }
                }

                Repeater{
                    model: datasInfo//sky:datasInfo 是一个数组
                    delegate: Item{
                        width: mainCol.width
                        height: 20
                        Row{
                            spacing: 1
                            anchors.fill: parent
                            Rectangle{
                                width: parent.width/3-1
                                height: parent.height
                                Text{
                                    anchors.verticalCenter: parent.verticalCenter
                                    x:10
                                    text:modelData.tubeInTime//sky:入管时间
                                    font.pixelSize: 12
                                }
                                Text{
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 10
                                    text:modelData.tubeInTemp//sky:入管温度
                                    font.pixelSize: 12
                                }

                            }
                            Rectangle{
                                width: parent.width/3-1
                                height: parent.height
                                Text{
                                    anchors.verticalCenter: parent.verticalCenter
                                    x:10
                                    text:modelData.tubeOutTime//sky:出管时间
                                    font.pixelSize: 12
                                }
                                Text{
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 10
                                    text:modelData.tubeOutTemp//sky:出管温度
                                    font.pixelSize: 12
                                }
                            }
                            Rectangle{
                                width: parent.width/3-1
                                height: parent.height
                                Text{
                                    anchors.verticalCenter: parent.verticalCenter
                                    x:10
                                    text:modelData.tubeCOTTime//sky:cot管时间
                                    font.pixelSize: 12
                                }
                                Text{
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 10
                                    text:modelData.tubeCOTTemp////sky:cot管温度
                                    font.pixelSize: 12
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}
