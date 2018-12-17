import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

//foruance num selector
ComboBox{
    width: 120
    height: 30
//    anchors.verticalCenter: compareBnt.verticalCenter
    property string borderColor:"#dadada"
    property string bgColor: "#f6f6f6"
    property int borderWidth:1
    property string fontColorNormal: '#333333'
    property string fontColorTip: "#999999"
//    model: ListModel{
//        Component.onCompleted: {
//            for(var a = 0; a<11; a++){
//                append({
//                           "text":"H1"+Number(a+10).toString()
//                       });
//            }
//        }
//    }
    style: ComboBoxStyle{
        font.pixelSize:18
        textColor: fontColorNormal
        selectionColor: "#12eeff"
        selectedTextColor: "white"
        background: Rectangle{
            width: control.width
            height: control.height
            border.width: 1
            border.color: borderColor
            Image {
                id:etcImg
                source: "qrc:/imgs/icons/etc.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 5
            }
            Rectangle{
                width: 1
                height: parent.height
                anchors.right: etcImg.left
                anchors.rightMargin: 5
                color: borderColor
            }
        }
    }
}
