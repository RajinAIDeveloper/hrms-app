import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Alert } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Colors } from '../../constants/Colors';
import { Ionicons } from '@expo/vector-icons';
import Animated, { FadeInDown } from 'react-native-reanimated';
import { router } from 'expo-router';
import { useTheme } from '../../context/ThemeContext';

// Download Option Card
const DownloadOption = ({ icon, title, subtitle, color, onPress, theme, delay }: any) => (
    <Animated.View entering={FadeInDown.delay(delay).duration(400)}>
        <TouchableOpacity
            style={[styles.optionCard, { backgroundColor: theme.card, borderColor: theme.border }]}
            onPress={onPress}
            activeOpacity={0.7}
        >
            <View style={[styles.optionIcon, { backgroundColor: color + '15' }]}>
                <Ionicons name={icon} size={28} color={color} />
            </View>
            <View style={styles.optionInfo}>
                <Text style={[styles.optionTitle, { color: theme.text }]}>{title}</Text>
                <Text style={[styles.optionSubtitle, { color: theme.subtext }]}>{subtitle}</Text>
            </View>
            <Ionicons name="download-outline" size={24} color={theme.primary} />
        </TouchableOpacity>
    </Animated.View>
);

export default function PayslipDownloadScreen() {
    const { isDark } = useTheme();
    const theme = Colors[isDark ? 'dark' : 'light'];

    const currentMonth = new Date().toLocaleDateString('en-US', { month: 'long', year: 'numeric' });

    const handleDownload = (type: string) => {
        Alert.alert(
            "📥 Downloading",
            `Your ${type} is being downloaded...`,
            [{ text: "OK" }]
        );
    };

    return (
        <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top']}>
            {/* Header */}
            <Animated.View entering={FadeInDown.duration(300)} style={[styles.header, { backgroundColor: theme.card, borderBottomColor: theme.border }]}>
                <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
                    <Ionicons name="arrow-back" size={24} color={theme.text} />
                </TouchableOpacity>
                <Text style={[styles.headerTitle, { color: theme.text }]}>📄 Download Documents</Text>
                <View style={{ width: 40 }} />
            </Animated.View>

            <View style={styles.content}>
                <Text style={[styles.sectionLabel, { color: theme.subtext }]}>SELECT DOCUMENT</Text>

                <DownloadOption
                    icon="document-text"
                    title="Current Payslip"
                    subtitle={currentMonth}
                    color={theme.primary}
                    onPress={() => handleDownload('Payslip for ' + currentMonth)}
                    theme={theme}
                    delay={100}
                />

                <DownloadOption
                    icon="card"
                    title="Tax Card"
                    subtitle="Fiscal Year 2025-26"
                    color="#10B981"
                    onPress={() => handleDownload('Tax Card for FY 2025-26')}
                    theme={theme}
                    delay={200}
                />

                <DownloadOption
                    icon="folder-open"
                    title="All Payslips"
                    subtitle="View complete history"
                    color="#F59E0B"
                    onPress={() => router.push('/(tabs)/payroll')}
                    theme={theme}
                    delay={300}
                />
            </View>
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1 },
    header: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 16, borderBottomWidth: 1 },
    backButton: { padding: 8 },
    headerTitle: { fontSize: 20, fontWeight: '700' },
    content: { padding: 20 },
    sectionLabel: { fontSize: 12, fontWeight: '600', marginBottom: 16, textTransform: 'uppercase', letterSpacing: 0.5 },
    optionCard: { flexDirection: 'row', alignItems: 'center', padding: 16, borderRadius: 16, borderWidth: 1, marginBottom: 12 },
    optionIcon: { width: 56, height: 56, borderRadius: 16, alignItems: 'center', justifyContent: 'center', marginRight: 16 },
    optionInfo: { flex: 1 },
    optionTitle: { fontSize: 16, fontWeight: '600' },
    optionSubtitle: { fontSize: 13, marginTop: 2 },
});
