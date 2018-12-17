import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id:root
    property int minValue:500
    property int maxValue:2000
    property var orientation: Qt.Horizontal
    property int value: 700
    property string text;
    width: 300
    height: 40

    Column{
        anchors.fill: parent
        spacing: 5

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 14
            text: root.text
            color: "#454545"
        }

        Slider{
            id: slider
            orientation: root.orientation
            width: parent.width
            height: 6
            value: root.value
            minimumValue: root.minValue
            maximumValue: root.maxValue
            onValueChanged:{
                root.value = value;
            }

            style: SliderStyle{
                groove: Rectangle {
                    implicitWidth: control.width
                    implicitHeight: control.height
                    color: "#aaaaaa"
                    radius: height/2
                    clip: true
                    Rectangle{
                        height: parent.height
                        radius: height/2
                        color: "#344750"
                        width: styleData.handlePosition
                    }
                }
                handle: Rectangle {
                    anchors.centerIn: parent
                    color: "#344750"
                    implicitWidth: 20
                    implicitHeight: 20
                    radius: height/2
                }
            }
        }

    }
}
