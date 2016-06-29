#ifndef CHOCOUPDATER_H
#define CHOCOUPDATER_H

#include <QMainWindow>
#include <QSystemTrayIcon>
#include <QtWidgets>

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
    void createActions();
    void createTrayIcon();
    void prepareInterface(QStringList installed);

public slots:

private slots:
    void on_pushButton_clicked();

private:
    Ui::chocoupdater *ui;
    QTreeWidgetItem *topLevelItem;
//    QProcess* process;
    QSystemTrayIcon trayIcon;
    QAction *restoreAction;
    QAction *quitAction;
    QMenu *trayIconMenu;
    QTranslator *translator;
};

#endif // CHOCOUPDATER_H
