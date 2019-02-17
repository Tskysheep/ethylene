import QtQuick 2.7
import "../Widget"
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id:root
    anchors.fill: parent

    property date globalDate: new Date()
    property int current_fn: forancecombox.currentIndex //当前炉号
    property int  current_edit_item_index: 0

    onCurrent_fnChanged: refreshData()

    function refreshData(){
        pressdataModel.clear()
        var datas = server.pressdataList(String(forancecombox.currentIndex));
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

    //压力信息表
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
                leftPadding: 50


                //日期输入（选择）
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
                            width: time_show_text1.width + time_select_btn1.width + 40
                            height: time_select_btn1.height + 8

                            radius: height/2
                            color: "#00000000"//透明颜色
                            border.width: 1
                            border.color: "black"

                            Row{
                                id:date_select_row
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
                                    text:globalDate.toLocaleDateString(Qt.local,"yyyy/MM/dd")
                                    anchors.verticalCenter: parent.verticalCenter


                                }

                                Image {
                                    height: 20
                                    width: 20
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
                                            calendarDialog.open()
                                        }
                                    }
                                }

                            }
                        }
                    }
                }

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
                            id:forancecombox
                            anchors.verticalCenter: parent.verticalCenter
                        }

                    }

                }

                //文丘里输入
                Item {
                    width: 786
                    height: parent.height
                    Column{
                        anchors.fill: parent
                        Row{
                            id:venturi_input_row
                            anchors.centerIn: parent
                            spacing: 10
                            Text {
                                text: "文丘里(Kpa)："
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 20
                            }
                            FormTextEdit2{
                                id:venturi1
                                width:150
                                height: 30
                                focuscolor: "blue"
                                non_focuscolor: "black"
                                pradius: 8
                                holderText:"请输入数值1"
                            }
                            FormTextEdit2{
                                id:venturi2
                                width:150
                                height: 30
                                focuscolor: "blue"
                                non_focuscolor: "black"
                                pradius: 8
                                holderText:"请输入数值2"
                            }
                            FormTextEdit2{
                                id:venturi3
                                width:150
                                height: 30
                                focuscolor: "blue"
                                non_focuscolor: "black"
                                pradius: 8
                                holderText:"请输入数值3"
                            }
                            FormTextEdit2{
                                id:venturi4
                                width:150
                                height: 30
                                focuscolor: "blue"
                                non_focuscolor: "black"
                                pradius: 8
                                holderText:"请输入数值4"
                            }


                        }
                        Text {
                            id:input_err_text
                            width: venturi_input_row.width
                            anchors.bottom: parent.bottom
                            text: ""
                            color: "#FF0101"
                            font.family: "微软雅黑"
                            font.pixelSize: 18
                        }
                    }
                }

                //确定按钮
                Item {
                    width: 118
                    height: parent.height
                    RoundIconButton{
                        id:sure_btn
                        anchors.centerIn: parent
                        text: "确定"
                        bgColor: "#5592E4"
                        imgSrc:"qrc:/imgs/icons/sure_icon.png"
                        textSize: 20
                        onBngClicked: {
                            //console.log("0000000000000")
                            //var now = new Date();
                            if((venturi1.text !== "")&&(venturi2.text !== "")&&(venturi3.text !== "")&&(venturi4.text !== "")){
                                input_err_text.text = ""
                                server.addPressure(forancecombox.currentIndex,Qt.formatDateTime(globalDate,"yyyy-MM-dd hh:mm:ss"),venturi1.text,venturi2.text,venturi3.text,venturi4.text)
                                refreshData()
                            }else{
                                input_err_text.text = "\t\t\t*输入数据不完整，请重新输入"
                            }
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
                        model: pressdataModel
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
                                        text: time//Number(index+1).toString() + "号管"
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

                                        Image {
                                            width: 20
                                            height: parent.height
                                            source: "qrc:/imgs/icons/edit_icon.png"
                                            MouseArea{
                                                anchors.fill: parent
                                                onClicked: {

                                                    pwd_input_dialog.visible = true;

                                                    current_edit_item_index = index//记录当前编辑行
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
        }


    }


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

    //管理员密码输入弹窗
    Rectangle{
        id:pwd_input_dialog
        visible: false
        z:3
        border.width: 2
        border.color: "black"
        width: 334
        height: 200
        anchors.centerIn: parent
        Column{
            anchors.fill: parent
            spacing: 20
            Text {
                id:pwd_tips
                anchors.horizontalCenter: parent.horizontalCenter
                text: "*请输入管理员密码"
                color: "#FF0101"
                font.family: "微软雅黑"
                font.pixelSize: 20

            }
            Row{
                width: 212
                height: 42
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text:"密码："
                    font.pixelSize: 23

                }

                Rectangle{
                    width: pwd_input.width
                    height: pwd_input.height
                    border.color: "black"
                    border.width: 1
                    color: "#00000000"
                    z:0
                    FormTextEdit2{
                        id:pwd_input
                        width: pwd_tips.width - 20
                        height: 25
                        echoMode: TextInput.Password
                        non_focuscolor: "black"
                    }

                }
                            }
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 50
                Rectangle{
                    id:yes_btn
                    color: "#557EE4"
                    radius: 5
                    width: 80
                    height: 30
                    scale: ma1.containsMouse?1.1:1
                    Behavior on scale{
                        PropertyAnimation{
                            properties: "scale"
                            duration: 200
                            easing.type: Easing.OutBack
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text:"确定"
                        font.pixelSize: 23
                    }

                    MouseArea{
                        id:ma1
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if(server.verifyAdminPwd(pwd_input.text)) {
                                admin_pwd_error_tips.text = ""
                                pwd_input.text = ""
                                fix_date_input.holderText = pressdataModel.get(current_edit_item_index).time
                                venturi1_fix_input.holderText = pressdataModel.get(current_edit_item_index).value1
                                venturi2_fix_input.holderText = pressdataModel.get(current_edit_item_index).value2
                                venturi3_fix_input.holderText = pressdataModel.get(current_edit_item_index).value3
                                venturi4_fix_input.holderText = pressdataModel.get(current_edit_item_index).value4
                                pwd_input_dialog.visible = false;
                                venturi_fix_dialog.visible = true;


                            }else{
                                admin_pwd_error_tips.text = "密码不正确"
                            }
                        }
                    }

                }

                Rectangle{
                    id:cancel_btn
                    color: "#C4C4C4"
                    radius: 5
                    width: 80
                    height: 30
                    scale: ma2.containsMouse?1.1:1
                    Behavior on scale{
                        PropertyAnimation{
                            properties: "scale"
                            duration: 200
                            easing.type: Easing.OutBack
                        }
                    }
                    Text {
                        anchors.centerIn: parent
                        text:"取消"
                        font.pixelSize: 23
                    }

                    MouseArea{
                        id:ma2
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            pwd_input_dialog.visible = false;
                            pwd_input.text=""

                        }

                    }

                }

            }
            Text{
                id:admin_pwd_error_tips
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

    }
    //文丘里数值修改弹窗
    Rectangle{
        id:venturi_fix_dialog
        visible: false
        z:3
        border.width: 2
        border.color: "black"
        width: 300
        height: 500
        anchors.centerIn: parent

        Column{
            anchors.fill: parent
            spacing: 50
            Text {
                text:"*请修改文丘里的值"
                font.pixelSize: 23
                color: "#FC0303"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Row{
                Text {
                    id:date_tip
                    text: "   日期："
                    anchors.verticalCenter:parent.verticalCenter
                    //font.family: "微软雅黑"
                }

                FormTextEdit2{
                    id:fix_date_input
                    non_focuscolor: "black"
                    width: venturi_fix_dialog.width - date_tip.width - 10
                }

            }

            Row{
                Text {
                    text: "文丘里1："
                    anchors.verticalCenter: parent.verticalCenter
                    //font.family: "微软雅黑"
                }

                FormTextEdit2{
                    id:venturi1_fix_input
                    non_focuscolor: "black"
                    width: venturi_fix_dialog.width - date_tip.width - 10
                }
            }

            Row{
                Text {
                    text: "文丘里2："
                    anchors.verticalCenter:parent.verticalCenter
                    //font.family: "微软雅黑"
                }

                FormTextEdit2{
                    id:venturi2_fix_input
                    non_focuscolor: "black"
                    width: venturi_fix_dialog.width - date_tip.width - 10
                }
            }

            Row{
                Text {
                    text: "文丘里3："
                    anchors.verticalCenter:parent.verticalCenter
                    //font.family: "微软雅黑"
                }

                FormTextEdit2{
                    id:venturi3_fix_input
                    non_focuscolor: "black"
                    width: venturi_fix_dialog.width - date_tip.width - 10
                }
            }

            Row{
                Text {
                    text: "文丘里4："
                    anchors.verticalCenter:parent.verticalCenter
                    //font.family: "微软雅黑"
                }

                FormTextEdit2{
                    id:venturi4_fix_input
                    non_focuscolor: "black"
                    width: venturi_fix_dialog.width - date_tip.width - 10
                }
            }

            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 50
                Rectangle{
                    id:yes_btn2
                    color: "#557EE4"
                    radius: 5
                    width: 80
                    height: 30
                    scale: ma3.containsMouse?1.1:1
                    Behavior on scale{
                        PropertyAnimation{
                            properties: "scale"
                            duration: 200
                            easing.type: Easing.OutBack
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text:"确定"
                        font.pixelSize: 23
                    }

                    MouseArea{
                        id:ma3
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            venturi_fix_dialog.visible = false;
                            //获取旧数据
                            var old_values = []
                            old_values.push(pressdataModel.get(current_edit_item_index).value1)
                            old_values.push(pressdataModel.get(current_edit_item_index).value2)
                            old_values.push(pressdataModel.get(current_edit_item_index).value3)
                            old_values.push(pressdataModel.get(current_edit_item_index).value4)
                            //获取新数据
                            var new_values = []
                            new_values.push(venturi1_fix_input.text)
                            new_values.push(venturi2_fix_input.text)
                            new_values.push(venturi3_fix_input.text)
                            new_values.push(venturi4_fix_input.text)

                            //获取旧时间
                            var old_time = pressdataModel.get(current_edit_item_index).time.split("/").join("-")

                            //获取新时间
                            var new_time = fix_date_input.text.split("/").join("-")

                            server.updatePressData(String(current_fn),old_values,new_values,old_time,new_time)

                            refreshData()
                        }
                    }

                }

                Rectangle{
                    id:cancel_btn2
                    color: "#C4C4C4"
                    radius: 5
                    width: 80
                    height: 30
                    scale: ma4.containsMouse?1.1:1
                    Behavior on scale{
                        PropertyAnimation{
                            properties: "scale"
                            duration: 200
                            easing.type: Easing.OutBack
                        }
                    }
                    Text {
                        anchors.centerIn: parent
                        text:"取消"
                        font.pixelSize: 23
                    }

                    MouseArea{
                        id:ma4
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: venturi_fix_dialog.visible = false;

                    }

                }

            }

        }
    }
}
