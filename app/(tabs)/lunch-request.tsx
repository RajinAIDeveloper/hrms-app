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
import { router } from 'expo-router';
import DateTimePicker from '@react-native-community/datetimepicker';
import AppHeader from '../../components/AppHeader';
import { useTheme } from '../../context/ThemeContext';

// --- Components ---

// Segmented Control for Tabs
const SegmentedControl = ({ selected, onSelect, theme }: any) => (
    <View style={[styles.segmentContainer, { backgroundColor: theme.card, borderColor: theme.border }]}>
        <TouchableOpacity
            style={[styles.segmentBtn, selected === 'apply' && { backgroundColor: theme.primary }]}
            onPress={() => onSelect('apply')}
        >
            <Text style={[styles.segmentText, { color: selected === 'apply' ? 'white' : theme.subtext }]}>Apply Lunch</Text>
        </TouchableOpacity>
        <TouchableOpacity
            style={[styles.segmentBtn, selected === 'list' && { backgroundColor: theme.primary }]}
            onPress={() => onSelect('list')}
        >
            <Text style={[styles.segmentText, { color: selected === 'list' ? 'white' : theme.subtext }]}>Today&apos;s List</Text>
        </TouchableOpacity>
    </View>
);

// Dynamic Guest Input List
const GuestInputList = ({ guests, setGuests, theme }: any) => {
    const addGuest = () => {
        setGuests([...guests, { id: Date.now(), name: '' }]);
    };

    const removeGuest = (id: number) => {
        setGuests(guests.filter((g: any) => g.id !== id));
    };

    const updateName = (id: number, text: string) => {
        const newGuests = guests.map((g: any) => g.id === id ? { ...g, name: text } : g);
        setGuests(newGuests);
    };

    return (
        <View style={styles.guestListContainer}>
            {guests.map((guest: any, index: number) => (
                <Animated.View key={guest.id} entering={FadeInDown.delay(index * 100).duration(300)} style={[styles.guestInputRow, { backgroundColor: theme.card, borderColor: theme.border }]}>
                    <View style={styles.guestInputWrapper}>
                        <Ionicons name="person-outline" size={20} color={theme.subtext} />
                        <TextInput
                            style={[styles.guestInput, { color: theme.text }]}
                            placeholder={`Guest ${index + 1} Name`}
                            placeholderTextColor={theme.subtext}
                            value={guest.name}
                            onChangeText={(text) => updateName(guest.id, text)}
                        />
                    </View>
                    <TouchableOpacity onPress={() => removeGuest(guest.id)} style={styles.removeBtn}>
                        <Ionicons name="trash-outline" size={20} color="#EF4444" />
                    </TouchableOpacity>
                </Animated.View>
            ))}

            <TouchableOpacity onPress={addGuest} style={[styles.addGuestBtn, { borderColor: theme.primary, backgroundColor: theme.primary + '10' }]}>
                <Ionicons name="add-circle-outline" size={20} color={theme.primary} />
                <Text style={[styles.addGuestText, { color: theme.primary }]}>Add Another Guest</Text>
            </TouchableOpacity>
        </View>
    );
};

// Form Section
const FormSection = ({ title, children, delay = 0, theme }: any) => (
    <Animated.View entering={FadeInDown.delay(delay).duration(400)} style={styles.formSection}>
        <Text style={[styles.sectionLabel, { color: theme.subtext }]}>{title}</Text>
        {children}
    </Animated.View>
);

// Submit Button
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

// Mock Data for List
const TODAY_REQUESTS = [
    { id: '101', name: 'Rahim Ahmed', empId: 'EMP-1001', date: 'Today', guests: 0 },
    { id: '102', name: 'Sarah Khan', empId: 'EMP-1045', date: 'Today', guests: 2 },
    { id: '103', name: 'Karim Ullah', empId: 'EMP-1022', date: 'Today', guests: 0 },
];

// List Item Component
const RequestItem = ({ item, index, theme }: any) => (
    <Animated.View entering={FadeInDown.delay(index * 100).duration(400)} style={[styles.requestCard, { backgroundColor: theme.card, borderColor: theme.border }]}>
        <View style={[styles.avatarBox, { backgroundColor: theme.primary + '15' }]}>
            <Text style={[styles.avatarText, { color: theme.primary }]}>{item.name.charAt(0)}</Text>
        </View>
        <View style={{ flex: 1 }}>
            <Text style={[styles.reqName, { color: theme.text }]}>{item.name}</Text>
            <Text style={[styles.reqId, { color: theme.subtext }]}>{item.empId}</Text>
        </View>
        <View style={{ alignItems: 'flex-end' }}>
            <Text style={[styles.reqDate, { color: theme.text }]}>{item.date}</Text>
            {item.guests > 0 && (
                <View style={[styles.guestBadge, { backgroundColor: '#F59E0B20' }]}>
                    <Text style={[styles.guestBadgeText, { color: '#F59E0B' }]}>+{item.guests} Guests</Text>
                </View>
            )}
        </View>
    </Animated.View>
);

// --- Main Screen ---
export default function LunchRequestScreen() {
    const { isDark } = useTheme();
    const theme = Colors[isDark ? 'dark' : 'light'];

    const [activeTab, setActiveTab] = useState('apply'); // 'apply' | 'list'
    const [selectedDate, setSelectedDate] = useState(new Date());
    const [showDatePicker, setShowDatePicker] = useState(false);
    const [includeGuest, setIncludeGuest] = useState(false);
    // Guest list state: Array of objects {id, name}
    const [guests, setGuests] = useState([{ id: 1, name: '' }]);
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
        // Validate guest names if guest included
        if (includeGuest) {
            const emptyGuests = guests.filter(g => g.name.trim() === '');
            if (emptyGuests.length > 0) {
                Alert.alert("Missing Info", "Please enter names for all guests.");
                return;
            }
        }

        setLoading(true);
        setTimeout(() => {
            setLoading(false);
            const guestMsg = includeGuest ? ` with ${guests.length} guest(s) (${guests.map(g => g.name).join(', ')})` : '';
            Alert.alert(
                "✅ Request Submitted!",
                `Your lunch request for ${formattedDate}${guestMsg} has been submitted.`,
                [{ text: "OK", onPress: () => router.back() }]
            );
        }, 1500);
    };

    // Minimum date is today
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    return (
        <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top']}>
            <AppHeader showBack={true} showLogo={true} showMenu={false} showLogout={false} showNotification={false} />

            <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scrollContent}>

                {/* Header Title */}
                <View style={[styles.headerContainer, { backgroundColor: theme.card, borderBottomColor: theme.border }]}>
                    <Text style={[styles.pageTitle, { color: theme.text }]}>🍽️ Lunch Management</Text>
                    <SegmentedControl selected={activeTab} onSelect={setActiveTab} theme={theme} />
                </View>

                {activeTab === 'apply' ? (
                    // APPLY LUNCH FORM
                    <View>
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

                        {/* Guest Details */}
                        {includeGuest && (
                            <FormSection title="Guest Details" delay={0} theme={theme}>
                                <GuestInputList guests={guests} setGuests={setGuests} theme={theme} />
                            </FormSection>
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
                                <Text style={[styles.summaryLabel, { color: theme.subtext }]}>Meal:</Text>
                                <Text style={[styles.summaryValue, { color: theme.text }]}>Self {includeGuest ? `+ ${guests.length} Guest(s)` : ''}</Text>
                            </View>
                            <View style={styles.summaryRow}>
                                <Text style={[styles.summaryLabel, { color: theme.subtext }]}>Total Count:</Text>
                                <Text style={[styles.summaryValue, { color: theme.text }]}>{1 + (includeGuest ? guests.length : 0)} Plate(s)</Text>
                            </View>
                        </Animated.View>

                        {/* Submit */}
                        <Animated.View entering={FadeInDown.delay(500).duration(400)} style={styles.submitContainer}>
                            <SubmitButton onPress={handleSubmit} loading={loading} theme={theme} />
                        </Animated.View>
                    </View>
                ) : (
                    // TODAY'S LIST VIEW
                    <View style={styles.listContainer}>
                        <View style={styles.listHeader}>
                            <Text style={[styles.listHeaderTitle, { color: theme.text }]}>Today&apos;s Requests ({TODAY_REQUESTS.length})</Text>
                        </View>
                        {TODAY_REQUESTS.map((item, index) => (
                            <RequestItem key={item.id} item={item} index={index} theme={theme} />
                        ))}
                    </View>
                )}

            </ScrollView>
        </SafeAreaView>
    );
}

// --- Styles ---
const styles = StyleSheet.create({
    container: { flex: 1 },
    scrollContent: { paddingBottom: 100 },

    // Header
    headerContainer: { padding: 20, paddingTop: 10, borderBottomWidth: 1 },
    pageTitle: { fontSize: 24, fontWeight: '800', marginBottom: 16 },

    // Tabs
    segmentContainer: { flexDirection: 'row', padding: 4, borderRadius: 12, borderWidth: 1 },
    segmentBtn: { flex: 1, paddingVertical: 8, borderRadius: 8, alignItems: 'center' },
    segmentText: { fontSize: 13, fontWeight: '600' },

    // Form
    formSection: { paddingHorizontal: 20, marginTop: 20 },
    sectionLabel: { fontSize: 12, fontWeight: '600', marginBottom: 10, textTransform: 'uppercase', letterSpacing: 0.5 },

    dateCard: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 16, borderRadius: 12, borderWidth: 1 },
    dateCardContent: { flexDirection: 'row', alignItems: 'center', gap: 12 },
    dateText: { fontSize: 16, fontWeight: '600' },

    guestRow: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 16, borderRadius: 12, borderWidth: 1 },
    guestInfo: { flexDirection: 'row', alignItems: 'center', gap: 10 },
    guestLabel: { fontSize: 15, fontWeight: '500' },

    // Dynamic Guests
    guestListContainer: { gap: 12 },
    guestInputRow: { flexDirection: 'row', alignItems: 'center', padding: 4, paddingRight: 12, borderRadius: 12, borderWidth: 1 },
    guestInputWrapper: { flex: 1, flexDirection: 'row', alignItems: 'center', gap: 10, paddingHorizontal: 12 },
    guestInput: { flex: 1, height: 48, fontSize: 15 },
    removeBtn: { padding: 8 },
    addGuestBtn: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 8, padding: 12, borderRadius: 12, borderWidth: 1, marginTop: 4, borderStyle: 'dashed' },
    addGuestText: { fontSize: 14, fontWeight: '600' },

    textInput: { padding: 16, borderRadius: 12, borderWidth: 1, fontSize: 15, minHeight: 80, textAlignVertical: 'top' },

    summaryCard: { marginHorizontal: 20, marginTop: 24, padding: 16, borderRadius: 16, borderWidth: 1 },
    summaryTitle: { fontSize: 14, fontWeight: '700', marginBottom: 12 },
    summaryRow: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 8 },
    summaryLabel: { fontSize: 13 },
    summaryValue: { fontSize: 13, fontWeight: '600' },

    submitContainer: { paddingHorizontal: 20, marginTop: 24 },
    submitButton: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 10, paddingVertical: 16, borderRadius: 14, shadowColor: '#5E35B1', shadowOffset: { width: 0, height: 4 }, shadowOpacity: 0.3, shadowRadius: 8, elevation: 8 },
    submitButtonText: { color: 'white', fontSize: 16, fontWeight: '700' },

    // List View
    listContainer: { paddingHorizontal: 20, paddingTop: 20 },
    listHeader: { marginBottom: 12 },
    listHeaderTitle: { fontSize: 16, fontWeight: '700' },
    requestCard: { flexDirection: 'row', alignItems: 'center', padding: 16, borderRadius: 16, borderWidth: 1, marginBottom: 12, gap: 12 },
    avatarBox: { width: 44, height: 44, borderRadius: 22, alignItems: 'center', justifyContent: 'center' },
    avatarText: { fontSize: 18, fontWeight: '700' },
    reqName: { fontSize: 15, fontWeight: '600', marginBottom: 2 },
    reqId: { fontSize: 12 },
    reqDate: { fontSize: 12, fontWeight: '500', marginBottom: 4 },
    guestBadge: { paddingHorizontal: 6, paddingVertical: 2, borderRadius: 4 },
    guestBadgeText: { fontSize: 10, fontWeight: '700' },
});
