#include "LightIconMap.h"
#include "IconData.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QRegularExpression>
#include <QTextStream>

using namespace Qt::StringLiterals;

LightIconMap::LightIconMap(QObject *parent)
    : QQmlPropertyMap(this, parent)
{}

QUrl LightIconMap::configUrl() const
{
    return m_configUrl;
}

QUrl LightIconMap::normalizeUrl(const QUrl &url)
{
    if (!url.isValid())
        return {};

    if (url.scheme().isEmpty())
        return QUrl::fromLocalFile(url.toString());

    return url;
}

QString LightIconMap::readTextUrl(const QUrl &url)
{
    const QUrl u = normalizeUrl(url);
    if (!u.isValid())
        return {};

    QString path = u.isLocalFile() ? u.toLocalFile() : u.toString();
    if (path.contains("qrc"))
        path.replace("qrc", "");

    QFile f(path);
    if (!f.open(QIODevice::ReadOnly | QIODevice::Text))
        return {};

    QTextStream in(&f);
    in.setEncoding(QStringConverter::Utf8);
    return in.readAll();
}

QUrl LightIconMap::resolveUrl(const QUrl &baseConfigUrl, const QUrl &maybeRelative)
{
    const QUrl u = normalizeUrl(maybeRelative);
    if (!u.isValid())
        return {};

    if (u.isRelative() && baseConfigUrl.isValid()) {
        QUrl base = normalizeUrl(baseConfigUrl);
        // For qrc:/ and file:/ this works with resolved().
        return base.resolved(u);
    }
    return u;
}

QUrl LightIconMap::fontUrl() const
{
    return m_fontUrl;
}

void LightIconMap::setFontUrl(const QUrl &newFontUrl)
{
    if (m_fontUrl == newFontUrl)
        return;
    m_fontUrl = newFontUrl;
    emit fontUrlChanged();
}

void LightIconMap::setConfigUrl(const QUrl &url)
{
    const QUrl n = normalizeUrl(url);
    if (m_configUrl == n && !this->keys().isEmpty())
        return;

    m_configUrl = n;
    emit configUrlChanged();
    reload();
}

QString LightIconMap::glyph(const QString &name) const
{
    const QVariant v = value(name);
    return v.isValid() ? v.toString() : QString{};
}

void LightIconMap::reload()
{
    const auto ks = keys();
    for (const QString &k : ks)
        QQmlPropertyMap::clear(k);

    const auto oldChildren = findChildren<IconData *>(QString{}, Qt::FindDirectChildrenOnly);
    for (IconData *c : oldChildren)
        c->deleteLater();

    m_fontUrl = QUrl();
    emit fontUrlChanged();

    if (!m_configUrl.isValid())
        return;

    const QString cfgText = readTextUrl(m_configUrl);
    const auto doc = QJsonDocument::fromJson(cfgText.toUtf8());
    if (!doc.isObject())
        return;

    const QJsonObject cfg = doc.object();
    const QString prefix = cfg.value("prefix"_L1).toString("icon-"_L1);

    const QUrl font = resolveUrl(m_configUrl, QUrl(cfg.value("font"_L1).toString()));
    if (font.isValid()) {
        m_fontUrl = font;
        emit fontUrlChanged();
    }

    const QUrl cssUrl = resolveUrl(m_configUrl, QUrl(cfg.value("css"_L1).toString()));
    const QString cssText = readTextUrl(cssUrl);
    if (cssText.isEmpty())
        return;

    const QRegularExpression re(uR"(\.)"_s + QRegularExpression::escape(prefix) + uR"(([A-Za-z0-9_\-]+):before\s*\{[^}]*content:\s*["']\\([0-9A-Fa-f]{4,6})["']\s*;[^}]*\})"_s);

    auto it = re.globalMatch(cssText);
    while (it.hasNext()) {
        const auto m = it.next();
        const QString name = m.captured(1);
        const QString hex = m.captured(2);

        bool ok = false;
        const uint code = hex.toUInt(&ok, 16);
        if (!ok || code == 0 || code > 0x10FFFF)
            continue;

        const QString glyph = QString::fromUcs4(&code, 1);

        auto *data = new IconData(this);
        data->setType(IconData::Type::Light);
        data->setPath(glyph);

        insert(name, QVariant::fromValue(static_cast<QObject *>(data)));
    }
}
