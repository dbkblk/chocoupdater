#include "w_install.h"
#include "ui_w_install.h"
#include "chocoupdater.h"
#include <QTime>

w_install::w_install(QStringList list, QWidget *parent) :
    QWidget(parent),
    ui(new Ui::w_install)
{
    ui->setupUi(this);
    pkglist_to_install = list;
    //pkglist_to_install << "youtube-dl";
    start_time = QDateTime::currentDateTime();

    // Count number of programs to install
    pkg_to_install = pkglist_to_install.count();
    pkg_installing = 1;
    ui->progressBar->setValue(0);
    QString label = "Installing package " + QString::number(pkg_installing) + " of " + QString::number(pkg_to_install);
    ui->label->setText(label);

    QString command =  QString("-y %1 -f").arg(pkglist_to_install.join(" "));
    LPCWSTR str = (const wchar_t*) command.utf16();
    qDebug() << str;

    ShellExecute(0, L"runas", L"cup", str, 0, SW_HIDE);
    // parse C:\ProgramData\chocolatey\logs\chocolatey.log

    // Update interface every 2s
    QTimer *timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(updateInterface()));
    timer->start(2000); //time specified in ms
    nLine = 0;
}

w_install::~w_install()
{
    delete ui;
}

void w_install::updateInterface()
{
    // Open log file
    QFile file("C:\\ProgramData\\chocolatey\\logs\\chocolatey.log");
    if(!file.open(QIODevice::ReadOnly))
    {
     qDebug() << "Error opening log";
     return;
    }
    QTextStream in(&file);
    QDateTime dt_previous;
//    start_time = QDateTime::fromString("2016-06-04 14:23:47,791", "yyyy-MM-dd hh:mm:ss,zzz"); // Debug
    //qDebug() << "Start date is " << start_time.date();
    int n = 0;
    while(!in.atEnd()) {
        QString line = in.readLine();

        // Increment n each line, but only increment nLine when the line is read to avoid to reread the file each time
        if(n >= nLine) {
            QDateTime dt = QDateTime::fromString(line.left(23), "yyyy-MM-dd hh:mm:ss,zzz");
            qDebug() << line;

            if(start_time <= dt || start_time <= dt_previous)
            {
                if(line.contains("[INFO ]"))
                {
                    qDebug() << "'[INFO ]' found";
                    if (line.contains(" was successful."))
                    {
                        QString text = line.right(line.length() - 34);
                        text.replace(" The upgrade of ","");
                        text.replace(" was successful.", "");
                        foreach (QString value, pkglist_to_install)
                        {
                            if(value == text)
                            {
                                qDebug() << value << "found";
                                pkg_installing = pkg_installing + 1;
                                QString label = "Installing package " + QString::number(pkg_installing) + " of " + QString::number(pkg_to_install);
                                ui->label->setText(label);
                                ui->progressBar->setValue(int((pkg_installing-1)/pkg_to_install)*100);
                            }
                        }

                        qDebug() << dt.date() << text;
                    }
                }
                if(line.contains("Chocolatey upgraded"))
                {
                    QString text = line.split(".")[0].split(" ")[2];
                    QString pkg_success = text.split("/")[0];
                    QString pkg_total = text.split("/")[1];
                    ui->progressBar->setValue(100);

                    QMessageBox msgBox;
                    msgBox.setWindowTitle("");
                    msgBox.setText(tr("All the selected softwares have been updated:"));
                    msgBox.exec();
                    QApplication::exit();
                }
            }

            // Pass the date to the previous value to be able to check end sentences.
            if (dt.isValid())
            {
                dt_previous = dt;
            }
            nLine++;
        }

        n++;
    }
    qDebug() << "Parse passed";
}
