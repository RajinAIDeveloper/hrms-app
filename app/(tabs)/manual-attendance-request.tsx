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

// Request Type Selector
const RequestTypeSelector = ({ selected, onSelect, theme }: any) => {
    const types = [
        { id: 'in_time', label: 'In Time', icon: 'log-in', color: '#10B981' },
        { id: 'out_time', label: 'Out Time', icon: 'log-out', color: '#EF4444' },
        { id: 'both', label: 'Both', icon: 'swap-horizontal', color: '#3B82F6' },
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

// Date/Time Picker Button
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

// Form Section
const FormSection = ({ title, children, delay = 0, theme }: any) => (
    <Animated.View entering={FadeInDown.delay(delay).duration(400)} style={styles.formSection}>
        <Text style={[styles.sectionLabel, { color: theme.subtext }]}>{title}</Text>
        {children}
    </Animated.View>
);

// --- Main Screen ---
export default function ManualAttendanceRequestScreen() {
    const { isDark } = useTheme();
    const theme = Colors[isDark ? 'dark' : 'light'];

    const [requestType, setRequestType] = useState('in_time'); // 'in_time', 'out_time', 'both'
    const [attendanceDate, setAttendanceDate] = useState(new Date());

    // Default times
    const defaultInTime = new Date(); defaultInTime.setHours(9, 0, 0, 0);
    const defaultOutTime = new Date(); defaultOutTime.setHours(18, 0, 0, 0);

    const [inTime, setInTime] = useState(defaultInTime);
    const [outTime, setOutTime] = useState(defaultOutTime);

    const [showDatePicker, setShowDatePicker] = useState(false);
    const [showInTimePicker, setShowInTimePicker] = useState(false);
    const [showOutTimePicker, setShowOutTimePicker] = useState(false);

    const [reason, setReason] = useState('');
    const [loading, setLoading] = useState(false);

    const scale = useSharedValue(1);
    const animatedStyle = useAnimatedStyle(() => ({
        transform: [{ scale: scale.value }],
    }));

    const formatDate = (date: Date) => {
        return date.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric', year: 'numeric' });
    };

    const formatTime = (date: Date) => {
        return date.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
    };

    const handleDateChange = (event: any, date?: Date) => {
        setShowDatePicker(Platform.OS === 'ios');
        if (date) setAttendanceDate(date);
    };

    const handleInTimeChange = (event: any, date?: Date) => {
        setShowInTimePicker(Platform.OS === 'ios');
        if (date) setInTime(date);
    };

    const handleOutTimeChange = (event: any, date?: Date) => {
        setShowOutTimePicker(Platform.OS === 'ios');
        if (date) setOutTime(date);
    };

    const handleSubmit = () => {
        if (!reason.trim()) {
            Alert.alert("Missing Information", "Please provide a reason for the Manual Attendance Request.");
            return;
        }

        scale.value = withSequence(withTiming(0.95, { duration: 100 }), withSpring(1));
        setLoading(true);
        setTimeout(() => {
            setLoading(false);
            Alert.alert(
                "✅ Request Submitted!",
                `Your manual attendance request for ${formatDate(attendanceDate)} has been submitted for approval.`,
                [{ text: "OK", onPress: () => router.back() }]
            );
        }, 1500);
    };

    return (
        <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top']}>
            <AppHeader showBack={true} showLogo={true} showMenu={false} showLogout={false} showNotification={false} />

            <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scrollContent}>

                {/* Page Title */}
                <Animated.View entering={FadeInDown.duration(300)} style={{ paddingHorizontal: 20, marginTop: 10, marginBottom: 10, backgroundColor: theme.card, borderBottomWidth: 1, borderBottomColor: theme.border }}>
                    <Text style={[styles.headerTitle, { color: theme.text }]}>✋ Manual Attendance</Text>
                </Animated.View>

                {/* Attendance Date */}
                <FormSection title="Attendance Date" delay={100} theme={theme}>
                    <PickerButton
                        label="Select Date"
                        value={formatDate(attendanceDate)}
                        onPress={() => setShowDatePicker(true)}
                        theme={theme}
                    />
                </FormSection>

                {showDatePicker && (
                    <DateTimePicker
                        value={attendanceDate}
                        mode="date"
                        display={Platform.OS === 'ios' ? 'spinner' : 'default'}
                        onChange={handleDateChange}
                        maximumDate={new Date()}
                    />
                )}

                {/* Request Type */}
                <FormSection title="Request Correction For" delay={200} theme={theme}>
                    <RequestTypeSelector selected={requestType} onSelect={setRequestType} theme={theme} />
                </FormSection>

                {/* Time Selection */}
                <FormSection title="Corrected Time" delay={300} theme={theme}>
                    <View style={styles.timeRow}>

                        {(requestType === 'in_time' || requestType === 'both') && (
                            <View style={{ flex: 1 }}>
                                <PickerButton
                                    label="In Time"
                                    value={formatTime(inTime)}
                                    onPress={() => setShowInTimePicker(true)}
                                    theme={theme}
                                    icon="time-outline"
                                />
                            </View>
                        )}

                        {(requestType === 'both') && <View style={{ width: 12 }} />}

                        {(requestType === 'out_time' || requestType === 'both') && (
                            <View style={{ flex: 1 }}>
                                <PickerButton
                                    label="Out Time"
                                    value={formatTime(outTime)}
                                    onPress={() => setShowOutTimePicker(true)}
                                    theme={theme}
                                    icon="time-outline"
                                />
                            </View>
                        )}

                    </View>
                </FormSection>

                {showInTimePicker && (
                    <DateTimePicker
                        value={inTime}
                        mode="time"
                        display={Platform.OS === 'ios' ? 'spinner' : 'default'}
                        onChange={handleInTimeChange}
                    />
                )}

                {showOutTimePicker && (
                    <DateTimePicker
                        value={outTime}
                        mode="time"
                        display={Platform.OS === 'ios' ? 'spinner' : 'default'}
                        onChange={handleOutTimeChange}
                    />
                )}

                {/* Reason */}
                <FormSection title="Reason" delay={400} theme={theme}>
                    <TextInput
                        style={[styles.textInput, { backgroundColor: theme.card, borderColor: theme.border, color: theme.text }]}
                        placeholder="e.g. Forgot to punch out, Device error..."
                        placeholderTextColor={theme.subtext}
                        value={reason}
                        onChangeText={setReason}
                        multiline
                    />
                </FormSection>

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
                                <Ionicons name="checkmark-circle-outline" size={24} color="white" />
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
    headerTitle: { fontSize: 20, fontWeight: '700' },
    formSection: { paddingHorizontal: 20, marginTop: 20 },
    sectionLabel: { fontSize: 12, fontWeight: '600', marginBottom: 10, textTransform: 'uppercase', letterSpacing: 0.5 },

    typeGrid: { flexDirection: 'row', gap: 12 },
    typeCard: { flex: 1, padding: 16, borderRadius: 14, borderWidth: 1, alignItems: 'center', gap: 8 },
    typeIcon: { width: 48, height: 48, borderRadius: 24, alignItems: 'center', justifyContent: 'center' },
    typeLabel: { fontSize: 13, fontWeight: '600' },

    timeRow: { flexDirection: 'row' },
    pickerButton: { flex: 1, flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 14, borderRadius: 12, borderWidth: 1 },
    pickerContent: { flexDirection: 'row', alignItems: 'center', gap: 10 },
    pickerLabel: { fontSize: 11 },
    pickerValue: { fontSize: 14, fontWeight: '600' },

    textInput: { padding: 16, borderRadius: 12, borderWidth: 1, fontSize: 15, minHeight: 100, textAlignVertical: 'top' },

    submitContainer: { paddingHorizontal: 20, marginTop: 32 },
    submitButton: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 10, paddingVertical: 16, borderRadius: 14, shadowColor: '#5E35B1', shadowOffset: { width: 0, height: 4 }, shadowOpacity: 0.3, shadowRadius: 8, elevation: 8 },
    submitButtonText: { color: 'white', fontSize: 16, fontWeight: '700' },
});
