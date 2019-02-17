import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../Widget"
import QtCharts 2.1
import QtQuick.Dialogs 1.2
Item {
    id:root
    anchors.fill: parent
    property date fromDate: new Date("2016-01-01 00:00:00")
    property date toDate:new Date("2016-01-20 00:00:00")

    property var  analyzeResult: []
    property var searchDatas: []

    property string borderColor:"#dadada"
    property string bgColor: "#f6f6f6"
    property int borderWidth:1
    property string fontColorNormal: '#333333'
    property string fontColorTip: "#3E3E3E"

    //property bool showTubeInCompareLines: showTubeInOptionSwitch.checked
    property bool showAI_tube_in_diagnoseCompareLines: showAI_tube_in_diagnoseOptionSwitch.checked
    property bool showAI_tube_out_diagnoseCompareLines: showAI_tube_out_diagnoseOptionSwitch.checked
    property bool showTMT_div_COT_modelCompareLines: showTMT_div_COT_modelOptionSwitch.checked

    property var ai_diagnose_in_line_style: Qt.DashLine
    property var ai_diagnose_out_line_style: Qt.SolidLine
    property var tmt_div_cot_model_line_style: Qt.DashDotLine
    //property var tubeCOTLineStyle: Qt.DashDotDotLine

    property var ai_diagnose_inResultLines:[]
    property var ai_diagnose_outResultLines:[]
    property var tmt_div_COT_modelResultLines:[]
    property var tubeCOTResultLines: []

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

//            var myAxisX = chartView.axisX(lineSeries);
//            var myAxisY = chartView.axisY(lineSeries);
            var lineIn = chartView.createSeries(ChartView.SeriesTypeLine, "T"+selectedTubeListModel.get(a).tubeNum, xAxis, yAxis);
            var lineOut = chartView.createSeries(ChartView.SeriesTypeLine, "T"+selectedTubeListModel.get(a).tubeNum, xAxis, yAxis);
            var lineCOT = chartView.createSeries(ChartView.SeriesTypeLine, "T"+selectedTubeListModel.get(a).tubeNum, xAxis, yAxis);


            fromDate = new Date(result[0].time);
            toDate = new Date(result[result.length-1].time);

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

    function refresh2(){
        searchDatas = []
        ai_diagnose_inResultLines = []
        ai_diagnose_outResultLines = []
        tmt_div_COT_modelResultLines = []

        var fromDateStr = fromDatPicker.year + "-" +
                fromDatPicker.month + "-" +
                fromDatPicker.day + " 00:00:00";
        var toDateStr = toDatPicker.year + "-" +
                toDatPicker.month + "-" +
                toDatPicker.day + " 23:59:59"

        var fDate = new Date(fromDateStr);
        var tDate = new Date(toDateStr);

        var result = server.diagnoseData(currentFuranceNum,acrossSection[currentFuranceNum],fDate,tDate)
        //console.log(result)
        for(var a = 0; a < result.tubeOutData[0].data.length; a++){
            var sdata = {}
            sdata.TMTOUT = [] //出管温度
            sdata.TMTIN = [] //入管温度
            sdata.ACSSP = [] //出管时间查询的横跨段压力 across setcion pressure
            sdata.ACSSP2 = [] //入管时间查询的横跨段压力
            sdata.COT = [] //出管cot
            sdata.VTIP = [] //文丘里压力 venturi press
            sdata.Date = ""
            for(var b = 0; b < 48; b++){
                sdata.TMTOUT.push(result.tubeOutData[b].data[a].temp)
                sdata.TMTIN.push(result.tubeInData[b].data[a].temp)
                //sdata.ACSSP.push(result.tubeCotData[b].data[a].temp)
                //sdata.ACSSP2.push(result.tubeCotData2[b].data[a].temp)
                //sdata.COT.push(result.tubeDiagnoseCotData[b].data[a].temp)
                sdata.COT.push(845)
                sdata.ACSSP.push(200)
                sdata.ACSSP2.push(199)

            }
            sdata.Date = result.tubeOutData[0].data[a].time.split(" ")[0]
            searchDatas.push(sdata)
        }

        //文丘里
        for(var c = 0; c < searchDatas.length; c++){
             var obj = server.diagnoseAccessPressureData(5,searchDatas[c].Date);
            for(var d = 0; d < 48; d++){
                if(d >=0 && d <= 11){
                    searchDatas[c].VTIP.push(obj.value1)
                }else if(d >= 12 && d <= 23){
                    searchDatas[c].VTIP.push(obj.value2)
                }else if(d >= 24 && d <= 35){
                    searchDatas[c].VTIP.push(obj.value3)
                }else{
                    searchDatas[c].VTIP.push(obj.value4)
                }
            }
        }

        console.log(searchDatas[0].TMTOUT)
        console.log(searchDatas[0].TMTIN)
        //console.log(searchDatas[0].VTIP)
        //console.log(searchDatas[0].ACSSP)
        //console.log(searchDatas[0].ACSSP2)

//        console.log(searchDatas[0].Date)
        //compute_apr(searchDatas[0].VTIP,searchDatas[0].ACSSP)


        //将所有数据取出
        var venturis = []
        var out_acrosssections = []
        var in_acrosssections = []
        var tmtouts = []
        var tmtins = []
        for(var e = 0; e < searchDatas.length; e++){
            for( var f = 0; f < searchDatas[e].TMTOUT.length; f++){
                venturis.push(searchDatas[e].VTIP[f])

                out_acrosssections.push(searchDatas[e].ACSSP[f])
                in_acrosssections.push(searchDatas[e].ACSSP2[f])

                tmtouts.push(searchDatas[e].TMTOUT[f])
                tmtins.push(searchDatas[e].TMTIN[f])
            }
        }

        //计算绝压比 apr
        var out_aprs = compute_apr(venturis,out_acrosssections)
        var in_aprs = compute_apr(venturis,in_acrosssections)

        //console.log("out",out_aprs)
        //console.log("in",in_aprs)


        var all_tmt = [];
        var all_apr = []

        //前一半出管，后一半入管
        for(var g = 0; g < tmtouts.length; g++){
            //tmt
            all_tmt[g] = tmtouts[g]
            all_tmt[tmtouts.length + g] = tmtins[g]

            //apr
            all_apr[g] = out_aprs[g]
            all_apr[tmtouts.length + g] = in_aprs[g]
        }

        //console.log("all_tmt",all_tmt)
        //console.log("all_apr",all_apr)

        //调用结焦诊断算法
        analyze_dialog.tip = "正在分析中，请稍等...."
        analyze_dialog.visible = true;
        utils.test(all_tmt,all_apr);
    }

    Connections{
        target: utils
        onFinish:{
            analyze_dialog.tip = "分析完成！"
            analyze_dialog.visible = false
            analyzeResult = utils.getResult();

            for(var a = 0; a < searchDatas.length; a++){
                var out_result = [];
                var in_result = [];
                var tmt_div_cot_result = [];
                var out_sum = 0;
                var in_sum = 0;
                for(var b = 0; b < 48; b++){
                    out_result.push(analyzeResult[48*a + b])
                    out_sum += Number(analyzeResult[48*a + b])

                    in_result.push(analyzeResult[48*searchDatas.length + (48*a+b)])
                    in_sum += Number(analyzeResult[48*searchDatas.length + (48*a+b)])

                    tmt_div_cot_result.push(searchDatas[a].TMTOUT[b]/searchDatas[a].COT[b])
                }
                searchDatas[a].OUTRS = out_result
                searchDatas[a].OUTAVG = (out_sum/48).toFixed(0)
                //console.log(a,out_sum/48)
                searchDatas[a].INRS = in_result
                searchDatas[a].INAVG = (in_sum/48).toFixed(0)
                //console.log(a,in_sum/48)

                searchDatas[a].TMTDIVCOTRS = tmt_div_cot_result
            }

            console.log("分析结果",analyzeResult)
            if(analyzeResult[1] === "Some") return;


            chartView.removeAllSeries()
            for(var c = 0; c < selectedTubeListModel.count; c++){
                //获取xy轴
                var myAxisx = chartView.axisX(lineSeries)
                var myAxisy = chartView.axisY(lineSeries)
                //构建折线
                var AI_diagnose_in_line = chartView.createSeries(ChartView.SeriesTypeLine,"T"+selectedTubeListModel.get(c).tubeNum,myAxisx,myAxisy)
                var AI_diagnose_out_line = chartView.createSeries(ChartView.SeriesTypeLine,"T"+selectedTubeListModel.get(c).tubeNum,myAxisx,myAxisy)
                var tmt_div_cot_model_line = chartView.createSeries(ChartView.SeriesTypeLine,"T"+selectedTubeListModel.get(c).tubeNum,myAxisx,myAxisy)
                //x 轴最大，最小值
                var dtFrom = new Date(searchDatas[searchDatas.length - 1].Date)
                dtFrom.setHours(0)
                dtFrom.setMinutes(0)
                dtFrom.setSeconds(0)
                var dtTo = new Date(searchDatas[0].Date)
                dtTo.setHours(0)
                dtTo.setMinutes(0)
                dtTo.setSeconds(0)
                fromDate = dtFrom
                toDate = dtTo
                //为折线添加数据
                for(var d = 0; d < searchDatas.length; d++){
                    var dtTime = new Date(searchDatas[d].Date)
                    dtTime.setHours(0)
                    dtTime.setMinutes(0)
                    dtTime.setSeconds(0)
                    //AI_diagnose_in_line.append(dtTime,1)
                    AI_diagnose_in_line.append(dtTime,searchDatas[d].OUTRS[selectedTubeListModel.get(c).tubeNum -1])
                    AI_diagnose_in_line.color = selectedTubeListModel.get(c).displayColor
                    AI_diagnose_in_line.style = ai_diagnose_in_line_style

                    AI_diagnose_out_line.append(dtTime,searchDatas[d].OUTRS[selectedTubeListModel.get(c).tubeNum -1])
                    AI_diagnose_out_line.color = selectedTubeListModel.get(c).displayColor
                    AI_diagnose_out_line.style = ai_diagnose_out_line_style

                    tmt_div_cot_model_line.append(dtTime,searchDatas[d].TMTDIVCOTRS[selectedTubeListModel.get(c).tubeNum -1])
                    tmt_div_cot_model_line.color = selectedTubeListModel.get(c).displayColor
                    tmt_div_cot_model_line.style = tmt_div_cot_model_line_style


                }

                ai_diagnose_inResultLines.push(AI_diagnose_in_line)
                ai_diagnose_outResultLines.push(AI_diagnose_out_line)
                tmt_div_COT_modelResultLines.push(tmt_div_cot_model_line)


            }

            //xAxis.min = new Date(searchDatas[searchDatas.length - 1].Date)
            //xAxis.max = new Date(searchDatas[0].Date)
/*            xAxis.min = fromDate
            xAxis.max = toDate
            lineSeries.clear()
            scatterSeries.clear()

            for(var c = 0; c < searchDatas.length; c++){
                lineSeries.append(new Date(searchDatas[c].Date),searchDatas[c].OUTAVG)
                scatterSeries.append(new Date(searchDatas[c].Date),searchDatas[c].OUTAVG)

                console.log(searchDatas[c].Date)
                console.log(searchDatas[c].OUTRS)
                console.log(searchDatas[c].INRS)
                console.log(searchDatas[c].OUTAVG)
                console.log(searchDatas[c].INAVG)

            }
*/
        }
    }


    function compute_apr(venturis,acrosssections){
        //console.log(venturis,acrosssections)
        var aprs = []
        for(var a = 0; a < venturis.length; a++){
            //绝压比 = （文丘里压力+大气压（101kpa））/(横跨段压力+大气压（101kpa）)
            //apr = (venturi+101)/(acrosssection+101)
            aprs.push(((venturis[a]+101)/(acrosssections[a]+101)).toFixed(2))
        }


/*        console.log(aprs.length)
        for(var b = 0; b < aprs.length; b++){
            console.log(b+1,aprs[b])
        }
*/

        return aprs;
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

                                    if(showAI_tube_in_diagnoseCompareLines){
                                        if(ai_diagnose_inResultLines.length > 0){
                                            ai_diagnose_inResultLines[index].visible = checked;

                                        }
                                    }

                                    if(showAI_tube_out_diagnoseCompareLines){
                                        if(ai_diagnose_outResultLines.length > 0){
                                            ai_diagnose_outResultLines[index].visible = checked
                                        }
                                    }

                                    if(showTMT_div_COT_modelCompareLines){
                                        if(tmt_div_COT_modelResultLines.length > 0){
                                            tmt_div_COT_modelResultLines[index].visible = checked
                                        }
                                    }

//                                    if(showTubeOutCompareLines)
//                                        tubeOutResultLines[index].visible = checked;

//                                    if(showTubeCOTCompareLines)
//                                        tubeCOTResultLines[index].visible = checked;

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


                        //compare button
                        RoundIconButton{
                            id: compareBnt
                            text: "开始分析"
                            width: 120
                            height: 35
                            textSize: 17
                            imgSrc: "qrc:/imgs/icons/bnt_comparer.png"
                            bgColor: "#5596E4"

                            onBngClicked: {
                                refresh2();
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
//                        antialiasing: true

                        property int maxDisplayTemp: 4
                        property int minDisplayTemp: -1
//                        Behavior on maxDisplayTemp{
//                            PropertyAnimation{
//                                properties: "maxDisplayTemp"
//                                easing.type: Easing.OutQuint
//                                duration: 300
//                            }
//                        }
//                        Behavior on minDisplayTemp{
//                            PropertyAnimation{
//                                properties: "minDisplayTemp"
//                                easing.type: Easing.OutQuint
//                                duration: 300
//                            }
//                        }

//                        UpDownBox{
//                            id:maxUpdownBox
//                            anchors.top: chartView.top
//                            anchors.topMargin: 15
//                            upEnable: chartView.maxDisplayTemp<1500
//                            downEnable: chartView.minDisplayTemp<chartView.maxDisplayTemp
//                            onAboutToDown: {
//                                chartView.maxDisplayTemp -=50;
//                            }
//                            onAboutToUp: {
//                                chartView.maxDisplayTemp += 50;
//                            }
//                        }

//                        UpDownBox{
//                            id:minUpdownBox
//                            anchors.bottom: chartView.bottom
//                            anchors.bottomMargin: 15
//                            upEnable: chartView.minDisplayTemp<chartView.maxDisplayTemp
//                            downEnable: chartView.minDisplayTemp>0
//                            onAboutToDown: {
//                                chartView.minDisplayTemp -=50;
//                            }
//                            onAboutToUp: {
//                                chartView.minDisplayTemp += 50;
//                            }
//                        }

                        ValueAxis{
                            id:yAxis
                            min: chartView.minDisplayTemp
                            max: chartView.maxDisplayTemp
                            tickCount: 6
                            labelFormat: "%.0f"
                            titleText: "结焦程度"
                            titleFont.family: "微软雅黑"
                            titleFont.pixelSize: 20

                        }
                        DateTimeAxis{
                            id:xAxis
                            min:fromDate
                            max: toDate
                            //tickCount: 10
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
                                        text: "显示智能分析入管曲线"
                                        font.pixelSize: 15
                                        font.family: "微软雅黑"
                                        color: fontColorTip
                                    }
                                }

                                Switch{
                                    id:showAI_tube_in_diagnoseOptionSwitch
                                    width: 50
                                    height: 20
                                    checked: true
                                    onCheckedChanged: {
                                        for(var a in ai_diagnose_inResultLines){
                                            if(selectedTubeListModel.get(a).selected)
                                                ai_diagnose_inResultLines[a].visible = checked;
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
                                        text: "显示智能分析出管曲线"
                                        font.pixelSize: 15
                                        font.family: "微软雅黑"
                                        color: fontColorTip
                                    }
                                }

                                Switch{
                                    id:showAI_tube_out_diagnoseOptionSwitch
                                    width: 50
                                    height: 20
                                    checked: true
                                    onCheckedChanged: {
                                        for(var b in ai_diagnose_outResultLines){
                                            if(selectedTubeListModel.get(b).selected)
                                                ai_diagnose_outResultLines[b].visible = checked
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

                        //show  tmt_div_cot option
                        Item{
                            width: 230
                            height : 20
                            Row{
                                id:showTMTDIVCOTOPtionRow
                                height: 20
                                spacing: 20
                                Item{
                                    width: 150
                                    height: 20
                                    Text{
                                        anchors.centerIn: parent
                                        text: "显示TMT/COT曲线"
                                        font.pixelSize: 15
                                        font.family: "微软雅黑"
                                        color: fontColorTip
                                    }
                                }

                                Switch{
                                    id:showTMT_div_COT_modelOptionSwitch
                                    width: 50
                                    height: 20
                                    checked: true
                                    onCheckedChanged: {
                                        for(var a in tmt_div_COT_modelResultLines)
                                            if(selectedTubeListModel.get(a).selected)
                                                tmt_div_COT_modelResultLines[a].visible = checked;
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
//                    Row{
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        y:40
//                        spacing: 10

//                        Text{
//                            text: "       入管曲线:"
//                            font.pixelSize: 17
//                            font.family: "微软雅黑"
//                            color: "#3E3E3E"
//                        }
//                        Image {
//                            source: "qrc:/imgs/icons/solid_line.png"
//                            opacity: 0.6
//                        }

//                        Text{
//                            text: "       出管曲线:"
//                            font.pixelSize: 17
//                            font.family: "微软雅黑"
//                            color: "#3E3E3E"
//                        }
//                        Image {
//                            source: "qrc:/imgs/icons/dash_line.png"
//                            opacity: 0.6
//                        }

//                        Text{
//                            text: "       COT管曲线:"
//                            font.pixelSize: 17
//                            font.family: "微软雅黑"
//                            color: "#3E3E3E"
//                        }
//                        Image {
//                            source: "qrc:/imgs/icons/dash_dot_dot_line.png"
//                            opacity: 0.6
//                        }
//                    }
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

    //sky 所谓的转圈圈
    TipBusyIndicator{
        id:analyze_dialog
        visible: false
        anchors.centerIn: parent
    }
}
