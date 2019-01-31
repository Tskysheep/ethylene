#ifndef GLOBALSERIALPORTMANAGER_H
#define GLOBALSERIALPORTMANAGER_H

#include <QObject>

class GlobalSerialPortManager : public QObject
{
    Q_OBJECT
public:
    explicit GlobalSerialPortManager(QObject *parent = nullptr);

signals:

public slots:
};

#endif // GLOBALSERIALPORTMANAGER_H