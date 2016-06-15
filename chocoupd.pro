TQT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = chocoupd
TEMPLATE = app


SOURCES += src/main.cpp\
        src/chocoupdater.cpp \
    src/w_install.cpp

HEADERS  += src/chocoupdater.h \
    src/w_install.h

FORMS    += src/chocoupdater.ui \
    src/w_install.ui

RC_FILE = icon.rc

DISTFILES += \
    README.md

TRANSLATIONS = translations/chocoupd.ts

RESOURCES     = resources.qrc
