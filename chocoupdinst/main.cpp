#include "chocoupdinst.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    chocoupdinst w;
    w.show();

    return a.exec();
}
