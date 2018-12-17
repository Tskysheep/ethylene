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

    id:mainWin
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
}
