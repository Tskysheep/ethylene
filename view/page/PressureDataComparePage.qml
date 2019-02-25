import QtQuick 2.7
import "../Widget"
import QtCharts 2.1
import QtQuick.Controls 1.4

Item {
    anchors.fill: parent
    id:root

    property var _Datas: []
    property date from_date: new Date()
    property date to_date: new Date()
    property int day_num : 0
    property int current_day: 0
    property int current_chartview: 0 // 0 代表文秋里  1 代表横跨段

    onCurrent_chartviewChanged: {
        if(current_chartview === 0){
            bar1.label = "文秋里1"
            bar2.label = "文秋里2"
            bar3.label = "文秋里3"
            bar4.label = "文秋里4"
        }else{
            bar1.label = "横跨段1"
            bar2.label = "横跨段2"
            bar3.label = "横跨段3"
            bar4.label = "横跨段4"
        }
    }

    onCurrent_dayChanged: {
        if(current_chartview === 0){
            //文秋里切换时 数据填充逻辑
            if(current_day < 0){
                current_day = 0
                barChart.title = "当前数据时间："+Qt.formatDateTime(new Date(from_date.getTime() + current_day*24*60*60*1000),"yyyy/MM/dd")
                for(var c = 0; c < _Datas[current_day].length; c++){
                    bar1.replace(c,_Datas[current_day][c].value1)
                    bar2.replace(c,_Datas[current_day][c].value2)
                    bar3.replace(c,_Datas[current_day][c].value3)
                    bar4.replace(c,_Datas[current_day][c].value4)
                }
            }else if(current_day >= day_num){
                current_day = day_num - 1;
                barChart.title = "当前数据时间："+Qt.formatDateTime(new Date(from_date.getTime() + current_day*24*60*60*1000),"yyyy/MM/dd")
                for(var c = 0; c < _Datas[current_day].length; c++){
                    bar1.replace(c,_Datas[current_day][c].value1)
                    bar2.replace(c,_Datas[current_day][c].value2)
                    bar3.replace(c,_Datas[current_day][c].value3)
                    bar4.replace(c,_Datas[current_day][c].value4)
                }
            }else{
                barChart.title = "当前数据时间："+Qt.formatDateTime(new Date(from_date.getTime() + current_day*24*60*60*1000),"yyyy/MM/dd")
                for(var c = 0; c < _Datas[current_day].length; c++){
                    bar1.replace(c,_Datas[current_day][c].value1)
                    bar2.replace(c,_Datas[current_day][c].value2)
                    bar3.replace(c,_Datas[current_day][c].value3)
                    bar4.replace(c,_Datas[current_day][c].value4)
                }
            }

        }else{
            //横跨段切换时 数据填充逻辑
            if(current_day < 0){
                current_day = 0
                barChart.title = "当前数据时间："+Qt.formatDateTime(new Date(from_date.getTime() + current_day*24*60*60*1000),"yyyy/MM/dd")
                for(var c = 0; c < _Datas[current_day].length; c++){
                    switch(acrossSection[c].length){
                    case 1:
                        bar1.replace(c,_Datas[current_day][c].value1)
                        bar2.replace(c,0)
                        bar3.replace(c,0)
                        bar4.replace(c,0)
                        break;
                    case 2:
                        bar1.replace(c,_Datas[current_day][c].value1)
                        bar2.replace(c,_Datas[current_day][c].value2)
                        bar3.replace(c,0)
                        bar4.replace(c,0)
                        break;
                    case 4:
                        bar1.replace(c,_Datas[current_day][c].value1)
                        bar2.replace(c,_Datas[current_day][c].value2)
                        bar3.replace(c,_Datas[current_day][c].value3)
                        bar4.replace(c,_Datas[current_day][c].value4)
                        break;

                    }
                }
            }else if(current_day >= day_num){
                current_day = day_num - 1;
                barChart.title = "当前数据时间："+Qt.formatDateTime(new Date(from_date.getTime() + current_day*24*60*60*1000),"yyyy/MM/dd")
                for(var c = 0; c < _Datas[current_day].length; c++){
                    switch(acrossSection[c].length){
                    case 1:
                        bar1.replace(c,_Datas[current_day][c].value1)
                        bar2.replace(c,0)
                        bar3.replace(c,0)
                        bar4.replace(c,0)
                        break;
                    case 2:
                        bar1.replace(c,_Datas[current_day][c].value1)
                        bar2.replace(c,_Datas[current_day][c].value2)
                        bar3.replace(c,0)
                        bar4.replace(c,0)
                        break;
                    case 4:
                        bar1.replace(c,_Datas[current_day][c].value1)
                        bar2.replace(c,_Datas[current_day][c].value2)
                        bar3.replace(c,_Datas[current_day][c].value3)
                        bar4.replace(c,_Datas[current_day][c].value4)
                        break;

                    }
                }

            }else{
                for(var c = 0; c < _Datas[current_day].length; c++){
                    barChart.title = "当前数据时间："+Qt.formatDateTime(new Date(from_date.getTime() + current_day*24*60*60*1000),"yyyy/MM/dd")
                    switch(acrossSection[c].length){
                    case 1:
                        bar1.replace(c,_Datas[current_day][c].value1)
                        bar2.replace(c,0)
                        bar3.replace(c,0)
                        bar4.replace(c,0)
                        break;
                    case 2:
                        bar1.replace(c,_Datas[current_day][c].value1)
                        bar2.replace(c,_Datas[current_day][c].value2)
                        bar3.replace(c,0)
                        bar4.replace(c,0)
                        break;
                    case 4:
                        bar1.replace(c,_Datas[current_day][c].value1)
                        bar2.replace(c,_Datas[current_day][c].value2)
                        bar3.replace(c,_Datas[current_day][c].value3)
                        bar4.replace(c,_Datas[current_day][c].value4)
                        break;

                    }
                }
            }

        }

    }


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

    function refresh(){
        _Datas = []
        current_day = 0

        var from_str = fromDatPicker.year + "-" + fromDatPicker.month + "-" + fromDatPicker.day
        var to_str = toDatPicker.year + "-" + toDatPicker.month + "-" + toDatPicker.day

        var fdt = new Date(from_str)
        fdt.setHours(0)
        fdt.setMinutes(0)
        fdt.setSeconds(0)
        from_date = fdt

        var tdt = new Date(to_str)
        tdt.setHours(23)
        tdt.setMinutes(59)
        tdt.setSeconds(59)
        to_date = tdt

        day_num = (tdt.getTime() - fdt.getTime()) / (24*60*60*1000)

        for(var a = 0; a < day_num; a++){
            var data = []
            for(var b = 0; b < acrossSection.length; b++){
                var obj = server.diagnoseVenturiPressureData(b,Qt.formatDateTime(new Date(fdt.getTime() + a*24*60*60*1000),"yyyy-MM-dd"))
                //console.log(obj.time)

                var obj2 = {};
                //判断obj 是否为空
                if(obj.time){
                    obj2.time = obj.time
                    obj2.fn = b
                    obj2.value1 = obj.value1
                    obj2.value2 = obj.value2
                    obj2.value3 = obj.value3
                    obj2.value4 = obj.value4
                }else{
                    obj2.time = ""
                    obj2.fn = b
                    obj2.value1 = 0
                    obj2.value2 = 0
                    obj2.value3 = 0
                    obj2.value4 = 0
                }

                data.push(obj2)
            }

            _Datas.push(data)
        }

        //初始化图表
        barChart.title = "当前数据时间"+Qt.formatDateTime(new Date(from_date.getTime() + current_day*24*60*60*1000),"yyyy/MM/dd")
        for(var c = 0; c < _Datas[current_day].length; c++){
            bar1.replace(c,_Datas[current_day][c].value1)
            bar2.replace(c,_Datas[current_day][c].value2)
            bar3.replace(c,_Datas[current_day][c].value3)
            bar4.replace(c,_Datas[current_day][c].value4)
        }



    }

    function refresh2(){
        _Datas = []
        current_day = 0

        var from_str = fromDatPicker.year + "-" + fromDatPicker.month + "-" + fromDatPicker.day
        var to_str = toDatPicker.year + "-" + toDatPicker.month + "-" + toDatPicker.day

        var fdt = new Date(from_str)
        fdt.setHours(Number(hours_input.text))
        fdt.setMinutes(Number(minute_input.text))
        fdt.setSeconds(0)
        from_date = fdt

        var tdt = new Date(to_str)
        tdt.setHours(Number(hours_input.text))
        tdt.setMinutes(Number(minute_input.text))
        tdt.setSeconds(0)
        to_date = tdt

        day_num = (tdt.getTime() - fdt.getTime()) / (24*60*60*1000)
        //console.log("天数",day_num)

        for(var a = 0; a < day_num; a++){
            var data = []
            for(var b = 0; b < acrossSection.length; b++){
                var obj = server.access_acrossection_pressdata(acrossSection[b],new Date(fdt.getTime() + a*24*60*60*1000))
                var obj2 = {};
                //判断obj 是否为空
                if(obj.time){
                    switch(acrossSection[b].length){
                        case 1:
                            obj2.time = obj.time
                            obj2.fn = b
                            obj2.value1 = obj.value1
                            break;
                        case 2:
                            obj2.time = obj.time
                            obj2.fn = b
                            obj2.value1 = obj.value1
                            obj2.value2 = obj.value2
                            break;
                        case 4:
                            obj2.time = obj.time
                            obj2.fn = b
                            obj2.value1 = obj.value1
                            obj2.value2 = obj.value2
                            obj2.value3 = obj.value3
                            obj2.value4 = obj.value4
                            break;
                    }

                }else{
                    switch(acrossSection[b].length){
                        case 1:
                            obj2.time = ""
                            obj2.fn = b
                            obj2.value1 = 0
                            break;
                        case 2:
                            obj2.time = ""
                            obj2.fn = b
                            obj2.value1 = 0
                            obj2.value2 = 0
                            break;
                        case 4:
                            obj2.time = ""
                            obj2.fn = b
                            obj2.value1 = 0
                            obj2.value2 = 0
                            obj2.value3 = 0
                            obj2.value4 = 0
                            break;
                    }

                }

                data.push(obj2)
            }

            _Datas.push(data)
        }

        barChart.title = "当前数据时间："+Qt.formatDateTime(new Date(from_date.getTime() + current_day*24*60*60*1000),"yyyy/MM/dd")

        for(var c = 0; c < _Datas[current_day].length; c++){
            switch(acrossSection[c].length){
            case 1:
                bar1.replace(c,_Datas[current_day][c].value1)
                bar2.replace(c,0)
                bar3.replace(c,0)
                bar4.replace(c,0)
                break;
            case 2:
                bar1.replace(c,_Datas[current_day][c].value1)
                bar2.replace(c,_Datas[current_day][c].value2)
                bar3.replace(c,0)
                bar4.replace(c,0)
                break;
            case 4:
                bar1.replace(c,_Datas[current_day][c].value1)
                bar2.replace(c,_Datas[current_day][c].value2)
                bar3.replace(c,_Datas[current_day][c].value3)
                bar4.replace(c,_Datas[current_day][c].value4)
                break;

            }
        }




    }


    Column{
        anchors.fill: parent
        z:2
        //top bar
        Item{
            id:top_bar
            width: parent.width
            height: 50
            //clip: true
            Rectangle{
                width: parent.width-10
                anchors.horizontalCenter: parent.horizontalCenter
                height: 1
                color: "#dadada"
                anchors.bottom: parent.bottom
            }

            // select row
            Row{
                id:select_row
                anchors.verticalCenter: parent.verticalCenter
                x:parent.width/2 -  select_row.width / 2
                spacing: 30

                //text
//                Item{
//                    width: 20
//                    height: 20
//                    anchors.verticalCenter: compareBnt.verticalCenter
//                    Text{
//                        anchors.centerIn: parent
//                        text: "炉号"
//                        font.pixelSize: 15
//                        font.family: "微软雅黑"
//                        color: "#3E3E3E"
//                    }
//                }

                //foruance num selector
//                ForanceNumComboBox{
//                    id:foranceComboBox
//                    anchors.verticalCenter: compareBnt.verticalCenter
//                }


                Item{
                    width: 20
                    height: 20
                    anchors.verticalCenter: compareBnt.verticalCenter
                    Text{
                        anchors.centerIn: parent
                        text: "从"
                        font.pixelSize: 15
                        font.family: "微软雅黑"
                        color: "#3E3E3E"
                    }
                }

                //from date picker
                DatePicker{
                    id:fromDatPicker
                    anchors.verticalCenter: compareBnt.verticalCenter
                }


                Image{
                    width: 20
                    height: 20
                    id:fromtime_select_btn
                    source: "qrc:/imgs/icons/button_calendar_press.png"
                    scale:btnCalender1.containsMouse ? 1.1 : 1
                    anchors.verticalCenter: compareBnt.verticalCenter
                    Behavior on scale {
                        PropertyAnimation{
                            properties: "scale"
                            duration: 200
                            easing.type: Easing.OutBack
                        }
                    }

                    MouseArea{
                        anchors.fill: fromtime_select_btn
                        id:btnCalender1
                        hoverEnabled: true
                        onClicked: {
                            fromtime_calendarDialog.open()
                        }
                    }
                }


                //text
                Item{
                    width: 20
                    height: 20
                    anchors.verticalCenter: compareBnt.verticalCenter
                    Text{
                        anchors.centerIn: parent
                        text: "到"
                        font.pixelSize: 15
                        font.family: "微软雅黑"
                        color: "#3E3E3E"
                    }
                }

                //to date picker
                DatePicker{
                    id:toDatPicker
                    anchors.verticalCenter: compareBnt.verticalCenter
                }

                Image{
                    width: 20
                    height: 20
                    id:totime_select_btn
                    source: "qrc:/imgs/icons/button_calendar_press.png"
                    scale:btnCalender2.containsMouse ? 1.1 : 1
                    anchors.verticalCenter: compareBnt.verticalCenter
                    Behavior on scale {
                        PropertyAnimation{
                            properties: "scale"
                            duration: 200
                            easing.type: Easing.OutBack
                        }
                    }

                    MouseArea{
                        anchors.fill: totime_select_btn
                        id:btnCalender2
                        hoverEnabled: true
                        onClicked: {
                            totime_calendarDialog.open()
                        }
                    }
                }


//                Rectangle{
//                    id:timeset
//                    width: 20
//                    height: 20
//                    color: "black"
//                    visible: false
//                    anchors.verticalCenter: compareBnt.verticalCenter
//                    MouseArea{
//                        anchors.fill: timeset
//                        onClicked: {
//                            timepicker.open()
//                        }

//                    }

//                }

                Image {
                    id: timeset
                    width: 20
                    height: 20
                    visible: false
                    source: "qrc:/imgs/icons/timeclock3.png"
                    anchors.verticalCenter: compareBnt.verticalCenter
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



                //compare button
                RoundIconButton{
                    id: compareBnt
                    text: "开始比较"
                    width: 120
                    height: 35
                    textSize: 17
                    imgSrc: "qrc:/imgs/icons/bnt_comparer.png"
                    bgColor: "#5596E4"

                    onBngClicked: {
                        //refresh();
                        switch(current_chartview){
                            case 0:
                                refresh();
                                break;
                            case 1:
                                refresh2();
                                break;
                        }
                    }
                }

                RoundIconButton{
                    imgSrc: "qrc:/imgs/icons/picture.png"
                    width: 120
                    height: 35
                    textSize: 17
                    text: "导出图片"
                    bgColor: "#344750"
                    onBngClicked: {
                        root.grabToImage(function(result){
                            var url = server.getSaveFilePath();
                            result.saveToFile(url);
                        });
                    }
                }
            }

        }

        Item{
            id:change_btn
            width: parent.width
            height: 65

            RoundIconButton{
                id: venturi
                text: "文丘里"
                width: 120
                height: 35
                textSize: 17
                x:parent.width / 2 - width - 15
                anchors.bottom: parent.bottom
                bgColor: "#5596E4"

                onBngClicked: {
                    //refresh();
//                    if(mainloader.sourceComponent !== venturi_component){
//                        mainloader.sourceComponent = venturi_component
//                    }

                    current_chartview = 0
                    timeset.visible = false
                }
            }

            RoundIconButton{
                id: across_section
                text: "横跨段"
                width: 120
                height: 35
                textSize: 17
                x:parent.width / 2 + 15
                anchors.bottom: parent.bottom
                bgColor: "#344750"

                onBngClicked: {
                    //refresh();
//                    if(mainloader.sourceComponent !== acrossection_component){
//                        mainloader.sourceComponent = acrossection_component
//                        timepicker.open();
//                    }

                    current_chartview = 1
                     timeset.visible = true
                }
            }


        }

        Item {
            width: parent.width
            height:parent.height - top_bar.height - change_btn.height
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.fill: parent

            Image {
                id: upPage
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: barChart.left
                source: "qrc:/imgs/icons/upPage_icon.png"
                scale: upma.containsMouse ? 1.3 : 1

                Behavior on scale{
                    PropertyAnimation{
                        properties: "scale"
                        duration: 200
                        easing.type: Easing.OutBack
                    }
                }

                MouseArea{
                    id:upma
                    hoverEnabled: true
                    anchors.fill: upPage
                    onClicked: {
                        if(_Datas.length === 0) return;
                            current_day--
                    }
                }

            }

            Image {
                id: nextPage
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: barChart.right
                source: "qrc:/imgs/icons/nextPage_icon.png"

                scale: nextma.containsMouse ? 1.3 : 1

                Behavior on scale{
                    PropertyAnimation{
                        properties: "scale"
                        duration: 200
                        easing.type:  Easing.OutBack
                    }
                }

                MouseArea{
                    id:nextma
                    hoverEnabled: true
                    anchors.fill: nextPage
                    onClicked: {
                        if(_Datas.length === 0) return;
                            current_day++

                    }
                }
            }


            ChartView{
                width: parent.width * 8/9
                height: parent.height
                anchors.centerIn: parent
                antialiasing: true
                id:barChart
                backgroundColor: "#00000000"
                title: "当前数据时间："
                titleFont.family: "微软雅黑"
                titleFont.pixelSize: 20

                property int maxValue:600
                property int minValue: 0

                Behavior on maxValue{
                    PropertyAnimation{
                        properties: "maxValue"
                        duration: 300
                        easing.type: Easing.OutQuint
                    }
                }

                Behavior on minValue{
                    PropertyAnimation{
                        properties: "minValue"
                        duration: 300
                        easing.type: Easing.OutQuint
                    }
                }

                UpDownBox{
                    id:maxUpdownBox
                    anchors.top: barChart.top
                    anchors.topMargin: 60
                    upEnable: barChart.maxValue<1500
                    downEnable: barChart.minValue < barChart.maxValue
                    onAboutToDown: {
                        barChart.maxValue -=50;
                    }
                    onAboutToUp: {
                        barChart.maxValue += 50;
                    }
                }

                UpDownBox{
                    id:minUpdownBox
                    anchors.bottom: barChart.bottom
                    anchors.bottomMargin: 50
                    upEnable: barChart.minValue < barChart.maxValue
                    downEnable: barChart.minDisplayTemp>0
                    onAboutToDown: {
                        barChart.minValue -=50;
                    }
                    onAboutToUp: {
                        barChart.minValue += 50;
                    }
                }
                ValueAxis {
                    id: barAxisY
                    min: barChart.minValue
                    max: barChart.maxValue
                    titleText: "压力/Kpa"
                    titleFont.family: "微软雅黑"
                    titleFont.pixelSize: 20
                    labelFormat: "%.0f"
                }
                BarSeries {
                    id: bars
                    //sky 显示每个条形图的数值
                    labelsVisible: true
                    labelsPosition: AbstractBarSeries.LabelsOutsideEnd

                    axisX: BarCategoryAxis {
                        titleText: "炉号"
                        titleFont.family: "微软雅黑"
                        titleFont.pixelSize: 20

                        categories: ["H110", "H111", "H112", "H113", "H114", "H115","H116","H117","H118","H119","H120" ]
                    }
                    axisY: barAxisY

                    BarSet {
                        id:bar1
                        //sky 数值的字体颜色等
                        label: "文丘里1";
                        labelFont.family: "微软雅黑"
                        labelFont.pixelSize: 20
                        labelColor: "#209fdf"
                                    values: [450, 450,450, 450, 450, 450,450,450,450,450,450]
                    }
                    BarSet {
                        id: bar2
                        label: "文丘里2";
                        labelFont.family: "微软雅黑"
                        labelFont.pixelSize: 20
                        labelColor: "#99ca53"
                                    values: [550,550,550,550,550,550,550,550,550,550,550]
                    }
                    BarSet {
                        id: bar3
                        label: "文丘里3";
                        labelFont.family: "微软雅黑"
                        labelFont.pixelSize: 20
                        labelColor: "#F6A625"
                                    values: [560,560,560,560,560,560,560,560,560,560,560]
                    }

                    BarSet {
                        id: bar4
                        label: "文丘里4";
                        labelFont.family: "微软雅黑"
                        labelFont.pixelSize: 20
                        labelColor: "#344750"
                                    values: [430,430,430,430,430,430,430,430,430,430,430]
                    }
                }
            }

        }


    }


//    Component{
//        id:venturi_component


//    }



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

    CustomDialog{
        id:fromtime_calendarDialog
        title: "选择日期"
        content:Calendar{
            id:calendar1
            anchors.fill: parent
        }
        onAccepted: {
            //globalDate = calendar1.selectedDate;
            fromDatPicker.setYear(String(calendar1.selectedDate.getFullYear()))
            fromDatPicker.setMonth(String(calendar1.selectedDate.getMonth() + 1))
            fromDatPicker.setDay(String(calendar1.selectedDate.getDate()))
        }
    }

    CustomDialog{
        id:totime_calendarDialog
        title: "选择日期"
        content:Calendar{
            id:calendar2
            anchors.fill: parent
        }
        onAccepted: {
            //globalDate = calendar2.selectedDate;
            toDatPicker.setYear(String(calendar2.selectedDate.getFullYear()))
            toDatPicker.setMonth(String(calendar2.selectedDate.getMonth() + 1))
            toDatPicker.setDay(String(calendar2.selectedDate.getDate()))
        }
    }


}
