import React, { useState } from 'react';
import { View, Text, Image, TouchableOpacity, ScrollView, StyleSheet, Switch, Alert, Pressable, Modal, TextInput } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import * as ImagePicker from 'expo-image-picker';
import { useTheme } from '../../context/ThemeContext';
import { usePrayerSettings } from '../../context/PrayerSettingsContext';
import { useAuth } from '../../context/AuthContext';
import AppHeader from '../../components/AppHeader';
import Animated, { FadeIn, FadeInDown, FadeInUp, FadeInLeft, FadeInRight, ZoomIn } from 'react-native-reanimated';

const MENU_ITEMS = [
    { id: 'personal', icon: 'person-outline', label: 'Personal Information', screen: 'profile/personal-info' },
    { id: 'documents', icon: 'document-text-outline', label: 'My Documents', screen: 'profile/documents' },
    { id: 'bank', icon: 'card-outline', label: 'Bank Details', screen: 'profile/bank-details' },
    { id: 'emergency', icon: 'call-outline', label: 'Emergency Contacts', screen: 'profile/emergency' },
];

export default function ProfileScreen() {
    const router = useRouter();
    const { theme, isDark, setTheme } = useTheme();
    const { user, logout } = useAuth();
    const {
        showUpcomingPrayerTimes,
        enablePrayerTimeNotifications,
        setShowUpcomingPrayerTimes,
        setEnablePrayerTimeNotifications,
    } = usePrayerSettings();

    // State
    const [phone, setPhone] = useState('+880 1712 345678');
    const [notificationsEnabled, setNotificationsEnabled] = useState(true);
    const [biometricEnabled, setBiometricEnabled] = useState(false);

    // Generate initials from employee name
    const getInitials = (name: string) => {
        if (!name) return 'U';
        return name
            .split(' ')
            .map(n => n[0])
            .join('')
            .substring(0, 2)
            .toUpperCase();
    };

    // Edit Modal State
    const [isEditModalVisible, setEditModalVisible] = useState(false);
    const [tempPhone, setTempPhone] = useState(phone);

    // Theme Helpers
    const styles = getStyles(isDark);
    const iconColor = isDark ? '#60A5FA' : '#2563EB';
    const textColor = isDark ? '#E5E5E5' : '#171717';
    const subTextColor = isDark ? '#A3A3A3' : '#737373';
    const cardBg = isDark ? '#1F2937' : 'white';

    const handleAvatarChange = async () => {
        Alert.alert('Change Avatar', 'Photo upload feature coming soon!');
    };

    const handleLogout = () => {
        Alert.alert('Logout', 'Are you sure you want to logout?', [
            { text: 'Cancel', style: 'cancel' },
            {
                text: 'Logout',
                style: 'destructive',
                onPress: async () => {
                    await logout();
                    // AuthContext handles navigation to login
                }
            },
        ]);
    };

    const toggleTheme = (value: boolean) => {
        setTheme(value ? 'dark' : 'light');
    };

    return (
        <SafeAreaView style={styles.container} edges={['top']}>
            {/* Consistent Header */}
            <AppHeader />

            <ScrollView showsVerticalScrollIndicator={false}>
                {/* Page Title Row */}
                <Animated.View entering={FadeInDown.duration(300)} style={styles.titleRow}>
                    <Text style={styles.headerTitle}>Profile</Text>
                    <TouchableOpacity onPress={() => console.log('Edit Profile')}>
                        <Ionicons name="create-outline" size={24} color={iconColor} />
                    </TouchableOpacity>
                </Animated.View>

                {/* Profile Card */}
                <Animated.View entering={FadeInDown.delay(100).duration(400)} style={styles.profileCard}>
                    <TouchableOpacity onPress={handleAvatarChange} style={styles.avatarContainer}>
                        {user?.photoPath ? (
                            <Image source={{ uri: user.photoPath }} style={styles.avatar} />
                        ) : (
                            <View style={[styles.avatar, styles.avatarPlaceholder]}>
                                <Text style={styles.avatarInitials}>{getInitials(user?.employeeName || 'User')}</Text>
                            </View>
                        )}
                        <View style={styles.cameraBadge}>
                            <Ionicons name="camera" size={12} color="white" />
                        </View>
                    </TouchableOpacity>
                    <Text style={styles.name}>{user?.employeeName || 'User'}</Text>
                    <Text style={styles.designation}>{user?.designationName || 'Employee'}</Text>
                    <View style={styles.badgeRow}>
                        <View style={styles.badge}>
                            <Ionicons name="briefcase-outline" size={14} color={iconColor} />
                            <Text style={styles.badgeText}>{user?.departmentName || 'Department'}</Text>
                        </View>
                        <View style={styles.badge}>
                            <Ionicons name="id-card-outline" size={14} color={iconColor} />
                            <Text style={styles.badgeText}>{user?.employeeCode || 'ID'}</Text>
                        </View>
                    </View>
                </Animated.View>

                {/* Quick Info */}
                <Animated.View entering={FadeInLeft.delay(200).duration(400)} style={styles.section}>
                    <View style={styles.infoItem}>
                        <Ionicons name="mail-outline" size={20} color={subTextColor} />
                        <Text style={styles.infoText}>{user?.username || 'user@example.com'}</Text>
                    </View>
                    <TouchableOpacity style={styles.infoItem} onPress={() => { setTempPhone(phone); setEditModalVisible(true); }}>
                        <Ionicons name="call-outline" size={20} color={subTextColor} />
                        <Text style={styles.infoText}>{phone}</Text>
                        <Ionicons name="pencil-outline" size={14} color={iconColor} style={{ marginLeft: 4 }} />
                    </TouchableOpacity>
                    <View style={styles.infoItem}>
                        <Ionicons name="location-outline" size={20} color={subTextColor} />
                        <Text style={styles.infoText}>{user?.branchName || 'Office Location'}</Text>
                    </View>
                </Animated.View>

                {/* Menu Section */}
                <Animated.View entering={FadeInUp.delay(300).duration(500)} style={styles.sectionContainer}>
                    <Text style={styles.sectionTitle}>Account</Text>
                    {MENU_ITEMS.map((item, index) => (
                        <Animated.View key={item.id} entering={FadeInRight.delay(400 + (index * 50)).duration(400)}>
                            <TouchableOpacity style={styles.menuItem} onPress={() => router.push(item.screen as any)}>
                                <View style={styles.menuIconWrapper}>
                                    <Ionicons name={item.icon as any} size={20} color={iconColor} />
                                </View>
                                <Text style={styles.menuLabel}>{item.label}</Text>
                                <Ionicons name="chevron-forward" size={20} color={subTextColor} />
                            </TouchableOpacity>
                        </Animated.View>
                    ))}
                </Animated.View>

                {/* Settings Section */}
                <Animated.View entering={FadeInUp.delay(500).duration(500)} style={styles.sectionContainer}>
                    <Text style={styles.sectionTitle}>Settings</Text>

                    <View style={styles.menuItem}>
                        <View style={styles.menuIconWrapper}><Ionicons name="notifications-outline" size={20} color={subTextColor} /></View>
                        <Text style={styles.menuLabel}>Push Notifications</Text>
                        <Switch value={notificationsEnabled} onValueChange={setNotificationsEnabled} trackColor={{ false: '#E5E5E5', true: '#93C5FD' }} thumbColor={notificationsEnabled ? '#2563EB' : '#A3A3A3'} />
                    </View>

                    <View style={styles.menuItem}>
                        <View style={styles.menuIconWrapper}><Ionicons name="finger-print-outline" size={20} color={subTextColor} /></View>
                        <Text style={styles.menuLabel}>Biometric Login</Text>
                        <Switch value={biometricEnabled} onValueChange={setBiometricEnabled} trackColor={{ false: '#E5E5E5', true: '#93C5FD' }} thumbColor={biometricEnabled ? '#2563EB' : '#A3A3A3'} />
                    </View>

                    <View style={styles.menuItem}>
                        <View style={styles.menuIconWrapper}><Ionicons name="moon-outline" size={20} color={subTextColor} /></View>
                        <Text style={styles.menuLabel}>Dark Mode</Text>
                        <Switch value={isDark} onValueChange={toggleTheme} trackColor={{ false: '#E5E5E5', true: '#93C5FD' }} thumbColor={isDark ? '#2563EB' : '#A3A3A3'} />
                    </View>

                    <View style={styles.menuItem}>
                        <View style={styles.menuIconWrapper}><Ionicons name="time-outline" size={20} color={subTextColor} /></View>
                        <Text style={styles.menuLabel}>Show Upcoming Prayer time</Text>
                        <Switch
                            value={showUpcomingPrayerTimes}
                            onValueChange={setShowUpcomingPrayerTimes}
                            trackColor={{ false: '#E5E5E5', true: '#93C5FD' }}
                            thumbColor={showUpcomingPrayerTimes ? '#2563EB' : '#A3A3A3'}
                        />
                    </View>

                    <View style={styles.menuItem}>
                        <View style={styles.menuIconWrapper}><Ionicons name="notifications-outline" size={20} color={subTextColor} /></View>
                        <Text style={[styles.menuLabel, !showUpcomingPrayerTimes && { color: isDark ? '#6B7280' : '#A3A3A3' }]}>Enable Prayer time Notification</Text>
                        <Switch
                            value={enablePrayerTimeNotifications}
                            onValueChange={setEnablePrayerTimeNotifications}
                            disabled={!showUpcomingPrayerTimes}
                            trackColor={{ false: '#E5E5E5', true: '#93C5FD' }}
                            thumbColor={
                                !showUpcomingPrayerTimes
                                    ? (isDark ? '#6B7280' : '#D4D4D4')
                                    : (enablePrayerTimeNotifications ? '#2563EB' : '#A3A3A3')
                            }
                        />
                    </View>
                </Animated.View>

                {/* Logout */}
                <Animated.View entering={FadeInUp.delay(600).duration(500)}>
                    <TouchableOpacity style={styles.logoutButton} onPress={handleLogout}>
                        <Ionicons name="log-out-outline" size={20} color="#EF4444" />
                        <Text style={styles.logoutText}>Logout</Text>
                    </TouchableOpacity>
                </Animated.View>

                <Text style={styles.versionText}>HRMS App v1.0.0</Text>
                <View style={{ height: 100 }} />
            </ScrollView>

            {/* Edit Phone Modal */}
            <Modal visible={isEditModalVisible} transparent animationType="fade" onRequestClose={() => setEditModalVisible(false)}>
                <Pressable style={styles.modalOverlay} onPress={() => setEditModalVisible(false)}>
                    <Animated.View entering={ZoomIn.duration(300)} style={styles.modalContent}>
                        <Text style={styles.modalTitle}>Edit Phone Number</Text>
                        <TextInput
                            style={styles.input}
                            value={tempPhone}
                            onChangeText={setTempPhone}
                            keyboardType="phone-pad"
                            placeholder="+880 1..."
                        />
                        <View style={styles.modalActions}>
                            <TouchableOpacity onPress={() => setEditModalVisible(false)}><Text style={styles.cancelText}>Cancel</Text></TouchableOpacity>
                            <TouchableOpacity onPress={() => { setPhone(tempPhone); setEditModalVisible(false); }}><Text style={styles.saveText}>Save</Text></TouchableOpacity>
                        </View>
                    </Animated.View>
                </Pressable>
            </Modal>
        </SafeAreaView>
    );
}

const getStyles = (isDark: boolean) => StyleSheet.create({
    container: { flex: 1, backgroundColor: isDark ? '#111827' : '#FAFAFA' },
    titleRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: 20, paddingVertical: 12 },
    header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: 20, paddingVertical: 16, backgroundColor: isDark ? '#1F2937' : 'white', borderBottomWidth: 1, borderBottomColor: isDark ? '#374151' : '#F5F5F5' },
    headerTitle: { fontSize: 20, fontWeight: 'bold', color: isDark ? '#F9FAFB' : '#171717' },
    profileCard: { alignItems: 'center', paddingVertical: 24, backgroundColor: isDark ? '#1F2937' : 'white', marginBottom: 8 },
    avatarContainer: { position: 'relative', marginBottom: 12 },
    avatar: { width: 100, height: 100, borderRadius: 50, backgroundColor: '#F5F5F5' },
    avatarPlaceholder: {
        backgroundColor: isDark ? '#374151' : '#E5E7EB',
        alignItems: 'center',
        justifyContent: 'center'
    },
    avatarInitials: {
        fontSize: 36,
        fontWeight: 'bold',
        color: isDark ? '#60A5FA' : '#2563EB'
    },
    cameraBadge: { position: 'absolute', bottom: 0, right: 0, backgroundColor: '#2563EB', padding: 6, borderRadius: 12, borderWidth: 2, borderColor: isDark ? '#1F2937' : 'white' },
    name: { fontSize: 20, fontWeight: 'bold', color: isDark ? '#F9FAFB' : '#171717' },
    designation: { fontSize: 14, color: isDark ? '#9CA3AF' : '#737373', marginTop: 4 },
    badgeRow: { flexDirection: 'row', gap: 12, marginTop: 12 },
    badge: { flexDirection: 'row', alignItems: 'center', gap: 6, backgroundColor: isDark ? 'rgba(37, 99, 235, 0.2)' : '#EFF6FF', paddingHorizontal: 12, paddingVertical: 6, borderRadius: 16 },
    badgeText: { fontSize: 12, color: '#2563EB', fontWeight: '500' },
    section: { backgroundColor: isDark ? '#1F2937' : 'white', marginBottom: 8, paddingHorizontal: 20, paddingVertical: 16 },
    infoItem: { flexDirection: 'row', alignItems: 'center', gap: 12, marginBottom: 12 },
    infoText: { fontSize: 14, color: isDark ? '#D1D5DB' : '#525252' },
    sectionContainer: { backgroundColor: isDark ? '#1F2937' : 'white', marginBottom: 8, paddingVertical: 8 },
    sectionTitle: { fontSize: 12, fontWeight: '600', color: isDark ? '#9CA3AF' : '#A3A3A3', textTransform: 'uppercase', paddingHorizontal: 20, paddingVertical: 8 },
    menuItem: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 20, paddingVertical: 14, gap: 12 },
    menuIconWrapper: { width: 36, height: 36, borderRadius: 8, backgroundColor: isDark ? '#374151' : '#F5F5F5', alignItems: 'center', justifyContent: 'center' },
    menuLabel: { flex: 1, fontSize: 15, color: isDark ? '#F9FAFB' : '#171717' },
    logoutButton: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 8, marginHorizontal: 20, marginTop: 16, paddingVertical: 14, borderRadius: 12, borderWidth: 1, borderColor: '#FEE2E2', backgroundColor: isDark ? 'rgba(239, 68, 68, 0.1)' : '#FEF2F2' },
    logoutText: { fontSize: 16, fontWeight: '600', color: '#EF4444' },
    versionText: { textAlign: 'center', color: '#A3A3A3', fontSize: 12, marginTop: 16 },
    // Modal
    modalOverlay: { flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', alignItems: 'center' },
    modalContent: { backgroundColor: isDark ? '#1F2937' : 'white', borderRadius: 16, padding: 20, width: '80%' },
    modalTitle: { fontSize: 18, fontWeight: 'bold', marginBottom: 16, color: isDark ? '#F9FAFB' : '#171717' },
    input: { backgroundColor: isDark ? '#374151' : '#F5F5F5', color: isDark ? 'white' : 'black', borderRadius: 8, padding: 12, marginBottom: 16 },
    modalActions: { flexDirection: 'row', justifyContent: 'flex-end', gap: 20 },
    cancelText: { color: isDark ? '#9CA3AF' : '#737373', fontWeight: '600' },
    saveText: { color: '#2563EB', fontWeight: 'bold' }
});
