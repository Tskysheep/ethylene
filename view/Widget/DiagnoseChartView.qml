import QtQuick 2.0
import QtCharts 2.2

Item {
    visible: false
    z:3
    property alias x_axis_min: xAxis.min
    property alias x_axis_max: xAxis.max
    property alias _lineSeries: lineSeries
    property alias _scatterSeries: scatterSeries
    property alias title: analysisChartView.title


    function show(){
        visible = true;

    }

    function hide(){
        visible = false;
    }

    Rectangle{
        anchors.fill: parent
        id:rect
        //color:"blue"
        ChartView{
            id:analysisChartView
            //width: parent.width - parent.width/4
            //height: 500
            //x:(parent.width - analysisChartView.width)/2
            anchors.fill: parent
            title: "结焦趋势"
            titleColor: fontColorNormal
            titleFont.pixelSize: 20
            antialiasing: true
            legend.visible: false
            property var maxValue: 4
            property var minValue: -1
            backgroundColor: "#00000000"

            ValueAxis{
                id:yAxis
                min: analysisChartView.minValue
                max: analysisChartView.maxValue
                tickCount: 6
                labelFormat: "%0.00f"
                titleText: "结焦程度"
            }
            DateTimeAxis{
                id:xAxis
                min:x_axis_min
                max: x_axis_max
                format: "yy/MM/dd"
                titleText: "日期：年/月/日"
            }
            SplineSeries{
                id:lineSeries
                axisX: xAxis
                axisY: yAxis
            }

            ScatterSeries{
                id:scatterSeries
                axisX: xAxis
                axisY: yAxis
            }

        }




/*        ChartView{
            anchors.fill: parent
            BarSeries{
                id:bars
                axisX: BarCategoryAxis{
                    categories: ["1","2","3","4","5","6","7","8"]
                }

                BarSet{
                    id:aabarset
                    label: "kk"
                    values: value
                }
            }
        }
*/
    }
}
