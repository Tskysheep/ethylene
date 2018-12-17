import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.0

ApplicationWindow {
    property int windowWidth: Screen.desktopAvailableWidth*0.8
    property int windowHeight: Screen.desktopAvailableHeight*0.8
    id:mainWin
    Rectangle{
        id:mainRec
        width: mainRow.width
        height: mainRow.height

        Row{
            id:mainRow
            height: bg.height
            Rectangle{
                width: 300
                height: bg.height

            }

            Image {
                id: bg
                source: "qrc:/imgs/icons/login_bg.jpg"
            }
        }
    }
}
