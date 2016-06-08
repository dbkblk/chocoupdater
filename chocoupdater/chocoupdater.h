#ifndef CHOCOUPDATER_H
#define CHOCOUPDATER_H

#include <QMainWindow>
#include <QtCore>
#include <QtWidgets>
#include "w_install.h"

namespace Ui {
class chocoupdater;
}

class chocoupdater : public QMainWindow
{
    Q_OBJECT

public:
    explicit chocoupdater(QWidget *parent = 0);
    ~chocoupdater();
    QStringList getCheckedList();

public slots:

private slots:
    void on_pushButton_clicked();

private:
    Ui::chocoupdater *ui;
    QTreeWidgetItem *topLevelItem;
    QProcess* process;
    w_install *install;
};

#endif // CHOCOUPDATER_H
