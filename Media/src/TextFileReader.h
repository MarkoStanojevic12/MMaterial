#pragma once

#include <QObject>
#include <QUrl>
#include <qqmlintegration.h>

class TextFileReader : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit TextFileReader(QObject *parent = nullptr);

    Q_INVOKABLE QString readText(const QUrl &url) const;
};
