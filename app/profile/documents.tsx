import React from 'react';
import { View, Text, TouchableOpacity, ScrollView, StyleSheet } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import { useTheme } from '../../context/ThemeContext';

const DOCUMENTS = [
    { id: 1, name: 'Employment Contract', date: '15 Mar 2022', type: 'PDF' },
    { id: 2, name: 'NDA Agreement', date: '15 Mar 2022', type: 'PDF' },
    { id: 3, name: 'Salary Certificate - 2025', date: '10 Jan 2025', type: 'PDF' },
];

export default function DocumentsScreen() {
    const router = useRouter();
    const { isDark } = useTheme();

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
                <Text style={styles.headerTitle}>My Documents</Text>
                <View style={{ width: 24 }} />
            </View>

            <ScrollView contentContainerStyle={styles.content}>
                {DOCUMENTS.map(doc => (
                    <View key={doc.id} style={styles.docCard}>
                        <View style={styles.iconWrapper}>
                            <Ionicons name="document-text" size={24} color={isDark ? '#EF4444' : '#EF4444'} />
                        </View>
                        <View style={{ flex: 1 }}>
                            <Text style={styles.docName}>{doc.name}</Text>
                            <Text style={styles.docDate}>Uploaded on {doc.date}</Text>
                        </View>
                        <TouchableOpacity>
                            <Ionicons name="download-outline" size={20} color={highlightColor} />
                        </TouchableOpacity>
                    </View>
                ))}
            </ScrollView>
        </SafeAreaView>
    );
}

const getStyles = (isDark: boolean) => StyleSheet.create({
    container: { flex: 1, backgroundColor: isDark ? '#111827' : '#FAFAFA' },
    header: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 20, backgroundColor: isDark ? '#1F2937' : 'white', borderBottomWidth: 1, borderBottomColor: isDark ? '#374151' : '#F5F5F5' },
    headerTitle: { fontSize: 18, fontWeight: 'bold', color: isDark ? '#F9FAFB' : '#171717' },
    content: { padding: 20 },
    docCard: { flexDirection: 'row', alignItems: 'center', backgroundColor: isDark ? '#1F2937' : 'white', padding: 16, borderRadius: 12, marginBottom: 12, gap: 12, shadowColor: '#000', shadowOpacity: 0.05, shadowRadius: 4, elevation: 1 },
    iconWrapper: { width: 40, height: 40, backgroundColor: isDark ? 'rgba(239, 68, 68, 0.1)' : '#FEF2F2', borderRadius: 8, alignItems: 'center', justifyContent: 'center' },
    docName: { fontSize: 16, fontWeight: '600', color: isDark ? '#F9FAFB' : '#171717' },
    docDate: { fontSize: 12, color: isDark ? '#9CA3AF' : '#737373' },
});
