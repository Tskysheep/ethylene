#include "globalserialportmanager.h"

GlobalSerialPortManager::GlobalSerialPortManager(QObject *parent) : QObject(parent)
{
    port_flag = false;
    read_flag = false;
    success_cmd_send_flag = false;
    finish_flag = false;
    auto_open_count = 0;

//    if(QSerialPortInfo::availablePorts().size() > 0)
//    global_port.setPort(QSerialPortInfo::availablePorts().at(0)); //用（默认）第一个可用串口



    //配置计时器
    rec_timer.setInterval(100);
    rec_timer.setSingleShot(true);

    auto_op_timer.setInterval(5000);
    auto_op_timer.setSingleShot(true);

    //建立信号和槽连接
    connect(&global_port,&QSerialPort::readyRead,this,&GlobalSerialPortManager::isRead);
    connect(&rec_timer,&QTimer::timeout,this,&GlobalSerialPortManager::readData);
    connect(&auto_op_timer,&QTimer::timeout,this,&GlobalSerialPortManager::autoOpenPort);

}

GlobalSerialPortManager *GlobalSerialPortManager::instance()
{
    static GlobalSerialPortManager *instance;
    if(!instance)
        instance = new GlobalSerialPortManager();

    return instance;
}

bool GlobalSerialPortManager::getPortFlag()
{
    return port_flag;
}

void GlobalSerialPortManager::closePort()
{
    auto_open_count = 0;
    port_flag = false;
    global_port.close();
}

void GlobalSerialPortManager::openPort()
{
    if(port_flag) return;//如果当前是开启的就不用开

    global_port.setPortName(cPortName);//设置串口名称

    if(global_port.portName() == ""){ //启动软件前没有串口的情况
            //打开串口
            if(global_port.open(QIODevice::ReadWrite)){
                //配置串口
                global_port.setBaudRate(115200);
                global_port.setDataBits(QSerialPort::Data8);
                global_port.setParity(QSerialPort::NoParity);
                global_port.setStopBits(QSerialPort::OneStop);
                global_port.setFlowControl(QSerialPort::NoFlowControl);
                auto_open_count = 0;
                port_flag = true;
                qDebug()<<"---------------------------------open global port succ-------------------------";
            }else {
                auto_open_count++;
                emit openPortSucc_Faild(false);
                if(auto_open_count == 2) return; //只自动打开两次，然后就不继续打开了
                else auto_op_timer.start();

            }


    }else{//启动软件前有串口
        //打开串口
        if(global_port.open(QIODevice::ReadWrite)){
            global_port.setBaudRate(115200);
            global_port.setDataBits(QSerialPort::Data8);
            global_port.setParity(QSerialPort::NoParity);
            global_port.setStopBits(QSerialPort::OneStop);
            global_port.setFlowControl(QSerialPort::NoFlowControl);
            auto_open_count = 0;
            port_flag = true;
            qDebug()<<"---------------------------------open global port succ-------------------------";
        }else {
            auto_open_count++;
            emit openPortSucc_Faild(false);
            if(auto_open_count == 2 ) return; //只自动打开两次，然后就不继续打开了
            else auto_op_timer.start();

        }

    }
}

int GlobalSerialPortManager::getSerialPortsNum()
{
    return QSerialPortInfo::availablePorts().count();
}

QString GlobalSerialPortManager::getSerialPortName(int index)
{
    if(index < QSerialPortInfo::availablePorts().count()){
        return QSerialPortInfo::availablePorts().at(index).portName();
    }else{
        return "null";
    }
}

void GlobalSerialPortManager::setPortName(QString name)
{
    cPortName = name;

}

QVariantMap GlobalSerialPortManager::getAllData()
{
    QVariantMap map;

    for(int a = 0; a < dataMap.size(); a++){
        map.insert(QString::number(dataMap.keys().at(a)),dataMap.values().at(a));
    }

    return map;
}



void GlobalSerialPortManager::readData()
{
    QString tmpstr = tr(global_port.readAll().data());
    qDebug()<<"原始数据：" +  tmpstr;
    QString matchstr = matchData(tmpstr);

    if(tmpstr.contains("@Connect_Core_PC$")){
        emit coreSyn();
        sendData("@Connect_PC_Core$");
        //success_cmd_send_flag = false;
        //finish_flag = false;
        qDebug()<<"已发送：@Connect_PC_Core$";
        sleep(200);
        dataMap.clear();//开始新的连接，清除原来的数据
        return;
    }

/*    if(tmpstr.contains("@Core_send_finish$")){
        emit recFinish();
        //sendData("@PC_saves_data$");
        //qDebug()<<"已发送：@PC_saves_data$";
        return;
    }
*/

//    if(tmpstr.contains("@PC_data_receive_failure$")){
//        if(success_cmd_send_flag){
//            sendData("@PC_receives_data$");
//            qDebug()<<"再次发送 @PC_receives_data$";
//        }

//        return;
//    }

    if(tmpstr.contains("@Data_PC_saves_failure$")){

        finish_flag = false;
        dataMap.clear();
        sendData("@PC_saves_data$");
        qDebug()<<"再次发送 @PC_saves_data$";
        return;
    }

//    if(finish_flag){
//        return;
//    }

    if(checkData(matchstr)){//检查数据是否完整
        QString tmpstr2 = matchstr.split(",").at(0);
        int key = QString(tmpstr2.at(4)).toInt();
        if(dataMap.contains(key)){
                dataMap.insert(key,matchstr);
                //emit msgToast(key);
                sendData("@PC_receives_data$");
                //success_cmd_send_flag = true;
                qDebug()<<"已发送：@PC_receives_data$";
                checkFinish();
                sleep(100);
        }else{//新接收的数据在字典中不存在，直接插入
            dataMap.insert(key,matchstr);
            emit msgToast(key);
            sendData("@PC_receives_data$");
            //success_cmd_send_flag = true;
            qDebug()<<"已发送：@PC_receives_data$";
            checkFinish();
            sleep(100);
        }
    }



}

void GlobalSerialPortManager::isRead()//决定是否接收数据
{
    if(read_flag){
        return;
    }else{
        rec_timer.start();
    }


}

void GlobalSerialPortManager::autoOpenPort()
{
    if(port_flag) return;
    else openPort();

}

void GlobalSerialPortManager::sendData(QString data)
{
    global_port.write(data.toLatin1());
}

bool GlobalSerialPortManager::checkData(QString data)//判断数据是否完整
{
    if(data.contains("??")&&data.contains("#")){
        if(data.split(",").count() == 14){
            //检查数据是否小于0 ，是则说明硬件那边测量错误
            for(int a = 1; a < data.split("??").at(1).split(",").count(); a++){
                if(data.split("??").at(1).split(",").at(a).toInt() <= 200){
                    //sendData("@data_error$");
                    return false;
                }
            }

            return true;
        }else{

            return false;
        }
    }else{

        return false;
    }

}

void GlobalSerialPortManager::sleep(unsigned int msec)
{
    QTime dieTime = QTime::currentTime().addMSecs(msec);
    while( QTime::currentTime() < dieTime )
        QCoreApplication::processEvents(QEventLoop::AllEvents, 100);

}

QString GlobalSerialPortManager::matchData(QString data)
{
    QRegExp rx(QString("\\?\\?\\d#\\d.*\\?\\?"));
    rx.setMinimal(true);//非贪婪模式
    int pos = data.indexOf(rx);
    if(pos >= 0){
        return rx.cap(0);
    }

    return QString("");

}

void GlobalSerialPortManager::checkFinish()
{
    if(dataMap.count() < 8){

    }else{
        emit recFinish();
    }
}

void GlobalSerialPortManager::setFinishFlag(bool flag)
{
    finish_flag = flag;
}


