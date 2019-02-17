import QtQuick 2.0
import "../Widget"
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    height:1000
    width:1000
    property date globalDate: new Date();

    Rectangle{
        width: parent.width
        height: 155
        color: "#ECF5FA"

        Row{
            anchors.fill: parent
            Item {
                height: row1.height
                width: row1.width
                anchors.centerIn: parent
                Row{
                    id:row1
                    spacing: 30

                    Text{
                        text: "日期"
                        font.pixelSize: 20
                        anchors.verticalCenter: parent.verticalCenter

                    }

                    Text{
                        text: globalDate.toLocaleDateString(Qt.local,"yyyy/MM/dd")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 20
                        color: "#3E3E3E"
                        Rectangle{
                            width: parent.width+30
                            height: parent.height+5
                            anchors.centerIn: parent
                            radius: height/2
                            color: "#00000000"
                            border.width: 1
                            border.color: "#CECDCD"
                        }
                    }


                    Image {
                        source: "qrc:/imgs/icons/button_calendar_press.png"
                        anchors.verticalCenter: parent.verticalCenter
                        scale: bntCalendar.containsMouse?1.05:1
                        Behavior on scale{
                            PropertyAnimation{
                                property:"scale"
                                duration: 200
                                easing.type: Easing.OutBack
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            id: bntCalendar
                            hoverEnabled: true
                            onClicked: {
                                //TODO
                                calendarDialog.open();
                            }
                        }
                    }
                }

            }

            Item {
                height: row2.height
                width: row2.width
                anchors.centerIn: parent
                Row{
                    id:row2
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10
                    Text{
                        text: "炉号:"
                        font.pixelSize: 20
                        color: "#454545"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    ForanceNumComboBox{
                        id:foranceNumComboBox
                    }
                }


            }
        }
    }


    CustomDialog{
        id:calendarDialog
        title: "选择日期"
        content:Calendar{
            id:calendar
            anchors.fill: parent
        }
        onAccepted: {
            globalDate = calendar.selectedDate;
        }
    }

}
