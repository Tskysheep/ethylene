
import QtQuick 2.0
import "../Widget"
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id:root
    anchors.fill: parent
    property var searchDatas:[]
    property var result;
    property int currentGroup: 0
    property int currentFuranceNum: 5
    //初始化相关数据
    Component.onCompleted: {
        for(var a=0;a<12;a++){
            var tubeNum = a+1;
            var searchData = {};
            var datasInfo = [];

            for(var b=0;b<1;b++){
                var sdata = {};
                sdata.tubeInTime = "";
                sdata.tubeInTemp = "";

                sdata.tubeOutTime = "";
                sdata.tubeOutTemp = "";

                sdata.tubeCOTTime = "";
                sdata.tubeCOTTemp = "";

                datasInfo.push(sdata);
            }

            searchData.datasInfo = datasInfo;
            searchData.tubeNum = tubeNum;

            searchDatas.push(searchData);
        }
        searchDatasRepeator.model = searchDatas;

        datalistcontent.height = (searchDatas[0].datasInfo.length+1)*20 + 25
        searchDatas = [];
    }
    //切换组号后重新渲染显示
    onCurrentGroupChanged: {
        refresh();
    }
    //根据条件更新数据
    function refresh(){
        searchDatas = [];
        //sky：从全局变量result 中取出相应数据放进另一个全局变量 searchDatas 中

        for(var a=0;a<12;a++){
            var tubeNum = currentGroup*12 + a ;
            var searchData = {};
            var datasInfo = [];

            for(var b=0;b<result.tubeInData[tubeNum].data.length;b++){
                var sdata = {};
                sdata.tubeInTime = result.tubeInData[tubeNum].data[b].time;
                sdata.tubeInTemp = result.tubeInData[tubeNum].data[b].temp;

                sdata.tubeOutTime = result.tubeOutData[tubeNum].data[b].time;
                sdata.tubeOutTemp = result.tubeOutData[tubeNum].data[b].temp;

                sdata.tubeCOTTemp = -1;
                sdata.tubeCOTTime = "无cot数据"
                if(!result.tubeCotData){
                    sdata.tubeCOTTemp = result.tubeCotData[tubeNum].data[b].temp;
                    sdata.tubeCOTTime = result.tubeCotData[tubeNum].data[b].time;
                }
                datasInfo.push(sdata);
            }

            searchData.datasInfo = datasInfo;
            searchData.tubeNum = tubeNum+1;
            console.log((searchData.toString()));
            console.log((datasInfo.toString()));
            searchDatas.push(searchData);
        }
        searchDatasRepeator.model = searchDatas;

        //根据查询到的数据的数量，设定显示的高度
        datalistcontent.height = (searchDatas[0].datasInfo.length+1)*20 + 25 + 180

    }



    Column{
        id:maincol
        anchors.fill: parent
        //top bar
        Rectangle{
            id:topBar
            width: root.width
            height: 80
            color: "#ccf4f7"

            //bnts
            Row{
                id:bntRow
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 100
                spacing: 30
                RoundIconButton{
                    id:searchbnt
                    imgSrc: "qrc:/imgs/icons/search_small.png"
                    text: "查询"
                    bgColor: "#41ccdc"
                    width: 120
                    height: 35
                    onBngClicked: {
                        //组装查询条件,进行查询
                        searchDatas = [];//sky:清空全局变量searchDatas ???

                        var fromDateStr = fromDatePicker.year + "-" +
                                fromDatePicker.month + "-" +
                                fromDatePicker.day + " 00:00:00";
                        var toDateStr = toDatePicker.year + "-" +
                                toDatePicker.month + "-" +
                                toDatePicker.day + " 23:59:50";
                        var fromDate = new Date(fromDateStr);
                        var toDate = new Date(toDateStr);

                        result = server.all_tube_show( currentFuranceNum, fromDate, toDate);//sky:mysqlserver.cpp 668行返回一个QJsonObject 对象 root

                        console.log("gg");
                        console.log(result.toString());

                        refresh();
                    }
                }
                RoundIconButton{
                    id:exportbnt
                    imgSrc: "qrc:/imgs/icons/output.png"
                    text: "导出数据"
                    width: 120
                    height: 35
                    onBngClicked: {
                        if(server.exportExcel1()) {
                            console.log("哇咔咔，到底是谁先呢？？");
                        }
                    }
                }
            }

            //date pickers
            Column{
                id:datePickerCol
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: bntRow.left
                anchors.rightMargin: 50
                spacing: 10
                Item{
                    id: fromDatepickerItem
                    width: fromDatepickerRow.width
                    height: 20
                    Row{
                        id:fromDatepickerRow
                        Item{
                            width: 60
                            height: 20
                            Text{
                                anchors.centerIn: parent
                                text: "从时间:"
                                font.pixelSize: 16
                                color: "#333333"
                            }
                        }
                        DatePicker{
                            id:fromDatePicker
                        }
                    }
                }

                Item{
                    id: toDatepickerItem
                    width: toDatepickerRow.width
                    height: 20
                    Row{
                        id:toDatepickerRow
                        Item{
                            width: 60
                            height: 20
                            Text{
                                anchors.centerIn: parent
                                text: "到时间:"
                                font.pixelSize: 16
                                color: "#333333"
                            }
                        }
                        DatePicker{
                            id:toDatePicker
                        }
                    }
                }

            }

            //forance chooser 炉号选择器
            Row{
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: datePickerCol.left
                anchors.rightMargin: 50
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

            //line
            Rectangle{
                width: parent.width
                height: 1
                color: "#999999"
                anchors.bottom: parent.bottom
            }

        }

        //content           sky:显示数据内容的区域
        Rectangle{
            id: content
            width: root.width
            height: root.height - topBar.height-40

            ScrollView{
                width: parent.width
                height: parent.height
                style: ScrollViewStyle{
                    decrementControl: Item{

                    }
                    incrementControl: Item{

                    }
                    corner: Item{

                    }
                }

                Item{
                    id:datalistcontent
                    width: datasRow.width
                    height: 100
                    Row{
                        id:datasRow
                        Repeater{
                            id:searchDatasRepeator
                            delegate: TubeInfoList{
                                id:infoDelegate
                                tubeNum: modelData.tubeNum
                                datasInfo: modelData.datasInfo
                            }
                        }
                    }
                    Rectangle{
                        width: 1
                        height: parent.height
                        color: "#999999"
                    }
                }
            }
        }

        //indicators 组别指示器
        Rectangle{
            width: parent.width
            height: 40
            color: "#999999"
            Row{
                height: 38
                spacing: 1
                anchors.centerIn: parent
                Repeater{
                    model: 4
                    delegate: Rectangle{
                        width: root.width/4-5
                        height: 38
                        color: currentGroup === index?"#41ccdc":"#344750"
                        Text{
                            anchors.centerIn: parent
                            text: "第"+(index+1)+"组"
                            color: "#ffffff"
                            font.pixelSize: 20
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: currentGroup = index
                        }
                    }
                }
            }
        }
    }
}
