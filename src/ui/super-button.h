#ifndef _BUTTON_H
#define _BUTTON_H

//#include "settings.h"


class SuperButton : public QGraphicsObject
{
    Q_OBJECT

public:
    explicit SuperButton(const QString &label, qreal scale = 1.0);
    explicit SuperButton(const QString &label, const QSizeF &size);
    explicit SuperButton(const QString &label, const QSizeF &size, const QString file_name, Qt::AlignmentFlag flag = Qt::AlignRight);
    ~SuperButton();
    void setMute(bool mute);
    void setFont(const QFont &font);

    virtual QRectF boundingRect() const;

protected:
    virtual void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget);
    virtual void hoverEnterEvent(QGraphicsSceneHoverEvent *event);
    virtual void hoverLeaveEvent(QGraphicsSceneHoverEvent *event);
    virtual void mousePressEvent(QGraphicsSceneMouseEvent *event);
    virtual void mouseReleaseEvent(QGraphicsSceneMouseEvent *event);

    virtual void timerEvent(QTimerEvent *);

private:
    QString label;
    QSizeF size;
    bool mute;
    QFont font;
    QImage outimg;
    QPixmap title;
    QGraphicsPixmapItem *title_item;
    int glow;
    int timer_id;
    QString f_name;

    QGraphicsDropShadowEffect *de;
    QGraphicsDropShadowEffect *effect;

    void init(QString file_name = "", Qt::AlignmentFlag flag = Qt::AlignRight);

signals:
    void clicked();
};

#endif

