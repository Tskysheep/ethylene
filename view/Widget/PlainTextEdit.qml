import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id:plainTextEdit
    property string text;
    property int fontSize: 14
    property int pwidth: 60
    property int pheight: 25
    property int maxNumber:9999
    property int minNumber: 0

    signal finished();

    width: pwidth
    height: pheight


    TextField{
        anchors.fill: parent
        font.pixelSize: fontSize
        text: plainTextEdit.text
        verticalAlignment:TextInput.AlignBottom
        horizontalAlignment: TextInput.AlignHCenter
        validator: IntValidator {bottom: minNumber; top: maxNumber;}
        onTextChanged: plainTextEdit.text = text;
        onFontChanged: plainTextEdit.text = text;
        style: TextFieldStyle{
            textColor: "#333333"
            background: Rectangle {
                implicitWidth: plainTextEdit.width
                implicitHeight: plainTextEdit.height
                border.color: control.activeFocus?"#4577ee":"#666666"
                border.width: 1
                radius: 5
            }
        }
        onEditingFinished: {
            plainTextEdit.text = text;
            finished();
        }
    }

}
