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
    property date fromDate: new Date(toDate.getTime() - 10*24*60*60*1000)
    property date toDate:new Date()
    property var  analyzeResult: []
    property var searchDatas: []

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

    property var colordelegate: ["#13B92E","#E1D121","#FD9F02","#FD030F"]

    function refresh2(){
        searchDatas = []

        var fromDateStr = fromDatPicker.year + "-" +
                fromDatPicker.month + "-" +
                fromDatPicker.day + " 00:00:00";
        var toDateStr = toDatPicker.year + "-" +
                toDatPicker.month + "-" +
                toDatPicker.day + " 23:59:59"

        var fDate = new Date(fromDateStr);
        var tDate = new Date(toDateStr);
        fromDate = fDate;
        toDate = tDate;

        var result = server.diagnoseData(currentFuranceNum,acrossSection[currentFuranceNum],fDate,tDate)
        console.log(result)
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
             var obj = server.diagnoseVenturiPressureData(currentFuranceNum,searchDatas[c].Date);
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

        //console.log(searchDatas[0].TMTOUT)
        //console.log(searchDatas[0].TMTIN)
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
        tip_title.text = "正在分析中，请稍等...."
        analyze_dialog.visible = true;
        utils.test(all_tmt,all_apr);
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


    //更新每条折线的数据
    function refresh(){

        // remove all lines
        //tubeChartView.removeAllSeries();
        //analysisChartView.removeAllSeries();
        scatterSeries.clear()
        lineSeries.clear()
        //pressureChartView.removeAllSeries();

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
            //var resultPressue = server.pressureData(currentFuranceNum, selectedTubeListModel.get(a).tubeNum, fDate, tDate);
//            console.log("*********************",resultPressue.length);
            console.log("result:",result.length);

            //var axisXDiagnose = analysisChartView.axisX(lineSeries);
            //var axisYDiagnose = analysisChartView.axisY(lineSeries);

            //var myAxisX = tubeChartView.axisX(lineSeries1);
            //var myAxisY = tubeChartView.axisY(lineSeries1);

            //var axisXPressure = pressureChartView.axisX(lineSeries2);
            //var axisYPressure = pressureChartView.axisY(lineSeries2);

            //var lineIn = tubeChartView.createSeries(ChartView.SeriesTypeLine, "T"+selectedTubeListModel.get(a).tubeNum, myAxisX, myAxisY);
            //var lineOut = tubeChartView.createSeries(ChartView.SeriesTypeLine, "T"+selectedTubeListModel.get(a).tubeNum, myAxisX, myAxisY);
            //var lineCOT = tubeChartView.createSeries(ChartView.SeriesTypeLine, "T"+selectedTubeListModel.get(a).tubeNum, myAxisX, myAxisY);

//            var lineDiagnose = analysisChartView.createSeries(ChartView.SeriesTypeScatter,
//                                                              "T"+selectedTubeListModel.get(a).tubeNum,
//                                                              axisXDiagnose,
//                                                              axisYDiagnose);

//            var linePressures = pressureChartView.createSeries(ChartView.SeriesTypeLine,
//                                                           "T"+selectedTubeListModel.get(a).tubeNum,
//                                                           axisXPressure, axisYPressure);

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
                //lineIn.append(mdata.time,mdata.tubeInTemp);
                //lineOut.append(mdata.time,mdata.tubeOutTemp);
                //lineCOT.append(mdata.time,mdata.tubeCOTTemp);
                if(b % 2 === 0){
                    //lineDiagnose.append(mdata.time, 2);
                    scatterSeries.append(mdata.time,2)
                    lineSeries.append(mdata.time,2)
                }else{
                    scatterSeries.append(mdata.time,1)
                    lineSeries.append(mdata.time, 1)
                }

                //set line color
                //lineIn.color = selectedTubeListModel.get(a).displayColor;
                //lineOut.color = selectedTubeListModel.get(a).displayColor;
                //lineCOT.color = selectedTubeListModel.get(a).displayColor;

                //lineDiagnose.color = selectedTubeListModel.get(a).displayColor;

                //set line style
                //lineOut.style = tubeOutLIneStyle;
                //lineCOT.style = tubeCOTLineStyle;
                //lineIn.style = tubeInLineStyle;
            }

//            for(var c = 0; c< resultPressue.length; c++){
//                var pdata = {};
//                pdata.time = new Date(resultPressue[c].time);
//                pdata.value = resultPressue[c].value;
//                linePressures.append(pdata.time,pdata.value);
//                linePressures.color = selectedTubeListModel.get(a).displayColor;
//                console.log(pdata.time,pdata.value);
//            }

            //restore lines to further control
            //tubeInResultLines.push(lineIn);
            //tubeOutResultLines.push(lineOut);
            //tubeCOTResultLines.push(lineCOT);

            //diagnoseResultLines.push(lineDiagnose)

            //pressureResultLines.push(linePressures)
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


    Rectangle{
        width: parent.width - parent.width/4
        height: 50
        x:(parent.width - rightTopBar.width)/2
        id: rightTopBar
        border.width: 1
        border.color: borderColor
        anchors.top: parent.top
        anchors.topMargin: 25

        // select row
        Row{
            anchors.centerIn: parent
            spacing: 30
            //from date picker
            DatePicker{
                id:fromDatPicker
                anchors.verticalCenter: analisisBnt.verticalCenter
            }

            Image{
                width: 20
                height: 20
                id:fromtime_select_btn
                source: "qrc:/imgs/icons/button_calendar_press.png"
                scale:btnCalender1.containsMouse ? 1.1 : 1
                anchors.verticalCenter: analisisBnt.verticalCenter
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
                anchors.verticalCenter: analisisBnt.verticalCenter
                Text{
                    anchors.centerIn: parent
                    text: "到"
                    font.pixelSize: 18
                    //color: "#12eeaa"
                }
            }

            //to date picker
            DatePicker{
                id:toDatPicker
                anchors.verticalCenter: analisisBnt.verticalCenter
            }

            Image{
                width: 20
                height: 20
                id:totime_select_btn
                source: "qrc:/imgs/icons/button_calendar_press.png"
                scale:btnCalender2.containsMouse ? 1.1 : 1
                anchors.verticalCenter: analisisBnt.verticalCenter
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


            //text
            Item{
                width: 20
                height: 20
                anchors.verticalCenter: analisisBnt.verticalCenter
                Text{
                    anchors.centerIn: parent
                    text: "炉号"
                    font.pixelSize: 18
                    //color: "#12eeaa"
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
                bgColor: "#5596E4"
                id:analisisBnt
                onBngClicked: {

                    refresh2()
//                                tip_title.text = "正在分析中，请稍等...."
//                                analyze_dialog.visible = true;
//                                utils.test();
                }
            }

            RoundIconButton{
                imgSrc: "qrc:/imgs/icons/picture.png"
                width: 120
                height: 35
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

    Item {
        id:tubes
        width: parent.width
        height: bar_row.height
        //anchors.top: rightTopBar.bottom
        //anchors.topMargin: 50
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        Row{
            id:bar_row
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 15
            Repeater{
                model: 48
                delegate:Column{
                        id:bar_col
                        Rectangle{
                            id:one_bar
                            height: 400
                            width: 15
                            color: searchDatas.length > 0 ? colordelegate[searchDatas[0].OUTRS[index]] :"#5596E4"
                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    if(hoverEnabled){
                                        hoverEnabled = false
                                        one_bar.color = "green"
                                    }else{
                                        hoverEnabled = true
                                        one_bar.color = "#5596E4"
                                    }
                                }

                                onEntered: {
                                    flowChartView._lineSeries.clear()
                                    flowChartView._lineSeries2.clear()
                                    flowChartView._lineSeries3.clear()
                                    flowChartView._scatterSeries.clear()
                                    flowChartView._scatterSeries1.clear()
                                    flowChartView._scatterSeries2.clear()
                                    flowChartView._scatterSeries3.clear()

                                    flowChartView.x_axis_min = fromDate

                                    var tdt = new Date(Qt.formatDateTime(toDate,"yyyy-MM-dd"))
                                    tdt.setHours(0)
                                    tdt.setMinutes(0)
                                    tdt.setSeconds(0)
                                    flowChartView.x_axis_max = tdt

                                    flowChartView.title = String(index+1)+"号管结焦趋势"
                                    for(var a = 0; a < searchDatas.length; a++){
                                        var dtime = new Date(searchDatas[a].Date)
                                        dtime.setHours(0)
                                        dtime.setMinutes(0)
                                        dtime.setSeconds(0)

                                        flowChartView._lineSeries.append(dtime,searchDatas[a].OUTRS[index])
                                        flowChartView._lineSeries2.append(dtime,searchDatas[a].INRS[index])
                                        flowChartView._lineSeries3.append(dtime,searchDatas[a].TMTDIVCOTRS[index])
                                        switch(Number(searchDatas[a].OUTRS[index])){
                                                case 0:
                                                    flowChartView._scatterSeries.append(dtime,searchDatas[a].OUTRS[index])
                                                    break;
                                                case 1:
                                                    flowChartView._scatterSeries1.append(dtime,searchDatas[a].OUTRS[index])
                                                    break;
                                                case 2:
                                                    flowChartView._scatterSeries2.append(dtime,searchDatas[a].OUTRS[index])
                                                    break;
                                                case 3:
                                                    flowChartView._scatterSeries3.append(dtime,searchDatas[a].OUTRS[index])
                                          }

                                        switch(Number(searchDatas[a].INRS[index])){
                                                case 0:
                                                    flowChartView._scatterSeries.append(dtime,searchDatas[a].INRS[index])
                                                    break;
                                                case 1:
                                                    flowChartView._scatterSeries1.append(dtime,searchDatas[a].INRS[index])
                                                    break;
                                                case 2:
                                                    flowChartView._scatterSeries2.append(dtime,searchDatas[a].INRS[index])
                                                    break;
                                                case 3:
                                                    flowChartView._scatterSeries3.append(dtime,searchDatas[a].INRS[index])
                                          }
                                    }

                                    flowChartView.show()
                                }

                                onExited: {
                                    flowChartView.hide()
                                }
                            }
                        }
                        Text {
                            text: index +1
                            font.pixelSize: 15
                        }
                    }
            }
        }

    }

    Text {
        anchors.top: tubes.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        text: "管号"
    }

    /*
              //sky:文丘里值输入
    Rectangle{
        width: parent.width
        height: 50
        id: rightTopBar2
        //border.width: 1
        //border.color: borderColor
        color:"transparent"

        Row{
            anchors.centerIn: parent
            spacing: 25
            Text {
                height: 30
                text: "文丘里："
                verticalAlignment: Text.AlignBottom
                font.pixelSize: 23
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

            Text{
                height: 30
                id:label1
                verticalAlignment: Text.AlignBottom
                text: "单位（kpa）"


            }
            Text{
                height: 30
                verticalAlignment: Text.AlignBottom
                text: "*未输入数值，则默认为零"
                color:"red"
            }
        }

    }
*/

/*    Item{

        width: parent.width
        height: analysisChartView.height
        anchors.top: rightTopBar.bottom
        anchors.topMargin: 50
        id: chartViewsItem

        Glow{
            anchors.fill: analysisChartView
            color: "#10000000"
            spread: 0.1
            radius: 5
            source: analysisChartView
            transparentBorder: true
            fast: true
            cached: true
            samples: 15

        }

        ChartView{
            id:analysisChartView
            width: parent.width
            height: 500
            legend.visible:false


            BarSeries{
                id:bars
                axisX: BarCategoryAxis{
                    titleText: "管号"
                    categories: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,
                    22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,
                        44,45,46,47,48]
                }

                BarSet{
                    id:aabarse
                    values: [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,,2,2,2,2,2,2,2]
                }

                onHovered: {
                    if(status){
                        //console.log(index + 1)
                        flowChartView.x_axis_min = fromDate
                        flowChartView.x_axis_max = toDate
                        flowChartView.title = (index + 1)+"号管结焦趋势"
                        flowChartView._lineSeries.clear()
                        flowChartView._scatterSeries.clear()
                        for(var a = 0; a < searchDatas.length; a++){
                            flowChartView._lineSeries.append(new Date(searchDatas[a].Date),searchDatas[a].OUTRS[index])
                            flowChartView._scatterSeries.append(new Date(searchDatas[a].Date),searchDatas[a].OUTRS[index])
                        }

                        flowChartView.visible = true
                    }else{
                        flowChartView.visible = false
                    }
                }
            }
        }


/*        ChartView{
            id:analysisChartView
            width: parent.width - parent.width/4
            height: 500
            x:(parent.width - analysisChartView.width)/2
            title: "结焦趋势"
            titleColor: fontColorNormal
            titleFont.pixelSize: 20
            antialiasing: true
            legend.visible: false
            property var maxValue: 5
            property var minValue: 0
            backgroundColor: "#00000000"

            ValueAxis{
                id:yAxis
                min: analysisChartView.minValue
                max: analysisChartView.maxValue
                tickCount: 6
                labelFormat: "%0.00f"
                titleText: "结焦程度"
            }
            DateTimeAxis{
                id:xAxis
                min:fromDate
                max: toDate
                format: "yy/MM/dd"
                titleText: "日期：年/月/日"
            }
            SplineSeries{
                id:lineSeries
                axisX: xAxis
                axisY: yAxis
            }

            ScatterSeries{
                id:scatterSeries
                axisX: xAxis
                axisY: yAxis
                onHovered: {
                    if(state){
                        var p = utils.getPos()
                        //console.log(root.x,root.y)
                        //console.log(root.width,root.height)
                        //console.log(p.x,p.y)
                        flowChartView.x = analysisChartView.x//p.x - root.x - flowChartView.width/2 //(root.x + flowChartView.width)/2
                        flowChartView.y = analysisChartView.y//p.y - root.x - flowChartView.height/2 //(root.y + flowChartView.width)/2
                        flowChartView.show()
                    }else{
                        flowChartView.hide()
                    }
                }
            }

        }
    }*/
/*
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

*/

    Connections{
        target: utils
        onFinish:{
            tip_title.text = "分析完成！"
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

            }*/

        }
    }



    //sky:悬浮的柱形图
    DiagnoseChartView{
        id:flowChartView
        anchors.bottom: tubes.top
        anchors.bottomMargin:  -200
        anchors.horizontalCenter: parent.horizontalCenter
        width: tubes.width - 300//parent.width /2
        height: tubes.height + 200 //parent.height /3
    }

    Rectangle{
        id:analyze_dialog
        width: 200
        height: 180
        anchors.centerIn: parent
        //z:2
        visible: false
        color: "#00000000"

        Text{
            id:tip_title
            text: "正在分析中，请稍等...."
            font.pixelSize: 20
            font.family: "宋体"
            x:(parent.width - tip_title.width)/2
        }

        BusyIndicator{
            width: 80
            height: 80
            id:busy
            running: true
            anchors.centerIn: parent
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
