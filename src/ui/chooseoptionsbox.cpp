#include "chooseoptionsbox.h"
#include "engine.h"
#include "button.h"
#include "client.h"
#include "clientstruct.h"
#include "timed-progressbar.h"
#include "skin-bank.h"

#include <QGraphicsProxyWidget>

ChooseOptionsBox::ChooseOptionsBox()
    : progressBar(NULL)
{
}
//====================
//||================||
//|| Please Choose: ||
//||    _______     ||
//||   |   1   |    ||
//||    -------     ||
//||    _______     ||
//||   |   2   |    ||
//||    -------     ||
//||    _______     ||
//||   |   3   |    ||
//||    -------     ||
//====================

QRectF ChooseOptionsBox::boundingRect() const
{
    const int width = getButtonWidth() + outerBlankWidth * 2;
    
    /*
    int max = 0;
    foreach(const QString &str, options)
        max = qMax(max, str.split("+").length());
    */
    int max = options.count();
    int height = topBlankWidth + max * defaultButtonHeight + (max - 1) * interval + bottomBlankWidth;

    if (ServerInfo.OperationTimeout != 0)
        height += 12;

    return QRectF(0, 0, width, height);
}

void ChooseOptionsBox::chooseOption(const QStringList &options)
{
#ifdef Q_OS_ANDROID
    minButtonWidth = G_DASHBOARD_LAYOUT.m_avatarArea.width() * 2;
    defaultButtonHeight = G_DASHBOARD_LAYOUT.m_normalHeight / 2;
#endif
    //repaint background
    this->options = options;

    QStringList titles = skillName.split("%");
    QString skillname = titles.at(0);
    QString titile_text;
    if (titles.length() > 1) {
        titile_text = translate("#" + skillname);
        foreach(const QString &element, titles) {
            if (element.startsWith("from:")) {
                QStringList froms = element.split(":");
                if (!froms.at(1).isEmpty()) {
                    QString from = ClientInstance->getPlayerName(froms.at(1));
                    titile_text.replace("%from", from);
                }
            }
            else if (element.startsWith("to:")) {
                QStringList tos = element.split(":");
                QStringList to_list;
                for (int i = 1; i < tos.length(); i++)
                    to_list << ClientInstance->getPlayerName(tos.at(i));
                QString to = to_list.join(", ");
                titile_text.replace("%to", to);
            }
            else if (element.startsWith("log:")) {
                QStringList logs = element.split(":");
                if (!logs.at(1).isEmpty()) {
                    QString log = logs.at(1);
                    titile_text.replace("%log", log);
                }
            }
        }
    }
    else
        titile_text = translate(skillName);

    title = QString("%1 %2").arg(Sanguosha->translate(titile_text)).arg(tr("Please choose:"));
    prepareGeometryChange();

    const int buttonWidth = getButtonWidth();
    QMap<Button *, int> pos;
    int y = 0;
    foreach(const QString &option, options) {
        ++y;
        QString text = translate(option);

        Button *button = new Button(text, QSizeF(buttonWidth,
            defaultButtonHeight));
        button->setFont(Button::defaultFont());
        button->setObjectName(option);
        buttons << button;
        button->setParentItem(this);
        pos[button] = y;

        QString original_tooltip = QString(":%1").arg(title);
        QString tooltip = Sanguosha->translate(original_tooltip);
        if (tooltip == original_tooltip) {
            original_tooltip = QString(":%1").arg(option);
            tooltip = Sanguosha->translate(original_tooltip);
        }
        connect(button, &Button::clicked, this, &ChooseOptionsBox::reply);
        if (tooltip != original_tooltip)
            button->setToolTip(QString("<font color=%1>%2</font>")
            .arg(Config.SkillDescriptionInToolTipColor.name())
            .arg(tooltip));

    }

    moveToCenter();
    show();

    for (int i = 0; i < buttons.length(); ++i) {
        Button *button = buttons.at(i);

        int y = pos[button];

        QPointF pos;
        pos.setX(outerBlankWidth);
        pos.setY(topBlankWidth + defaultButtonHeight *(y - 1) + (y - 2) * interval + defaultButtonHeight / 2);

        button->setPos(pos);
    }
    if (ServerInfo.OperationTimeout != 0) {
        if (!progressBar) {
            progressBar = new QSanCommandProgressBar();
            progressBar->setMaximumWidth(boundingRect().width() - 16);
            progressBar->setMaximumHeight(12);
            progressBar->setTimerEnabled(true);
            progressBarItem = new QGraphicsProxyWidget(this);
            progressBarItem->setWidget(progressBar);
            progressBar->setHidden(true);
            progressBarItem->setPos(boundingRect().center().x() - progressBarItem->boundingRect().width() / 2, boundingRect().height() - 20);
            connect(progressBar, &QSanCommandProgressBar::timedOut, this, &ChooseOptionsBox::reply);
        }
        progressBar->setCountdown(QSanProtocol::S_COMMAND_MULTIPLE_CHOICE);
        progressBar->show();
    }
}

void ChooseOptionsBox::reply()
{
    QString choice = sender()->objectName();
    if (choice.isEmpty())
        choice = options.first();
    ClientInstance->onPlayerMakeChoice(choice);
}

int ChooseOptionsBox::getButtonWidth() const
{
    if (options.isEmpty())
        return minButtonWidth;

    QFontMetrics fontMetrics(Button::defaultFont());
    int biggest = 0;
    foreach(const QString &option, options) {
        QString text = translate(option);

        const int width = fontMetrics.width(text);
        if (width > biggest)
            biggest = width;
    }

    QStringList titles = skillName.split("%");
    QString skillname = titles.at(0);
    QString titile_text;
    if (titles.length() > 1) {
        titile_text = translate("#" + skillname);
        foreach(const QString &element, titles) {
            if (element.startsWith("from:")) {
                QStringList froms = element.split(":");
                if (!froms.at(1).isEmpty()) {
                    QString from = ClientInstance->getPlayerName(froms.at(1));
                    titile_text.replace("%from", from);
                }
            }
            else if (element.startsWith("to:")) {
                QStringList tos = element.split(":");
                QStringList to_list;
                for (int i = 1; i < tos.length(); i++)
                    to_list << ClientInstance->getPlayerName(tos.at(i));
                QString to = to_list.join(", ");
                titile_text.replace("%to", to);
            }
            else if (element.startsWith("log:")) {
                QStringList logs = element.split(":");
                if (!logs.at(1).isEmpty()) {
                    QString log = logs.at(1);
                    titile_text.replace("%log", log);
                }
            }
        }
    }
    else
        titile_text = translate(skillName);

    const int w2 = fontMetrics.width(QString("%1 %2").arg(Sanguosha->translate(titile_text)).arg(tr("Please choose:")));
    if (w2 > biggest)
        biggest = w2;
    // Otherwise it would look compact
    biggest += 20;

    int width = minButtonWidth;
    return qMax(biggest, width);
}

QString ChooseOptionsBox::translate(const QString &option) const
{
    QString title = QString("%1:%2").arg(skillName.split("%").at(0)).arg(option);
    QString translated = Sanguosha->translate(title);
    if (translated == title)
        translated = Sanguosha->translate(option);
    return translated;
}

void ChooseOptionsBox::clear()
{
    
    if (progressBar != NULL) {
        progressBar->hide();
        progressBar->deleteLater();
        progressBar = NULL;
    }
    
    foreach(Button *button, buttons)
        button->deleteLater();

    buttons.clear();

    disappear();
}