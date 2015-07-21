#ifndef _START_SCENE_H
#define _START_SCENE_H

//#include "button.h"
//#include "qsan-selectable-item.h"
//#include "server.h"

class SuperButton;
class QSanSelectableItem;
class Server;

class StartScene : public QGraphicsScene
{
    Q_OBJECT

public:
    StartScene();
    ~StartScene();
    void addButton(QAction *action);
    void setServerLogBackground();
    void switchToServer(Server *server);
    void addBGM(QString path);
private:
    void printServerInfo();

    //QSanSelectableItem *logo;
    QTextEdit *server_log;
    QList<SuperButton *> buttons;
};

#endif

