import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id:plainTextEdit
    property string text;
    property int fontSize: 14
    property int pwidth: 60
    property int pheight: 25
    property int pradius: 2
    property string focuscolor:"#9912eeff"
    property string non_focuscolor:"#99ffffff"
    property string ptextcolor: "#aaaaaa"
    property string p_placeholderTextColor: "#999999"
    property string bgcolor: "#00000000"
    property int pborderwidth: 1
    property string holderText: ""
    property var echoMode: TextInput.Normal

    signal finished();

    width: pwidth
    height: pheight


    TextField{
        anchors.fill: parent
        font.pixelSize: fontSize
        text: plainTextEdit.text
        verticalAlignment:TextInput.AlignVCenter
        horizontalAlignment: TextInput.AlignHCenter
        onTextChanged: plainTextEdit.text = text;
        onFontChanged: plainTextEdit.text = text;
        echoMode: plainTextEdit.echoMode

        placeholderText : plainTextEdit.holderText
        style: TextFieldStyle{
            textColor: ptextcolor

            placeholderTextColor: p_placeholderTextColor
            background: Rectangle {
                color: bgcolor
                implicitWidth: plainTextEdit.width
                implicitHeight: plainTextEdit.height
                border.color: control.activeFocus? focuscolor : non_focuscolor
                border.width: pborderwidth
                radius: pradius
            }
        }
        onEditingFinished: {
            plainTextEdit.text = text;
            finished();
        }
    }

}
