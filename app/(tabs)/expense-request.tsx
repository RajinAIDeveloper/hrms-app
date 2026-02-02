import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, Alert, TextInput, Platform, Image } from 'react-native';
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
import * as ImagePicker from 'expo-image-picker';
import { useTheme } from '../../context/ThemeContext';

// Expense Category Selector
const CategorySelector = ({ selected, onSelect, theme }: any) => {
    const categories = [
        { id: 'transport', label: 'Transport', icon: 'car', color: '#3B82F6' },
        { id: 'food', label: 'Food', icon: 'fast-food', color: '#EF4444' },
        { id: 'office', label: 'Office', icon: 'briefcase', color: '#F59E0B' },
        { id: 'medical', label: 'Medical', icon: 'medkit', color: '#10B981' },
    ];

    return (
        <View style={styles.categoryGrid}>
            {categories.map((cat, index) => (
                <Animated.View key={cat.id} entering={FadeInDown.delay(index * 50).duration(400)} style={{ width: '48%' }}>
                    <TouchableOpacity
                        style={[
                            styles.categoryCard,
                            { backgroundColor: theme.card, borderColor: selected === cat.id ? cat.color : theme.border },
                            selected === cat.id && { borderWidth: 2, transform: [{ scale: 1.02 }] }
                        ]}
                        onPress={() => onSelect(cat.id)}
                        activeOpacity={0.7}
                    >
                        <View style={[styles.categoryIcon, { backgroundColor: cat.color + '20' }]}>
                            <Ionicons name={cat.icon as any} size={24} color={cat.color} />
                        </View>
                        <Text style={[styles.categoryLabel, { color: theme.text }]}>{cat.label}</Text>
                        {selected === cat.id && (
                            <View style={[styles.checkBadge, { backgroundColor: cat.color }]}>
                                <Ionicons name="checkmark" size={12} color="white" />
                            </View>
                        )}
                    </TouchableOpacity>
                </Animated.View>
            ))}
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

export default function ExpenseRequestScreen() {
    const { isDark } = useTheme();
    const theme = Colors[isDark ? 'dark' : 'light'];

    const [category, setCategory] = useState('transport');
    const [amount, setAmount] = useState('');
    const [date, setDate] = useState(new Date());
    const [showDatePicker, setShowDatePicker] = useState(false);
    const [description, setDescription] = useState('');
    const [receipt, setReceipt] = useState<string | null>(null);
    const [loading, setLoading] = useState(false);

    const scale = useSharedValue(1);
    const animatedButtonStyle = useAnimatedStyle(() => ({
        transform: [{ scale: scale.value }],
    }));

    const formatDate = (date: Date) => {
        return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
    };

    const handleDateChange = (event: any, selectedDate?: Date) => {
        setShowDatePicker(Platform.OS === 'ios');
        if (selectedDate) {
            setDate(selectedDate);
        }
    };

    const pickImage = async () => {
        // Mock image picker for now or actual implementation if expo-image-picker is available (mocking mainly for reliability in this env)
        // In a real app we'd request permissions.
        // For this demo, let's just simulate a successful pick after a delay or use a mock URI.

        Alert.alert(
            "📷 Upload Receipt",
            "Choose a method",
            [
                { text: "Camera", onPress: () => setReceipt('https://via.placeholder.com/150') },
                { text: "Gallery", onPress: () => setReceipt('https://via.placeholder.com/150') },
                { text: "Cancel", style: "cancel" }
            ]
        );
    };

    const handleSubmit = () => {
        if (!amount || !description) {
            Alert.alert("⚠️ Missing Info", "Please enter amount and description.");
            return;
        }

        scale.value = withSequence(withTiming(0.95, { duration: 100 }), withSpring(1));
        setLoading(true);

        setTimeout(() => {
            setLoading(false);
            Alert.alert(
                "✅ Expense Submitted!",
                `Your claim for $${amount} (${category}) has been submitted.`,
                [{ text: "OK", onPress: () => router.back() }]
            );
        }, 1500);
    };

    return (
        <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top']}>
            <AppHeader showBack={true} showLogo={true} showMenu={false} showLogout={false} showNotification={false} />

            <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scrollContent}>

                {/* Header Title */}
                <Animated.View entering={FadeInDown.duration(300)} style={{ paddingHorizontal: 20, marginTop: 10, marginBottom: 10, backgroundColor: theme.card, borderBottomWidth: 1, borderBottomColor: theme.border }}>
                    <Text style={[styles.headerTitle, { color: theme.text }]}>🧾 Apply Reimbursement</Text>
                </Animated.View>

                {/* Amount Input (Prominent) */}
                <Animated.View entering={FadeInDown.delay(100).duration(400)} style={styles.amountContainer}>
                    <Text style={[styles.currencySymbol, { color: theme.text }]}>$</Text>
                    <TextInput
                        style={[styles.amountInput, { color: theme.text }]}
                        placeholder="0.00"
                        placeholderTextColor={theme.subtext}
                        keyboardType="numeric"
                        value={amount}
                        onChangeText={setAmount}
                    />
                </Animated.View>

                {/* Category Selection */}
                <FormSection title="Expense Category" delay={200} theme={theme}>
                    <CategorySelector selected={category} onSelect={setCategory} theme={theme} />
                </FormSection>

                {/* Date Selection */}
                <FormSection title="Date of Expense" delay={300} theme={theme}>
                    <TouchableOpacity
                        style={[styles.dateButton, { backgroundColor: theme.card, borderColor: theme.border }]}
                        onPress={() => setShowDatePicker(true)}
                    >
                        <Ionicons name="calendar-outline" size={20} color={theme.primary} />
                        <Text style={[styles.dateValue, { color: theme.text }]}>{formatDate(date)}</Text>
                        <Ionicons name="chevron-down" size={16} color={theme.subtext} />
                    </TouchableOpacity>
                </FormSection>

                {showDatePicker && (
                    <DateTimePicker
                        value={date}
                        mode="date"
                        display={Platform.OS === 'ios' ? 'spinner' : 'default'}
                        onChange={handleDateChange}
                        maximumDate={new Date()}
                    />
                )}

                {/* Description */}
                <FormSection title="Description" delay={400} theme={theme}>
                    <TextInput
                        style={[styles.descriptionInput, { backgroundColor: theme.card, borderColor: theme.border, color: theme.text }]}
                        placeholder="Dinner with client, Taxi fare, etc."
                        placeholderTextColor={theme.subtext}
                        value={description}
                        onChangeText={setDescription}
                        multiline
                    />
                </FormSection>

                {/* Receipt Upload */}
                <FormSection title="Receipt / Attachment" delay={500} theme={theme}>
                    <TouchableOpacity
                        style={[styles.uploadBox, { borderColor: theme.border, backgroundColor: theme.card }]}
                        onPress={pickImage}
                        activeOpacity={0.7}
                    >
                        {receipt ? (
                            <View style={styles.receiptPreview}>
                                <Ionicons name="document-text" size={32} color={theme.primary} />
                                <Text style={[styles.receiptText, { color: theme.text }]}>ReceiptAttached.jpg</Text>
                                <TouchableOpacity onPress={() => setReceipt(null)} style={styles.removeBtn}>
                                    <Ionicons name="close-circle" size={20} color="#EF4444" />
                                </TouchableOpacity>
                            </View>
                        ) : (
                            <>
                                <View style={[styles.uploadIcon, { backgroundColor: theme.primary + '15' }]}>
                                    <Ionicons name="cloud-upload-outline" size={24} color={theme.primary} />
                                </View>
                                <Text style={[styles.uploadText, { color: theme.subtext }]}>Tap to upload receipt</Text>
                            </>
                        )}
                    </TouchableOpacity>
                </FormSection>

                {/* Submit Button */}
                <Animated.View entering={FadeInDown.delay(600).duration(400)} style={[styles.submitContainer, animatedButtonStyle]}>
                    <TouchableOpacity
                        style={[styles.submitButton, { backgroundColor: theme.primary }]}
                        onPress={handleSubmit}
                        activeOpacity={0.9}
                    >
                        {loading ? (
                            <Ionicons name="reload" size={24} color="white" style={{ transform: [{ rotate: '45deg' }] }} />
                        ) : (
                            <>
                                <Ionicons name="checkmark-circle" size={24} color="white" />
                                <Text style={styles.submitButtonText}>Submit Claim</Text>
                            </>
                        )}
                    </TouchableOpacity>
                </Animated.View>

            </ScrollView>
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1 },
    scrollContent: { paddingBottom: 100 },
    headerTitle: { fontSize: 22, fontWeight: '700' },
    amountContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        marginVertical: 20,
    },
    currencySymbol: { fontSize: 32, fontWeight: '600', marginRight: 4 },
    amountInput: {
        fontSize: 40,
        fontWeight: 'bold',
        minWidth: 100,
        textAlign: 'center',
    },
    formSection: { paddingHorizontal: 20, marginTop: 24 },
    sectionLabel: { fontSize: 12, fontWeight: '600', marginBottom: 12, textTransform: 'uppercase', letterSpacing: 0.5 },

    // Category Styles
    categoryGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 12 },
    categoryCard: {
        padding: 16,
        borderRadius: 16,
        borderWidth: 1,
        alignItems: 'center',
        gap: 8,
        position: 'relative',
        height: 110,
        justifyContent: 'center',
    },
    categoryIcon: { width: 44, height: 44, borderRadius: 22, alignItems: 'center', justifyContent: 'center', marginBottom: 4 },
    categoryLabel: { fontSize: 13, fontWeight: '600' },
    checkBadge: { position: 'absolute', top: 8, right: 8, width: 20, height: 20, borderRadius: 10, alignItems: 'center', justifyContent: 'center' },

    // Date Styles
    dateButton: {
        flexDirection: 'row',
        alignItems: 'center',
        padding: 16,
        borderRadius: 12,
        borderWidth: 1,
        gap: 12,
    },
    dateValue: { flex: 1, fontSize: 16, fontWeight: '500' },

    // Input Styles
    descriptionInput: {
        padding: 16,
        borderRadius: 12,
        borderWidth: 1,
        fontSize: 15,
        minHeight: 100,
        textAlignVertical: 'top',
    },

    // Upload Styles
    uploadBox: {
        height: 120,
        borderRadius: 16,
        borderWidth: 1,
        borderStyle: 'dashed',
        alignItems: 'center',
        justifyContent: 'center',
        gap: 8,
    },
    uploadIcon: { width: 48, height: 48, borderRadius: 24, alignItems: 'center', justifyContent: 'center' },
    uploadText: { fontSize: 14 },
    receiptPreview: { flexDirection: 'row', alignItems: 'center', gap: 12 },
    receiptText: { fontSize: 14, fontWeight: '500' },
    removeBtn: { padding: 4 },

    // Submit Styles
    submitContainer: { paddingHorizontal: 20, marginTop: 40 },
    submitButton: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        gap: 10,
        paddingVertical: 18,
        borderRadius: 16,
        shadowColor: '#10B981',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.3,
        shadowRadius: 8,
        elevation: 8,
    },
    submitButtonText: { color: 'white', fontSize: 18, fontWeight: '700' },
});
