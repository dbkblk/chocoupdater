#include "chocoupdater.h"
#include "ui_chocoupdater.h"
#include "QtCore"

chocoupdater::chocoupdater(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::chocoupdater)
{
    /* Language routine : Get language parameter */
    QString loc = QLocale::system().name().section('_', 0, 0);
    translator = new QTranslator(this);
    translator->load(QString("chocoupd_" + loc + ".qm"),"lang/");
    qApp->installTranslator(translator);


    // Create system tray
    createActions();
    createTrayIcon();
    trayIcon.show();    

    // Draw ui elements
    ui->setupUi(this);

    ui->treeWidget->setColumnCount(4);
    ui->treeWidget->setHeaderLabels(QStringList() << "" << tr("Program") << tr("Version") << tr("Update"));

    // Vérification des màj : cup -y all --noop -r
}

chocoupdater::~chocoupdater()
{
    delete ui;
}

QStringList chocoupdater::getCheckedList(){
    QTreeWidgetItemIterator it(ui->treeWidget);
    QStringList list;
    // Get file list
    while (*it) {
            if((*it)->checkState(0) == Qt::Checked){
                list << (*it)->text(1);
            }
            ++it;
        }

    qDebug() << "Checked list requested : " << list;
    return list;
}

void chocoupdater::on_pushButton_clicked()
{
    QProcess prc;
    QString command = QString("inst_helper %1").arg(getCheckedList().join(" "));
    prc.startDetached(command);
    QApplication::exit();
}

void chocoupdater::createActions()
{
    restoreAction = new QAction(tr("&Open"), this);
    connect(restoreAction, SIGNAL(triggered()), this, SLOT(showNormal()));
    quitAction = new QAction(tr("&Quit"), this);
    connect(quitAction, SIGNAL(triggered()), qApp, SLOT(quit()));
}

void chocoupdater::createTrayIcon()
{
    trayIconMenu = new QMenu(this);
    trayIconMenu->addAction(restoreAction);
    trayIconMenu->addAction(configAction);
    trayIconMenu->addSeparator();
    trayIconMenu->addAction(quitAction);
    trayIcon.setIcon(QIcon(":/icon.ico"));
    trayIcon.setContextMenu(trayIconMenu);
    trayIcon.setToolTip(tr("Chocoupd is checking for updates..."));
}

void chocoupdater::prepareInterface(QStringList installed)
{
    // List programs with update
    ui->treeWidget->header()->resizeSection(0, 60);
    ui->treeWidget->header()->resizeSection(1, 250);
    ui->treeWidget->header()->resizeSection(1, 150);
    ui->treeWidget->header()->resizeSection(1, 150);
    foreach (QString line, installed)
    {
        // Parse string
        QStringList versions = line.split("|");
//        qDebug() << versions;

        // List only updateable programs
        if (versions[1] != versions[2])
        {
            // List programs with a checkbox
            topLevelItem = new QTreeWidgetItem;
            topLevelItem->setFlags(topLevelItem->flags() | Qt::ItemIsUserCheckable);
            topLevelItem->setCheckState(0,Qt::Checked);
            topLevelItem->setText(1,versions[0]);
            topLevelItem->setText(2,versions[1]);
            topLevelItem->setText(3,versions[2]);
            ui->treeWidget->addTopLevelItem(topLevelItem);
        }
    }
    trayIcon.showMessage(tr("Updates found"), QString(installed.count() + tr(" updates found")));
}
