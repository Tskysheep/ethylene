import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../Widget"
import QtCharts 2.1
import QtQuick.Dialogs 1.2
Item {
    id:root
    anchors.fill: parent

    property date fromDate: new Date(toDate.getTime() - 10*24*60*60*1000)
    property date toDate:new Date()



    property string borderColor:"#dadada"
    property string bgColor: "#f6f6f6"
    property int borderWidth:1
    property string fontColorNormal: '#333333'
    property string fontColorTip: "#3E3E3E"

    property bool showTubeInCompareLines: showTubeInOptionSwitch.checked
    property bool showTubeOutCompareLines: showTubeOutOptionSwitch.checked
    property bool showTubeCOTCompareLines: showTubeCOTOptionSwitch.checked

    property var tubeInLineStyle: Qt.SolidLine
    property var tubeOutLIneStyle: Qt.DashLine
    property var tubeCOTLineStyle: Qt.DashDotDotLine

    property var tubeInResultLines:[]
    property var tubeOutResultLines:[]
    property var tubeCOTResultLines: []

    property int currentEdittingTube:0
    property int currentFuranceNum: foranceComboBox.currentIndex


    property var colorSet:[
        "#FF0000","#FF1493","#104E8B","#080808","#00688B","#00CED1","#3A5FCD","#404040",
        "#32CD32","#27408B","#4B0082","#6B8E23","#8B0A50","#8968CD","#708090","#7A67EE",
        "#636363","#548B54","#8B6508","#CD2990","#B9D3EE","#8B8378","#8B5A2B","#8470FF",
        "#4A4A4A","#141414","#171717","#4A708B","#54FF9F","#555555","#7A378B","#8B1A1A",
        "#636363","#548B54","#8B6508","#CD2990","#B9D3EE","#8B8378","#8B5A2B","#8470FF",
        "#32CD32","#27408B","#4B0082","#6B8E23","#8B0A50","#8968CD","#708090","#7A67EE",
    ]


    //根据所设定的参数更新数据
    function refresh(){
        chartView.removeAllSeries();
        tubeInResultLines = [];
        tubeOutResultLines = [];
        tubeCOTResultLines = [];

        for(var a = 0; a<selectedTubeListModel.count; a++){

            var fromDateStr = fromDatPicker.year + "-" +
                    fromDatPicker.month + "-" +
                    fromDatPicker.day + " 00:00:00";
            var toDateStr = toDatPicker.year + "-" +
                    toDatPicker.month + "-" +
                    toDatPicker.day + " 23:59:59"

            var fDate = new Date(fromDateStr);
            var tDate = new Date(toDateStr);


            var result = server.compare_datas(currentFuranceNum, selectedTubeListModel.get(a).tubeNum, fDate, tDate);//sky:在mysqlserver.cpp 467 行返回QJsonArray 对象 jsarr

            var myAxisX = chartView.axisX(lineSeries);
            var myAxisY = chartView.axisY(lineSeries);
            var lineIn = chartView.createSeries(ChartView.SeriesTypeLine, "T"+selectedTubeListModel.get(a).tubeNum, myAxisX, myAxisY);
            var lineOut = chartView.createSeries(ChartView.SeriesTypeLine, "T"+selectedTubeListModel.get(a).tubeNum, myAxisX, myAxisY);
            var lineCOT = chartView.createSeries(ChartView.SeriesTypeLine, "T"+selectedTubeListModel.get(a).tubeNum, myAxisX, myAxisY);


            fromDate = new Date(result[0].time);
            toDate = new Date(result[result.length-1].time);
            xAxis.min = fromDate
            xAxis.max = toDate

            //append spot
            var mdatas = [];
            for(var b = 0; b<result.length; b++){

                var mdata = {};
                mdata.tubeInTemp = result[b].temp_in;
                mdata.tubeOutTemp = result[b].temp_out;
                mdata.tubeCOTTemp = -1;
                if(result[b].temp_cot) {
                    mdata.tubeCOTTemp = (result[b].temp_cot);
                }


                mdata.time = new Date(result[b].time);
                console.log(mdata.time,result[b].time);
                mdata.lineColor = selectedTubeListModel.get(a).displayColor;

                mdatas.push(mdata);

                //add spot
                lineIn.append(mdata.time,mdata.tubeInTemp);
                lineOut.append(mdata.time,mdata.tubeOutTemp);
                lineCOT.append(mdata.time,mdata.tubeCOTTemp);

                //set line color
                lineIn.color = selectedTubeListModel.get(a).displayColor;
                lineOut.color = selectedTubeListModel.get(a).displayColor;
                lineCOT.color = selectedTubeListModel.get(a).displayColor;

                //set line style
                lineOut.style = tubeOutLIneStyle;
                lineCOT.style = tubeCOTLineStyle;
                lineIn.style = tubeInLineStyle;
            }

            lineIn.visible = selectedTubeListModel.get(a).selected;
            lineOut.visible = selectedTubeListModel.get(a).selected;
            lineCOT.visible = selectedTubeListModel.get(a).selected;
            //restore lines to further control
            tubeInResultLines.push(lineIn);
            tubeOutResultLines.push(lineOut);
            tubeCOTResultLines.push(lineCOT);
        }
    }

    //selected tube list model 数据模型 存储和读取数据
    ListModel{
        id:selectedTubeListModel
    }

    ListModel{
        id:tubeListModel
        Component.onCompleted: {
            for(var a = 0; a<48; a++){
                append({
                           "tubeNum":Number(a+1),
                           "selected":false,
                           "displayColor":colorSet[a]
                       });
            }
        }
    }

    Rectangle{
        id:bg
        anchors.fill: parent
        color: bgColor
    }

    Row{
        id:mainRow
        width: parent.width-40
        height: parent.height-40
        anchors.centerIn: parent
        spacing: 20
        //left bar
        Rectangle{
            id:leftBar
            width: 200
            height: parent.height
            radius: 2
            border.width: borderWidth
            border.color: borderColor

            Column{
                anchors.fill: parent
                //title
                Item{
                    id:title
                    width: parent.width
                    height: 40
                    MouseArea{
                        anchors.fill: parent
                        onClicked: tubeSelectorDialog.open()
                    }
                    Row{
                        anchors.centerIn: parent
                        spacing: 20
                        Item{
                            width: titleText.width
                            height: 20
                            Text{
                                id:titleText
                                text: "比较炉管列表"
                                font.pixelSize: 18
                                color: fontColorNormal
                                anchors.centerIn: parent
                            }
                        }

                        Image {
                            id: addBnt
                            source: "qrc:/imgs/icons/add1.png"
                        }

                    }

                    Rectangle{
                        id:line
                        width: parent.width-20
                        height: 1
                        color: borderColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                    }
                }

                //tube list content
                ListView{
                    id:tubeListConteent
                    clip: true
                    width: parent.width
                    height: parent.height - title.height-deleteBar.height
                    model:selectedTubeListModel
                    delegate: Item{
                        width: tubeListConteent.width
                        height: 50

                        Row{
                            anchors.centerIn: parent
                            spacing: 30
                            Rectangle{
                                width: 60
                                height: 20
                                color: "#f0f0f0"
                                Rectangle{
                                    width: 20
                                    height: parent.height
                                    color: displayColor
                                }
                                Text{
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 15
                                    text: tubeNum
                                    font.pixelSize: 16
                                    color: fontColorNormal
                                }
                            }

                            Switch{
                                width: 50
                                height: 20
                                checked: selected

                                onCheckedChanged: {
                                    //控制管的显影
                                    if(showTubeInCompareLines)
                                        tubeInResultLines[index].visible = checked;

                                    if(showTubeOutCompareLines)
                                        tubeOutResultLines[index].visible = checked;

                                    if(showTubeCOTCompareLines)
                                        tubeCOTResultLines[index].visible = checked;

                                    selectedTubeListModel.setProperty(index,"selected",checked);
                                }

                                style:SwitchStyle{
                                    groove: Rectangle {
                                            implicitWidth: control.width
                                            implicitHeight: control.height
                                            radius: height/2
                                            color: control.checked ? "#12eeff" : "#c0c0c0"
                                    }
                                    handle: Item{
                                        width: height + height/3
                                        height: control.height
                                        Rectangle{
                                            anchors.centerIn: parent
                                            width: parent.width-6
                                            height: parent.height-6
                                            radius: width/2
                                        }
                                    }
                                }

                            }
                        }
                    }
                }

                //sky:2018.10.23 23:05
                //delete bar
                Item{
                    id:deleteBar
                    height: 40
                    width: parent.width
                    Rectangle{
                        width: parent.width
                        height: 1
                        color: borderColor
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: selectedTubeListModel.clear();
                    }

                    Row{
                        anchors.centerIn: parent
                        spacing: 20
                        Item{
                            width: titleText.width
                            height: 20
                            Text{
                                text: "清空列表"
                                font.pixelSize: 18
                                color: fontColorNormal
                                anchors.centerIn: parent
                            }
                        }

                        Image {
                            id: deleteBnt
                            source: "qrc:/imgs/icons/delete.png"
                        }

                    }

                }
            }
        }

        //right content
        Rectangle{
            width: parent.width-leftBar.width-20
            height: parent.height
            border.width: borderWidth
            border.color: borderColor

            Column{
                anchors.fill: parent
                z:2
                //top bar
                Item{
                    width: parent.width
                    height: 50
                    id: rightTopBar
                    clip: true
                    Rectangle{
                        width: parent.width-10
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: 1
                        color: borderColor
                        anchors.bottom: parent.bottom
                    }

                    // select row
                    Row{
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        spacing: 15

                        //text
                        Item{
                            width: 20
                            height: 20
                            anchors.verticalCenter: compareBnt.verticalCenter
                            Text{
                                anchors.centerIn: parent
                                text: "炉号"
                                font.pixelSize: 15
                                font.family: "微软雅黑"
                                color: "#3E3E3E"
                            }
                        }

                        //foruance num selector
                        ForanceNumComboBox{
                            id:foranceComboBox
                            anchors.verticalCenter: compareBnt.verticalCenter

                        }


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
                                refresh();
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

                //content
                Item{
                    width: parent.width
                    height: parent.height - rightTopBar.height

                    //Chart
                    ChartView{
                        id:chartView
                        legend.visible: false
                        width: parent.width - 80
                        height: parent.height - 80
                        anchors.centerIn: parent
                        antialiasing: true

                        property int maxDisplayTemp: 1100
                        property int minDisplayTemp: 700
                        Behavior on maxDisplayTemp{
                            PropertyAnimation{
                                properties: "maxDisplayTemp"
                                easing.type: Easing.OutQuint
                                duration: 300
                            }
                        }
                        Behavior on minDisplayTemp{
                            PropertyAnimation{
                                properties: "minDisplayTemp"
                                easing.type: Easing.OutQuint
                                duration: 300
                            }
                        }

                        UpDownBox{
                            id:maxUpdownBox
                            anchors.top: chartView.top
                            anchors.topMargin: 15
                            upEnable: chartView.maxDisplayTemp<1500
                            downEnable: chartView.minDisplayTemp<chartView.maxDisplayTemp
                            onAboutToDown: {
                                chartView.maxDisplayTemp -=50;
                            }
                            onAboutToUp: {
                                chartView.maxDisplayTemp += 50;
                            }
                        }

                        UpDownBox{
                            id:minUpdownBox
                            anchors.bottom: chartView.bottom
                            anchors.bottomMargin: 15
                            upEnable: chartView.minDisplayTemp<chartView.maxDisplayTemp
                            downEnable: chartView.minDisplayTemp>0
                            onAboutToDown: {
                                chartView.minDisplayTemp -=50;
                            }
                            onAboutToUp: {
                                chartView.minDisplayTemp += 50;
                            }
                        }

                        ValueAxis{
                            id:yAxis
                            min: chartView.minDisplayTemp
                            max: chartView.maxDisplayTemp
                            tickCount: 12
                            labelFormat: "%.0f"
                            titleText: "温度/℃"
                            titleFont.family: "微软雅黑"
                            titleFont.pixelSize: 20

                        }
                        DateTimeAxis{
                            id:xAxis
                            min:fromDate
                            max: toDate
                            format: "yy/MM/dd"
                            titleText: "时间：年/月/日"
                            titleFont.family: "微软雅黑"
                            titleFont.pixelSize: 20
                        }
                        LineSeries{
                            id:lineSeries
                            axisX: xAxis
                            axisY: yAxis
                        }
                    }

                    //option selector
                    Column{
                        anchors.right: parent.right
                        y:5
                        spacing: 5
                        id: optionsCol

                        //show tube in option
                        Item{
                            width: 230
                            height : 20
                            Row{
                                id:showTubeInOPtionRow
                                height: 20
                                spacing: 20
                                Item{
                                    width: 150
                                    height: 20
                                    Text{
                                        anchors.centerIn: parent
                                        text: "显示入管温度曲线"
                                        font.pixelSize: 15
                                        font.family: "微软雅黑"
                                        color: fontColorTip
                                    }
                                }

                                Switch{
                                    id:showTubeInOptionSwitch
                                    width: 50
                                    height: 20
                                    checked: true
                                    onCheckedChanged: {
                                        for(var a in tubeInResultLines){
                                            if(selectedTubeListModel.get(a).selected)
                                                tubeInResultLines[a].visible = checked;
                                        }
                                    }

                                    style: SwitchStyle{
                                        groove: Rectangle{
                                            width: control.width
                                            height: control.height
                                            radius: height/2
                                            color: control.checked? "#12eeff":"#999999"
                                        }
                                        handle: Item{
                                            width: height + height/3
                                            height: control.height
                                            Rectangle{
                                                anchors.centerIn: parent
                                                width: parent.width-6
                                                height: parent.height-6
                                                radius: height/2
                                            }
                                        }
                                    }
                                }

                            }
                        }

                        //show tube out option
                        Item{
                            width: 230
                            height : 20
                            Row{
                                id:showTubeOutOPtionRow
                                height: 20
                                spacing: 20
                                Item{
                                    width: 150
                                    height: 20
                                    Text{
                                        anchors.centerIn: parent
                                        text: "显示出管温度曲线"
                                        font.pixelSize: 15
                                        font.family: "微软雅黑"
                                        color: fontColorTip
                                    }
                                }

                                Switch{
                                    id:showTubeOutOptionSwitch
                                    width: 50
                                    height: 20
                                    checked: true
                                    onCheckedChanged: {
                                        for(var a in tubeOutResultLines)
                                            if(selectedTubeListModel.get(a).selected)
                                                tubeOutResultLines[a].visible = checked;
                                    }

                                    style: SwitchStyle{
                                        groove: Rectangle{
                                            width: control.width
                                            height: control.height
                                            radius: height/2
                                            color: control.checked? "#12eeff":"#999999"
                                        }
                                        handle: Item{
                                            width: height + height/3
                                            height: control.height
                                            Rectangle{
                                                anchors.centerIn: parent
                                                width: parent.width-6
                                                height: parent.height-6
                                                radius: height/2
                                            }
                                        }
                                    }
                                }

                            }
                        }

                        //show tube cot option
                        Item{
                            width: 230
                            height : 20
                            Row{
                                id:showTubeCOTOPtionRow
                                height: 20
                                spacing: 20
                                Item{
                                    width: 150
                                    height: 20
                                    Text{
                                        anchors.centerIn: parent
                                        text: "显示COT温度曲线"
                                        font.pixelSize: 15
                                        font.family: "微软雅黑"
                                        color: fontColorTip
                                    }
                                }

                                Switch{
                                    id:showTubeCOTOptionSwitch
                                    width: 50
                                    height: 20
                                    checked: true
                                    onCheckedChanged: {
                                        for(var a in tubeCOTResultLines)
                                            if(selectedTubeListModel.get(a).selected)
                                                tubeCOTResultLines[a].visible = checked;
                                    }

                                    style: SwitchStyle{
                                        groove: Rectangle{
                                            width: control.width
                                            height: control.height
                                            radius: height/2
                                            color: control.checked? "#12eeff":"#999999"
                                        }
                                        handle: Item{
                                            width: height + height/3
                                            height: control.height
                                            Rectangle{
                                                anchors.centerIn: parent
                                                width: parent.width-6
                                                height: parent.height-6
                                                radius: height/2
                                            }
                                        }
                                    }
                                }

                            }
                        }

                    }

                    //line style tip
                    Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                        y:40
                        spacing: 10

                        Text{
                            text: "       入管曲线:"
                            font.pixelSize: 17
                            font.family: "微软雅黑"
                            color: "#3E3E3E"
                        }
                        Image {
                            source: "qrc:/imgs/icons/solid_line.png"
                            opacity: 0.6
                        }

                        Text{
                            text: "       出管曲线:"
                            font.pixelSize: 17
                            font.family: "微软雅黑"
                            color: "#3E3E3E"
                        }
                        Image {
                            source: "qrc:/imgs/icons/dash_line.png"
                            opacity: 0.6
                        }

                        Text{
                            text: "       COT管曲线:"
                            font.pixelSize: 17
                            font.family: "微软雅黑"
                            color: "#3E3E3E"
                        }
                        Image {
                            source: "qrc:/imgs/icons/dash_dot_dot_line.png"
                            opacity: 0.6
                        }
                    }
                }
            }
        }
    }

    //dilaog
    CustomDialog{
        id: tubeSelectorDialog
        title: "管列表筛选框"
        content: Item{
            width: 500
            height: 500
            ListView{
                anchors.fill: parent
                id:tubeChosserListView
                model: tubeListModel
                clip: true
                delegate: Item{
                    width: tubeChosserListView.width
                    height: 80

                    Row{
                        anchors.centerIn: parent
                        spacing: 30
                        RadioButton{
                            checked: selected
                            onCheckedChanged: tubeListModel.setProperty(index,"selected",checked);
                            anchors.verticalCenter: parent.verticalCenter
                            style: RadioButtonStyle {
                                      indicator: Rectangle {
                                              implicitWidth: 40
                                              implicitHeight: 40
                                              radius: 20
                                              border.color: control.activeFocus ? "darkblue" : "gray"
                                              border.width: 6
                                              Rectangle {
                                                  anchors.fill: parent
                                                  visible: control.checked
                                                  color: "#555"
                                                  radius: 20
                                                  anchors.margins: 6
                                              }
                                      }
                                  }

                        }

                        Text{
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 16
                            text: Number(index+1)+"号管"
                        }

                        Rectangle{
                            width: 200
                            height: 5
                            color: displayColor
                            anchors.verticalCenter: parent.verticalCenter
                            border.width: 1
                            border.color: "#cfcfcf"
                        }

                        Image {
                            source: "qrc:/imgs/icons/modify.png"
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    currentEdittingTube = index;
                                    colorDialog.open();
                                }
                            }
                        }
                    }

                    Rectangle{
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width-100
                        height: 1
                        color: borderColor
                        opacity: 0.5
                    }
                }
            }
        }
        onAccepted: {
            selectedTubeListModel.clear();

            for(var a = 0; a<tubeListModel.count; a++){
                if(tubeListModel.get(a).selected){
                    selectedTubeListModel.append({
                                                     "tubeNum":tubeListModel.get(a).tubeNum,
                                                     "displayColor":tubeListModel.get(a).displayColor,
                                                     "selected":true
                                                 });
                }
            }
        }
    }

    ColorDialog{
        id:colorDialog

        onAccepted: {
            tubeListModel.setProperty(root.currentEdittingTube,"displayColor",color.toString());
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
