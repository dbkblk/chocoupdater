#ifndef CHOCOUPDINST_H
#define CHOCOUPDINST_H

#include <QMainWindow>

namespace Ui {
class chocoupdinst;
}

class chocoupdinst : public QMainWindow
{
    Q_OBJECT

public:
    explicit chocoupdinst(QWidget *parent = 0);
    ~chocoupdinst();

private:
    Ui::chocoupdinst *ui;
};

#endif // CHOCOUPDINST_H
