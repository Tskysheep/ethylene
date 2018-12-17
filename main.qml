import QtQuick 2.4
import QtQuick.Controls 1.4
import "./view"
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

ApplicationWindow {
    property int windowWidth: Screen.desktopAvailableWidth*0.8
    property int windowHeight: Screen.desktopAvailableHeight*0.8
    id:mainWin
    title: "乙烯裂解炉管外表面温度监测与智能分析系统"
    visible: true
    width: windowWidth
    height: windowHeight
    minimumHeight: windowHeight
    minimumWidth: windowWidth

    //Main Window
    //MainWindow.qml作为控件被包裹进来
    MainWindow{
        anchors.fill: parent
    }
    //软件顶部的工具栏
    menuBar: MenuBar {
        Menu {
            title: "用户"
            MenuItem {
                text: "注销登陆"
                onTriggered: {
                    server.logOut();
                    close();
                }
            }
        }
    }
}
