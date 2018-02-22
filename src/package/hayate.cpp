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
                    room->doLightbox("bimie$", 1500);
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


class Gangqu : public TriggerSkill
{
public:
    Gangqu() : TriggerSkill("gangqu")
    {
        frequency = NotFrequent;
        events << EventPhaseStart << CardEffected;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == EventPhaseStart)
        {
            if (player->getPhase() == Player::Finish){
                if (!player->isKongcheng() && player->getPile("gang").length() == 0 && room->askForSkillInvoke(player, objectName(), data)){
                    player->addToPile("gang", room->askForCardChosen(player, player, "h", objectName()));
                }
            }
            else if (player->getPhase() == Player::Start && player->getPile("gang").length() > 0){
                if (player->getPile("gang").length() == 1){
                    room->obtainCard(player, player->getPile("gang").first());
                }
                else{
                    room->fillAG(player->getPile("gang"), player);
                    room->obtainCard(player, room->askForAG(player, player->getPile("gang"), false, objectName()));
                    room->clearAG(player);
                }
            }
        }
        else if (triggerEvent == CardEffected){
            CardEffectStruct effect = data.value<CardEffectStruct>();
            if (effect.to == player && player->getPile("gang").length() > 0 && effect.card->getType() == (Sanguosha->getCard(player->getPile("gang").first()))->getType() && room->askForSkillInvoke(player, objectName() + "Prevent", data)){
                room->broadcastSkillInvoke(objectName());
                room->doLightbox(objectName() + "$", 800);
                return true;
            }
        }
        return false;
    }
};

TiaojiaoCard::TiaojiaoCard()
{
}

bool TiaojiaoCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    if (!targets.isEmpty()) return false;
    return to_select != Self;
}

void TiaojiaoCard::use(Room *room, ServerPlayer *tsukushi, QList<ServerPlayer *> &targets) const
{
    ServerPlayer *target = targets.first();
    ServerPlayer *slashTarget = room->askForPlayerChosen(tsukushi, room->getAlivePlayers(), "tiaojiao");
    if (!room->askForUseSlashTo(target, slashTarget, "@TiaojiaoSlash:" + tsukushi->getGeneralName() + ":" + target->getGeneralName() + ":" + slashTarget->getGeneralName(), false)){
        if (!target->isNude()){
            room->obtainCard(tsukushi, room->askForCardChosen(tsukushi, target, "hej", objectName()));
        }
    }
}

class Tiaojiao : public ZeroCardViewAsSkill
{
public:
    Tiaojiao() : ZeroCardViewAsSkill("tiaojiao")
    {
    }

    bool isEnabledAtPlay(const Player *player) const
    {
        return !player->hasUsed("TiaojiaoCard");
    }

    const Card *viewAs() const
    {
        return new TiaojiaoCard();
    }
};


class Gongming : public TriggerSkill
{
public:
    Gongming() : TriggerSkill("gongming")
    {
        frequency = NotFrequent;
        events << HpRecover;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target != NULL;
    }

    bool trigger(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        ServerPlayer *sher = room->findPlayerBySkillName(objectName());
        if (!sher){
            return false;
        }
        if (sher->getPhase() == Player::NotActive){
            return false;
        }
        if (room->askForChoice(sher, objectName(), "youdraw+hedraws") == "youdraw"){
            sher->drawCards(sher->getLostHp() + 1);
        }
        else{
            player->drawCards(sher->getLostHp() + 1);
        }
        room->broadcastSkillInvoke(objectName());
        return false;
    }
};

class YaojingVS : public OneCardViewAsSkill
{
public:
    YaojingVS() : OneCardViewAsSkill("yaojing")
    {
    }

    bool isEnabledAtPlay(const Player *player) const
    {
        return player->hasFlag("Yaojing_Active");
    }

    bool viewFilter(const Card *card) const
    {
        return true;
    }

    const Card *viewAs(const Card *originalCard) const
    {
        Card *god_salvation = new GodSalvation(originalCard->getSuit(), originalCard->getNumber());
        god_salvation->addSubcard(originalCard->getId());
        god_salvation->setSkillName(objectName());
        return god_salvation;
    }
};

class Yaojing : public TriggerSkill
{
public:
    Yaojing() : TriggerSkill("yaojing")
    {
        events << EventPhaseChanging << CardUsed << EventLoseSkill << Death;
        view_as_skill = new YaojingVS;
    }

    int getEffectIndex(const ServerPlayer*, const Card*){
        return 0;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == EventPhaseChanging && player->hasSkill(objectName())) {
            // change phase to not active -> make change to maximum
            PhaseChangeStruct changing = data.value<PhaseChangeStruct>();
            if (changing.from == Player::Discard){
                player->tag["yaojing_times"] = QVariant(0);
            }
            else if (changing.to == Player::Play){
                if (room->hasAura()){
                    if (room->getAura() == objectName() || room->getAura() == "MacrossF"){
                        // is current

                        room->setPlayerFlag(player, "Yaojing_Active");
                        return false;
                    }
                    if (room->getAuraPlayer()->getHandcardNum() > player->getHandcardNum()){
                        // cannot replace
                        return false;
                    }

                }
                if (!player->askForSkillInvoke(objectName(), data)){
                    return false;
                }
                room->broadcastSkillInvoke(objectName(), rand() % 2 * 2 + 1);
                room->setPlayerFlag(player, "Yaojing_Active");
                if (room->getAura() == "xingjian"){
                    room->doAura(player, "MacrossF");
                }
                else{
                    room->doAura(player, objectName());
                }
                
            }
        }
        else if (triggerEvent == CardUsed) {
            // gain card used mark
            CardUseStruct use = data.value<CardUseStruct>();
            if (use.card->isKindOf("GodSalvation") && use.from == player && player->hasSkill(objectName())){
                if (use.card->getSkillName() == objectName()){
                    room->doLightbox(objectName() + "$", 1500);
                    player->tag["yaojing_times"] = QVariant(player->tag["yaojing_times"].toInt() + 1);
                }
            }
        }
        else if (triggerEvent == EventLoseSkill){
            if (data.toString() == objectName() && room->hasAura() && (room->getAura() == objectName() || room->getAura() == "MacrossF")){
                player->tag["yaojing_times"] = QVariant(0);
                if (room->getAura() == "MacrossF"){
                    ServerPlayer *ranka = room->findPlayerBySkillName("xingjian");
                    if (ranka &&ranka->isAlive()){
                        room->doAura(ranka, "xingjian");
                        return false;
                    }
                    
                }
                room->clearAura();
            }
        }
        else if (triggerEvent == Death){
            DeathStruct death = data.value<DeathStruct>();
            if (death.who->hasSkill(objectName()) && room->hasAura() && (room->getAura() == objectName() || room->getAura() == "MacrossF")){
                player->tag["yaojing_times"] = QVariant(0);
                if (room->getAura() == "MacrossF"){
                    ServerPlayer *ranka = room->findPlayerBySkillName("xingjian");
                    if (ranka && ranka->isAlive()){
                        room->doAura(ranka, "xingjian");
                        return false;
                    }

                }
                room->clearAura();
            }
        }

        return false;
    }
};

class YaojingMaxCards : public MaxCardsSkill
{
public:
    YaojingMaxCards() : MaxCardsSkill("#yaojing")
    {
    }

    int getExtra(const Player *target) const
    {
        if (target->tag["yaojing_times"].toInt() > 0){
            return  -target->tag["yaojing_times"].toInt();
        }
        else
            return 0;
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

    General *tsukushi = new General(this, "tsukushi", "real", 3, false);
    tsukushi->addSkill(new Gangqu);
    tsukushi->addSkill(new Tiaojiao);

    addMetaObject<TiaojiaoCard>();

    General *sheryl = new General(this, "sheryl", "diva", 3, false);
    sheryl->addSkill(new Yaojing);
    sheryl->addSkill(new YaojingMaxCards);
    sheryl->addSkill(new Gongming);
    related_skills.insertMulti("yaojing", "#yaojing");
}

ADD_PACKAGE(Hayate)