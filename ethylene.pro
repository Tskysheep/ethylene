TEMPLATE = app

QT += qml quick widgets sql serialport axcontainer concurrent core

CONFIG += c++11

SOURCES += main.cpp \
    sql/mysqlserver.cpp \
    serial/serialportmanager.cpp \
    global.cpp \
    setting/ethylenesetting.cpp \
    autosavedata.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    sql/mysqlserver.h \
    serial/serialportmanager.h \
    global.h \
    setting/ethylenesetting.h \
    autosavedata.h
