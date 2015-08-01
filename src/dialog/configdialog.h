#ifndef _CONFIG_DIALOG_H
#define _CONFIG_DIALOG_H


namespace Ui {
    class ConfigDialog;
}

class ConfigDialog : public QDialog
{
    Q_OBJECT
public:
    ConfigDialog(QWidget *parent = 0);
    static const int S_CORNER_SIZE = 5;
    ~ConfigDialog();

private:
    Ui::ConfigDialog *ui;
    void showFont(QLineEdit *lineedit, const QFont &font);

    QPoint windowPos;
    QPoint mousePos;
    QPoint dPos;

    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
    void roundCorners();

private slots:
    void on_setTextEditColorButton_clicked();
    void on_setTextEditFontButton_clicked();
    void on_changeAppFontButton_clicked();
    void on_resetBgMusicButton_clicked();
    void on_browseBgMusicButton_clicked();
    void on_resetBgButton_clicked();
    void on_browseBgButton_clicked();
    void saveConfig();

signals:
    void bg_changed();
};

#endif

