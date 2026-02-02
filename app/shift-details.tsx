import React from 'react';
import { View, Text, StyleSheet, ScrollView, Image, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Colors } from '../constants/Colors';
import { Ionicons } from '@expo/vector-icons';
import Animated, { FadeInDown, FadeInRight } from 'react-native-reanimated';
import AppHeader from '../components/AppHeader';
import { useTheme } from '../context/ThemeContext';

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
                    <Text style={[styles.sectionTitle, { color: theme.text }]}>Weekly Roster</Text>
                    <TouchableOpacity>
                        <Text style={[styles.seeAll, { color: theme.primary }]}>View Month</Text>
                    </TouchableOpacity>
                </View>

                <Animated.View entering={FadeInDown.delay(200).duration(400)}>
                    <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={styles.rosterScroll}>
                        {weekSchedule.map((shift, index) => (
                            <ShiftCard key={index} {...shift} theme={theme} />
                        ))}
                    </ScrollView>
                </Animated.View>

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
});
