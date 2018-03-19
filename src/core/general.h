#ifndef _GENERAL_H
#define _GENERAL_H

class Skill;
class TriggerSkill;
class Package;
class QSize;

class General : public QObject
{
    Q_OBJECT
    Q_ENUMS(Gender)
    Q_PROPERTY(QString kingdom READ getKingdom)
    Q_PROPERTY(int maxhp READ getMaxHp)
    Q_PROPERTY(int heg_max_hp)
    Q_PROPERTY(bool male READ isMale STORED false CONSTANT)
    Q_PROPERTY(bool female READ isFemale STORED false CONSTANT)
    Q_PROPERTY(Gender gender READ getGender CONSTANT)
    Q_PROPERTY(bool lord READ isLord CONSTANT)
    Q_PROPERTY(bool hidden READ isHidden CONSTANT)

public:
    explicit General(Package *package, const QString &name, const QString &kingdom,
        int max_hp = 4, bool male = true, bool hidden = false, bool never_shown = false, int heg_max_hp = -1);

    // property getters/setters
    int getMaxHp() const;
    QString getKingdom() const;
    bool isMale() const;
    bool isFemale() const;
    bool isNeuter() const;
    bool isLord() const;
    bool isHidden() const;
    bool isTotallyHidden() const;

    enum Gender
    {
        Sexless, Male, Female, Neuter
    };
    Gender getGender() const;
    void setGender(Gender gender);

    void addSkill(Skill *skill);
    void addSkill(const QString &skill_name);
    void addWakeTypeSkillForAudio(const QString &skill_name);
    void addHegSkill(Skill *skill);
    void addHegSkill(const QString &skill_name);
    void addHegWakeTypeSkillForAudio(const QString &skill_name);
    bool hasSkill(const QString &skill_name) const;
    QList<const Skill *> getSkillList() const;
    QList<const Skill *> getVisibleSkillList() const;
    QList<const Skill *> getWakedSkillList() const;
    QSet<const Skill *> getVisibleSkills() const;
    QSet<const TriggerSkill *> getTriggerSkills() const;

    void addRelateSkill(const QString &skill_name);
    QStringList getRelatedSkillNames() const;
    QStringList getWakeTypeSkillNamesForAudio() const;

    QString getPackage() const;
    QString getSkillDescription(bool include_name = false) const;
    QString getBriefName() const;

    inline QSet<QString> getExtraSkillSet() const
    {
        return extra_set;
    }

public slots:
    void lastWord() const;

private:
    QString kingdom;
    int max_hp;
    int heg_max_hp;
    Gender gender;
    bool lord;
    QSet<QString> extra_set;
    QStringList skillname_list;
    QStringList related_skills;
    QStringList wake_type_skills;
    QStringList hegemony_skillname_list;
    QStringList hegemony_wake_type_skills;
    bool hidden;
    bool never_shown;
};

#endif

