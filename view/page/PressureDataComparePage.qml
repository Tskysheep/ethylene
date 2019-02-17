import QtQuick 2.7
import "../Widget"
import QtCharts 2.1

Item {
    anchors.fill: parent


    Column{
        anchors.fill: parent
        z:2
        //top bar
        Item{
            id:top_bar
            width: parent.width
            height: 50
            //clip: true
            Rectangle{
                width: parent.width-10
                anchors.horizontalCenter: parent.horizontalCenter
                height: 1
                color: "#dadada"
                anchors.bottom: parent.bottom
            }

            // select row
            Row{
                id:select_row
                anchors.verticalCenter: parent.verticalCenter
                x:parent.width/2 -  select_row.width / 2
                spacing: 30

                //text
                Item{
                    width: 20
                    height: 20
                    anchors.verticalCenter: compareBnt.verticalCenter
                    Text{
                        anchors.centerIn: parent
                        text: "炉号"
                        font.pixelSize: 15
                        font.family: "微软雅黑"
                        color: "#3E3E3E"
                    }
                }

                //foruance num selector
                ForanceNumComboBox{
                    id:foranceComboBox
                    anchors.verticalCenter: compareBnt.verticalCenter
                }


                Item{
                    width: 20
                    height: 20
                    anchors.verticalCenter: compareBnt.verticalCenter
                    Text{
                        anchors.centerIn: parent
                        text: "从"
                        font.pixelSize: 15
                        font.family: "微软雅黑"
                        color: "#3E3E3E"
                    }
                }

                //from date picker
                DatePicker{
                    id:fromDatPicker
                    anchors.verticalCenter: compareBnt.verticalCenter
                }

                //text
                Item{
                    width: 20
                    height: 20
                    anchors.verticalCenter: compareBnt.verticalCenter
                    Text{
                        anchors.centerIn: parent
                        text: "到"
                        font.pixelSize: 15
                        font.family: "微软雅黑"
                        color: "#3E3E3E"
                    }
                }

                //to date picker
                DatePicker{
                    id:toDatPicker
                    anchors.verticalCenter: compareBnt.verticalCenter
                }


                //compare button
                RoundIconButton{
                    id: compareBnt
                    text: "开始比较"
                    width: 120
                    height: 35
                    textSize: 17
                    imgSrc: "qrc:/imgs/icons/bnt_comparer.png"
                    bgColor: "#5596E4"

                    onBngClicked: {
                        refresh();
                    }
                }

                RoundIconButton{
                    imgSrc: "qrc:/imgs/icons/picture.png"
                    width: 120
                    height: 35
                    textSize: 17
                    text: "导出图片"
                    bgColor: "#344750"
                    onBngClicked: {
                        root.grabToImage(function(result){
                            var url = server.getSaveFilePath();
                            result.saveToFile(url);
                        });
                    }
                }
            }

        }

        Item{
            id:change_btn
            width: parent.width
            height: 65

            RoundIconButton{
                id: venturi
                text: "文丘里"
                width: 120
                height: 35
                textSize: 17
                x:parent.width / 2 - width - 15
                anchors.bottom: parent.bottom
                bgColor: "#5596E4"

                onBngClicked: {
                    //refresh();
                }
            }

            RoundIconButton{
                id: across_section
                text: "横跨段"
                width: 120
                height: 35
                textSize: 17
                x:parent.width / 2 + 15
                anchors.bottom: parent.bottom
                bgColor: "#344750"

                onBngClicked: {
                    //refresh();
                }
            }


        }

        Item {
            width: parent.width
            height:parent.height - top_bar.height - change_btn.height

            ChartView{
                anchors.fill: parent
                anchors.centerIn: parent
                antialiasing: true
                id:barChart
                //title: "数据导入时间：" + newest_date
                titleFont.family: "微软雅黑"
                titleFont.pixelSize: 20
                ValueAxis {
                    id: barAxisY
                    min: 700
                    max: 1100
                    titleText: "压力/Kpa"
                    titleFont.family: "微软雅黑"
                    titleFont.pixelSize: 20
                    labelFormat: "%.0f"
                }
                BarSeries {
                    id: bars
                    //sky 显示每个条形图的数值
                    labelsVisible: true
                    labelsPosition: AbstractBarSeries.LabelsOutsideEnd

                    axisX: BarCategoryAxis {
                        titleText: "炉号"
                        titleFont.family: "微软雅黑"
                        titleFont.pixelSize: 20

                        categories: ["0", "1", "2", "3", "4", "5","6","7","8","9","10" ]
                    }
                    axisY: barAxisY

                    BarSet {
                        id:bar1
                        //sky 数值的字体颜色等
                        label: "文丘里1";
                        labelFont.family: "微软雅黑"
                        labelFont.pixelSize: 20
                        labelColor: "#209fdf"
                                    values: [966, 966,966, 966, 966, 966,966,966,966,966]
                    }
                    BarSet {
                        id: bar2
                        label: "文丘里2";
                        labelFont.family: "微软雅黑"
                        labelFont.pixelSize: 20
                        labelColor: "#99ca53"
                                    values: [888,888,888,888,888,888,888,888,888,888,888]
                    }
                    BarSet {
                        id: bar3
                        label: "文丘里3";
                        labelFont.family: "微软雅黑"
                        labelFont.pixelSize: 20
                        labelColor: "#F6A625"
                                    values: [855,855,855,855,855,855,855,855,855,855,855]
                    }

                    BarSet {
                        id: bar4
                        label: "文丘里4";
                        labelFont.family: "微软雅黑"
                        labelFont.pixelSize: 20
                        labelColor: "#344750"
                                    values: [999,999,999,999,999,999,999,999,999,999,999]
                    }
                }
            }

        }

    }



}
