#include <QApplication>
#include "global.h"
#include "./setting/ethylenesetting.h"
#include "autosavedata.h"
#include <QFontDatabase>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    int fontid = QFontDatabase::addApplicationFont(QCoreApplication::applicationDirPath()+"/SourceCodePro-Regular.ttf");
    QString mshy = QFontDatabase::applicationFontFamilies(fontid).at(0);
    QFont font(mshy);
    QApplication::setFont(font);

//    QDate a(2016,4,30);
//    QDate b(2016,8,20);
//    qDebug()<<"月份差测试:"<<AutoSaveData::monthTo (a,b);
    AutoSaveData asd;

//    MysqlServer server;

//    qmlRegisterType<SerialPortManager>("SerialPortManager",1,0,"SerialPortManager");
//    server.rootContext()->setContextProperty("server", &server);

//    server.load(QUrl(QStringLiteral("qrc:/login.qml")));

//    app.setFont();

    openLoginWindow();

    return app.exec();
}
