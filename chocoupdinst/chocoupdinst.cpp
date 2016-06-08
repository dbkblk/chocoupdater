#include "chocoupdinst.h"
#include "ui_chocoupdinst.h"

chocoupdinst::chocoupdinst(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::chocoupdinst)
{
    ui->setupUi(this);
}

chocoupdinst::~chocoupdinst()
{
    delete ui;
}
