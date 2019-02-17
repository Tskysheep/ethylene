import QtQuick 2.0
import QtQuick.Dialogs 1.0
import "../Widget"
//相关参数备份周期录入页
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
                    //ESINI.setValue("/YJS/tubeIn",tubeInSlider.value);
                    //ESINI.setValue("/YJS/tubeOut",tubeOutSlider.value);
                    //ESINI.setValue("/YJS/tubeCot",tubeCOTSlider.value);
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
        savePath.text=ESINI.getValue("/YJS/savrPath","C:/ethylene");

    }

}
