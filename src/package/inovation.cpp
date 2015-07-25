#include "inovation.h"
#include "general.h"
#include "skill.h"
#include "standard.h"
#include "client.h"
#include "engine.h"
#include "maneuvering.h"
#include "clientplayer.h"
#include "wrapped-card.h"
#include "room.h"
#include "roomthread.h"


YinshenCard::YinshenCard()
{
    target_fixed = true;
}

void YinshenCard::use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &) const
{
    room->akarinPlayer(source);
}

class Yinshen : public ZeroCardViewAsSkill
{
public:
    Yinshen() : ZeroCardViewAsSkill("yinshen")
    {
    }

    bool isEnabledAtPlay(const Player *player) const
    {
        return !player->hasUsed("YinshenCard");
    }

    const Card *viewAs() const
    {
        return new YinshenCard;
    }
};


InovationPackage::InovationPackage()
    : Package("inovation")
{
    General *akarin = new General(this, "akarin", "real"); // WEI 009
    akarin->addSkill(new Yinshen);

    addMetaObject<YinshenCard>();
}

ADD_PACKAGE(Inovation)

