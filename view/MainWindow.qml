import QtQuick 2.0
import QtQml.Models 2.2
import "./bar"
import "./Widget"
import QtQuick.Controls 1.4
//功能选择栏
Item {
    id:mainWindow
    property int tubein_alert_temp: 950
    property int tubeout_alert_temp: 1080
    property int tubecot_alert_temp: 850
    property var global_rev_data_date:[]
    property var tubein_datas: []
    property var tubeout_datas: []

    onTubein_alert_tempChanged: {
        console.log(tubein_alert_temp)
    }

    property var pages:[]
    ListModel{
        id:menuList

    }

    function insertTest( in_out,value,location){
        if(in_out === "tube_in")
            tubein_datas[location-1] = value;

        if(in_out === "tube_out")
            tubeout_datas[location-1] = value;

    }

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

        if(value.length%8===0&&value.length>0){
            return true;
        }
        else{
            return false;
        }
    }

    Component.onCompleted: {

        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/tmp_icon.png",
                            "selected":true,
                            "title":"温度数据维护",
                            "content":"qrc:/view/page/DataImportPage.qml",
                            "onHovered":false,
                            "subdataModel":[
                                {
                                    "subimgSrc":"qrc:/imgs/icons/import_icon.png",
                                    "selected":true,
                                    "subtitle":"温度数据导入",
                                    "content":"qrc:/view/page/DataImportPage.qml"
                                },
                                {
                                    "subimgSrc":"qrc:/imgs/icons/search_icon.png",
                                    "selected":false,
                                    "subtitle":"温度数据查询",
                                    "content":"qrc:/view/page/DataSearchPage.qml"
                                }
                            ]
                        });

        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/press_icon.png",
                            "selected":false,
                            "title":"压力数据维护",
                            "content":"qrc:/view/page/DataSearchPage.qml",
                            "onHovered":false,
                            "subdataModel":[
                                {
                                    "subimgSrc":"qrc:/imgs/icons/import_icon.png",
                                    "selected":false,
                                    "subtitle":"文丘里数据输入",
                                    "content":"qrc:/view/page/PressureDataInputPage.qml"
                                },
                                {
                                    "subimgSrc":"qrc:/imgs/icons/search_icon.png",
                                    "selected":false,
                                    "subtitle":"压力数据查询",
                                    "content":"qrc:/view/page/PressureDataSearchPage.qml"
                                }
                            ]


                        });
        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/compare_icon.png",
                            "selected":false,
                            "title":"炉管数据比较",
                            "content":"qrc:/view/page/TubesComparePage.qml",
                            "onHovered":false,
                            "subdataModel":[
                                {
                                    "subimgSrc":"qrc:/imgs/icons/tmp_cmp_icon.png",
                                    "selected":false,
                                    "subtitle":"温度数据比较",
                                    "content":"qrc:/view/page/TubesComparePage.qml"
                                },
                                {
                                    "subimgSrc":"qrc:/imgs/icons/press_cmp_icon.png",
                                    "selected":false,
                                    "subtitle":"压力数据比较",
                                    "content":"qrc:/view/page/PressureDataComparePage.qml"
                                }
                            ]

                        });
        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/diagnose.png",
                            "selected":false,
                            "title":"炉管结焦诊断",
                            "content":"qrc:/view/page/DiagnosePage2.qml",
                            "onHovered":false,
//                            "subdataModel":[
//                                {
//                                    "subimgSrc":"qrc:/imgs/icons/import_icon.png",
//                                    "selected":false,
//                                    "subtitle":"温度数据导入",
//                                    "content":"qrc:/view/page/DiagnosePage2.qml"

//                                },
//                                {
//                                    "subimgSrc":"qrc:/imgs/icons/search_icon.png",
//                                    "selected":false,
//                                    "subtitle":"温度数据查询",
//                                    "content":"qrc:/view/page/DiagnosePage2.qml"
//                                }
//                            ]

                        });
/*        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/presure.png",
                            "selected":false,
                            "title":"用户信息管理",
                            "content":"qrc:/view/page/PressureDataImportPage.qml",
                            "onHovered":false,
                            "subdataModel":[
                                {
                                    "subimgSrc":"",
                                    "selected":true,
                                    "subtitle":"温度数据导入"
                                },
                                {
                                    "subimgSrc":"",
                                    "selected":false,
                                    "subtitle":"温度数据查询"
                                }
                            ]

                        });
*/
        if(server.currentUserAccess === 1)
            menuList.append({
                                "imgSrc":"qrc:/imgs/icons/user_icon.png",
                                "selected":false,
                                "title":"用户信息管理",
                                "content":"qrc:/view/page/UserManagerPage.qml",
                                "onHovered":false,
/*                                "subdataModel":[
                                    {
                                        "subimgSrc":"qrc:/imgs/icons/import_icon.png",
                                        "selected":false,
                                        "subtitle":"温度数据导入",
                                        "content":"qrc:/view/page/UserManagerPage.qml"
                                    },
                                    {
                                        "subimgSrc":"qrc:/imgs/icons/search_icon.png",
                                        "selected":false,
                                        "subtitle":"温度数据查询",
                                        "content":"qrc:/view/page/UserManagerPage.qml"
                                    }
                                ]
*/

                            });
        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/param_icon.png",
                            "selected":false,
                            "title":"系统参数设置",
                            "content":"qrc:/view/page/SettingPage.qml",
                            "onHovered":false,
/*                            "subdataModel":[
                                {
                                    "subimgSrc":"qrc:/imgs/icons/tube_setting.png",
                                    "selected":false,
                                    "subtitle":"炉管参数设置",

                                    "content":"qrc:/view/page/SettingPage.qml"
                                },
                                {
                                    "subimgSrc":"qrc:/imgs/icons/local_setting.png",
                                    "selected":false,
                                    "subtitle":"本地参数设置",

                                    "content":"qrc:/view/page/SettingPage2.qml"
                                }
                            ]
*/

                        });
        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/version_icon.png",
                            "selected":false,
                            "title":"软件版本信息",
                            "content":"qrc:/view/page/MessagePage.qml",
                            "onHovered":false,
/*                            "subdataModel":[
                                {
                                    "subimgSrc":"qrc:/imgs/icons/import_icon.png",
                                    "selected":false,
                                    "subtitle":"温度数据导入",
                                    "content":"qrc:/view/page/MessagePage.qml"
                                },
                                {
                                    "subimgSrc":"qrc:/imgs/icons/search_icon.png",
                                    "selected":false,
                                    "subtitle":"温度数据查询",
                                    "content":"qrc:/view/page/MessagePage.qml"
                                }
                            ]
*/
                        });
        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/close_btn8.png",
                            "selected":false,
                            "title":"退出系统",
                            "content":"qrc:/view/page/MessagePage.qml",
                            "onHovered":false
                        });


        globalPort.openPortSucc_Faild.connect(global_port_open_deal)
        globalPort.coreSyn.connect(global_port_coreSyn_deal)
        globalPort.msgToast.connect(global_port_msgToast_deal)
        globalPort.recFinish.connect(global_port_recFinish_del)
        globalPort.openPort();
    }

    Row{
        anchors.fill: parent
        LeftBar{
            id:leftbar
            width: 150
            height: parent.height
            z:3
            dataModel: menuList
            onIndexChanged: {
                loader.source = menuList.get(index).content
            }
            onSubBtnSelected: {
                loader.source = menuList.get(index).subdataModel.get(subindex).content
            }
        }
        Loader{
            id:loader
            width: parent.width-leftbar.width
            height:parent.height
            source: "qrc:/view/page/DataImportPage.qml"
            //点击任意位置，二级菜单收回，一级菜单图标高亮回到原来位置
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    //二级菜单收回
                    for(var a = 0; a < menuList.count; a++){
                        if(menuList.get(a).subdataModel !== undefined){
                            if(menuList.get(a).onHovered){
                                menuList.setProperty(a,"onHovered",false)
                            }
                        }
                    }
                //一级菜单图标高亮回到原来位置
                    //清除一级菜单的状态
                    for(var a = 0; a < menuList.count; a++){
                        if(menuList.get(a).selected){
                            menuList.setProperty(a,"selected",false)
                        }
                    }
                    //高亮回到原位
                   menuList.setProperty(leftbar.loadindex,"selected",true)
                }
            }
        }

    }

//    GlobalSerialPortManager{
//        id:global_port
//    }


    function global_port_open_deal(flag){
        if(!flag){
            messageText.text = "串口打开失败"
            toast_dialog.open()
        }

    }

    function global_port_coreSyn_deal(){
        global_rev_data_date = []
        messageText.text += "连接成功\n"
        toast_dialog.open()

    }

    function global_port_msgToast_deal(win_num){
        global_rev_data_date[win_num] = new Date()//Qt.formatDateTime(new Date(),"yyyy-MM-dd hh:mm:ss")//new Date().toLocaleString(Qt.local,"yyyy-MM-dd hh:mm:ss")
        messageText.text += win_num +"窗口数据接收成功"+Qt.formatDateTime(global_rev_data_date[win_num],"yyyy-MM-dd hh:mm:ss")+"\n"

    }

    function global_port_recFinish_del(){
        messageText.text += "所有数据接收完成\n"
        var data = globalPort.getAllData()
        for(var a in data){
            messageText.text += a + "  " + data[a] + "\n"
        }

        var all_data;
        for(var a in data){
            all_data += data[a];
        }

        var ok = checkStr(all_data)
        if(!ok){
            if(all_data !== ""){
                messageText.text += "数据不完整！请重新发送\n";

            }else{
                messageText.text += "数据为空！请重新发送\n";
            }
        }else{


            messageText.text += "      数据导入成功\n"
            //global_port.sendData("@PC_saves_data$")


            var value=all_data.toString().split("??");//sky:根据？？切分数据 返回的是[] 每个元素是字符串



            /*删除换行符的数据，占两个字符*/
            for(var a=0;a<value.length;a++){
                if(value[a].length<20){
                    value.splice(a,1);
                }
            }


            var count=value.length/8;//sky:计算有多少组数据，每组数据8条 count == 1

            console.time("保存数据所需时间")

            for(var index=0;index<count;index++){
/***-----------------------sky:新数据格式，获取时间和炉号      *************/

                /*炉号*/
                var s = value[8*index+0].split(",")[0].charAt(0);
                console.log("炉号",s)

                //炉号为偶数炉管映射处理
                if(s % 2 === 0){
                    for(var j = 0 ;j < 8 ;j++){
                        var w = Number(String(value[8*index+j]).split("#")[1].charAt(0));
                        console.log("窗口号",w);
                        var temp18s = String(value[8*index+j]).split(",");

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
                                if(server.isPushingIncompleteDatas(str)){
                                    console.log("************* push invalid datas;")
                                    console.log("窗口号",tubenum,"炉号",s,"出入管",location,"数据",temp,"时间",Qt.formatDateTime(global_rev_data_date[j+1],"yyyy-MM-dd hh:mm:ss"))
                                    insertTest(location,temp,tubenum)
                                    server.pushDatas(String(tubenum),String(s),String(location),String(temp),Qt.formatDateTime(global_rev_data_date[j+1],"yyyy-MM-dd hh:mm:ss"));
                                }
                            }else{
                                console.log("窗口号",tubenum,"炉号",s,"出入管",location,"数据",temp,"时间",Qt.formatDateTime(global_rev_data_date[j+1],"yyyy-MM-dd hh:mm:ss"))
                                insertTest(location,temp,tubenum)
                                server.pushDatas(String(tubenum),String(s),String(location),String(temp),Qt.formatDateTime(global_rev_data_date[j+1],"yyyy-MM-dd hh:mm:ss"));
                            }
                        }
                    }


                }else{//炉号为奇数炉管映射处理
 //----------------------sky:映射修改测试-------------------
                    for(var j=0;j<8;j++){
    //                        console.log(j+"号窗口：",value[9*index+j]);
                        var w=Number(String(value[8*index+j]).split("#")[1].charAt(0));
                        console.log("窗口号",w);
                        var temp18s=String(value[8*index+j]).split(",")

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

                            // -1原为200
                            if(temp <= 200){
                                var str = String(tubenum) + "号管数据为空，是否继续上传该数据？"
                                if(server.isPushingIncompleteDatas(str)){//sky:！！！！这里有逻辑问题，无论选择是或否，都会上传数据，要搞清楚
                                    console.log("窗口号",tubenum,"炉号",s,"出入管",location,"数据",temp,"时间",Qt.formatDateTime(global_rev_data_date[j+1],"yyyy-MM-dd hh:mm:ss"))
                                    console.log("************* push invalid datas;")
                                    insertTest(location,temp,tubenum)
                                    server.pushDatas(String(tubenum),String(s),String(location),String(temp),Qt.formatDateTime(global_rev_data_date[j+1],"yyyy-MM-dd hh:mm:ss"));
                                }
                            } else{
                                console.log("窗口号",tubenum,"炉号",s,"出入管",location,"数据",temp,"时间",Qt.formatDateTime(global_rev_data_date[j+1],"yyyy-MM-dd hh:mm:ss"))
                                //console.log(Qt.formatDateTime(global_rev_data_date[j+1],"yyyy-MM-dd hh:mm:ss"))
                                insertTest(location,temp,tubenum)
                                server.pushDatas(String(tubenum),String(s),String(location),String(temp),Qt.formatDateTime(global_rev_data_date[j+1],"yyyy-MM-dd hh:mm:ss"));
                            }
                        }

                    }


                }


            }

            console.timeEnd("保存数据所需时间")
            //global_port.sleep(1000*5)
            //globalPort .sendData("@PC_saves_data$");
            globalPort.setFinishFlag(!0)

//------------------------sky:测试输出------------------------
            console.log("------------------------sky:测试输出------------------------")
            console.log("tubein_datas",tubein_datas)
            console.log("tubeout_datas",tubeout_datas)
            console.log("------------------------sky:测试输出------------------------")
//------------------------sky:测试输出------------------------

        }



    }

    CustomDialog{
        id:toast_dialog
        title: "无线数据导入"

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
 /*                   Flickable{
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
*/                }
                Item{
                    width: itemContent.width
                    height: itemContent.height-100
/*                    Text{
                        id:currentPortNameDisplayText
                        anchors.horizontalCenter: parent.horizontalCenter
                        y:20
                        text:"当前选择的串口:"+portModel.get(currentPortIndex).portName
                        color:"#ffffff"
                        font.pointSize: 25
                    }
*/
                    TextArea{
                        width: parent.width-60
                        height: 200
                        anchors.centerIn: parent
                        id:messageText
                        text:""
                        font.pointSize: 20
                        backgroundVisible: false
                        readOnly: true
                        textColor: "#ffffff"
                        cursorPosition: text.length
                    }
                }

/*                Item{
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
                                                                          :
                                                                            "  请选择Rola接收器串口对应的串口，然后再按下开始接收按钮，系统会自动接收遥控器发来的数据，直到接收完毕，如果没有找到串口号，请检擦Rola接收器是否正常安装驱动。如果不知道哪个串口对应Rola接收器的，可以先拔出usb线，然后点击导入数据按钮查看串口第一次，然后关闭对话框，重新插入usb线，再点击导入数据按钮查看串口第二次，如果第二次出现了第一次查看串口时没有的串口名，说明这就是对应Rola接收器的串口！或者在系统中查看串口。";
                                    }
                                }
                                else{
                                    serialPortManager.closeSerialPort();
                                    messageText.text =readyReciveData?"   正在接收数据中，请用遥控器发送数据到Rola接收器"
                                                                     :
                                                                       "  请选择Rola接收器串口对应的串口，然后再按下开始接收按钮，系统会自动接收遥控器发来的数据，直到接收完毕，如果没有找到串口号，请检擦Rola接收器是否正常安装驱动。如果不知道哪个串口对应Rola接收器的，可以先拔出usb线，然后点击导入数据按钮查看串口第一次，然后关闭对话框，重新插入usb线，再点击导入数据按钮查看串口第二次，如果第二次出现了第一次查看串口时没有的串口名，说明这就是对应Rola接收器的串口！或者在系统中查看串口。";
                                    data_resend_time=1;
                                }
                            }
                        }
                    }
                }
*/            }


        }


    }
}
