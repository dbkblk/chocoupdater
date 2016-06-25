QT       += core gui widgets

TARGET = chocoupd

TEMPLATE = app

SOURCES += src/main.cpp\
        src/chocoupdater.cpp

HEADERS  += src/chocoupdater.h

FORMS    += src/chocoupdater.ui

RC_FILE = icon.rc

DISTFILES += \
    README.md

TRANSLATIONS = translations/chocoupd.ts translations/chocoupd_fr.ts

RESOURCES     = resources.qrc

CONFIG(debug, debug|release) {
    DESTDIR = build/debug
} else {
    DESTDIR = build/
}

Release:OBJECTS_DIR = build/.obj
Release:MOC_DIR = build/.moc
Release:RCC_DIR = build/.rcc
Release:UI_DIR = build/.ui

Debug:OBJECTS_DIR = build/debug/.obj
Debug:MOC_DIR = build/debug/.moc
Debug:RCC_DIR = build/debug/.rcc
Debug:UI_DIR = build/debug/.ui
