#ifndef SERIALPORTMANAGER_H
#define SERIALPORTMANAGER_H

#include <QObject>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QString>
#include <QList>
#include <QtDebug>
#include <QTimer>
#include <QTime>
class SerialPortManager : public QObject
{
    Q_OBJECT
public:
    //设置默认串口和参数并将信号与相关槽连接.
    explicit SerialPortManager(QObject *parent = 0);
    //返回串口的数量
    Q_INVOKABLE int getSerialPortsNum();
    //根据索引返回串口名
    Q_INVOKABLE QString getSerialPortName(int index);
    //根据串口名,切换监听串口
    Q_INVOKABLE void setPortName(QString name);
    //打开当前选择串口
    Q_INVOKABLE bool openSerialPort();
    //关闭当前选择串口
    Q_INVOKABLE void closeSerialPort();
    //将数据写入触发槽sendDatas()通过串口发送
    Q_INVOKABLE void writeDates(QString datas);

    //在QML中以属性的方式访问
    Q_PROPERTY(QString revDatas READ revDatas WRITE setRevDatas NOTIFY revDatasChanged)
    QString revDatas(){
        return bufferDatas;
    }
    //设置bufferDates对象的值
    void setRevDatas(QString data){
        bufferDatas=data;
    }

    //延时函数
    void delay_MSec_Suspend(unsigned int msec)
    {
        QTime _Timer = QTime::currentTime();

        QTime _NowTimer;
        do{
                  _NowTimer=QTime::currentTime();
        }while (_Timer.msecsTo(_NowTimer)<=msec);

    }


signals:
    //读取完毕信号
    void readingFinish();
    //数据变化信号
    void revDatasChanged();

public slots:
    //槽,决定是否接收数据
    void readDatas();
    //槽,多次发送数据防止丢包
    void sendDatas();
    //获取接收的数据, 并判断是否结束
    void readingDatas();
private:
    QSerialPortInfo serialportInfo;
    QSerialPort seriaPort;
    QSerialPort serialSender;
    QString cPortName;//当前串口名
    QString bufferDatas;//串口数据接收字符串
    QTimer sendTimer;
    QTimer receiveTimer;
    int dataSendTimes=0;

    bool isreadingDatas;
    QString sendDataStr;
};

#endif // SERIALPORTMANAGER_H
