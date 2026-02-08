import React, { useState, useMemo } from 'react';
import { View, Text, TouchableOpacity, ScrollView, StyleSheet, Modal, Pressable } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useTheme } from '../../context/ThemeContext';
import AppHeader from '../../components/AppHeader';
import Animated, { FadeIn, FadeInDown, FadeInUp, FadeInLeft, FadeInRight, ZoomIn } from 'react-native-reanimated';

// ============ MOCK DATA ============
const MOCK_ATTENDANCE: Record<string, { status: 'present' | 'absent' | 'leave' | 'holiday'; punchIn?: string; punchOut?: string; hours?: string; isLate?: boolean; lateBy?: string }> = {
    '2026-02-03': { status: 'present', punchIn: '09:02 AM', punchOut: '06:15 PM', hours: '9h 13m', isLate: true, lateBy: '2m' },
    '2026-02-04': { status: 'present', punchIn: '09:10 AM', punchOut: '06:00 PM', hours: '8h 50m', isLate: true, lateBy: '10m' },
    '2026-02-05': { status: 'leave' },
    '2026-02-06': { status: 'present', punchIn: '08:55 AM', punchOut: '06:30 PM', hours: '9h 35m', isLate: false },
    '2026-02-07': { status: 'holiday' },
    '2026-02-10': { status: 'present', punchIn: '09:00 AM', punchOut: '06:00 PM', hours: '9h 00m', isLate: false },
    '2026-02-11': { status: 'absent' },
    '2026-02-12': { status: 'present', punchIn: '09:05 AM', punchOut: '06:10 PM', hours: '9h 05m', isLate: true, lateBy: '5m' },
    '2026-02-13': { status: 'present', punchIn: '09:20 AM', punchOut: '06:05 PM', hours: '8h 45m', isLate: true, lateBy: '20m' },
    '2026-02-14': { status: 'present', punchIn: '08:50 AM', punchOut: '06:00 PM', hours: '9h 10m', isLate: false },
    '2026-02-17': { status: 'present', punchIn: '09:15 AM', punchOut: '06:20 PM', hours: '9h 05m', isLate: true, lateBy: '15m' },
    '2026-02-18': { status: 'present', punchIn: '08:58 AM', punchOut: '06:00 PM', hours: '9h 02m', isLate: false },
};

const HOLIDAYS = [
    { date: '2026-02-07', name: 'Victory Day', type: 'National' },
    { date: '2026-02-21', name: 'Language Movement Day', type: 'National' },
    { date: '2026-03-17', name: 'Sheikh Mujibur Rahman Birthday', type: 'National' },
    { date: '2026-03-26', name: 'Independence Day', type: 'National' },
];

const LEAVE_BALANCE = [
    { type: 'Annual', used: 5, total: 14, color: '#3B82F6' },
    { type: 'Sick', used: 2, total: 10, color: '#EF4444' },
    { type: 'Casual', used: 3, total: 7, color: '#F59E0B' },
];

// ============ UTILS ============
const getDaysInMonth = (month: number, year: number) => new Date(year, month + 1, 0).getDate();
const getFirstDayOfMonth = (month: number, year: number) => new Date(year, month, 1).getDay();
const formatDateKey = (day: number, month: number, year: number) =>
    `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const DAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

// ============ TYPES ============
type TabType = 'attendance' | 'leaves' | 'holidays' | 'late';
type ViewMode = 'calendar' | 'list';

export default function AttendanceScreen() {
    const { isDark } = useTheme();
    const [activeTab, setActiveTab] = useState<TabType>('attendance');
    const [viewMode, setViewMode] = useState<ViewMode>('calendar');
    const [currentMonth, setCurrentMonth] = useState(new Date().getMonth());
    const [currentYear, setCurrentYear] = useState(new Date().getFullYear());
    const [selectedDate, setSelectedDate] = useState<string | null>(null);
    const [reportModalVisible, setReportModalVisible] = useState(false);
    const [detailsModalVisible, setDetailsModalVisible] = useState(false);

    // Dynamic Styles
    const styles = getStyles(isDark);
    const iconColor = isDark ? '#60A5FA' : '#2563EB';

    const stats = useMemo(() => {
        let present = 0, absent = 0, leave = 0, holiday = 0, late = 0;
        Object.values(MOCK_ATTENDANCE).forEach(d => {
            if (d.status === 'present') present++;
            else if (d.status === 'absent') absent++;
            else if (d.status === 'leave') leave++;
            else if (d.status === 'holiday') holiday++;
            if (d.isLate) late++;
        });
        return { present, absent, leave, holiday, late };
    }, []);

    const changeMonth = (delta: number) => {
        let newMonth = currentMonth + delta;
        let newYear = currentYear;
        if (newMonth < 0) { newMonth = 11; newYear--; }
        else if (newMonth > 11) { newMonth = 0; newYear++; }
        setCurrentMonth(newMonth);
        setCurrentYear(newYear);
        setSelectedDate(null);
    };

    const renderCalendar = () => {
        const daysInMonth = getDaysInMonth(currentMonth, currentYear);
        const firstDay = getFirstDayOfMonth(currentMonth, currentYear);
        const days = [];

        // Empty cells for first day of month
        for (let i = 0; i < firstDay; i++) {
            days.push(<View key={`empty-${i}`} style={styles.dayCellContainer} />);
        }

        for (let day = 1; day <= daysInMonth; day++) {
            const dateKey = formatDateKey(day, currentMonth, currentYear);
            const data = MOCK_ATTENDANCE[dateKey];
            const isHoliday = HOLIDAYS.some(h => h.date === dateKey);
            const isSelected = selectedDate === dateKey;

            let bgColor = isDark ? '#374151' : '#F5F5F5'; // Default background

            if (activeTab === 'attendance') {
                if (data?.status === 'present') bgColor = isDark ? 'rgba(34, 197, 94, 0.2)' : '#DCFCE7';
                else if (data?.status === 'absent') bgColor = isDark ? 'rgba(239, 68, 68, 0.2)' : '#FEE2E2';
                else if (data?.status === 'leave') bgColor = isDark ? 'rgba(245, 158, 11, 0.2)' : '#FEF9C3';
                else if (isHoliday || data?.status === 'holiday') bgColor = isDark ? 'rgba(59, 130, 246, 0.2)' : '#DBEAFE';
            } else if (activeTab === 'leaves') {
                if (data?.status === 'leave') bgColor = isDark ? 'rgba(245, 158, 11, 0.3)' : '#FEF9C3';
            } else if (activeTab === 'holidays') {
                if (isHoliday || data?.status === 'holiday') bgColor = isDark ? 'rgba(59, 130, 246, 0.3)' : '#DBEAFE';
            } else if (activeTab === 'late') {
                if (data?.isLate) bgColor = isDark ? 'rgba(239, 68, 68, 0.25)' : '#FEE2E2';
            }

            days.push(
                <Animated.View
                    key={day}
                    entering={ZoomIn.delay(day * 5).duration(300)}
                    style={styles.dayCellContainer}
                >
                    <TouchableOpacity
                        style={[styles.dayCell, { backgroundColor: bgColor }, isSelected && styles.selectedDay]}
                        onPress={() => {
                            setSelectedDate(dateKey);
                            setDetailsModalVisible(true);
                        }}
                        activeOpacity={0.7}
                    >
                        <Text style={[styles.dayText, isSelected && styles.selectedDayText]}>{day}</Text>
                        {activeTab === 'attendance' && data?.status && (
                            <View style={[styles.dotIndicator, {
                                backgroundColor: data.status === 'present' ? '#22C55E' : data.status === 'absent' ? '#EF4444' : '#F59E0B'
                            }]} />
                        )}
                        {activeTab === 'leaves' && data?.status === 'leave' && (
                            <View style={[styles.dotIndicator, { backgroundColor: '#F59E0B' }]} />
                        )}
                        {activeTab === 'holidays' && (isHoliday || data?.status === 'holiday') && (
                            <View style={[styles.dotIndicator, { backgroundColor: '#3B82F6' }]} />
                        )}
                        {activeTab === 'late' && data?.isLate && (
                            <View style={[styles.dotIndicator, { backgroundColor: '#EF4444' }]} />
                        )}
                    </TouchableOpacity>
                </Animated.View>
            );
        }
        return days;
    };

    const renderDayDetails = () => {
        if (!selectedDate) return null;

        let shouldShow = false;
        const data = MOCK_ATTENDANCE[selectedDate];
        const holiday = HOLIDAYS.find(h => h.date === selectedDate);

        if (activeTab === 'attendance') shouldShow = true;
        else if (activeTab === 'leaves' && data?.status === 'leave') shouldShow = true;
        else if (activeTab === 'holidays' && (holiday || data?.status === 'holiday')) shouldShow = true;
        else if (activeTab === 'late' && data?.isLate) shouldShow = true;

        if (!shouldShow) {
            if (activeTab === 'leaves' && data?.status) return null;
            if (activeTab === 'holidays' && !holiday) return null;
            if (activeTab === 'late' && !data?.isLate) return null;
        }

        return (
            <View style={styles.detailCard}>
                <View style={styles.detailHeader}>
                    <Text style={styles.detailTitle}>{new Date(selectedDate).toLocaleDateString(undefined, { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}</Text>
                    {holiday && <View style={styles.holidayBadge}><Text style={styles.holidayBadgeText}>🎉 {holiday.name}</Text></View>}
                </View>

                {data ? (
                    <View style={styles.detailContent}>
                        <View style={styles.statusRow}>
                            <View style={[styles.largeStatusBadge, { backgroundColor: data.status === 'present' ? '#22C55E' : data.status === 'absent' ? '#EF4444' : '#F59E0B' }]}>
                                <Ionicons name={data.status === 'present' ? 'checkmark-circle' : data.status === 'absent' ? 'close-circle' : 'time'} size={24} color="white" />
                                <Text style={styles.largeStatusText}>{data.status.toUpperCase()}</Text>
                            </View>
                            {data.isLate && (
                                <View style={[styles.largeStatusBadge, { backgroundColor: '#EF4444', marginLeft: 8 }]}>
                                    <Ionicons name="time-outline" size={24} color="white" />
                                    <Text style={styles.largeStatusText}>LATE {data.lateBy}</Text>
                                </View>
                            )}
                        </View>

                        <View style={styles.timeGrid}>
                            {data.punchIn && (
                                <View style={styles.timeItem}>
                                    <Text style={styles.timeLabel}>Punch In</Text>
                                    <Text style={styles.timeValue}>{data.punchIn}</Text>
                                </View>
                            )}
                            {data.punchOut && (
                                <View style={styles.timeItem}>
                                    <Text style={styles.timeLabel}>Punch Out</Text>
                                    <Text style={styles.timeValue}>{data.punchOut}</Text>
                                </View>
                            )}
                            {data.hours && (
                                <View style={styles.timeItem}>
                                    <Text style={styles.timeLabel}>Duration</Text>
                                    <Text style={styles.timeValue}>{data.hours}</Text>
                                </View>
                            )}
                        </View>
                    </View>
                ) : (
                    <Text style={styles.noDataText}>
                        {activeTab === 'holidays' && holiday ? 'Public Holiday' : activeTab === 'leaves' ? 'No leave recorded.' : activeTab === 'late' ? 'No late record.' : 'No attendance data found for this date.'}
                    </Text>
                )}
            </View>
        );
    };

    return (
        <SafeAreaView style={styles.container} edges={['top']}>
            <AppHeader />

            <View style={styles.titleRow}>
                <Text style={styles.headerTitle}>Attendance</Text>
                <TouchableOpacity onPress={() => setReportModalVisible(true)} style={styles.downloadBtn}>
                    <Ionicons name="download-outline" size={20} color={iconColor} />
                </TouchableOpacity>
            </View>

            <View style={styles.tabContainer}>
                {(['attendance', 'leaves', 'holidays', 'late'] as TabType[]).map((tab, index) => (
                    <TouchableOpacity key={tab} style={[styles.tab, activeTab === tab && styles.activeTab]} onPress={() => { setActiveTab(tab); setSelectedDate(null); }}>
                        <Text style={[styles.tabText, activeTab === tab && styles.activeTabText]}>{tab.charAt(0).toUpperCase() + tab.slice(1)}</Text>
                    </TouchableOpacity>
                ))}
            </View>

            <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={{ paddingBottom: 100 }}>
                {/* Stats Row - specific stats per tab or generic? Keeping generic for now or filtered. */}
                {activeTab === 'attendance' && (
                    <Animated.View entering={FadeInDown.duration(500)} style={styles.statsRow}>
                        <View style={[styles.statCard, { backgroundColor: isDark ? 'rgba(34, 197, 94, 0.15)' : '#F0FDF4', borderColor: isDark ? 'rgba(34, 197, 94, 0.3)' : '#BBF7D0' }]}>
                            <View style={[styles.statIcon, { backgroundColor: '#22C55E' }]}><Ionicons name="checkmark" size={16} color="white" /></View>
                            <Text style={styles.statNum}>{stats.present}</Text>
                            <Text style={styles.statLabel}>Present</Text>
                        </View>
                        <View style={[styles.statCard, { backgroundColor: isDark ? 'rgba(239, 68, 68, 0.15)' : '#FEF2F2', borderColor: isDark ? 'rgba(239, 68, 68, 0.3)' : '#FECACA' }]}>
                            <View style={[styles.statIcon, { backgroundColor: '#EF4444' }]}><Ionicons name="close" size={16} color="white" /></View>
                            <Text style={styles.statNum}>{stats.absent}</Text>
                            <Text style={styles.statLabel}>Absent</Text>
                        </View>
                        <View style={[styles.statCard, { backgroundColor: isDark ? 'rgba(245, 158, 11, 0.15)' : '#FFFBEB', borderColor: isDark ? 'rgba(245, 158, 11, 0.3)' : '#FDE68A' }]}>
                            <View style={[styles.statIcon, { backgroundColor: '#F59E0B' }]}><Ionicons name="time" size={16} color="white" /></View>
                            <Text style={styles.statNum}>{stats.leave}</Text>
                            <Text style={styles.statLabel}>Leave</Text>
                        </View>
                        <View style={[styles.statCard, { backgroundColor: isDark ? 'rgba(59, 130, 246, 0.15)' : '#EFF6FF', borderColor: isDark ? 'rgba(59, 130, 246, 0.3)' : '#BFDBFE' }]}>
                            <View style={[styles.statIcon, { backgroundColor: '#3B82F6' }]}><Ionicons name="calendar" size={16} color="white" /></View>
                            <Text style={styles.statNum}>{stats.holiday}</Text>
                            <Text style={styles.statLabel}>Holiday</Text>
                        </View>
                    </Animated.View>
                )}

                {activeTab === 'late' && (
                    <Animated.View entering={FadeInDown.duration(500)} style={styles.lateStatsContainer}>
                        <View style={styles.lateStatsCard}>
                            <View style={styles.lateStatsHeader}>
                                <Ionicons name="time-outline" size={32} color="#EF4444" />
                                <Text style={styles.lateStatsTitle}>Late Arrivals</Text>
                            </View>
                            <Text style={styles.lateStatsCount}>{stats.late}</Text>
                            <Text style={styles.lateStatsSubtext}>Total late days this month</Text>
                        </View>
                    </Animated.View>
                )}

                {/* Leave Balances Header (only for Leaves tab) */}
                {activeTab === 'leaves' && (
                    <View style={{ paddingHorizontal: 20, marginBottom: 16 }}>
                        <Text style={styles.sectionTitle}>Leave Calendar</Text>
                    </View>
                )}
                {activeTab === 'holidays' && (
                    <View style={{ paddingHorizontal: 20, marginBottom: 16 }}>
                        <Text style={styles.sectionTitle}>Holiday Calendar</Text>
                    </View>
                )}
                {activeTab === 'late' && (
                    <View style={{ paddingHorizontal: 20, marginBottom: 16 }}>
                        <Text style={styles.sectionTitle}>Late Arrival Calendar</Text>
                    </View>
                )}

                {/* Shared Calendar / List Navigation */}
                <View style={styles.monthNav}>
                    <TouchableOpacity onPress={() => changeMonth(-1)} style={styles.navBtn}><Ionicons name="chevron-back" size={20} color={isDark ? '#E5E5E5' : '#404040'} /></TouchableOpacity>
                    <Text style={styles.monthText}>{MONTHS[currentMonth]} {currentYear}</Text>
                    <TouchableOpacity onPress={() => changeMonth(1)} style={styles.navBtn}><Ionicons name="chevron-forward" size={20} color={isDark ? '#E5E5E5' : '#404040'} /></TouchableOpacity>
                    <View style={{ flex: 1 }} />
                    <TouchableOpacity onPress={() => setViewMode(viewMode === 'calendar' ? 'list' : 'calendar')} style={styles.viewToggle}>
                        <Ionicons name={viewMode === 'calendar' ? 'list' : 'grid'} size={20} color={iconColor} />
                    </TouchableOpacity>
                </View>

                {/* Calendar View */}
                {viewMode === 'calendar' && (
                    <Animated.View entering={FadeIn.duration(500)} style={styles.calendarContainer}>
                        <View style={styles.weekRow}>{DAYS.map(d => <Text key={d} style={styles.weekDay}>{d}</Text>)}</View>
                        <View style={styles.daysGrid}>{renderCalendar()}</View>
                    </Animated.View>
                )}

                {/* List View */}
                {viewMode === 'list' && (
                    <View style={styles.listContainer}>
                        {Object.entries(MOCK_ATTENDANCE)
                            .filter(([_, data]) => {
                                if (activeTab === 'attendance') return true;
                                if (activeTab === 'leaves') return data.status === 'leave';
                                if (activeTab === 'late') return data.isLate === true;
                                return false; // Holidays handled separately below for better view
                            })
                            .map(([date, data], index) => (
                                <Animated.View key={date} entering={FadeInRight.delay(index * 50).duration(400)}>
                                    <TouchableOpacity
                                        style={styles.listItem}
                                        onPress={() => {
                                            setSelectedDate(date);
                                            setDetailsModalVisible(true);
                                        }}
                                    >
                                        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 12 }}>
                                            <View style={[styles.listIcon, { backgroundColor: data.status === 'present' ? '#22C55E20' : '#EF444420' }]}>
                                                <Ionicons name={data.status === 'present' ? 'checkmark' : 'alert'} size={18} color={data.status === 'present' ? '#22C55E' : '#EF4444'} />
                                            </View>
                                            <View>
                                                <Text style={styles.listDate}>{date}</Text>
                                                {activeTab === 'late' && data.lateBy && (
                                                    <Text style={styles.lateByText}>Late by {data.lateBy}</Text>
                                                )}
                                            </View>
                                        </View>
                                        <View style={[styles.statusBadge, { backgroundColor: data.status === 'present' ? '#22C55E' : data.status === 'absent' ? '#EF4444' : '#F59E0B' }]}>
                                            <Text style={styles.statusText}>{data.status.toUpperCase()}</Text>
                                        </View>
                                    </TouchableOpacity>
                                </Animated.View>
                            ))}
                        {activeTab === 'holidays' && HOLIDAYS.map((h, i) => (
                            <Animated.View key={h.date} entering={FadeInRight.delay(i * 50).duration(400)}>
                                <View style={styles.listItem}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', gap: 12 }}>
                                        <View style={[styles.listIcon, { backgroundColor: '#3B82F620' }]}>
                                            <Ionicons name='calendar' size={18} color='#3B82F6' />
                                        </View>
                                        <Text style={styles.listDate}>{h.date} - {h.name}</Text>
                                    </View>
                                </View>
                            </Animated.View>
                        ))}
                    </View>
                )}

                {/* Additional Tab Content */}
                {activeTab === 'leaves' && (
                    <View style={styles.leaveBalanceSection}>
                        <Text style={[styles.sectionTitle, { marginTop: 20 }]}>Leave Balance</Text>
                        {LEAVE_BALANCE.map((l, i) => (
                            <Animated.View key={l.type} entering={FadeInUp.delay(i * 100).duration(400)} style={styles.leaveCard}>
                                <View style={[styles.leaveIcon, { backgroundColor: l.color }]}><Ionicons name="briefcase" size={18} color="white" /></View>
                                <View style={{ flex: 1 }}>
                                    <Text style={styles.leaveType}>{l.type} Leave</Text>
                                    <View style={styles.progressBar}>
                                        <View style={[styles.progressFill, { width: `${(l.used / l.total) * 100}%`, backgroundColor: l.color }]} />
                                    </View>
                                    <Text style={styles.leaveUsed}>{l.used} used of {l.total} days</Text>
                                </View>
                                <View style={styles.balanceBadge}>
                                    <Text style={[styles.leaveRemaining, { color: l.color }]}>{l.total - l.used}</Text>
                                    <Text style={[styles.daysLabel, { color: l.color }]}>left</Text>
                                </View>
                            </Animated.View>
                        ))}
                    </View>
                )}
            </ScrollView>

            <Modal visible={reportModalVisible} transparent animationType="fade" onRequestClose={() => setReportModalVisible(false)}>
                <Pressable style={styles.modalOverlay} onPress={() => setReportModalVisible(false)}>
                    <Animated.View entering={ZoomIn.duration(300)} style={styles.modalContent}>
                        <Text style={styles.modalTitle}>Download Report</Text>
                        {['This Month', 'Last Month', 'This Year', 'Custom Range'].map((opt, i) => (
                            <TouchableOpacity key={opt} style={styles.modalOption} onPress={() => setReportModalVisible(false)}>
                                <Ionicons name="document-text-outline" size={22} color={iconColor} />
                                <Text style={styles.modalOptionText}>{opt}</Text>
                                <Ionicons name="chevron-forward" size={18} color="#A3A3A3" style={{ marginLeft: 'auto' }} />
                            </TouchableOpacity>
                        ))}
                        <TouchableOpacity style={styles.modalClose} onPress={() => setReportModalVisible(false)}>
                            <Text style={styles.modalCloseText}>Cancel</Text>
                        </TouchableOpacity>
                    </Animated.View>
                </Pressable>
            </Modal>

            {/* Day Details Modal */}
            <Modal visible={detailsModalVisible} transparent animationType="fade" onRequestClose={() => setDetailsModalVisible(false)}>
                <Pressable style={styles.modalOverlay} onPress={() => setDetailsModalVisible(false)}>
                    <Animated.View entering={ZoomIn.duration(300)} style={styles.detailsModalContent}>
                        {renderDayDetails()}
                        <TouchableOpacity style={styles.modalClose} onPress={() => setDetailsModalVisible(false)}>
                            <Text style={styles.modalCloseText}>Close</Text>
                        </TouchableOpacity>
                    </Animated.View>
                </Pressable>
            </Modal>
        </SafeAreaView>
    );
}

const getStyles = (isDark: boolean) => StyleSheet.create({
    container: { flex: 1, backgroundColor: isDark ? '#111827' : '#F9FAFB' },
    titleRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: 20, paddingVertical: 12 },
    headerTitle: { fontSize: 24, fontWeight: '800', color: isDark ? '#F9FAFB' : '#111827', letterSpacing: -0.5 },
    downloadBtn: { padding: 8, backgroundColor: isDark ? '#1F2937' : 'white', borderRadius: 12, borderWidth: 1, borderColor: isDark ? '#374151' : '#E5E7EB' },

    tabContainer: { flexDirection: 'row', backgroundColor: isDark ? '#1F2937' : 'white', padding: 4, marginHorizontal: 20, borderRadius: 16, marginBottom: 16 },
    tab: { flex: 1, paddingVertical: 10, alignItems: 'center', borderRadius: 12 },
    activeTab: { backgroundColor: isDark ? '#374151' : '#F3F4F6' },
    tabText: { fontWeight: '600', color: isDark ? '#9CA3AF' : '#6B7280', fontSize: 13 },
    activeTabText: { color: isDark ? '#F9FAFB' : '#111827', fontWeight: '700' },

    statsRow: { flexDirection: 'row', paddingHorizontal: 20, gap: 12, marginBottom: 20 },
    statCard: { flex: 1, padding: 12, borderRadius: 16, alignItems: 'center', borderWidth: 1 },
    statIcon: { width: 28, height: 28, borderRadius: 14, alignItems: 'center', justifyContent: 'center', marginBottom: 8 },
    statNum: { fontSize: 18, fontWeight: '800', color: isDark ? '#F9FAFB' : '#111827' },
    statLabel: { fontSize: 11, color: isDark ? '#9CA3AF' : '#6B7280', fontWeight: '500' },

    monthNav: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 20, marginBottom: 16, gap: 12 },
    navBtn: { padding: 8, borderRadius: 12, backgroundColor: isDark ? '#1F2937' : 'white', borderWidth: 1, borderColor: isDark ? '#374151' : '#E5E7EB' },
    monthText: { fontSize: 16, fontWeight: '700', color: isDark ? '#F9FAFB' : '#1F2937' },
    viewToggle: { padding: 8, backgroundColor: isDark ? '#1F2937' : 'white', borderRadius: 12, borderWidth: 1, borderColor: isDark ? '#374151' : '#E5E7EB' },

    calendarContainer: { paddingHorizontal: 20 },
    weekRow: { flexDirection: 'row', justifyContent: 'space-around', marginBottom: 12 },
    weekDay: { width: '14.28%', textAlign: 'center', fontSize: 13, color: isDark ? '#9CA3AF' : '#9CA3AF', fontWeight: '600' },
    daysGrid: { flexDirection: 'row', flexWrap: 'wrap' },
    dayCellContainer: { width: '14.28%', aspectRatio: 1, marginBottom: 8, padding: 2 },
    dayCell: { flex: 1, alignItems: 'center', justifyContent: 'center', borderRadius: 14 },
    dayText: { fontSize: 14, color: isDark ? '#F9FAFB' : '#374151', fontWeight: '700' }, // High contrast
    selectedDay: { borderWidth: 2, borderColor: '#2563EB', backgroundColor: isDark ? 'rgba(37, 99, 235, 0.2)' : '#EFF6FF' },
    selectedDayText: { fontWeight: 'bold', color: '#2563EB' },
    dotIndicator: { width: 4, height: 4, borderRadius: 2, marginTop: 4 },

    detailCard: { margin: 20, padding: 20, backgroundColor: isDark ? '#1F2937' : 'white', borderRadius: 24, shadowColor: '#000', shadowOpacity: 0.05, shadowRadius: 10, elevation: 4 },
    detailHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 20 },
    detailTitle: { fontSize: 18, fontWeight: '700', color: isDark ? '#F9FAFB' : '#111827', maxWidth: '70%' },
    holidayBadge: { backgroundColor: '#EFF6FF', paddingHorizontal: 10, paddingVertical: 4, borderRadius: 12 },
    holidayBadgeText: { fontSize: 12, color: '#2563EB', fontWeight: '600' },
    detailContent: { gap: 16 },
    statusRow: { flexDirection: 'row', alignItems: 'center' },
    largeStatusBadge: { flexDirection: 'row', alignItems: 'center', gap: 8, paddingHorizontal: 16, paddingVertical: 8, borderRadius: 16 },
    largeStatusText: { color: 'white', fontWeight: '700', fontSize: 14 },
    timeGrid: { flexDirection: 'row', gap: 12, flexWrap: 'wrap' },
    timeItem: { flex: 1, padding: 12, backgroundColor: isDark ? '#374151' : '#F9FAFB', borderRadius: 12, minWidth: '30%' },
    timeLabel: { fontSize: 11, color: isDark ? '#9CA3AF' : '#6B7280', marginBottom: 4 },
    timeValue: { fontSize: 14, fontWeight: '700', color: isDark ? '#F9FAFB' : '#111827' },
    noDataText: { textAlign: 'center', color: isDark ? '#9CA3AF' : '#6B7280', marginVertical: 20 },

    listContainer: { paddingHorizontal: 20 },
    listItem: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', padding: 16, backgroundColor: isDark ? '#1F2937' : 'white', borderRadius: 16, marginBottom: 12, borderWidth: 1, borderColor: isDark ? '#374151' : '#F3F4F6' },
    listIcon: { width: 36, height: 36, borderRadius: 12, alignItems: 'center', justifyContent: 'center' },
    listDate: { fontSize: 15, fontWeight: '600', color: isDark ? '#F9FAFB' : '#1F2937' },
    statusBadge: { paddingHorizontal: 10, paddingVertical: 4, borderRadius: 8 },
    statusText: { color: 'white', fontSize: 11, fontWeight: '700' },

    holidayListSection: { padding: 20 },
    sectionTitle: { fontSize: 18, fontWeight: '700', color: isDark ? '#F9FAFB' : '#111827', marginBottom: 16 },
    holidayCard: { flexDirection: 'row', alignItems: 'center', gap: 16, backgroundColor: isDark ? '#1F2937' : 'white', padding: 16, borderRadius: 20, marginBottom: 12 },
    holidayDate: { alignItems: 'center', backgroundColor: isDark ? 'rgba(37, 99, 235, 0.1)' : '#EFF6FF', padding: 12, borderRadius: 16, minWidth: 60 },
    holidayDateText: { fontSize: 20, fontWeight: '800', color: '#2563EB' },
    holidayMonth: { fontSize: 11, color: '#2563EB', fontWeight: '600', textTransform: 'uppercase' },
    holidayName: { fontSize: 16, fontWeight: '700', color: isDark ? '#F9FAFB' : '#1F2937' },
    holidayType: { fontSize: 13, color: isDark ? '#9CA3AF' : '#6B7280' },

    leaveBalanceSection: { padding: 20 },
    leaveCard: { flexDirection: 'row', alignItems: 'center', gap: 16, backgroundColor: isDark ? '#1F2937' : 'white', padding: 16, borderRadius: 20, marginBottom: 12 },
    leaveIcon: { width: 44, height: 44, borderRadius: 14, alignItems: 'center', justifyContent: 'center' },
    leaveType: { fontSize: 15, fontWeight: '700', color: isDark ? '#F9FAFB' : '#1F2937' },
    progressBar: { height: 6, backgroundColor: isDark ? '#374151' : '#F3F4F6', borderRadius: 3, marginVertical: 8, width: '100%' },
    progressFill: { height: '100%', borderRadius: 3 },
    leaveUsed: { fontSize: 12, color: isDark ? '#9CA3AF' : '#6B7280' },
    balanceBadge: { alignItems: 'flex-end' },
    leaveRemaining: { fontSize: 20, fontWeight: '800' },
    daysLabel: { fontSize: 11, fontWeight: '600' },

    modalOverlay: { flex: 1, backgroundColor: 'rgba(0,0,0,0.6)', justifyContent: 'center', alignItems: 'center', padding: 20 },
    modalContent: { backgroundColor: isDark ? '#1F2937' : 'white', borderRadius: 24, padding: 24, width: '100%', maxWidth: 400 },
    modalTitle: { fontSize: 20, fontWeight: '800', marginBottom: 20, textAlign: 'center', color: isDark ? '#F9FAFB' : '#1F2937' },
    modalOption: { flexDirection: 'row', alignItems: 'center', gap: 12, paddingVertical: 16, borderBottomWidth: 1, borderBottomColor: isDark ? '#374151' : '#F3F4F6' },
    modalOptionText: { fontSize: 16, color: isDark ? '#F9FAFB' : '#1F2937', fontWeight: '500' },
    modalClose: { marginTop: 20, alignItems: 'center', padding: 12 },
    modalCloseText: { color: '#EF4444', fontWeight: '700', fontSize: 16 },

    lateStatsContainer: { paddingHorizontal: 20, marginBottom: 20 },
    lateStatsCard: { backgroundColor: isDark ? '#1F2937' : 'white', borderRadius: 24, padding: 24, alignItems: 'center', borderWidth: 1, borderColor: isDark ? '#374151' : '#F3F4F6' },
    lateStatsHeader: { flexDirection: 'row', alignItems: 'center', gap: 12, marginBottom: 16 },
    lateStatsTitle: { fontSize: 20, fontWeight: '700', color: isDark ? '#F9FAFB' : '#111827' },
    lateStatsCount: { fontSize: 48, fontWeight: '800', color: '#EF4444', marginBottom: 8 },
    lateStatsSubtext: { fontSize: 14, color: isDark ? '#9CA3AF' : '#6B7280' },

    detailsModalContent: { backgroundColor: isDark ? '#1F2937' : 'white', borderRadius: 24, padding: 0, width: '100%', maxWidth: 400, overflow: 'hidden' },
    lateByText: { fontSize: 12, color: '#EF4444', fontWeight: '600', marginTop: 2 },
});
