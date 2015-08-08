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
        for (int i = 0; i < damage.damage; i++)
        {
            if (target->isAlive() && room->askForSkillInvoke(target, objectName(), QVariant::fromValue(damage)))
            {
                room->broadcastSkillInvoke(objectName());
                room->drawCards(target, 2, objectName());
                int id = room->askForCardChosen(target, target, "h", objectName());
                target->addToPile("zha", id);
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
};

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

    const Card *viewAs(const Card *originalCard) const
    {
        LuanwuCard *luanwu = new LuanwuCard;
        luanwu->addSubcard(originalCard);
        return luanwu;
    }
};

class Chidun : public TriggerSkill
{
public:
    Chidun() : TriggerSkill("chidun")
    {
        events << DamageInflicted << DamageComplete << DamageCaused;
    }
    
    bool triggerable(const ServerPlayer *target) const
    {
        return target != NULL;
    }
    
    bool trigger(TriggerEvent event, Room *room, ServerPlayer *player, QVariant &data) const
    {
        DamageStruct damage = data.value<DamageStruct>();
        if (event == DamageInflicted)
        {
            QList<ServerPlayer *> ayanamis = room->findPlayersBySkillName(objectName());
            foreach (ServerPlayer *ayanami, ayanamis)
            {
                if (damage.to != ayanami && damage.damage >= 1 && !damage.transfer && ayanami->askForSkillInvoke(objectName(), data))
                {
                    room->notifySkillInvoked(ayanami, objectName());
                    room->broadcastSkillInvoke(objectName(), 1);
                    
                    LogMessage log;
                    log.type = "#TriggerSkill";
                    log.from = ayanami;
                    log.arg = objectName();
                    room->sendLog(log);
                    
                    damage.to->setFlags("chidun_tar");
                    damage.transfer = true;
                    damage.to = ayanami;
                    damage.transfer_reason = objectName();
                    player->tag["TransferDamage"] = QVariant::fromValue(damage);
                    
                    return true;
                }
            }
        } else if (event == DamageComplete) {
            ServerPlayer *slasher = NULL;
            
            foreach (ServerPlayer *tar, room->getAlivePlayers())
            {
                if (tar->hasFlag("chidun_tar"))
                {
                    slasher = tar;
                    break;    
                }
            }
            
            if (slasher)
                slasher->setFlags("-chidun_tar");
                
            QString prompt = "@chidun:" + damage.from->objectName();
            
            while (true)
            {
                slasher->setFlags("chidun_slasher");
                const Card *slash = room->askForUseSlashTo(slasher, damage.from, prompt, false, false, false);
                if (slash)
                {
                    room->broadcastSkillInvoke(objectName(), 2);
                } else {
                    break;
                }
            }
            return false;
        } else {
            if (damage.from->hasFlag("chidun_slash"))
            {
                damage.from->setFlags("-chidun_slash");
                damage.damage ++;
                data = QVariant::fromValue(damage);
                room->broadcastSkillInvoke(objectName(), 3);
            }
        }
        return false;
    }
};

WuxinCard::WuxinCard()
{
    target_fixed = false;
    mute = true;
}

bool WuxinCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    return targets.length() == 0 && to_select != Self;
}

void WuxinCard::use(Room *room, ServerPlayer *player, QList<ServerPlayer *> &targets) const
{
    if (player->isKongcheng()) return;
    ServerPlayer *target = targets.first();

    room->broadcastSkillInvoke("wuxin");
    DummyCard *handcards = player->wholeHandCards();
    
    CardMoveReason reason(CardMoveReason::S_REASON_GIVE, player->objectName(), target->objectName(), "wuxin", QString());
    room->obtainCard(target, handcards, reason, false);
    delete handcards;
    room->recover(player, RecoverStruct(player));
}

class WuxinVS : public ZeroCardViewAsSkill
{
public:
    WuxinVS() : ZeroCardViewAsSkill("wuxin")
    {
    }

    bool isEnabledAtPlay(const Player *) const
    {
        return false;
    }

    bool isEnabledAtResponse(const Player *player, const QString &pattern) const
    {
        return pattern == "@@wuxin" && !player->isKongcheng();
    }

    const Card *viewAs() const
    {
        return new WuxinCard;
    }
};

class WuxinAya : public TriggerSkill
{
public:
    WuxinAya() : TriggerSkill("wuxinaya")
    {
        events << DamageInflicted;
        view_as_skill = new WuxinVS;
    }
    
    bool trigger(TriggerEvent event, Room *room, ServerPlayer *player, QVariant &data) const
    {
        DamageStruct damage = data.value<DamageStruct>();
        if (damage.damage >= player->getHp() && !player->isKongcheng() && player->isAlive() && player->askForSkillInvoke(objectName(), data))
        {
            room->askForUseCard(player, "@@wuxin", "@wuxin_give", -1, Card::MethodUse);
            return true;
        }
    }
};

ErciyuanPackage::ErciyuanPackage() : Package("erciyuan")
{
    General *itomakoto = new General(this, "itomakoto", "real", 3, true, false);
    itomakoto->addSkill(new Haochuan);
    itomakoto->addSkill(new Renzha);
    
    General *ayanamirei = new General(this, "ayanamirei", "science", 3, false, false);
    ayanamirei->addSkill(new WuxinAya);
    ayanamirei->addSkill(new Chidun);
}

ADD_PACKAGE(Erciyuan)