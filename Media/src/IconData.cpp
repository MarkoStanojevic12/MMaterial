#include "IconData.h"

IconData::IconData(QObject *parent)
    : QObject(parent)
{}

QString IconData::path() const
{
    return m_path;
}

void IconData::setPath(const QString &path)
{
    if (m_path == path)
        return;
    m_path = path;
    emit pathChanged();
}

IconData::Type IconData::type() const
{
    return m_type;
}

void IconData::setType(Type t)
{
    if (m_type == t)
        return;
    m_type = t;
    emit typeChanged();
}

qreal IconData::brightness() const
{
    return m_brightness;
}

void IconData::setBrightness(qreal newBrightness)
{
    if (qFuzzyCompare(m_brightness, newBrightness))
        return;
    m_brightness = newBrightness;
    emit brightnessChanged();
}

qreal IconData::colorization() const
{
    return m_colorization;
}

void IconData::setColorization(qreal newColorization)
{
    if (qFuzzyCompare(m_colorization, newColorization))
        return;
    m_colorization = newColorization;
    emit colorizationChanged();
}
