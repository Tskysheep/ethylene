import QtQuick 2.0

Item {
    id:datepicker
    width: mainRow.width
    height: 20
    property var year:yearPlainText.text
    property var month:monthPlainText.text
    property var day: dayPlainText.text
    onMonthChanged: {
        if(month.length == 1){
            if(month <10 ){
                month = "0" + Number(month).toString();
            }
        }
    }
    onDayChanged: {
        if(day.length == 1){
            if(day <10 ){
                day = "0" + Number(day).toString();
            }
        }
    }

    Row{
        id:mainRow
        spacing: 5
        PlainTextEdit{
            id: yearPlainText
            minNumber: 2000
            onTextChanged: year = text;
        }
        Item{
            width: 20
            height: 20
            Text{
                text:"年"
                font.pixelSize: 16
                anchors.centerIn: parent
                color: "#333333"
            }
        }

        PlainTextEdit{
            maxNumber: 12
            minNumber: 1
            id: monthPlainText
            onTextChanged:  month = text;
        }
        Item{
            width: 20
            height: 20
            Text{
                text:"月"
                font.pixelSize: 16
                anchors.centerIn: parent
                color: "#333333"
            }
        }

        PlainTextEdit{
            maxNumber: 31
            minNumber: 1
            id: dayPlainText
            onTextChanged: day = text;
        }
        Item{
            width: 20
            height: 20
            Text{
                text:"日"
                font.pixelSize: 16
                anchors.centerIn: parent
                color: "#333333"
            }
        }
    }

}
