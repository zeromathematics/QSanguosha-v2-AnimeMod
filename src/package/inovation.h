#ifndef _INOVATION_H
#define _INOVATION_H

#include "package.h"
#include "card.h"

class InovationPackage : public Package
{
    Q_OBJECT

public:
    InovationPackage();
};

class YinshenCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE YinshenCard();

    void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

#endif

