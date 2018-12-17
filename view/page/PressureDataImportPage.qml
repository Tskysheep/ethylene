import QtQuick 2.0
import "../Widget"
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
//压力数据录入页
Item {
    id:root
    anchors.fill: parent

    property int currentFornace : 0
    property int currentGroup: 0
    property var furnaces:[
        "H110","H111","H112","H113","H114","H115","H116","H117","H118","H119","H120"
    ]
    property date globalDate: new Date();

    ListModel{
        id:pressureDatModel
        Component.onCompleted: {
            for(var a = 0; a<48; a++){
                append({
                           "value":"0"
                       });
            }
        }
    }

    Column{
        id:mainCol
        anchors.fill: parent

        //top bar
        Rectangle{
            id:topBar
            width: parent.width
            height: 50
            color: "#eef4f7"
            //fornaces
            Row{
                anchors.centerIn: parent
                Repeater{
                    model: furnaces
                    delegate:Item{
                        width: 80
                        height: topBar.height
                        Rectangle{
                            anchors.fill: parent
                            color: "#11000000"
                            radius: 2
                            opacity: ma.containsMouse?1:0
                            Behavior on opacity {
                                PropertyAnimation{
                                    properties: "opacity"
                                    duration: 150
                                }
                            }
                        }

                        Text{
                            text: modelData
                            font.weight: index === currentFornace?60:55
                            font.bold: index === currentFornace
                            font.pixelSize: 15
                            anchors.centerIn: parent
                            font.family: "软雅黑体"
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: currentFornace = index
                            hoverEnabled: true
                            id:ma
                        }
                        Rectangle{
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 5
                            color: "#00c5dc"
                            visible: currentFornace === index
                        }
                    }
                }
            }

            //line
            Rectangle{
                anchors.bottom: parent.bottom
                width: parent.width
                height: 2
                color: Qt.darker("#eef4f7",1.1)
            }

            RoundIconButton{
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                text: "保存数据"
                imgSrc: "qrc:/imgs/icons/add.png"
                anchors.rightMargin: 20
                bgColor: "#12ccef"
                onBngClicked: {
                    //录入输入的压力数据
                    var data = [];
//                    var kk=0;
                    var limit=pressureDatModel.count;
                    console.log("size:",limit);
                    for(var a=0;a<limit;a++){
                        console.log("压力",a,"值:",pressureDatModel.get(a).value);
                        data.push(pressureDatModel.get(a).value);
                    }
                    server.pushPressureData(currentFornace,data,globalDate);
                }
            }
        }

        //grid header
        Item{
            id: header
            width: parent.width-20
            anchors.horizontalCenter: parent.horizontalCenter
            height: 50

            Row{
                anchors.fill: parent

                Rectangle{
                    width: parent.width/3
                    height: parent.height
                    color: "#344750"

                    RoundIconButton{
                        bgColor: "#00000000"
                        anchors.fill: parent
                        textSize: 20
                        imgSrc: "qrc:/imgs/icons/iton_tube.png"
                        text: "管号"
                        enabled: false
                    }
                }

                Rectangle{
                    width: parent.width/3
                    height: parent.height
                    color: "#344750"
                    Rectangle{
                        width: 1
                        height: parent.height
                        color: "#eaeaea"
                    }

                    Row{
                        anchors.centerIn: parent
                        spacing: 30

                        Text{
                            text: "日期"
                            font.pixelSize: 20
                            anchors.verticalCenter: parent.verticalCenter
                            color: "white"
                        }

                        Text{
                            text: globalDate.toLocaleDateString(Qt.local,"yyyy/MM/dd")
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 20
                            color: "white"
                            Rectangle{
                                width: parent.width+30
                                height: parent.height+5
                                anchors.centerIn: parent
                                radius: height/2
                                color: "#00000000"
                                border.width: 1
                                border.color: "white"
                            }
                        }


                        Image {
                            source: "qrc:/imgs/icons/button_calendar_press.png"
                            anchors.verticalCenter: parent.verticalCenter
                            scale: bntCalendar.containsMouse?1.05:1
                            Behavior on scale{
                                PropertyAnimation{
                                    property:"scale"
                                    duration: 200
                                    easing.type: Easing.OutBack
                                }
                            }

                            MouseArea{
                                anchors.fill: parent
                                id: bntCalendar
                                hoverEnabled: true
                                onClicked: {
                                    //TODO
                                    calendarDialog.open();
                                }
                            }
                        }
                    }
                }

                Rectangle{
                    width: parent.width/3
                    height: parent.height
                    color: "#344750"

                    Rectangle{
                        width: 1
                        height: parent.height
                        color: "#eaeaea"
                    }

                    Row{
                        anchors.centerIn: parent
                        spacing: parent.width -setter.width - 24 - 50
                        RoundIconButton{
                            id:setter
                            bgColor: "#00000000"
                            anchors.verticalCenter: parent.verticalCenter
                            textSize: 20
                            imgSrc: "qrc:/imgs/icons/icon_pressure.png"
                            text: "压强(pa)"
                            enabled: false
                            width: 200
                            height: 50
                        }

//                        CheckBox{
//                            anchors.verticalCenter: parent.verticalCenter
//                            style: CheckBoxStyle {
//                                indicator: Rectangle {
//                                        implicitWidth: 24
//                                        implicitHeight: 24
//                                        radius: 2
//                                        border.color: control.activeFocus ? "#12aadf" : "#aaaaaa"
//                                        border.width: 1

//                                        Image {
//                                            source: "qrc:/imgs/icons/icon_choose.png"
//                                            anchors.centerIn: parent
//                                            opacity: control.checked?1:0.2
//                                        }
//                                }
//                            }
//                        }
                    }
                }
            }
        }

        //grid content
        Flickable{
            id:gridFlic
            width: parent.width-20
            height: parent.height - topBar.height - header.height
            clip: true
            flickableDirection: Qt.Vertical
            contentHeight: gridContent.height
            contentWidth: gridContent.width
            anchors.horizontalCenter: parent.horizontalCenter
            boundsBehavior: Flickable.DragOverBounds

            Item{
                id: gridContent
                width: root.width - 20
                height: gridCol.height

                Column{
                    width: parent.width
                    id:gridCol

                    Repeater{
                        model: pressureDatModel
                        delegate: Rectangle{
                            width: gridContent.width
                            height: 40
                            color: index%2 == 0?"white":"#eef4f7"

                            Row{
                                anchors.fill: parent

                                Item{
                                    width: parent.width/3
                                    height: parent.height

                                    Text{
                                        anchors.centerIn: parent
                                        text: Number(index+1).toString() + "号管"
                                        font.pixelSize: 14
                                        color: "#454545"
                                    }

                                }

                                Item{
                                    width: parent.width/3
                                    height: parent.height

                                    Row{
                                        anchors.centerIn: parent
                                        spacing: 15

                                        Text{
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: globalDate.toLocaleDateString(Qt.local,"yyyy/MM/dd")
                                            font.pixelSize: 14
                                            color: "#454545"
                                        }

//                                        Image {
//                                            anchors.verticalCenter: parent.verticalCenter
//                                            source: bntSubCanlendar.containsMouse && bntSubCanlendar.pressed?"qrc:/imgs/icons/button_time-_press-.png":
//                                                                                                              bntSubCanlendar.containsMouse?"qrc:/imgs/icons/button_time_hover.png":
//                                                                                                                                             "qrc:/imgs/icons/buttontime_normai.png"
//                                            MouseArea{
//                                                anchors.fill: parent
//                                                hoverEnabled: true
//                                                id: bntSubCanlendar
//                                            }
//                                        }
                                    }

                                }

                                Item{
                                    width: parent.width/3
                                    height: parent.height

                                    Row{
                                        anchors.centerIn: parent
                                        spacing: parent.width - 200 - 20 - 40

                                        TextField{
                                            width: 200
                                            height: 30
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: value
                                            validator: IntValidator {bottom: 0; top: 1000000;}

                                            placeholderText: "输入压强值"
                                            horizontalAlignment: TextInput.AlignHCenter

                                            onTextChanged:{
                                                pressureDatModel.setProperty(index,"value",text);
                                            }

                                            style: TextFieldStyle{
                                                textColor: "#454545"
                                                placeholderTextColor: "#999999"
                                                background: Rectangle {
                                                    width: control.width
                                                    height: control.height
                                                    radius: height/2
                                                    border.color: control.activeFocus?"#12aaef":"#666666"
                                                    border.width: 1
                                                    color: "#00000000"
                                                }
                                            }
                                        }

//                                        CheckBox{
//                                            anchors.verticalCenter: parent.verticalCenter
//                                            style: CheckBoxStyle {
//                                                indicator: Rectangle {
//                                                        implicitWidth: 24
//                                                        implicitHeight: 24
//                                                        radius: 2
//                                                        border.color: control.activeFocus ? "#12aadf" : "#aaaaaa"
//                                                        border.width: 1

//                                                        Image {
//                                                            source: "qrc:/imgs/icons/icon_choose.png"
//                                                            anchors.centerIn: parent
//                                                            opacity: control.checked?1:0.2
//                                                        }
//                                                }
//                                            }
//                                        }
                                    }

                                }
                            }
                        }
                    }
                }
            }
        }
    }

//    Rectangle{
//        width: 10
//        height: 200
//        y:gridFlic.y
//        anchors.right: parent.right
//        color: "#344750"

//    }

    CustomDialog{
        id:calendarDialog
        title: "选择日期"
        content:Calendar{
            id:calendar
            anchors.fill: parent
        }
        onAccepted: {
            globalDate = calendar.selectedDate;
        }
    }

}
