#include "hayate.h"
#include "serverplayer.h"
#include "room.h"
#include "skill.h"
#include "maneuvering.h"
#include "clientplayer.h"
#include "engine.h"
#include "client.h"
#include "exppattern.h"
#include "roomthread.h"
#include "wrapped-card.h"
#include "json.h"
#include "settings.h"

class Yingdi : public TriggerSkill
{
public:
    Yingdi() : TriggerSkill("yingdi")
    {
        frequency = Compulsory;
        events << CardUsed << Damage << EventPhaseStart << EventLoseSkill;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == CardUsed){

            CardUseStruct use = data.value<CardUseStruct>();
            if (!use.card || !use.card->isKindOf("Slash")){
                return false;
            }
            if (!use.from || use.from->getMark("@real_hei") > 0){
                return false;
            }
            if (use.to.length() == 0){
                return false;
            }
            //if it is ai, then return false
            if (use.from->getAI() != NULL){
                return false;
            }

            foreach(ServerPlayer *to, use.to){
                if (!to->hasSkill(objectName())){
                    continue;
                }
                return true;
            }
        }
        else if (triggerEvent == Damage){
            DamageStruct damage = data.value<DamageStruct>();
            if (!damage.from || !damage.from->hasSkill(objectName())){
                return false;
            }
            if (damage.to && damage.to->getMark("@real_hei") == 0){
                damage.to->gainMark("@real_hei");
            }
        }
        else if (triggerEvent == EventPhaseStart){
            if (player && player->hasSkill(objectName()) && player->isAlive() && player->getPhase() == Player::RoundStart){
                QStringList lst;
                foreach(ServerPlayer *p, room->getAlivePlayers()){
                    if (!lst.contains(p->getRole())){
                        lst.append(p->getRole());
                    }
                }
                if (lst.length() <= 2){
                    room->detachSkillFromPlayer(player, objectName());
                    room->acquireSkill(player, "jiesha");
                }
            }
        }
        else if (triggerEvent == EventLoseSkill){
            if (data.toString() == objectName()){
                foreach(ServerPlayer *player, room->getAlivePlayers()){
                    if (player->getMark("@real_hei") > 0){
                        player->loseAllMarks("@real_hei");
                    }
                }
            }
        }
        return false;
    }
};

class Diansuo : public TriggerSkill
{
public:
    Diansuo() : TriggerSkill("diansuo")
    {
        frequency = NotFrequent;
        events << EventPhaseStart << EventLoseSkill << DamageCaused << TargetConfirming;
    }
    bool triggerable(const ServerPlayer *target) const
    {
        return target;
    }
    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == EventPhaseStart) {
            if (player && player->hasSkill(objectName()) && player->isAlive() && player->getPhase() == Player::Play){
                if (room->askForSkillInvoke(player, objectName(), data)){
                    foreach(ServerPlayer *player, room->getAlivePlayers()){
                        if (player->getMark("@diansuo_target") > 0){
                            player->loseAllMarks("@diansuo_target");
                        }
                    }
                    room->askForPlayerChosen(player, room->getAlivePlayers(), objectName())->gainMark("@diansuo_target");
                }
            }
        }
        else if (triggerEvent == EventLoseSkill) {
            if (data.toString() == objectName()){
                foreach(ServerPlayer *player, room->getAlivePlayers()){
                    if (player->getMark("@diansuo_target") > 0){
                        player->loseAllMarks("@diansuo_target");
                    }
                }
            }
        }
        else if (triggerEvent == DamageCaused){
            DamageStruct damage = data.value<DamageStruct>();
            if (damage.from && damage.from->isAlive() && damage.to && damage.to->isAlive() && damage.from->hasSkill(objectName())){
                ServerPlayer *a;
                bool hasA = false;
                foreach(ServerPlayer *p, room->getAlivePlayers()){
                    if (p->getMark("@diansuo_target") > 0){
                        a = p;
                        hasA = true;
                        break;
                    }
                }
                if (!hasA){
                    return false;
                }

                if (a == damage.to){
                    return false;
                }

                if (room->askForSkillInvoke(damage.from, objectName()+"_cause", data)){
                    if (room->askForChoice(damage.from, objectName(), "diansuo_left+diansuo_right", data) == "diansuo_left"){
                        while (damage.to != a->getNext()){
                            room->getThread()->delay(150);
                            room->swapSeat(a, a->getNext());
                        }
                    }
                    else{
                        while (damage.to != a->getNext()){
                            room->getThread()->delay(150);
                            room->swapSeat(a, a->getNext());
                        }
                        room->getThread()->delay(150);
                        room->swapSeat(a, a->getNext());
                    }
                    a->loseAllMarks("@diansuo_target");
                    damage.from = a;
                    damage.nature = DamageStruct::Thunder;
                    data.setValue(damage);

                    LogMessage log;
                    log.type = "#diansuo_source_change";
                    log.from = a;
                    room->sendLog(log);
                }
            }
        }
        else if (triggerEvent == TargetConfirming){
            CardUseStruct use = data.value<CardUseStruct>();
            if (use.to.length() == 1 && use.from && use.from->isAlive()){

                ServerPlayer *hei = room->findPlayerBySkillName(objectName());
                if (!hei || hei->isDead() || hei->getPhase() != Player::NotActive){
                    return false;
                }

                ServerPlayer *old = use.to.first();
                if (!old || old->isDead()){
                    return false;
                }
                ServerPlayer *a;
                bool hasA = false;
                foreach(ServerPlayer *p, room->getAlivePlayers()){
                    if (p->getMark("@diansuo_target") > 0){
                        a = p;
                        printf("has_target");
                        hasA = true;
                        break;
                    }
                }
                if (!hasA){
                    return false;
                }

                if (a == old){
                    return false;
                }
                if (a == use.from){
                    return false;
                }
                if (old == use.from){
                    return false;
                }

                int left_distance = 0;
                int right_distance = 0;

                ServerPlayer *s = old;
                while (s != use.from){
                    left_distance++;
                    s = s->getNext();
                }
                s = use.from;
                while (s != old){
                    right_distance++;
                    s = s->getNext();
                }

                bool can = false;

                printf("left is" + left_distance);
                printf("right is" + right_distance);

                if (left_distance == right_distance){
                    can = true;
                }
                else if (left_distance < right_distance){
                    
                    ServerPlayer *current = old->getNext();
                    while (current != use.from){
                        if (current == a){
                            can = true;
                            break;
                        }
                        else{
                            current = current->getNext();
                        }
                    }
                }
                else{
                    ServerPlayer *current = use.from->getNext();
                    while (current != old){
                        if (current == a){
                            can = true;
                            break;
                        }
                        else{
                            current = current->getNext();
                        }
                    }
                }
                
                if (can && room->askForSkillInvoke(hei, objectName() + "_target", data)){
                    if (left_distance < right_distance){

                        while (old != a->getNext()){
                            room->swapSeat(a, a->getNext());
                        }
                    }
                    else{
                        while (old != a->getNext()){
                            room->swapSeat(a, a->getNext());
                        }
                    }

                    use.to.removeOne(old);
                    use.to.append(a);
                    data.setValue(use);

                    // need a broadcast
                    LogMessage log;
                    log.type = "#diansuo_effect";
                    log.from = a;
                    log.arg = old->getGeneralName();
                    log.arg2 = use.card->objectName();
                    room->sendLog(log);
                }
                
            }
        }
        return false;
    }
};


class Jiesha : public TriggerSkill
{
public:
    Jiesha() : TriggerSkill("jiesha")
    {
        frequency = Compulsory;
        events << SlashProceed;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == SlashProceed) {
            SlashEffectStruct effect = data.value<SlashEffectStruct>();
            if (effect.from && effect.from->hasSkill(objectName()) && effect.from->getWeapon() && effect.from->getWeapon()->isKindOf("DoubleSword") && effect.to){
                LogMessage log;
                log.type = "#jiesha_effect";
                log.from = effect.to;
                log.arg = effect.slash->objectName();
                room->sendLog(log);
                room->slashResult(effect, NULL);
                return true;
            }
        }
        return false;
    }
};

// for oumashu
class LonelinessInvalidity : public InvaliditySkill
{
public:
    LonelinessInvalidity() : InvaliditySkill("#loneliness-inv")
    {
    }

    bool isSkillValid(const Player *player, const Skill *skill) const
    {
        return player->getMark("Loneliness" + skill->objectName()) == 0;
    }
};





// akame


// diarmuid
class Pomo : public TriggerSkill
{
public:
    Pomo() : TriggerSkill("pomo")
    {
        frequency = Compulsory;
        events << TargetConfirmed << CardFinished << TargetSpecified;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == TargetConfirmed) 
        {
            CardUseStruct use = data.value<CardUseStruct>();
            if (use.from && use.from->hasSkill(objectName()) && use.card->isKindOf("Slash") && use.from == player){
                room->setPlayerFlag(use.from, "PomoArmor");
                room->broadcastSkillInvoke(objectName());
                foreach(ServerPlayer *p, use.to){
                    room->setPlayerMark(p, "Armor_Nullified", 1);
                }
            }
        }
        else if (triggerEvent == TargetSpecified && TriggerSkill::triggerable(player)){
            CardUseStruct use = data.value<CardUseStruct>();
            if (!use.card->isKindOf("Slash"))
                return false;
            foreach(ServerPlayer *p, use.to) {
                if (!player->isAlive()) break;
                p->addMark("pomo");
                room->addPlayerMark(p, "@skill_invalidity");

                foreach(ServerPlayer *pl, room->getAllPlayers())
                    room->filterCards(pl, pl->getCards("he"), true);
                JsonArray args;
                args << QSanProtocol::S_GAME_EVENT_UPDATE_SKILL;
                room->doBroadcastNotify(QSanProtocol::S_COMMAND_LOG_EVENT, args);
            }
        }
        else if (triggerEvent == CardFinished)
        {
            CardUseStruct use = data.value<CardUseStruct>();
            if (use.card->isKindOf("Slash") && use.from->hasFlag("PomoArmor")){
                foreach(ServerPlayer *p, use.to){
                    room->setPlayerMark(p, "Armor_Nullified", 0);
                    if (p->getMark("pomo") == 0) continue;
                    room->removePlayerMark(p, "@skill_invalidity", p->getMark("pomo"));
                    p->setMark("pomo", 0);
                }
            }
        }
        return false;
    }
};


class Bimie : public TriggerSkill
{
public:
    Bimie() : TriggerSkill("bimie")
    {
        frequency = NotFrequent;
        events << Damage << PreHpRecover << Death;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target != NULL;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == Damage)
        {
            DamageStruct damage = data.value<DamageStruct>();
            if (damage.card && damage.card->isKindOf("Slash") && damage.from == player && damage.from->hasSkill(objectName()) && damage.to->getMark("@zhou") == 0 && damage.to->isAlive()){
                if (room->askForSkillInvoke(player, objectName(), data)){
                    room->broadcastSkillInvoke(objectName());
                    room->doLightbox("LuaBimie$", 1500);
                    damage.to->gainMark("@zhou", 1);
                }
            }
        }
        else if (triggerEvent == PreHpRecover){
            return player->getMark("@zhou") > 0;
        }
        else if (triggerEvent == Death)
        {
            DeathStruct death = data.value<DeathStruct>();
            if (player == death.who && death.who->hasSkill(objectName())){
                foreach(ServerPlayer *p, room->getAlivePlayers()){
                    room->setPlayerMark(p, "@zhou", 0);
                }
            }
        }
        return false;
    }
};







HayatePackage::HayatePackage()
    : Package("hayate")
{
    General *hei = new General(this, "hei", "science", 4);
    skills << new Jiesha << new LonelinessInvalidity;
    hei->addSkill(new Yingdi);
    hei->addSkill(new Diansuo);
    hei->addWakeTypeSkillForAudio("jiesha");

    General * diarmuid = new General(this, "diarmuid", "magic", 4);
    diarmuid->addSkill(new Pomo);
    diarmuid->addSkill(new Bimie);
}

ADD_PACKAGE(Hayate)