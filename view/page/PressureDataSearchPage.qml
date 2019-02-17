import QtQuick 2.7
import "../Widget"
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id:root
    anchors.fill: parent

    property date globalDate1: new Date()
    property date globalDate2: new Date()
    property int current_fn: foranceNumComboBox.currentIndex //当前炉号

    onCurrent_fnChanged: refreshData()

    function refreshData(){
        //清除上一次数据
        pressdataModel.clear()

        //获取时间
        var from_time = time_show_text.text.split("/").join("-")
        var to_time = time_show_text1.text.split("/").join("-")

        var datas = server.access_pressdata(String(foranceNumComboBox.currentIndex),from_time,to_time)
        for(var a = 0; a < datas.length; a++){
            pressdataModel.append({
                                      "time" :datas[a].time,
                                      "value1":datas[a].value1,
                                      "value2":datas[a].value2,
                                      "value3":datas[a].value3,
                                      "value4":datas[a].value4
                                  })
        }
    }

    //压力数据模型
    ListModel{
        id:pressdataModel
        Component.onCompleted: {
            refreshData();
        }
    }

    Column{
        anchors.fill: parent
        spacing: 0
        Rectangle{
            id:topBar
            width: parent.width
            height: 80
            color: "#ECF5FA"

            Row{
                id:row1
                anchors.fill: parent
                spacing: 30
                leftPadding : 100



                //炉号选择
                Item {
                    width: 214
                    height: parent.height
                    Row{
                        anchors.centerIn: parent
                        spacing: 5
                        Text {
                            text: "炉号："
                            font.pixelSize: 20
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        ForanceNumComboBox{
                            id:foranceNumComboBox
                            anchors.verticalCenter: parent.verticalCenter
                        }

                    }

                }


                //日期输入1（选择）
                Item {
                    width: 245
                    height: parent.height
                    Row{
                        anchors.centerIn: parent
                        spacing: 20
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 20
                            text: "日期"
                        }


                        Rectangle{
                            width: time_show_text.width + time_select_btn.width  + 40
                            height: time_select_btn.height + 8

                            radius: height/2
                            color: "#00000000"//透明颜色
                            border.width: 1
                            border.color: "black"

                            Row{
                                anchors.fill: parent
                                spacing: 10

                                //占空
                                Rectangle{
                                    width:1
                                    height: parent.height
                                    color: "#00000000"
                                }

                                Text{
                                    id:time_show_text
                                    text:globalDate1.toLocaleDateString(Qt.local,"yyyy/MM/dd")
                                    anchors.verticalCenter: parent.verticalCenter


                                }

                                Image {
                                    width: 20
                                    height: 20
                                    id:time_select_btn
                                    source: "qrc:/imgs/icons/button_calendar_press.png"
                                    anchors.verticalCenter: parent.verticalCenter
                                    scale: bntCalender.containsMouse ? 1.05 : 1
                                    Behavior on scale {
                                        PropertyAnimation{
                                            property: "scale"
                                            duration: 200
                                            easing.type: Easing.OutBack
                                        }
                                    }
                                    MouseArea{
                                        anchors.fill: parent
                                        id:bntCalender
                                        hoverEnabled: true
                                        onClicked: {
                                            calendarDialog1.open()
                                        }
                                    }
                                }

                            }


                        }

                    }
                }


                Item {
                    width: 20
                    height : parent.height
                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        text: "到"

                    }
                }

                //日期输入2（选择）
                Item {
                    width: 245
                    height: parent.height
                    Row{
                        anchors.centerIn: parent
                        spacing: 20
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 20
                            text: "日期"
                        }


                        Rectangle{
                            width: time_show_text1.width + time_select_btn1.width  + 40
                            height: time_select_btn1.height + 8

                            radius: height/2
                            color: "#00000000"//透明颜色
                            border.width: 1
                            border.color: "black"

                            Row{
                                anchors.fill: parent
                                spacing: 10

                                //占空
                                Rectangle{
                                    width:1
                                    height: parent.height
                                    color: "#00000000"
                                }

                                Text{
                                    id:time_show_text1
                                    text:globalDate2.toLocaleDateString(Qt.local,"yyyy/MM/dd")
                                    anchors.verticalCenter: parent.verticalCenter


                                }

                                Image {
                                    width: 20
                                    height: 20
                                    id:time_select_btn1
                                    source: "qrc:/imgs/icons/button_calendar_press.png"
                                    anchors.verticalCenter: parent.verticalCenter
                                    scale: bntCalender1.containsMouse ? 1.05 : 1
                                    Behavior on scale {
                                        PropertyAnimation{
                                            property: "scale"
                                            duration: 200
                                            easing.type: Easing.OutBack
                                        }
                                    }
                                    MouseArea{
                                        anchors.fill: parent
                                        id:bntCalender1
                                        hoverEnabled: true
                                        onClicked: {
                                            calendarDialog2.open()
                                        }
                                    }
                                }

                            }


                        }

                    }
                }



                //数据查询按钮
                Item {
                    width: 118
                    height: parent.height
                    RoundIconButton{
                        id:search_btn
                        anchors.centerIn: parent
                        text: "数据查询"
                        bgColor: "#5596E4"
                        imgSrc:"qrc:/imgs/icons/search_icon.png"
                        textSize: 20
                        onBngClicked: {
                            refreshData()
                        }
                    }
                }

                //数据导出按钮
                Item {
                    width: 118
                    height: parent.height
                    RoundIconButton{
                        id:export_btn
                        anchors.centerIn: parent
                        text: "数据导出"
                        bgColor: "#344750"
                        imgSrc:"qrc:/imgs/icons/export_icon.png"
                        textSize: 20
                        onBngClicked: {
                            //获取时间
                            var datetimes = []
                            for(var a = 0; a < pressdataModel.count; a++){
                                datetimes.push(pressdataModel.get(a).time)
                            }

                            //获取压力值1
                            var value1s = []
                            for(var a = 0; a < pressdataModel.count; a++){
                                value1s.push(pressdataModel.get(a).value1)
                            }

                            //获取压力值2
                            var value2s = []
                            for(var a = 0; a < pressdataModel.count; a++){
                                value2s.push(pressdataModel.get(a).value2)
                            }

                            //获取压力值3
                            var value3s = []
                            for(var a = 0; a < pressdataModel.count; a++){
                                value3s.push(pressdataModel.get(a).value3)
                            }

                            //获取压力值4
                            var value4s = []
                            for(var a = 0; a < pressdataModel.count; a++){
                                value4s.push(pressdataModel.get(a).value4)
                            }

                            server.exportPressureExcel(foranceNumComboBox.currentText,
                                                       datetimes,value1s,value2s,value3s,value4s)
                        }
                    }
                }

            }



        }

        Rectangle{
            id:header
            width: parent.width
            height: 45
            Row{
                anchors.fill: parent
                spacing: 2
                Repeater{
                    model:["日期","文丘里1","文丘里2","文丘里3","文丘里4"]
                    delegate: Rectangle{
                        width: parent.width/5
                        height: 45
                        color: "#344750"
                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: "#FFFFFF"
                            font.family: "微软雅黑"
                            font.pixelSize: 23
                        }
                    }
                }

            }
        }

        Flickable{
            id:gridFlic
            width: parent.width
            height: parent.height - topBar.height - header.height
            clip: true
            flickableDirection: Qt.Vertical
            contentHeight: gridContent.height
            contentWidth: gridContent.width
            anchors.horizontalCenter: parent.horizontalCenter
            boundsBehavior: Flickable.DragOverBounds

            Item{
                id: gridContent
                width: root.width
                height: gridCol.height

                Column{
                    width: parent.width
                    id:gridCol

                    Repeater{
                        model:pressdataModel
                        delegate: Rectangle{
                            width: gridContent.width
                            height: 40
                            color: index%2 == 0?"white":"#eef4f7"

                            Row{
                                anchors.fill: parent

                                Item{
                                    width: parent.width/5
                                    height: parent.height

                                    Text{
                                        anchors.centerIn: parent
                                        text: time
                                        font.pixelSize: 20
                                        color: "#454545"
                                    }

                                }

                                Item{
                                    width: parent.width/5
                                    height: parent.height

                                    Row{
                                        anchors.centerIn: parent
                                        spacing: 15

                                        Text{
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: value1//"文丘里1"//globalDate.toLocaleDateString(Qt.local,"yyyy/MM/dd")
                                            font.pixelSize: 20
                                            color: "#454545"
                                        }

                                    }

                                }

                                Item{
                                    width: parent.width/5
                                    height: parent.height

                                    Row{
                                        anchors.centerIn: parent
                                        spacing: 15

                                        Text{
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: value2//"文丘里2"//globalDate.toLocaleDateString(Qt.local,"yyyy/MM/dd")
                                            font.pixelSize: 20
                                            color: "#454545"
                                        }

                                    }

                                }

                                Item{
                                    width: parent.width/5
                                    height: parent.height

                                    Row{
                                        anchors.centerIn: parent
                                        spacing: 15

                                        Text{
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: value3//"文丘里3"//globalDate.toLocaleDateString(Qt.local,"yyyy/MM/dd")
                                            font.pixelSize: 20
                                            color: "#454545"
                                        }

                                    }

                                }

                                Item{
                                    width: parent.width/5
                                    height: parent.height

                                    Row{
                                        anchors.centerIn: parent
                                        spacing: 20

                                        Text{
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: value4//"文丘里4"//globalDate.toLocaleDateString(Qt.local,"yyyy/MM/dd")
                                            font.pixelSize: 20
                                            color: "#454545"
                                        }


                                    }

                                }

                            }
                        }
                    }
                }
            }
        }


    }


    CustomDialog{
        id:calendarDialog1
        title: "选择日期"
        content:Calendar{
            id:calendar1
            anchors.fill: parent
        }
        onAccepted: {
            globalDate1 = calendar1.selectedDate;
        }
    }

    CustomDialog{
        id:calendarDialog2
        title: "选择日期"
        content:Calendar{
            id:calendar2
            anchors.fill: parent
        }
        onAccepted: {
            globalDate2 = calendar2.selectedDate;
        }
    }
}
