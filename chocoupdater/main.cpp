#include "chocoupdater.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    chocoupdater w;
    w.showMinimized();

    return a.exec();
}
