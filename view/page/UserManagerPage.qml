import QtQuick 2.0
import "../Widget"
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id:root
    anchors.fill: parent

    function refreshData(){
        userModel.clear();
        var users = server.usersList();

        for(var a = 0; users.length; a++){
            console.log(users[a].userAccess);
            userModel.append({
                       "userName":users[a].userName,
                       "userPwd":users[a].userPwd,
                       "userAccess":users[a].userAccess,
                       "userNameEditting":false,
                       "userPwdEditting":false,
                       "userId":users[a].userId
                   });
        }
    }
    //用户信息列表
    ListModel{
        id: userModel
        Component.onCompleted: {
            refreshData();
        }
    }

    Column{
        anchors.fill: parent

        //header
        Item{
            width: parent.width-20
            height: 50
            id: header
            anchors.horizontalCenter: parent.horizontalCenter

            //header
            Row{
                anchors.fill: parent
                Rectangle{
                    width: parent.width/3
                    height: parent.height
                    color: "#344750"

                    RoundIconButton{
                        anchors.centerIn: parent
                        textSize: 20
                        text: "用户"
                        imgSrc: "qrc:/imgs/icons/icon_user.png"
                        height: 50
                        enabled: false
                    }

                    Image {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 25
                        source: bntUserAdd.containsMouse?"qrc:/imgs/icons/button_user_add_hover.png":"qrc:/imgs/icons/button_user_add_normal.png"
                        MouseArea{
                            anchors.fill: parent
                            id:bntUserAdd
                            hoverEnabled: true
                            onClicked: {
                                addUserDialog.open();
                            }
                        }
                    }

                }

                Rectangle{
                    width: parent.width/3
                    height: parent.height
                    color: "#344750"

                    RoundIconButton{
                        anchors.centerIn: parent
                        textSize: 20
                        text: "密码"
                        imgSrc: "qrc:/imgs/icons/icon_user_pwd-password-.png"
                        height: 50
                        enabled: false
                    }
                    Rectangle{
                        width: 1
                        height: parent.height
                    }
                }

                Rectangle{
                    width: parent.width/3
                    height: parent.height
                    color: "#344750"
                    RoundIconButton{
                        anchors.centerIn: parent
                        textSize: 20
                        text: "操作权限"
                        imgSrc: "qrc:/imgs/icons/icon_user_access.png"
                        height: 50
                        enabled: false
                    }
                    Rectangle{
                        width: 1
                        height: parent.height
                    }
                }

            }
        }

        //
        Rectangle{
            width: parent.width - 20
            height: parent.height - header.height
            border.width: 1
            border.color: "#aaaaaa"
            anchors.horizontalCenter: parent.horizontalCenter
            Flickable{
                id:contnetFlic
                width: parent.width - 2
                height: parent.height - 2
                anchors.centerIn: parent
                clip: true
                contentHeight: gridContent.height
                contentWidth: gridContent.width
                anchors.horizontalCenter: parent.horizontalCenter
                boundsBehavior: Flickable.DragOverBounds
                flickableDirection: Qt.Vertical

                Item{
                    id:gridContent
                    height: gridCol.height
                    width: root.width - 20

                    Column{
                        id:gridCol
                        width: parent.width

                        Repeater{
                            model:userModel
                            delegate: Rectangle{
                                width: gridContent.width
                                height: 40
                                color: index%2 === 0? "#eef4f7":"white"

                                Row{
                                    anchors.fill: parent

                                    //user name
                                    Item{
                                        width: parent.width/3
                                        height: parent.height
                                        id:userNameItem

                                        Row{
                                            anchors.centerIn: parent
                                            spacing: 10
                                            TextField{
                                                id:userNameTextEditor
                                                text: userName
                                                font.pixelSize: 16
                                                width: userNameItem.width/2
                                                height: 30
                                                textColor:activeFocus?"#12aadf":"454545"
                                                enabled: userNameEditting

                                                style: TextFieldStyle{
                                                    background: Rectangle{
                                                        width: control.width
                                                        height: control.height
                                                        color: "#00000000"
                                                        Rectangle{
                                                            width: parent.width
                                                            height: 1
                                                            anchors.bottom: parent.bottom
                                                            color: "#12aaef"
                                                            visible: control.activeFocus
                                                        }
                                                    }
                                                }
                                            }

                                            //user password
                                            Image {
                                                source: "qrc:/imgs/icons/modify.png"
                                                anchors.verticalCenter: parent.verticalCenter
                                                MouseArea{
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        for(var a = 0; a<userModel.count;a ++){
                                                            if(a === index)
                                                                continue;
                                                            userModel.setProperty(a,"userPwdEditting",false);
                                                            userModel.setProperty(a,"userNameEditting",false);
                                                        }

                                                        if(userNameEditting){
                                                            userModel.setProperty(index,"userNameEditting",false);
                                                            root.forceActiveFocus();
                                                            //加修改函数
                                                            server.updateUser(userNameTextEditor.text,userPwd,userAccess,userId);
//                                                            userNameTextEditor.enabled = false;
                                                        }
                                                        else{
                                                            userModel.setProperty(index,"userNameEditting",true);
//                                                            userNameTextEditor.enabled = true;
                                                            userNameTextEditor.forceActiveFocus();
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    //user password
                                    Item{
                                        width: parent.width/3
                                        height: parent.height
                                        id:userPwdItem

                                        Row{
                                            anchors.centerIn: parent
                                            spacing: 10
                                            TextField{
                                                id:userPwdTextEditor
                                                text: userPwd
                                                font.pixelSize: 16
                                                width: userPwdItem.width/2
                                                height: 30
                                                enabled: userPwdEditting
                                                textColor:activeFocus?"#12aadf":"454545"
                                                echoMode: TextInput.Password

                                                style: TextFieldStyle{
                                                    background: Rectangle{
                                                        width: control.width
                                                        height: control.height
                                                        color: "#00000000"
//
                                                        Rectangle{
                                                            width: parent.width
                                                            height: 1
                                                            anchors.bottom: parent.bottom
                                                            color: "#12aaef"
                                                            visible: control.activeFocus
                                                        }
                                                    }
                                                }
                                            }
                                            //修改按钮
                                            Image {
                                                source: "qrc:/imgs/icons/modify.png"
                                                anchors.verticalCenter: parent.verticalCenter
                                                MouseArea{
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        for(var a = 0; a<userModel.count;a ++){
                                                            if(a === index)
                                                                continue;
                                                            userModel.setProperty(a,"userPwdEditting",false);
                                                            userModel.setProperty(a,"userNameEditting",false);
                                                        }


                                                        if(userPwdEditting){
                                                            userModel.setProperty(index,"userPwdEditting",false);
                                                            root.forceActiveFocus();
                                                            server.updateUser(userName,userPwdTextEditor.text,userAccess,userId);
                                                        }
                                                        else{
                                                            userModel.setProperty(index,"userPwdEditting",true);
                                                            userPwdTextEditor.forceActiveFocus();
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    Item{
                                        width: parent.width/3
                                        height: parent.height
                                        id:userAccessItem

                                        CustomComboBox{
                                            anchors.right: parent.right
                                            anchors.rightMargin: 20
                                            anchors.centerIn: parent
                                            model: ["普通","管理员"]
                                            currentIndex: userAccess
                                            onActivated: {
                                                userModel.setProperty(index,"userAccess",index);

                                                server.updateUser(userName,userPwd,Number(index).toString(),userId);
                                                refreshData();
                                            }

                                        }

                                        Rectangle{
                                            anchors.centerIn: iconUserDelete
                                            radius: 2
                                            color: "#ff9912"
                                            width: 30
                                            height: 30
                                            scale: iconUserDelete.scale
                                            MouseArea{
                                                anchors.fill: parent
                                                id:bntUserDelete
                                                hoverEnabled: true
                                                onClicked: {
//                                                    userModel.remove(index)
                                                    var result = server.removeUser(userName);
                                                    console.log("remove user:",result);
                                                    refreshData();
                                                }
                                            }
                                        }

                                        Image {
                                            id:iconUserDelete
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.rightMargin: 20
                                            scale: bntUserDelete.containsMouse?1.1:1
                                            source: "qrc:/imgs/icons/button_delete.png"
                                            width: 15
                                            height: 15
                                            Behavior on scale{
                                                PropertyAnimation{
                                                    properties: "scale"
                                                    duration: 200
                                                    easing.type: Easing.OutBack
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
//添加新用户对话框
    CustomDialog{
        id:addUserDialog
        title: "添加新用户"
        content:Item{
            width: 500
            height: 300
            id: dialogContent
            property string userName;
            property string userPwd;
            property string userRPwd;
            property string access:"0"

            Column{
                anchors.centerIn: parent
                spacing: 25

                TextField{

                    font.pixelSize: 16
                    width: 250
                    height: 30
                    textColor:activeFocus?"#12aadf":"454545"
                    placeholderText: "输入用户名"
                    horizontalAlignment: TextInput.AlignHCenter
                    onTextChanged:{
                        dialogContent.userName = text;
                    }

                    style: TextFieldStyle{
                        background: Rectangle{
                            width: control.width
                            height: control.height
                            color: "#00000000"
                            Rectangle{
                                width: parent.width
                                height: 1
                                anchors.bottom: parent.bottom
                                color: control.activeFocus?"#12aaef":"#555555"
//                                visible: control.activeFocus
                            }
                        }
                    }
                }

                TextField{
                    font.pixelSize: 16
                    width: 250
                    height: 30
                    textColor:activeFocus?"#12aadf":"454545"
                    placeholderText: "输入用密码"
                    echoMode:  TextInput.Password
                    horizontalAlignment: TextInput.AlignHCenter
                    onTextChanged:{
                        dialogContent.userPwd = text;
                    }

                    style: TextFieldStyle{
                        background: Rectangle{
                            width: control.width
                            height: control.height
                            color: "#00000000"
                            Rectangle{
                                width: parent.width
                                height: 1
                                anchors.bottom: parent.bottom
                                color: control.activeFocus?"#12aaef":"#555555"
//                                visible: control.activeFocus
                            }
                        }
                    }
                }

                TextField{
                    font.pixelSize: 16
                    width: 250
                    height: 30
                    textColor:activeFocus?"#12aadf":"454545"
                    placeholderText: "再输入用密码"
                    echoMode:  TextInput.Password
                    horizontalAlignment: TextInput.AlignHCenter
                    onTextChanged:{
                        dialogContent.userRPwd = text;
                    }

                    style: TextFieldStyle{
                        background: Rectangle{
                            width: control.width
                            height: control.height
                            color: "#00000000"
                            Rectangle{
                                width: parent.width
                                height: 1
                                anchors.bottom: parent.bottom
                                color: control.activeFocus?"#12aaef":"#555555"
//                                visible: control.activeFocus
                            }
                        }
                    }
                }

                CustomComboBox{
                    model: ["普通","管理员"]
                    anchors.horizontalCenter: parent.horizontalCenter
                    onActivated: {
                        dialogContent.access = Number(index).toString();
                    }
                }

            }

        }
        onAccepted: {
            if(dialogContent.userName ===""||
                    dialogContent.userPwd==="")
                return;

            if(dialogContent.userPwd === dialogContent.userRPwd){
                server.addUser(dialogContent.userName,dialogContent.userPwd,dialogContent.access);
                refreshData();
            }
        }
        onRejected: {

        }
    }
}
