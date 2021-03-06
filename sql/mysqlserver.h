#ifndef MYSQLSERVER_H
#define MYSQLSERVER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDateTime>
#include <QVariant>
#include <string>
#include <QList>
#include <QDebug>
#include <QMap>
#include <QDateTime>
#include <iterator>
#include <QTime>
#include <QWidget>
#include <QPushButton>
#include <QDebug>
#include <QFile>
#include <QFileDialog>
#include <QTextStream>
#include <QAxObject>
#include <QGridLayout>
#include <QString>
#include <QStringList>
#include <QDir>
#include <QFileInfo>
#include <QFileInfoList>
#include <windows.h>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonParseError>
#include <QtConcurrent>
#include <QSettings>


//存了乙烯入管 出管 COT 的48 根管的温度，时间结构体
struct ethlene_databases{
    //炉号
    int forenceNum[48];
    int forenceNum1[48];
    int forenceNum2[48];

    //各个管对应的时间
    //入管时间数组
    QDateTime time[48];
    //出管时间数组
    QDateTime time1[48];
    //COT管时间数组
    QDateTime time2[48];

    //各个管对应的温度
    //入管温度数组
    int tube_in_temps[48];
    //出管温度数组
    int tube_out_temps[48];
    //COT温度数组
    int cot_temp[48];
};

//简单数据结构，温度，时间
struct datas_time{
    int temp;
    QDateTime time;
};

class MysqlServer : public QObject
{
    Q_OBJECT
public:
    //初始化相关对象的实现与设置
    explicit MysqlServer(QObject *parent = 0);
    //单例模式
    static MysqlServer* instance();
    //插入数据到数据库中
    Q_INVOKABLE void pushDatas(QString tubeNum,//炉号
                               QString forunNum,//管号
                               QString location,//位置（tube in ,tube out ,tube cot)
                               QString temp,//温度
                               QString dataTime//时间
                               );
    //计算日平均温度处理算法
    void mdeal_with(QList<datas_time> *mdt);
    //进行时间排序 将数据按时间进行排序
    void sortData(QList<datas_time> *mdt);
    //管管比较
    Q_INVOKABLE QJsonArray compare_datas(int forunceNum,int tubeNum,QDateTime from_DateTime,QDateTime to_DateTime);
    //炉管诊断 根据条件返回压力数据
    Q_INVOKABLE QJsonArray pressureData(int forunceNum,int tubeNum,QDateTime from_DateTime,QDateTime to_DateTime);
    //全管查询 根据炉号时间为条件以JSON格式返回所有管的数据
    Q_INVOKABLE QJsonObject all_tube_show(int forunceNum,QDateTime from_DateTime, QDateTime to_DateTime);
    //sky add:结焦诊断相关数据获取
    Q_INVOKABLE QJsonObject diagnoseData(int forunceNum,QStringList column_names ,QDateTime frome_DateTime,QDateTime to_DateTime);
    Q_INVOKABLE QJsonObject diagnoseVenturiPressureData(int forunceNum,QString date);
    Q_PROPERTY(QString currentUser READ currentUser NOTIFY currentUserChanged)
    //返回当前用户对象
    QString currentUser();
    //返回当前用户对象权限
    Q_PROPERTY(int currentUserAccess READ currentUserAccess NOTIFY currentUserAccessChanged)
    int currentUserAccess();
    //sky add 获取炉管数据的最新时间
    Q_INVOKABLE QDateTime access_tube_newest_time(int forunceNum);
    //获取最新的入管，出管，ＣＯＴ温度 以JSON数组的格式返回
    Q_INVOKABLE QJsonArray access_tube_in_temp(int forunceNum);
    Q_INVOKABLE QJsonArray access_tube_out_temp(int forunceNum);
    Q_INVOKABLE QJsonArray access_tube_cot_temp(int forunceNum);
    //更新最新显示数据
    Q_INVOKABLE void refresh_data(){
        //初始化各个管的温度
        for(int a=0;a<48;a++){
            my_ethlene_datas.tube_in_temps[a]=0;
            my_ethlene_datas.tube_out_temps[a] = 0;
            my_ethlene_datas.cot_temp[a] = 0;
            my_ethlene_datas.time[a] = QDateTime();
            my_ethlene_datas.time1[a] = QDateTime();
            my_ethlene_datas.time2[a] = QDateTime();
        }
        //this->access_tube_in_temp(i);
        //this->access_tube_out_temp();
        //this->access_tube_cot_temp();

    }
    //设置备份路径
    Q_INVOKABLE void setDumpPath(QString path);

    //登陆
    Q_INVOKABLE bool login(QString userName, QString pwd, QString access);

    //注销
    Q_INVOKABLE void logOut();

    //用户列表
    Q_INVOKABLE QJsonArray usersList();


    //添加用户
    Q_INVOKABLE bool addUser(const QString& userName,
                             const QString& pwd,
                             const QString& access);

    //删除用户
    Q_INVOKABLE bool removeUser(const QString& userName);

    //更新用户
    Q_INVOKABLE bool updateUser(const QString& userName,
                                const QString& pwd,
                                const QString& access,
                                const QString& userId);
    Q_INVOKABLE bool verifyAdminPwd(QString pwd);

    //sky 压力列表
    Q_INVOKABLE QJsonArray pressdataList(const QString& fn);

    //sky 添加压力
    Q_INVOKABLE bool addPressure(const QString& fn,
                                 const QString& time,
                                 const QString& value1,
                                 const QString& value2,
                                 const QString& value3,
                                 const QString& value4);
    //sky 修改压力
    Q_INVOKABLE bool updatePressData(QString forunceNum,
                                        QStringList old_values,
                                        QStringList new_values,
                                        QString old_time,
                                        QString new_time);
    //sky 查询压力
    Q_INVOKABLE QJsonArray access_pressdata(QString forunceNum,QString from_time,QString to_time);
    Q_INVOKABLE QJsonObject access_acrossection_pressdata(QStringList acrosssections,QDateTime time);

    //导入压强数据
    Q_INVOKABLE bool pushPressureData(const int &fn, const QJsonArray& data, const QDateTime& date);

    //获取保存图片路径
    Q_INVOKABLE QString getSaveFilePath();
    //备份数据为excel 每月备份一次当月的数据
    void dumpDatas();

    //是否导入不完整数据对话框
    Q_INVOKABLE bool isPushingIncompleteDatas(const QString& str);

    //自动导出数据
    void dumpDatasLi();
    //导出excel
    QAxObject *excel;
    QAxObject *workbooks;
    QAxObject *workbook;
    QAxObject *worksheets;
    QAxObject *worksheet;
signals:
    void currentUserAccessChanged();
    void currentUserChanged();

    void dumpDataOver();
    void allTubeShowDataGot(const QJsonObject& jsonResult);
    void access_tube_cot_temp_got(const QJsonArray& jsonResult);
    void diagnoseData_got(const QJsonObject& jsonResult);
public slots:
    //导出EXCEl 指定导出路径并导出excel
    bool exportExcel1(QString fn);      //手动导出excel
    void exportExcel(QString creatPath);
    //sky 导出压力
    bool exportPressureExcel(QString fn,
                             QStringList datetimes,
                             QStringList value1s,
                             QStringList value2s,
                             QStringList value3s,
                             QStringList value4s);

    bool exportPressure2Excel(QString fn,
                             QStringList datetimes,
                             QStringList value1s,
                             QStringList value2s,
                             QStringList value3s,
                             QStringList value4s);

    void onDumpDataOver();

    void refreshDataBaseInfo();
private:
    //当前48根管最新的温度数据保存
    ethlene_databases my_ethlene_datas;
    //新方案诊断与检测数据存放
    QList<datas_time> tube_in_test_datas;
    QList<datas_time> tube_out_test_datas;
    QList<datas_time> tube_cot_test_datas;
    QList<datas_time> pressure_test_datas;
    //全管查询后存放的数据
    QList<datas_time> tube_in_full_search_datas[48];
    QList<datas_time> tube_out_full_search_datas[48];
    QList<datas_time> tube_cot_full_search_datas[48];
    QList<datas_time> tube_cot_full_search_datas2[48];
    QList<datas_time> diagnose_tube_cot_full_search_datas[48];
    //备份数据目录
    QString mdumpPath;
    QSettings msettings;
    int m_access = 0;
    QString m_currentUser;

    //sky:乙烯厂数据库连接相关信息
    QString e_dbtype;
    QString e_ip;
    QString e_dbname;
    int e_dbport;

    //sky 本地数据库连接相关信息
    QString local_dbtype;
    QString local_ip;
    QString local_dbname;
    QString local_dbuser;
    QString local_dbpwd;
};
#endif // MYSQLSERVER_H
