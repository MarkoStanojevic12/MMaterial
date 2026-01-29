#pragma once

#include <QObject>
#include <QString>
#include <QtQml/qqml.h>

class IconData : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)
    Q_PROPERTY(Type type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(qreal brightness READ brightness WRITE setBrightness NOTIFY brightnessChanged FINAL)
    Q_PROPERTY(qreal colorization READ colorization WRITE setColorization NOTIFY colorizationChanged FINAL)

public:
    enum class Type { Light = 0, Heavy = 1 };
    Q_ENUM(Type)

    explicit IconData(QObject *parent = nullptr);

    QString path() const;
    void setPath(const QString &path);

    Type type() const;
    void setType(Type t);

    qreal brightness() const;
    void setBrightness(qreal newBrightness);

    qreal colorization() const;
    void setColorization(qreal newColorization);

signals:
    void pathChanged();
    void typeChanged();

    void brightnessChanged();

    void colorizationChanged();

private:
    QString m_path;
    Type m_type = Type::Heavy;

    qreal m_brightness = 0.7;
    qreal m_colorization = 1.0;
};
