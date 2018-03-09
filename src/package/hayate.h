#ifndef _HAYATE_H
#define _HAYATE_H

#include "package.h"
#include "card.h"
#include "standard.h"
#include "wind.h"

class HayatePackage : public Package
{
    Q_OBJECT

public:
    HayatePackage();
};

class TiaojiaoCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE TiaojiaoCard();

    bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

class HaremuCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE HaremuCard();

    bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

class YoushuiCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE YoushuiCard();

    bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

class MojuCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE MojuCard();

    bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

#endif