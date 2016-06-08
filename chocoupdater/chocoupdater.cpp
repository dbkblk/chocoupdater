#include "chocoupdater.h"
#include "ui_chocoupdater.h"
#include "QtCore"

chocoupdater::chocoupdater(QStringList installed, QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::chocoupdater)
{
    ui->setupUi(this);

    ui->treeWidget->setColumnCount(4);
    ui->treeWidget->setHeaderLabels(QStringList() << "" << "Program" << "Version" << "Update");

    // Vérification des màj : cup -y all --noop -r

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
    install = new w_install(getCheckedList());
    install->show();    
}
