#include "mysqlserver.h"
#include <QDebug>
#include "../global.h"
#include <QDialog>
#include <QFrame>
#include <QPushButton>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QSqlError>

//时间转换 转换时间为一般格式
static QDateTime get_cot_dateTime(QString str){
    QString t = str;

    QString t1;
    //从索引为3的位置，取3个字符
    if(t.mid(3,3)=="JAN"){
        t1 = t.replace(3,3,"01").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="FEB"){
        t1 = t.replace(3,3,"02").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="MAR"){
        t1 = t.replace(3,3,"03").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="APR"){
        t1 = t.replace(3,3,"04").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="MAY"){
        t1 = t.replace(3,3,"05").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="JUN"){
        t1 = t.replace(3,3,"06").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="JUL"){
        t1 = t.replace(3,3,"07").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="AUG"){
        t1 = t.replace(3,3,"08").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="SEP"){
        t1 = t.replace(3,3,"09").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="OCT"){
        t1 = t.replace(3,3,"10").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="NOV"){
        t1 = t.replace(3,3,"11").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="DEC"){
        t1 = t.replace(3,3,"12").insert(6,"20").remove(19,2);
    }

    QDateTime time = QDateTime::fromString(t1, "dd-MM-yyyy hh:mm:ss");
    return time;
}
//转换时间为一般格式并返回时间的日期部分
static QDate get_cot_date(QString str){
    QString t = str;

    QString t1;
    if(t.mid(3,3)=="JAN"){
        t1 = t.replace(3,3,"01").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="FEB"){
        t1 = t.replace(3,3,"02").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="MAR"){
        t1 = t.replace(3,3,"03").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="APR"){
        t1 = t.replace(3,3,"04").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="MAY"){
        t1 = t.replace(3,3,"05").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="JUN"){
        t1 = t.replace(3,3,"06").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="JUL"){
        t1 = t.replace(3,3,"07").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="AUG"){
        t1 = t.replace(3,3,"08").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="SEP"){
        t1 = t.replace(3,3,"09").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="OCT"){
        t1 = t.replace(3,3,"10").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="NOV"){
        t1 = t.replace(3,3,"11").insert(6,"20").remove(19,2);
    }
    else if (t.mid(3,3)=="DEC"){
        t1 = t.replace(3,3,"12").insert(6,"20").remove(19,2);
    }

    QDateTime time = QDateTime::fromString(t1, "dd-MM-yyyy hh:mm:ss");
    return time.date();
}
//根据索引返回月份的文本格式
static QString get_cot_date_month(int month){

    if(month==1){
        return "JAN";
    }
    else if (month==2){
        return "FEB";
    }
    else if (month==3){
        return "MAR";
    }
    else if (month==4){
        return "APR";
    }
    else if (month==5){
        return "MAY";
    }
    else if (month==6){
        return "JUN";
    }
    else if (month==7){
        return "JUL";
    }
    else if (month==8){
        return "AUG";
    }
    else if (month==9){
        return "SEP";
    }
    else if (month==10){
        return "OCT";
    }
    else if (month==11){
        return "NOV";
    }
    else if (month==12){
        return "DEC";
    }
}
//将数据根据时间排序, 并将每一天的数据合并,值为一天的平均值
void MysqlServer::mdeal_with(QList<datas_time> *mdt){
    //    qDebug()<<mdt->count();
    if(mdt->count()==0)
        return;

    //时间排序整理
    for(int a=0;a<mdt->count();a++){
        for(int b=a;b<mdt->count();b++){
            if(mdt->at(a).time>mdt->at(b).time){
                mdt->swap(a,b);
            }
        }
    }

    //一天中的平均值
    for(int a=1;a<mdt->count();a++){
        if(mdt->at(a).time.date()==mdt->at(a-1).time.date()){
            (*mdt)[a-1].temp=(mdt->at(a).temp+mdt->at(a-1).temp)/2;
            //在索引位置删除该元素
            mdt->takeAt(a);
            //a代表了以天为单位的计数
            a--;
        }
    }

}
//将数据按时间进行排序
void MysqlServer::sortData (QList<datas_time> *mdt){
    if(mdt->count()==0)
        return;

    //时间排序整理

    for(int a=0;a<mdt->count();a++){
        for(int b=a;b<mdt->count();b++){
            if(mdt->at(a).time>mdt->at(b).time){
                mdt->swap(a,b);
            }
        }
    }
}
//插入数据到数据库
void MysqlServer::pushDatas(QString tubeNum,//炉号
                            QString forunNum,//管号
                            QString location,//位置（tube in ,tube out ,tube cot)
                            QString temp,//温度
                            QString dataTime//时间
                            ){

    //创建
    QSqlDatabase db=QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("192.168.0.167");
    db.setDatabaseName("schema");
    db.setUserName("root");
    db.setPassword("sky");

    //链接数据库
    if(db.open()){
        qDebug()<<"database is established!";
    }
    else{
        qDebug()<<"faled to connect to database";
    }
    QString table;
    if(location=="tube_in")
        table="table_in";
    else
        table="table_out";

    //获取数据,同时检查是否有重复数据，如果有就跳出函数
    QString querystr="SELECT Time from schema."+table+" where Time="+"'"+dataTime+"' AND TN='"+tubeNum+"' AND FN='"+forunNum+"'";
    QSqlQuery query;
    query.exec(querystr);

    if(query.next()){
        qDebug()<<"数据重复"<<endl;
        return;
    }

    //    INSERT INTO `schema1`.`table_out` (`idtable_out`, `FN`, `TN`, `Temp`, `Time`) VALUES ('1001', '5', '12', '970', '2015-02-19 09:20:23');
    //检查已经没有重复数据后把数据插入表中
    querystr="INSERT INTO `schema`.`"+table+"` (`FN`,`TN`,`Temp`,`Time`) VALUES ('"+forunNum+"','"+tubeNum+"','"+temp+"','"+dataTime+"')";
    query.clear();
    query.exec(querystr);
    db.close();
}

MysqlServer::MysqlServer(QObject *parent) :
    QObject(parent)
{
    connect (this,&MysqlServer::dumpDataOver,this,&MysqlServer::onDumpDataOver);
    //用户数据保存目录
    QString userDataPath=QDir::homePath ()+"/ethylene";
    QDir dir(userDataPath);
    if(!dir.exists ())
        dir.mkdir (userDataPath);

    if(!msettings.value ("dumpPath").toString ().isNull ()&& msettings.value ("dumpPath").toString ()!="")
        mdumpPath=msettings.value ("dumpPath").toString ();
    else
        mdumpPath=userDataPath;

    //初始化各个管的温度
    for(int a=0;a<48;a++){
        my_ethlene_datas.tube_in_temps[a]=0;
        my_ethlene_datas.tube_out_temps[a] = 0;
        my_ethlene_datas.cot_temp[a] = 0;
        my_ethlene_datas.time[a] = QDateTime();
        my_ethlene_datas.time1[a] = QDateTime();
        my_ethlene_datas.time2[a] = QDateTime();
    }
    //    QAxObject *excel;
    //    QAxObject *workbooks;
    //    QAxObject *workbook;
    //    QAxObject *worksheets;
    //    QAxObject *worksheet;
    this->excel=Q_NULLPTR;
    this->workbook=Q_NULLPTR;
    this->workbooks=Q_NULLPTR;
    //    this->worksheet=Q_NULLPTR;
    //    this->worksheets=Q_NULLPTR;

    //备份excel数据
    //    dumpDatas ();
}

MysqlServer *MysqlServer::instance()
{
    static MysqlServer *instance;
    if(!instance)
        instance = new MysqlServer();
    return instance;
}
//备份数据，每月备份一次当月的数据
void MysqlServer::dumpDatas (){
    //备份数据，每月备份一次当月的数据
    QDate date=QDate::currentDate ();
    date.setDate (date.year (),date.month ()-1,date.day ());
    QString fileName=QString::number (date.year ())+"-"+QString::number (date.month ())+".xlsx";
    QFile file(mdumpPath+"/"+fileName);
    if(file.exists ())
        return;
    date.setDate (date.year (),date.month (),1);
    QDateTime fromDate(date);
    date.setDate (date.year (),date.month (),date.daysInMonth ());
    //    QTime toTime;
    //    toTime.setHMS (23,59,59);
    QDateTime toDate(date);
    //    toDate.setTime (toTime);
    this->all_tube_show (5,fromDate,toDate);
    exportExcel (fileName);
}
//弹出警告对话框,并将参数作为内容
bool MysqlServer::isPushingIncompleteDatas(const QString& str)
{
    QDialog dialog;
    QFont font;
    font.setPixelSize(14);
    dialog.setFont(font);
    dialog.setFixedSize(500, 300);
    QVBoxLayout* layout = new QVBoxLayout;
    layout->addStretch();
    QLabel* strLabel = new QLabel(&dialog);
    strLabel->setText(str);
    layout->addWidget(strLabel, 0 , Qt::AlignHCenter);
    layout->addStretch();

    QPushButton* okBnt = new QPushButton("继续", &dialog);
    okBnt->setFixedHeight(40);
    QPushButton* cancleBnt = new QPushButton("取消", &dialog);
    cancleBnt->setFixedHeight(40);

    QHBoxLayout* bntLayout = new QHBoxLayout;

    bntLayout->addWidget(okBnt);
    bntLayout->addWidget(cancleBnt);

    layout->addLayout(bntLayout);
    dialog.setLayout(layout);

    connect(okBnt, &QPushButton::clicked, &dialog, &QDialog::accept);
    connect(cancleBnt, &QPushButton::clicked, &dialog, &QDialog::reject);

    return dialog.exec() == 0 ? false : true;
}

//管管比较之带cot
//根据炉号管号时间为条件以JSON格式返回管管比较所需要的数据
QJsonArray MysqlServer::compare_datas(int forunceNum,int tubeNum,QDateTime from_DateTime, QDateTime to_DateTime){

    //管管比较厚存放的数据
    QList<datas_time> tube_in_compare_datas; //sky:datas_time是头文件定义的结构体类型
    QList<datas_time> tube_out_compare_datas;
    QList<datas_time> tube_cot_compare_datas;
    //创建
    QSqlDatabase db=QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("192.168.0.167");
    db.setDatabaseName("schema");
    db.setUserName("root");
    db.setPassword("sky");

    //链接数据库
    if(db.open()){

        qDebug()<<"database is established!";
    }
    else{
        qDebug()<<"faled to connect to database";
    }
    //数据库查询对象
    QSqlQuery query;
    //过滤入管的数据语句
    QString sqlstr1="select * from table_in where FN="+QString::number (forunceNum)+
            " and TN='"+QString::number (tubeNum)+"'"+
            " and Time>='"+from_DateTime.date ().toString ("yyyy-MM-dd")+"'"+
            " and Time<='"+to_DateTime.date ().toString ("yyyy-MM-dd")+"'";
    query.exec(sqlstr1);
    //获取入管数据
    while(query.next()){
        datas_time data;
        data.time=query.value("Time").toDateTime();
        data.temp=query.value("Temp").toInt();
        tube_in_compare_datas.append(data);
    }
    //清空查询条件
    query.clear();
    //过滤出管的数据语句
    QString sqlstr2="select * from table_out where FN="+QString::number (forunceNum)+
            " and TN='"+QString::number (tubeNum)+"'"+
            " and Time>='"+from_DateTime.date ().toString ("yyyy-MM-dd")+"'"+
            " and Time<='"+to_DateTime.date ().toString ("yyyy-MM-dd")+"'";
    query.exec(sqlstr2);
    //获取出管数据
    while(query.next()){
        datas_time data;
        data.time=query.value("Time").toDateTime();
        data.temp=query.value("Temp").toInt();
        tube_out_compare_datas.append(data);
    }


    //关闭数据库
    db.close();
    //获取cot数据
    //创建石油厂数据接口
    QSqlDatabase cotdb=QSqlDatabase::addDatabase("QODBC");

    //连接石油厂数据库
    cotdb.setHostName("10.112.200.22");
    cotdb.setDatabaseName("History");
    cotdb.setPort(10014);

    bool existCot=false;

    if(cotdb.open()){
        existCot = true;
        qDebug()<<"remote database is established!";
        for ( int tubeNum = 1 ; tubeNum < 49 ; tubeNum++){
            QSqlQuery query1;
            query1.setForwardOnly(true);
            if(tubeNum<10){
                QString time1String = QString::number(from_DateTime.date().day(), 10)+"-"+get_cot_date_month(from_DateTime.date().month())+"-"+QString::number(from_DateTime.date().year(), 10).right(2);
                QString time2String = QString::number(to_DateTime.date().day(), 10)+"-"+get_cot_date_month(to_DateTime.date().month())+"-"+QString::number(to_DateTime.date().year(), 10).right(2);
                query1.exec("select name,ts,value from history where name like 'TI160"+QString::number(tubeNum, 10)+"_"+QString::number(forunceNum, 10)+"' and ts >='"+time1String+" 00:00:00.0' and ts<='"+time2String+" 23:59:59.0'");
                while(query1.next()){
                    datas_time data;
                    data.time=get_cot_dateTime(query1.value(1).toString());
                    data.temp=query1.value(2).toInt();
                    qDebug()<<"tubeCotNum : "<<tubeNum<<"time : "<<data.time<<"temp : "<<data.temp;
                    tube_cot_compare_datas.append(data);
                }
            }
            else {
                QString time1String = QString::number(from_DateTime.date().day(), 10)+"-"+get_cot_date_month(from_DateTime.date().month())+"-"+QString::number(from_DateTime.date().year(), 10).right(2);
                QString time2String = QString::number(to_DateTime.date().day(), 10)+"-"+get_cot_date_month(to_DateTime.date().month())+"-"+QString::number(to_DateTime.date().year(), 10).right(2);
                query1.exec("select name,ts,value from history where name like 'TI16"+QString::number(tubeNum, 10)+"_"+QString::number(forunceNum, 10)+"' and ts >='"+time1String+" 00:00:00.0' and ts<='"+time2String+" 23:59:59.0'");

                while(query1.next()){
                    datas_time data;
                    data.time=get_cot_dateTime(query1.value(1).toString());
                    data.temp=query1.value(2).toInt();
                    qDebug()<<"tubeCotNum : "<<tubeNum<<"time : "<<data.time<<"temp : "<<data.temp;
                    tube_cot_compare_datas.append(data);
                }
            }
        }
        cotdb.close();
        //将数据根据时间排序, 并将每一天的数据合并,值为一天的平均值
        mdeal_with(&tube_cot_compare_datas);
    }
    else{
        qDebug()<<"faled to connect to remote database";

    }

    //将数据根据时间排序, 并将每一天的数据合并,值为一天的平均值
    mdeal_with(&tube_in_compare_datas);
    //将数据根据时间排序, 并将每一天的数据合并,值为一天的平均值
    mdeal_with(&tube_out_compare_datas);


    //封装json数据库，给qml使用
    QJsonArray jsarr;
    for(int a=0;a<tube_in_compare_datas.count ();a++){
        QJsonObject obj1;
        obj1.insert ("time",tube_in_compare_datas.at (a).time.toString("yyyy-MM-dd hh:mm:ss"));
        //temp in
        obj1.insert ("temp_in",tube_in_compare_datas.at(a).temp);
        //temp out
        obj1.insert ("temp_out",tube_out_compare_datas.at(a).temp);
        //temp cot
        if(existCot){
            obj1.insert ("temp_cot",tube_cot_compare_datas.at(a).temp);
        }


        jsarr.append (obj1);
    }

    //清空临时链表
    tube_in_compare_datas.clear ();
    tube_out_compare_datas.clear ();
    tube_cot_compare_datas.clear ();

    return jsarr;
}


//全部显示之带cot
//根据炉号时间为条件以JSON格式返回所有管的数据
QJsonObject MysqlServer::all_tube_show(int forunceNum,QDateTime from_DateTime, QDateTime to_DateTime){

    QJsonObject root;
    QJsonArray tubeInData;
    QJsonArray tubeOutData;
    QJsonArray tubeCotData;

    from_DateTime.setTime(QTime(0,0));
    to_DateTime.setTime(QTime(23,59,59));

    //    qDebug()<<"全部显示的日期为："<<from_DateTime.toString(Qt::ISODate)<<"  到  "<<to_DateTime.toString(Qt::ISODate);

    //清空数据
    for(int i = 0 ; i <48 ; i++){
        tube_in_full_search_datas[i].clear();
        tube_out_full_search_datas[i].clear();
        tube_cot_full_search_datas[i].clear();
    }
    //创建
    QSqlDatabase db=QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("192.168.0.167");
    db.setDatabaseName("schema");
    db.setUserName("root");
    db.setPassword("sky");

    //链接数据库
    if(db.open()){
        qDebug()<<"database is established!";
    }
    else{
        qDebug()<<"faled to connect to database";
    }

    //获取数据
    QSqlQuery query;
    QList<QDateTime> get_outTime_forCot[48];

    //sky:入管温度数据查询
    QString sqlstr1="select * from table_in where FN="+QString::number (forunceNum)+
            " and Time>='"+from_DateTime.date ().toString ("yyyy-MM-dd")+"'"+
            " and Time<='"+to_DateTime.date ().toString ("yyyy-MM-dd")+"'";
    query.exec (sqlstr1);

    int ttilikaibin=0;//sky:李凯彬？？
    while(query.next ()){
        ttilikaibin++;
        const int& tn = query.value("TN").toInt();
        const int& temp = query.value("Temp").toInt();
        const QDateTime& dt = query.value("Time").toDateTime();

        if(tn < 1 || tn > 48)
            continue;
        if(temp < 0)
            continue;

        datas_time data;
        data.time = dt;
        data.temp = temp;
        tube_in_full_search_datas[tn - 1].append (data);
    }
    qDebug()<<"应该是这？："<<ttilikaibin<<endl;//sky:测试用的？
    query.clear ();

    //sky:出管温度数据查询
    sqlstr1="select * from table_out where FN="+QString::number (forunceNum)+
            " and Time>='"+from_DateTime.date ().toString ("yyyy-MM-dd")+"'"+
            " and Time<='"+to_DateTime.date ().toString ("yyyy-MM-dd")+"'";

    query.exec (sqlstr1);
    while (query.next ()) {
        const int& tn = query.value("TN").toInt();
        const int& temp = query.value("Temp").toInt();
        const QDateTime& dt = query.value("Time").toDateTime();

        if(tn < 1 || tn > 48)
            continue;
        if(temp < 0)
            continue;

        datas_time data;
        data.time = dt;
        data.temp = temp;
        tube_out_full_search_datas[tn - 1].append (data);
        get_outTime_forCot[tn - 1].append(data.time);
    }

    //获取cot数据
    //创建石油厂数据接口
    QSqlDatabase cotdb=QSqlDatabase::addDatabase("QODBC");

    //连接石油厂数据库
    cotdb.setHostName("10.112.200.22");
    cotdb.setDatabaseName("History");
    cotdb.setPort(10014);

    bool existCot =false;

    if(cotdb.open()){
        qDebug()<<"remote database is established!";
        existCot = true;
        for ( int tubeNum = 1 ; tubeNum < 49 ; tubeNum++){
            QSqlQuery query1;
            query1.setForwardOnly(true);
            if(tubeNum<10){
                QString time1String = QString::number(from_DateTime.date().day(), 10)+"-"+get_cot_date_month(from_DateTime.date().month())+"-"+QString::number(from_DateTime.date().year(), 10).right(2);
                QString time2String = QString::number(to_DateTime.date().day(), 10)+"-"+get_cot_date_month(to_DateTime.date().month())+"-"+QString::number(to_DateTime.date().year(), 10).right(2);
                query1.exec("select name,ts,value from history where name like 'TI160"+QString::number(tubeNum, 10)+"_"+QString::number(forunceNum, 10)+"' and ts >='"+time1String+" 00:00:00.0' and ts<='"+time2String+" 23:59:59.0'");
                while(query1.next()){
                    datas_time data;
                    data.time=get_cot_dateTime(query1.value(1).toString());
                    data.temp=query1.value(2).toInt();
                    qDebug()<<"tubeCotNum : "<<tubeNum<<"time : "<<data.time<<"temp : "<<data.temp;
                    tube_cot_full_search_datas[tubeNum-1].append(data);
                }
            }
            else {
                QString time1String = QString::number(from_DateTime.date().day(), 10)+"-"+get_cot_date_month(from_DateTime.date().month())+"-"+QString::number(from_DateTime.date().year(), 10).right(2);
                QString time2String = QString::number(to_DateTime.date().day(), 10)+"-"+get_cot_date_month(to_DateTime.date().month())+"-"+QString::number(to_DateTime.date().year(), 10).right(2);
                query1.exec("select name,ts,value from history where name like 'TI16"+QString::number(tubeNum, 10)+"_"+QString::number(forunceNum, 10)+"' and ts >='"+time1String+" 00:00:00.0' and ts<='"+time2String+" 23:59:59.0'");

                while(query1.next()){
                    datas_time data;
                    data.time=get_cot_dateTime(query1.value(1).toString());
                    data.temp=query1.value(2).toInt();
                    qDebug()<<"tubeCotNum : "<<tubeNum<<"time : "<<data.time<<"temp : "<<data.temp;
                    tube_cot_full_search_datas[tubeNum-1].append(data);
                }
            }
        }

        for(int a=0;a<48;a++){
            sortData(&tube_cot_full_search_datas[a]);
        }
    }
    else{
        qDebug()<<"faled to connect to remote database";

    }


    //生成json数据
    for(int a=0;a<48;a++){
        QJsonArray jsarr1;
        QJsonArray jsarr2;
        QJsonArray jsarr3;
        for(auto it:tube_in_full_search_datas[a]){
            QJsonObject obj;
            obj.insert ("time",it.time.toString ("yy/M/d hh:mm:ss"));
            obj.insert ("temp",it.temp);
            //qDebug()<<"time"<<it.time.toString ("yy/M/d hh:mm:ss")<<"  Temp:"<<it.temp;
            jsarr1.append (obj);
        }
        for(auto it:tube_out_full_search_datas[a]){
            QJsonObject obj;
            obj.insert ("time",it.time.toString ("yy/M/d hh:mm:ss"));
            obj.insert ("temp",it.temp);
            jsarr2.append (obj);
        }
        if(existCot){
            for(auto it:tube_cot_full_search_datas[a]){
                QJsonObject obj;
                obj.insert ("time",it.time.toString ("yy/M/d hh:mm:ss"));
                obj.insert ("temp",it.temp);
                jsarr3.append (obj);
            }
        }

        QJsonObject o1;
        QJsonObject o2;
        QJsonObject o3;
        o1.insert("data",jsarr1);
        o2.insert("data",jsarr2);
        o3.insert("data",jsarr3);
        tubeInData.append (o1);
        tubeOutData.append (o2);
        qDebug()<<"YY1:"+jsarr1.count();//<<"YY2:"<<jsarr2.count()<<"YY3:"<<jsarr1.count<<endl;

        //test for cot data
        tubeCotData.append (o3);
    }

    root.insert ("tubeInData",tubeInData);
    root.insert ("tubeOutData",tubeOutData);
    if(existCot){
        root.insert ("tubeCotData",tubeCotData);
        cotdb.close();
    }else {
        root.insert("tubeCotData","null");
    }
    


    //关闭数据库
    db.close();

    //test
    qDebug()<<"LLL:"<<QString(QJsonDocument(root).toJson());

    return root;

    //    //处理数据
    //    qDebug()<<"数据处理****************：“";
    //    mdeal_with(&tube_in_show_datas);
    //    mdeal_with(&tube_out_show_datas);

}

//返回当前用户对象
QString MysqlServer::currentUser()
{
    return m_currentUser;
}
//返回当前用户对象权限
int MysqlServer::currentUserAccess()
{
    return m_access;
}


//获取 入管 的最新温度
QJsonArray MysqlServer::access_tube_in_temp(){
    //创建
    QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("192.168.0.167");
    db.setDatabaseName("schema");
    db.setUserName("root");
    db.setPassword("sky");

    //链接数据库
    if(db.open())
        qDebug()<<"database is established!";
    else
        qDebug()<<"faled to connect to database";

    //获取数据
    QSqlQuery query;
    query.exec("SELECT * FROM schema.table_in where Time in(select max(Time) from schema.table_in group by TN)");
//    query.exec("SELECT * FROM table_in ORDER BY table_in.Time DESC");

    //json 数据
    QJsonArray jsarr;
    //    QJsonObject root;

    //数据获取
    while(query.next()){
        //判断初始值是否为空d
        const int tn = query.value("TN").toInt();
        const QDateTime dt = query.value("Time").toDateTime();
        const int temp = query.value("Temp").toInt();

        if(tn < 1 || tn > 48)
            continue;

        if(temp < 0)
            continue;

        //保存最新温度数据，方便后面作时间比较
        my_ethlene_datas.tube_in_temps[tn-1] = temp;
        my_ethlene_datas.time[tn-1] = dt;
    }
    for(int i = 0; i < 48; i++){
        QJsonObject jsobj;
        jsobj.insert ("temp",my_ethlene_datas.tube_in_temps[i]);
        jsobj.insert ("time",my_ethlene_datas.time[i].toString("yyyy-MM-dd hh:mm:ss"));
        jsarr.append (jsobj);
    }
    //关闭数据库
    db.close();
    //    root.insert ("datas",jsarr);
    return jsarr;
}
//获取 出管 的最新温度
QJsonArray MysqlServer::access_tube_out_temp(){
    //创建
    QSqlDatabase db=QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("192.168.0.167");
    db.setDatabaseName("schema");
    db.setUserName("root");
    db.setPassword("sky");

    //链接数据库
    if(db.open())
        qDebug()<<"database is established!";
    else
        qDebug()<<"faled to connect to database";

    //json 数据
    QJsonArray jsarr;

    //获取数据
    QSqlQuery query;
    query.exec("SELECT * FROM schema.table_out where Time in(select max(Time) from schema.table_out group by TN)");
//    query.exec("SELECT	* FROM	table_out ORDER BY	table_out.Time DESC");

    //数据获取
    while(query.next()){
        //判断初始值是否为空
        const int tn = query.value("TN").toInt();
        const QDateTime dt = query.value("Time").toDateTime();
        const int temp = query.value("Temp").toInt();

        if(tn < 1 || tn > 48)
            continue;
        if(temp < 0)
            continue;

        //保存最新温度数据，方便后面作时间比较
        my_ethlene_datas.tube_out_temps[tn-1] = temp;
        my_ethlene_datas.time1[tn-1] = dt;
    }

    for(int i = 0; i < 48; i++){
        QJsonObject jsobj;
        jsobj.insert ("temp",my_ethlene_datas.tube_out_temps[i]);
        jsobj.insert ("time",my_ethlene_datas.time1[i].toString("yyyy-MM-dd hh:mm:ss"));
        jsarr.append (jsobj);
    }
    //关闭数据库
    db.close();
    return jsarr;

}

//获取 ＣＯＴ 的最新温度
//转换成单独CotServer
QJsonArray MysqlServer::access_tube_cot_temp(){
    //链接石油厂数据
    QSqlDatabase db=QSqlDatabase::addDatabase("QODBC");
    //json 数据
    QJsonArray jsarr;

    //链接石油厂数据库
    db.setHostName("10.112.200.22");
    db.setDatabaseName("History");
    db.setPort(10014);
    if(db.open()){

        qDebug()<<"remote database is established!";
    }
    else{
        qDebug()<<"faled to connect to remote database";
        return jsarr;
    }

    //通过链接石油厂数据库加载COT温度数据
    QSqlQuery query1;
    query1.setForwardOnly(true);
    //    qDebug()<<query1.isForwardOnly();


    //第一种查询方法：48次查询来初始化cot数据
    for (int i=1;i<=48;i++){
        if(i<10){
            QString time1String = my_ethlene_datas.time1[i-1].toString("dd-MM-yy HH-mm-ss").left(2)+"-"+get_cot_date_month(my_ethlene_datas.time1[i-1].date().month())+"-"+my_ethlene_datas.time1[i-1].toString("dd-MM-yy HH-mm-ss").mid(6,2)+" "+my_ethlene_datas.time1[i-1].toString("dd-MM-yy HH-mm-ss").mid(9,2)+":"+my_ethlene_datas.time1[i-1].toString("dd-MM-yy HH-mm-ss").mid(12,2);
            qDebug()<<"查询检查BBB"<<query1.exec("select name,ts,value from history where name like 'TI160"+QString::number(i, 10)+"_5' and ts >='"+time1String+":00.0' and ts<='"+time1String+":59.0'");

            while(query1.next()){
                if(my_ethlene_datas.time2[i-1].toString()==""||
                        ( my_ethlene_datas.time1[i-1].date()==get_cot_date(query1.value(1).toString())&&
                          my_ethlene_datas.time1[i-1].time().hour()==get_cot_dateTime(query1.value(1).toString()).time().hour()&&
                          my_ethlene_datas.time1[i-1].time().minute()==get_cot_dateTime(query1.value(1).toString()).time().minute()
                          )){
                    my_ethlene_datas.time2[i-1]=get_cot_dateTime(query1.value(1).toString());
                    my_ethlene_datas.cot_temp[i-1]=query1.value(2).toInt();
                }
            }
            for(int i = 0; i<48; i++){
                QJsonObject jsobj;
                jsobj.insert ("temp",my_ethlene_datas.cot_temp[i]);
                jsobj.insert ("time",my_ethlene_datas.time2[i].toString("yyyy-MM-dd hh:mm:ss"));
                jsarr.append (jsobj);
            }
        }
        else {
            QString time1String = my_ethlene_datas.time1[i-1].toString("dd-MM-yy HH-mm-ss").left(2)+"-"+get_cot_date_month(my_ethlene_datas.time1[i-1].date().month())+"-"+my_ethlene_datas.time1[i-1].toString("dd-MM-yy HH-mm-ss").mid(6,2)+" "+my_ethlene_datas.time1[i-1].toString("dd-MM-yy HH-mm-ss").mid(9,2)+":"+my_ethlene_datas.time1[i-1].toString("dd-MM-yy HH-mm-ss").mid(12,2);
            qDebug()<<"查询检查BBB"<<query1.exec("select name,ts,value from history where name like 'TI16"+QString::number(i, 10)+"_5' and ts >='"+time1String+":00.0' and ts<='"+time1String+":59.0'");


            while(query1.next()){
                if(my_ethlene_datas.time2[i-1].toString()==""||
                        ( my_ethlene_datas.time1[i-1].date()==get_cot_date(query1.value(1).toString())&&
                          my_ethlene_datas.time1[i-1].time().hour()==get_cot_dateTime(query1.value(1).toString()).time().hour()&&
                          my_ethlene_datas.time1[i-1].time().minute()==get_cot_dateTime(query1.value(1).toString()).time().minute()
                          )){
                    my_ethlene_datas.time2[i-1]=get_cot_dateTime(query1.value(1).toString());
                    my_ethlene_datas.cot_temp[i-1]=query1.value(2).toInt();
                }
            }
            for(int i = 0; i<48; i++){
                QJsonObject jsobj;
                jsobj.insert ("temp",my_ethlene_datas.cot_temp[i]);
                jsobj.insert ("time",my_ethlene_datas.time2[i].toString("yyyy-MM-dd hh:mm:ss"));
                jsarr.append (jsobj);
            }
        }
    }


    //断开远程数据库连接
    db.close();

    return jsarr;

}

//使用详细看压缩文件中的说明文档。ODBC配置后，SQL语句访问实时数据库的表名为history，字段名分别为name（位号）、ts（时间）、value（值）。这里的位号就是炉管号，如48号管，位号就是TI1648_5，45号管，位号就是TI1645_5；时间格式是“日-月-年”，且月份用英文缩写；值就是对应炉管的COT值。一个例子：select name,ts,value

//诊断与检测函数 根据条件返回压力数据
QJsonArray MysqlServer::pressureData(int forunceNum,int tubeNum,QDateTime from_DateTime,QDateTime to_DateTime){
    //清空数据
    pressure_test_datas.clear();

    QJsonArray pressureData;

    /**********************************查询本机的数据库**********************************/
    //创建
    QSqlDatabase db=QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("192.168.0.167");
    db.setDatabaseName("schema");
    db.setUserName("root");
    db.setPassword("sky");

    //链接数据库
    if(db.open()){

        qDebug()<<"database is established!";
    }
    else{
        qDebug()<<"faled to connect to database";
    }

    QString sqlstr1="select * from pressures where FN="+QString::number (forunceNum)+
            " and TN='"+QString::number (tubeNum)+"'"+
            " and time>='"+from_DateTime.date ().toString ("yyyy-MM-dd")+"'"+
            " and time<='"+to_DateTime.date ().toString ("yyyy-MM-dd")+"'";

    //获取数据
    QSqlQuery query;
    //过滤入管的数据语句
    query.exec(sqlstr1);
    //数据获取
    while(query.next()){
        datas_time data;
        data.time=query.value("time").toDateTime();
        data.temp=query.value("value").toInt();
        pressure_test_datas.append(data);
    }

    //关闭数据库
    db.close();
    /**********************************查询本机的数据库**********************************/

    //处理数据
    mdeal_with(&pressure_test_datas);

    //return data

    for(auto it : pressure_test_datas){
        QJsonObject obj;
        obj.insert ("time",it.time.toString ("yyyy-MM-dd hh:mm:ss"));
        obj.insert ("value",it.temp);
        pressureData.append (obj);
    }
    return pressureData;
}
//指定导出路径并导出excel(带COT版)
bool MysqlServer::exportExcel1()      //手动导出excel
{

    QString fileName=QDateTime::currentDateTime ().toString ("yyyy-MM-dd hh_mm_ss");
    QString format=".xlsx";
    QString filePath=QDir::root ().path ();
    QString creatPath=QFileDialog::getSaveFileName(0,tr("Export Excel"),filePath+"/"+fileName+format,tr("Microsoft Office 2003 (*.xlsx)"));//获取保存路径
    //调用高级线程 (其中使用了lambda表达式“[]{...}”作为匿名函数使用)
    QtConcurrent::run([this,creatPath]{
        HRESULT r = OleInitialize(0);
        if (r != S_OK && r != S_FALSE)
        {
            qWarning("Qt:初始化Ole失败（error %x）",(unsigned int)r);
        }
        qDebug()<<"bool excell 1"<<endl;
        if(!creatPath.isEmpty()){
            qDebug()<<"bool excell 1.1"<<endl;
            excel = new QAxObject();
            qDebug()<<"bool excell 1.2"<<endl;
            excel->setControl("Excel.Application");
            qDebug()<<"bool excell 1.3"<<endl;
            excel->dynamicCall("SetVisible (bool Visible)","false");//不显示窗体
            qDebug()<<"bool excell 1.4"<<endl;
            excel->setProperty("DisplayAlerts", false);//不显示任何警告信息。如果为true那么在关闭是会出现类似“文件已修改，是否保存”的提示
            workbooks = excel->querySubObject("WorkBooks");//获取工作簿集合
            workbooks->dynamicCall("Add");//新建一个工作簿
            workbook = excel->querySubObject("ActiveWorkBook");//获取当前工作簿
            worksheets = workbook->querySubObject("Sheets");//获取工作表集合
            worksheets->querySubObject("Add()");
            QAxObject * a = worksheets->querySubObject("Item(int)", 1);
            a->setProperty("Name","exportExcel");

            worksheet = worksheets->querySubObject("Item(const QString&)", "exportExcel");//获取工作表集合的工作表名

            //写表头，第一行
            QAxObject *header;
            QString  headerStr;
            qDebug()<<"bool excell 2"<<endl;
            for ( int j = 1 ; j < 49 ; j++)
            {
                header = worksheet->querySubObject("Cells(int,int)", 1,6*j-5);//获取单元格
                headerStr = "第"+ QString::number(j) + "号管";
                header->dynamicCall("Value", headerStr);//设置单元格的值
                header = header->querySubObject("Font");
                header->setProperty("Bold", true);//设置黑体
            }
            QStringList AtoZ;
            AtoZ<<""<<"A"<<"B"<<"C"<<"D"<<"E"<<"F"<<"G"<<"H"<<"I"<<"J"<<"K"<<"L"<<"M"<<"N"<<"O"<<"P"<<"Q"<<"R"<<"S"<<"T"<<"U"<<"V"<<"W"<<"X"<<"Y"<<"Z";
            QStringList AAZZ;
            AAZZ<<""<<"A"<<"B"<<"C"<<"D"<<"E"<<"F"<<"G"<<"H"<<"I"<<"J"<<"K"<<"L"<<"M"<<"N"<<"O"<<"P"<<"Q"<<"R"<<"S"<<"T"<<"U"<<"V"<<"W"<<"X"<<"Y"<<"Z";
            qDebug()<<"bool excell 3"<<endl;
            for ( int i = 1 ; i < 27 ; i++)
            {
                for(int j = 1 ; j <27 ;j++)
                {
                    AAZZ.append(AtoZ.at(i)+AtoZ.at(j));
                }
            }
            //左右居中 合并单元格
            qDebug()<<"bool excell 4"<<endl;
            for ( int j = 1 ; j < 289 ; j++)
            {
                QString cell;
                cell.append(AAZZ.at(j));
                cell.append(QString::number(1));
                cell.append(":");
                cell.append(AAZZ.at(j+5));
                cell.append(QString::number(1));
                QAxObject *range = worksheet->querySubObject("Range(const QString&)", cell);
                //                range->setProperty("VerticalAlignment", -4108);//xlCenter上下居中
                range->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                range->setProperty("WrapText", true);
                range->setProperty("MergeCells", true);
                j = j+5;
            }
            //表头
            qDebug()<<"bool excell 5"<<endl;
            for ( int j = 1 ; j < 49 ; j++)
            {
                header = worksheet->querySubObject("Cells(int,int)", 2,6*j-5);//获取单元格
                headerStr = "入管时间";
                header->dynamicCall("Value", headerStr);//设置单元格的值
                header->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                header = header->querySubObject("Font");
                header->setProperty("Bold", true);//设置黑体
                QString columnsStr;
                columnsStr = AAZZ.at(6*j-5) + ":"+AAZZ.at(6*j-5);
                header= worksheet->querySubObject("Columns(const QString&)",columnsStr );
                header->setProperty("ColumnWidth", 27);//设置列宽

                header = worksheet->querySubObject("Cells(int,int)", 2,6*j-4);//获取单元格
                headerStr = "入管温度";
                header->dynamicCall("Value", headerStr);//设置单元格的值
                header->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                header = header->querySubObject("Font");
                header->setProperty("Bold", true);//设置黑体

                header = worksheet->querySubObject("Cells(int,int)", 2,6*j-3);//获取单元格
                headerStr = "出管时间";
                header->dynamicCall("Value", headerStr);//设置单元格的值
                header->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                header = header->querySubObject("Font");
                header->setProperty("Bold", true);//设置黑体
                columnsStr = AAZZ.at(6*j-3) + ":"+AAZZ.at(6*j-3);
                header= worksheet->querySubObject("Columns(const QString&)",columnsStr );
                header->setProperty("ColumnWidth", 27);//设置列宽

                header = worksheet->querySubObject("Cells(int,int)", 2,6*j-2);//获取单元格
                headerStr = "出管温度";
                header->dynamicCall("Value", headerStr);//设置单元格的值
                header->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                header = header->querySubObject("Font");
                header->setProperty("Bold", true);//设置黑体

                header = worksheet->querySubObject("Cells(int,int)", 2,6*j-1);//获取单元格
                headerStr = "Cot时间";
                header->dynamicCall("Value", headerStr);//设置单元格的值
                header->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                header = header->querySubObject("Font");
                header->setProperty("Bold", true);//设置黑体
                columnsStr = AAZZ.at(6*j-1) + ":"+AAZZ.at(6*j-1);
                header= worksheet->querySubObject("Columns(const QString&)",columnsStr );
                header->setProperty("ColumnWidth", 27);//设置列宽

                header = worksheet->querySubObject("Cells(int,int)", 2,6*j-0);//获取单元格
                headerStr = "COT温度";
                header->dynamicCall("Value", headerStr);//设置单元格的值
                header->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                header = header->querySubObject("Font");
                header->setProperty("Bold", true);//设置黑体
            }
            //左右居中
            //写数据
            QAxObject *datas;
            QString  datasStr;
            qDebug()<<"bool excell 7"<<endl;
            for ( int i  = 1 ; i < 49 ; i++ )
            {
                //入管时间和温度
                int j=0;
                for ( auto it:tube_in_full_search_datas[i-1])
                {

                    datasStr = it.time.toString(Qt::ISODate);
                    datas = worksheet->querySubObject("Cells(int,int)", j+3,i*6-5);//获取单元格
                    datas->dynamicCall("Value", datasStr);//设置单元格的值
                    datas->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中

                    datasStr = QString::number(it.temp);
                    datas = worksheet->querySubObject("Cells(int,int)", j+3,i*6-4);//获取单元格
                    datas->dynamicCall("Value", datasStr);//设置单元格的值
                    datas->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中

                    j++;
                }
                j=0;
                //出管时间和温度
                qDebug()<<"bool excell 8"<<endl;
                for ( auto it: tube_out_full_search_datas[i-1])
                {
                    datasStr = it.time.toString(Qt::ISODate);
                    datas = worksheet->querySubObject("Cells(int,int)", j+3,i*6-3);//获取单元格
                    datas->dynamicCall("Value", datasStr);//设置单元格的值
                    datas->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中

                    datasStr = QString::number(it.temp);
                    datas = worksheet->querySubObject("Cells(int,int)", j+3,i*6-2);//获取单元格
                    datas->dynamicCall("Value", datasStr);//设置单元格的值
                    datas->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中

                    j++;
                }
                j=0;
                //COT温度
                qDebug()<<"bool excell 9"<<endl;
                for ( auto it:tube_cot_full_search_datas[i-1])
                {
                    qDebug()<<"有毒不"<<endl;
                    datasStr = it.time.toString(Qt::ISODate);
                    datas = worksheet->querySubObject("Cells(int,int)", j+3,i*6-1);//获取单元格
                    datas->dynamicCall("Value", datasStr);//设置单元格的值
                    datas->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中


                    datasStr = QString::number(it.temp);
//                    datasStr = it.temp.toString(Qt::ISODate);
//                    datasStr = "无COTtemp";
                    datas = worksheet->querySubObject("Cells(int,int)", j+3,i*6);//获取单元格
                    datas->dynamicCall("Value", datasStr);//设置单元格的值
                    datas->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                    j++;
                }
            }

            //保存并关闭
            qDebug()<<"bool excell 10"<<endl;
            workbook->dynamicCall("SaveAs(const QString&)",QDir::toNativeSeparators(creatPath));//保存至creatPath，注意一定要用QDir::toNativeSeparators将路径中的"/"转换为"\"，不然一定保存不了。
            workbook->dynamicCall("Close()");//关闭工作簿
        }

        OleUninitialize();
    });//end thread
    return true;
}
//根据导出excel到指定路径
void MysqlServer::exportExcel ( QString creatPath){
    //    QString creatPath=mdumpPath+"/"+fileName;
    //    QString creatPath=fileName;
    qDebug()<<"存储路径"<<creatPath;
    //调用高级线程 (其中使用了lambda表达式“[]{...}”作为匿名函数使用)
    QtConcurrent::run([this,creatPath]{
        HRESULT r = OleInitialize(0);
        if (r != S_OK && r != S_FALSE)
        {
            qWarning("Qt:初始化Ole失败（error %x）",(unsigned int)r);
        }
        if(!creatPath.isEmpty()){
            qDebug()<<"excll   1"<<endl ;
            excel = new QAxObject(this);
            excel->setControl("Excel.Application");
            excel->dynamicCall("SetVisible (bool Visible)","false");//不显示窗体
            excel->setProperty("DisplayAlerts", false);//不显示任何警告信息。如果为true那么在关闭是会出现类似“文件已修改，是否保存”的提示
            qDebug()<<"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<5";
            workbooks = excel->querySubObject("WorkBooks");//获取工作簿集合

            workbooks->dynamicCall("Add");//新建一个工作簿
            qDebug()<<"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<1";
            workbook = excel->querySubObject("ActiveWorkBook");//获取当前工作簿

            worksheets = workbook->querySubObject("Sheets");//获取工作表集合

            worksheets->querySubObject("Add()");

            QAxObject * a = worksheets->querySubObject("Item(int)", 1);
            a->setProperty("Name","exportExcel");
            worksheet = worksheets->querySubObject("Item(const QString&)", "exportExcel");//获取工作表集合的工作表名

            //写表头
            QAxObject *header;
            QString  headerStr;
            qDebug()<<"excll   2"<<endl ;
            for ( int j = 1 ; j < 49 ; j++)
            {
                header = worksheet->querySubObject("Cells(int,int)", 1,6*j-5);//获取单元格
                headerStr = "第"+ QString::number(j) + "号管";
                header->dynamicCall("Value", headerStr);//设置单元格的值
                header = header->querySubObject("Font");
                header->setProperty("Bold", true);//设置黑体
            }
            QStringList AtoZ;
            AtoZ<<""<<"A"<<"B"<<"C"<<"D"<<"E"<<"F"<<"G"<<"H"<<"I"<<"J"<<"K"<<"L"<<"M"<<"N"<<"O"<<"P"<<"Q"<<"R"<<"S"<<"T"<<"U"<<"V"<<"W"<<"X"<<"Y"<<"Z";
            QStringList AAZZ;
            AAZZ<<""<<"A"<<"B"<<"C"<<"D"<<"E"<<"F"<<"G"<<"H"<<"I"<<"J"<<"K"<<"L"<<"M"<<"N"<<"O"<<"P"<<"Q"<<"R"<<"S"<<"T"<<"U"<<"V"<<"W"<<"X"<<"Y"<<"Z";
            qDebug()<<"excll   3"<<endl ;
            for ( int i = 1 ; i < 27 ; i++)
            {
                for(int j = 1 ; j <27 ;j++)
                {
                    AAZZ.append(AtoZ.at(i)+AtoZ.at(j));
                }
            }
            //左右居中 合并单元格
            qDebug()<<"excll   4"<<endl ;
            for ( int j = 1 ; j < 289 ; j++)
            {
                QString cell;
                cell.append(AAZZ.at(j));
                cell.append(QString::number(1));
                cell.append(":");
                cell.append(AAZZ.at(j+5));
                cell.append(QString::number(1));
                QAxObject *range = worksheet->querySubObject("Range(const QString&)", cell);
                //                range->setProperty("VerticalAlignment", -4108);//xlCenter上下居中
                range->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                range->setProperty("WrapText", true);
                range->setProperty("MergeCells", true);
                j = j+5;
            }
            //表头
            qDebug()<<"excll   5"<<endl ;
            for ( int j = 1 ; j < 49 ; j++)
            {
                header = worksheet->querySubObject("Cells(int,int)", 2,6*j-5);//获取单元格
                headerStr = "入管时间";
                header->dynamicCall("Value", headerStr);//设置单元格的值
                header->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                header = header->querySubObject("Font");
                header->setProperty("Bold", true);//设置黑体
                QString columnsStr;
                columnsStr = AAZZ.at(6*j-5) + ":"+AAZZ.at(6*j-5);
                header= worksheet->querySubObject("Columns(const QString&)",columnsStr );
                header->setProperty("ColumnWidth", 27);//设置列宽

                header = worksheet->querySubObject("Cells(int,int)", 2,6*j-4);//获取单元格
                headerStr = "入管温度";
                header->dynamicCall("Value", headerStr);//设置单元格的值
                header->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                header = header->querySubObject("Font");
                header->setProperty("Bold", true);//设置黑体

                header = worksheet->querySubObject("Cells(int,int)", 2,6*j-3);//获取单元格
                headerStr = "出管时间";
                header->dynamicCall("Value", headerStr);//设置单元格的值
                header->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                header = header->querySubObject("Font");
                header->setProperty("Bold", true);//设置黑体
                columnsStr = AAZZ.at(6*j-3) + ":"+AAZZ.at(6*j-3);
                header= worksheet->querySubObject("Columns(const QString&)",columnsStr );
                header->setProperty("ColumnWidth", 27);//设置列宽

                header = worksheet->querySubObject("Cells(int,int)", 2,6*j-2);//获取单元格
                headerStr = "出管温度";
                header->dynamicCall("Value", headerStr);//设置单元格的值
                header->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                header = header->querySubObject("Font");
                header->setProperty("Bold", true);//设置黑体

                header = worksheet->querySubObject("Cells(int,int)", 2,6*j-1);//获取单元格
                headerStr = "Cot时间";
                header->dynamicCall("Value", headerStr);//设置单元格的值
                header->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                header = header->querySubObject("Font");
                header->setProperty("Bold", true);//设置黑体
                columnsStr = AAZZ.at(6*j-1) + ":"+AAZZ.at(6*j-1);
                header= worksheet->querySubObject("Columns(const QString&)",columnsStr );
                header->setProperty("ColumnWidth", 27);//设置列宽

                header = worksheet->querySubObject("Cells(int,int)", 2,6*j-0);//获取单元格
                headerStr = "COT温度";
                header->dynamicCall("Value", headerStr);//设置单元格的值
                header->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                header = header->querySubObject("Font");
                header->setProperty("Bold", true);//设置黑体
            }
            //左右居中
            qDebug()<<"excll   6"<<endl ;
            for ( int j = 1 ; j < 241 ; j++)
            {
                header = worksheet->querySubObject("Cells(int,int)", 3,j);//获取单元格
                header->dynamicCall("Value", QString::number(j));//设置单元格的值
                header->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
            }
            //写数据
            QAxObject *datas;
            QString  datasStr;
            qDebug()<<"excll   7"<<endl ;
            for ( int i  = 1 ; i < 49 ; i++ )
            {
                //入管时间和温度
                int j=0;
                for ( auto it:tube_in_full_search_datas[i-1])
                {

                    datasStr = it.time.toString(Qt::ISODate);
                    datas = worksheet->querySubObject("Cells(int,int)", j+3,i*6-5);//获取单元格
                    datas->dynamicCall("Value", datasStr);//设置单元格的值
                    datas->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中

                    datasStr = QString::number(it.temp);
                    datas = worksheet->querySubObject("Cells(int,int)", j+3,i*6-4);//获取单元格
                    datas->dynamicCall("Value", datasStr);//设置单元格的值
                    datas->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中

                    j++;
                }
                j=0;
                //出管时间和温度
                for ( auto it: tube_out_full_search_datas[i-1])
                {
                    datasStr = it.time.toString(Qt::ISODate);
                    datas = worksheet->querySubObject("Cells(int,int)", j+3,i*6-3);//获取单元格
                    datas->dynamicCall("Value", datasStr);//设置单元格的值
                    datas->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中

                    datasStr = QString::number(it.temp);
                    datas = worksheet->querySubObject("Cells(int,int)", j+3,i*6-2);//获取单元格
                    datas->dynamicCall("Value", datasStr);//设置单元格的值
                    datas->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中

                    j++;
                }
                j=0;
                //COT温度
                for ( auto it:tube_cot_full_search_datas[i-1])
                {
                    datasStr = it.time.toString(Qt::ISODate);
                    datas = worksheet->querySubObject("Cells(int,int)", j+3,i*6-1);//获取单元格
                    datas->dynamicCall("Value", datasStr);//设置单元格的值
                    datas->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中

                    datasStr = QString::number(it.temp);
                    datas = worksheet->querySubObject("Cells(int,int)", j+3,i*6);//获取单元格
                    datas->dynamicCall("Value", datasStr);//设置单元格的值
                    datas->setProperty("HorizontalAlignment", -4108);//xlCenter左右居中
                    j++;
                }
            }

            //保存并关闭
            qDebug()<<"excll   8"<<endl ;
            workbook->dynamicCall("SaveAs(const QString&)",QDir::toNativeSeparators(creatPath));//保存至creatPath，注意一定要用QDir::toNativeSeparators将路径中的"/"转换为"\"，不然一定保存不了。
            workbook->dynamicCall("Close()");//关闭工作簿
        }
        OleUninitialize();
        dumpDataOver ();
    });//end thread
}
//设置备份路径
void MysqlServer::setDumpPath (QString path){
    this->mdumpPath=path;
    this->msettings.setValue ("dumpPath",path);
}

bool MysqlServer::login(QString userName, QString pwd, QString access)
{
    //创建
    QSqlDatabase db=QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("192.168.0.167");
    db.setDatabaseName("schema");
    db.setUserName("root");
    db.setPassword("sky");
    m_access = access.toInt();
    m_currentUser = userName;
    currentUserAccessChanged();
    currentUserChanged();
    //链接数据库
    if(db.open()){
        qDebug()<<"database is established!";
    }
    else{
        qDebug()<<"faled to connect to database";
        qDebug() << db.lastError().text();
        return false;
    }
    qDebug()<<"kk4";
    //获取数据
    QSqlQuery query;
    QString str = "SELECT * FROM schema.users where user_name='" + userName +
            "' and user_pwd='" + pwd +
            "' and user_access='" + access + "'";
    query.exec(str);
    if(query.next()){
        openManagerWindow();
        return true;
    }
    return false;
}

void MysqlServer::logOut()
{
    openLoginWindow();
}

QJsonArray MysqlServer::usersList()
{
    //创建
    QSqlDatabase db=QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("192.168.0.167");
    db.setDatabaseName("schema");
    db.setUserName("root");
    db.setPassword("sky");

    //链接数据库
    if(db.open()){
        qDebug()<<"database is established!";
    }
    else{
        qDebug()<<"faled to connect to database";
    }

    //获取数据
    QSqlQuery query;
    QString str = "SELECT user_name,user_pwd,user_access,id FROM schema.users";
    QJsonArray users;
    query.exec(str);
    while(query.next()){
        QJsonObject user;
        user.insert("userName",query.value("user_name").toString());
        user.insert("userPwd",query.value("user_pwd").toString());
        user.insert("userAccess",query.value("user_access").toString());
        user.insert("userId",query.value("id").toInt());
        users.append(user);
    }
    return users;
}

bool MysqlServer::addUser(const QString &userName, const QString &pwd, const QString &access)
{

    if(m_access == 0)
        return false;

    //创建
    QSqlDatabase db=QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("192.168.0.167");
    db.setDatabaseName("schema");
    db.setUserName("root");
    db.setPassword("sky");

    //链接数据库
    if(db.open()){
        qDebug()<<"database is established!";
    }
    else{
        qDebug()<<"faled to connect to database";
    }
    QSqlQuery query;
    QString checkStr = "SELECT * from `schema`.`users` where user_name='"+userName+"'";
    query.exec(checkStr);
    if(query.next())
        return false;
    query.clear();
    QString str = "INSERT INTO `schema`.`users` (`user_name`,`user_pwd`,`user_access`) VALUES ('"+userName+"','"+pwd+"','"+access+"')";
    qDebug()<<"insert user"<<query.exec(str);

    db.close();
    return true;
}

bool MysqlServer::removeUser(const QString &userName)
{
    if(m_access == 0)
        return false;

    //创建
    QSqlDatabase db=QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("192.168.0.167");
    db.setDatabaseName("schema");
    db.setUserName("root");
    db.setPassword("sky");

    //链接数据库
    if(db.open()){
        qDebug()<<"database is established!";
    }
    else{
        qDebug()<<"faled to connect to database";
    }
    QSqlQuery query;

    QString str = "DELETE FROM `schema`.`users` WHERE `user_name`='"+userName+"'";
    qDebug()<<"delete user:"<<query.exec(str);
    return true;
}

bool MysqlServer::updateUser(const QString &userName, const QString &pwd, const QString &access, const QString& userId)
{
    //    UPDATE `schema1`.`users` SET `user_access`='1' WHERE `id`='2';

    if(m_access == 0)
        return false;

    //创建
    QSqlDatabase db=QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("192.168.0.167");
    db.setDatabaseName("schema");
    db.setUserName("root");
    db.setPassword("sky");

    //链接数据库
    if(db.open()){
        qDebug()<<"database is established!";
    }
    else{
        qDebug()<<"faled to connect to database";
    }
    QSqlQuery query;
    QString str = "UPDATE `schema`.`users` SET `user_name`='"+userName+
            "',`user_pwd`='"+pwd+
            "',`user_access`='"+access+"' WHERE `id`='"+userId+"'";
    qDebug()<<query.exec(str);
    return true;

}

bool MysqlServer::pushPressureData(const int& fn, const QJsonArray &data, const QDateTime &date)
{
    //创建
    QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("192.168.0.167");
    db.setDatabaseName("schema");
    db.setUserName("root");
    db.setPassword("sky");

    //链接数据库
    if(db.open()){
        qDebug()<<"database is established!";
    }
    else{
        qDebug()<<"faled to connect to database";
    }
    QSqlQuery query;
    query.exec("SELECT time from `sheme1`.`pressures` where time='"+date.toString("yyyy-MM-dd hh:mm:ss")+
               "' and FN='"+QString::number(fn)+"'");
    if(query.next())
        return false;
    query.clear();

    int tn = 0;
    for(auto it: data){
        QString value = it.toString();
        QString dateStr = date.toString("yyyy-MM-dd hh:mm:ss");
        QString str = "INSERT INTO `schema`.pressures (`FN`,`TN`,`value`,`time`) VALUE('"+QString::number(fn)+
                "','"+QString::number(tn)+
                "','"+value+
                "','"+dateStr+"')";
        query.exec(str);
        query.clear();
        tn++;
    }
    db.close();
    return true;
}

QString MysqlServer::getSaveFilePath()
{
    QString filePath = QDir::home().path();
    QString fileName = "保存图片.png";
    return QFileDialog::getSaveFileName(0,tr("导出图片"),filePath+"/"+fileName,tr("*.png"));
}
// 销毁自身
void MysqlServer::onDumpDataOver (){
    this->deleteLater();

}
