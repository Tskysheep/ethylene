#include "global.h"
#include <QQmlApplicationEngine>
#include <QtQml>
#include "./setting/ethylenesetting.h"
//打开登录界面
void openLoginWindow()
{
    EthyleneSetting *ESINI=new EthyleneSetting();
    QQmlApplicationEngine *engine = new QQmlApplicationEngine();
    engine->rootContext()->setContextProperty("ESINI",ESINI);
    engine->rootContext()->setContextProperty("server",MysqlServer::instance());
    engine->load(QUrl(QStringLiteral("qrc:/login.qml")));
}
//打开管理界面
void openManagerWindow()
{
    EthyleneSetting *ESINI=new EthyleneSetting();
    QQmlApplicationEngine *engine = new QQmlApplicationEngine();
    engine->rootContext()->setContextProperty("server",MysqlServer::instance());
    engine->rootContext()->setContextProperty("ESINI",ESINI);
    qmlRegisterType<SerialPortManager>("SerialPortManager",1,0,"SerialPortManager");
    engine->load(QUrl(QStringLiteral("qrc:/main.qml")));
}
