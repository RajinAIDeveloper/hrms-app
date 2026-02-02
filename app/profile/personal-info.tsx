import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, ScrollView, StyleSheet } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import { useTheme } from '../../context/ThemeContext';

export default function PersonalInfoScreen() {
    const router = useRouter();
    const { isDark } = useTheme();
    const [phone, setPhone] = useState('+880 1712 345678');
    const [isEditing, setIsEditing] = useState(false);

    // Dynamic Styles
    const styles = getStyles(isDark);
    const iconColor = isDark ? '#F9FAFB' : '#171717';
    const highlightColor = isDark ? '#60A5FA' : '#2563EB';

    return (
        <SafeAreaView style={styles.container} edges={['top']}>
            <View style={styles.header}>
                <TouchableOpacity onPress={() => router.back()}>
                    <Ionicons name="arrow-back" size={24} color={iconColor} />
                </TouchableOpacity>
                <Text style={styles.headerTitle}>Personal Information</Text>
                <View style={{ width: 24 }} />
            </View>

            <ScrollView contentContainerStyle={styles.content}>
                <View style={styles.inputGroup}>
                    <Text style={styles.label}>Full Name</Text>
                    <TextInput style={[styles.input, styles.disabledInput]} value="Rahim Ahmed" editable={false} />
                </View>

                <View style={styles.inputGroup}>
                    <Text style={styles.label}>Email Address</Text>
                    <TextInput style={[styles.input, styles.disabledInput]} value="rahim.ahmed@company.com" editable={false} />
                </View>

                <View style={styles.inputGroup}>
                    <Text style={styles.label}>Phone Number</Text>
                    <View style={styles.phoneInputWrapper}>
                        <TextInput
                            style={[styles.input, { flex: 1, backgroundColor: isEditing ? (isDark ? '#374151' : 'white') : (isDark ? '#1F2937' : '#F5F5F5') }]}
                            value={phone}
                            onChangeText={setPhone}
                            editable={isEditing}
                            placeholderTextColor={isDark ? '#9CA3AF' : '#A3A3A3'}
                        />
                        <TouchableOpacity onPress={() => setIsEditing(!isEditing)} style={styles.editIcon}>
                            <Ionicons name={isEditing ? "checkmark-circle" : "create-outline"} size={22} color={highlightColor} />
                        </TouchableOpacity>
                    </View>
                </View>

                <View style={styles.inputGroup}>
                    <Text style={styles.label}>Date of Birth</Text>
                    <TextInput style={[styles.input, styles.disabledInput]} value="15 Aug 1990" editable={false} />
                </View>

                <View style={styles.inputGroup}>
                    <Text style={styles.label}>Nationality</Text>
                    <TextInput style={[styles.input, styles.disabledInput]} value="Bangladeshi" editable={false} />
                </View>
            </ScrollView>
        </SafeAreaView>
    );
}

const getStyles = (isDark: boolean) => StyleSheet.create({
    container: { flex: 1, backgroundColor: isDark ? '#111827' : '#FAFAFA' },
    header: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 20, backgroundColor: isDark ? '#1F2937' : 'white', borderBottomWidth: 1, borderBottomColor: isDark ? '#374151' : '#F5F5F5' },
    headerTitle: { fontSize: 18, fontWeight: 'bold', color: isDark ? '#F9FAFB' : '#171717' },
    content: { padding: 20 },
    inputGroup: { marginBottom: 20 },
    label: { fontSize: 14, color: isDark ? '#D1D5DB' : '#525252', marginBottom: 8, fontWeight: '500' },
    input: { backgroundColor: isDark ? '#374151' : 'white', borderWidth: 1, borderColor: isDark ? '#4B5563' : '#E5E5E5', borderRadius: 10, padding: 12, fontSize: 16, color: isDark ? '#F9FAFB' : '#171717' },
    disabledInput: { backgroundColor: isDark ? '#1F2937' : '#F5F5F5', color: isDark ? '#9CA3AF' : '#737373' },
    phoneInputWrapper: { flexDirection: 'row', alignItems: 'center' },
    editIcon: { position: 'absolute', right: 12 },
});
