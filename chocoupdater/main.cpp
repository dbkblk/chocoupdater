#include "chocoupdater.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    QProcess choco;
    choco.start("cup -y all --noop -r");
    choco.waitForFinished(-1);
    QStringList installed = QString(choco.readAll()).split(QRegExp("[\r\n]+"));
    installed.removeAll("");
    installed.removeFirst();
    installed.removeFirst();

    int nNew = 0;
    foreach (QString line, installed)
    {
        // Parse string
        QStringList versions = line.split("|");

        // List only updateable programs
        if (versions[1] != versions[2])
        {
           nNew++;
        }
    }

    chocoupdater w(installed);
    if(nNew > 0){
        w.showMinimized();
    }
    else {
        qDebug() << "No updates found";
        QApplication::exit();
    }

    return a.exec();
}
