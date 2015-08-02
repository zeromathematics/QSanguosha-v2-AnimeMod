#include "erciyuan.h"
#include "skill.h"
#include "standard.h"
#include "clientplayer.h"
#include "engine.h"
#include "util.h"
#include "room.h"
#include "roomthread.h"

class Renzha : public MasochismSkill
{
public:
	Renzha() : MasochismSkill("renzha")
	{
		frequency = Frequent;
	}
	
	void onDamaged(ServerPlayer *target, const DamageStruct &damage) const
	{
		Room *room = target->getRoom();
		for (int i = 0; i < damage.damage; i++) {
			if (target->isAlive() && room->askForSkillInvoke(target, objectName(), QVariant::fromValue(damage))) {
				room->broadcastSkillInvoke(objectName());
				room->drawCards(target, 2, objectName());
				int id = room->askForCardChosen(target, target, "h", objectName());
				target->addToPile("zha", id)
				if (room->askForChoice(target, objectName(), "RenzhaTurnover+cancel") == "RenzhaTurnover")
				{
					room->broadcastSkillInvoke(objectName());
					target->turnOver();
					room->drawCards(target, 2, objectName());
				} else {
					break;
				}
			}
		}	
	}
}

#include "thicket.h"

class Haochuan : public OneCardViewAsSkill
{
public:
	Haochuan() : OneCardViewAsSkill("haochuan")
	{
		expand_pile = "zha";
		filter_pattern = ".|.|.|zha";
	}
	
	bool isEnabledAtPlay(const Player *player) const
    {
        return player->faceUp();
    }

    const Card *viewAs(const QList<const Card *> &cards) const
    {
		LuanwuCard *luanwu = new LuanwuCard;
		luanwu->addSubcard(cards[1]);
		return luanwu;
    }
}

ErciyuanPackage::ErciyuanPackage() : Package("erciyuan")
{
	General *itomakoto = new General(this, "itomakoto", "real", 3, true, false);
	itomakoto->addSkill(new Haochuan);
	itomakoto->addSkill(new Renzha);
	
}

ADD_PACKAGE(Erciyuan)
