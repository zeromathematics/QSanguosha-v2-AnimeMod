#include "inovation.h"
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

//standard
class Yingzi : public DrawCardsSkill
{
public:
    Yingzi() : DrawCardsSkill("yingzi")
    {
        frequency = Compulsory;
    }

    int getDrawNum(ServerPlayer *zhouyu, int n) const
    {
        Room *room = zhouyu->getRoom();

        int index = qrand() % 2 + 1;
        if (!zhouyu->hasInnateSkill(this)) {
            if (zhouyu->hasSkill("hunzi"))
                index = 5;
            else if (zhouyu->hasSkill("mouduan"))
                index += 2;
        }
        room->broadcastSkillInvoke(objectName(), index);
        room->sendCompulsoryTriggerLog(zhouyu, objectName());

        return n + 1;
    }
};

class YingziMaxCards : public MaxCardsSkill
{
public:
    YingziMaxCards() : MaxCardsSkill("#yingzi")
    {
    }

    int getFixed(const Player *target) const
    {
        if (target->hasSkill("yingzi"))
            return target->getMaxHp();
        else
            return -1;
    }
};

class Fankui : public MasochismSkill
{
public:
    Fankui() : MasochismSkill("fankui")
    {
    }

    void onDamaged(ServerPlayer *simayi, const DamageStruct &damage) const
    {
        ServerPlayer *from = damage.from;
        Room *room = simayi->getRoom();
        for (int i = 0; i < damage.damage; i++) {
            QVariant data = QVariant::fromValue(from);
            if (from && !from->isNude() && room->askForSkillInvoke(simayi, "fankui", data)) {
                room->broadcastSkillInvoke(objectName());
                int card_id = room->askForCardChosen(simayi, from, "he", "fankui");
                CardMoveReason reason(CardMoveReason::S_REASON_EXTRACTION, simayi->objectName());
                room->obtainCard(simayi, Sanguosha->getCard(card_id),
                    reason, room->getCardPlace(card_id) != Player::PlaceHand);
            }
            else {
                break;
            }
        }
    }
};

class Guicai : public RetrialSkill
{
public:
    Guicai() : RetrialSkill("guicai")
    {

    }

    const Card *onRetrial(ServerPlayer *player, JudgeStruct *judge) const
    {
        if (player->isNude())
            return NULL;

        QStringList prompt_list;
        prompt_list << "@guicai-card" << judge->who->objectName()
            << objectName() << judge->reason << QString::number(judge->card->getEffectiveId());
        QString prompt = prompt_list.join(":");
        bool forced = false;
        if (player->getMark("JilveEvent") == int(AskForRetrial))
            forced = true;

        Room *room = player->getRoom();

        const Card *card = room->askForCard(player, forced ? "..!" : "..", prompt, QVariant::fromValue(judge), Card::MethodResponse, judge->who, true);
        if (forced && card == NULL) {
            QList<const Card *> c = player->getCards("he");
            card = c.at(qrand() % c.length());
        }

        if (card) {
            if (player->hasInnateSkill("guicai") || !player->hasSkill("jilve"))
                room->broadcastSkillInvoke(objectName());
            else
                room->broadcastSkillInvoke("jilve", 1);
        }

        return card;
    }
};

class Longdan : public OneCardViewAsSkill
{
public:
    Longdan() : OneCardViewAsSkill("longdan")
    {
        response_or_use = true;
    }

    bool viewFilter(const Card *to_select) const
    {
        const Card *card = to_select;

        switch (Sanguosha->currentRoomState()->getCurrentCardUseReason()) {
        case CardUseStruct::CARD_USE_REASON_PLAY: {
            return card->isKindOf("Jink");
        }
        case CardUseStruct::CARD_USE_REASON_RESPONSE:
        case CardUseStruct::CARD_USE_REASON_RESPONSE_USE: {
            QString pattern = Sanguosha->currentRoomState()->getCurrentCardUsePattern();
            if (pattern == "slash")
                return card->isKindOf("Jink");
            else if (pattern == "jink")
                return card->isKindOf("Slash");
        }
        default:
            return false;
        }
    }

    bool isEnabledAtPlay(const Player *player) const
    {
        return Slash::IsAvailable(player);
    }

    bool isEnabledAtResponse(const Player *, const QString &pattern) const
    {
        return pattern == "jink" || pattern == "slash";
    }

    const Card *viewAs(const Card *originalCard) const
    {
        if (originalCard->isKindOf("Slash")) {
            Jink *jink = new Jink(originalCard->getSuit(), originalCard->getNumber());
            jink->addSubcard(originalCard);
            jink->setSkillName(objectName());
            return jink;
        }
        else if (originalCard->isKindOf("Jink")) {
            Slash *slash = new Slash(originalCard->getSuit(), originalCard->getNumber());
            slash->addSubcard(originalCard);
            slash->setSkillName(objectName());
            return slash;
        }
        else
            return NULL;
    }

    int getEffectIndex(const ServerPlayer *player, const Card *) const
    {
        int index = qrand() % 2 + 1;
        if (Player::isNostalGeneral(player, "zhaoyun"))
            index += 2;
        return index;
    }
};

class Paoxiao : public TargetModSkill
{
public:
    Paoxiao() : TargetModSkill("paoxiao")
    {
        frequency = NotCompulsory;
    }

    int getResidueNum(const Player *from, const Card *) const
    {
        if (from->hasSkill(this))
            return 1000;
        else
            return 0;
    }
};

class Wumou : public TriggerSkill
{
public:
    Wumou() : TriggerSkill("wumou")
    {
        frequency = Compulsory;
        events << CardUsed;
    }

    bool trigger(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        CardUseStruct use = data.value<CardUseStruct>();
        if (use.card->isNDTrick()) {
            room->broadcastSkillInvoke(objectName());
            room->sendCompulsoryTriggerLog(player, objectName());

            int num = player->getMark("@wrath");
            if (num >= 1 && room->askForChoice(player, objectName(), "discard+losehp") == "discard") {
                player->loseMark("@wrath");
            }
            else
                room->loseHp(player);
        }

        return false;
    }
};

class Benghuai : public PhaseChangeSkill
{
public:
    Benghuai() : PhaseChangeSkill("benghuai")
    {
        frequency = Compulsory;
    }

    bool onPhaseChange(ServerPlayer *dongzhuo) const
    {
        bool trigger_this = false;
        Room *room = dongzhuo->getRoom();

        if (dongzhuo->getPhase() == Player::Finish) {
            QList<ServerPlayer *> players = room->getOtherPlayers(dongzhuo);
            foreach(ServerPlayer *player, players) {
                if (dongzhuo->getHp() > player->getHp()) {
                    trigger_this = true;
                    break;
                }
            }
        }

        if (trigger_this) {
            room->sendCompulsoryTriggerLog(dongzhuo, objectName());

            QString result = room->askForChoice(dongzhuo, "benghuai", "hp+maxhp");
            int index = (dongzhuo->isFemale()) ? 2 : 1;

            if (!dongzhuo->hasInnateSkill(this) && dongzhuo->getMark("juyi") > 0)
                index = 3;

            if (!dongzhuo->hasInnateSkill(this) && dongzhuo->getMark("baoling") > 0)
                index = result == "hp" ? 4 : 5;

            room->broadcastSkillInvoke(objectName(), index);
            if (result == "hp")
                room->loseHp(dongzhuo);
            else
                room->loseMaxHp(dongzhuo);
        }

        return false;
    }
};

TiaoxinCard::TiaoxinCard()
{
}

bool TiaoxinCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    return targets.isEmpty() && to_select->inMyAttackRange(Self);
}

void TiaoxinCard::onEffect(const CardEffectStruct &effect) const
{
    Room *room = effect.from->getRoom();
    bool use_slash = false;
    if (effect.to->canSlash(effect.from, NULL, false))
        use_slash = room->askForUseSlashTo(effect.to, effect.from, "@tiaoxin-slash:" + effect.from->objectName());
    if (!use_slash && effect.from->canDiscard(effect.to, "he"))
        room->throwCard(room->askForCardChosen(effect.from, effect.to, "he", "tiaoxin", false, Card::MethodDiscard), effect.to, effect.from);
}

class Tiaoxin : public ZeroCardViewAsSkill
{
public:
    Tiaoxin() : ZeroCardViewAsSkill("tiaoxin")
    {
    }

    bool isEnabledAtPlay(const Player *player) const
    {
        return !player->hasUsed("TiaoxinCard");
    }

    const Card *viewAs() const
    {
        return new TiaoxinCard;
    }

    int getEffectIndex(const ServerPlayer *player, const Card *) const
    {
        int index = qrand() % 2 + 1;
        if (!player->hasInnateSkill(this) && player->hasSkill("baobian"))
            index += 3;
        else if (!player->hasInnateSkill(this) && player->getMark("fengliang") > 0)
            index += 5;
        else if (player->hasArmorEffect("eight_diagram"))
            index = 3;
        return index;
    }
};




QString BasicCard::getType() const
{
    return "basic";
}

Card::CardType BasicCard::getTypeId() const
{
    return TypeBasic;
}

TrickCard::TrickCard(Suit suit, int number)
    : Card(suit, number), cancelable(true)
{
    handling_method = Card::MethodUse;
}

void TrickCard::setCancelable(bool cancelable)
{
    this->cancelable = cancelable;
}

QString TrickCard::getType() const
{
    return "trick";
}

Card::CardType TrickCard::getTypeId() const
{
    return TypeTrick;
}

bool TrickCard::isCancelable(const CardEffectStruct &effect) const
{
    Q_UNUSED(effect);
    return cancelable;
}

QString EquipCard::getType() const
{
    return "equip";
}

Card::CardType EquipCard::getTypeId() const
{
    return TypeEquip;
}

bool EquipCard::isAvailable(const Player *player) const
{
    return !player->isProhibited(player, this) && Card::isAvailable(player);
}

void EquipCard::onUse(Room *room, const CardUseStruct &card_use) const
{
    CardUseStruct use = card_use;

    ServerPlayer *player = use.from;
    if (use.to.isEmpty())
        use.to << player;

    QVariant data = QVariant::fromValue(use);
    RoomThread *thread = room->getThread();
    thread->trigger(PreCardUsed, room, player, data);
    thread->trigger(CardUsed, room, player, data);
    thread->trigger(CardFinished, room, player, data);
}

void EquipCard::use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const
{
    if (targets.isEmpty()) {
        CardMoveReason reason(CardMoveReason::S_REASON_USE, source->objectName(), QString(), this->getSkillName(), QString());
        room->moveCardTo(this, NULL, Player::DiscardPile, reason, true);
    }
    int equipped_id = Card::S_UNKNOWN_CARD_ID;
    ServerPlayer *target = targets.first();
    if (target->getEquip(location()))
        equipped_id = target->getEquip(location())->getEffectiveId();

    QList<CardsMoveStruct> exchangeMove;
    CardsMoveStruct move1(getEffectiveId(), target, Player::PlaceEquip,
        CardMoveReason(CardMoveReason::S_REASON_USE, target->objectName()));
    exchangeMove.push_back(move1);
    if (equipped_id != Card::S_UNKNOWN_CARD_ID) {
        CardsMoveStruct move2(equipped_id, NULL, Player::DiscardPile,
            CardMoveReason(CardMoveReason::S_REASON_CHANGE_EQUIP, target->objectName()));
        exchangeMove.push_back(move2);
    }
    LogMessage log;
    log.from = target;
    log.type = "$Install";
    log.card_str = QString::number(getEffectiveId());
    room->sendLog(log);

    room->moveCardsAtomic(exchangeMove, true);
}

static bool isEquipSkillViewAsSkill(const Skill *s)
{
    if (s == NULL)
        return false;

    if (s->inherits("ViewAsSkill"))
        return true;

    if (s->inherits("TriggerSkill")) {
        const TriggerSkill *ts = qobject_cast<const TriggerSkill *>(s);
        if (ts == NULL)
            return false;

        if (ts->getViewAsSkill() != NULL)
            return true;
    }

    return false;
}

void EquipCard::onInstall(ServerPlayer *player) const
{
    const Skill *skill = Sanguosha->getSkill(this);

    if (skill != NULL) {
        Room *room = player->getRoom();
        if (skill->inherits("TriggerSkill")) {
            const TriggerSkill *trigger_skill = qobject_cast<const TriggerSkill *>(skill);
            room->getThread()->addTriggerSkill(trigger_skill);
        }

        if (isEquipSkillViewAsSkill(skill))
            room->attachSkillToPlayer(player, objectName());
    }
}

void EquipCard::onUninstall(ServerPlayer *player) const
{
    const Skill *skill = Sanguosha->getSkill(this);
    if (isEquipSkillViewAsSkill(skill))
        player->getRoom()->detachSkillFromPlayer(player, objectName(), true);
}

QString GlobalEffect::getSubtype() const
{
    return "global_effect";
}

void GlobalEffect::onUse(Room *room, const CardUseStruct &card_use) const
{
    ServerPlayer *source = card_use.from;
    QList<ServerPlayer *> targets, all_players = room->getAllPlayers();
    foreach(ServerPlayer *player, all_players) {
        const ProhibitSkill *skill = room->isProhibited(source, player, this);
        if (skill) {
            if (skill->isVisible()) {
                LogMessage log;
                log.type = "#SkillAvoid";
                log.from = player;
                log.arg = skill->objectName();
                log.arg2 = objectName();
                room->sendLog(log);

                room->broadcastSkillInvoke(skill->objectName());
            }
        }
        else
            targets << player;
    }

    CardUseStruct use = card_use;
    use.to = targets;
    TrickCard::onUse(room, use);
}

bool GlobalEffect::isAvailable(const Player *player) const
{
    bool canUse = false;
    QList<const Player *> players = player->getAliveSiblings();
    players << player;
    foreach(const Player *p, players) {
        if (player->isProhibited(p, this))
            continue;

        canUse = true;
        break;
    }

    return canUse && TrickCard::isAvailable(player);
}

QString AOE::getSubtype() const
{
    return "aoe";
}

bool AOE::isAvailable(const Player *player) const
{
    bool canUse = false;
    QList<const Player *> players = player->getAliveSiblings();
    foreach(const Player *p, players) {
        if (player->isProhibited(p, this))
            continue;

        canUse = true;
        break;
    }

    return canUse && TrickCard::isAvailable(player);
}

void AOE::onUse(Room *room, const CardUseStruct &card_use) const
{
    ServerPlayer *source = card_use.from;
    QList<ServerPlayer *> targets, other_players = room->getOtherPlayers(source);
    foreach(ServerPlayer *player, other_players) {
        const ProhibitSkill *skill = room->isProhibited(source, player, this);
        if (skill) {
            if (skill->isVisible()) {
                LogMessage log;
                log.type = "#SkillAvoid";
                log.from = player;
                log.arg = skill->objectName();
                log.arg2 = objectName();
                room->sendLog(log);

                room->broadcastSkillInvoke(skill->objectName());
            }
        }
        else
            targets << player;
    }

    CardUseStruct use = card_use;
    use.to = targets;
    TrickCard::onUse(room, use);
}

QString SingleTargetTrick::getSubtype() const
{
    return "single_target_trick";
}

bool SingleTargetTrick::targetFilter(const QList<const Player *> &, const Player *, const Player *) const
{
    return true;
}

DelayedTrick::DelayedTrick(Suit suit, int number, bool movable)
    : TrickCard(suit, number), movable(movable)
{
    judge.negative = true;
}

void DelayedTrick::onUse(Room *room, const CardUseStruct &card_use) const
{
    CardUseStruct use = card_use;
    WrappedCard *wrapped = Sanguosha->getWrappedCard(this->getEffectiveId());
    use.card = wrapped;

    QVariant data = QVariant::fromValue(use);
    RoomThread *thread = room->getThread();
    thread->trigger(PreCardUsed, room, use.from, data);
    use = data.value<CardUseStruct>();

    LogMessage log;
    log.from = use.from;
    log.to = use.to;
    log.type = "#UseCard";
    log.card_str = toString();
    room->sendLog(log);

    CardMoveReason reason(CardMoveReason::S_REASON_USE, use.from->objectName(), use.to.first()->objectName(), this->getSkillName(), QString());
    room->moveCardTo(this, use.to.first(), Player::PlaceDelayedTrick, reason, true);

    thread->trigger(CardUsed, room, use.from, data);
    use = data.value<CardUseStruct>();
    thread->trigger(CardFinished, room, use.from, data);
}

void DelayedTrick::use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const
{
    QStringList nullified_list = room->getTag("CardUseNullifiedList").toStringList();
    bool all_nullified = nullified_list.contains("_ALL_TARGETS");
    if (all_nullified || targets.isEmpty()) {
        if (movable) {
            onNullified(source);
            if (room->getCardOwner(getEffectiveId()) != source) return;
        }
        CardMoveReason reason(CardMoveReason::S_REASON_USE, source->objectName(), QString(), this->getSkillName(), QString());
        room->moveCardTo(this, room->getCardOwner(getEffectiveId()), NULL, Player::DiscardPile, reason, true);
    }
}

QString DelayedTrick::getSubtype() const
{
    return "delayed_trick";
}

void DelayedTrick::onEffect(const CardEffectStruct &effect) const
{
    Room *room = effect.to->getRoom();

    CardMoveReason reason(CardMoveReason::S_REASON_USE, effect.to->objectName(), getSkillName(), QString());
    room->moveCardTo(this, NULL, Player::PlaceTable, reason, true);

    LogMessage log;
    log.from = effect.to;
    log.type = "#DelayedTrick";
    log.arg = effect.card->objectName();
    room->sendLog(log);

    JudgeStruct judge_struct = judge;
    judge_struct.who = effect.to;
    room->judge(judge_struct);

    if (judge_struct.isBad()) {
        takeEffect(effect.to);
        if (room->getCardOwner(getEffectiveId()) == NULL) {
            CardMoveReason reason(CardMoveReason::S_REASON_NATURAL_ENTER, QString());
            room->throwCard(this, reason, NULL);
        }
    }
    else if (movable) {
        onNullified(effect.to);
    }
    else {
        if (room->getCardOwner(getEffectiveId()) == NULL) {
            CardMoveReason reason(CardMoveReason::S_REASON_NATURAL_ENTER, QString());
            room->throwCard(this, reason, NULL);
        }
    }
}

void DelayedTrick::onNullified(ServerPlayer *target) const
{
    Room *room = target->getRoom();
    RoomThread *thread = room->getThread();
    if (movable) {
        QList<ServerPlayer *> players = room->getOtherPlayers(target);
        players << target;
        ServerPlayer *p = NULL;

        foreach(ServerPlayer *player, players) {
            if (player->containsTrick(objectName()))
                continue;

            const ProhibitSkill *skill = room->isProhibited(target, player, this);
            if (skill) {
                if (skill->isVisible()) {
                    LogMessage log;
                    log.type = "#SkillAvoid";
                    log.from = player;
                    log.arg = skill->objectName();
                    log.arg2 = objectName();
                    room->sendLog(log);

                    room->broadcastSkillInvoke(skill->objectName());
                }
                continue;
            }

            CardMoveReason reason(CardMoveReason::S_REASON_TRANSFER, target->objectName(), QString(), this->getSkillName(), QString());
            room->moveCardTo(this, target, player, Player::PlaceDelayedTrick, reason, true);

            if (target == player) break;

            CardUseStruct use;
            use.from = NULL;
            use.to << player;
            use.card = this;
            QVariant data = QVariant::fromValue(use);
            thread->trigger(TargetConfirming, room, player, data);
            CardUseStruct new_use = data.value<CardUseStruct>();
            if (new_use.to.isEmpty()) {
                p = player;
                break;
            }

            foreach(ServerPlayer *p, room->getAllPlayers())
                thread->trigger(TargetConfirmed, room, p, data);
            break;
        }
        if (p)
            onNullified(p);
    }
    else {
        CardMoveReason reason(CardMoveReason::S_REASON_NATURAL_ENTER, target->objectName());
        room->throwCard(this, reason, NULL);
    }
}

Weapon::Weapon(Suit suit, int number, int range)
    : EquipCard(suit, number), range(range)
{
    can_recast = true;
}

bool Weapon::isAvailable(const Player *player) const
{
    QString mode = player->getGameMode();
    if (mode == "04_1v3" && !player->isCardLimited(this, Card::MethodRecast))
        return true;
    return !player->isCardLimited(this, Card::MethodUse) && EquipCard::isAvailable(player);
}

int Weapon::getRange() const
{
    return range;
}

QString Weapon::getSubtype() const
{
    return "weapon";
}

void Weapon::onUse(Room *room, const CardUseStruct &card_use) const
{
    CardUseStruct use = card_use;
    ServerPlayer *player = card_use.from;
    if (room->getMode() == "04_1v3"
        && use.card->isKindOf("Weapon")
        && (player->isCardLimited(use.card, Card::MethodUse)
        || (!player->getHandPile().contains(getEffectiveId())
        && player->askForSkillInvoke("weapon_recast", QVariant::fromValue(use))))) {
        CardMoveReason reason(CardMoveReason::S_REASON_RECAST, player->objectName());
        reason.m_eventName = "weapon_recast";
        room->moveCardTo(use.card, player, NULL, Player::DiscardPile, reason);
        player->broadcastSkillInvoke("@recast");

        LogMessage log;
        log.type = "#UseCard_Recast";
        log.from = player;
        log.card_str = use.card->toString();
        room->sendLog(log);

        player->drawCards(1, "weapon_recast");
        return;
    }
    EquipCard::onUse(room, use);
}

EquipCard::Location Weapon::location() const
{
    return WeaponLocation;
}

QString Weapon::getCommonEffectName() const
{
    return "weapon";
}

QString Armor::getSubtype() const
{
    return "armor";
}

EquipCard::Location Armor::location() const
{
    return ArmorLocation;
}

QString Armor::getCommonEffectName() const
{
    return "armor";
}

Horse::Horse(Suit suit, int number, int correct)
    : EquipCard(suit, number), correct(correct)
{
}

int Horse::getCorrect() const
{
    return correct;
}

void Horse::onInstall(ServerPlayer *) const
{
}

void Horse::onUninstall(ServerPlayer *) const
{
}

QString Horse::getCommonEffectName() const
{
    return "horse";
}

OffensiveHorse::OffensiveHorse(Card::Suit suit, int number, int correct)
    : Horse(suit, number, correct)
{
}

QString OffensiveHorse::getSubtype() const
{
    return "offensive_horse";
}

DefensiveHorse::DefensiveHorse(Card::Suit suit, int number, int correct)
    : Horse(suit, number, correct)
{
}

QString DefensiveHorse::getSubtype() const
{
    return "defensive_horse";
}

EquipCard::Location Horse::location() const
{
    if (correct > 0)
        return DefensiveHorseLocation;
    else
        return OffensiveHorseLocation;
}

QString Treasure::getSubtype() const
{
    return "treasure";
}

EquipCard::Location Treasure::location() const
{
    return TreasureLocation;
}

QString Treasure::getCommonEffectName() const
{
    return "treasure";
}

//mapo tofu
MapoTofu::MapoTofu(Card::Suit suit, int number)
    : BasicCard(suit, number)
{
    setObjectName("mapo_tofu");
}

QString MapoTofu::getSubtype() const
{
    return "food_card";
}

bool MapoTofu::IsAvailable(const Player *player, const Card *tofu)
{
    MapoTofu *newanaleptic = new MapoTofu(Card::NoSuit, 0);
    newanaleptic->deleteLater();
#define THIS_TOFU (tofu == NULL ? newanaleptic : tofu)
    if (player->isCardLimited(THIS_TOFU, Card::MethodUse) || player->isProhibited(player, THIS_TOFU))
        return false;

    return player->usedTimes("MapoTofu") <= Sanguosha->correctCardTarget(TargetModSkill::Residue, player, THIS_TOFU);
#undef THIS_ANALEPTIC
}

bool MapoTofu::isAvailable(const Player *player) const
{

    return IsAvailable(player, this) && BasicCard::isAvailable(player);
}

bool MapoTofu::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    return targets.length() == 0 && Self->distanceTo(to_select) <= 1 && to_select->getMark("mtUsed") == 0;
}

void MapoTofu::onUse(Room *room, const CardUseStruct &card_use) const
{
    CardUseStruct use = card_use;
    if (use.to.isEmpty())
        use.to << use.from;
    BasicCard::onUse(room, use);
}

void MapoTofu::use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const
{
    if (targets.isEmpty())
        targets << source;
    BasicCard::use(room, source, targets);
}

void MapoTofu::onEffect(const CardEffectStruct &effect) const
{
    Room *room = effect.to->getRoom();
    //room->setEmotion(effect.to, "mapo_tofu");//TODO

    DamageStruct damage;
    damage.to = effect.to;
    damage.damage = effect.to->getHp() > 0 ? effect.to->getHp() - 1: 0;
    int toDamge = damage.damage;
    damage.chain = false;
    damage.nature = DamageStruct::Fire;
    effect.to->getRoom()->damage(damage);
    LogMessage log;
    log.type = "#MapoTofuUse";
    log.from = effect.from;
    log.to << effect.to;
    log.arg = objectName();
    room->sendLog(log);
    effect.to->setMark("mtUsed", toDamge + 1);
}



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

class Keji : public TriggerSkill
{
public:
    Keji() : TriggerSkill("keji")
    {
        events << PreCardUsed << CardResponded << EventPhaseChanging;
        frequency = Frequent;
        global = true;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *lvmeng, QVariant &data) const
    {
        if (triggerEvent == EventPhaseChanging) {
            bool can_trigger = true;
            if (lvmeng->hasFlag("KejiSlashInPlayPhase")) {
                can_trigger = false;
                lvmeng->setFlags("-KejiSlashInPlayPhase");
            }
            PhaseChangeStruct change = data.value<PhaseChangeStruct>();
            if (change.to == Player::Discard && lvmeng->isAlive() && lvmeng->hasSkill(this)) {
                if (can_trigger && lvmeng->askForSkillInvoke(this)) {
                    if (lvmeng->getHandcardNum() > lvmeng->getMaxCards()) {
                        int index = qrand() % 2 + 1;
                        if (!lvmeng->hasInnateSkill(this) && lvmeng->hasSkill("mouduan"))
                            index += 4;
                        else if (Player::isNostalGeneral(lvmeng, "lvmeng"))
                            index += 2;
                        room->broadcastSkillInvoke(objectName(), index);
                    }
                    lvmeng->skip(Player::Discard);
                }
            }
        }
        else if (lvmeng->getPhase() == Player::Play) {
            const Card *card = NULL;
            if (triggerEvent == PreCardUsed)
                card = data.value<CardUseStruct>().card;
            else
                card = data.value<CardResponseStruct>().m_card;
            if (card->isKindOf("Slash"))
                lvmeng->setFlags("KejiSlashInPlayPhase");
        }

        return false;
    }
};

//akarin
class SE_Touming : public TriggerSkill
{
public:
    SE_Touming() : TriggerSkill("SE_Touming")
    {
        events << EventPhaseStart << EventPhaseEnd;
        frequency = NotFrequent;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *akarin, QVariant &data) const
    {
        if (triggerEvent == EventPhaseStart) {
            if (!akarin->hasSkill(objectName()))
                return false;
            if (akarin->getPhase() == Player::Discard)
                akarin->setMark("SE_Touming_num", akarin->getHandcardNum());
            else if (akarin->getPhase() == Player::RoundStart && akarin->getMark("touming_used") > 0){
                room->removeAkarinEffect(akarin);
                akarin->setMark("touming_used", 0);
            }
        }
        else if (triggerEvent == EventPhaseEnd) 
        {
            if (!akarin->hasSkill(objectName()))
                return false;
            if (akarin->getPhase() == Player::Discard && akarin->getHandcardNum() == akarin->getMark("SE_Touming_num"))
            {
                if (!akarin->askForSkillInvoke(objectName(), data))
                    return false;
                room->broadcastSkillInvoke(objectName());
                room->doLightbox("SE_Touming$", 1500);
                room->akarinPlayer(akarin);
                akarin->setMark("touming_used", 1);
                akarin->drawCards((room->getAlivePlayers().length() + 1)/2);
            }
        }

        return false;
    }
};

class SE_Tuanzi : public TriggerSkill
{
public:
    SE_Tuanzi() : TriggerSkill("SE_Tuanzi")
    {
        events << CardUsed;
        frequency = NotFrequent;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *akarin, QVariant &data) const
    {
        if (triggerEvent == CardUsed) {
            if (akarin->getPhase() == Player::Play)
            {
                CardUseStruct use = data.value<CardUseStruct>();
                if ((use.card->isKindOf("TrickCard") && use.card->isBlack()) || use.card->isKindOf("BasicCard"))
                {
                    if (!akarin->askForSkillInvoke(objectName(), data))
                        return false;
                    room->broadcastSkillInvoke(objectName());
                    QList<int> ids;
                    ids.append(use.card->getEffectiveId());
                    CardsMoveStruct move(ids, NULL, Player::DrawPile,
                        CardMoveReason(CardMoveReason::S_REASON_PUT, akarin->objectName(), objectName(), QString()));
                    room->moveCardsAtomic(move, true);
                }
            }
        }
      
        return false;
    }
};

class Huanxing : public TriggerSkill
{
public:
    Huanxing() : TriggerSkill("huanxing")
    {
        events << CardUsed << EventPhaseEnd << TurnStart << TrickCardCanceling << SlashProceed;
        frequency = NotFrequent;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *nao, QVariant &data) const
    {
        if (triggerEvent == CardUsed) {
            CardUseStruct use = data.value<CardUseStruct>();
            if (use.to.length() == 0 || !use.to.at(0) || use.to.at(0)->getMark("disappear") == 1 || use.from->objectName() == use.to.at(0)->objectName())
                return false;
            if (use.to.length() > 1)
                return false;
            if (!use.to.at(0)->hasSkill(objectName()))
                return false;
            if (!use.to.at(0)->askForSkillInvoke(objectName(), data))
                return false;
            foreach(ServerPlayer* p, room->getAlivePlayers()){
                if (p->getMark("@huanxing_target") > 0){
                    p->loseMark("@huanxing_target");
                    room->removeAkarinEffect(use.to.at(0), p);
                }
            }
            use.from->gainMark("@huanxing_target");
            room->broadcastSkillInvoke(objectName(), rand() % 4 + 1);
            room->doLightbox("huanxing$", 300);
            room->akarinPlayer(use.to.at(0), use.from);
            use.to.at(0)->setMark("disappear", 1);
            return true;
        }
        else if (triggerEvent == EventPhaseEnd) {
            if (!nao || !nao->hasSkill(objectName()) || nao->getPhase() != Player::Finish)
                return false;
            foreach(ServerPlayer* p, room->getAlivePlayers()){
                if (p->getMark("@huanxing_target") > 0){
                    p->loseMark("@huanxing_target");
                    room->removeAkarinEffect(nao, p);
                }
            }

        }
        else if (triggerEvent == TurnStart) {
            if (!nao || !nao->hasSkill(objectName()))
                return false;
            nao->setMark("disappear", 0);

        }
        else if (triggerEvent == TrickCardCanceling) {
            CardEffectStruct effect = data.value<CardEffectStruct>();
            if (effect.from && effect.from->hasSkill(objectName()) && effect.to && effect.to->getMark("@huanxing_target") == 1){
                LogMessage log;
                log.type = "#huanxing_effect";
                log.from = effect.to;
                log.arg = effect.card->objectName();
                room->sendLog(log);
                room->broadcastSkillInvoke(objectName(), 6);
                return true;
            }
        }
        else if (triggerEvent == SlashProceed) {
            SlashEffectStruct effect = data.value<SlashEffectStruct>();
            if (effect.from && effect.from->hasSkill(objectName()) && effect.to && effect.to->getMark("@huanxing_target") == 1){
                LogMessage log;
                log.type = "#huanxing_effect";
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
    bool triggerable(const ServerPlayer *target) const
    {
        return target != NULL;
    }
};

class Fushang : public TriggerSkill
{
public:
    Fushang() : TriggerSkill("fushang")
    {
        events << Damaged << EventPhaseStart;
        frequency = NotFrequent;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == Damaged) {
            DamageStruct damage = data.value<DamageStruct>();
            if (!damage.to || damage.to->isDead()){
                return false;
            }
            ServerPlayer *nao = room->findPlayerBySkillName(objectName());
            if (!nao || !nao->askForSkillInvoke(objectName(), data))
                return false;
            room->broadcastSkillInvoke(objectName());
            damage.to->gainMark("@fushang");
            damage.to->gainMark("@fushang_time", 2 - damage.to->getMark("@fushang_time"));
            return false;
        }
        else if (triggerEvent == EventPhaseStart) {
            if (player->getPhase() == Player::RoundStart){
                if (player->getMark("@fushang_time") > 0){
                    player->loseMark("@fushang_time");
                    if (player->getMark("@fushang_time") == 0){
                        room->broadcastSkillInvoke(objectName(), 1);
                        room->recover(player, RecoverStruct(player, NULL, player->getMark("@fushang")));
                        player->loseAllMarks("@fushang");
                    }
                }
            }
        }
        return false;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target != NULL;
    }
};

KeyTrick::KeyTrick(Card::Suit suit, int number)
    : DelayedTrick(suit, number)
{
    setObjectName("key_trick");
    mute = true;
    handling_method = Card::MethodNone;
}

bool KeyTrick::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *) const
{
    if (!targets.isEmpty() || to_select->containsTrick(objectName()))
        return false;
    return true;
}

void KeyTrick::takeEffect(ServerPlayer *) const
{
}

void KeyTrick::onEffect(const CardEffectStruct &) const
{
}

void KeyTrick::onNullified(ServerPlayer *) const
{
}

void KeyTrick::onUse(Room *room, const CardUseStruct &card_use) const
{
    DelayedTrick::onUse(room, card_use);
}


class GuangyuViewAsSkill : public OneCardViewAsSkill
{
public:
    GuangyuViewAsSkill() : OneCardViewAsSkill("guangyu")
    {
        response_pattern = "@@guangyu";
    }

    bool viewFilter(const Card *to_select) const
    {
        QStringList guangyu = Self->property("guangyu").toString().split("+");
        foreach(QString id, guangyu) {
            bool ok;
            if (id.toInt(&ok) == to_select->getEffectiveId() && ok)
                return true;
        }
        return false;
    }

    const Card *viewAs(const Card *originalCard) const
    {
        KeyTrick *gy = new KeyTrick(originalCard->getSuit(), originalCard->getNumber());
        gy->addSubcard(originalCard);
        gy->setSkillName("guangyu");
        return gy;
    }
};

class Guangyu : public TriggerSkill
{
public:
    Guangyu() : TriggerSkill("guangyu")
    {
        events << BeforeCardsMove;
        view_as_skill = new GuangyuViewAsSkill;
    }

    bool trigger(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        CardsMoveOneTimeStruct move = data.value<CardsMoveOneTimeStruct>();
        if (move.from != player)
            return false;
        if (move.to_place == Player::DiscardPile
            && ((move.reason.m_reason & CardMoveReason::S_MASK_BASIC_REASON) == CardMoveReason::S_REASON_DISCARD)) {

            int i = 0;
            QList<int> guangyu_card;
            foreach(int card_id, move.card_ids) {
                const Card *c = Sanguosha->getCard(card_id);
                if (room->getCardOwner(card_id) == move.from && c->isRed()) {
                    guangyu_card << card_id;
                }
                i++;
            }
            if (guangyu_card.isEmpty())
                return false;

            room->setPlayerProperty(player, "guangyu", IntList2StringList(guangyu_card).join("+"));
            if (room->getTag("nagisa_voice").isNull())
                room->setTag("nagisa_voice", QVariant(1));
            int num = room->getTag("nagisa_voice").toInt();

            do {
                if (!room->askForUseCard(player, "@@guangyu", "@guangyu-use")) break;
                if (num > 40)
                    room->broadcastSkillInvoke(objectName(), 40);
                else
                    room->broadcastSkillInvoke(objectName(), num);
                num++;
                QList<int> ids = StringList2IntList(player->property("guangyu").toString().split("+"));
                QList<int> to_remove;
                foreach(int card_id, guangyu_card) {
                    if (!ids.contains(card_id))
                        to_remove << card_id;
                }
                move.removeCardIds(to_remove);
                data = QVariant::fromValue(move);
                guangyu_card = ids;
            } while (!guangyu_card.isEmpty());
            room->setTag("nagisa_voice", QVariant(num));
        }
        return false;
    }
};

class GuangyuTrigger : public TriggerSkill
{
public:
    GuangyuTrigger() : TriggerSkill("#guangyu-trigger")
    {
        events << EventPhaseStart << PreCardUsed;
        frequency = NotFrequent;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == EventPhaseStart) {
            if (!player || player->getPhase() != Player::Judge || player->getJudgingArea().length() == 0)
                return false;
            foreach(const Card* card, player->getJudgingArea()){
                if (card->isKindOf("KeyTrick")){
                    ServerPlayer *nagisa = room->findPlayerBySkillName("guangyu");
                    if (!nagisa || !nagisa->askForSkillInvoke("guangyu", data))
                        return false;
                    int num = room->getTag("nagisa_voice").toInt();
                    if (num > 40)
                        room->broadcastSkillInvoke(objectName(), rand()%9 + 31);
                    else
                        room->broadcastSkillInvoke(objectName(), num);
                    num++;
                    room->setTag("nagisa_voice", QVariant(num));
                    room->doLightbox("guangyu$", 800);
                    foreach(const Card* card, player->getJudgingArea()){
                        player->obtainCard(card);
                    }
                    return false;
                }
            }
        }
        else if (triggerEvent == PreCardUsed) {
            CardUseStruct use = data.value<CardUseStruct>();
            if (use.card->isKindOf("KeyTrick") && use.card->getSkillName() == "guangyu") {
                QList<int> ids = StringList2IntList(player->property("guangyu").toString().split("+"));
                ids.removeOne(use.card->getEffectiveId());
                room->setPlayerProperty(player, "guangyu", IntList2StringList(ids).join("+"));
            }
            return false;
        }
        return false;
    }
    bool triggerable(const ServerPlayer *target) const
    {
        return target != NULL;
    }
};

class Xiyuan : public TriggerSkill
{
public:
    Xiyuan() : TriggerSkill("xiyuan")
    {
        events << Death;
        frequency = NotFrequent;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == Death) {
            DeathStruct death = data.value<DeathStruct>();

            if (death.who != player)
                return false;
            if (!death.who->hasSkill(objectName()) || room->getOtherPlayers(death.who).length() == 0)
                return false;
            if (room->getTag("xiyuan_used").toBool() || !death.who->askForSkillInvoke(objectName(), data))
                return false;
            ServerPlayer *tomoya = room->askForPlayerChosen(death.who, room->getOtherPlayers(death.who), objectName());
            room->broadcastSkillInvoke(objectName());
            room->doLightbox("xiyuan$", 3000);
            room->changeHero(tomoya, "Ushio", false, true, true, true);
            LogMessage log;
            log.type = "#XiyuanChangeHero";
            log.from = death.who;
            log.to << tomoya;
            log.arg = objectName();
            room->sendLog(log);
            room->setTag("xiyuan_used", QVariant(true));
        }
        return false;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target != NULL && target->hasSkill(this);
    }
};

class Dingxin : public TriggerSkill
{
public:
    Dingxin() : TriggerSkill("dingxin")
    {
        events << EventPhaseStart << Dying;
        frequency = Compulsory;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == EventPhaseStart) {
            if (!player || player->getPhase() != Player::RoundStart || !player->hasSkill(objectName()))
                return false;
            if (room->getTag("nagisa_voice").isNull())
                room->setTag("nagisa_voice", QVariant(1));
            if (player->getHp() > 1){
                int num = room->getTag("nagisa_voice").toInt();
                if (num > 16)
                    room->broadcastSkillInvoke(objectName(), rand() % 5 + 12);
                else
                    room->broadcastSkillInvoke(objectName(), num);
                room->setTag("nagisa_voice", QVariant(num + 1));
            }
            
            player->setFlags("dingxin_used");
            room->loseHp(player);
            player->setFlags("-dingxin_used");
        }
        else if (triggerEvent == Dying) {
            DyingStruct dying = data.value<DyingStruct>();
            if (!dying.who->hasSkill(objectName()) || !dying.who->hasFlag("dingxin_used"))
                return false;
            ServerPlayer *nagisa;
            foreach(ServerPlayer *p, room->getPlayers()){
                if ((p->getGeneralName() == "Nagisa" || (p->getGeneral2() && p->getGeneral2Name() == "Nagisa")) && p->isDead()){
                    nagisa = p;
                    break;
                }
            }
            QString choice;
            if (nagisa && nagisa->isDead()){
                choice = room->askForChoice(dying.who, objectName(), "dingxin_recover+dingxin_revive", data);
            }
            else{
                choice = "dingxin_recover";
            }
            if (choice == "dingxin_recover"){
                room->broadcastSkillInvoke(objectName(), rand()%2 + 17);
                room->doLightbox("dingxin$", 2000);
                room->recover(dying.who, RecoverStruct(dying.who, NULL, 3));
                LogMessage log;
                log.type = "#DingxinRecover";
                log.from = dying.who;
                room->sendLog(log);
            }
            else{
                room->broadcastSkillInvoke(objectName(), 19);
                room->doLightbox("dingxin$", 2000);
                room->revivePlayer(nagisa, true);
                room->setPlayerProperty(nagisa, "hp", QVariant(2));
                nagisa->drawCards(2);
                LogMessage log;
                log.type = "#DingxinRevive";
                log.from = dying.who;
                log.to << nagisa;
                room->sendLog(log);
            }
            return false;
        }
        return false;
    }
};

//Dark Sakura
class Xushu : public TriggerSkill
{
public:
    Xushu() : TriggerSkill("xushu")
    {
        frequency = Compulsory;
        events << Predamage << EventPhaseStart;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == Predamage){
            DamageStruct damage = data.value<DamageStruct>();
            if (damage.from->hasSkill(objectName()) || damage.to->hasSkill(objectName())) {
                if (damage.from->hasSkill(objectName(), 1)){
                    if (damage.reason != "shengjian_black")
                        room->broadcastSkillInvoke(objectName());
                    room->sendCompulsoryTriggerLog(damage.from, objectName());
                }   
                else{
                    if (damage.to->getHp() > 4)
                        room->broadcastSkillInvoke(objectName(), 2);
                    room->sendCompulsoryTriggerLog(damage.to, objectName());
                }  
                room->loseHp(damage.to, damage.damage);

                return true;
            }
        }
        else if (triggerEvent == EventPhaseStart){
            if (!player->hasSkill(objectName()) || player->getPhase() != Player::RoundStart)
                return false;
            room->loseHp(room->askForPlayerChosen(player, room->getOtherPlayers(player), objectName()));
            room->broadcastSkillInvoke(objectName(), rand()%2 + 3);
        }
        
        return false;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target != NULL;
    }
};

//xishou
class Xishou : public TriggerSkill
{
public:
    Xishou() : TriggerSkill("xishou")
    {
        frequency = Frequent;
        events << Dying;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == Dying){
            DyingStruct dying = data.value<DyingStruct>();
            ServerPlayer *sakura = room->findPlayerBySkillName(objectName());
            if (!sakura || dying.who == sakura || !player->hasSkill(objectName()))
                return false;
            QList<const Skill *> list = dying.who->getVisibleSkillList();
            QString choices = "";
            int len = list.length();
            int i = 0;
            foreach(const Skill *skill, list){
                if (!sakura->hasSkill(skill))
                    choices += skill->objectName();
                i++;
                if (len != i && !sakura->hasSkill(skill)){
                    choices += "+";
                }
            }
            if (choices == "" || !sakura->askForSkillInvoke(objectName(), data))
                return false;
            
            QString choice = room->askForChoice(sakura, objectName(), choices, data);
            room->broadcastSkillInvoke(objectName());
            if (!sakura->hasSkill(choice))
                room->acquireSkill(sakura, choice);
            room->recover(sakura, RecoverStruct(sakura));
        }

        return false;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target != NULL;
    }
};

//shengbei
//Dark Sakura
class Shengbei : public TriggerSkill
{
public:
    Shengbei() : TriggerSkill("shengbei")
    {
        frequency = Compulsory;
        events << DrawNCards << TurnStart;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == DrawNCards){
            if (player->hasSkill(objectName())){
                data.setValue(data.toInt() + 3);
            }
        }
        else if (triggerEvent == TurnStart){
            if (player->hasSkill(objectName())){
                bool do_voice = true;
                if (!player->faceUp()){
                    room->broadcastSkillInvoke(objectName());
                    player->turnOver();
                    do_voice = false;
                }
                if (player->getJudgingArea().length() > 0){
                    foreach(const Card* card, player->getJudgingArea()){
                        room->throwCard(card, player);
                    }
                    if (do_voice)
                        room->broadcastSkillInvoke(objectName());
                }
            }
        }
        return false;
    }
};

class ShengbeiMaxCards : public MaxCardsSkill
{
public:
    ShengbeiMaxCards() : MaxCardsSkill("#shengbei")
    {
    }

    int getFixed(const Player *target) const
    {
        if (target->hasSkill("shengbei"))
            return target->getHp() + 3;
        else
            return -1;
    }
};

//caoying
class Caoying : public TriggerSkill
{
public:
    Caoying() : TriggerSkill("caoying")
    {
        frequency = Frequent;
        events << TargetConfirmed << HpLost;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == TargetConfirmed){
            CardUseStruct use = data.value<CardUseStruct>();
            foreach(ServerPlayer *p, use.to){
                if (p->hasSkill(objectName()) && p == player && !use.from->hasSkill(objectName())){
                    use.from->gainMark("@kage");
                }
            }
        }
        else if (triggerEvent == HpLost){
            if (player->getMark("@kage") == 0)
                return false;
            ServerPlayer *sakura = room->findPlayerBySkillName(objectName());
            if (!sakura)
                return false;
            if (sakura->askForSkillInvoke(objectName(), data)){
                room->broadcastSkillInvoke(objectName());
                for (int i = 0; i < player->getMark("@kage"); i++){
                    if (!player->isNude()){
                        room->throwCard(room->askForCardChosen(sakura, player, "he", objectName()), player, sakura);
                    }
                    else{
                        break;
                    }
                }
                player->loseAllMarks("@kage");
            }
        }

        return false;
    }

    bool triggerable(const ServerPlayer *target) const
    {
        return target != NULL;
    }
};

class ShengjianBlack : public TriggerSkill
{
public:
    ShengjianBlack() : TriggerSkill("shengjian_black")
    {
        frequency = Frequent;
        events << HpLost;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == HpLost){
            if (player->hasSkill(objectName()) && player->askForSkillInvoke(objectName(), data)){
                ServerPlayer *p = room->askForPlayerChosen(player, room->getOtherPlayers(player), objectName());
                if (!p)
                    return false;
                room->broadcastSkillInvoke(objectName());
                DamageStruct damage;
                damage.from = player;
                damage.to = p;
                damage.reason = "shengjian_black";
                damage.damage = abs(player->getEquips().length() - p->getEquips().length());
                room->damage(damage);
                foreach(const Card* card, p->getEquips()){
                    room->throwCard(card, p, player);
                }
            }
        }
        return false;
    }
};


class Fengbi : public TriggerSkill
{
public:
    Fengbi() : TriggerSkill("fengbi")
    {
        frequency = Compulsory;
        events << NonTrigger;
    }

    bool trigger(TriggerEvent , Room *, ServerPlayer *, QVariant &) const
    {
        return false;
    }
};

//chuangzao
class Chuangzao : public TriggerSkill
{
public:
    Chuangzao() : TriggerSkill("chuangzao")
    {
        frequency = Frequent;
        events << CardUsed << EventPhaseStart;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == CardUsed){
            CardUseStruct use = data.value<CardUseStruct>();
            if (!use.card || !use.card->isKindOf("TrickCard") || !use.from || !use.from->hasSkill(objectName()))
                return false;
            if (use.from->getMark("@Chuangzao_trick_used") == 0)
                use.from->gainMark("@Chuangzao_trick_used");
        }
        else if (triggerEvent == EventPhaseStart){
            if (player->getPhase() == Player::Discard){
                if (player->getMark("@Chuangzao_trick_used") == 0){
                    if (!player->askForSkillInvoke(objectName(), data))
                        return false;
                    player->drawCards(1);
                    int id = room->askForCardChosen(player, player, "he", objectName(), true);
                    if (id == -1)
                        return false;
                    player->addToPile("music", id, true);
                }
                else{
                    player->loseAllMarks("@Chuangzao_trick_used");
                }
            }
        }
        return false;
    }
};

QidaoCard::QidaoCard()
{
}

bool QidaoCard::targetFilter(const QList<const Player *> &targets, const Player *, const Player *) const
{
    return targets.length() == 0;
}

void QidaoCard::use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const
{
    ServerPlayer *target = targets.at(0);
    if (!target)
        return;
    int id = room->askForCardChosen(source, target, "h", "qidao");
    room->showCard(target, id);
    const Card *card = Sanguosha->getCard(id);
    CardUseStruct use;
    Slash *slash = new Slash(Card::NoSuit, 0);
    switch (card->getSuit())
    {
    case Card::Spade:
        use.from = source;
        use.to.append(target);
        use.card = slash;
        room->useCard(use, false);
        break;
    case Card::Heart:
        room->recover(source, RecoverStruct(source));
        break;
    case Card::Diamond:
        source->drawCards(2);
        break;
    case Card::Club:
        room->askForDiscard(target, objectName(), 2, 2, false, true);
        break;
    default:
        break;
    }
}
class Qidao : public OneCardViewAsSkill
{
public:
    Qidao() : OneCardViewAsSkill("qidao"){

    }

    bool viewFilter(const Card *) const
    {
        return true;
    }

    const Card *viewAs(const Card *originalCard) const
    {
        QidaoCard *qdc = new QidaoCard();
        qdc->addSubcard(originalCard);
        qdc->setSkillName("qidao");
        return qdc;
    }

    bool isEnabledAtPlay(const Player *player) const
    {
        return !player->hasUsed("QidaoCard");
    }
};

class Benpao : public TriggerSkill
{
public:
    Benpao() : TriggerSkill("benpao")
    {
        frequency = Wake;
        events << EventPhaseStart << EventPhaseChanging;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == EventPhaseStart){
            if (player->getMark("@waked") == 1 || !player->hasSkill(objectName()))
                return false;
            if (player->getPile("music").length() < 3)
                return false;
            player->drawCards(room->getAlivePlayers().length());
            player->acquireSkill("guangmang");
            player->acquireSkill("shuohuang");
            player->setMark("benpao_turn", 1);
        }
        else if (triggerEvent == EventPhaseChanging){
            PhaseChangeStruct change = data.value<PhaseChangeStruct>();
            if (change.to == Player::NotActive && player->getMark("benpao_turn") == 1){
                player->setMark("benpao_turn", 0);
                player->gainAnExtraTurn();
            }
        }
        return false;
    }
};

class Guangmang : public TriggerSkill
{
public:
    Guangmang() : TriggerSkill("guangmang")
    {
        frequency = NotFrequent;
        events << EventPhaseStart;
    }

    bool trigger(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
    {
        if (triggerEvent == EventPhaseStart){
            if (player->getPile("music").length() == 0 || !player->askForSkillInvoke(objectName(), data))
                return false;
            ServerPlayer *target = room->askForPlayerChosen(player, room->getOtherPlayers(player), objectName());
            if (!target)
                return false;
            QVariant newdata;
            newdata.setValue(target);
            QString choice = room->askForChoice(player, objectName(), "guangmang_hp+guangmang_handcards", newdata);
            if (choice == "guangmang_hp")
                room->setPlayerProperty(target, "hp", player->getHp());
            else{
                if (target->getHandcardNum() > player->getHandcardNum())
                    room->askForDiscard(target, objectName(), target->getHandcardNum() - player->getHandcardNum(), target->getHandcardNum() - player->getHandcardNum());
                else
                    target->drawCards(player->getHandcardNum() - target->getHandcardNum());
            }
        }
        return false;
    }
};

ShuohuangCard::ShuohuangCard()
{
}

bool ShuohuangCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    return targets.length() == 0 && (to_select->getWeapon() || (to_select->getArmor() && to_select != Self));
}

void ShuohuangCard::use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const
{
    ServerPlayer *target = targets.at(0);
    if (!target)
        return;
    QString choice;
    if (target->getWeapon() && target->getArmor() && target != source){
        QVariant newdata;
        newdata.setValue(target);
        choice = room->askForChoice(source, objectName(), "shuohuang_weapon+shuohuang_armor", newdata);
    }
    else if (target->getWeapon()){
        choice = "shuohuang_weapon";
    }
    if (choice == "shuohuang_weapon"){
        room->throwCard(target->getWeapon(), target, source);
        source->drawCards(1);
    }
    else{
        if (source->getArmor())
            room->throwCard(source->getArmor(), source, source);
        CardsMoveStruct move;
        move.card_ids.append(target->getArmor()->getEffectiveId());
        move.from = target;
        move.to = source;
        move.from_place = Player::PlaceEquip;
        move.to_place = Player::PlaceEquip;
        move.reason = CardMoveReason(CardMoveReason::S_REASON_CHANGE_EQUIP, source->objectName());
        room->moveCardsAtomic(move, true);
    }
}

class Shuohuang : public OneCardViewAsSkill
{
public:
    Shuohuang() : OneCardViewAsSkill("shuohuang"){

    }

    bool viewFilter(const Card *to_select) const
    {
        return to_select->isKindOf("BasicCard");
    }

    const Card *viewAs(const Card *originalCard) const
    {
        ShuohuangCard *shc = new ShuohuangCard();
        shc->addSubcard(originalCard);
        shc->setSkillName("shuohuang");
        return shc;
    }

    bool isEnabledAtPlay(const Player *player) const
    {
        return !player->hasUsed("ShuohuangCard");
    }
};

InovationPackage::InovationPackage()
    : Package("inovation")
{
    patterns["."] = new ExpPattern(".|.|.|hand");
    patterns[".S"] = new ExpPattern(".|spade|.|hand");
    patterns[".C"] = new ExpPattern(".|club|.|hand");
    patterns[".H"] = new ExpPattern(".|heart|.|hand");
    patterns[".D"] = new ExpPattern(".|diamond|.|hand");

    patterns[".black"] = new ExpPattern(".|black|.|hand");
    patterns[".red"] = new ExpPattern(".|red|.|hand");

    patterns[".."] = new ExpPattern(".");
    patterns["..S"] = new ExpPattern(".|spade");
    patterns["..C"] = new ExpPattern(".|club");
    patterns["..H"] = new ExpPattern(".|heart");
    patterns["..D"] = new ExpPattern(".|diamond");

    patterns[".Basic"] = new ExpPattern("BasicCard");
    patterns[".Trick"] = new ExpPattern("TrickCard");
    patterns[".Equip"] = new ExpPattern("EquipCard");

    patterns[".Weapon"] = new ExpPattern("Weapon");
    patterns["slash"] = new ExpPattern("Slash");
    patterns["jink"] = new ExpPattern("Jink");
    patterns["peach"] = new  ExpPattern("Peach");
    patterns["nullification"] = new ExpPattern("Nullification");
    patterns["peach+analeptic"] = new ExpPattern("Peach,Analeptic");


    skills << new Keji << new Yingzi << new Paoxiao << new Tiaoxin << new Fankui << new Longdan << new Guicai << new Wumou << new Benghuai << new Fengbi;
    General *nagisa = new General(this, "Nagisa", "real", 3, false);
    nagisa->addSkill(new Guangyu);
    nagisa->addSkill(new GuangyuTrigger);
    nagisa->addSkill(new Xiyuan);
    related_skills.insertMulti("guangyu", "#guangyu-trigger");

    General *ushio = new General(this, "Ushio", "real", 3, false, true);
    ushio->addSkill(new Dingxin);

    General *akarin = new General(this, "Akarin", "real", 3, false); 
    akarin->addSkill(new SE_Touming);
    akarin->addSkill(new SE_Tuanzi);
    General *nao = new General(this, "Nao", "science", 3, false);
    nao->addSkill(new Huanxing);
    nao->addSkill(new Fushang);

    General *sakura = new General(this, "DarkSakura1", "magic", 8, false, true);
    sakura->addSkill(new Xushu);
    sakura->addSkill(new Xishou);

    General *sakura2 = new General(this, "DarkSakura2", "magic", 4, false, true);
    sakura2->addSkill("xushu");
    sakura2->addSkill("xishou");
    sakura2->addSkill(new Shengbei);
    sakura2->addSkill(new ShengbeiMaxCards);
    related_skills.insertMulti("shengbei", "#shengbei");
    sakura2->addSkill(new Caoying);
    sakura2->addSkill(new ShengjianBlack);

    General *kaori = new General(this, "Kaori", "real", 3, false);
    kaori->addSkill(new Chuangzao);
    kaori->addSkill(new Qidao);
    kaori->addSkill(new Benpao);
    skills << new Guangmang << new Shuohuang;
    kaori->addWakeTypeSkillForAudio("guangmang");
    kaori->addWakeTypeSkillForAudio("shuohuang");

    QList<Card *> cards;
    cards << new KeyTrick(Card::Heart, 10)
        << new KeyTrick(Card::Heart, 4)
        << new MapoTofu(Card::Spade, 1);

    foreach(Card *card, cards)
        card->setParent(this);

    addMetaObject<YinshenCard>();
    addMetaObject<QidaoCard>();
    addMetaObject<ShuohuangCard>();
}

ADD_PACKAGE(Inovation)

