import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id:plainTextEdit
    property string text;
    property int fontSize: 14
    property int pwidth: 60
    property int pheight: 25
    property string holderText: ""
    property var echoMode: TextInput.Normal

    signal finished();

    width: pwidth
    height: pheight


    TextField{
        anchors.fill: parent
        font.pixelSize: fontSize
        text: plainTextEdit.text
        verticalAlignment:TextInput.AlignBottom
        horizontalAlignment: TextInput.AlignHCenter
        onTextChanged: plainTextEdit.text = text;
        onFontChanged: plainTextEdit.text = text;
        echoMode: plainTextEdit.echoMode

        placeholderText : plainTextEdit.holderText
        style: TextFieldStyle{
            textColor: "#aaaaaa"

            placeholderTextColor: "#999999"
            background: Rectangle {
                color: "#00000000"
                implicitWidth: plainTextEdit.width
                implicitHeight: plainTextEdit.height
                border.color: control.activeFocus?"#9912eeff":"#99ffffff"
                border.width: 1
                radius: 2
            }
        }
        onEditingFinished: {
            plainTextEdit.text = text;
            finished();
        }
    }

}
