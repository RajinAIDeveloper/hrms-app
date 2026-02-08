import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, Alert, TextInput, Platform, ActivityIndicator } from 'react-native';
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
import { useAuth } from '../../context/AuthContext';
import attendanceApi from '../../services/attendance';
import { EmployeeManualAttendanceDTO } from '../../types/attendance.types';

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
    const { user } = useAuth();

    const [requestType, setRequestType] = useState('both'); // 'in_time', 'out_time', 'both'
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

    // Format time to HH:mm:ss for API
    const formatTimeForAPI = (date: Date): string => {
        const hours = date.getHours().toString().padStart(2, '0');
        const minutes = date.getMinutes().toString().padStart(2, '0');
        const seconds = '00';
        return `${hours}:${minutes}:${seconds}`;
    };

    // Format date to ISO string for API
    const formatDateForAPI = (date: Date): string => {
        return date.toISOString();
    };

    // Map request type to API format
    const mapRequestType = (type: string): 'In-Time' | 'Out-Time' | 'Both' => {
        if (type === 'in_time') return 'In-Time';
        if (type === 'out_time') return 'Out-Time';
        return 'Both';
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

    // Validation function
    const validateForm = (): string | null => {
        // Validate reason
        if (!reason.trim()) {
            return 'Please provide a reason for the manual attendance request.';
        }

        // Validate time fields based on request type
        const apiRequestType = mapRequestType(requestType);

        if (apiRequestType === 'In-Time' || apiRequestType === 'Both') {
            // Check if in-time is after 1:00 AM
            const minInTime = new Date(inTime);
            minInTime.setHours(1, 0, 0, 0);

            if (inTime < minInTime) {
                return 'In-time cannot be before 01:00 AM';
            }
        }

        if (apiRequestType === 'Out-Time' || apiRequestType === 'Both') {
            // Check if out-time is before 11:59 PM
            const maxOutTime = new Date(outTime);
            maxOutTime.setHours(23, 59, 0, 0);

            if (outTime > maxOutTime) {
                return 'Out-time cannot be after 11:59 PM';
            }
        }

        // If both selected, validate that out-time is after in-time
        if (apiRequestType === 'Both') {
            if (inTime >= outTime) {
                return 'Out-time must be after In-time';
            }
        }

        return null;
    };

    const handleSubmit = async () => {
        // Validate form
        const validationError = validateForm();
        if (validationError) {
            Alert.alert('Validation Error', validationError);
            return;
        }

        if (!user?.employeeId) {
            Alert.alert('Error', 'User information not available. Please login again.');
            return;
        }

        scale.value = withSequence(withTiming(0.95, { duration: 100 }), withSpring(1));
        setLoading(true);

        try {
            const apiRequestType = mapRequestType(requestType);

            // Build request payload
            const requestData: EmployeeManualAttendanceDTO = {
                ManualAttendanceId: 0,
                ManualAttendanceCode: '',
                EmployeeId: user.employeeId,
                DepartmentId: user.departmentId || null,
                SectionId: user.sectionId || null,
                UnitId: null,
                AttendanceDate: formatDateForAPI(attendanceDate),
                TimeRequestFor: apiRequestType,
                InTime: (apiRequestType === 'In-Time' || apiRequestType === 'Both')
                    ? formatTimeForAPI(inTime)
                    : null,
                OutTime: (apiRequestType === 'Out-Time' || apiRequestType === 'Both')
                    ? formatTimeForAPI(outTime)
                    : null,
                StateStatus: 'Pending',
                Reason: reason.trim(),
                Remarks: null,
            };

            console.log('Submitting manual attendance:', requestData);

            // Call API
            const response = await attendanceApi.saveManualAttendance(requestData);

            console.log('API Response:', response.data);

            // Check if submission was successful
            if (response.data.status) {
                setLoading(false);
                Alert.alert(
                    'Success',
                    `Your manual attendance request for ${formatDate(attendanceDate)} has been submitted successfully!`,
                    [
                        {
                            text: 'OK',
                            onPress: () => {
                                // Reset form
                                setRequestType('both');
                                setAttendanceDate(new Date());
                                setInTime(defaultInTime);
                                setOutTime(defaultOutTime);
                                setReason('');

                                // Navigate back
                                router.back();
                            }
                        }
                    ]
                );
            } else {
                throw new Error(response.data.message || 'Failed to submit manual attendance request');
            }
        } catch (error: any) {
            setLoading(false);
            console.error('Manual attendance submission error:', error);

            let errorMessage = 'Failed to submit manual attendance request. Please try again.';

            if (error.response) {
                // Server responded with error
                errorMessage = error.response.data?.message || error.response.data?.error || errorMessage;
            } else if (error.request) {
                // Network error
                errorMessage = 'Network error. Please check your connection.';
            } else if (error.message) {
                errorMessage = error.message;
            }

            Alert.alert('Error', errorMessage);
        }
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
                        style={[styles.submitButton, { backgroundColor: theme.primary, opacity: loading ? 0.7 : 1 }]}
                        onPress={handleSubmit}
                        activeOpacity={0.9}
                        disabled={loading}
                    >
                        {loading ? (
                            <ActivityIndicator size="small" color="white" />
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
