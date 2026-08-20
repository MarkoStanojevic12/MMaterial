#pragma once

#include <QAbstractListModel>
#include <QDateTime>
#include <QVariantMap>
#include <qqmlintegration.h>

class NotificationCenter : public QAbstractListModel
{
	Q_OBJECT
	QML_ELEMENT
	QML_SINGLETON
	Q_PROPERTY(int count READ count NOTIFY countChanged)
	Q_PROPERTY(int unreadCount READ unreadCount NOTIFY unreadCountChanged)
	Q_PROPERTY(int maxEntries READ maxEntries WRITE setMaxEntries NOTIFY maxEntriesChanged)
	Q_PROPERTY(int severityFilter READ severityFilter WRITE setSeverityFilter NOTIFY severityFilterChanged)
	Q_PROPERTY(QVariantList severities READ severities NOTIFY severitiesChanged)

public:
	enum Role {
		MessageRole = Qt::UserRole + 1,
		SeverityRole,
		TitleRole,
		GroupKeyRole,
		PresentationRole,
		TimestampRole,
		FieldsRole,
		ReadRole
	};

	explicit NotificationCenter(QObject* parent = nullptr);

	int rowCount(const QModelIndex& parent = {}) const override;
	QVariant data(const QModelIndex& index, int role) const override;
	QHash<int, QByteArray> roleNames() const override;

	Q_INVOKABLE void push(const QString& message, const QVariantMap& details = {});
	Q_INVOKABLE void markAllRead();
	Q_INVOKABLE void dismissModal(const QVariantMap& details) { emit modalDismissed(details); }
	Q_INVOKABLE void removeAt(int row);
	Q_INVOKABLE int removeByGroup(const QString& groupKey);
	Q_INVOKABLE void clearAll();

	int count() const { return m_visible.size(); }
	int unreadCount() const { return m_unreadCount; }

	int maxEntries() const { return m_maxEntries; }
	void setMaxEntries(int value);

	static constexpr int kAllSeverities = -1;
	int severityFilter() const { return m_severityFilter; }
	void setSeverityFilter(int severity);

	QVariantList severities() const;

signals:
	void modalRequested(const QString& message, const QVariantMap& details);
	void modalDismissed(const QVariantMap& details);
	void countChanged();
	void unreadCountChanged();
	void maxEntriesChanged();
	void severityFilterChanged();
	void severitiesChanged();

private:
	struct Entry {
		QString message;
		int severity = 0;
		QString title;
		QString groupKey;
		QString presentation;
		QDateTime timestamp;
		QVariantList fields;
		bool read = false;
	};

	bool matchesFilter(const Entry& entry) const;
	void resetFilterIfEmpty();
	void rebuildVisible();
	void setUnreadCount(int value);

	QList<Entry> m_entries;
	QList<int> m_visible;
	int m_unreadCount = 0;
	int m_maxEntries = 300;
	int m_severityFilter = kAllSeverities;
};
