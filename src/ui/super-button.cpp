#include "super-button.h"
#include "audio.h"
#include "engine.h"
#include "settings.h"

static QRectF ButtonRect(0, 0, 190, 50);

SuperButton::SuperButton(const QString &label, qreal scale)
    : label(label), size(ButtonRect.size() * scale), mute(true), font(Config.SmallFont)
{
    title = QPixmap(size.toSize());
    outimg = QImage(size.toSize(), QImage::Format_ARGB32);
    init();
}

SuperButton::SuperButton(const QString &label, const QSizeF &size)
    : label(label), size(size), mute(true), font(Config.SmallFont)
{
    title = QPixmap(size.toSize());
    outimg = QImage(size.toSize(), QImage::Format_ARGB32);
    init();
}

SuperButton::SuperButton(const QString &label, const QSizeF &size, const QString file_name, Qt::AlignmentFlag flag)
    : label(label), size(size), mute(true), font(Config.SmallFont)
{
    title = QPixmap(size.toSize());
    outimg = QImage(size.toSize(), QImage::Format_ARGB32);
    init(file_name, flag);
}

void SuperButton::init(QString file_name, Qt::AlignmentFlag flag)
{
    setFlags(ItemIsFocusable);
    f_name = file_name;

    setAcceptHoverEvents(true);
    setAcceptedMouseButtons(Qt::LeftButton);

    title.fill(QColor(0, 0, 0, 0));
    QPainter pt(&title);
    pt.setFont(font);
    pt.setPen(Config.TextEditColor);
    pt.setRenderHint(QPainter::TextAntialiasing);
    if (flag != Qt::AlignCenter)
        pt.drawText(boundingRect(), flag, label);
    else
        pt.drawText(boundingRect(), Qt::AlignCenter, label);

    title_item = new QGraphicsPixmapItem(this);
    title_item->setPixmap(title);
    title_item->hide();

    de = new QGraphicsDropShadowEffect;
    de->setOffset(0);
    de->setBlurRadius(12);
    de->setColor(QColor(255, 165, 0));

    title_item->setGraphicsEffect(de);

    QImage bgimg;
    if (f_name == "")
    {
        bgimg = QImage("image/system/button/button.png");
    }
    else
    {
        f_name.remove(0, 6);
        if (QFile::exists("image/system/button/" + f_name + ".png"))
            bgimg = QImage("image/system/button/" + f_name + ".png");
        else
            bgimg = QImage("image/system/button/button.png");
    }
    

    qreal pad = 10;

    int w = bgimg.width();
    int h = bgimg.height();

    int tw = outimg.width();
    int th = outimg.height();

    qreal xc = (w - 2 * pad) / (tw - 2 * pad);
    qreal yc = (h - 2 * pad) / (th - 2 * pad);

    for (int i = 0; i < tw; i++) {
        for (int j = 0; j < th; j++) {
            int x = i;
            int y = j;

            if (x >= pad && x <= (tw - pad))
                x = pad + (x - pad) * xc;
            else if (x >= (tw - pad))
                x = w - (tw - x);

            if (y >= pad && y <= (th - pad))
                y = pad + (y - pad) * yc;
            else if (y >= (th - pad))
                y = h - (th - y);


            QRgb rgb = bgimg.pixel(x, y);
            outimg.setPixel(i, j, rgb);
        }
    }

    effect = new QGraphicsDropShadowEffect;
    effect->setBlurRadius(5);
    effect->setOffset(this->boundingRect().height() / 7.0);
    effect->setColor(QColor(0, 0, 0, 200));
    this->setGraphicsEffect(effect);

    glow = 0;
    timer_id = 0;
}

SuperButton::~SuperButton()
{
    de->deleteLater();
    effect->deleteLater();
}

void SuperButton::setMute(bool mute)
{
    this->mute = mute;
}

void SuperButton::setFont(const QFont &font)
{
    this->font = font;
    title.fill(QColor(0, 0, 0, 0));
    QPainter pt(&title);
    pt.setFont(font);
    pt.setPen(Config.TextEditColor);
    pt.setRenderHint(QPainter::TextAntialiasing);
    pt.drawText(boundingRect(), Qt::AlignCenter, label);

    title_item->setPixmap(title);
}

void SuperButton::hoverEnterEvent(QGraphicsSceneHoverEvent *)
{
    //setFocus(Qt::MouseFocusReason);
    title_item->show();

    QImage bgimg;
    if (f_name == "")
    {
        bgimg = QImage("image/system/button/button.png");
    }
    else
    {
        if (QFile::exists("image/system/button/" + f_name + "1.png"))
            bgimg = QImage("image/system/button/" + f_name + "1.png");
        else
            bgimg = QImage("image/system/button/button.png");
    }


    qreal pad = 10;

    int w = bgimg.width();
    int h = bgimg.height();

    int tw = outimg.width();
    int th = outimg.height();

    qreal xc = (w - 2 * pad) / (tw - 2 * pad);
    qreal yc = (h - 2 * pad) / (th - 2 * pad);

    for (int i = 0; i < tw; i++) {
        for (int j = 0; j < th; j++) {
            int x = i;
            int y = j;

            if (x >= pad && x <= (tw - pad))
                x = pad + (x - pad) * xc;
            else if (x >= (tw - pad))
                x = w - (tw - x);

            if (y >= pad && y <= (th - pad))
                y = pad + (y - pad) * yc;
            else if (y >= (th - pad))
                y = h - (th - y);


            QRgb rgb = bgimg.pixel(x, y);
            outimg.setPixel(i, j, rgb);
        }
    }

    if (!mute) Sanguosha->playSystemAudioEffect("button-hover", false);
    if (!timer_id) timer_id = QObject::startTimer(40);
}

void SuperButton::hoverLeaveEvent(QGraphicsSceneHoverEvent *)
{
    title_item->hide();

    QImage bgimg;
    if (f_name == "")
    {
        bgimg = QImage("image/system/button/button.png");
    }
    else
    {
        if (QFile::exists("image/system/button/" + f_name + ".png"))
            bgimg = QImage("image/system/button/" + f_name + ".png");
        else
            bgimg = QImage("image/system/button/button.png");
    }


    qreal pad = 10;

    int w = bgimg.width();
    int h = bgimg.height();

    int tw = outimg.width();
    int th = outimg.height();

    qreal xc = (w - 2 * pad) / (tw - 2 * pad);
    qreal yc = (h - 2 * pad) / (th - 2 * pad);

    for (int i = 0; i < tw; i++) {
        for (int j = 0; j < th; j++) {
            int x = i;
            int y = j;

            if (x >= pad && x <= (tw - pad))
                x = pad + (x - pad) * xc;
            else if (x >= (tw - pad))
                x = w - (tw - x);

            if (y >= pad && y <= (th - pad))
                y = pad + (y - pad) * yc;
            else if (y >= (th - pad))
                y = h - (th - y);


            QRgb rgb = bgimg.pixel(x, y);
            outimg.setPixel(i, j, rgb);
        }
    }
}

void SuperButton::mousePressEvent(QGraphicsSceneMouseEvent *event)
{
    QImage bgimg;
    if (f_name == "")
    {
        bgimg = QImage("image/system/button/button.png");
    }
    else
    {
        if (QFile::exists("image/system/button/" + f_name + "2.png"))
            bgimg = QImage("image/system/button/" + f_name + "2.png");
        else
            bgimg = QImage("image/system/button/button.png");
    }


    qreal pad = 10;

    int w = bgimg.width();
    int h = bgimg.height();

    int tw = outimg.width();
    int th = outimg.height();

    qreal xc = (w - 2 * pad) / (tw - 2 * pad);
    qreal yc = (h - 2 * pad) / (th - 2 * pad);

    for (int i = 0; i < tw; i++) {
        for (int j = 0; j < th; j++) {
            int x = i;
            int y = j;

            if (x >= pad && x <= (tw - pad))
                x = pad + (x - pad) * xc;
            else if (x >= (tw - pad))
                x = w - (tw - x);

            if (y >= pad && y <= (th - pad))
                y = pad + (y - pad) * yc;
            else if (y >= (th - pad))
                y = h - (th - y);


            QRgb rgb = bgimg.pixel(x, y);
            outimg.setPixel(i, j, rgb);
        }
    }
    event->accept();
}

void SuperButton::mouseReleaseEvent(QGraphicsSceneMouseEvent *)
{
    QImage bgimg;
    if (f_name == "")
    {
        bgimg = QImage("image/system/button/button.png");
    }
    else
    {
        if (QFile::exists("image/system/button/" + f_name + ".png"))
            bgimg = QImage("image/system/button/" + f_name + ".png");
        else
            bgimg = QImage("image/system/button/button.png");
    }


    qreal pad = 10;

    int w = bgimg.width();
    int h = bgimg.height();

    int tw = outimg.width();
    int th = outimg.height();

    qreal xc = (w - 2 * pad) / (tw - 2 * pad);
    qreal yc = (h - 2 * pad) / (th - 2 * pad);

    for (int i = 0; i < tw; i++) {
        for (int j = 0; j < th; j++) {
            int x = i;
            int y = j;

            if (x >= pad && x <= (tw - pad))
                x = pad + (x - pad) * xc;
            else if (x >= (tw - pad))
                x = w - (tw - x);

            if (y >= pad && y <= (th - pad))
                y = pad + (y - pad) * yc;
            else if (y >= (th - pad))
                y = h - (th - y);


            QRgb rgb = bgimg.pixel(x, y);
            outimg.setPixel(i, j, rgb);
        }
    }
    if (!mute) Sanguosha->playSystemAudioEffect("button-down", false);
    emit clicked();
}

QRectF SuperButton::boundingRect() const
{
    return QRectF(QPointF(), size);
}

void SuperButton::paint(QPainter *painter, const QStyleOptionGraphicsItem *, QWidget *)
{
    QRectF rect = boundingRect();

    painter->drawImage(rect, outimg);
    painter->fillRect(rect, QColor(255, 255, 255, glow * 10));
}

void SuperButton::timerEvent(QTimerEvent *)
{
    update();
    if (hasFocus()) {
        if (glow < 5) glow++;
    } else {
        if (glow > 0)
            glow--;
        else if (timer_id) {
            QObject::killTimer(timer_id);
            timer_id = 0;
        }
    }
}

