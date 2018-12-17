#ifndef ETHYLENESETTING_H
#define ETHYLENESETTING_H

#include <QObject>
#include <QSettings>
class EthyleneSetting : public QObject
{
    Q_OBJECT
public:
    //设定当前的存储文件
    explicit EthyleneSetting(QObject *parent = 0);
    ~EthyleneSetting();
    //设置相关键值对
    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    //根据键获取相关值, 并可设置默认返回值
    Q_INVOKABLE QVariant getValue(const QString &key, const QVariant &defaultValue = QVariant());

signals:

public slots:

private:
    QSettings *rootIni;
};

#endif // ETHYLENESETTING_H
