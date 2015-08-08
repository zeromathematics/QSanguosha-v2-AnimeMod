#ifndef _ERCIYUAN_H
#define _ERCIYUAN_H

#include "package.h"
#include "card.h"
//#include "skill.h"
//#include "standard.h"


class ErciyuanPackage : public Package
{
    Q_OBJECT

public:
    ErciyuanPackage();
};

class WuxinCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE WuxinCard();

    bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

#endif

