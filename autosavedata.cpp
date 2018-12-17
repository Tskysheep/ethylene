#include "autosavedata.h"
//初始化相关参数
AutoSaveData::AutoSaveData(QString df,QObject *parent) : QObject(parent),dateFormat(df)
{
//    {"H110","H111","H112","H113","H114","H115","H116","H117","H118","H119","H120"}
    stoveNumber[0]="H110";
    stoveNumber[1]="H111";
    stoveNumber[2]="H112";
    stoveNumber[3]="H113";
    stoveNumber[4]="H114";
    stoveNumber[5]="H115";
    stoveNumber[6]="H116";
    stoveNumber[7]="H117";
    stoveNumber[8]="H118";
    stoveNumber[9]="H119";
    stoveNumber[10]="H120";
    timer.setInterval (300000);
//    timer.setInterval(5000);
    timer.setSingleShot (false);
    timer.setTimerType (Qt::VeryCoarseTimer);
    connect (&timer,&QTimer::timeout,this,&AutoSaveData::check);
    timer.start ();
}

AutoSaveData::~AutoSaveData()
{

}

//特化使用，返回两个时间内的月份差
int AutoSaveData::monthTo(const QDate &firstDate, const QDate &secondDate, int defaultValue, bool *ok)
{
    if(firstDate.isValid ()&&secondDate.isValid ()) {
        int firstyear=firstDate.year ();
        int secondyear=secondDate.year ();
        int firstmooth=firstDate.month ();
        int secondmooth=secondDate.month ();
        int yearpoor=secondyear-firstyear;
        if(yearpoor>=0) {
            int yeartomooth=yearpoor*12;
            int moothpoor=secondmooth-1-firstmooth+yeartomooth;
            if(ok!=NULL) {
                *ok=true;
            }
            return moothpoor;
        }  else if(yearpoor<0){
            int yeartomooth=yearpoor*12;
            int moothpoor=secondmooth+1-firstmooth+yeartomooth;
            if(ok!=NULL) {
                *ok=true;
            }
            return moothpoor;
        }
    } else {
        if(ok!=NULL) {
            *ok=false;
        }
        return defaultValue;
    }
}
//特化，返回date的monthValue月前的日期
QDate AutoSaveData::upDateformonth(QDate date, int monthValue)
{
    int year=date.year();
    int month=date.month();
    int tmpV=month-monthValue;
    if(tmpV>0) {
        return QDate(year,tmpV,1);
    } else {
        year--;
        month=12+tmpV;
        return QDate(year,month,1);
    }
}


void AutoSaveData::check()
{

    bool *ok=new bool;
    int cycleValue=settingINI.getValue ("/YJS/cycle",1).toInt (ok);
    QString savePath=QString(settingINI.getValue("/YJS/savrPath","").toByteArray());

    if(savePath=="") {
        qDebug()<<"路径没有设置";
        return;
    }
//    saveData (savePath);
    if(!(*ok)) {
        qDebug()<<"备份周期获取转换失败";
        return;
    }
    QDate currentDate=QDate::currentDate ();
//    QDate currentDate(2015,3,1);//测试
    QString lastSaveDateStr=QString(settingINI.getValue ("/YJS/SaveDate","null").toByteArray ());
    if(lastSaveDateStr!="null") {
        QDate lastSaveDate=QDate::fromString (lastSaveDateStr,dateFormat);
        if(!lastSaveDate.isValid ()) {
            qDebug()<<"上次备份日期获取无效";
            return ;
        }

        int monthPoor=monthTo (lastSaveDate,currentDate,0,ok);
        if(!(*ok)) {
            qDebug()<<"日期有毒无法比较";
            return;
        }
        if(monthPoor>=cycleValue) {
//            备份去吧，备份规则是什么呢？？偷懒的妥妥1号规则
            QDate beginDate=upDateformonth(currentDate,cycleValue);
            QDate overDate=upDateformonth(currentDate,1);
            overDate.setDate(overDate.year(),overDate.month(),overDate.daysInMonth());
            saveData (savePath,beginDate,overDate);
        } else {
            qDebug()<<"时辰未到";
            return;
        }

    } else {
        qDebug()<<"备份第一次";
        QDate beginDate=upDateformonth(currentDate,cycleValue);
        QDate overDate=upDateformonth(currentDate,1);
        overDate.setDate(overDate.year(),overDate.month(),overDate.daysInMonth());
        saveData (savePath,beginDate,overDate);
    }
}
//存储数据为excel
void AutoSaveData::saveData(QString savePath, QDate beginD, QDate overD)
{
    savePath=savePath.remove(0,8);
    settingINI.setValue("/YJS/SaveDate",overD.toString(dateFormat));
    QString tmpstove;
    for(int i=0;i<11;i++) {
        QString tmpstove=stoveNumber[i];
        qDebug()<<"pathCreate:"<<savePath+"/"+tmpstove<<endl;
        QDir tmpdir(savePath+"/"+tmpstove);
        if(!tmpdir.exists()) {
            tmpdir.mkpath(savePath+"/"+tmpstove);
        }
    }

    QString timeStr=beginD.toString("yyyy-MM-dd")+"_"+overD.toString("yyyy-MM-dd")+".xlsx";
    QDateTime bDT(beginD,QTime(0,0,0,0));
    QDateTime oDT(overD,QTime(24,59,59));
    for(int i=0;i<11;i++) {
        MysqlServer * tmpSql=new MysqlServer();
        tmpSql->all_tube_show(i,bDT,oDT);
        tmpSql->exportExcel(savePath+"/"+stoveNumber[i]+"/"+timeStr);
        delete tmpSql;
    }


}



