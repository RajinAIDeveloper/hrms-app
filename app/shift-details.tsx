import React, { useState, useMemo } from 'react';
import { View, Text, StyleSheet, ScrollView, Image, TouchableOpacity, Modal, Pressable } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Colors } from '../constants/Colors';
import { Ionicons } from '@expo/vector-icons';
import Animated, { FadeInDown, FadeInRight, ZoomIn, FadeIn } from 'react-native-reanimated';
import AppHeader from '../components/AppHeader';
import { useTheme } from '../context/ThemeContext';

// ============ MOCK DATA ============
const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const DAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

// Mock shift roster data for the month
const SHIFT_ROSTER: Record<string, { employees: Array<{ id: number; name: string; role: string; shift: string; time: string; image: string }> }> = {
    '2026-02-03': {
        employees: [
            { id: 1, name: 'Sarah Wilson', role: 'UX Designer', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=1' },
            { id: 2, name: 'David Chen', role: 'Developer', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=2' },
            { id: 3, name: 'Maria Garcia', role: 'Tester', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=3' },
            { id: 4, name: 'James Smith', role: 'Manager', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=4' },
        ]
    },
    '2026-02-04': {
        employees: [
            { id: 1, name: 'Sarah Wilson', role: 'UX Designer', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=1' },
            { id: 2, name: 'David Chen', role: 'Developer', shift: 'Night', time: '18:00 - 03:00', image: 'https://i.pravatar.cc/150?u=2' },
            { id: 5, name: 'Emily Brown', role: 'Support', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=5' },
        ]
    },
    '2026-02-05': {
        employees: [
            { id: 1, name: 'Sarah Wilson', role: 'UX Designer', shift: 'WFH', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=1' },
            { id: 3, name: 'Maria Garcia', role: 'Tester', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=3' },
            { id: 4, name: 'James Smith', role: 'Manager', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=4' },
            { id: 6, name: 'Michael Lee', role: 'Developer', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=6' },
        ]
    },
    '2026-02-06': {
        employees: [
            { id: 2, name: 'David Chen', role: 'Developer', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=2' },
            { id: 3, name: 'Maria Garcia', role: 'Tester', shift: 'Half Day', time: '09:00 - 13:00', image: 'https://i.pravatar.cc/150?u=3' },
            { id: 4, name: 'James Smith', role: 'Manager', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=4' },
        ]
    },
    '2026-02-10': {
        employees: [
            { id: 1, name: 'Sarah Wilson', role: 'UX Designer', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=1' },
            { id: 2, name: 'David Chen', role: 'Developer', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=2' },
            { id: 5, name: 'Emily Brown', role: 'Support', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=5' },
        ]
    },
    '2026-02-12': {
        employees: [
            { id: 1, name: 'Sarah Wilson', role: 'UX Designer', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=1' },
            { id: 3, name: 'Maria Garcia', role: 'Tester', shift: 'General', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=3' },
            { id: 4, name: 'James Smith', role: 'Manager', shift: 'WFH', time: '09:00 - 18:00', image: 'https://i.pravatar.cc/150?u=4' },
            { id: 6, name: 'Michael Lee', role: 'Developer', shift: 'Night', time: '18:00 - 03:00', image: 'https://i.pravatar.cc/150?u=6' },
        ]
    },
};

// ============ UTILS ============
const getDaysInMonth = (month: number, year: number) => new Date(year, month + 1, 0).getDate();
const getFirstDayOfMonth = (month: number, year: number) => new Date(year, month, 1).getDay();
const formatDateKey = (day: number, month: number, year: number) =>
    `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
const isSameDate = (date1: Date, date2: Date) =>
    date1.getDate() === date2.getDate() && date1.getMonth() === date2.getMonth() && date1.getFullYear() === date2.getFullYear();

// Shift Card Component
const ShiftCard = ({ day, date, type, time, isToday, theme }: any) => (
    <View style={[
        styles.shiftCard,
        {
            backgroundColor: isToday ? theme.primary : theme.card,
            borderColor: theme.border,
            borderWidth: isToday ? 0 : 1
        }
    ]}>
        <Text style={[styles.shiftDay, { color: isToday ? 'white' : theme.subtext }]}>{day}</Text>
        <Text style={[styles.shiftDate, { color: isToday ? 'white' : theme.text }]}>{date}</Text>
        <View style={[styles.shiftTypeBadge, { backgroundColor: isToday ? 'rgba(255,255,255,0.2)' : theme.background }]}>
            <Text style={[styles.shiftType, { color: isToday ? 'white' : theme.text }]}>{type}</Text>
        </View>
        <Text style={[styles.shiftTime, { color: isToday ? 'rgba(255,255,255,0.9)' : theme.subtext }]}>{time}</Text>
    </View>
);

// Team Member
const TeamMember = ({ name, role, image, theme, index }: any) => (
    <Animated.View entering={FadeInRight.delay(index * 100).duration(400)} style={[styles.teamMember, { backgroundColor: theme.card, borderColor: theme.border }]}>
        <Image source={{ uri: image }} style={styles.teamAvatar} />
        <View style={styles.teamInfo}>
            <Text style={[styles.teamName, { color: theme.text }]}>{name}</Text>
            <Text style={[styles.teamRole, { color: theme.subtext }]}>{role}</Text>
        </View>
        <TouchableOpacity style={[styles.callBtn, { backgroundColor: theme.success + '15' }]}>
            <Ionicons name="call" size={18} color={theme.success} />
        </TouchableOpacity>
    </Animated.View>
);

export default function ShiftDetailsScreen() {
    const { isDark } = useTheme();
    const theme = Colors[isDark ? 'dark' : 'light'];

    const [viewMode, setViewMode] = useState<'week' | 'calendar'>('week');
    const [currentMonth, setCurrentMonth] = useState(new Date().getMonth());
    const [currentYear, setCurrentYear] = useState(new Date().getFullYear());
    const [selectedDate, setSelectedDate] = useState<string | null>(null);
    const [rosterModalVisible, setRosterModalVisible] = useState(false);

    const weekSchedule = [
        { day: 'Mon', date: '02 Feb', type: 'General', time: '09:00 - 18:00', isToday: true },
        { day: 'Tue', date: '03 Feb', type: 'General', time: '09:00 - 18:00', isToday: false },
        { day: 'Wed', date: '04 Feb', type: 'General', time: '09:00 - 18:00', isToday: false },
        { day: 'Thu', date: '05 Feb', type: 'WFH', time: '09:00 - 18:00', isToday: false },
        { day: 'Fri', date: '06 Feb', type: 'General', time: '09:00 - 18:00', isToday: false },
        { day: 'Sat', date: '07 Feb', type: 'Half Day', time: '09:00 - 13:00', isToday: false },
        { day: 'Sun', date: '08 Feb', type: 'Off', time: 'Weekend', isToday: false },
    ];

    const team = [
        { id: 1, name: 'Sarah Wilson', role: 'UX Designer', image: 'https://i.pravatar.cc/150?u=1' },
        { id: 2, name: 'David Chen', role: 'Developer', image: 'https://i.pravatar.cc/150?u=2' },
        { id: 3, name: 'Maria Garcia', role: 'Tester', image: 'https://i.pravatar.cc/150?u=3' },
        { id: 4, name: 'James Smith', role: 'Manager', image: 'https://i.pravatar.cc/150?u=4' },
    ];

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
        const today = new Date();

        // Empty cells for first day of month
        for (let i = 0; i < firstDay; i++) {
            days.push(<View key={`empty-${i}`} style={styles.dayCellContainer} />);
        }

        for (let day = 1; day <= daysInMonth; day++) {
            const dateKey = formatDateKey(day, currentMonth, currentYear);
            const roster = SHIFT_ROSTER[dateKey];
            const isToday = isSameDate(new Date(dateKey), today);
            const isSelected = selectedDate === dateKey;

            let bgColor = isDark ? '#374151' : '#F5F5F5';
            if (isToday) bgColor = isDark ? 'rgba(94, 53, 177, 0.3)' : '#EDE7F6';
            if (roster) bgColor = isDark ? 'rgba(34, 197, 94, 0.2)' : '#DCFCE7';

            days.push(
                <Animated.View
                    key={day}
                    entering={ZoomIn.delay(day * 5).duration(300)}
                    style={styles.dayCellContainer}
                >
                    <TouchableOpacity
                        style={[
                            styles.dayCell,
                            { backgroundColor: bgColor },
                            isSelected && styles.selectedDay
                        ]}
                        onPress={() => {
                            if (roster) {
                                setSelectedDate(dateKey);
                                setRosterModalVisible(true);
                            }
                        }}
                        activeOpacity={0.7}
                        disabled={!roster}
                    >
                        <Text style={[
                            styles.dayText,
                            { color: isDark ? '#F9FAFB' : '#374151' },
                            isToday && { fontWeight: '800', color: theme.primary },
                            isSelected && { color: '#2563EB' },
                            !roster && { opacity: 0.4 }
                        ]}>
                            {day}
                        </Text>
                        {roster && (
                            <View style={styles.employeeCountBadge}>
                                <Text style={styles.employeeCountText}>{roster.employees.length}</Text>
                            </View>
                        )}
                    </TouchableOpacity>
                </Animated.View>
            );
        }
        return days;
    };

    const renderRosterModal = () => {
        if (!selectedDate) return null;

        const roster = SHIFT_ROSTER[selectedDate];
        if (!roster) return null;

        const date = new Date(selectedDate);
        const formattedDate = date.toLocaleDateString(undefined, {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });

        return (
            <View style={styles.rosterModalCard}>
                <View style={styles.rosterModalHeader}>
                    <Ionicons name="calendar-outline" size={24} color={theme.primary} />
                    <View style={{ flex: 1, marginLeft: 12 }}>
                        <Text style={[styles.rosterModalTitle, { color: theme.text }]}>Shift Roster</Text>
                        <Text style={[styles.rosterModalDate, { color: theme.subtext }]}>{formattedDate}</Text>
                    </View>
                </View>

                <View style={[styles.rosterEmployeeCount, { backgroundColor: isDark ? '#374151' : '#F3F4F6' }]}>
                    <Ionicons name="people" size={20} color={theme.primary} />
                    <Text style={[styles.rosterEmployeeCountText, { color: theme.text }]}>
                        {roster.employees.length} employees scheduled
                    </Text>
                </View>

                <ScrollView style={styles.rosterEmployeeList} showsVerticalScrollIndicator={false}>
                    {roster.employees.map((employee, index) => (
                        <Animated.View
                            key={employee.id}
                            entering={FadeInRight.delay(index * 100).duration(400)}
                            style={[styles.rosterEmployeeCard, { backgroundColor: isDark ? '#1F2937' : 'white', borderColor: theme.border }]}
                        >
                            <Image source={{ uri: employee.image }} style={styles.rosterEmployeeAvatar} />
                            <View style={styles.rosterEmployeeInfo}>
                                <Text style={[styles.rosterEmployeeName, { color: theme.text }]}>{employee.name}</Text>
                                <Text style={[styles.rosterEmployeeRole, { color: theme.subtext }]}>{employee.role}</Text>
                            </View>
                            <View style={{ alignItems: 'flex-end' }}>
                                <View style={[
                                    styles.shiftBadge,
                                    {
                                        backgroundColor: employee.shift === 'Night' ? '#EF444420' :
                                            employee.shift === 'WFH' ? '#3B82F620' :
                                                employee.shift === 'Half Day' ? '#F59E0B20' : '#22C55E20'
                                    }
                                ]}>
                                    <Text style={[
                                        styles.shiftBadgeText,
                                        {
                                            color: employee.shift === 'Night' ? '#EF4444' :
                                                employee.shift === 'WFH' ? '#3B82F6' :
                                                    employee.shift === 'Half Day' ? '#F59E0B' : '#22C55E'
                                        }
                                    ]}>
                                        {employee.shift}
                                    </Text>
                                </View>
                                <Text style={[styles.rosterEmployeeTime, { color: theme.subtext }]}>{employee.time}</Text>
                            </View>
                        </Animated.View>
                    ))}
                </ScrollView>
            </View>
        );
    };

    return (
        <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top']}>
            <AppHeader showBack={true} showLogo={true} />

            {/* Fixed Header (Directory-style) */}
            <View style={[styles.fixedHeader, { backgroundColor: theme.card, borderBottomColor: theme.border }]}>
                <Animated.View entering={FadeInDown.duration(300)}>
                    <Text style={[styles.pageTitle, { color: theme.text }]}>⏱️ My Work Shift</Text>
                    <Text style={[styles.pageSubtitle, { color: theme.subtext }]}>Manage your schedule & team availability</Text>
                </Animated.View>
            </View>

            <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scrollContent}>

                {/* Current Shift Banner */}
                <Animated.View entering={FadeInDown.delay(100).duration(400)} style={[styles.currentShiftCard, { backgroundColor: theme.primary }]}>
                    <View style={styles.currentShiftHeader}>
                        <View style={styles.statusDot} />
                        <Text style={styles.currentShiftLabel}>CURRENTLY ACTIVE</Text>
                    </View>
                    <Text style={styles.currentShiftTime}>09:00 AM - 06:00 PM</Text>
                    <Text style={styles.currentShiftType}>General Shift • Floor 3, Zone A</Text>

                    <View style={styles.shiftProgress}>
                        <View style={[styles.progressBar, { width: '45%' }]} />
                    </View>
                    <Text style={styles.progressText}>4h 30m remaining</Text>
                </Animated.View>

                {/* Weekly Roster */}
                <View style={styles.sectionHeader}>
                    <Text style={[styles.sectionTitle, { color: theme.text }]}>
                        {viewMode === 'week' ? 'Weekly Roster' : 'Monthly Calendar'}
                    </Text>
                    <TouchableOpacity
                        style={[styles.viewToggleBtn, { backgroundColor: isDark ? '#374151' : '#F3F4F6' }]}
                        onPress={() => setViewMode(viewMode === 'week' ? 'calendar' : 'week')}
                    >
                        <Ionicons
                            name={viewMode === 'week' ? 'calendar' : 'list'}
                            size={18}
                            color={theme.primary}
                        />
                        <Text style={[styles.viewToggleText, { color: theme.primary }]}>
                            {viewMode === 'week' ? 'Calendar' : 'Week'}
                        </Text>
                    </TouchableOpacity>
                </View>

                {viewMode === 'week' ? (
                    <Animated.View entering={FadeIn.duration(400)}>
                        <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={styles.rosterScroll}>
                            {weekSchedule.map((shift, index) => (
                                <ShiftCard key={index} {...shift} theme={theme} />
                            ))}
                        </ScrollView>
                    </Animated.View>
                ) : (
                    <Animated.View entering={FadeIn.duration(400)}>
                        {/* Month Navigation */}
                        <View style={styles.monthNav}>
                            <TouchableOpacity onPress={() => changeMonth(-1)} style={[styles.navBtn, { backgroundColor: theme.card, borderColor: theme.border }]}>
                                <Ionicons name="chevron-back" size={20} color={theme.text} />
                            </TouchableOpacity>
                            <Text style={[styles.monthText, { color: theme.text }]}>
                                {MONTHS[currentMonth]} {currentYear}
                            </Text>
                            <TouchableOpacity onPress={() => changeMonth(1)} style={[styles.navBtn, { backgroundColor: theme.card, borderColor: theme.border }]}>
                                <Ionicons name="chevron-forward" size={20} color={theme.text} />
                            </TouchableOpacity>
                        </View>

                        {/* Calendar */}
                        <View style={styles.calendarContainer}>
                            <View style={styles.weekRow}>
                                {DAYS.map(d => <Text key={d} style={[styles.weekDay, { color: theme.subtext }]}>{d}</Text>)}
                            </View>
                            <View style={styles.daysGrid}>
                                {renderCalendar()}
                            </View>
                        </View>

                        {/* Legend */}
                        <View style={[styles.legendContainer, { backgroundColor: isDark ? '#1F2937' : '#F9FAFB' }]}>
                            <View style={styles.legendItem}>
                                <View style={[styles.legendDot, { backgroundColor: '#22C55E' }]} />
                                <Text style={[styles.legendText, { color: theme.subtext }]}>Scheduled</Text>
                            </View>
                            <View style={styles.legendItem}>
                                <View style={[styles.legendDot, { backgroundColor: theme.primary }]} />
                                <Text style={[styles.legendText, { color: theme.subtext }]}>Today</Text>
                            </View>
                        </View>
                    </Animated.View>
                )}

                {/* Team On Shift */}
                <View style={[styles.sectionHeader, { marginTop: 24 }]}>
                    <Text style={[styles.sectionTitle, { color: theme.text }]}>Team on Shift ({team.length})</Text>
                </View>

                <View style={styles.teamList}>
                    {team.map((member, index) => (
                        <TeamMember key={member.id} {...member} theme={theme} index={index} />
                    ))}
                </View>

            </ScrollView>

            {/* Roster Modal */}
            <Modal visible={rosterModalVisible} transparent animationType="fade" onRequestClose={() => setRosterModalVisible(false)}>
                <Pressable style={styles.modalOverlay} onPress={() => setRosterModalVisible(false)}>
                    <Animated.View entering={ZoomIn.duration(300)} style={styles.rosterModal}>
                        {renderRosterModal()}
                        <TouchableOpacity
                            style={[styles.closeModalBtn, { backgroundColor: theme.primary }]}
                            onPress={() => setRosterModalVisible(false)}
                        >
                            <Text style={styles.closeModalText}>Close</Text>
                        </TouchableOpacity>
                    </Animated.View>
                </Pressable>
            </Modal>
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1 },
    fixedHeader: {
        paddingHorizontal: 20,
        paddingTop: 16,
        paddingBottom: 12,
        borderBottomWidth: 1,
    },
    scrollContent: { paddingHorizontal: 20, paddingTop: 16, paddingBottom: 100 },
    pageTitle: { fontSize: 24, fontWeight: '700' },
    pageSubtitle: { fontSize: 14, marginTop: 4 },

    // Current Shift
    currentShiftCard: { padding: 20, borderRadius: 20, marginBottom: 16 },
    currentShiftHeader: { flexDirection: 'row', alignItems: 'center', marginBottom: 16 },
    statusDot: { width: 8, height: 8, borderRadius: 4, backgroundColor: '#4ADE80', marginRight: 8 },
    currentShiftLabel: { color: 'rgba(255,255,255,0.8)', fontSize: 12, fontWeight: '700', letterSpacing: 1 },
    currentShiftTime: { color: 'white', fontSize: 28, fontWeight: '700', marginBottom: 4 },
    currentShiftType: { color: 'rgba(255,255,255,0.9)', fontSize: 14 },
    shiftProgress: { height: 6, backgroundColor: 'rgba(255,255,255,0.2)', borderRadius: 3, marginTop: 20, marginBottom: 8 },
    progressBar: { height: '100%', backgroundColor: 'white', borderRadius: 3 },
    progressText: { color: 'rgba(255,255,255,0.8)', fontSize: 12, textAlign: 'right' },

    // Roster
    sectionHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 },
    sectionTitle: { fontSize: 18, fontWeight: '700' },
    seeAll: { fontSize: 14, fontWeight: '600' },
    rosterScroll: { paddingRight: 20, gap: 12 },
    shiftCard: { width: 100, padding: 12, borderRadius: 16, alignItems: 'center', justifyContent: 'center' },
    shiftDay: { fontSize: 12, fontWeight: '600', marginBottom: 4 },
    shiftDate: { fontSize: 14, fontWeight: '700', marginBottom: 8 },
    shiftTypeBadge: { paddingHorizontal: 8, paddingVertical: 4, borderRadius: 8, marginBottom: 8 },
    shiftType: { fontSize: 10, fontWeight: '700' },
    shiftTime: { fontSize: 10 },

    // Team
    teamList: { gap: 12 },
    teamMember: { flexDirection: 'row', alignItems: 'center', padding: 12, borderRadius: 16, borderWidth: 1 },
    teamAvatar: { width: 48, height: 48, borderRadius: 24 },
    teamInfo: { flex: 1, marginLeft: 12 },
    teamName: { fontSize: 16, fontWeight: '600' },
    teamRole: { fontSize: 13 },
    callBtn: { width: 40, height: 40, borderRadius: 20, alignItems: 'center', justifyContent: 'center' },

    // Calendar View
    viewToggleBtn: { flexDirection: 'row', alignItems: 'center', gap: 6, paddingHorizontal: 12, paddingVertical: 6, borderRadius: 12 },
    viewToggleText: { fontSize: 14, fontWeight: '600' },
    monthNav: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 16, marginBottom: 16 },
    navBtn: { padding: 8, borderRadius: 12, borderWidth: 1 },
    monthText: { fontSize: 16, fontWeight: '700', minWidth: 120, textAlign: 'center' },
    calendarContainer: { marginBottom: 16 },
    weekRow: { flexDirection: 'row', justifyContent: 'space-around', marginBottom: 12 },
    weekDay: { width: '14.28%', textAlign: 'center', fontSize: 12, fontWeight: '600' },
    daysGrid: { flexDirection: 'row', flexWrap: 'wrap' },
    dayCellContainer: { width: '14.28%', aspectRatio: 1, marginBottom: 8, padding: 2 },
    dayCell: { flex: 1, alignItems: 'center', justifyContent: 'center', borderRadius: 12, position: 'relative' },
    dayText: { fontSize: 14, fontWeight: '600' },
    selectedDay: { borderWidth: 2, borderColor: '#2563EB' },
    employeeCountBadge: { position: 'absolute', bottom: 4, backgroundColor: '#22C55E', borderRadius: 8, paddingHorizontal: 6, paddingVertical: 2 },
    employeeCountText: { color: 'white', fontSize: 9, fontWeight: '700' },
    legendContainer: { flexDirection: 'row', justifyContent: 'center', gap: 20, padding: 12, borderRadius: 12, marginTop: 8 },
    legendItem: { flexDirection: 'row', alignItems: 'center', gap: 6 },
    legendDot: { width: 10, height: 10, borderRadius: 5 },
    legendText: { fontSize: 12 },

    // Roster Modal
    modalOverlay: { flex: 1, backgroundColor: 'rgba(0,0,0,0.6)', justifyContent: 'center', alignItems: 'center', padding: 20 },
    rosterModal: { width: '100%', maxWidth: 500, maxHeight: '80%', borderRadius: 24, overflow: 'hidden' },
    rosterModalCard: { backgroundColor: 'transparent' },
    rosterModalHeader: { flexDirection: 'row', alignItems: 'center', padding: 20, backgroundColor: 'rgba(255,255,255,0.95)', borderTopLeftRadius: 24, borderTopRightRadius: 24 },
    rosterModalTitle: { fontSize: 18, fontWeight: '700' },
    rosterModalDate: { fontSize: 13, marginTop: 2 },
    rosterEmployeeCount: { flexDirection: 'row', alignItems: 'center', gap: 8, padding: 12, marginHorizontal: 20, marginTop: 12, borderRadius: 12 },
    rosterEmployeeCountText: { fontSize: 14, fontWeight: '600' },
    rosterEmployeeList: { maxHeight: 400, paddingHorizontal: 20, paddingVertical: 12, backgroundColor: 'rgba(255,255,255,0.95)' },
    rosterEmployeeCard: { flexDirection: 'row', alignItems: 'center', padding: 12, borderRadius: 16, marginBottom: 10, borderWidth: 1 },
    rosterEmployeeAvatar: { width: 44, height: 44, borderRadius: 22 },
    rosterEmployeeInfo: { flex: 1, marginLeft: 12 },
    rosterEmployeeName: { fontSize: 15, fontWeight: '600' },
    rosterEmployeeRole: { fontSize: 12, marginTop: 2 },
    rosterEmployeeTime: { fontSize: 11, marginTop: 4 },
    shiftBadge: { paddingHorizontal: 10, paddingVertical: 4, borderRadius: 8, marginBottom: 4 },
    shiftBadgeText: { fontSize: 11, fontWeight: '700' },
    closeModalBtn: { padding: 16, alignItems: 'center', borderBottomLeftRadius: 24, borderBottomRightRadius: 24 },
    closeModalText: { color: 'white', fontSize: 16, fontWeight: '700' },
});
