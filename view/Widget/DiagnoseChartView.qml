import QtQuick 2.0
import QtCharts 2.2

Item {
    visible: false
    z:3
    property alias x_axis_min: xAxis.min
    property alias x_axis_max: xAxis.max
    property alias _lineSeries: lineSeries
    property alias _lineSeries2: lineSeries2
    property alias _lineSeries3: lineSeries3
    property alias _scatterSeries: scatterSeries0
    property alias _scatterSeries1: scatterSeries1
    property alias _scatterSeries2: scatterSeries2
    property alias _scatterSeries3: scatterSeries3
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
                name:"出管趋势曲线"
                axisX: xAxis
                axisY: yAxis
                style: Qt.DashLine
                color: "blue"

            }
            SplineSeries{
                id:lineSeries2
                name:"入管趋势曲线"
                axisX: xAxis
                axisY: yAxis
                style: Qt.DashDotLine
                color: "black"
            }

            SplineSeries{
                id:lineSeries3
                name:"TMT/COT曲线"
                axisX: xAxis
                axisY: yAxis
                style: Qt.SolidLine
                color: "green"
            }

            ScatterSeries{
                id:scatterSeries0
                name:"正常"
                axisX: xAxis
                axisY: yAxis
                color: "#13B92E"
            }

            ScatterSeries{
                id:scatterSeries1
                name:"轻度结焦"
                axisX: xAxis
                axisY: yAxis
                color: "#E1D121"

            }

            ScatterSeries{
                id:scatterSeries2
                name:"中度结焦"
                axisX: xAxis
                axisY: yAxis
                color: "#FD9F02"
            }

            ScatterSeries{
                id:scatterSeries3
                name:"严重结焦"
                axisX: xAxis
                axisY: yAxis
                color: "#FD030F"
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
