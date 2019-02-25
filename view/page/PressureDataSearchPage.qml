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

    //sky 横跨段默认字段(十一个炉)
    property var acrossSection:[
        ["PI1351_0","PI1352_0"],//0号炉的字段
        ["PI1352_1"],//1号炉的字段
        ["PI1351_2","PI1352_2"],
        ["PI1351_3","PI1352_3"],
        ["PI1451_4","PI1452_4","PI1453_4","PI1454_4"],
        ["PI1451_5","PI1452_5","PI1453_5","PI1454_5"],
        ["PI1451_6","PI1452_6","PI1453_6","PI1454_6"],
        ["PI1451_7","PI1452_7","PI1453_7","PI1454_7"],
        ["PI1551","PI1552"],
        ["PI1351_9","PI1352_9"],
        ["PI1351_10","PI1352_10"]
    ]

    onCurrent_fnChanged: refreshData()

    //查询文丘里
    function refreshData(){
        //清除上一次数据
        pressdataModel.clear()

        //获取时间
        var from_time = time_show_edit.text.split("/").join("-")
        var to_time = time_show_edit2.text.split("/").join("-")

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

    //查询横跨段
    function refreshData2(){
        pressdataModel.clear();

        var from_time = time_show_edit.text.split("/").join("-")
        var to_time = time_show_edit2.text.split("/").join("-")

        var ftime = new Date(from_time)
        ftime.setHours(Number(hours_input.text))
        ftime.setMinutes(Number(minute_input.text))
        ftime.setSeconds(0)

        var ttime = new Date(to_time)
        ttime.setHours(Number(hours_input.text))
        ttime.setMinutes(Number(minute_input.text))
        ttime.setSeconds(0)

        var day_num = (ttime.getTime() - ftime.getTime())/(24*60*60*1000)

        for(var a = 0; a < day_num; a++){
            var obj = server.access_acrossection_pressdata(acrossSection[foranceNumComboBox.currentIndex],new Date(ftime.getTime()+a*24*60*60*1000))
            switch(acrossSection[foranceNumComboBox.currentIndex].length){
                    case 1:
                        pressdataModel.append({
                                                  "time" :obj.time,
                                                  "value1":obj.value1,
                                                  "value2":"无",
                                                  "value3":"无",
                                                  "value4":"无"
                                              })

                        break;
                    case 2:
                        pressdataModel.append({
                                                  "time" :obj.time,
                                                  "value1":obj.value1,
                                                  "value2":obj.value2,
                                                  "value3":"无",
                                                  "value4":"无"
                                              })

                        break;

                    case 4:
                        pressdataModel.append({
                                                  "time" :obj.time,
                                                  "value1":obj.value1,
                                                  "value2":obj.value2,
                                                  "value3":obj.value3,
                                                  "value4":obj.value4
                                              })
                        break;
            }

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
                spacing: 50
                leftPadding : 100

                //切换按钮
                Item {
                    width: 150
                    height: parent.height
                    RoundIconButton{
                        id:changepage_btn
                        anchors.centerIn: parent
                        text: "切换到横跨段查询"
                        bgColor: "#5596E4"
                        //imgSrc:"qrc:/imgs/icons/search_icon.png"
                        textSize: 13
                        onBngClicked: {

                            if(text === "切换到横跨段查询" ){
                                timeset.visible = true
                                pressdataModel.clear()
                                content_loader.sourceComponent = accrossection_component
                                header_repeater.model = ["日期","横跨段1","横跨段2","横跨段3","横跨段4"]
                                timepicker.open()
                            }else{
                                timeset.visible = false
                                pressdataModel.clear()
                                content_loader.sourceComponent = venturi_component
                                header_repeater.model = ["日期","文丘里1","文丘里2","文丘里3","文丘里4"]
                            }

                           text =  (text === "切换到横跨段查询" ) ? "切换到文丘里查询" : "切换到横跨段查询"
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
                        spacing: 10
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 20
                            text: "日期"
                        }


                        Rectangle{
                            width: time_show_edit.width + time_select_btn.width  + 40
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

/*                                Text{
                                    id:time_show_text
                                    text:globalDate1.toLocaleDateString(Qt.local,"yyyy/MM/dd")
                                    anchors.verticalCenter: parent.verticalCenter


                                }
*/

                                TextField{
                                    id:time_show_edit
                                    anchors.verticalCenter: parent.verticalCenter
                                    verticalAlignment: TextInput.AlignVCenter
                                    horizontalAlignment: TextInput.AlignHCenter
                                    text:Qt.formatDateTime(globalDate1,"yyyy/MM/dd")
                                    validator: RegExpValidator{
                                        //regExp: /^(?:(?!0000)[0-9]{4}[/](?:(?:0[1-9]|1[0-2])(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])[/](?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$/
                                        //利用正则限定日期格式输入（yyyy/MM/dd）
                                        regExp: /^([0-9]{4}|[0-9]{2})[/]([0]?[1-9]|[1][0-2])[/]([0]?[1-9]|[1|2][0-9]|[3][0|1])$/
                                    }

                                    onTextChanged: {

                                    }

                                    onEditingFinished:{
                                    }

                                    style:TextFieldStyle{
                                        background: Rectangle{
                                            color: "#00000000"
                                            border.color: "#00000000"
                                        }
                                    }
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
                        spacing: 10
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 20
                            text: "日期"
                        }


                        Rectangle{
                            width: time_show_edit2.width + time_select_btn1.width  + 40
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

/*                                Text{
                                    id:time_show_text1
                                    text:globalDate2.toLocaleDateString(Qt.local,"yyyy/MM/dd")
                                    anchors.verticalCenter: parent.verticalCenter


                                }
*/

                                TextField{
                                    id:time_show_edit2
                                    anchors.verticalCenter: parent.verticalCenter
                                    verticalAlignment: TextInput.AlignVCenter
                                    horizontalAlignment: TextInput.AlignHCenter
                                    text:Qt.formatDateTime(globalDate2,"yyyy/MM/dd")
                                    validator: RegExpValidator{
                                        //regExp: /^(?:(?!0000)[0-9]{4}[/](?:(?:0[1-9]|1[0-2])(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])[/](?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$/
                                        //利用正则限定日期格式输入（yyyy/MM/dd）
                                        regExp: /^([0-9]{4}|[0-9]{2})[/]([0]?[1-9]|[1][0-2])[/]([0]?[1-9]|[1|2][0-9]|[3][0|1])$/
                                    }

                                    onTextChanged: {

                                    }

                                    onEditingFinished:{
                                    }

                                    style:TextFieldStyle{
                                        background: Rectangle{
                                            color: "#00000000"
                                            border.color: "#00000000"
                                        }
                                    }
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


                Image {
                    id: timeset
                    width: 20
                    height: 20
                    visible: false
                    source: "qrc:/imgs/icons/timeclock3.png"
                    anchors.verticalCenter: parent.verticalCenter
                    scale:timesetma.containsMouse ? 1.1 :1

                    Behavior on scale {
                        PropertyAnimation{
                            properties: "scale"
                            duration: 200
                            easing.type: Easing.OutBack
                        }
                    }

                    MouseArea{
                        id:timesetma
                        anchors.fill: timeset
                        hoverEnabled: true
                        onClicked: {
                            timepicker.open()
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
                            if(changepage_btn.text === "切换到横跨段查询"){
                                refreshData()
                            }else{
                                tip_dialog.show("正在查询数据中，请稍等....")
                                refreshData2()
                                tip_dialog.hide("查询完成！")
                            }
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

                           if(changepage_btn.text === "切换到横跨段查询"){
                               server.exportPressureExcel(foranceNumComboBox.currentText,
                                                          datetimes,value1s,value2s,value3s,value4s)
                           }else{

                               server.exportPressure2Excel(foranceNumComboBox.currentText,
                                                          datetimes,value1s,value2s,value3s,value4s)
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
                    id:header_repeater
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

        Loader{
            id:content_loader
            width: parent.width
            height: parent.height - topBar.height - header.height
            sourceComponent: venturi_component
        }



//        Flickable{
//            id:gridFlic
//            width: parent.width
//            height: parent.height - topBar.height - header.height
//            clip: true
//            flickableDirection: Qt.Vertical
//            contentHeight: gridContent.height
//            contentWidth: gridContent.width
//            anchors.horizontalCenter: parent.horizontalCenter
//            boundsBehavior: Flickable.DragOverBounds

//        }


    }


    Component{
        id:venturi_component
        ScrollView{
            anchors.fill: parent

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

    Component{
        id:accrossection_component
        ScrollView{
            anchors.fill: parent

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

    CustomDialog{
        id:timepicker
        title: "请指定查询时间"
        content: Item {
            anchors.fill: parent
            Row{
                anchors.centerIn: parent
                spacing: 10
                Column{
                    id:hours_col
                    spacing: 3
                    Text {
                        id:add_hours
                        width: hours_input.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "+"
                        font.pixelSize: 20
                        MouseArea{
                            anchors.fill: add_hours
                            onClicked: {
                                hours_input.text = (Number(hours_input.text) + 1) > 23 ? 23 : (Number(hours_input.text) + 1)

                            }
                        }
                    }
                    PlainTextEdit{
                        id:hours_input
                        maxNumber: 23
                        minNumber: 0
                        text:new Date().getHours()
                    }
                    Text {
                        id:sub_hours
                        width: hours_input.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "-"
                        font.pixelSize: 20
                        MouseArea{
                            anchors.fill: sub_hours
                            onClicked: {
                                hours_input.text = (Number(hours_input.text) - 1) < 0 ? 0 :(Number(hours_input.text) - 1)
                            }
                        }
                    }
                }
                Text {
                    height: hours_col.height
                    verticalAlignment: Text.AlignVCenter
                    text:"时"
                    font.pixelSize: 25
                }
                Column{
                    id:minute_col
                    spacing: 3
                    Text {
                        id:add_minute
                        width: minute_input.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "+"
                        font.pixelSize: 20
                        MouseArea{
                            anchors.fill: add_minute
                            onClicked: {
                                minute_input.text = (Number(minute_input.text) + 1) > 59 ? 59 : (Number(minute_input.text) + 1)

                            }
                        }
                    }
                    PlainTextEdit{
                        id:minute_input
                        maxNumber: 59
                        minNumber: 0
                        text : new Date().getMinutes()
                    }
                    Text {
                        id:sub_minute
                        width: minute_input.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "-"
                        font.pixelSize: 20
                        MouseArea{
                            anchors.fill: sub_minute
                            onClicked: {
                                minute_input.text = (Number(minute_input.text) - 1) < 0 ? 0 : (Number(minute_input.text) - 1)
                            }
                        }
                    }
                }
                Text {
                    height: minute_col.height
                    verticalAlignment: Text.AlignVCenter
                    text:"分"
                    font.pixelSize: 25
                }
            }
        }
    }

    TipBusyIndicator{
        id:tip_dialog
    }

}
