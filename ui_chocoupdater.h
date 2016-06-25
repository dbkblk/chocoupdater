/********************************************************************************
** Form generated from reading UI file 'chocoupdater.ui'
**
** Created by: Qt User Interface Compiler version 5.7.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_CHOCOUPDATER_H
#define UI_CHOCOUPDATER_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QTreeWidget>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_chocoupdater
{
public:
    QWidget *centralWidget;
    QTreeWidget *treeWidget;
    QPushButton *pushButton;
    QPushButton *Configuration;
    QLabel *label;
    QLabel *label_2;
    QMenuBar *menuBar;

    void setupUi(QMainWindow *chocoupdater)
    {
        if (chocoupdater->objectName().isEmpty())
            chocoupdater->setObjectName(QStringLiteral("chocoupdater"));
        chocoupdater->resize(500, 500);
        QSizePolicy sizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(chocoupdater->sizePolicy().hasHeightForWidth());
        chocoupdater->setSizePolicy(sizePolicy);
        chocoupdater->setMinimumSize(QSize(500, 500));
        chocoupdater->setMaximumSize(QSize(500, 500));
        chocoupdater->setUnifiedTitleAndToolBarOnMac(false);
        centralWidget = new QWidget(chocoupdater);
        centralWidget->setObjectName(QStringLiteral("centralWidget"));
        treeWidget = new QTreeWidget(centralWidget);
        QTreeWidgetItem *__qtreewidgetitem = new QTreeWidgetItem();
        __qtreewidgetitem->setText(0, QStringLiteral("1"));
        treeWidget->setHeaderItem(__qtreewidgetitem);
        treeWidget->setObjectName(QStringLiteral("treeWidget"));
        treeWidget->setGeometry(QRect(10, 80, 480, 360));
        treeWidget->setItemsExpandable(false);
        treeWidget->setWordWrap(true);
        pushButton = new QPushButton(centralWidget);
        pushButton->setObjectName(QStringLiteral("pushButton"));
        pushButton->setGeometry(QRect(330, 450, 160, 30));
        pushButton->setMinimumSize(QSize(0, 30));
        Configuration = new QPushButton(centralWidget);
        Configuration->setObjectName(QStringLiteral("Configuration"));
        Configuration->setEnabled(false);
        Configuration->setGeometry(QRect(160, 450, 160, 30));
        Configuration->setMinimumSize(QSize(160, 30));
        Configuration->setMaximumSize(QSize(160, 30));
        label = new QLabel(centralWidget);
        label->setObjectName(QStringLiteral("label"));
        label->setGeometry(QRect(80, 10, 405, 60));
        label->setMinimumSize(QSize(405, 60));
        label->setMaximumSize(QSize(405, 60));
        label->setAlignment(Qt::AlignLeading|Qt::AlignLeft|Qt::AlignTop);
        label->setWordWrap(true);
        label->setMargin(5);
        label_2 = new QLabel(centralWidget);
        label_2->setObjectName(QStringLiteral("label_2"));
        label_2->setGeometry(QRect(15, 10, 60, 60));
        chocoupdater->setCentralWidget(centralWidget);
        menuBar = new QMenuBar(chocoupdater);
        menuBar->setObjectName(QStringLiteral("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 500, 21));
        chocoupdater->setMenuBar(menuBar);

        retranslateUi(chocoupdater);

        QMetaObject::connectSlotsByName(chocoupdater);
    } // setupUi

    void retranslateUi(QMainWindow *chocoupdater)
    {
        chocoupdater->setWindowTitle(QApplication::translate("chocoupdater", "Update(s) available!", 0));
        pushButton->setText(QApplication::translate("chocoupdater", "Install now", 0));
        Configuration->setText(QApplication::translate("chocoupdater", "Configuration", 0));
        label->setText(QApplication::translate("chocoupdater", "<html><head/><body><p><span style=\" font-size:11pt; font-weight:600;\">Updates are available for this computer.</span></p><p><span style=\" font-size:11pt; font-weight:600;\">Would you like to update?</span></p></body></html>", 0));
        label_2->setText(QApplication::translate("chocoupdater", "<html><head/><body><p><img  height=\"60\" width=\"60\" src=\":/icon.ico\"/></p></body></html>", 0));
    } // retranslateUi

};

namespace Ui {
    class chocoupdater: public Ui_chocoupdater {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_CHOCOUPDATER_H
