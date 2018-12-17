#include "serialportmanager.h"
#include <QDebug>

//串口管理类
SerialPortManager::SerialPortManager(QObject *parent) : QObject(parent)
{
    //标记：是否正在读取数据，默认值false
    isreadingDatas=false;
    //变量：发送数据串
    sendDataStr="";
//    this->cPortName="COM3";
    //预防有些设备没有串口的情况
    if(this->serialportInfo.availablePorts().count()>0){
        //取得获取回来的串口列表的第一个的串口名
        this->cPortName=serialportInfo.availablePorts().at(0).portName();
    }
    //设置串口名
    this->seriaPort.setPortName(this->cPortName);
    //设置波特率
    this->seriaPort.setBaudRate(115200);
    //sky:设置数据位
    this->seriaPort.setDataBits(QSerialPort::Data8);
    //sky:设置检验位
    this->seriaPort.setParity(QSerialPort::NoParity);
    //sky:设置停止位
    this->seriaPort.setStopBits(QSerialPort::OneStop);
    //设置发送计时器的连接超时时间
    this->sendTimer.setInterval(500);
    receiveTimer.setSingleShot(true);
    receiveTimer.setInterval(100);

    //sky:每100毫秒检查接收数据，并判断是否结束
    connect(&receiveTimer,SIGNAL(timeout()),this,SLOT(readingDatas()));
    connect(&seriaPort,SIGNAL(readyRead()),this,SLOT(readDatas()));
    connect(&sendTimer,SIGNAL(timeout()),this,SLOT(sendDatas()));

}

//获取串口数量
int SerialPortManager::getSerialPortsNum(){
    return serialportInfo.availablePorts().count();
}

//根据索引返回串口名
QString SerialPortManager::getSerialPortName(int index){
    if(index<serialportInfo.availablePorts().count()){
        return serialportInfo.availablePorts().at(index).portName();
    }
    else
        return "null";
}

//根据串口名,切换监听串口
void SerialPortManager::setPortName(QString name){
    this->seriaPort.setPortName(name);
    //设置当前串口名
    this->cPortName=name;
    qDebug()<<"current port :"<<cPortName<<cPortName.length()<<endl;
}

//槽,决定是否接收数据
void SerialPortManager::readDatas(){
    if(isreadingDatas)
    {
        qDebug()<<"reject receive";
        return;
    }else
    {
        qDebug()<<"first receive"<<endl;
        receiveTimer.start();
    }

}

//获取接收的数据, 并判断是否结束
void SerialPortManager::readingDatas()
{
    qDebug()<<"==="<<this->seriaPort.bytesAvailable()<<endl;
    //sky：修改 2018.12.07
    //if(this->seriaPort.bytesAvailable()>0){
    if(bufferDatas.isEmpty()||bufferDatas.count("#") < 8){
        //sky：修改 2018.12.07
        //bufferDatas+=seriaPort.readAll().data();
//-------------------------sky 接受逻辑---------------
        if(bufferDatas.isEmpty()){
            bufferDatas += seriaPort.readAll().data();
            qDebug()<<"----------1"<<bufferDatas;

        }else{
            QString tmp = seriaPort.readAll().data();
            if(!bufferDatas.contains(tmp)){
                bufferDatas += tmp;
                qDebug()<<"----------2"<<bufferDatas;
            }

        }
//-----------------------sky 接受逻辑---------------
//        delay_MSec_Suspend(2000);
        receiveTimer.start();

    }else{
        qDebug()<<"receive over"<<bufferDatas<<endl;
        //读取完毕信号
        readingFinish();
        //数据变化信号
        revDatasChanged();
        //接收完毕，标记修改为false
        isreadingDatas=false;
    }
}
//打开串口
bool SerialPortManager::openSerialPort(){
    return this->seriaPort.open(QIODevice::ReadWrite);
}
//关闭串口
void SerialPortManager::closeSerialPort(){
    this->seriaPort.close();
}
//写入数据
void SerialPortManager::writeDates(QString datas){
    qDebug()<<this->seriaPort.portName()<<"       "<<this->seriaPort.baudRate()<<endl;
    sendDataStr=datas;
//    serialSender.setPortName(this->seriaPort.portName());
//    serialSender.setBaudRate(this->seriaPort.baudRate());
//    qDebug()<<serialSender.open(QIODevice::ReadWrite);
    qDebug()<<seriaPort.open(QIODevice::ReadWrite);
    sendTimer.start();
}
//发送数据
void SerialPortManager::sendDatas(){
    //连续发送二十次关闭数据发送触发器，这个参数是经过实际测试后获得的
    if(this->dataSendTimes>=20){
        this->sendTimer.stop();
        this->dataSendTimes=0;
//        this->serialSender.close();
//        closeSerialPort();
        return;
    }

    //计数器，连续发送二十次关闭数据发送触发器
    this->dataSendTimes++;


    //发送数据

    QString datas=sendDataStr+"\n";//"Data_Receive_Success!\n";//Data_Receive_Success!
    QByteArray data=datas.toLocal8Bit();
//    this->serialSender.write(data);
    qDebug()<<"falele1"<<seriaPort.write(data)<<endl;
//    qDebug()<<"falele"<<this->serialSender.write(data)<<endl;
//    this->serialSender.waitForBytesWritten(100);
    this->seriaPort.waitForBytesWritten(100);

}
