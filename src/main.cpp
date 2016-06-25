#include "chocoupdater.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    chocoupdater w;

    QProcess choco;
    choco.start("cup -y all --noop -r");
    choco.waitForFinished(-1);
    QStringList installed = QString(choco.readAll()).split(QRegExp("[\r\n]+"));
    installed.removeAll("");

    int nNew = 0;
    foreach (QString line, installed)
    {
        // Keep only updates messages for parsing
        if (!line.contains("|")){
            installed.removeAll(line);
        }
        else {
            // Parse string
            QStringList versions = line.split("|");

            // List only updateable programs
            if (versions[1] != versions[2])
            {
               nNew++;
            }
        }
    }

    if(nNew > 0){
        qDebug() << "Updates found";
        w.prepareInterface(installed);
        w.showMinimized();
    }
    else {
        qDebug() << "No updates found";
        QApplication::exit();
    }

    return a.exec();
}
