import QtQuick 2.0
import "../bar"
import "../Widget"
import QtCharts 2.1
import QtQml.Models 2.2
import SerialPortManager 1.0
import QtQuick.Controls 1.4
//数据导入页面
Item {
    id:root
    anchors.fill: parent
    //-----------sky 测试用数组----------
    property var tubein_datas: []
    property var tubeout_datas: []

    //-----------sky 测试用数组----------
    property int currentFornace : 5
    property int currentGroup: 0
    property int currentDisplayState:0
    property int currentPortIndex:0//串口索引值
    property bool readyReciveData:false//串口接收状态
    property var requestPushData: []
    signal closeGlobalPort();//关闭全局监听串口
    signal openGlobalPort();//关闭全局监听串口
    //sky:炉号数组
    property var furnaces:[
        "H110","H111","H112","H113","H114","H115","H116","H117","H118","H119","H120"
    ]
    property var requestData;
    property string newest_date: ""

    property int data_resend_time: 0;
    property alias topBar: topBar
    //更新3管数据
    function refresh(){
        //获取最新数据的时间
        var date = server.access_tube_newest_time();
        var date2 = new Date(date.toString())
        newest_date = date2.getFullYear() + "/" + (date2.getMonth()+1) + "/" + date2.getDate();
        console.log(" 最新时间：",newest_date)


        var st=new Date().getTime();
        requestData = {};
        //sky:在global中为server导出对像：engine->rootContext()->setContextProperty("server",MysqlServer::instance());
        requestData.tubeInDatas = server.access_tube_in_temp();//sky:将入管的数据读入暂时的数组中
        requestData.tubeOutDatas = server.access_tube_out_temp();//sky:将出管的数据读入暂时的数组中
//        requestData.tubeCOTDatas = server.access_tube_out_temp();
        requestData.tubeCOTDatas = server.access_tube_cot_temp();////sky:将cot数据读入暂时的数组中
        //打印刷新时间
        var et=new Date().getTime();
        console.log("spend time:",et-st)
    }

    //串口数据导入排错检测，硬件逻辑
    function checkStr(str){
        //硬件那边的bug,记得提醒硬件组修改：
//        str = str.replace("???", "??")
        //排错1
        //校检符号为,的个数，是否整齐，单段104个

        var seg1=String(str).match(new RegExp(",","g"));
        console.log("number is,",seg1.length);

        //校检符号位#的个数是否整齐，单端8个//sky:按照新的数据格式，#应该为16个，也是8的倍数，不用修改
        var seg2=String(str).match(new RegExp("#","g"));
        console.log("number is,",seg2.length);

        if((seg1.length%104!==0||seg2.length%8!==0)&&seg2.length>0&&seg1.length>0){
            return false;
        }

        //排错2
        var value=str.toString().split("??");//sky:清除掉“？？”


        /*删除换行符的数据，占两个字符*/
        for(var a=0;a<value.length;a++){
            if(value[a].length<20){
                value.splice(a,1);
            }
        }
        for(var a=0;a<value.length;a++){
//            if(value[a].length===2){
//                value.splice(a,1);
//            }
            console.log(a,"  ",value[a].length,"  ",value[a]);
        }
        console.log("kk:",value.length,value.toString());
        if(value.length%9===0&&value.length>0){
            return true;
        }
        else{
            return false;
        }
    }

 //---------------------sky:测试用函数----------------
    function insertTest( in_out,value,location){
        if(in_out === "tube_in")
            tubein_datas[location-1] = value;

        if(in_out === "tube_out")
            tubeout_datas[location-1] = value;

    }




 //---------------------sky:测试用函数----------------

    //初始化显示用的3管数据
    Component.onCompleted: {
        refresh();
        tubeInLine.clear();
        tubeOutLine.clear();
        tubeCOTLine.clear();

        var tubeInBarValues = [];
        var tubeOutBarValues = [];
        var tubeCOTBarValues = [];

        for(var i = 0; i< 12; i++){
            var tempIn = requestData.tubeInDatas[currentGroup*12 + i].temp;
            var tempOut = requestData.tubeOutDatas[currentGroup*12 + i].temp;
            var tempCot =0;
            if(requestData.tubeCotDatas != null){
                tempCot = requestData.tubeCotDatas[currentGroup*12 + i].temp;
            }


            tubeInLine.append((i+1), tempIn);
            tubeOutLine.append((i+1), tempOut);
            tubeCOTLine.append((i+1), tempCot);

            tubeInBarValues.push(tempIn);
            tubeOutBarValues.push(tempOut);
            tubeCOTBarValues.push(tempCot);
        }

        tubeInBarSet.values = tubeInBarValues;
        tubeOutBarSet.values = tubeOutBarValues;
        tubeCOTBarSet.values = tubeCOTBarValues;
    }
    //监听组的切换,切换管时切换图像
    onCurrentGroupChanged: {
        tubeInLine.clear();
        tubeOutLine.clear();
        tubeCOTLine.clear();

        var tubeInBarValues = [];
        var tubeOutBarValues = [];
        var tubeCOTBarValues = [];

        for(var i = 0; i< 12; i++){
            var tempIn = requestData.tubeInDatas[currentGroup*12 + i].temp;
            var tempOut = requestData.tubeOutDatas[currentGroup*12 + i].temp;
            var tempCot =0;
            if(requestData.tubeCotDatas != null){
                tempCot = requestData.tubeCotDatas[currentGroup*12 + i].temp;
            }
            tubeInLine.append((i+1), tempIn);
            tubeOutLine.append((i+1), tempOut);

            //test for cot using tube_out datas
            tubeCOTLine.append((i+1),tempCot);

            tubeInBarValues.push(tempIn);
            tubeOutBarValues.push(tempOut);

            //test for cot using tube_out datas
            tubeCOTBarValues.push(tempCot);
        }

        tubeInBarSet.values = tubeInBarValues;
        tubeOutBarSet.values = tubeOutBarValues;
        tubeCOTBarSet.values = tubeCOTBarValues;
    }

    Column{
        anchors.fill: parent
        //top bar
        Rectangle{
            id:topBar
            width: parent.width
            height: 50
            color: "#eef4f7"
            //fornaces 炉号
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
        }

        //content
        Rectangle{
            id:content
            width: parent.width
            height: parent.height-topBar.height
            color: "#ffffff"
            ListView{
                id:chartlist
                width: parent.width-80
                height: parent.height-80
                anchors.centerIn: parent
                clip: true
                enabled: false
                Component.onCompleted: {
                    // unknown problem
                    currentDisplayState = 1;
                    currentDisplayState = 0;
                }

                highlightRangeMode:ListView.StrictlyEnforceRange
                snapMode: ListView.SnapOneItem
                orientation: ListView.Vertical
                highlightMoveDuration:350
                currentIndex: currentDisplayState

                model: ObjectModel{
                    //linear chart
                    Item{
                        width: chartlist.width
                        height: chartlist.height
                        //charts
                        ChartView{
                            width: chartlist.width
                            height: chartlist.height
                            anchors.centerIn: parent
                            antialiasing: true
                            id:linearChart
                            title: "数据导入时间：" + newest_date
                            titleFont.family: "微软雅黑"
                            titleFont.pixelSize: 20


                            ValueAxis {
                                id: axisX
                                min: 1
                                max: 12
                                titleText: "管号"
                                titleFont.family: "微软雅黑"
                                titleFont.pixelSize: 20
                                tickCount: 12
                                labelFormat: "%.0f"
                            }

                            ValueAxis {
                                id: axisY
                                min: 700
                                max: 1100
                                titleText: "温度/℃"
                                titleFont.family: "微软雅黑"
                                titleFont.pixelSize: 20
                                labelFormat: "%.0f"
                            }
                            AreaSeries {
                                id:tubeOutSeries
                                name: "出管温度"
                                color: "#66ffff66"
                                borderColor: "#333333"
                                borderWidth: 1
                                axisX: axisX
                                axisY: axisY
                                upperSeries: LineSeries {
                                    id:tubeOutLine
                                }
                                lowerSeries: tubeInLine
                                //sky：显示每个点的数值
                                pointLabelsVisible: true
                                pointLabelsClipping : false
                                pointLabelsColor:"#66ff5645"
                                pointLabelsFont.pixelSize: 23
                                pointLabelsFont.family: "微软雅黑"
                                pointLabelsFormat: "@yPoint"

                            }
                            AreaSeries {
                                id:tubeInSeries
                                name: "入管温度"
                                color: "#66ff5645"
                                borderColor: "#333333"
                                borderWidth: 1
                                axisX: axisX
                                axisY: axisY
                                upperSeries: LineSeries {
                                    id:tubeInLine
                                }
                                lowerSeries: tubeCOTLine
                                //sky：显示每个点的数值
                                pointLabelsVisible: true
                                pointLabelsClipping : false
                                pointLabelsColor:"#66ff5645"
                                pointLabelsFont.pixelSize: 23
                                pointLabelsFont.family: "微软雅黑"
                                pointLabelsFormat: "@yPoint"

                            }
                            AreaSeries {
                                id:tubeCOTSeries
                                name: "COT温度"
                                color: "#660077ff"
                                borderColor: "#333333"
                                borderWidth: 1
                                axisX: axisX
                                axisY: axisY
                                upperSeries: LineSeries {
                                    id:tubeCOTLine
                                }

                                //sky：显示每个点的数值
                                pointLabelsVisible: true
                                pointLabelsClipping : false
                                pointLabelsColor:"#660077ff"
                                pointLabelsFont.family: "微软雅黑"
                                pointLabelsFont.pixelSize: 23
                            }

                        }

                    }


                    //bar chart
                    Item{
                        width: chartlist.width
                        height: chartlist.height
                        ChartView{
                            width: chartlist.width
                            height: chartlist.height
                            anchors.centerIn: parent
                            antialiasing: true
                            id:barChart
                            title: "数据导入时间：" + newest_date
                            titleFont.family: "微软雅黑"
                            titleFont.pixelSize: 20
                            ValueAxis {
                                id: barAxisY
                                min: 700
                                max: 1100
                                titleText: "温度/℃"
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
                                    titleText: "管号"
                                    titleFont.family: "微软雅黑"
                                    titleFont.pixelSize: 20

                                    categories: ["1", "2", "3", "4", "5", "6","7","8","9","10","11","12" ]
                                }
                                axisY: barAxisY

                                BarSet {
                                    id:tubeOutBarSet
                                    //sky 数值的字体颜色等
                                    label: "出管温度";
                                    labelFont.family: "微软雅黑"
                                    labelFont.pixelSize: 20
                                    labelColor: "#209fdf"
//                                    values: [966, 966,966, 966, 966, 966,966,966,966,966,966]
                                }
                                BarSet {
                                    id: tubeInBarSet
                                    label: "入管温度";
                                    labelFont.family: "微软雅黑"
                                    labelFont.pixelSize: 20
                                    labelColor: "#99ca53"
//                                    values: [888,888,888,888,888,888,888,888,888,888,888,888]
                                }
                                BarSet {
                                    id: tubeCOTBarSet
                                    label: "COT温度";
                                    labelFont.family: "微软雅黑"
                                    labelFont.pixelSize: 20
                                    labelColor: "#F6A625"
//                                    values: [855,855,855,855,855,855,855,855,855,855,855,855]
                                }
                            }
                        }
                    }
                }
            }

            //group chooser
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                y:15
                spacing: 50
                Repeater{
                    model: 4
                    delegate: Text{
                        font.pixelSize: 20
                        font.family: "微软雅黑"
                        color: currentGroup === index?"#557EE4": "#000000"
                        text: "第"+Number(index+1)+"组"
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                currentGroup = index;
                            }
                        }
                        Rectangle{
                            anchors.top: parent.bottom
                            anchors.topMargin: 10
                            width: parent.width
                            height: 3
                            color: "#557EE4"
                            opacity: index === currentGroup?1:0
                            Behavior on opacity {
                                PropertyAnimation{
                                    properties: "opacity"
                                    duration: 100
                                }
                            }
                        }
                    }
                }
            }

            //bnts
            Column{
                anchors.right: parent.right
                anchors.rightMargin: 25
                y:25
                spacing: 10
                id:bntsCol
                RoundIconButton{
                    text: currentDisplayState === 0?"显示直方图":"显示线性图"
                    imgSrc: currentDisplayState === 0?"qrc:/imgs/icons/line.png": "qrc:/imgs/icons/straight.png"
                    onBngClicked: {
                        currentDisplayState = currentDisplayState === 0? 1:0
                    }

                    width: 120
                    height: 36
                }
                RoundIconButton{
                    text: "手工导入新数据"
                    imgSrc: "qrc:/imgs/icons/add.png"
                    width: 120
                    height: 36
                    textSize: 13
                    onBngClicked: {
                        global_port.closePort();
                        messageText.text =readyReciveData?"   正在接收数据中，请用遥控器发送数据到Rola接收器"
                                                         :"请确保Rola接收器准备就绪！\n然后点击“开始接收数据”按钮进行数据接收。"
                                                           //"  请选择Rola接收器串口对应的串口，然后再按下开始接收按钮，系统会自动接收遥控器发来的数据，直到接收完毕，如果没有找到串口号，请检擦Rola接收器是否正常安装驱动。如果不知道哪个串口对应Rola接收器的，可以先拔出usb线，然后点击导入数据按钮查看串口第一次，然后关闭对话框，重新插入usb线，再点击导入数据按钮查看串口第二次，如果第二次出现了第一次查看串口时没有的串口名，说明这就是对应Rola接收器的串口！或者在系统中查看串口。";
                        data_resend_time=1;
                        dataImportDialog.open();
                    }
                }
            }
        }
    }


    //串口数据缓存触发 读取串口数据, 检测无误后 写入数据库
    Timer{
        id:completeTimer
        interval: 2300
        onTriggered: {
            if(data_resend_time>5){
                readyReciveData=false;
                serialPortManager.closeSerialPort();
                messageText.text ="上次数据传输失败5次以上,停止接受数据\n"
                messageText.text +="请确保Rola接收器准备就绪！\n然后点击“开始接收数据”按钮进行数据接收。"//"  请选择Rola接收器串口对应的串口，然后再按下开始接收按钮，系统会自动接收遥控器发来的数据，直到接收完毕，如果没有找到串口号，请检擦Rola接收器是否正常安装驱动。如果不知道哪个串口对应Rola接收器的，可以先拔出usb线，然后点击导入数据按钮查看串口第一次，然后关闭对话框，重新插入usb线，再点击导入数据按钮查看串口第二次，如果第二次出现了第一次查看串口时没有的串口名，说明这就是对应Rola接收器的串口！或者在系统中查看串口。";
                data_resend_time=1;
                return;
            }
            messageText.text =messageText.text+ "  正在接收数据，接受完成后将上传，上传过程中请勿做其他操作，完成后自动关闭对话框。第"+data_resend_time+
                    "次接受数据\n";

            var datas=serialPortManager.revDatas;
            serialPortManager.revDatas="";
            console.log("datas:\n",datas);
//            datas="
//<20170811-18:54:40-S(5)W(5)>  //sky:w是窗口号（win）
//??5#1,1021,994,1000,974,1001,964,998,980,999,975,987,965,11864??
//??5#2,1077,1080,1081,1085,1094,1085,1092,1104,1093,1116,1098,1117,13129??
//??5#3,1098,1076,1068,1101,1075,1090,1081,1089,1106,1092,1096,1093,13073??
//??5#4,1003,975,995,978,999,970,995,964,988,972,1003,983,11834??
//??5#5,1016,978,1014,973,1005,966,989,978,987,972,989,990,11867??
//??5#6,1086,1091,1089,1076,1088,1066,1087,1092,1097,1096,1120,1099,13098??
//??5#7,1111,1107,1106,1118,1110,1118,1114,1113,1114,1116,1125,1108,13372??
//??5#8,933,944,937,945,931,947,935,951,945,947,942,943,11313??

//<20170811-18:54:40-S(5)W(6)>
//??5#1,1021,994,1000,974,1001,964,998,980,999,975,987,965,11864??
//??5#2,1077,1080,1081,1085,1094,1085,1092,1104,1093,1116,1098,1117,13129??
//??5#3,1098,1076,1068,1101,1075,1090,1081,1089,1106,1092,1096,1093,13073??
//??5#4,1003,975,995,978,999,970,995,964,988,972,1003,983,11834??
//??5#5,1016,978,1014,973,1005,966,989,978,987,972,989,990,11867??
//??5#6,1086,1091,1089,1076,1088,1066,1087,1092,1097,1096,1120,1099,13098??
//??5#7,1111,1107,1106,1118,1110,1118,1114,1113,1114,1116,1125,1108,13372??
//??5#8,933,944,937,945,931,947,935,951,945,947,942,943,11313??

//<20170811-18:54:40-S(5)W(7)>
//??5#1,1021,994,1000,974,1001,964,998,980,999,975,987,965,11864??
//??5#2,1077,1080,1081,1085,1094,1085,1092,1104,1093,1116,1098,1117,13129??
//??5#3,1098,1076,1068,1101,1075,1090,1081,1089,1106,1092,1096,1093,13073??
//??5#4,1003,975,995,978,999,970,995,964,988,972,1003,983,11834??
//??5#5,1016,978,1014,973,1005,966,989,978,987,972,989,990,11867??
//??5#6,1086,1091,1089,1076,1088,1066,1087,1092,1097,1096,1120,1099,13098??
//??5#7,1111,1107,1106,1118,1110,1118,1114,1113,1114,1116,1125,1108,13372??
//??5#8,933,944,937,945,931,947,935,951,945,947,942,943,11313??

//";
            var ok=checkStr(datas);
            //错误提示框
            if(!ok){
                if(datas!=""){
                    messageText.text=messageText.text+"数据不完整!\n";
                }else {
                    messageText.text=messageText.text+"数据为空!\n";
                }
                data_resend_time++;
                serialPortManager.revDatas="";
                serialPortManager.writeDates("Data_Receive_Failure");
                completeTimer.start();
//                serialPortManager.closeSerialPort();
//                readyReciveData=false;
//                errorDialog_text.text="由于接收的数据不完整导致数据导入失败，请重新打开串口接收数据，建议遥控存的数据不要超过三组，以提高数据接收完整度"
//                +datas;
//                errorDialog.open();


                return;
            }

            serialPortManager.writeDates("@PC_saves_data$");
            //ser.sendData("@PC_saves_data$")

            messageText.text="第"+data_resend_time+"次接收，数据正确，准备上传，上传过程中请勿做其他操作，完成后自动关闭对话框！\n";
            data_resend_time=0;

            var value=datas.toString().split("??");//sky:根据？？切分数据 返回的是[] 每个元素是字符串



            /*删除换行符的数据，占两个字符*/
            for(var a=0;a<value.length;a++){
                if(value[a].length<20){
                    value.splice(a,1);
                }
            }


            var count=value.length/9;//sky:计算有多少组数据，每组数据9条 count == 1

            for(var index=0;index<count;index++){
                console.log("header:",value[9*index+0]);

                var date=value[9*index+0].substr(value[9*index+0].indexOf("<")+1,8);
                console.log("date:",date);
                /*年*/
                var year=String(date).substring(0,4);
                console.log("year:",year);
                /*月*/
                var month=String(date).substring(4,6);
                console.log("month",month);
                /*日*/
                var day=String(date).substring(6,8);
                console.log("day",day);

                /*转换*/
                date=year+"-"+month+"-"+day;
                console.log("Date",date);

                /*时间*/
                var time=String(value[9*index+0]).split("-")[1];
                console.log("time:",time);
                /*时*/
                var hours=String(time).split(":")[0];
                if(Number(hours)<10)
                    hours="0"+String(Number(hours));
                else
                    hours=String(Number(hours));

                /*分*/
                var minute=String(time).split(":")[1];
                if(Number(minute)<10)
                    minute="0"+String(Number(minute));
                else
                    minute=String(Number(minute));

                /*秒*/
                var second=String(time).split(":")[2];
                if(Number(second)<10)
                    second="0"+String(Number(second));
                else
                    second=String(Number(second));
                /*转换*/
                time=hours+":"+minute+":"+second;


                /*时间+日期*/
                var dateTime=date+" "+time;
                console.log("dateTime convertion:",dateTime);



                /*炉号*/
                var s=Number(String(value[9*index+0]).split("-")[2].charAt(2));
                console.log("炉号",s);

/***-----------------------sky:新数据格式，获取时间和炉号
//                var now = new Date();

//                /*年*/
//                var year = now.getFullYear();
//                console.log("year:",year)
//                /*月*/
//                var month = now.getMonth() + 1;
//                console.log("month:",month)
//                /*日*/
//                var day = now.getDate();
//                console.log("day:",day)

//                /*转换*/
//                var date = year + "-" + month +"-" + day;

//                /*时*/
//                var hours = now.getHours();
//                if(hours < 10){
//                    hours = "0"+hours
//                }

//                /*分*/
//                var minute = now.getMinutes();
//                if(minute < 10){
//                    minute = "0"+minute
//                }


//                /*秒*/
//                var second = now.getSeconds();
//                if(second < 10){
//                    second = "0"+second
//                }

//                /*转换*/
//                var time = hours + ":" + minute + ":" + second;

//                /*时间+日期*/
//                var dateTime = date + " " + time;

//                console.log("dateTime convertion:",dateTime);

//                /*炉号*/
//                var s = value[8*index+0].split(",")[0].charAt(0);
//                console.log("炉号",s)




 //----------------------sky:映射修改测试-------------------***/
                //炉号为偶数炉管映射处理
                if(s % 2 === 0){
                    for(var j = 1 ;j < 9 ;j++){
                        var w = Number(String(value[9*index+j]).split("#")[1].charAt(0));
                        console.log("窗口号",w);
                        var temp18s = String(value[9*index+j]).split(",");

                        var g = 1;
                        var location = "tube_in";

                        if(w === 1){
                            g = 1;
                            location = "tube_in";
                        }
                        else if(w === 2){
                            g = 1;
                            location = "tube_out";
                        }
                        else if(w === 3){
                            g = 2;
                            location = "tube_out";
                        }
                        else if(w === 4){
                            g = 2;
                            location = "tube_in";
                        }
                        else if(w === 5){
                            g = 3;
                            location = "tube_in";
                        }
                        else if(w === 6){
                            g = 3;
                            location = "tube_out";
                        }
                        else if(w === 7){
                            g = 4;
                            location = "tube_out";
                        }
                        else if(w === 8){
                            g = 4;
                            location = "tube_in";
                        }

                        var rule = 0;
                        if(w % 2 === 0)
                            rule = 1;

                        for(var a = 1 ;a < temp18s.length-1 ;a++){
                            if(rule === 1)
                                var tubenum = a + (g-1) * 12
                            else
                                var tubenum = 13 - a +(g-1) * 12

                            var temp = Number(temp18s[a])

                            if(temp <= 200){
                                var str = String(tubenum) + "号管数据为空，是否继续上传该数据？"
                                if(server.isPushingIncompleteDatas(str))
                                    console.log("************* push invalid datas;")
                                    insertTest(location,temp,tubenum)
                                    server.pushDatas(String(tubenum),String(s),String(location),String(temp),String(dateTime));

                            }else{
                                insertTest(location,temp,tubenum)
                                server.pushDatas(String(tubenum),String(s),String(location),String(temp),String(dateTime));
                            }
                        }
                    }


                }else{//炉号为奇数炉管映射处理
 //----------------------sky:映射修改测试-------------------
                    for(var j=1;j<9;j++){
    //                        console.log(j+"号窗口：",value[9*index+j]);
                        var w=Number(String(value[9*index+j]).split("#")[1].charAt(0));
                        console.log("窗口号",w);
                        var temp18s=String(value[9*index+j]).split(",")

                        //g=4;location=tube_in
                        var g=4;
                        var location="tube_in";

                        if(w===1){
                            g=4;
                            location="tube_in";
                        }
                        else if(w===2){
                            g=4;
                            location="tube_out";
                        }
                        else if(w===3){
                            g=3;
                            location="tube_out";
                        }
                        else if(w===4){
                            g=3;
                            location="tube_in";
                        }
                        else if(w===5){
                            g=2;
                            location="tube_in";
                        }
                        else if(w===6){
                            g=2;
                            location="tube_out";
                        }
                        else if(w===7){
                            g=1;
                            location="tube_out";
                        }
                        else if(w===8){
                            g=1;
                            location="tube_in";
                        }
                        //１，３，５，７号窗口是从左到右读入，２，４，６，８号窗口是从又到左读入
                        var rule=0;

                        if(w%2===0)
                            rule=1;

                        //切割的字符串为这个，第一个和最后一个是废的
    //                    5#1,896,894,896,890,898,883,898,885,896,897,882,881,10694
                        for(var a=1;a<temp18s.length-1;a++){
                            //判段是否采用从右到左的数据插入方法
                            if(rule===1)
                                var tubenum=13-a+(g-1)*12;//sky:管号
                            else
                                var tubenum=a+(g-1)*12;

                            var temp=Number(temp18s[a]);

                            if(temp <= 200){
                                var str = String(tubenum) + "号管数据为空，是否继续上传该数据？"
                                if(server.isPushingIncompleteDatas(str))//sky:！！！！这里有逻辑问题，无论选择是或否，都会上传数据，要搞清楚
                                    console.log("************* push invalid datas;")
                                    insertTest(location,temp,tubenum)
                                    server.pushDatas(String(tubenum),String(s),String(location),String(temp),String(dateTime));
                            } else{
    //                        console.log("temp:",temp18s[a],"   ",a);
                                insertTest(location,temp,tubenum)
                                server.pushDatas(String(tubenum),String(s),String(location),String(temp),String(dateTime));
                            }
                        }
    //                    console.log("group:",g,"tubenum:",tubenum,"foruneNum:",s,"location:",location,"temp:",temp,"datetime:",dateTime);


    //                    //数据测试正确
    //                    console.log(w+"号窗口",
    //                                temp18s[1],
    //                                temp18s[2],
    //                                temp18s[3],
    //                                temp18s[4],
    //                                temp18s[5],
    //                                temp18s[6],
    //                                temp18s[7],
    //                                temp18s[8],
    //                                temp18s[9],
    //                                temp18s[10],
    //                                temp18s[11],
    //                                temp18s[12]
    //                                );

                    }


                }


            }
//------------------------sky:测试输出------------------------
            console.log("------------------------sky:测试输出------------------------")
            console.log("tubein_datas",tubein_datas)
            console.log("tubeout_datas",tubeout_datas)
            console.log("------------------------sky:测试输出------------------------")
//------------------------sky:测试输出------------------------

            //关闭串口（必须）
            serialPortManager.closeSerialPort();
            readyReciveData=false;

            //调用反馈器
            serialPortManager.writeDates("Data_Receive_Success");

            //关闭导入数据对话框
            dataImportDialog.close();

            //显示成功导入数据对话框
//            var msgComponent = Qt.createComponent("qrc:/UI/Widgets/MessageDialog.qml");
//            if (msgComponent.status === Component.Ready) {
//                var msgDialog = msgComponent.createObject(root);
//                msgDialog.errorStr="    数据导入成功！";1
//                msgDialog.open();
//            }
            errorDialog.title ="成功"
            errorDialog_text.text="    数据导入成功！";
            errorDialog.open();
        }
    }

    //反馈计时器
    Timer{
        id:responseTimer
        interval: 2000
        onTriggered: {
        }
    }

    //串口设置
    SerialPortManager{

        id:serialPortManager
        onReadingFinish: {
            completeTimer.start();
        }
    }

    //串口名称列表
    ListModel{
        id:portModel
        Component.onCompleted: {
            for(var i=0;i<serialPortManager.getSerialPortsNum();i++){
                var portname=String(serialPortManager.getSerialPortName(i));
                portModel.append({
                                     "portName":portname,
                                     "isSelected":false

                                 });
                setProperty(0,"isSelected",true);
            }
            currentPortNameDisplayText.text="当前选择的串口:"+portModel.get(currentPortIndex).portName;
        }
    }

    //data import dialog 数据导入对话框
    CustomDialog {
        id:dataImportDialog
        title: "无线数据导入"
        onRejected:{
            readyReciveData=false;
            serialPortManager.closeSerialPort();
            //openGlobalPort();//开启全局监听串口
             global_port.openPort();
        }

        onAccepted:{
            readyReciveData=false;
            serialPortManager.closeSerialPort();
            //openGlobalPort()
             global_port.openPort();
        }

        content: Rectangle {
            id:itemContent
            color: "#12ccef"
            implicitWidth: 500
            implicitHeight: 500

            Column{
                anchors.fill: parent
                Rectangle{
                    width: itemContent.width
                    height: 40
                    color:"#454545"
                    Flickable{
                        anchors.fill: parent
                        contentWidth: row2.width
                        Row{
                            id:row2
                            Repeater{
                                model: portModel
                                delegate: CheckButton{
                                    bntText: portName
                                    selected: isSelected
                                    onBntClicked: {
                                        currentPortIndex=index;
                                        console.log(portModel.get(index).portName)
                                        for(var i=0;i<portModel.count;i++){
                                            if(i===index)
                                                continue;
                                            if(portModel.get(i).isSelected){
                                                portModel.setProperty(i,"isSelected",false);
                                            }
                                        }
                                        portModel.setProperty(index,"isSelected",true);
                                        currentPortNameDisplayText.text="当前选择的串口:"+portModel.get(currentPortIndex).portName;
                                        //设置串口
                                        serialPortManager.setPortName(portName);
                                    }
                                }
                            }
                        }
                    }
                }
                Item{
                    width: itemContent.width
                    height: itemContent.height-100
                    Text{
                        id:currentPortNameDisplayText
                        anchors.horizontalCenter: parent.horizontalCenter
                        y:20
                        text:"当前选择的串口:"+portModel.get(currentPortIndex).portName
                        color:"#ffffff"
                        font.pointSize: 25
                    }
                    TextArea{
                        width: parent.width-60
                        height: 200
                        anchors.centerIn: parent
                        id:messageText
                        text:readyReciveData?"   正在接收数据中，请用遥控器发送数据到Rola接收器"
                                            : "请确保Rola接收器准备就绪！\n然后点击“开始接收数据”按钮进行数据接收。"
                                              //"  请选择Rola接收器串口对应的串口，然后再按下开始接收按钮，系统会自动接收遥控器发来的数据，直到接收完毕，如果没有找到串口号，请检擦Rola接收器是否正常安装驱动。如果不知道哪个串口对应Rola接收器的，可以先拔出usb线，然后点击导入数据按钮查看串口第一次，然后关闭对话框，重新插入usb线，再点击导入数据按钮查看串口第二次，如果第二次出现了第一次查看串口时没有的串口名，说明这就是对应Rola接收器的串口！或者在系统中查看串口。"
                        font.pointSize: 18
                        backgroundVisible: false
                        readOnly: true
                        textColor: "#ffffff"

                    }
                }

                Item{
                    width:parent.width
                    height:60
                    Row{
                        anchors.centerIn: parent
                        spacing: 100
                        RoundIconButton{
                           text: readyReciveData?"取消接收":"开始接收数据"
                            onBngClicked: {
                                readyReciveData=readyReciveData?false:true
                    //-----------------------sky test-------------------
                                console.log("------------sky test :--------",readyReciveData)
                    //-----------------------sky test-------------------
                                if(readyReciveData){
                                    serialPortManager.revDatas="";
                                    var ok=serialPortManager.openSerialPort();
                                    //-----------------------sky test2-------------------
                                                console.log("------------sky test2 :--------",ok)
                                    //-----------------------sky test2-------------------
                                    if(!ok){
                                        //打开串口失败
                                        readyReciveData=false;
                                        serialPortManager.closeSerialPort();
                                        //串口打开错误对话框
                                        errorDialog.title = "错误"
                                        errorDialog_text.text="   串口打开失败，可能有其他程序在占用此串口，请手动关闭其他占用该串口的程序，再重新打开串口。";
                                        errorDialog.open();
//                                        var msgComponent = Qt.createComponent("qrc:/UI/Widgets/MessageDialog.qml");
//                                        if (msgComponent.status === Component.Ready) {
//                                            var msgDialog = msgComponent.createObject(root);
//                                            msgDialog.errorStr="    串口打开失败，可能有其他程序在占用此串口，请手动关闭其他占用该串口的程序，再重新打开串口。";
//                                            msgDialog.open();
//                                        }
                                    }else{
                                        //--------------sky 添加代码
                                        messageText.text = readyReciveData?"   正在接收数据中，请用遥控器发送数据到Rola接收器"
                                                                          : "请确保Rola接收器准备就绪！\n然后点击“开始接收数据”按钮进行数据接收。"
                                                                            //"  请选择Rola接收器串口对应的串口，然后再按下开始接收按钮，系统会自动接收遥控器发来的数据，直到接收完毕，如果没有找到串口号，请检擦Rola接收器是否正常安装驱动。如果不知道哪个串口对应Rola接收器的，可以先拔出usb线，然后点击导入数据按钮查看串口第一次，然后关闭对话框，重新插入usb线，再点击导入数据按钮查看串口第二次，如果第二次出现了第一次查看串口时没有的串口名，说明这就是对应Rola接收器的串口！或者在系统中查看串口。";
                                    }
                                }
                                else{
                                    serialPortManager.closeSerialPort();
                                    messageText.text =readyReciveData?"   正在接收数据中，请用遥控器发送数据到Rola接收器"
                                                                     : "请确保Rola接收器准备就绪！\n然后点击“开始接收数据”按钮进行数据接收。"
                                                                       //"  请选择Rola接收器串口对应的串口，然后再按下开始接收按钮，系统会自动接收遥控器发来的数据，直到接收完毕，如果没有找到串口号，请检擦Rola接收器是否正常安装驱动。如果不知道哪个串口对应Rola接收器的，可以先拔出usb线，然后点击导入数据按钮查看串口第一次，然后关闭对话框，重新插入usb线，再点击导入数据按钮查看串口第二次，如果第二次出现了第一次查看串口时没有的串口名，说明这就是对应Rola接收器的串口！或者在系统中查看串口。";
                                    data_resend_time=1;
                                }
                            }
                        }
                    }
                }
            }


        }
    }


    CustomDialog{
        id:errorDialog
        title: "错误"

        onRejected:{
            serialPortManager.closeSerialPort();
             global_port.openPort();
            //openGlobalPort();//开启全局监听串口
        }

        onAccepted:{
            serialPortManager.closeSerialPort();
             global_port.openPort();
            //openGlobalPort()
        }

        content: Item{
            width: 500
            height: 400
            TextArea{
                id:errorDialog_text
                anchors.fill: parent

                text:"由于接收的数据不完整导致数据导入失败，请重新打开串口接收数据，建议遥控存的数据不要超过三组，以提高数据接收完整度"
                font.pointSize: 22;
            }
        }
    }
}
