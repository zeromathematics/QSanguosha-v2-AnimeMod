#ifndef _DISTANCE_VIEW_DIALOG_H
#define _DISTANCE_VIEW_DIALOG_H

class ClientPlayer;

class DistanceViewDialogUI;

class DistanceViewDialog : public QDialog
{
    Q_OBJECT

public:
    DistanceViewDialog(QWidget *parent = 0);
    ~DistanceViewDialog();
    static const int S_CORNER_SIZE = 5;

private:
    DistanceViewDialogUI *ui;
    QPoint windowPos;
    QPoint mousePos;
    QPoint dPos;
    void roundCorners();

private slots:
    void showDistance();
};

#endif