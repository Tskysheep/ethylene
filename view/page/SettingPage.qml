import QtQuick 2.0
import QtQuick.Dialogs 1.0
import "../Widget"
//相关参数(警戒温度, 备份周期等)录入页
Rectangle {
    id:root
    anchors.fill: parent

    Rectangle{
        anchors.centerIn: parent
        width: 550
        height: 600
        border.width: 1
        border.color: "#cccccc"
        radius: 2

        Column{
            y:60
            x:30
            spacing: 15

            Item{
                id:tubeInSettingItem
                width: tubeInSettingRow.width
                height: 60
                //tube in alert temp setting
                Row{
                    id:tubeInSettingRow
                    spacing: 15
                    anchors.verticalCenter: parent.verticalCenter
                    Image{
                        source: "qrc:/imgs/icons/icon_tube_in.png"
                    }

                    ESlider{
                        id:tubeInSlider
                        text: "入管警戒温度"
                        value: 840
                        anchors.verticalCenter: parent.verticalCenter
                        onValueChanged: {
                            tubeInTempEdit.text = value
                            console.log("noshow");
                            saveButton.noshow=false;
                        }

                    }

                    PlainTextEdit{
                        id:tubeInTempEdit
                        anchors.verticalCenter: parent.verticalCenter
                        text: tubeInSlider.value
                        enabled: true
                        maxNumber: 2000
                        minNumber: 500
                        onFinished: {
                            tubeInSlider.value = text;
                        }
                    }

                    Text{
                        text: "℃"
                        font.pixelSize: 16
                        color: "#454545"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Item{
                id: tubeOutSettingItem
                width: tubeOutSettingRow.width
                height: 60
                //tube out alert temp setting
                Row{
                    id:tubeOutSettingRow
                    spacing: 15
                    anchors.verticalCenter: parent.verticalCenter
                    Image{
                        source: "qrc:/imgs/icons/icon_tube_out.png"
                    }

                    ESlider{
                        id:tubeOutSlider
                        text: "出管警戒温度"
                        value: 840
                        anchors.verticalCenter: parent.verticalCenter
                        onValueChanged: {
                            saveButton.noshow=false;
                            tubeOutTempEdit.text = value;
                        }

                    }

                    PlainTextEdit{
                        id:tubeOutTempEdit
                        anchors.verticalCenter: parent.verticalCenter
                        text: tubeOutSlider.value
                        enabled: true
                        maxNumber: 2000
                        minNumber: 500
                        onFinished: {
                            tubeOutSlider.value = text;
                        }
                    }

                    Text{
                        text: "℃"
                        font.pixelSize: 16
                        color: "#454545"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Item{
                id:tubeCOTSettingItem
                width: tubeCOTSettingRow.width
                height: 60
                //tube cot alert temp setting
                Row{
                    id:tubeCOTSettingRow
                    spacing: 15
                    anchors.verticalCenter: parent.verticalCenter
                    Image{
                        source: "qrc:/imgs/icons/icon_tube_cot.png"
                    }

                    ESlider{
                        id:tubeCOTSlider
                        text: "COT警戒温度"
                        value: 840
                        anchors.verticalCenter: parent.verticalCenter
                        onValueChanged: {
                            saveButton.noshow=false;
                            tubeCOTTempEdit.text = value;
                        }
                    }

                    PlainTextEdit{
                        id:tubeCOTTempEdit
                        anchors.verticalCenter: parent.verticalCenter
                        text: tubeCOTSlider.value
                        enabled: true
                        minNumber: 500
                        maxNumber: 2000
                        onFinished: {
                            tubeCOTSlider.value = text;
                        }
                    }

                    Text{
                        text: "℃"
                        font.pixelSize: 16
                        color: "#454545"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Item{
                id: cycleSettingItem
                width: cycleSettingRow.width
                height: 60
                //cycle Setting
                Row{
                    id:cycleSettingRow
                    spacing: 15
                    anchors.verticalCenter: parent.verticalCenter
                    Image{
                        source: "qrc:/imgs/icons/cycle.png"
                    }

                    ESlider{
                        id:cycleSlider
                        text: "数据备份周期"
                        value: 1
                        minValue: 1
                        maxValue: 12
                        anchors.verticalCenter: parent.verticalCenter
                        onValueChanged: {
                            saveButton.noshow=false;
                            cycleEdit.text = value;
                        }
                    }

                    PlainTextEdit{
                        id:cycleEdit
                        anchors.verticalCenter: parent.verticalCenter
                        text: cycleSlider.value
                        enabled: true
                        minNumber: 1
                        maxNumber: 12
                        onFinished: {
                            cycleSlider.value = text;
                        }
                    }

                    Text{
                        text: "个月"
                        font.pixelSize: 16
                        color: "#454545"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Row{
                id:dumpBntRow
    //            anchors.top: cycleSettingItem.bottom
    //            anchors.topMargin: 50
                x:0
                spacing: 20
                Text{
                    text: "数据备份目录"
                    font.pixelSize: 15
                    color: "#454545"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Image {
                    id: dumpPathButton
                    source: bumpPathMa.pressed?"qrc:/imgs/icons/save_press.png":
                                                 bumpPathMa.containsMouse?"qrc:/imgs/icons/save_hover.png":
                                                                           "qrc:/imgs/icons/save_normal.png"
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        id:bumpPathMa
                        onClicked:  {
                            if(savePath.text!="") {
                                fileDialog.folder=savePath.text;
                            }

                            fileDialog.open();
                        }
                    }
                }

                Text{
                    id:savePath
                    text: ""
                    clip: true;
                    wrapMode:Text.WrapAnywhere;
                    width: cycleSettingRow.width-200
                    font.pixelSize: 15
                    color: "#454545"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Rectangle {
            id:saveButton
            width: parent.width/3;
            height: parent.height/8;
            clip: true;
            color: "#50f744"
            radius: width/8;
            anchors.horizontalCenter: parent.horizontalCenter ;
            anchors.bottom: parent.bottom ;
            anchors.bottomMargin: height/2;
            property alias  noshow: masking.visible ;
            enabled: !noshow
            Text {
                text: qsTr("保存设置");
                anchors.centerIn: parent ;
                font.pixelSize: parent.height/3
                color: "white"
            }
            Rectangle {
                id:masking
                visible: true;
                anchors.fill: parent ;
                radius: parent.radius ;
                color: "#70454545"
            }
            MouseArea {
                anchors.fill: parent ;
                onClicked: {
                    saveButton.noshow=true;
                    console.log("/YJS/tubeIn",tubeInSlider.value);
                    ESINI.setValue("/YJS/tubeIn",tubeInSlider.value);
                    ESINI.setValue("/YJS/tubeOut",tubeOutSlider.value);
                    ESINI.setValue("/YJS/tubeCot",tubeCOTSlider.value);
                    ESINI.setValue("/YJS/cycle",cycleSlider.value);
                    ESINI.setValue("/YJS/savrPath",savePath.text);
                }
            }

        }



        FileDialog {
              id: fileDialog
              title: "Please choose a file"
              folder: shortcuts.home
//              selectExisting:true;
              selectFolder:true;

              onAccepted: {
                  saveButton.noshow=false;
                  console.log("You chose: " + fileDialog.fileUrls)
                  savePath.text=""+fileDialog.fileUrls;
                  close()
              }
              onRejected: {
                  console.log("Canceled")
                  close();
              }
              Component.onCompleted: visible = false
          }
    }
    Component.onCompleted: {
        console.log("运行了");
        saveButton.noshow=true;
        tubeInTempEdit.text=ESINI.getValue("/YJS/tubeIn",1000);
        tubeInSlider.value=tubeInTempEdit.text;
        tubeOutTempEdit.text=ESINI.getValue("/YJS/tubeOut",1000);
        tubeOutSlider.value=tubeOutTempEdit.text;
        tubeCOTTempEdit.text=ESINI.getValue("/YJS/tubeCot",1000);
        tubeCOTSlider.value=tubeCOTTempEdit.text;
        cycleEdit.text=ESINI.getValue("/YJS/cycle",12);
        cycleSlider.value=cycleEdit.text;
        savePath.text=ESINI.getValue("/YJS/savrPath","C:/ethylene");

    }

}
