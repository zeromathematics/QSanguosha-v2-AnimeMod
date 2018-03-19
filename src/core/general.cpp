#include "general.h"
#include "engine.h"
#include "skill.h"
#include "package.h"
#include "client.h"
#include "clientstruct.h"
#include "gamerule.h"

General::General(Package *package, const QString &name, const QString &kingdom,
    int max_hp, bool male, bool hidden, bool never_shown, int heg_max_hp)
    : QObject(package), kingdom(kingdom), max_hp(max_hp), gender(male ? Male : Female),
    hidden(hidden), never_shown(never_shown), heg_max_hp(heg_max_hp >= 0 ? heg_max_hp : max_hp)
{
    static QChar lord_symbol('$');
    if (name.endsWith(lord_symbol)) {
        QString copy = name;
        copy.remove(lord_symbol);
        lord = true;
        setObjectName(copy);
    } else {
        lord = false;
        setObjectName(name);
    }
}

int General::getMaxHp() const
{
    if (ServerInfo.EnableHegemony){
        return heg_max_hp;
    }
    return max_hp;
}

QString General::getKingdom() const
{
    if (ServerInfo.EnableHegemony){
        return BasaraMode::getMappedAiKingdom(kingdom);
    }
    return kingdom;
}

bool General::isMale() const
{
    return gender == Male;
}

bool General::isFemale() const
{
    return gender == Female;
}

bool General::isNeuter() const
{
    return gender == Neuter;
}

void General::setGender(Gender gender)
{
    this->gender = gender;
}

General::Gender General::getGender() const
{
    return gender;
}

bool General::isLord() const
{
    return lord;
}

bool General::isHidden() const
{
    return hidden;
}

bool General::isTotallyHidden() const
{
    return never_shown;
}

void General::addSkill(Skill *skill)
{
    if (!skill) {
        QMessageBox::warning(NULL, "", tr("Invalid skill added to general %1").arg(objectName()));
        return;
    }
    if (!skillname_list.contains(skill->objectName())) {
        skill->setParent(this);
        skillname_list << skill->objectName();
        hegemony_skillname_list << skill->objectName();
    }
}

void General::addSkill(const QString &skill_name)
{
    if (!skillname_list.contains(skill_name)) {
        extra_set.insert(skill_name);
        skillname_list << skill_name;
        hegemony_skillname_list << skill_name;
    }
}

void General::addWakeTypeSkillForAudio(const QString &skill_name)
{
    if (!wake_type_skills.contains(skill_name)) {
        extra_set.insert(skill_name);
        wake_type_skills << skill_name;
        hegemony_wake_type_skills << skill_name;
    }
}

void General::addHegSkill(Skill *skill)
{
    if (!skill) {
        QMessageBox::warning(NULL, "", tr("Invalid hegemony skill added to general %1").arg(objectName()));
        return;
    }
    if (!hegemony_skillname_list.contains(skill->objectName())) {
        skill->setParent(this);
        hegemony_skillname_list << skill->objectName();
    }
}

void General::addHegSkill(const QString &skill_name)
{
    if (skill_name.startsWith("-")){
        QString real_name = skill_name.mid(1);
        if (hegemony_skillname_list.contains(real_name)) {
            hegemony_skillname_list.removeAll(real_name);
        }
    }
    else{
        if (!hegemony_skillname_list.contains(skill_name)) {
            extra_set.insert(skill_name);
            hegemony_skillname_list << skill_name;
        }
    }
}

void General::addHegWakeTypeSkillForAudio(const QString &skill_name)
{
    if (skill_name.startsWith("-")){
        QString real_name = skill_name.mid(1);
        if (hegemony_wake_type_skills.contains(real_name)) {
            hegemony_wake_type_skills.removeAll(real_name);
        }
    }
    else{
        if (!hegemony_wake_type_skills.contains(skill_name)) {
            extra_set.insert(skill_name);
            hegemony_wake_type_skills << skill_name;
        }
    }
    
}

bool General::hasSkill(const QString &skill_name) const
{
    if (ServerInfo.EnableHegemony){
        return hegemony_skillname_list.contains(skill_name);
    }
    return skillname_list.contains(skill_name);
}

QList<const Skill *> General::getSkillList() const
{
    QList<const Skill *> skills;
    foreach(QString skill_name, ServerInfo.EnableHegemony ? hegemony_skillname_list : skillname_list) {
        if (skill_name == "mashu" && ServerInfo.DuringGame
            && ServerInfo.GameMode == "02_1v1" && ServerInfo.GameRuleMode != "Classical")
            skill_name = "xiaoxi";
        const Skill *skill = Sanguosha->getSkill(skill_name);
        skills << skill;
    }
    return skills;
}

QList<const Skill *> General::getVisibleSkillList() const
{
    QList<const Skill *> skills;
    foreach (const Skill *skill, getSkillList()) {
        if (skill->isVisible())
            skills << skill;
    }

    return skills;
}

QList<const Skill *> General::getWakedSkillList() const
{
    QList<const Skill *> skills;
    foreach(QString skill_name, ServerInfo.EnableHegemony ? hegemony_wake_type_skills : wake_type_skills) {
        if (skill_name == "mashu" && ServerInfo.DuringGame
            && ServerInfo.GameMode == "02_1v1" && ServerInfo.GameRuleMode != "Classical")
            skill_name = "xiaoxi";
        const Skill *skill = Sanguosha->getSkill(skill_name);
        skills << skill;
    }
    return skills;
}

QSet<const Skill *> General::getVisibleSkills() const
{
    return getVisibleSkillList().toSet();
}

QSet<const TriggerSkill *> General::getTriggerSkills() const
{
    QSet<const TriggerSkill *> skills;
    foreach(QString skill_name, ServerInfo.EnableHegemony ? hegemony_skillname_list : skillname_list) {
        const TriggerSkill *skill = Sanguosha->getTriggerSkill(skill_name);
        if (skill)
            skills << skill;
    }
    return skills;
}

void General::addRelateSkill(const QString &skill_name)
{
    related_skills << skill_name;
}

QStringList General::getRelatedSkillNames() const
{
    return related_skills;
}

QStringList General::getWakeTypeSkillNamesForAudio() const
{
    return ServerInfo.EnableHegemony ? hegemony_wake_type_skills : wake_type_skills;
}

QString General::getPackage() const
{
    QObject *p = parent();
    if (p)
        return p->objectName();
    else
        return QString(); // avoid null pointer exception;
}

QString General::getSkillDescription(bool include_name) const
{
    QString description;

    QList<const Skill *> normal_skills = getVisibleSkillList();
    foreach(const Skill *skill, normal_skills) {
        QString skill_name = Sanguosha->translate(skill->objectName());
        QString desc = skill->getDescription();
        desc.replace("\n", "<br/>");
        description.append(QString("<b>%1</b>: %2 <br/> <br/>").arg(skill_name).arg(desc));
    }

    foreach(const Skill *skill, getWakedSkillList()){
        if (normal_skills.contains(skill)){
            continue;
        }
        QString skill_name = Sanguosha->translate(skill->objectName());
        QString desc = skill->getDescription();
        desc.replace("\n", "<br/>");
        description.append(QString("<font color='#bc64a4'><b>%1</b></font><font color='#d3ccd6'>: %2 </font><br/> <br/>").arg(skill_name).arg(desc));
    }

    if (include_name) {
        QString color_str = Sanguosha->getKingdomColor(getKingdom()).name();
        QString name = QString("<font color=%1><b>%2</b></font>     ").arg(color_str).arg(Sanguosha->translate(objectName()));
        name.prepend(QString("<img src='image/kingdom/icon/%1.png'/>    ").arg(getKingdom()));
        for (int i = 0; i < getMaxHp(); i++)
            name.append("<img src='image/system/magatamas/5.png' height = 12/>");

        QString gender("  <img src='image/gender/%1.png' height=17 />");
        if (isMale())
            name.append(gender.arg("male"));
        else if (isFemale())
            name.append(gender.arg("female"));

        name.append("<br/> <br/>");
        description.prepend(name);
    }

    return description;
}

QString General::getBriefName() const
{
    QString name = Sanguosha->translate("&" + objectName());
    if (name.startsWith("&"))
        name = Sanguosha->translate(objectName());

    return name;
}

void General::lastWord() const
{
    QString filename = QString("audio/death/%1.ogg").arg(objectName());
    bool fileExists = QFile::exists(filename);
    if (!fileExists) {
        QStringList origin_generals = objectName().split("_");
        if (origin_generals.length() > 1)
            filename = QString("audio/death/%1.ogg").arg(origin_generals.last());
    }
    Sanguosha->playAudioEffect(filename);
}

