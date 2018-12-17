#include "ethylenesetting.h"
#include <QDebug>

//QSettings：生成一个配置文件
EthyleneSetting::EthyleneSetting(QObject *parent) : QObject(parent)
{
    rootIni=new QSettings("./Ethylene",QSettings::IniFormat);
}

EthyleneSetting::~EthyleneSetting()
{
    delete rootIni;
}

void EthyleneSetting::setValue(const QString &key, const QVariant &value)
{
    rootIni->setValue (key,value);
    //将配置文件的更改写入存储
    rootIni->sync ();
}

QVariant EthyleneSetting::getValue(const QString &key, const QVariant &defaultValue)
{
    //将配置文件的更改写入存储
    rootIni->sync ();
    qDebug()<<"K:  "<<key<<"D:  "<<defaultValue;
    return rootIni->value (key,defaultValue);
}
