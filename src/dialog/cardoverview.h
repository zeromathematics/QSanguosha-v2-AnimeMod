#ifndef _CARD_OVERVIEW_H
#define _CARD_OVERVIEW_H

class Card;

class MainWindow;
namespace Ui {
    class CardOverview;
}

class CardOverview : public QDialog
{
    Q_OBJECT

public:
    static CardOverview *getInstance(QWidget *main_window);
    static const int S_CORNER_SIZE = 5;

    CardOverview(QWidget *parent = 0);
    void loadFromAll();
    void loadFromList(const QList<const Card *> &list);

    ~CardOverview();

private:
    Ui::CardOverview *ui;
    QPoint windowPos;
    QPoint mousePos;
    QPoint dPos;

    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
    void roundCorners();

    void addCard(int i, const Card *card);

private slots:
    void on_femalePlayButton_clicked();
    void on_malePlayButton_clicked();
    void on_playAudioEffectButton_clicked();
    void on_tableWidget_itemDoubleClicked(QTableWidgetItem *item);
    void on_tableWidget_itemSelectionChanged();
    void askCard();
    void exitOverview();
};

#endif

