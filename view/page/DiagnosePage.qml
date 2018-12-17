import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../Widget"
import QtCharts 2.1
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
Item {
    id:root
    anchors.fill: parent
    property date fromDate: new Date("2016-01-01 00:00:00")
    property date toDate:new Date("2016-01-20 00:00:00")

    property string borderColor:"#dadada"
    property string bgColor: "#f6f6f6"
    property int borderWidth:1
    property string fontColorNormal: '#333333'
    property string fontColorTip: "#999999"

    property var tubeInLineStyle: Qt.SolidLine
    property var tubeOutLIneStyle: Qt.DashLine
    property var tubeCOTLineStyle: Qt.DashDotDotLine

    property var tubeInResultLines:[]
    property var tubeOutResultLines:[]
    property var tubeCOTResultLines: []
    property var diagnoseResultLines: []
    property var pressureResultLines: []

    property int currentEdittingTube:0
    property int currentFuranceNum: 5

    property var colorSet:[
        "#FF0000","#FF1493","#104E8B","#080808","#00688B","#00CED1","#3A5FCD","#404040",
        "#32CD32","#27408B","#4B0082","#6B8E23","#8B0A50","#8968CD","#708090","#7A67EE",
        "#636363","#548B54","#8B6508","#CD2990","#B9D3EE","#8B8378","#8B5A2B","#8470FF",
        "#4A4A4A","#141414","#171717","#4A708B","#54FF9F","#555555","#7A378B","#8B1A1A",
        "#636363","#548B54","#8B6508","#CD2990","#B9D3EE","#8B8378","#8B5A2B","#8470FF",
        "#32CD32","#27408B","#4B0082","#6B8E23","#8B0A50","#8968CD","#708090","#7A67EE",
    ]
    //更新每条折线的数据
    function refresh(){

        // remove all lines
        tubeChartView.removeAllSeries();
        analysisChartView.removeAllSeries();
        pressureChartView.removeAllSeries();

        tubeInResultLines = [];
        tubeOutResultLines = [];
        tubeCOTResultLines = [];
        diagnoseResultLines = [];
        pressureResultLines = [];

        for(var a = 0; a<selectedTubeListModel.count; a++){

            var fromDateStr = fromDatPicker.year + "-" +
                    fromDatPicker.month + "-" +
                    fromDatPicker.day + " 00:00:00";
            var toDateStr = toDatPicker.year + "-" +
                    toDatPicker.month + "-" +
                    toDatPicker.day + " 23:59:59"

            var fDate = new Date(fromDateStr);
            var tDate = new Date(toDateStr);

            console.log("date:",fDate,",",tDate);

            var result = server.compare_datas(currentFuranceNum, selectedTubeListModel.get(a).tubeNum, fDate, tDate);
            var resultPressue = server.pressureData(currentFuranceNum, selectedTubeListModel.get(a).tubeNum, fDate, tDate);
//            console.log("*********************",resultPressue.length);
            console.log("result:",result.length);

            var axisXDiagnose = analysisChartView.axisX(lineSeries);
            var axisYDiagnose = analysisChartView.axisY(lineSeries);

            var myAxisX = tubeChartView.axisX(lineSeries1);
            var myAxisY = tubeChartView.axisY(lineSeries1);

            var axisXPressure = pressureChartView.axisX(lineSeries2);
            var axisYPressure = pressureChartView.axisY(lineSeries2);

            var lineIn = tubeChartView.createSeries(ChartView.SeriesTypeLine, "T"+selectedTubeListModel.get(a).tubeNum, myAxisX, myAxisY);
            var lineOut = tubeChartView.createSeries(ChartView.SeriesTypeLine, "T"+selectedTubeListModel.get(a).tubeNum, myAxisX, myAxisY);
            var lineCOT = tubeChartView.createSeries(ChartView.SeriesTypeLine, "T"+selectedTubeListModel.get(a).tubeNum, myAxisX, myAxisY);

            var lineDiagnose = analysisChartView.createSeries(ChartView.SeriesTypeLine,
                                                              "T"+selectedTubeListModel.get(a).tubeNum,
                                                              axisXDiagnose,
                                                              axisYDiagnose);
            var linePressures = pressureChartView.createSeries(ChartView.SeriesTypeLine,
                                                           "T"+selectedTubeListModel.get(a).tubeNum,
                                                           axisXPressure, axisYPressure);

            fromDate = new Date(result[0].time);
            toDate = new Date(result[result.length-1].time);

            for(var b = 0; b<result.length; b++){

                var mdata = {};
                mdata.tubeInTemp = result[b].temp_in;
                mdata.tubeOutTemp = result[b].temp_out;
                mdata.tubeCOTTemp = -1;
                if(result[b].temp_cot){
                    mdata.tubeCOTTemp = result[b].temp_cot;
                }


                mdata.time = new Date(result[b].time);
                console.log(mdata.time,result[b].time);
                mdata.lineColor = selectedTubeListModel.get(a).displayColor;

                //add spot
                lineIn.append(mdata.time,mdata.tubeInTemp);
                lineOut.append(mdata.time,mdata.tubeOutTemp);
                lineCOT.append(mdata.time,mdata.tubeCOTTemp);

                lineDiagnose.append(mdata.time, (mdata.tubeOutTemp/mdata.tubeInTemp));

                //set line color
                lineIn.color = selectedTubeListModel.get(a).displayColor;
                lineOut.color = selectedTubeListModel.get(a).displayColor;
                lineCOT.color = selectedTubeListModel.get(a).displayColor;

                lineDiagnose.color = selectedTubeListModel.get(a).displayColor;

                //set line style
                lineOut.style = tubeOutLIneStyle;
                lineCOT.style = tubeCOTLineStyle;
                lineIn.style = tubeInLineStyle;
            }

            for(var c = 0; c< resultPressue.length; c++){
                var pdata = {};
                pdata.time = new Date(resultPressue[c].time);
                pdata.value = resultPressue[c].value;
                linePressures.append(pdata.time,pdata.value);
                linePressures.color = selectedTubeListModel.get(a).displayColor;
                console.log(pdata.time,pdata.value);
            }

            //restore lines to further control
            tubeInResultLines.push(lineIn);
            tubeOutResultLines.push(lineOut);
            tubeCOTResultLines.push(lineCOT);

            diagnoseResultLines.push(lineDiagnose)

            pressureResultLines.push(linePressures)
        }
    }


    //selected tube list model 数据模型存储和提供数据
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
                                    //决定折线显隐
                                    if(tubeInResultLines[index])
                                        tubeInResultLines[index].visible = checked;

                                    if(tubeOutResultLines[index])
                                        tubeOutResultLines[index].visible = checked;

                                    if(tubeCOTResultLines[index])
                                        tubeCOTResultLines[index].visible = checked;

                                    if(diagnoseResultLines[index])
                                        diagnoseResultLines[index].visible = checked;

                                    if(pressureResultLines[index])
                                        pressureResultLines[index].visible = checked;

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
        Item{
            width: parent.width-leftBar.width-20
            height: parent.height

            Column{
                anchors.fill: parent
                z:2
                spacing: 10
                //top bar
                Rectangle{
                    width: parent.width
                    height: 50
                    id: rightTopBar
                    border.width: 1
                    border.color: borderColor

                    // select row
                    Row{
                        anchors.centerIn: parent
                        spacing: 30
                        //from date picker
                        DatePicker{
                            id:fromDatPicker
                            anchors.verticalCenter: analisisBnt.verticalCenter
                        }

                        //text
                        Item{
                            width: 20
                            height: 20
                            anchors.verticalCenter: analisisBnt.verticalCenter
                            Text{
                                anchors.centerIn: parent
                                text: "到"
                                font.pixelSize: 18
                                color: "#12eeaa"
                            }
                        }

                        //to date picker
                        DatePicker{
                            id:toDatPicker
                            anchors.verticalCenter: analisisBnt.verticalCenter
                        }

                        //text
                        Item{
                            width: 20
                            height: 20
                            anchors.verticalCenter: analisisBnt.verticalCenter
                            Text{
                                anchors.centerIn: parent
                                text: "炉号"
                                font.pixelSize: 18
                                color: "#12eeaa"
                            }
                        }

                        //foruance num selector
                        ForanceNumComboBox{
                            id:foranceComboBox
                        }

                        //compare button
                        RoundIconButton{
                            text: "开始分析"
                            width: 120
                            height: 35
                            imgSrc: "qrc:/imgs/icons/bnt_comparer.png"
                            bgColor: "#12ccef"
                            id:analisisBnt
                            onBngClicked: {
                                refresh();
                            }
                        }

                        RoundIconButton{
                            imgSrc: "qrc:/imgs/icons/picture.png"
                            width: 120
                            height: 35
                            text: "导出图片"
                            bgColor: "#ff7700"
                            onBngClicked: {
                                chartViewsItem.grabToImage(function(result){
                                    var url = server.getSaveFilePath();
                                    result.saveToFile(url);
                                });
                            }
                        }
                    }

                }

                Item{
                    id:chartsItem
                    width: parent.width
                    height: parent.height - rightTopBar.height - 10

                    ScrollView{
                        anchors.fill: parent

                        //Analysis
                        Item{
                            width: chartsItem.width-80
                            x:40
                            height: chartsCol.height
                            id: chartViewsItem

                            Glow{
                                anchors.fill: chartsCol
                                color: "#10000000"
                                spread: 0.1
                                radius: 5
                                source: chartsCol
                                transparentBorder: true
                                fast: true
                                cached: true
                                samples: 15

                            }

                            Column{
                                width: parent.width
                                id:chartsCol
                                spacing: 20

                                ChartView{
                                    id:analysisChartView
                                    width: parent.width
                                    height: 500
                                    title: "结焦趋势"
                                    titleColor: fontColorNormal
                                    titleFont.pixelSize: 20
                                    antialiasing: true
                                    legend.visible: false
                                    property var maxValue: 2
                                    property var minValue: 0

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
                                        anchors.top: analysisChartView.top
                                        anchors.topMargin: 15
                                        upEnable: analysisChartView.maxValue<5
                                        downEnable: analysisChartView.minValue<analysisChartView.maxValue
                                        onAboutToDown: {
                                            analysisChartView.maxValue -=0.2;
                                        }
                                        onAboutToUp: {
                                            analysisChartView.maxValue += 0.2;
                                        }
                                    }

                                    UpDownBox{
                                        anchors.bottom: analysisChartView.bottom
                                        anchors.bottomMargin: 15
                                        upEnable: analysisChartView.minValue<analysisChartView.maxValue
                                        downEnable: analysisChartView.minValue>0
                                        onAboutToDown: {
                                            analysisChartView.minValue -=0.2;
                                        }
                                        onAboutToUp: {
                                            analysisChartView.minValue += 0.2;
                                        }
                                    }

                                    ValueAxis{
                                        id:yAxis
                                        min: analysisChartView.minValue
                                        max: analysisChartView.maxValue
                                        tickCount: 10
//                                        labelFormat: "%0.00f"
                                    }
                                    DateTimeAxis{
                                        id:xAxis
                                        min:fromDate
                                        max: toDate
                                        format: "yy/MM/dd"
                                    }
                                    LineSeries{
                                        id:lineSeries
                                        axisX: xAxis
                                        axisY: yAxis
                                    }
                                }

                                ChartView{
                                    id:tubeChartView
                                    width: parent.width
                                    height: 600
                                    title: "温度曲线趋势"
                                    titleFont.pixelSize: 20
                                    titleColor: fontColorNormal
                                    antialiasing: true
                                    legend.visible: false

                                    property var maxValue: 1200
                                    property var minValue: 700

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
                                        anchors.top: tubeChartView.top
                                        anchors.topMargin: 15
                                        upEnable: tubeChartView.maxValue<1500
                                        downEnable: tubeChartView.minValue<tubeChartView.maxValue
                                        onAboutToDown: {
                                            tubeChartView.maxValue -=50;
                                        }
                                        onAboutToUp: {
                                            tubeChartView.maxValue += 50;
                                        }
                                    }

                                    UpDownBox{
                                        anchors.bottom: tubeChartView.bottom
                                        anchors.bottomMargin: 15
                                        upEnable: tubeChartView.minValue<tubeChartView.maxValue
                                        downEnable: tubeChartView.minValue>0
                                        onAboutToDown: {
                                            tubeChartView.minValue -=50;
                                        }
                                        onAboutToUp: {
                                            tubeChartView.minValue += 50;
                                        }
                                    }

                                    ValueAxis{
                                        id:yAxis1
                                        min: tubeChartView.minValue
                                        max: tubeChartView.maxValue
                                        tickCount: 10
                                        labelFormat: "%.0f"
                                    }
                                    DateTimeAxis{
                                        id:xAxis1
                                        min:fromDate
                                        max: toDate
                                        format: "yy/MM/dd"
                                    }
                                    LineSeries{
                                        id:lineSeries1
                                        axisX: xAxis1
                                        axisY: yAxis1
                                    }
                                }

                                ChartView{
                                    id:pressureChartView
                                    width: parent.width
                                    height: 500
                                    title: "压力趋势"
                                    titleFont.pixelSize: 20
                                    titleColor: fontColorNormal
                                    antialiasing: true
                                    legend.visible: false

                                    property var maxValue: 1500
                                    property var minValue: 200

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
                                        anchors.top: pressureChartView.top
                                        anchors.topMargin: 15
                                        upEnable: pressureChartView.maxValue<3000
                                        downEnable: pressureChartView.minValue<pressureChartView.maxValue
                                        onAboutToDown: {
                                            pressureChartView.maxValue -=50;
                                        }
                                        onAboutToUp: {
                                            pressureChartView.maxValue += 50;
                                        }
                                    }

                                    UpDownBox{
                                        anchors.bottom: pressureChartView.bottom
                                        anchors.bottomMargin: 15
                                        upEnable: pressureChartView.minValue<pressureChartView.maxValue
                                        downEnable: pressureChartView.minValue>0
                                        onAboutToDown: {
                                            pressureChartView.minValue -=50;
                                        }
                                        onAboutToUp: {
                                            pressureChartView.minValue += 50;
                                        }
                                    }


                                    ValueAxis{
                                        id:yAxis2
                                        min: pressureChartView.minValue
                                        max: pressureChartView.maxValue
                                        tickCount: 10
                                        labelFormat: "%.0f"
                                    }
                                    DateTimeAxis{
                                        id:xAxis2
                                        min:fromDate
                                        max: toDate
                                        format: "yy/MM/dd"
                                    }
                                    LineSeries{
                                        id:lineSeries2
                                        axisX: xAxis2
                                        axisY: yAxis2
                                    }
                                }
                            }
                        }
                    }
                }



            }
        }
    }

    //dilaog管列表筛选框
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
}
