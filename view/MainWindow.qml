import QtQuick 2.0
import "./bar"
//功能选择栏
Item {
    id:mainWindow

    property var pages:[]
    ListModel{
        id:menuList
    }
    Component.onCompleted: {

        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/date-input.png",
                            "selected":true,
                            "title":"数据导入",
                            "content":"qrc:/view/page/DataImportPage.qml"
                        });

        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/search.png",
                            "selected":false,
                            "title":"数据查询",
                            "content":"qrc:/view/page/DataSearchPage.qml"
                        });
        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/compare.png",
                            "selected":false,
                            "title":"管管比较",
                            "content":"qrc:/view/page/TubesComparePage.qml"
                        });
        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/diagnosis.png",
                            "selected":false,
                            "title":"结焦诊断",
                            "content":"qrc:/view/page/DiagnosePage.qml"
                        });
        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/presure.png",
                            "selected":false,
                            "title":"压力数据导入",
                            "content":"qrc:/view/page/PressureDataImportPage.qml"
                        });
        if(server.currentUserAccess === 1)
            menuList.append({
                                "imgSrc":"qrc:/imgs/icons/user.png",
                                "selected":false,
                                "title":"用户管理",
                                "content":"qrc:/view/page/UserManagerPage.qml"
                            });
        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/setting.png",
                            "selected":false,
                            "title":"参数信息",
                            "content":"qrc:/view/page/SettingPage.qml"
                        });
        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/message.png",
                            "selected":false,
                            "title":"版本信息",
                            "content":"qrc:/view/page/MessagePage.qml"
                        });
    }

    Row{
        anchors.fill: parent
        LeftBar{
            id:leftbar
            width: 150
            height: parent.height
            dataModel: menuList
            onIndexChanged: {
                loader.source = menuList.get(index).content
            }
        }
        Loader{
            id:loader
            width: parent.width-leftbar.width
            height:parent.height
            source: "qrc:/view/page/DataImportPage.qml"
        }
    }
}
