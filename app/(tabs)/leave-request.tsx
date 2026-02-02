import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, Alert, TextInput, Platform } from 'react-native';
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
} from 'react-native-reanimated';
import { router } from 'expo-router';
import DateTimePicker from '@react-native-community/datetimepicker';
import AppHeader from '../../components/AppHeader';
import { useTheme } from '../../context/ThemeContext';

// Leave Type Selector
const LeaveTypeSelector = ({ selected, onSelect, theme }: any) => {
    const types = [
        { id: 'casual', label: 'Casual', icon: 'sunny', color: '#F59E0B' },
        { id: 'sick', label: 'Sick', icon: 'medkit', color: '#EF4444' },
        { id: 'annual', label: 'Annual', icon: 'airplane', color: '#3B82F6' },
    ];

    return (
        <View style={styles.typeGrid}>
            {types.map((type) => (
                <TouchableOpacity
                    key={type.id}
                    style={[
                        styles.typeCard,
                        { backgroundColor: theme.card, borderColor: selected === type.id ? type.color : theme.border },
                        selected === type.id && { borderWidth: 2 }
                    ]}
                    onPress={() => onSelect(type.id)}
                >
                    <View style={[styles.typeIcon, { backgroundColor: type.color + '20' }]}>
                        <Ionicons name={type.icon as any} size={24} color={type.color} />
                    </View>
                    <Text style={[styles.typeLabel, { color: theme.text }]}>{type.label}</Text>
                </TouchableOpacity>
            ))}
        </View>
    );
};

// Date Picker Button
const DatePickerButton = ({ label, value, onPress, theme }: any) => (
    <TouchableOpacity
        style={[styles.dateButton, { backgroundColor: theme.card, borderColor: theme.border }]}
        onPress={onPress}
    >
        <View style={styles.dateContent}>
            <Ionicons name="calendar" size={20} color={theme.primary} />
            <View>
                <Text style={[styles.dateLabel, { color: theme.subtext }]}>{label}</Text>
                <Text style={[styles.dateValue, { color: theme.text }]}>{value}</Text>
            </View>
        </View>
        <Ionicons name="chevron-forward" size={20} color={theme.subtext} />
    </TouchableOpacity>
);

// Form Section
const FormSection = ({ title, children, delay = 0, theme }: any) => (
    <Animated.View entering={FadeInDown.delay(delay).duration(400)} style={styles.formSection}>
        <Text style={[styles.sectionLabel, { color: theme.subtext }]}>{title}</Text>
        {children}
    </Animated.View>
);

// --- Main Screen ---
export default function LeaveRequestScreen() {
    const { isDark } = useTheme();
    const theme = Colors[isDark ? 'dark' : 'light'];

    const [leaveType, setLeaveType] = useState('casual');
    const [startDate, setStartDate] = useState(new Date());
    const [endDate, setEndDate] = useState(new Date(Date.now() + 2 * 24 * 60 * 60 * 1000)); // 2 days from now
    const [showStartPicker, setShowStartPicker] = useState(false);
    const [showEndPicker, setShowEndPicker] = useState(false);
    const [reason, setReason] = useState('');
    const [loading, setLoading] = useState(false);

    const scale = useSharedValue(1);
    const animatedStyle = useAnimatedStyle(() => ({
        transform: [{ scale: scale.value }],
    }));

    const formatDate = (date: Date) => {
        return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
    };

    const handleStartDateChange = (event: any, date?: Date) => {
        setShowStartPicker(Platform.OS === 'ios');
        if (date) {
            setStartDate(date);
            if (date > endDate) {
                setEndDate(date);
            }
        }
    };

    const handleEndDateChange = (event: any, date?: Date) => {
        setShowEndPicker(Platform.OS === 'ios');
        if (date) {
            setEndDate(date);
        }
    };

    const calculateDays = () => {
        const diff = endDate.getTime() - startDate.getTime();
        return Math.ceil(diff / (1000 * 60 * 60 * 24)) + 1;
    };

    const handleSubmit = () => {
        scale.value = withSequence(withTiming(0.95, { duration: 100 }), withSpring(1));
        setLoading(true);
        setTimeout(() => {
            setLoading(false);
            Alert.alert(
                "✅ Leave Request Submitted!",
                `Your ${leaveType} leave from ${formatDate(startDate)} to ${formatDate(endDate)} has been submitted for approval.`,
                [{ text: "OK", onPress: () => router.back() }]
            );
        }, 1500);
    };

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    return (
        <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top']}>
            {/* Header */}
            <AppHeader showBack={true} showLogo={true} showMenu={false} showLogout={false} showNotification={false} />

            <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scrollContent}>

                {/* Page Title */}
                <Animated.View entering={FadeInDown.duration(300)} style={{ paddingHorizontal: 20, marginTop: 10, marginBottom: 10, backgroundColor: theme.card, borderBottomWidth: 1, borderBottomColor: theme.border }}>
                    <Text style={[styles.headerTitle, { color: theme.text }]}>📅 Apply Leave</Text>
                </Animated.View>

                {/* Leave Type */}
                <FormSection title="Leave Type" delay={100} theme={theme}>
                    <LeaveTypeSelector selected={leaveType} onSelect={setLeaveType} theme={theme} />
                </FormSection>

                {/* Date Range */}
                <FormSection title="Duration" delay={200} theme={theme}>
                    <View style={styles.dateRow}>
                        <DatePickerButton
                            label="Start Date"
                            value={formatDate(startDate)}
                            onPress={() => setShowStartPicker(true)}
                            theme={theme}
                        />
                        <DatePickerButton
                            label="End Date"
                            value={formatDate(endDate)}
                            onPress={() => setShowEndPicker(true)}
                            theme={theme}
                        />
                    </View>
                    <View style={[styles.durationBadge, { backgroundColor: theme.primary + '15' }]}>
                        <Text style={[styles.durationText, { color: theme.primary }]}>📆 {calculateDays()} day(s)</Text>
                    </View>
                </FormSection>

                {showStartPicker && (
                    <DateTimePicker
                        value={startDate}
                        mode="date"
                        display={Platform.OS === 'ios' ? 'spinner' : 'default'}
                        onChange={handleStartDateChange}
                        minimumDate={today}
                    />
                )}

                {showEndPicker && (
                    <DateTimePicker
                        value={endDate}
                        mode="date"
                        display={Platform.OS === 'ios' ? 'spinner' : 'default'}
                        onChange={handleEndDateChange}
                        minimumDate={startDate}
                    />
                )}

                {/* Reason */}
                <FormSection title="Reason" delay={300} theme={theme}>
                    <TextInput
                        style={[styles.textInput, { backgroundColor: theme.card, borderColor: theme.border, color: theme.text }]}
                        placeholder="Why do you need this leave?"
                        placeholderTextColor={theme.subtext}
                        value={reason}
                        onChangeText={setReason}
                        multiline
                    />
                </FormSection>

                {/* Balance Info */}
                <Animated.View entering={FadeInDown.delay(400).duration(400)} style={[styles.balanceCard, { backgroundColor: theme.card, borderColor: theme.border }]}>
                    <View style={styles.balanceRow}>
                        <View style={styles.balanceItem}>
                            <Text style={[styles.balanceValue, { color: theme.success }]}>12</Text>
                            <Text style={[styles.balanceLabel, { color: theme.subtext }]}>Available</Text>
                        </View>
                        <View style={[styles.balanceDivider, { backgroundColor: theme.border }]} />
                        <View style={styles.balanceItem}>
                            <Text style={[styles.balanceValue, { color: theme.warning }]}>{calculateDays()}</Text>
                            <Text style={[styles.balanceLabel, { color: theme.subtext }]}>Requested</Text>
                        </View>
                        <View style={[styles.balanceDivider, { backgroundColor: theme.border }]} />
                        <View style={styles.balanceItem}>
                            <Text style={[styles.balanceValue, { color: theme.primary }]}>{12 - calculateDays()}</Text>
                            <Text style={[styles.balanceLabel, { color: theme.subtext }]}>Remaining</Text>
                        </View>
                    </View>
                </Animated.View>

                {/* Submit */}
                <Animated.View entering={FadeInDown.delay(500).duration(400)} style={[styles.submitContainer, animatedStyle]}>
                    <TouchableOpacity
                        style={[styles.submitButton, { backgroundColor: theme.primary }]}
                        onPress={handleSubmit}
                        activeOpacity={0.9}
                    >
                        {loading ? (
                            <Ionicons name="reload" size={24} color="white" />
                        ) : (
                            <>
                                <Ionicons name="paper-plane" size={24} color="white" />
                                <Text style={styles.submitButtonText}>Submit Request</Text>
                            </>
                        )}
                    </TouchableOpacity>
                </Animated.View>
            </ScrollView>
        </SafeAreaView>
    );
}

// --- Styles ---
const styles = StyleSheet.create({
    container: { flex: 1 },
    scrollContent: { paddingBottom: 100 },
    header: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 16, borderBottomWidth: 1 },
    backButton: { padding: 8 },
    headerTitle: { fontSize: 20, fontWeight: '700' },
    formSection: { paddingHorizontal: 20, marginTop: 20 },
    sectionLabel: { fontSize: 12, fontWeight: '600', marginBottom: 10, textTransform: 'uppercase', letterSpacing: 0.5 },
    typeGrid: { flexDirection: 'row', gap: 12 },
    typeCard: { flex: 1, padding: 16, borderRadius: 14, borderWidth: 1, alignItems: 'center', gap: 8 },
    typeIcon: { width: 48, height: 48, borderRadius: 24, alignItems: 'center', justifyContent: 'center' },
    typeLabel: { fontSize: 13, fontWeight: '600' },
    dateRow: { flexDirection: 'row', gap: 12 },
    dateButton: { flex: 1, flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 14, borderRadius: 12, borderWidth: 1 },
    dateContent: { flexDirection: 'row', alignItems: 'center', gap: 10 },
    dateLabel: { fontSize: 11 },
    dateValue: { fontSize: 14, fontWeight: '600' },
    durationBadge: { marginTop: 12, alignSelf: 'center', paddingHorizontal: 16, paddingVertical: 8, borderRadius: 20 },
    durationText: { fontSize: 14, fontWeight: '600' },
    textInput: { padding: 16, borderRadius: 12, borderWidth: 1, fontSize: 15, minHeight: 100, textAlignVertical: 'top' },
    balanceCard: { marginHorizontal: 20, marginTop: 20, padding: 16, borderRadius: 16, borderWidth: 1 },
    balanceRow: { flexDirection: 'row', justifyContent: 'space-around' },
    balanceItem: { alignItems: 'center' },
    balanceValue: { fontSize: 24, fontWeight: '700' },
    balanceLabel: { fontSize: 11, marginTop: 4 },
    balanceDivider: { width: 1, height: '100%' },
    submitContainer: { paddingHorizontal: 20, marginTop: 24 },
    submitButton: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 10, paddingVertical: 16, borderRadius: 14, shadowColor: '#5E35B1', shadowOffset: { width: 0, height: 4 }, shadowOpacity: 0.3, shadowRadius: 8, elevation: 8 },
    submitButtonText: { color: 'white', fontSize: 16, fontWeight: '700' },
});
