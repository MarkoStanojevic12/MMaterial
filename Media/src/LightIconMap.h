#pragma once

#include <QQmlPropertyMap>
#include <QUrl>
#include <qqmlintegration.h>

class LightIconMap : public QQmlPropertyMap
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QUrl configUrl READ configUrl WRITE setConfigUrl NOTIFY configUrlChanged)
    Q_PROPERTY(QUrl fontUrl READ fontUrl WRITE setFontUrl NOTIFY fontUrlChanged FINAL)

public:
    explicit LightIconMap(QObject *parent = nullptr);

    QUrl configUrl() const;
    void setConfigUrl(const QUrl &url);

    Q_INVOKABLE QString glyph(const QString &name) const;
    Q_INVOKABLE QStringList getAllNames() const;

    QUrl fontUrl() const;
    void setFontUrl(const QUrl &newFontUrl);

signals:
    void configUrlChanged();
    void fontUrlChanged();

private:
    void reload();
    static QUrl normalizeUrl(const QUrl &url);
    static QString readTextUrl(const QUrl &url);
    static QUrl resolveUrl(const QUrl &baseConfigUrl, const QUrl &maybeRelative);

    QUrl m_configUrl;
    QUrl m_fontUrl;
};
