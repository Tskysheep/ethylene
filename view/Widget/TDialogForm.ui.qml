import QtQuick 2.4
import QtQuick.Controls 1.5


    CustomDialog {
        id: customDialog
        width: 400
        height: 400

        Button {
            id: button
            x: 195
            y: 403
            width: 121
            height: 23
            text: qsTr("Button")
            clip: true
            enabled: true
            visible: true
        }
    }
