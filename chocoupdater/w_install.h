#ifndef W_INSTALL_H
#define W_INSTALL_H

#include <QWidget>
#include <QTime>

namespace Ui {
class w_install;
}

class w_install : public QWidget
{
    Q_OBJECT

public:
    explicit w_install(QStringList list, QWidget *parent = 0);
    ~w_install();
    QStringList pkglist_to_install;

public slots:
    void updateInterface();

private:
    Ui::w_install *ui;
    int pkg_to_install;
    int pkg_installing;
    QDateTime start_time;
};

#endif // W_INSTALL_H
