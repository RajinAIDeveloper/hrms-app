import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, Alert, Switch, TextInput, Platform } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Colors } from '../../constants/Colors';
import { Ionicons } from '@expo/vector-icons';
import Animated, {
    FadeInDown,
    FadeInUp,
    useSharedValue,
    useAnimatedStyle,
    withSpring,
    withSequence,
    withTiming,
} from 'react-native-reanimated';
import { useColorScheme } from '../../hooks/use-color-scheme';
import { router } from 'expo-router';
import DateTimePicker from '@react-native-community/datetimepicker';
import AppHeader from '../../components/AppHeader';

// --- Components ---

// Quantity Stepper
const QuantityStepper = ({ value, onChange, theme }: any) => (
    <View style={styles.stepperContainer}>
        <TouchableOpacity
            style={[styles.stepperButton, { backgroundColor: theme.background, borderColor: theme.border }]}
            onPress={() => value > 1 && onChange(value - 1)}
        >
            <Ionicons name="remove" size={20} color={theme.text} />
        </TouchableOpacity>
        <Text style={[styles.stepperValue, { color: theme.text }]}>{value}</Text>
        <TouchableOpacity
            style={[styles.stepperButton, { backgroundColor: theme.primary }]}
            onPress={() => onChange(value + 1)}
        >
            <Ionicons name="add" size={20} color="white" />
        </TouchableOpacity>
    </View>
);

// Form Section
const FormSection = ({ title, children, delay = 0, theme }: any) => (
    <Animated.View entering={FadeInDown.delay(delay).duration(400)} style={styles.formSection}>
        <Text style={[styles.sectionLabel, { color: theme.subtext }]}>{title}</Text>
        {children}
    </Animated.View>
);

// Animated Submit Button
const SubmitButton = ({ onPress, loading, theme }: any) => {
    const scale = useSharedValue(1);

    const animatedStyle = useAnimatedStyle(() => ({
        transform: [{ scale: scale.value }],
    }));

    const handlePress = () => {
        scale.value = withSequence(
            withTiming(0.95, { duration: 100 }),
            withSpring(1, { damping: 10 })
        );
        onPress();
    };

    return (
        <Animated.View style={animatedStyle}>
            <TouchableOpacity
                style={[styles.submitButton, { backgroundColor: theme.primary }]}
                onPress={handlePress}
                activeOpacity={0.9}
            >
                {loading ? (
                    <Ionicons name="reload" size={24} color="white" />
                ) : (
                    <>
                        <Ionicons name="checkmark-circle" size={24} color="white" />
                        <Text style={styles.submitButtonText}>Submit Request</Text>
                    </>
                )}
            </TouchableOpacity>
        </Animated.View>
    );
};

// --- Main Screen ---
export default function LunchRequestScreen() {
    const colorScheme = useColorScheme();
    const theme = Colors[colorScheme ?? 'light'];

    const [selectedDate, setSelectedDate] = useState(new Date());
    const [showDatePicker, setShowDatePicker] = useState(false);
    const [includeGuest, setIncludeGuest] = useState(false);
    const [guestCount, setGuestCount] = useState(1);
    const [notes, setNotes] = useState('');
    const [loading, setLoading] = useState(false);

    const formattedDate = selectedDate.toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' });

    const handleDateChange = (event: any, date?: Date) => {
        setShowDatePicker(Platform.OS === 'ios');
        if (date) {
            setSelectedDate(date);
        }
    };

    const handleSubmit = () => {
        setLoading(true);
        setTimeout(() => {
            setLoading(false);
            Alert.alert(
                "✅ Request Submitted!",
                `Your lunch request for ${formattedDate}${includeGuest ? ` with ${guestCount} guest(s)` : ''} has been submitted.`,
                [{ text: "OK", onPress: () => router.back() }]
            );
        }, 1500);
    };

    // Minimum date is today
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    return (
        <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top']}>
            {/* Header */}
            <AppHeader showBack={true} showLogo={true} showMenu={false} showLogout={false} showNotification={false} />

            <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scrollContent}>

                {/* Page Title */}
                <Animated.View entering={FadeInDown.duration(300)} style={{ paddingHorizontal: 20, marginTop: 10, marginBottom: 10 }}>
                    <Text style={[styles.headerTitle, { color: theme.text }]}>🍽️ Apply Lunch</Text>
                </Animated.View>

                {/* Date Selection */}
                <FormSection title="Select Date" delay={100} theme={theme}>
                    <TouchableOpacity
                        style={[styles.dateCard, { backgroundColor: theme.card, borderColor: theme.border }]}
                        onPress={() => setShowDatePicker(true)}
                    >
                        <View style={styles.dateCardContent}>
                            <Ionicons name="calendar" size={22} color={theme.primary} />
                            <Text style={[styles.dateText, { color: theme.text }]}>{formattedDate}</Text>
                        </View>
                        <Ionicons name="chevron-forward" size={20} color={theme.subtext} />
                    </TouchableOpacity>
                </FormSection>

                {showDatePicker && (
                    <DateTimePicker
                        value={selectedDate}
                        mode="date"
                        display={Platform.OS === 'ios' ? 'spinner' : 'default'}
                        onChange={handleDateChange}
                        minimumDate={today}
                    />
                )}

                {/* Guest Toggle */}
                <FormSection title="Include Guest?" delay={200} theme={theme}>
                    <View style={[styles.guestRow, { backgroundColor: theme.card, borderColor: theme.border }]}>
                        <View style={styles.guestInfo}>
                            <Ionicons name="people" size={22} color={theme.primary} />
                            <Text style={[styles.guestLabel, { color: theme.text }]}>Add Guest Meal</Text>
                        </View>
                        <Switch
                            value={includeGuest}
                            onValueChange={setIncludeGuest}
                            trackColor={{ false: theme.border, true: theme.primary + '50' }}
                            thumbColor={includeGuest ? theme.primary : theme.subtext}
                        />
                    </View>
                </FormSection>

                {/* Guest Quantity */}
                {includeGuest && (
                    <Animated.View entering={FadeInUp.duration(300)}>
                        <FormSection title="Number of Guests" delay={0} theme={theme}>
                            <View style={[styles.quantityCard, { backgroundColor: theme.card, borderColor: theme.border }]}>
                                <QuantityStepper value={guestCount} onChange={setGuestCount} theme={theme} />
                            </View>
                        </FormSection>
                    </Animated.View>
                )}

                {/* Notes */}
                <FormSection title="Special Instructions (Optional)" delay={300} theme={theme}>
                    <TextInput
                        style={[styles.textInput, { backgroundColor: theme.card, borderColor: theme.border, color: theme.text }]}
                        placeholder="e.g., No spicy food, vegetarian..."
                        placeholderTextColor={theme.subtext}
                        value={notes}
                        onChangeText={setNotes}
                        multiline
                    />
                </FormSection>

                {/* Summary */}
                <Animated.View entering={FadeInDown.delay(400).duration(400)} style={[styles.summaryCard, { backgroundColor: theme.primary + '10', borderColor: theme.primary + '30' }]}>
                    <Text style={[styles.summaryTitle, { color: theme.primary }]}>📋 Summary</Text>
                    <View style={styles.summaryRow}>
                        <Text style={[styles.summaryLabel, { color: theme.subtext }]}>Date:</Text>
                        <Text style={[styles.summaryValue, { color: theme.text }]}>{formattedDate}</Text>
                    </View>
                    <View style={styles.summaryRow}>
                        <Text style={[styles.summaryLabel, { color: theme.subtext }]}>Meal:</Text>
                        <Text style={[styles.summaryValue, { color: theme.text }]}>🌞 Lunch</Text>
                    </View>
                    <View style={styles.summaryRow}>
                        <Text style={[styles.summaryLabel, { color: theme.subtext }]}>Total:</Text>
                        <Text style={[styles.summaryValue, { color: theme.text }]}>{1 + (includeGuest ? guestCount : 0)} meal(s)</Text>
                    </View>
                </Animated.View>

                {/* Submit */}
                <Animated.View entering={FadeInDown.delay(500).duration(400)} style={styles.submitContainer}>
                    <SubmitButton onPress={handleSubmit} loading={loading} theme={theme} />
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
    dateCard: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 16, borderRadius: 12, borderWidth: 1 },
    dateCardContent: { flexDirection: 'row', alignItems: 'center', gap: 12 },
    dateText: { fontSize: 16, fontWeight: '600' },
    guestRow: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 16, borderRadius: 12, borderWidth: 1 },
    guestInfo: { flexDirection: 'row', alignItems: 'center', gap: 10 },
    guestLabel: { fontSize: 15, fontWeight: '500' },
    quantityCard: { padding: 16, borderRadius: 12, borderWidth: 1, alignItems: 'center' },
    stepperContainer: { flexDirection: 'row', alignItems: 'center', gap: 20 },
    stepperButton: { width: 44, height: 44, borderRadius: 22, alignItems: 'center', justifyContent: 'center', borderWidth: 1 },
    stepperValue: { fontSize: 24, fontWeight: '700', minWidth: 40, textAlign: 'center' },
    textInput: { padding: 16, borderRadius: 12, borderWidth: 1, fontSize: 15, minHeight: 80, textAlignVertical: 'top' },
    summaryCard: { marginHorizontal: 20, marginTop: 24, padding: 16, borderRadius: 16, borderWidth: 1 },
    summaryTitle: { fontSize: 14, fontWeight: '700', marginBottom: 12 },
    summaryRow: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 8 },
    summaryLabel: { fontSize: 13 },
    summaryValue: { fontSize: 13, fontWeight: '600' },
    submitContainer: { paddingHorizontal: 20, marginTop: 24 },
    submitButton: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 10, paddingVertical: 16, borderRadius: 14, shadowColor: '#5E35B1', shadowOffset: { width: 0, height: 4 }, shadowOpacity: 0.3, shadowRadius: 8, elevation: 8 },
    submitButtonText: { color: 'white', fontSize: 16, fontWeight: '700' },
});
