TEMPLATE = app

QT += qml quick gui widgets sql serialport axcontainer concurrent core

CONFIG += c++11

SOURCES += main.cpp \
    sql/mysqlserver.cpp \
    serial/serialportmanager.cpp \
    global.cpp \
    setting/ethylenesetting.cpp \
    autosavedata.cpp \
    utils.cpp \
    serial/globalserialportmanager.cpp


RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

#DEFINES += __MW_STDINT_H__

HEADERS += \
    sql/mysqlserver.h \
    serial/serialportmanager.h \
    global.h \
    setting/ethylenesetting.h \
    autosavedata.h \
    utils.h \
    cube_coking_diagnose.h \
    serial/globalserialportmanager.h

#INCLUDEPATH += "D:/matlab2015/extern/include"
#INCLUDEPATH += "D:/matlab2015/extern/include/win32"

#LIBS += -L "D:/matlab2015/extern/lib/win32/microsoft/libmx.lib"
#LIBS += -L "D:/matlab2015/extern/lib/win32/microsoft/mclmcr.lib"
#LIBS += -L "D:/matlab2015/extern/lib/win32/microsoft/mclmcrrt.lib"

#win32: LIBS += -L$$PWD/./ -lcube_coking_diagnose

#INCLUDEPATH += $$PWD/.
#DEPENDPATH += $$PWD/.
