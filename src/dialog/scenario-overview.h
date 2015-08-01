#ifndef _SCENARIO_OVERVIEW_H
#define _SCENARIO_OVERVIEW_H

class QListWidget;
class QTextEdit;

class ScenarioOverview : public QDialog
{
    Q_OBJECT

public:
    ScenarioOverview(QWidget *parent);
    static const int S_CORNER_SIZE = 5;

private:
    QListWidget *list;
    QTextEdit *content_box;

private slots:
    void loadContent(int row);
};

#endif

