#include "utils.h"

Utils::Utils(QObject *parent) : QObject(parent)
{
    connect(pro,&QProcess::readyRead,this,&Utils::readResult);

}

//读取更多设置文件
QString Utils::readMoreInfo()
{
    QFile file("moreinfo.txt");
    if(!file.exists()){
        qDebug()<<"the file is not exits";
        return NULL;
    }else {
        if(!file.open(QIODevice::ReadOnly)){
            qDebug()<<file.errorString();
            return NULL;
        }else{
            QTextStream in(&file);
            QString json = in.readAll();
            file.close();
            //qDebug()<<json;
            return json;
        }
    }

}

//保存更多设置到文件
void Utils::saveMoreInfo(QString json)
{
    QFile file("moreinfo.txt");
    if(!file.open(QIODevice::WriteOnly)){
        qDebug()<<file.errorString();

    }else{
        QTextStream out(&file);
        out<<json;
        file.close();
    }

}

QPoint Utils::getPos()
{
    QPoint p = QCursor::pos();
    return p;

}

void Utils::test(QList<double> tmtouts,QList<double> aprs)
{

/*    //读取数据文件 ，这个路径要改
    QFile file("C:/Users/sky/Desktop/Total_result_A.csv");
    QList<double> listtmpout;
    QList<double> listapr;

    if(file.open(QIODevice::ReadOnly|QIODevice::Text)){
        QTextStream in(&file);
        for(int i = 0; i < 337; i++){
            QString line = in.readLine();
            if(i==0){
                qDebug()<<line.split(",",QString::SkipEmptyParts).at(0)<<
                          line.split(",",QString::SkipEmptyParts).at(2)<<
                          line.split(",",QString::SkipEmptyParts).at(3);
            }else{
                qDebug()<<line.split(",",QString::SkipEmptyParts).at(0).toInt()<<"      "<<
                          line.split(",",QString::SkipEmptyParts).at(2).toInt()<<"      "<<
                          line.split(",",QString::SkipEmptyParts).at(3).toDouble();
                listtmpout.append(line.split(",",QString::SkipEmptyParts).at(2).toDouble());
                listapr.append(line.split(",",QString::SkipEmptyParts).at(3).toDouble());
            }
        }
    }


    file.close();
*/
    QStringList l;


    for(int x = 0; x < tmtouts.size(); x++){


        //前一半插入TMT
        l.insert(x,QString::number(tmtouts.at(x)));
        //后一半插入apr
        l.insert(aprs.size()+x,QString::number(aprs.at(x)));

    }




    QString program = "C:\\Users\\sky\\Desktop\\op\\cube_coking_diagnose.exe";
    //QString result;

    pro->start(program,l);
    if(pro->waitForStarted(-1)){

        qDebug()<<"demo.exe 启动成功";
//        if(pro->waitForFinished()){
//            qDebug()<<"demo.exe 关闭";
//        }else{
//            qDebug()<<"demo.exe 在30秒内没有关闭";
//        }
/*        while(pro->waitForReadyRead(-1)){

           result =  QString(pro->readAllStandardOutput());
           qDebug()<<result;
           break;
        }
*/

    }else{
        qDebug()<<"exe 调用失败";
    }

//    return result;

    qDebug()<<"调用完成";

}

void Utils::readResult()
{
    QString result;
    result =  QString(pro->readAllStandardOutput());
    QStringList l = result.split(" ");
    l.removeOne("");
    resultList = l;
    qDebug()<<l.count();
//    for(int a = 0; a < l.count(); a++){
//        qDebug()<<a<<"  "<<l.at(a);
//    }
    qDebug()<<result;
    emit finish();
}

QStringList Utils::getResult()
{
    return resultList;
}
