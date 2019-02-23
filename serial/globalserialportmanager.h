#ifndef GLOBALSERIALPORTMANAGER_H
#define GLOBALSERIALPORTMANAGER_H

#include <QObject>
#include <QDebug>
#include <QTimer>
#include <QVariant>
#include <QString>
#include <QIODevice>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QTime>
#include <QRegExp>
#include <QCoreApplication>


class GlobalSerialPortManager : public QObject
{
    Q_OBJECT
public:
    explicit GlobalSerialPortManager(QObject *parent = nullptr);
    static GlobalSerialPortManager * instance();
    Q_INVOKABLE bool getPortFlag();//获取串口是否开启的标志
    Q_INVOKABLE void closePort();//关闭串口
    Q_INVOKABLE void openPort();//开启串口
    Q_INVOKABLE int getSerialPortsNum();//获取可用串口数量
    Q_INVOKABLE QString getSerialPortName(int index);//获取串口名称
    Q_INVOKABLE void setPortName(QString name);//根据串口名，切换监听串口
    Q_INVOKABLE QVariantMap getAllData();
    Q_INVOKABLE  void sendData(QString data);//数据发送函数
    Q_INVOKABLE void setFinishFlag(bool flag);

    QSerialPort global_port;
    QMap<int,QString> dataMap;//数据容器（字典）
    QTimer rec_timer;//缓冲接收计时器
    QTimer auto_op_timer;//自动开启串口定时器
    bool port_flag;//串口开始标志位
    bool read_flag;//读取数据标志
    bool success_cmd_send_flag;
    bool finish_flag;
    int auto_open_count;
    QString cPortName;
private:
    //void sendData(QString data);//数据发送函数
    bool checkData(QString data);//数据检查函数，检查数据是否完整
    QString matchData(QString data);//利用正则匹配规范数据，排除其他干扰
    void checkFinish();//检测8条数据是否接收


signals:
    void openPortSucc_Faild(bool);
    void coreSyn();//与仪器握手成功后的信号
    void msgToast(int);
    void recFinish();

public slots:
    void readData();
    void isRead();//是否可以接收
    void autoOpenPort();//自动开启串口
    void sleep(unsigned int msec);
};


#endif // GLOBALSERIALPORTMANAGER_H
