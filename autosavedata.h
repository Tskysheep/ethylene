#ifndef AUTOSAVEDATA_H
#define AUTOSAVEDATA_H

#include <QObject>
#include "setting/ethylenesetting.h"
#include "sql/mysqlserver.h"
#include <QTimer>
#include <QDate>
#include <QDebug>
#include <QDir>

class AutoSaveData : public QObject
{
    Q_OBJECT
public:
    //初始化相关参数
    explicit AutoSaveData(QString df="dd.MM.yyyy",QObject *parent = 0);
    ~AutoSaveData();
    //返回两个时间内的月份差
    static int monthTo(const QDate &firstDate,const QDate &secondDate,int defaultValue=0,bool *ok=NULL);
    QString stoveNumber[11];
//    返回date的monthValue月前的日期
    static QDate upDateformonth(QDate date,int monthValue);

signals:

public slots:
    //检测是否需要备份, 需要时开启备份
    void check();
private:
    QTimer timer;
    const QString dateFormat ;
    EthyleneSetting settingINI;
//    存储数据为excel
    void saveData(QString savePath,QDate beginD,QDate overD);
};
//{"H110","H111","H112","H113","H114","H115","H116","H117","H118","H119","H120"}
//AutoSaveData::stoveNumber[11]={"H110","H111","H112","H113","H114","H115","H116","H117","H118","H119","H120"};


#endif // AUTOSAVEDATA_H
