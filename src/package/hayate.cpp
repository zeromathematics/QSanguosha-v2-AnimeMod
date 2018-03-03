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

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *, QVariant &data) const
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

    bool trigger(TriggerEvent, Room *room, ServerPlayer *player, QVariant &) const
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

    bool viewFilter(const Card *) const
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

class Kurimu : public TriggerSkill
{
public:
    Kurimu() : TriggerSkill("kurimu")
    {
        frequency = NotFrequent;
        events << CardsMoveOneTime;
    }

    bool trigger(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        CardsMoveOneTimeStruct move = data.value<CardsMoveOneTimeStruct>();
        if (move.from && move.from == player){
            foreach(int card_id, move.card_ids){
                Card *card = Sanguosha->getCard(card_id);
                if (player->getPhase() == Player::NotActive && card->getSuit() == Card::Diamond && (move.from_places.contains(Player::PlaceHand) || move.from_places.contains(Player::PlaceEquip)) && room->askForSkillInvoke(player, objectName(), data)){
                    room->broadcastSkillInvoke(objectName());
                    room->doLightbox(objectName() + "$", 800);
                    ServerPlayer *to = room->askForPlayerChosen(player, room->getOtherPlayers(player), objectName());
                    player->drawCards(1);
                    to->drawCards(1);
                }
            }
        }
        return false;
    }
};

class Minatsu : public TriggerSkill
{
public:
    Minatsu() : TriggerSkill("minatsu")
    {
        frequency = NotFrequent;
        events << CardsMoveOneTime;
    }

    bool trigger(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        CardsMoveOneTimeStruct move = data.value<CardsMoveOneTimeStruct>();
        if (move.from && move.from == player){
            foreach(int card_id, move.card_ids){
                Card *card = Sanguosha->getCard(card_id);
                if (player->getPhase() == Player::NotActive && card->getSuit() == Card::Club && (move.from_places.contains(Player::PlaceHand) || move.from_places.contains(Player::PlaceEquip)) && room->askForSkillInvoke(player, objectName(), data)){
                    room->broadcastSkillInvoke(objectName());
                    room->doLightbox(objectName() + "$", 800);
                    ServerPlayer *to = room->askForPlayerChosen(player, room->getAlivePlayers(), objectName());
                    Card *card1 = Sanguosha->cloneCard("fire_slash", Card::NoSuit, 0);
                    card1->setSkillName(objectName());
                    room->useCard(CardUseStruct(card1, player, to, false));
                }
            }
        }
        return false;
    }
};


class Chizuru : public TriggerSkill
{
public:
    Chizuru() : TriggerSkill("chizuru")
    {
        frequency = NotFrequent;
        events << CardsMoveOneTime;
    }

    bool trigger(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        CardsMoveOneTimeStruct move = data.value<CardsMoveOneTimeStruct>();
        if (move.from && move.from == player){
            foreach(int card_id, move.card_ids){
                Card *card = Sanguosha->getCard(card_id);
                if (player->getPhase() == Player::NotActive && card->getSuit() == Card::Heart && (move.from_places.contains(Player::PlaceHand) || move.from_places.contains(Player::PlaceEquip)) && room->askForSkillInvoke(player, objectName(), data)){
                    room->broadcastSkillInvoke(objectName());
                    room->doLightbox(objectName() + "$", 800);
                    ServerPlayer *to = room->askForPlayerChosen(player, room->getAlivePlayers(), objectName());
                    room->recover(to, RecoverStruct(player), true);
                }
            }
        }
        return false;
    }
};

class Mafuyu : public TriggerSkill
{
public:
    Mafuyu() : TriggerSkill("mafuyu")
    {
        frequency = NotFrequent;
        events << CardsMoveOneTime << EventPhaseStart << EventLoseSkill << Death;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == CardsMoveOneTime){
            CardsMoveOneTimeStruct move = data.value<CardsMoveOneTimeStruct>();
            if (move.from && move.from->hasSkill(objectName()) && move.from->objectName() == player->objectName()){

                foreach(int card_id, move.card_ids){
                    Card *card = Sanguosha->getCard(card_id);
                    if (player->getPhase() == Player::NotActive && card->getSuit() == Card::Spade && (move.from_places.contains(Player::PlaceHand) || move.from_places.contains(Player::PlaceEquip)) && room->askForSkillInvoke(player, objectName(), data)){
                        room->broadcastSkillInvoke(objectName());
                        room->doLightbox(objectName() + "$", 800);
                        ServerPlayer *to = room->askForPlayerChosen(player, room->getAlivePlayers(), objectName());
                        to->gainMark("@mafuyu");
                    }
                }
            }
        }
        else if (triggerEvent == EventPhaseStart){
            if (player->getPhase() == Player::RoundStart){
                ServerPlayer *key = room->findPlayerBySkillName(objectName());
                if (!key && player->getMark("@mafuyu") > 0){
                    player->loseAllMarks("@mafuyu");
                    return false;
                }
                if (player->getMark("@mafuyu") > 0 && !player->isSkipped(Player::Play)){
                    room->broadcastSkillInvoke(objectName());
                    player->loseMark("@mafuyu");
                    player->skip(Player::Play);
                }
            }
        }
        else if (triggerEvent == EventLoseSkill){
            if (data.toString() == objectName()){
                foreach(ServerPlayer *p, room->getAlivePlayers()){
                    p->loseAllMarks("@mafuyu");
                }
            }
        }
        else if (triggerEvent == Death){
            DeathStruct death = data.value<DeathStruct>();
            if (death.who->hasSkill(objectName())){
                foreach(ServerPlayer *p, room->getAlivePlayers()){
                    p->loseAllMarks("@mafuyu");
                }
            }
        }
        return false;
    }
};

HaremuCard::HaremuCard()
{
    will_throw = false;
}

bool HaremuCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *) const
{
    return to_select->hasFlag("haremu_target") && targets.length() == 0;
}

void HaremuCard::use(Room *room, ServerPlayer *player, QList<ServerPlayer *> &targets) const
{
    ServerPlayer *target = targets.at(0);
    if (!target)
        return;
    QStringList used = player->tag["heremu_targets"].toStringList();
    used.append(target->objectName());
    player->tag["heremu_targets"] = used;
    room->obtainCard(target, this, true);
    
    if (!target->hasClub() && room->askForChoice(target, "haremu", "haremu_accept+cancel", QVariant::fromValue(player)) == "haremu_accept"){
        target->addClub("@amclub_haremu");
    }
}

class HaremuVS : public OneCardViewAsSkill
{
public:
    HaremuVS() : OneCardViewAsSkill("haremu"){
        response_pattern = "@@haremu";
    }

    bool viewFilter(const Card *) const
    {
        return true;
    }

    const Card *viewAs(const Card *originalCard) const
    {
        HaremuCard *hc = new HaremuCard();
        hc->addSubcard(originalCard);
        hc->setSkillName("haremu");
        return hc;
    }
};

class Haremu : public TriggerSkill
{
public:
    Haremu() : TriggerSkill("haremu")
    {
        frequency = NotFrequent;
        events << GameStart << EventAcquireSkill << EventLoseSkill << Death << EventPhaseStart;
        view_as_skill = new HaremuVS;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == GameStart){
            if (player->hasSkill(objectName()))
                player->addClub("@amclub_haremu");
        }
        else if (triggerEvent == EventAcquireSkill){
            if (player->hasSkill(objectName())){
                player->addClub("@amclub_haremu");
            }
        }
        else if (triggerEvent == EventLoseSkill){
            if (data.toString() == objectName()){
                room->clearClub("@amclub_haremu");
            }
        }
        else if (triggerEvent == Death){
            DeathStruct death = data.value<DeathStruct>();
            if (death.who->hasSkill(objectName())){
                room->clearClub("@amclub_haremu");
            }
        }
        else if (triggerEvent == EventPhaseStart){
            if (player->isFemale() && !player->hasSkill(objectName()) && player->getPhase() == Player::Play){
                ServerPlayer *key = room->findPlayerBySkillName(objectName());
                if (!key || !key->isAlive()){
                    return false;
                }
                QStringList used = key->tag["heremu_targets"].toStringList();
                if (used.contains(player->objectName())){
                    return false;
                }
                room->setPlayerFlag(player, "haremu_target");
                room->askForUseCard(key, "@@haremu", "@haremu-use");
            }
        }
        return false;
    }
};

class HaremuMaxCards : public MaxCardsSkill
{
public:
    HaremuMaxCards() : MaxCardsSkill("#haremu")
    {
    }

    int getExtra(const Player *target) const
    {
        if (!target->hasClub("@amclub_haremu")){
            return 0;
        }
        int i = 1;
        foreach(const Player *p, target->getSiblings()){
            if (p->isAlive() && p->hasClub("@amclub_haremu")){
                i++;
            }
        }
        return i;
    }
};

// redo  gaokang
class Gaokang : public TriggerSkill
{
public:
    Gaokang() : TriggerSkill("gaokang")
    {
        frequency = NotFrequent;
        events << DamageInflicted;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *, QVariant &data) const
    {
        if (triggerEvent == DamageInflicted){
            DamageStruct damage = data.value<DamageStruct>();
            if (damage.damage < 1 || damage.nature != DamageStruct::Normal || !damage.to){
                return false;
            }
            ServerPlayer *redo = room->findPlayerBySkillName(objectName());
            if (!redo || redo->isDead() ||redo->isKongcheng() || redo->distanceTo(damage.to) > 1 || !room->askForSkillInvoke(redo, objectName(), data)){
                return false;
            }
            room->throwCard(room->askForCardChosen(redo, redo, "he", objectName()), redo, redo);
            damage.damage -= 1;
            room->broadcastSkillInvoke(objectName());
            data.setValue(damage);
            if (redo->isKongcheng()){
                damage.to->drawCards(2);
            }
        }
        return false;
    }
};

// eugeo
class Rennai : public TriggerSkill
{
public:
    Rennai() : TriggerSkill("rennai")
    {
        frequency = Compulsory;
        events << DamageInflicted << PreHpLost << EventPhaseStart << EventLoseSkill << Death;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target;
    }

    void calcFreeze(Room *room, ServerPlayer *player) const{
        if (room->askForChoice(player, objectName(), "rennai_hp+rennai_handcardnum") == "rennai_hp"){
            QStringList hps;
            foreach(ServerPlayer *p, room->getAlivePlayers()){
                
                if (!hps.contains(QString::number(p->getHp()))){
                    hps.append(QString::number(p->getHp()));
                }
            }
            int targetHp = room->askForChoice(player, objectName(), hps.join("+"), QVariant("hp")).toInt();
            if (room->askForChoice(player, objectName(), "rennai_gain+rennai_lose", QVariant("hp+" + QString::number(targetHp))) == "rennai_gain"){
                foreach(ServerPlayer *p, room->getAlivePlayers()){
                    if (p->getHp() == targetHp){
                        p->gainMark("@Frozen_Eu"); 
                    }
                }
            }
            else{
                foreach(ServerPlayer *p, room->getAlivePlayers()){
                    if (p->getHp() == targetHp){
                        p->loseMark("@Frozen_Eu");
                    }
                }
            }
        }
        else{
            QStringList handcardnums;
            foreach(ServerPlayer *p, room->getAlivePlayers()){
                if (!handcardnums.contains(QString::number(p->getHandcardNum()))){
                    handcardnums.append(QString::number(p->getHandcardNum()));
                }
            }
            int targetHandcardnum = room->askForChoice(player, objectName(), handcardnums.join("+"), QVariant("handcardnum")).toInt();
            if (room->askForChoice(player, objectName(), "rennai_gain+rennai_lose", QVariant("handcardnum+" + QString::number(targetHandcardnum))) == "rennai_gain"){
                foreach(ServerPlayer *p, room->getAlivePlayers()){
                    if (p->getHandcardNum() == targetHandcardnum){
                        p->gainMark("@Frozen_Eu");
                    }
                }
            }
            else{
                foreach(ServerPlayer *p, room->getAlivePlayers()){
                    if (p->getHandcardNum() == targetHandcardnum){
                        p->loseMark("@Frozen_Eu");
                    }
                }
            }
        }
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == DamageInflicted){
            DamageStruct damage = data.value<DamageStruct>();
            if (damage.to->hasSkill(objectName()) && damage.to->getMark("@Patience") == 0){
                room->loseHp(damage.to);
                room->doLightbox(objectName() + "$", 800);
                damage.to->gainMark("@Patience");
                calcFreeze(room, damage.to);
                return true;
            }
            else if (damage.to->hasSkill(objectName()) && damage.to->getMark("@Patience") > 0){
                if (damage.from){
                    LogMessage log;
                    log.type = "#rennai_effect";
                    log.arg = damage.from->getGeneralName();
                    room->sendLog(log);
                    calcFreeze(room, damage.to);
                }
                else if (damage.card){
                    LogMessage log;
                    log.type = "#rennai_effect";
                    log.arg = damage.card->getClassName();
                    room->sendLog(log);
                    calcFreeze(room, damage.to);
                }
                
                return true;
            }
        }
        else if (triggerEvent == PreHpLost && TriggerSkill::triggerable(player)){
            if (player->hasSkill(objectName()) && player->getMark("@Patience") > 0){
                LogMessage log;
                log.type = "#rennai_effect2";
                room->sendLog(log);
                calcFreeze(room, player);
                return true;
            }
        }
        else if (triggerEvent == EventPhaseStart && player->getPhase() == Player::RoundStart){
            player->loseAllMarks("@Patience");
        }
        else if (triggerEvent == EventLoseSkill && TriggerSkill::triggerable(player)){
            if (data.toString() == objectName()){
                foreach(ServerPlayer *p, room->getAlivePlayers()){
                    p->loseAllMarks("@Frozen_Eu");
                }
            }
        }
        else if (triggerEvent == Death){
            DeathStruct death = data.value<DeathStruct>();
            if (death.who->hasSkill(objectName())){
                foreach(ServerPlayer *p, room->getAlivePlayers()){
                    p->loseAllMarks("@Frozen_Eu");
                }
            }
        }
        return false;
    }
};

class Zhanfang : public TriggerSkill
{
public:
    Zhanfang() : TriggerSkill("zhanfang")
    {
        frequency = NotFrequent;
        events << PreCardUsed << CardFinished << TrickCardCanceling << SlashProceed;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *, QVariant &data) const
    {
        if (triggerEvent == PreCardUsed){
            CardUseStruct use = data.value<CardUseStruct>();
            if (use.from->hasSkill(objectName())) {
                
                if (use.card->isKindOf("Collateral") || use.card->isKindOf("EquipCard") || use.card->isKindOf("DelayedTrick")){
                    return false;
                }
                if (use.to.count() != 1){
                    return false;
                }
                ServerPlayer *target = use.to.first();
                
                if (target->getMark("@Frozen_Eu") > 0 && room->askForSkillInvoke(use.from, objectName(), data)){
                    use.to.clear();
                    foreach(ServerPlayer *p, room->getAlivePlayers()){
                        if (p->getMark("@Frozen_Eu") > 0){
                            use.to.append(p);
                        }
                    }
                    use.card->setFlags("zhanfang_card");
                    room->doLightbox(objectName() + "$", 800);
                    data = QVariant::fromValue(use);
                }
            }
            

        }
        else if (triggerEvent == CardFinished){
            CardUseStruct use = data.value<CardUseStruct>();
            if (use.card->hasFlag("zhanfang_card")){
                foreach(ServerPlayer *p, use.to){
                    if (p->getEquips().count() > 0 && room->askForChoice(p, objectName(), "zhanfang_discard+cancel", data) == "zhanfang_discard"){
                        room->throwCard(room->askForCardChosen(p, p, "e", objectName()), p);
                        p->loseMark("@Frozen_Eu");
                    }
                }
            }
        }
        else if (triggerEvent == TrickCardCanceling){
            CardEffectStruct effect = data.value<CardEffectStruct>();
            if (effect.from && effect.from->hasSkill(objectName()) && effect.to && effect.to->getMark("@Frozen_Eu") > 0){
                LogMessage log;
                log.type = "#zhanfang_effect";
                log.from = effect.to;
                log.arg = effect.card->objectName();
                room->sendLog(log);
                room->broadcastSkillInvoke(objectName());
                return true;
            }
        }
        else if (triggerEvent == SlashProceed){
            SlashEffectStruct effect = data.value<SlashEffectStruct>();
            if (effect.from && effect.from->hasSkill(objectName()) && effect.to && effect.to->getMark("@Frozen_Eu") > 0){
                LogMessage log;
                log.type = "#zhanfang_effect";
                log.from = effect.to;
                log.arg = effect.slash->objectName();
                room->sendLog(log);
                room->broadcastSkillInvoke(objectName(), 5);
                room->slashResult(effect, NULL);
                return true;
            }
        }
        return false;
    }
};

class Huajian : public TriggerSkill
{
public:
    Huajian() : TriggerSkill("huajian")
    {
        frequency = NotFrequent;
        events << Death << CardsMoveOneTime << CardUsed;
        global = true;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == Death){
            DeathStruct death = data.value<DeathStruct>();
            if (death.who == player && player->hasSkill(objectName())){
                int num = -1;
                for (int i = 219; i < 250; i++){
                    if (Sanguosha->getCard(i)->objectName() == "GreenRose"){
                        num = i;
                    }
                }
                if (num == -1){
                    num = 56;
                }
                if (room->getTag("huajian_used").toBool() || !room->askForSkillInvoke(player, objectName(), data)){
                    return false;
                }
                ServerPlayer *dest = room->askForPlayerChosen(player, room->getOtherPlayers(player), objectName());
                room->doLightbox(objectName() + "$", 3000);
                if (dest->getWeapon()){
                    room->obtainCard(dest, dest->getWeapon());
                }
                
                CardsMoveStruct move;
                move.card_ids.append(num);
                move.to = dest;
                move.to_place = Player::PlaceEquip;
                move.reason.m_reason = CardMoveReason::S_REASON_RECYCLE;
                room->moveCardsAtomic(move, true);
                room->setTag("huajian_target", dest->objectName());
                room->setTag("huajian_used", QVariant(true));
            }
        }
        else if (triggerEvent == CardsMoveOneTime){

            CardsMoveOneTimeStruct move = data.value<CardsMoveOneTimeStruct>();
            if (!move.from || move.from->objectName() != room->getTag("huajian_target").toString()){
                return false;
            }
            if (move.from_places.contains(Player::PlaceEquip) || move.to_place == Player::DiscardPile){
                foreach(int id, move.card_ids){
                    if (Sanguosha->getCard(id)->objectName() == "GreenRose"){
                        foreach(ServerPlayer *p, room->getAlivePlayers()){
                            if (p->objectName() == room->getTag("huajian_target").toString()){
                                room->obtainCard(p, id);
                                return false;
                            }
                        }
                        
                    }
                }
            }
        }
        else if (triggerEvent == CardUsed){
            CardUseStruct use = data.value<CardUseStruct>();
            if (use.from->objectName() != room->getTag("huajian_target").toString() || !use.card){
                return false;
            }
            
            foreach(int id, use.card->getSubcards()){
                if (Sanguosha->getCard(id)->objectName() == "GreenRose"){
                    foreach(ServerPlayer *p, room->getAlivePlayers()){
                        if (p->objectName() == room->getTag("huajian_target").toString()){
                            room->obtainCard(p, id);
                            return false;
                        }
                    }
                }
            }
        }

        return false;
    }
};

//k1
class Guiyin : public TriggerSkill
{
public:
    Guiyin() : TriggerSkill("guiyin")
    {
        frequency = Compulsory;
        events << Damaged << EventPhaseStart << EventPhaseEnd << TargetConfirmed << EventLoseSkill << Death;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == Damaged){
            DamageStruct damage = data.value<DamageStruct>();
            if (damage.from && damage.from != player && !player->hasFlag("guiyin2_sound_used")){
                room->broadcastSkillInvoke(objectName(), 2);
                player->setFlags("guiyin2_sound_used");
            }
            damage.from->gainMark("@Oni");
            damage.to->gainMark("OniLv");
        }
        
        else if (triggerEvent == EventPhaseStart){
            if (player->hasSkill(objectName()) && player->getPhase() == Player::Finish && player->getMark("OniLv") > 2){
                room->broadcastSkillInvoke(objectName(), 3);
                foreach(ServerPlayer *p, room->getOtherPlayers(player)){
                    if (p->inMyAttackRange(player)){
                        p->gainMark("@Oni");
                        player->gainMark("OniLv");
                    }
                }
            }
        }
        else if (triggerEvent == EventPhaseEnd){
            if (player->hasSkill(objectName()) && player->getPhase() == Player::Play && player->getMark("OniLv") > 4){
                room->broadcastSkillInvoke(objectName(), 4);
                room->doLightbox(objectName() + "$", 2000);
                foreach(ServerPlayer *p, room->getAlivePlayers()){
                    if (p->getMark("@Oni") > 0){
                        room->damage(DamageStruct(objectName(), player, p, p->getMark("@Oni") > 2 ? (p == player ? 1 : 2) : p->getMark("@Oni")));
                        p->loseAllMarks("@Oni");
                    }
                }
                foreach(ServerPlayer *p, room->getOtherPlayers(player)){
                    bool hasHeart = false;
                    QList<int> hearts;
                    foreach(const Card *card, p->getHandcards()){
                        if (card->getSuit() == Card::Heart){
                            hasHeart = true;
                            hearts.append(card->getEffectiveId());
                        }
                    }
                    foreach(const Card *card, p->getEquips()){
                        if (card->getSuit() == Card::Heart){
                            hasHeart = true;
                            hearts.append(card->getEffectiveId());
                        }
                    }
                    if (!hasHeart){
                        continue;
                    }
                    // has heart
                    if (room->askForChoice(p, objectName(), "guiyin_give+cancel", data) == "guiyin_give"){
                        room->fillAG(hearts, p);
                        int card_id = room->askForAG(p, hearts, true, objectName());
                        room->clearAG(p);
                        if (card_id != -1){
                            room->obtainCard(player, card_id);
                            room->broadcastSkillInvoke(objectName(), 5);
                            room->doLightbox(objectName() + "_detach$", 3000);
                            room->detachSkillFromPlayer(player, objectName());
                            room->acquireSkill(player, "qiubang");
                            room->acquireSkill(player, "youshui");
                            break;
                        }
                    }
                }
            }
        }
        else if (triggerEvent == TargetConfirmed){
            CardUseStruct use = data.value<CardUseStruct>();
            if (use.to.contains(player) && use.from && use.card && !use.card->isKindOf("SkillCard")){
                use.from->gainMark("@Oni");
                player->gainMark("OniLv");
                if (use.from != player && !player->hasFlag("guiyin1_sound_used")){
                    room->broadcastSkillInvoke(objectName(), 1);
                    player->setFlags("guiyin1_sound_used");
                }
            }
        }
        return false;
    }
};

class GuiyinDis : public DistanceSkill
{
public:
    GuiyinDis() : DistanceSkill("#guiyin")
    {
    }

    int getCorrect(const Player *from, const Player *) const
    {
        if (from->hasSkill("guiyin") && from->getMark("OniLv") > 0)
            return -2;
        return 0;
    }
};



class Qiubang : public TriggerSkill
{
public:
    Qiubang() : TriggerSkill("qiubang")
    {
        frequency = NotFrequent;
        events << TargetConfirmed;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
         if (triggerEvent == TargetConfirmed){
            CardUseStruct use = data.value<CardUseStruct>();
            if (use.to.count() == 1 && use.to.first()->objectName() == player->objectName() && player->isAlive() && use.from && use.from != player && use.card && use.card->isBlack() && !use.card->isKindOf("SkillCard") && room->askForSkillInvoke(player, objectName(), data)){
                room->broadcastSkillInvoke(objectName());
                int used = player->tag["QiubangUsed"].toInt();
                player->drawCards(used - 3 > 3 ? 3 : (used - 3 < 1 ? 1 : used - 3));
                player->tag["QiubangUsed"] = QVariant(player->tag["QiubangUsed"].toInt() + 1);
                const Card *card = use.card;
                use.card = Sanguosha->cloneCard("duel", card->getSuit(), card->getNumber(), card->getFlags());
                data.setValue(use);
            }
        }
        return false;
    }
};

class QiubangDis : public DistanceSkill
{
public:
    QiubangDis() : DistanceSkill("#qiubang")
    {
    }

    int getCorrect(const Player *from, const Player *) const
    {
        if (from->hasSkill("qiubang"))
            return -2;
        return 0;
    }
};



YoushuiCard::YoushuiCard()
{
    will_throw = false;
}

bool YoushuiCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *) const
{
    return to_select->hasFlag("youshui_target") && targets.length() == 0;
}

void YoushuiCard::use(Room *room, ServerPlayer *, QList<ServerPlayer *> &targets) const
{
    ServerPlayer *target = targets.at(0);
    if (!target)
        return;
    target->tag["youshuiNum"] = QVariant::fromValue(this->subcardsLength());
    room->obtainCard(target, this, false);
}

class YoushuiVS : public ViewAsSkill
{
public:
    YoushuiVS() : ViewAsSkill("youshui")
    {
        response_pattern = "@@youshui";
    }

    bool viewFilter(const QList<const Card *> &, const Card *) const
    {
        return true;
    }

    const Card *viewAs(const QList<const Card *> &cards) const
    {
        if (cards.isEmpty())
            return NULL;
        YoushuiCard *ysc = new YoushuiCard();
        ysc->addSubcards(cards);
        return ysc;
    }
};

class Youshui : public TriggerSkill
{
public:
    Youshui() : TriggerSkill("youshui")
    {
        frequency = NotFrequent;
        events << EnterDying << QuitDying;
        view_as_skill = new YoushuiVS;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *, QVariant &data) const
    {
        if (triggerEvent == EnterDying){
            DyingStruct dying = data.value<DyingStruct>();
            if (dying.damage && dying.who && dying.damage->card && (dying.damage->card->isKindOf("Slash") || dying.damage->card->isKindOf("Duel"))){
                ServerPlayer *k1 = room->findPlayerBySkillName(objectName());
                if (!k1 || k1->isDead() || k1->objectName() == dying.who->objectName()){
                    return false;
                }
                // give card
                room->setPlayerFlag(dying.who, "youshui_target");
                room->askForUseCard(k1, "@@youshui", "@youshui-use");
                room->setPlayerFlag(dying.who, "-youshui_target");
            }
        }
        else if (triggerEvent == QuitDying){
            DyingStruct dying = data.value<DyingStruct>();
            if (dying.damage && dying.damage->card && (dying.damage->card->isKindOf("Slash") || dying.damage->card->isKindOf("Duel"))){
                if (dying.who->isAlive() && dying.who->tag["youshuiNum"].toInt() > 0){
                    ServerPlayer *k1 = room->findPlayerBySkillName(objectName());
                    if (!k1 || k1->isDead()){
                        return false;
                    }
                    int num = dying.who->tag["youshuiNum"].toInt() * 2;
                    for (int i = 0; i < num; i++){
                        if (!dying.who->isNude()){
                            room->obtainCard(k1, room->askForCardChosen(dying.who, dying.who, "he", objectName()));
                        }
                    }
                    dying.who->tag["youshuiNum"] = QVariant(0);
                }
                
            }
        }
        return false;
    }
};

// yuri
class Zuozhan : public TriggerSkill
{
public:
    Zuozhan() : TriggerSkill("zuozhan")
    {
        frequency = NotFrequent;
        events << EventPhaseStart << EventPhaseChanging;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == EventPhaseStart){
            if (player->getPhase() == Player::Start){
                ServerPlayer * yuri = room->findPlayerBySkillName(objectName());
                if (!yuri || (yuri->getHp() > player->getHp() && !player->hasClub("@amclub_sss")) || !room->askForSkillInvoke(yuri, objectName(), data))
                    return false;
                room->broadcastSkillInvoke(objectName());
                if (player->hasClub("@amclub_sss"))
                    room->doLightbox(objectName() + "$", 800);
                QStringList choices;
                choices << "1_Zuozhan" << "2_Zuozhan" << "3_Zuozhan" << "4_Zuozhan";
                QString choice1 = room->askForChoice(yuri, "zuozhan1%from:" + player->objectName(), choices.join("+"));
                choices.removeAll(choice1);
                QString choice2 = room->askForChoice(yuri, "zuozhan2%from:" + player->objectName(), choices.join("+"));
                choices.removeAll(choice2);
                QString choice3 = room->askForChoice(yuri, "zuozhan3%from:" + player->objectName(), choices.join("+"));
                choices.removeAll(choice3);
                QString choice4 = choices.first();
                QStringList result;
                result << choice1 << choice2 << choice3 << choice4;
                
                player->tag["zuozhan_tag"] = QVariant(result);
            }
            else if (player->getPhase() == Player::Finish){
                player->tag["zuozhan_tag"].clear();
            }
        }
        else if (triggerEvent == EventPhaseChanging){
            QStringList result = player->tag["zuozhan_tag"].toStringList();
            if (result.count() == 0){
                return false;
            }
            PhaseChangeStruct change = data.value<PhaseChangeStruct>();
            if (change.to == Player::NotActive){
                player->tag["zuozhan_tag"].clear();
                return false;
            }
            QString next = result.first();
            if (next == "1_Zuozhan"){
                change.to = Player::Judge;
            }
            else if (next == "2_Zuozhan"){
                change.to = Player::Draw;
            }
            else if (next == "3_Zuozhan"){
                change.to = Player::Play;
            }
            else if (next == "4_Zuozhan"){
                change.to = Player::Discard;
            }
            else if (next == "0_Zuozhan"){
                change.to = Player::Finish;
            }
            data.setValue(change);
            result.removeAt(0);
            if (result.count() == 0 && next != "0_Zuozhan"){
                result.append("0_Zuozhan");
            }
            player->tag["zuozhan_tag"] = QVariant(result);
        }
        return false;
    }
};



class Nishen : public TriggerSkill
{
public:
    Nishen() : TriggerSkill("nishen")
    {
        frequency = NotFrequent;
        events << GameStart << EventAcquireSkill << EventLoseSkill << Death << EnterDying;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == GameStart){
            if (player->hasSkill(objectName()))
                player->addClub("@amclub_sss");
        }
        else if (triggerEvent == EventAcquireSkill){
            if (player->hasSkill(objectName())){
                player->addClub("@amclub_sss");
            }
        }
        else if (triggerEvent == EventLoseSkill){
            if (data.toString() == objectName()){
                room->clearClub("@amclub_sss");
            }
        }
        else if (triggerEvent == Death){
            DeathStruct death = data.value<DeathStruct>();
            if (death.who->hasClub("@amclub_sss") && death.who == player){
                room->setTag("no_reward_or_punish", QVariant(death.who->objectName()));
                foreach(ServerPlayer *p, room->getPlayersByClub("@amclub_sss")){
                    if (p->getLostHp() > 0){
                        if (room->askForChoice(p, objectName(), "draw+recover", data) == "draw"){
                            p->drawCards(2);
                        }
                        else{
                            room->recover(p, RecoverStruct(death.who));
                        }
                    }
                    else{
                        p->drawCards(2);
                    }
                }
            }
            if (death.who->hasSkill(objectName())){
                room->clearClub("@amclub_sss");
            }
        }
        else if (triggerEvent == EnterDying){
            DyingStruct dying = data.value<DyingStruct>();
            if (!dying.who->hasSkill(objectName())){
                ServerPlayer *yuri = room->findPlayerBySkillName(objectName());
                if (!yuri || !yuri->isAlive() || dying.who->hasClub()){
                    return false;
                }
                QStringList used = yuri->tag["sss_targets"].toStringList();
                if (used.contains(dying.who->objectName())){
                    return false;
                }
                if (room->askForSkillInvoke(yuri, objectName(), data)){
                    room->broadcastSkillInvoke(objectName());
                    if (room->askForChoice(dying.who, "nishen", "nishen_accept+cancel", QVariant::fromValue(yuri)) == "nishen_accept"){
                        dying.who->addClub("@amclub_sss");
                    }
                    QStringList used = yuri->tag["sss_targets"].toStringList();
                    used.append(dying.who->objectName());
                    yuri->tag["sss_targets"] = used;
                }
                
            }
        }
        return false;
    }
};

class Mengxian : public TriggerSkill
{
public:
    Mengxian() : TriggerSkill("mengxian")
    {
        frequency = Frequent;
        events << EventPhaseStart << FinishJudge;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == EventPhaseStart){
            if (player->getPhase() == Player::Draw){
                while (player->askForSkillInvoke(objectName(), data)){
                    QString equip = (player->isKongcheng() ? "" : "+equip");
                    QString choice = room->askForChoice(player, objectName(), "basic+trick" + equip);
                    if (choice == "equip"){
                        room->throwCard(room->askForCardChosen(player, player, "h", objectName()), player, player);
                    }
                    JudgeStruct judge;
                    judge.who = player;
                    judge.negative = false;
                    judge.play_animation = false;
                    judge.time_consuming = true;
                    judge.reason = objectName();
                    judge.pattern = choice == "equip" ? "EquipCard" : (choice == "trick" ? "TrickCard" : "BasicCard");
                    room->judge(judge);
                    if ((judge.card->isKindOf("BasicCard") && choice == "basic") || (judge.card->isKindOf("TrickCard") && choice == "trick") || (judge.card->isKindOf("EquipCard") && choice == "equip")){
                        if (judge.card->isKindOf("BasicCard"))
                            room->broadcastSkillInvoke(objectName(), 1);
                        else if (judge.card->isKindOf("TrickCard"))
                            room->broadcastSkillInvoke(objectName(), 2);
                        else
                            room->broadcastSkillInvoke(objectName(), 3);
                        room->doLightbox(objectName() + "$", 500);
                        break;
                    }
                        
                    
                }
            }
            
        }
        else if (triggerEvent == FinishJudge){
            JudgeStruct *judge = data.value<JudgeStruct *>();
            if (judge->reason == objectName())
                player->obtainCard(judge->card);
                return true;
        }
        return false;
    }
};

HayatePackage::HayatePackage()
    : Package("hayate")
{
    General *hei = new General(this, "hei", "science", 4);
    skills << new Jiesha << new LonelinessInvalidity << new Gaokang << new Qiubang << new QiubangDis << new Youshui;
    hei->addSkill(new Yingdi);
    hei->addSkill(new Diansuo);
    hei->addWakeTypeSkillForAudio("jiesha");

    General * diarmuid = new General(this, "diarmuid", "magic", 4);
    diarmuid->addSkill(new Pomo);
    diarmuid->addSkill(new Bimie);

    General *tsukushi = new General(this, "tsukushi", "real", 3, false);
    tsukushi->addSkill(new Gangqu);
    tsukushi->addSkill(new Tiaojiao);

    General *sheryl = new General(this, "sheryl", "diva", 3, false);
    sheryl->addSkill(new Yaojing);
    sheryl->addSkill(new YaojingMaxCards);
    sheryl->addSkill(new Gongming);
    related_skills.insertMulti("yaojing", "#yaojing");

    General *sugisaki = new General(this, "sugisaki", "real", 3);
    sugisaki->addSkill(new Kurimu);
    sugisaki->addSkill(new Minatsu);
    sugisaki->addSkill(new Chizuru);
    sugisaki->addSkill(new Mafuyu);
    sugisaki->addSkill(new Haremu);
    sugisaki->addSkill(new HaremuMaxCards);
    related_skills.insertMulti("haremu", "#haremu");

    General *eugeo = new General(this, "eugeo", "science", 3);
    eugeo->addSkill(new Rennai);
    eugeo->addSkill(new Zhanfang);
    eugeo->addSkill(new Huajian);

    General *k1 = new General(this, "k1", "real", 4);
    k1->addSkill(new Guiyin);
    k1->addSkill(new GuiyinDis);
    related_skills.insertMulti("guiyin", "#guiyin");
    related_skills.insertMulti("qiubang", "#qiubang");
    k1->addWakeTypeSkillForAudio("qiubang");
    k1->addWakeTypeSkillForAudio("youshui");

    General *yuri = new General(this, "yuri", "real", 3, false);
    yuri->addSkill(new Zuozhan);
    yuri->addSkill(new Nishen);

    General *haruhi = new General(this, "haruhi", "real", 3, false);
    haruhi->addSkill(new Mengxian);

    addMetaObject<TiaojiaoCard>();
    addMetaObject<HaremuCard>();
    addMetaObject<YoushuiCard>();

}

ADD_PACKAGE(Hayate)