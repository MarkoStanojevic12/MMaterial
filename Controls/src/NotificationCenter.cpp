#include "NotificationCenter.h"

NotificationCenter::NotificationCenter(QObject* parent)
	: QAbstractListModel(parent)
{
}

int NotificationCenter::rowCount(const QModelIndex& parent) const
{
	return parent.isValid() ? 0 : m_visible.size();
}

QVariant NotificationCenter::data(const QModelIndex& index, int role) const
{
	if (!index.isValid() || index.row() < 0 || index.row() >= m_visible.size())
		return {};

	const Entry& entry = m_entries.at(m_visible.at(index.row()));
	switch (role) {
	case MessageRole: return entry.message;
	case SeverityRole: return entry.severity;
	case TitleRole: return entry.title;
	case GroupKeyRole: return entry.groupKey;
	case PresentationRole: return entry.presentation;
	case TimestampRole: return entry.timestamp;
	case FieldsRole: return entry.fields;
	case ReadRole: return entry.read;
	}
	return {};
}

QHash<int, QByteArray> NotificationCenter::roleNames() const
{
	return {
		{ MessageRole, "message" },
		{ SeverityRole, "severity" },
		{ TitleRole, "title" },
		{ GroupKeyRole, "groupKey" },
		{ PresentationRole, "presentation" },
		{ TimestampRole, "timestamp" },
		{ FieldsRole, "fields" },
		{ ReadRole, "read" }
	};
}

void NotificationCenter::push(const QString& message, const QVariantMap& details)
{
	if (message.isEmpty())
		return;

	Entry entry;
	entry.message = message;
	entry.severity = details.value(QStringLiteral("severity")).toInt();
	entry.title = details.value(QStringLiteral("title")).toString();
	entry.groupKey = details.value(QStringLiteral("groupKey")).toString();
	entry.presentation = details.value(QStringLiteral("presentation"), QStringLiteral("banner")).toString();
	entry.fields = details.value(QStringLiteral("fields")).toList();
	entry.timestamp = QDateTime::currentDateTime();

	for (int& visibleIndex : m_visible)
		++visibleIndex;
	m_entries.prepend(entry);

	if (matchesFilter(entry)) {
		beginInsertRows({}, 0, 0);
		m_visible.prepend(0);
		endInsertRows();
		emit countChanged();
	}

	while (m_entries.size() > m_maxEntries) {
		const int droppedIndex = m_entries.size() - 1;
		if (!m_entries.last().read)
			--m_unreadCount;
		m_entries.removeLast();
		if (!m_visible.isEmpty() && m_visible.last() == droppedIndex) {
			beginRemoveRows({}, m_visible.size() - 1, m_visible.size() - 1);
			m_visible.removeLast();
			endRemoveRows();
			emit countChanged();
		}
	}

	setUnreadCount(m_unreadCount + 1);
	emit severitiesChanged();

	if (entry.presentation == QStringLiteral("modal"))
		emit modalRequested(message, details);
}

void NotificationCenter::markAllRead()
{
	for (Entry& entry : m_entries)
		entry.read = true;
	if (!m_visible.isEmpty())
		emit dataChanged(index(0), index(m_visible.size() - 1), { ReadRole });
	setUnreadCount(0);
}

void NotificationCenter::removeAt(int row)
{
	if (row < 0 || row >= m_visible.size())
		return;

	const int entryIndex = m_visible.at(row);
	const bool wasUnread = !m_entries.at(entryIndex).read;

	beginRemoveRows({}, row, row);
	m_entries.removeAt(entryIndex);
	m_visible.removeAt(row);
	for (int& visibleIndex : m_visible) {
		if (visibleIndex > entryIndex)
			--visibleIndex;
	}
	endRemoveRows();

	if (wasUnread)
		setUnreadCount(m_unreadCount - 1);
	emit countChanged();
	emit severitiesChanged();
	resetFilterIfEmpty();
}

int NotificationCenter::removeByGroup(const QString& groupKey)
{
	if (groupKey.isEmpty())
		return 0;

	int removed = 0;
	int unread = 0;
	for (const Entry& entry : m_entries) {
		if (entry.groupKey != groupKey)
			continue;
		++removed;
		if (!entry.read)
			++unread;
	}
	if (removed == 0)
		return 0;

	beginResetModel();
	m_entries.removeIf([&groupKey](const Entry& entry) { return entry.groupKey == groupKey; });
	rebuildVisible();
	endResetModel();

	setUnreadCount(m_unreadCount - unread);
	emit countChanged();
	emit severitiesChanged();
	resetFilterIfEmpty();
	return removed;
}

void NotificationCenter::resetFilterIfEmpty()
{
	if (m_severityFilter == kAllSeverities)
		return;

	for (const Entry& entry : m_entries) {
		if (entry.severity == m_severityFilter)
			return;
	}
	setSeverityFilter(kAllSeverities);
}

void NotificationCenter::clearAll()
{
	if (m_entries.isEmpty())
		return;
	beginResetModel();
	m_entries.clear();
	m_visible.clear();
	endResetModel();
	setUnreadCount(0);
	emit countChanged();
	emit severitiesChanged();
}

void NotificationCenter::setMaxEntries(int value)
{
	value = qMax(1, value);
	if (m_maxEntries == value)
		return;
	m_maxEntries = value;
	emit maxEntriesChanged();

	if (m_entries.size() > m_maxEntries) {
		int unread = 0;
		for (int i = 0; i < m_maxEntries; ++i)
			unread += m_entries.at(i).read ? 0 : 1;
		beginResetModel();
		m_entries.resize(m_maxEntries);
		rebuildVisible();
		endResetModel();
		setUnreadCount(unread);
		emit countChanged();
		emit severitiesChanged();
	}
}

void NotificationCenter::setSeverityFilter(int severity)
{
	if (m_severityFilter == severity)
		return;
	m_severityFilter = severity;
	emit severityFilterChanged();

	beginResetModel();
	rebuildVisible();
	endResetModel();
	emit countChanged();
}

QVariantList NotificationCenter::severities() const
{
	static const QList<int> byUrgency { 3, 2, 0, 1 };

	QHash<int, int> countBySeverity;
	for (const Entry& entry : m_entries)
		countBySeverity[entry.severity] += 1;

	QVariantList result;
	for (int severity : byUrgency) {
		const int count = countBySeverity.take(severity);
		if (count > 0) {
			result.append(QVariantMap {
				{ QStringLiteral("severity"), severity },
				{ QStringLiteral("count"), count }
			});
		}
	}
	for (auto it = countBySeverity.constBegin(); it != countBySeverity.constEnd(); ++it) {
		result.append(QVariantMap {
			{ QStringLiteral("severity"), it.key() },
			{ QStringLiteral("count"), it.value() }
		});
	}
	return result;
}

bool NotificationCenter::matchesFilter(const Entry& entry) const
{
	return m_severityFilter == kAllSeverities || entry.severity == m_severityFilter;
}

void NotificationCenter::rebuildVisible()
{
	m_visible.clear();
	for (int i = 0; i < m_entries.size(); ++i) {
		if (matchesFilter(m_entries.at(i)))
			m_visible.append(i);
	}
}

void NotificationCenter::setUnreadCount(int value)
{
	value = qMax(0, value);
	if (m_unreadCount == value)
		return;
	m_unreadCount = value;
	emit unreadCountChanged();
}
