import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import "./view/Widget"
import QtQuick.Layouts 1.3
//登录页面
ApplicationWindow {
    property int windowWidth: Screen.desktopAvailableWidth*0.8
    property int windowHeight: Screen.desktopAvailableHeight*0.8
    property bool isAdmin: false
    property alias more_set_Dialog: more_set_Dialog
    property alias mainRec: mainRec

    property string m_dbtype : ""
    property string m_ip : ""
    property string m_dbname : ""
    property string m_dbport : ""

    property string m_local_dbtype : ""
    property string m_local_ip : ""
    property string m_local_dbname : ""
    property string m_local_dbuser : ""
    property string m_local_dbpwd: ""

    property int currentPortIndex: 0

    id:mainWin
    title: "裂解炉管智能结焦诊断系统"
    visible: true

    onIsAdminChanged: {
        adminCheck.checked = isAdmin;
        guestCheck.checked = !isAdmin;
    }
    //登录
    function login(username,passwd,access){
        if(server.login(username,passwd,access)){
            mainWin.close();
            return true;
        }
        else{
            //todo
            return false;
        }
    }

    Component.onCompleted: {
        var json = utils.readMoreInfo()
        if(json !== ""){
            //["dbtype","ip","dbname","dbport"]
            var jsobj = JSON.parse(json)
            m_dbtype = jsobj.db_type
            m_ip = jsobj.db_ip
            m_dbname = jsobj.db_name
            m_dbport = jsobj.db_port

            m_local_dbtype = jsobj.local_dbtype
            m_local_ip = jsobj.local_ip
            m_local_dbname = jsobj.local_dbname
            m_local_dbuser = jsobj.local_dbuser
            m_local_dbpwd = jsobj.local_dbpwd
        }
        db_type_input.text = m_dbtype
        db_ip_input.text = m_ip
        db_name_input.text = m_dbname
        db_port_input.text = m_dbport

        localdb_type_input.text = m_local_dbtype
        localdb_ip_input.text = m_local_ip
        localdb_name_input.text = m_local_dbname
        localdb_user_input.text = m_local_dbuser
        localdb_pwd_input.text = m_local_dbpwd

    }


    Rectangle{
        id:mainRec
        height: mainRow.height
        width: mainRow.width

        Row{
            id:mainRow
            height: bg.height

            Rectangle{
                width: 300
                height: bg.height
                color: "#152b44"

                Column{
                    id:login_info_col
                    anchors.centerIn: parent
                    spacing: 20
                    //input
                    Item{
                        id:userNameInputItem
                        width: userInputRow.width
                        height: iconUser.height

                        Row{
                            id:userInputRow
                            spacing: 15
                            Image {
                                id:iconUser
                                source: "qrc:/imgs/icons/icon_user.png"
                                width: 25
                                height: width
                            }

                            FormTextEdit{
                                id:userNameTextEdit
                                width: 200
                                height: iconUser.height
                                holderText: "输入用户名"
                            }
                        }
                    }

                    Item{
                        id:userPwdInputItem
                        width: pwdInputRow.width
                        height: iconPwd.height

                        Row{
                            id: pwdInputRow
                            spacing: 15
                            Image {
                                id:iconPwd
                                source: "qrc:/imgs/icons/icon_user_pwd-password-.png"
                                width: 25
                                height: width
                            }

                            FormTextEdit{
                                id: userPwdTextEdit
                                width: 200
                                echoMode: TextInput.Password;//隐藏密码
                                height: iconPwd.height
                                holderText: "输入密码"
                            }
                        }
                    }

                    //line
                    Rectangle{
                        width: 250
                        height: 1
                        color: "#aaaaaa"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    //CheckBox
                    Item{
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: checkboxRow.width
                        height: 20

                        Row{
                            id: checkboxRow
                            spacing: 15

                            CheckBox{
                                checked: false
                                id: adminCheck
                                onCheckedChanged: {
                                    if(checked)
                                        isAdmin = true;
                                }
                            }

                            Text{
                                text:"管理员   "
                                font.pixelSize: 14
                                color: "#aaaaaa"
                            }

                            CheckBox{
                                checked: true
                                id: guestCheck
                                onCheckedChanged: {
                                    if(checked)
                                        isAdmin = false;
                                }
                            }

                            Text{
                                text:"普通用户"
                                font.pixelSize: 14
                                color: "#aaaaaa"
                            }
                        }
                    }

                    //confirm button
                    Rectangle{

                        width: 150
                        height: 40
                        anchors.horizontalCenter: parent.horizontalCenter
                        color:comfirmma.containsMouse?"#ff12eeff":"#aa12eeff"
                        Text{
                            anchors.centerIn: parent
                            font.pixelSize: 22
                            text: "登陆"
                            color: "#ffffff"
                        }

                        MouseArea{
                            id:comfirmma
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                var access;
                                if(isAdmin)
                                    access = Number(1).toString();
                                else
                                    access = Number(0).toString();
                                var result = login(userNameTextEdit.text,userPwdTextEdit.text,access);
                                if(!result)
                                    messageDialog.open();
                            }
                        }
                    }
                }

                Item {
                    width: more_setting.width
                    height: more_setting.height
                    anchors.top:login_info_col.bottom
                    anchors.topMargin: 5
                    anchors.right: login_info_col.right
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: more_setting
                        anchors.right: parent.right
                        text: "更多设置？"
                        color:"#aa12eeff"
                        font.pixelSize: 15

                    }

                    MouseArea{
                        id:more_set_ma
                        anchors.fill: parent
                        hoverEnabled: true //悬浮使能
                        onHoveredChanged:{//当悬浮改变时，判断鼠标是否在次区域，根据此改变Text 的字体颜色
                            if(more_set_ma.containsMouse){
                                more_setting.color = "#ffffff"
                            }else{
                               more_setting.color = "#aa12eeff"
                            }

                        }

                        onClicked: {
                            console.log("更多设置")
                            more_set_Dialog.open()
                        }
                    }

                }

            }

            Image {
                id: bg
                source: "qrc:/imgs/icons/login_bg.jpg"
                width: 800
                height: sourceSize.height*width/sourceSize.width
            }
        }
    }

    CustomDialog{
        id:messageDialog
        title: "登陆错误"
        content: Item{
            width: 500
            height: 100
            Text{
                anchors.centerIn: parent
                font.pixelSize: 20
                text: "您的账号或密码输入有误，请重新输入"
                color: "#444444"
            }
        }
        onAccepted: {
            userNameTextEdit.text = "";
            userPwdTextEdit.text = "";
        }
    }

    CustomDialog{
        id:more_set_Dialog
        title: "更多设置"
        content:Item{
            id:more_root
            anchors.fill: parent

            Rectangle{
                //背景
                anchors.fill: parent
                color: "#152b44"
            }

            ScrollView{

                anchors.fill: parent
                verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

                Column{
                    id:more_set_input_col
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    spacing: 20
                    Item {
                        //占空
                       height: 1
                       width: parent.width
                    }
                    Text {
                        horizontalAlignment: Text.AlignHCenter
                        width: db_type_row.width
                        text:"远程数据库设置"
                        color: "white"
                        font.pixelSize: 25
                    }
                    Row{
                        id:db_type_row
                        Text {
                            text: "远程数据库类型："
                            height: 25
                            color: "white"
                            font.pixelSize: 20
                        }
                        FormTextEdit{
                            id:db_type_input
                            width: 250
                            height: 25
                            text: m_dbtype
                            //fontfamily: "Source Code Pro"
                            //holderText:m_dbtype
                        }
                    }

                    Row{
                        id:db_ip_row
                        Text {
                            text: "远程数据库地址："
                            height: 25
                            color: "white"
                            font.pixelSize: 20
                        }
                        FormTextEdit{
                            id:db_ip_input
                            width: 250
                            height: 25
                            text: m_ip
                            //fontfamily: "Source Code Pro"
                            //holderText: m_ip
                        }

                    }

                    Row{
                        id:db_name_row
                        Text {
                            text: "远程数据库名称："
                            height: 25
                            color: "white"
                            font.pixelSize: 20
                        }
                        FormTextEdit{
                            id:db_name_input
                            width: 250
                            height: 25
                            text: m_dbname
                            //fontfamily: "Source Code Pro"
                            //holderText: m_dbname
                        }
                    }

                    Row{
                        id:db_port_row
                        Text {
                            text: "远程数据库端口："
                            height: 25
                            color: "white"
                            font.pixelSize: 20
                        }
                        FormTextEdit{
                            id:db_port_input
                            width: 250
                            height: 25
                            text: m_dbport
                            //fontfamily: "Source Code Pro"
                            //holderText: m_dbport
                        }
                    }

                    Text {
                        horizontalAlignment: Text.AlignHCenter
                        width: db_type_row.width
                        text:"本地数据库设置"
                        color: "white"
                        font.pixelSize: 25
                    }
                    Row{
                        id:localdb_type_row
                        Text {
                            text: "本地数据库类型："
                            height: 25
                            color: "white"
                            font.pixelSize: 20
                        }
                        FormTextEdit{
                            id:localdb_type_input
                            width: 250
                            height: 25
                            text: m_local_dbtype
                            //fontfamily: "Source Code Pro"
                            //holderText:m_local_dbtype
                        }
                    }

                    Row{
                        id:localdb_ip_row
                        Text {
                            text: "本地数据库地址："
                            height: 25
                            color: "white"
                            font.pixelSize: 20
                        }
                        FormTextEdit{
                            id:localdb_ip_input
                            width: 250
                            height: 25
                            text: m_local_ip
                            //fontfamily: "Source Code Pro"
                            //holderText: m_local_ip
                        }

                    }

                    Row{
                        id:localdb_name_row
                        Text {
                            text: "本地数据库名称："
                            height: 25
                            color: "white"
                            font.pixelSize: 20
                        }
                        FormTextEdit{
                            id:localdb_name_input
                            width: 250
                            height: 25
                            text: m_local_dbname
                            //fontfamily: "Source Code Pro"
                            //holderText: m_local_dbname
                        }
                    }

                    Row{
                        id:localdb_port_row
                        Text {
                            text: "本地数据库用户："
                            height: 25
                            color: "white"
                            font.pixelSize: 20
                        }
                        FormTextEdit{
                            id:localdb_user_input
                            width: 250
                            height: 25
                            text: m_local_dbuser
                            //fontfamily: "Source Code Pro"
                            //holderText: m_local_dbuser
                        }
                    }


                    Row{
                        id:localdb_pwd_row
                        Text {
                            text: "本地数据库密码："
                            height: 25
                            color: "white"
                            font.pixelSize: 20
                        }
                        FormTextEdit{
                            id:localdb_pwd_input
                            width: 250
                            height: 25
                            text: m_local_dbpwd
                            //holderText: m_local_dbpwd
                            echoMode: TextInput.Password
                        }
                    }

                    Text {
                        id:portSelectShow
                        horizontalAlignment: Text.AlignHCenter
                        width: db_type_row.width
                        text:"串口选择"
                        color: "white"
                        font.pixelSize: 25
                    }

                    Rectangle{
                        width: parent.width
                        height: 40
                        color: "#454545"
                        Flickable{
                            anchors.fill: parent
                            contentWidth: portrow.width
                            Row{
                                id:portrow
                                Repeater{
                                    model: portModel
                                    delegate:CheckButton {
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
                                            //设置串口
                                            //.setPortName(portName);
                                            globalPort.setPortName(portName)

                                            portSelectShow.text = "串口选择"+"(当前选择串口："+portModel.get(currentPortIndex).portName+")" //设置提示
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        //占空
                       height: 1
                       width: parent.width
                    }
                }

            }

        }

            onAccepted: {
            console.log(db_type_input.text,db_ip_input.text,db_name_input.text,db_port_input.text)
            console.log(localdb_type_input.text,localdb_ip_input.text,localdb_name_input.text,localdb_user_input.text)
            var more_info_json = new Object();
            more_info_json.db_type = db_type_input.text.toUpperCase()
            more_info_json.db_ip = db_ip_input.text
            more_info_json.db_name = db_name_input.text
            more_info_json.db_port = db_port_input.text
            more_info_json.local_dbtype = localdb_type_input.text.toLocaleUpperCase()
            more_info_json.local_ip = localdb_ip_input.text
            more_info_json.local_dbname = localdb_name_input.text
            more_info_json.local_dbuser = localdb_user_input.text
            more_info_json.local_dbpwd = localdb_pwd_input.text

            utils.saveMoreInfo(JSON.stringify(more_info_json,["db_type","db_ip","db_name","db_port","local_dbtype","local_ip","local_dbname","local_dbport","local_dbpwd"],"\n"))
        }
    }

    ListModel{
        id:portModel
        Component.onCompleted: {
            for(var a = 0; a < globalPort.getSerialPortsNum(); a++){
                var portname = String(globalPort.getSerialPortName(a))
                portModel.append({
                                     "portName":portname,
                                     "isSelected":false
                                 });
                setProperty(0,"isSelected",true);
            }
            portSelectShow.text = "串口选择"+"(当前选择串口："+portModel.get(currentPortIndex).portName+")"
            if(portModel.count > 0) globalPort.setPortName(portModel.get(currentPortIndex).portName)
        }

    }

}
