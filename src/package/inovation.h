#ifndef _INOVATION_H
#define _INOVATION_H

#include "package.h"
#include "card.h"
#include "standard.h"

class InovationPackage : public Package
{
    Q_OBJECT

public:
    InovationPackage();
};

class TiaoxinCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE TiaoxinCard();

    bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    void onEffect(const CardEffectStruct &effect) const;
};


class MapoTofu : public BasicCard
{
    Q_OBJECT

public:
    Q_INVOKABLE MapoTofu(Card::Suit suit, int number);
    QString getSubtype() const;

    static bool IsAvailable(const Player *player, const Card *analeptic = NULL);

    bool isAvailable(const Player *player) const;
    bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    void onUse(Room *room, const CardUseStruct &card_use) const;
    void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
    void onEffect(const CardEffectStruct &effect) const;
};

class KeyTrick : public DelayedTrick
{
    Q_OBJECT

public:
    Q_INVOKABLE KeyTrick(Card::Suit suit, int number);

    bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    void takeEffect(ServerPlayer *target) const;
    void onEffect(const CardEffectStruct &effect) const;
    void onNullified(ServerPlayer *target) const;
    void onUse(Room *room, const CardUseStruct &card_use) const;
};

class YinshenCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE YinshenCard();



    void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

class QidaoCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE QidaoCard();

    bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

class ShuohuangCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE ShuohuangCard();

    bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

class ZhurenCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE ZhurenCard();

    bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

class DiangongCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE DiangongCard();

    bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

class ZhilingCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE ZhilingCard();

    bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

#endif

