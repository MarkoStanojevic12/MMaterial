#include "TextFileReader.h"

#include <QFile>
#include <QFileInfo>
#include <QTextStream>

TextFileReader::TextFileReader(QObject *parent)
    : QObject(parent)
{}

QString TextFileReader::readText(const QUrl &url) const
{
    QUrl effective = url;

    // Allow passing plain paths from QML/JSON; treat them as local files.
    if (effective.isValid() && effective.scheme().isEmpty())
        effective = QUrl::fromLocalFile(effective.toString());

    const QString path = effective.isLocalFile() ? effective.toLocalFile() : effective.toString();

    QFile f(path);
    if (!f.open(QIODevice::ReadOnly | QIODevice::Text))
        return {};

    QTextStream in(&f);
    in.setEncoding(QStringConverter::Utf8);
    return in.readAll();
}
