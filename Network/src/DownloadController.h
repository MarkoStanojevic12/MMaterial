#pragma once

#include <QObject>
#include <QString>
#include <QUrl>

#include <QAbstractListModel>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QtQmlIntegration>
#include <QTimer>

class Download : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_UNCREATABLE("Cannot create a Download object directly. Use the DownloadController instead.");

public:
    explicit Download(const QUrl &url, QObject *parent = nullptr, const QString &location = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation));
    ~Download();

    enum Status { Downloading = 0, Paused, Finished, Error, Retrying, Idle };
    Q_ENUM(Status);

    QString folderName() const;
    QString fileName() const;
    QString fileFullName() const;
    QUrl url() const;
    qint64 bytesDownloaded() const;
    qint64 totalBytes() const;
    int progress() const;

    void start();
    void pause();

    QString bytesToHumanReadable(qint64 bytes);

    Status status() const;
    void setStatus(Status newStatus);

    QString totalSize();
    QString downloadedSize();

signals:
    void progressMade(qint64 bytesReceived, qint64 bytesTotal);
    void finished();
    void error(QNetworkReply::NetworkError error, const QString &errorString);

    void statusChanged();

private slots:
    void onProgressMade(qint64 bytesReceived, qint64 bytesTotal);
    void onReadyRead();
    void onFinished();
    void onError(QNetworkReply::NetworkError error);
    void onErrorFinished(QNetworkReply::NetworkError error, const QString &errorString);

    void onStallTimeout();
    void onRetryTimeout();

private:
    void armStallWatchdog();
    void disarmStallWatchdog();
    void scheduleRetry(const QString &reasonForLog = {});
    void stopRetry();
    void resetRetryState();
    bool canRetry() const;

private:
    QUrl m_url;
    QString m_location;
    QString m_fileName;
    QString m_fileFullName;
    qint64 m_bytesDownloaded = 0;
    qint64 m_bytesDownloadedInitial = 0;
    qint64 m_totalBytes = 0;
    Status m_status = Idle;

    QNetworkAccessManager m_networkManager;
    QFile *m_file = nullptr;
    QNetworkReply *m_reply = nullptr;

    // Retry / stall detection
    QTimer m_stallTimer;
    QTimer m_retryTimer;
    int m_retryAttempts = 0;
    static constexpr int kStallTimeoutMs = 15'000;
    static constexpr int kRetryIntervalMs = 15'000;
    static constexpr int kMaxRetryAttempts = 20;
};

class DownloadModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(bool isRunning READ isRunning NOTIFY isRunningChanged FINAL)
public:
    explicit DownloadModel(QObject *parent = nullptr);

    enum Roles { UrlRole = Qt::UserRole + 1, FileNameRole, FileFullNameRole, ProgressRole, StatusRole, TotalSizeRole, DownloadedSizeRole };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    QHash<int, QByteArray> roleNames() const override;

    bool isRunning() const;

    Q_INVOKABLE Download *addDownload(const QUrl &url);
    Q_INVOKABLE Download *addDownload(const QUrl &url, const QString &location);

    Q_INVOKABLE void startDownload(int index);
    Q_INVOKABLE void pauseDownload(int index);
    Q_INVOKABLE void removeDownload(int index);
    Q_INVOKABLE void pauseRunning();

private slots:
    void onDownloadUpdated();
    void onDownloadError(QNetworkReply::NetworkError error, const QString &errorString);

private:
    QList<Download *> m_downloads;

signals:
    void error(const QString &errorString);
    void isRunningChanged();
};
