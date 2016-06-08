#-------------------------------------------------
#
# Project created by QtCreator 2016-06-03T20:35:58
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = chocoupd
TEMPLATE = app


SOURCES += main.cpp\
        chocoupdater.cpp \
    w_install.cpp

HEADERS  += chocoupdater.h \
    w_install.h

FORMS    += chocoupdater.ui \
    w_install.ui

DISTFILES += \
    README.md
