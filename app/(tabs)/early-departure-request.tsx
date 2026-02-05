import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, Alert, TextInput, Platform, Image, Modal } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Colors } from '../../constants/Colors';
import { Ionicons } from '@expo/vector-icons';
import Animated, {
    FadeInDown,
    useSharedValue,
    useAnimatedStyle,
    withSpring,
    withSequence,
    withTiming,
    LayoutAnimationConfig,
} from 'react-native-reanimated';
import { router } from 'expo-router';
import DateTimePicker from '@react-native-community/datetimepicker';
import AppHeader from '../../components/AppHeader';
import { useTheme } from '../../context/ThemeContext';

// --- Filter Modal ---
const SelectionModal = ({ visible, onClose, title, options, onSelect, theme }: any) => (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onClose}>
        <View style={styles.modalOverlay}>
            <View style={[styles.modalContent, { backgroundColor: theme.card, borderColor: theme.border }]}>
                <View style={styles.modalHeader}>
                    <Text style={[styles.modalTitle, { color: theme.text }]}>{title}</Text>
                    <TouchableOpacity onPress={onClose} style={styles.modalCloseBtn}>
                        <Ionicons name="close" size={20} color={theme.subtext} />
                    </TouchableOpacity>
                </View>
                <ScrollView style={{ maxHeight: 300 }}>
                    {options.map((option: string) => (
                        <TouchableOpacity
                            key={option}
                            style={[styles.modalOption, { borderBottomColor: theme.border }]}
                            onPress={() => { onSelect(option); onClose(); }}
                        >
                            <Text style={[styles.modalOptionText, { color: theme.text }]}>{option}</Text>
                        </TouchableOpacity>
                    ))}
                </ScrollView>
            </View>
        </View>
    </Modal>
);

// --- Components ---

const TabSelector = ({ activeTab, onSelect, theme }: any) => (
    <View style={[styles.tabContainer, { backgroundColor: theme.card, borderColor: theme.border }]}>
        <TouchableOpacity
            style={[styles.tabButton, activeTab === 'request' && { backgroundColor: theme.primary }]}
            onPress={() => onSelect('request')}
            activeOpacity={0.8}
        >
            <Text style={[styles.tabText, { color: activeTab === 'request' ? 'white' : theme.subtext }]}>New Request</Text>
        </TouchableOpacity>
        <TouchableOpacity
            style={[styles.tabButton, activeTab === 'reports' && { backgroundColor: theme.primary }]}
            onPress={() => onSelect('reports')}
            activeOpacity={0.8}
        >
            <Text style={[styles.tabText, { color: activeTab === 'reports' ? 'white' : theme.subtext }]}>Reports</Text>
        </TouchableOpacity>
    </View>
);

const PickerButton = ({ label, value, onPress, theme, icon = "calendar" }: any) => (
    <TouchableOpacity
        style={[styles.pickerButton, { backgroundColor: theme.card, borderColor: theme.border }]}
        onPress={onPress}
    >
        <View style={styles.pickerContent}>
            <Ionicons name={icon as any} size={20} color={theme.primary} />
            <View>
                <Text style={[styles.pickerLabel, { color: theme.subtext }]}>{label}</Text>
                <Text style={[styles.pickerValue, { color: theme.text }]}>{value}</Text>
            </View>
        </View>
        <Ionicons name="chevron-forward" size={20} color={theme.subtext} />
    </TouchableOpacity>
);

const FormSection = ({ title, children, delay = 0, theme }: any) => (
    <Animated.View entering={FadeInDown.delay(delay).duration(400)} style={styles.formSection}>
        <Text style={[styles.sectionLabel, { color: theme.subtext }]}>{title}</Text>
        {children}
    </Animated.View>
);

const ReportCard = ({ item, theme, index }: any) => {
    let statusColor = '#F59E0B'; // Pending
    let statusBg = '#FEF3C7';

    if (item.status === 'Approved') { statusColor = '#10B981'; statusBg = '#D1FAE5'; }
    if (item.status === 'Rejected') { statusColor = '#EF4444'; statusBg = '#FEE2E2'; }

    return (
        <Animated.View entering={FadeInDown.delay(index * 100).duration(400)} style={[styles.reportCard, { backgroundColor: theme.card, borderColor: theme.border }]}>
            <View style={styles.reportHeader}>
                <View style={[styles.reportDateBadge, { backgroundColor: theme.text + '10' }]}>
                    <Text style={[styles.reportMonth, { color: theme.text }]}>{new Date(item.date).toLocaleDateString('en-US', { month: 'short' })}</Text>
                    <Text style={[styles.reportDay, { color: theme.text }]}>{new Date(item.date).getDate()}</Text>
                </View>
                <View style={{ flex: 1, marginLeft: 12 }}>
                    <Text style={[styles.reportTitle, { color: theme.text }]}>Early Departure</Text>
                    <Text style={[styles.reportTime, { color: theme.subtext }]}>Departure: {item.time}</Text>
                </View>
                <View style={[styles.statusBadge, { backgroundColor: statusBg }]}>
                    <Text style={[styles.statusText, { color: statusColor }]}>{item.status}</Text>
                </View>
            </View>
            <View style={[styles.divider, { backgroundColor: theme.border }]} />
            <Text style={[styles.reportReason, { color: theme.text }]} numberOfLines={2}>Reason: {item.reason}</Text>
        </Animated.View>
    );
};

// --- Main Screen ---
export default function EarlyDepartureRequestScreen() {
    const { isDark } = useTheme();
    const theme = Colors[isDark ? 'dark' : 'light'];
    const [activeTab, setActiveTab] = useState('request');

    // Form State
    const [departureDate, setDepartureDate] = useState(new Date());
    const [departureTime, setDepartureTime] = useState(new Date());
    const [reason, setReason] = useState('');
    const [showDatePicker, setShowDatePicker] = useState(false);
    const [showTimePicker, setShowTimePicker] = useState(false);
    const [loading, setLoading] = useState(false);

    // Filter State
    const [filterMonth, setFilterMonth] = useState('February');
    const [filterYear, setFilterYear] = useState('2026');
    const [filterStatus, setFilterStatus] = useState('All');

    // Modal State
    const [modalVisible, setModalVisible] = useState(false);
    const [modalType, setModalType] = useState<null | 'month' | 'year' | 'status'>(null);

    const MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    const YEARS = ['2024', '2025', '2026'];
    const STATUSES = ['All', 'Pending', 'Approved', 'Rejected'];

    const openFilterModal = (type: 'month' | 'year' | 'status') => {
        setModalType(type);
        setModalVisible(true);
    };

    const getModalOptions = () => {
        switch (modalType) {
            case 'month': return MONTHS;
            case 'year': return YEARS;
            case 'status': return STATUSES;
            default: return [];
        }
    };

    const handleFilterSelect = (value: string) => {
        if (modalType === 'month') setFilterMonth(value);
        if (modalType === 'year') setFilterYear(value);
        if (modalType === 'status') setFilterStatus(value);
    };

    const getModalTitle = () => {
        switch (modalType) {
            case 'month': return 'Select Month';
            case 'year': return 'Select Year';
            case 'status': return 'Filter by Status';
            default: return '';
        }
    };

    // Mock Data
    const REPORTS = [
        { id: 1, date: '2026-02-02', time: '04:00 PM', reason: 'Medical emergency', status: 'Approved' },
        { id: 2, date: '2026-01-20', time: '03:30 PM', reason: 'Bank work', status: 'Rejected' },
        { id: 3, date: '2026-01-15', time: '05:00 PM', reason: 'Family event', status: 'Pending' },
    ];

    const handleDateChange = (event: any, date?: Date) => {
        setShowDatePicker(Platform.OS === 'ios');
        if (date) setDepartureDate(date);
    };

    const handleTimeChange = (event: any, date?: Date) => {
        setShowTimePicker(Platform.OS === 'ios');
        if (date) setDepartureTime(date);
    };

    const handleSubmit = () => {
        if (!reason.trim()) {
            Alert.alert("Missing Information", "Please provide a purpose for early departure.");
            return;
        }
        setLoading(true);
        setTimeout(() => {
            setLoading(false);
            Alert.alert("Request Submitted", "Your early departure request has been submitted.");
            setReason('');
        }, 1500);
    };

    return (
        <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top']}>
            <AppHeader showBack={true} showLogo={true} showMenu={false} showLogout={false} showNotification={false} />

            {/* Page Title & Tab Switcher */}
            <View style={[styles.headerContainer, { backgroundColor: theme.background, borderColor: theme.border }]}>
                <Text style={[styles.pageTitle, { color: theme.text }]}>🏃 Early Departure</Text>
                <TabSelector activeTab={activeTab} onSelect={setActiveTab} theme={theme} />
            </View>

            <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scrollContent}>

                {activeTab === 'request' ? (
                    <Animated.View entering={FadeInDown.duration(300)}>
                        {/* Request Form */}
                        <FormSection title="Departure Details" delay={100} theme={theme}>
                            <View style={{ gap: 12 }}>
                                <PickerButton
                                    label="Departure Date"
                                    value={departureDate.toLocaleDateString()}
                                    onPress={() => setShowDatePicker(true)}
                                    theme={theme}
                                />
                                <PickerButton
                                    label="Departure Time"
                                    value={departureTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                                    onPress={() => setShowTimePicker(true)}
                                    theme={theme}
                                    icon="time-outline"
                                />
                            </View>
                        </FormSection>

                        {showDatePicker && (
                            <DateTimePicker value={departureDate} mode="date" display={Platform.OS === 'ios' ? 'spinner' : 'default'} onChange={handleDateChange} minimumDate={new Date()} />
                        )}
                        {showTimePicker && (
                            <DateTimePicker value={departureTime} mode="time" display={Platform.OS === 'ios' ? 'spinner' : 'default'} onChange={handleTimeChange} />
                        )}

                        <FormSection title="Purpose" delay={200} theme={theme}>
                            <TextInput
                                style={[styles.textInput, { backgroundColor: theme.card, borderColor: theme.border, color: theme.text }]}
                                placeholder="State the reason for early departure..."
                                placeholderTextColor={theme.subtext}
                                value={reason}
                                onChangeText={setReason}
                                multiline
                            />
                        </FormSection>

                        <View style={styles.submitContainer}>
                            <TouchableOpacity
                                style={[styles.submitButton, { backgroundColor: '#F97316' }]} // Orange
                                onPress={handleSubmit}
                                activeOpacity={0.9}
                            >
                                {loading ? <Ionicons name="reload" size={24} color="white" /> : <Text style={styles.submitButtonText}>Submit Request</Text>}
                            </TouchableOpacity>
                        </View>
                    </Animated.View>
                ) : (
                    <Animated.View entering={FadeInDown.duration(300)}>
                        {/* Filters */}
                        <View style={styles.filterRow}>
                            {/* Mock Filters - In a real app these would be dropdowns */}
                            <TouchableOpacity
                                style={[styles.filterChip, { backgroundColor: theme.card, borderColor: theme.border }]}
                                onPress={() => openFilterModal('month')}
                            >
                                <Text style={{ color: theme.text }}>{filterMonth}</Text>
                                <Ionicons name="chevron-down" size={12} color={theme.subtext} />
                            </TouchableOpacity>
                            <TouchableOpacity
                                style={[styles.filterChip, { backgroundColor: theme.card, borderColor: theme.border }]}
                                onPress={() => openFilterModal('year')}
                            >
                                <Text style={{ color: theme.text }}>{filterYear}</Text>
                                <Ionicons name="chevron-down" size={12} color={theme.subtext} />
                            </TouchableOpacity>
                            <TouchableOpacity
                                style={[styles.filterChip, { backgroundColor: theme.card, borderColor: theme.border }]}
                                onPress={() => openFilterModal('status')}
                            >
                                <Text style={{ color: theme.text }}>{filterStatus}</Text>
                                <Ionicons name="chevron-down" size={12} color={theme.subtext} />
                            </TouchableOpacity>
                        </View>

                        {/* Reports List */}
                        <View style={styles.listContainer}>
                            {REPORTS.map((item, index) => (
                                <ReportCard key={item.id} item={item} index={index} theme={theme} />
                            ))}
                        </View>
                    </Animated.View>
                )}

            </ScrollView>

            <SelectionModal
                visible={modalVisible}
                onClose={() => setModalVisible(false)}
                title={getModalTitle()}
                options={getModalOptions()}
                onSelect={handleFilterSelect}
                theme={theme}
            />
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1 },
    headerContainer: { padding: 20, paddingBottom: 10 },
    pageTitle: { fontSize: 24, fontWeight: '800', marginBottom: 16 },
    tabContainer: { flexDirection: 'row', borderRadius: 12, padding: 4, borderWidth: 1 },
    tabButton: { flex: 1, paddingVertical: 10, alignItems: 'center', borderRadius: 8 },
    tabText: { fontWeight: '600', fontSize: 14 },

    scrollContent: { paddingBottom: 100 },
    formSection: { paddingHorizontal: 20, marginTop: 24 },
    sectionLabel: { fontSize: 12, fontWeight: '600', marginBottom: 10, textTransform: 'uppercase', letterSpacing: 0.5 },

    pickerButton: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 14, borderRadius: 12, borderWidth: 1 },
    pickerContent: { flexDirection: 'row', alignItems: 'center', gap: 10 },
    pickerLabel: { fontSize: 11 },
    pickerValue: { fontSize: 14, fontWeight: '600' },

    textInput: { padding: 16, borderRadius: 12, borderWidth: 1, fontSize: 15, minHeight: 120, textAlignVertical: 'top' },

    submitContainer: { paddingHorizontal: 20, marginTop: 32 },
    submitButton: { paddingVertical: 16, borderRadius: 14, alignItems: 'center', shadowColor: '#F97316', shadowOffset: { width: 0, height: 4 }, shadowOpacity: 0.3, shadowRadius: 8, elevation: 8 },
    submitButtonText: { color: 'white', fontSize: 16, fontWeight: '700' },

    // Reports Styles
    filterRow: { flexDirection: 'row', paddingHorizontal: 20, marginTop: 20, gap: 10 },
    filterChip: { flexDirection: 'row', alignItems: 'center', gap: 6, paddingHorizontal: 12, paddingVertical: 8, borderRadius: 20, borderWidth: 1 },

    listContainer: { padding: 20, gap: 12 },
    reportCard: { borderRadius: 16, padding: 16, borderWidth: 1 },
    reportHeader: { flexDirection: 'row', alignItems: 'center' },
    reportDateBadge: { alignItems: 'center', padding: 8, borderRadius: 8, minWidth: 50 },
    reportMonth: { fontSize: 10, fontWeight: '700', textTransform: 'uppercase' },
    reportDay: { fontSize: 18, fontWeight: '800' },
    reportTitle: { fontSize: 16, fontWeight: '700' },
    reportTime: { fontSize: 12, marginTop: 2 },
    statusBadge: { paddingHorizontal: 8, paddingVertical: 4, borderRadius: 6 },
    statusText: { fontSize: 10, fontWeight: '800', textTransform: 'uppercase' },
    divider: { height: 1, marginVertical: 12, opacity: 0.5 },
    reportReason: { fontSize: 13, lineHeight: 18 },

    // Modal Styles
    modalOverlay: { flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', padding: 20 },
    modalContent: { borderRadius: 16, maxHeight: 400, overflow: 'hidden', borderWidth: 1 },
    modalHeader: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 16, borderBottomWidth: 1, borderBottomColor: '#eee' },
    modalTitle: { fontSize: 16, fontWeight: '700' },
    modalCloseBtn: { padding: 4 },
    modalOption: { padding: 16, borderBottomWidth: 1 },
    modalOptionText: { fontSize: 16 },
});
