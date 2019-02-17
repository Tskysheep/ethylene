#ifndef UTILS_H
#define UTILS_H

//#include <mclmcr.h>
//#include <matrix.h>
//#include <mclcppclass.h>
//#include"cube_coking_diagnose.h"

#include <QDebug>
#include <QObject>
#include <QString>
#include <QIODevice>
#include <QFile>
#include <QTextStream>
#include <QCursor>
#include <QMouseEvent>
#include<QProcess>

class Utils : public QObject
{
    Q_OBJECT
public:
    explicit Utils(QObject *parent = 0);
    Q_INVOKABLE static QString readMoreInfo();
    Q_INVOKABLE void saveMoreInfo(QString json);
    Q_INVOKABLE QPoint getPos();
    Q_INVOKABLE void test(QList<double> tmtouts,QList<double> aprs);

signals:
    void finish();


public slots:
    void readResult();
    QStringList getResult();

private:
    QProcess *pro = new QProcess(this);
    QStringList resultList;
};

#endif // UTILS_H
