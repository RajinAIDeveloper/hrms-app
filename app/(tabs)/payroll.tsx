import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, Alert, Modal, Pressable } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Colors } from '../../constants/Colors';
import { Ionicons } from '@expo/vector-icons';
import Animated, {
    FadeInDown,
    FadeInLeft,
    useSharedValue,
    useAnimatedStyle,
    withTiming,
    Easing,
} from 'react-native-reanimated';
import { router } from 'expo-router';
import AppHeader from '../../components/AppHeader';
import { LineChart } from "react-native-chart-kit";
import { Dimensions } from "react-native";
import { useTheme } from '../../context/ThemeContext';

// Animated Counter Component
const AnimatedCounter = ({ target, prefix = '', suffix = '', theme }: any) => {
    const [displayValue, setDisplayValue] = useState(0);

    useEffect(() => {
        let start = 0;
        const duration = 1500;
        const increment = target / (duration / 16);
        const timer = setInterval(() => {
            start += increment;
            if (start >= target) {
                setDisplayValue(target);
                clearInterval(timer);
            } else {
                setDisplayValue(Math.floor(start));
            }
        }, 16);
        return () => clearInterval(timer);
    }, [target]);

    return (
        <Text style={[styles.amountValue, { color: theme.text }]}>
            {prefix}{displayValue.toLocaleString()}{suffix}
        </Text>
    );
};

// Payslip Card
const PayslipCard = ({ month, year, amount, status, onPress, onDownload, theme, delay }: any) => (
    <Animated.View entering={FadeInDown.delay(delay).duration(400)}>
        <TouchableOpacity
            style={[styles.payslipCard, { backgroundColor: theme.card, borderColor: theme.border }]}
            onPress={onPress}
            activeOpacity={0.7}
        >
            <View style={styles.payslipLeft}>
                <View style={[styles.monthBadge, { backgroundColor: theme.primary + '15' }]}>
                    <Text style={[styles.monthText, { color: theme.primary }]}>{month}</Text>
                    <Text style={[styles.yearText, { color: theme.primary }]}>{year}</Text>
                </View>
                <View style={styles.payslipInfo}>
                    <Text style={[styles.payslipTitle, { color: theme.text }]}>{month} {year} Payslip</Text>
                    <Text style={[styles.payslipAmount, { color: theme.success }]}>৳{amount.toLocaleString()}</Text>
                </View>
            </View>
            <View style={styles.payslipRight}>
                <View style={[styles.statusBadge, { backgroundColor: status === 'Paid' ? theme.success + '15' : theme.warning + '15' }]}>
                    <Text style={[styles.statusText, { color: status === 'Paid' ? theme.success : theme.warning }]}>{status}</Text>
                </View>
                <TouchableOpacity onPress={(e) => { e.stopPropagation(); onDownload(); }}>
                    <Ionicons name="download-outline" size={22} color={theme.primary} />
                </TouchableOpacity>
            </View>
        </TouchableOpacity>
    </Animated.View>
);

// Detail Row for Modal
const DetailRow = ({ label, value, theme, isBold = false, isNegative = false }: any) => (
    <View style={styles.detailRow}>
        <Text style={[styles.detailLabel, { color: theme.subtext }]}>{label}</Text>
        <Text style={[
            styles.detailValue,
            { color: isNegative ? theme.error : theme.text },
            isBold && { fontWeight: '700' }
        ]}>
            {isNegative ? '-' : ''}৳{value.toLocaleString()}
        </Text>
    </View>
);

// --- Main Screen ---
export default function PayrollScreen() {
    const { isDark } = useTheme();
    const theme = Colors[isDark ? 'dark' : 'light'];

    const [selectedPayslip, setSelectedPayslip] = useState<any>(null);
    const [isModalVisible, setIsModalVisible] = useState(false);
    const [chartMode, setChartMode] = useState<'salary' | 'reimbursement'>('salary');

    const salary = 75000;
    const deductions = 5000;
    const netPay = salary - deductions;

    // Reimbursement Mock Data
    const reimbursementStats = {
        claimed: 15400,
        pending: 2400,
        approved: 13000
    };

    const payslips = [
        { month: 'Jan', year: '2026', amount: 70000, status: 'Paid', basic: 50000, hra: 15000, medical: 5000, transport: 5000, tax: 5000 },
        { month: 'Dec', year: '2025', amount: 70000, status: 'Paid', basic: 50000, hra: 15000, medical: 5000, transport: 5000, tax: 5000 },
        { month: 'Nov', year: '2025', amount: 68000, status: 'Paid', basic: 48000, hra: 15000, medical: 5000, transport: 5000, tax: 5000 },
        { month: 'Oct', year: '2025', amount: 68000, status: 'Paid', basic: 48000, hra: 15000, medical: 5000, transport: 5000, tax: 5000 },
    ];

    const chartData = {
        salary: {
            labels: ["Aug", "Sep", "Oct", "Nov", "Dec", "Jan"],
            datasets: [{ data: [68000, 68000, 68000, 68000, 70000, 70000] }]
        },
        reimbursement: {
            labels: ["Aug", "Sep", "Oct", "Nov", "Dec", "Jan"],
            datasets: [{ data: [2000, 500, 3200, 1500, 4000, 2400] }]
        }
    };

    const handleDownload = (month: string, year: string) => {
        Alert.alert("📄 Downloading", `${month} ${year} payslip will be downloaded.`);
    };

    const openDetails = (slip: any) => {
        setSelectedPayslip(slip);
        setIsModalVisible(true);
    };

    return (
        <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top']}>
            {/* Consistent Header */}
            <AppHeader />

            {/* Page Title */}
            <Animated.View entering={FadeInDown.duration(300)} style={[styles.titleRow, { backgroundColor: theme.card, borderBottomWidth: 1, borderBottomColor: theme.border }]}>
                <Text style={[styles.headerTitle, { color: theme.text }]}>💰 Payroll & Claims</Text>
            </Animated.View>

            <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scrollContent}>

                {/* Current Month Summary */}
                <View style={[styles.summaryCard, { backgroundColor: theme.primary }]}>
                    <Text style={styles.summaryTitle}>January 2026</Text>
                    <View style={styles.summaryContent}>
                        <Animated.View entering={FadeInDown.delay(100).duration(400)} style={styles.summaryItem}>
                            <Text style={styles.summaryLabel}>Gross Salary</Text>
                            <AnimatedCounter target={salary} prefix="৳" theme={{ text: 'white' }} />
                        </Animated.View>
                        <View style={styles.summaryDivider} />
                        <Animated.View entering={FadeInDown.delay(200).duration(400)} style={styles.summaryItem}>
                            <Text style={styles.summaryLabel}>Deductions</Text>
                            <AnimatedCounter target={deductions} prefix="-৳" theme={{ text: '#FCA5A5' }} />
                        </Animated.View>
                    </View>
                    <Animated.View entering={FadeInDown.delay(300).duration(400)} style={styles.netPayRow}>
                        <Text style={styles.netPayLabel}>Net Pay</Text>
                        <AnimatedCounter target={netPay} prefix="৳" theme={{ text: 'white' }} />
                    </Animated.View>
                </View>

                {/* Reimbursement Claims Summary */}
                <View style={{ paddingHorizontal: 20, marginTop: 16 }}>
                    <Text style={[styles.sectionTitle, { color: theme.text, marginBottom: 12 }]}>Reimbursement Claims</Text>
                    <View style={{ flexDirection: 'row', gap: 12 }}>
                        <View style={[styles.claimCard, { backgroundColor: theme.card, borderColor: theme.border, flex: 1 }]}>
                            <Text style={[styles.claimLabel, { color: theme.subtext }]}>Claimed</Text>
                            <Text style={[styles.claimValue, { color: theme.text }]}>৳{reimbursementStats.claimed.toLocaleString()}</Text>
                        </View>
                        <View style={[styles.claimCard, { backgroundColor: theme.card, borderColor: theme.border, flex: 1 }]}>
                            <Text style={[styles.claimLabel, { color: theme.subtext }]}>Pending</Text>
                            <Text style={[styles.claimValue, { color: theme.warning }]}>৳{reimbursementStats.pending.toLocaleString()}</Text>
                        </View>
                        <View style={[styles.claimCard, { backgroundColor: theme.card, borderColor: theme.border, flex: 1 }]}>
                            <Text style={[styles.claimLabel, { color: theme.subtext }]}>Approved</Text>
                            <Text style={[styles.claimValue, { color: theme.success }]}>৳{reimbursementStats.approved.toLocaleString()}</Text>
                        </View>
                    </View>
                </View>

                {/* Salary Breakdown */}
                <View style={[styles.breakdownCard, { backgroundColor: theme.card, borderColor: theme.border, marginTop: 24 }]}>
                    <Text style={[styles.breakdownTitle, { color: theme.text }]}>Salary Structure</Text>
                    <DetailRow label="Basic Salary" value={50000} theme={theme} />
                    <DetailRow label="House Rent" value={15000} theme={theme} />
                    <DetailRow label="Medical" value={5000} theme={theme} />
                    <DetailRow label="Transport" value={5000} theme={theme} />
                    <View style={[styles.breakdownDivider, { backgroundColor: theme.border }]} />
                    <DetailRow label="Tax Deduction" value={5000} theme={theme} isNegative />
                </View>

                {/* Analytics Section with Toggle */}
                <Animated.View entering={FadeInDown.delay(250).duration(400)} style={styles.chartContainer}>
                    <View style={styles.chartHeader}>
                        <Text style={[styles.sectionTitle, { color: theme.text }]}>Analytics & Trends</Text>
                        <View style={[styles.chartToggle, { backgroundColor: theme.border }]}>
                            <TouchableOpacity
                                style={[styles.toggleBtn, chartMode === 'salary' && { backgroundColor: theme.card, shadowOpacity: 0.1 }]}
                                onPress={() => setChartMode('salary')}
                            >
                                <Text style={[styles.toggleText, { color: chartMode === 'salary' ? theme.text : theme.subtext }]}>Salary</Text>
                            </TouchableOpacity>
                            <TouchableOpacity
                                style={[styles.toggleBtn, chartMode === 'reimbursement' && { backgroundColor: theme.card, shadowOpacity: 0.1 }]}
                                onPress={() => setChartMode('reimbursement')}
                            >
                                <Text style={[styles.toggleText, { color: chartMode === 'reimbursement' ? theme.text : theme.subtext }]}>Claims</Text>
                            </TouchableOpacity>
                        </View>
                    </View>

                    <LineChart
                        data={chartData[chartMode]}
                        width={Dimensions.get("window").width - 40}
                        height={220}
                        yAxisLabel="৳"
                        yAxisSuffix=""
                        yAxisInterval={1}
                        chartConfig={{
                            backgroundColor: theme.background,
                            backgroundGradientFrom: theme.card,
                            backgroundGradientTo: theme.card,
                            decimalPlaces: 0,
                            color: (opacity = 1) => chartMode === 'salary' ? `rgba(16, 185, 129, ${opacity})` : `rgba(59, 130, 246, ${opacity})`,
                            labelColor: (opacity = 1) => theme.subtext,
                            style: { borderRadius: 16 },
                            propsForDots: { r: "6", strokeWidth: "2", stroke: theme.background }
                        }}
                        bezier
                        style={{ marginVertical: 8, borderRadius: 16, marginHorizontal: 20 }}
                    />
                </Animated.View>

                {/* Reports Section */}
                <View style={{ paddingHorizontal: 20, marginTop: 24 }}>
                    <Text style={[styles.sectionTitle, { color: theme.text, marginBottom: 12 }]}>Reports & Documents</Text>
                    <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={{ gap: 12, paddingRight: 20 }}>
                        {[
                            { label: 'Tax Report', icon: 'document-text', color: '#8B5CF6' },
                            { label: 'Yearly Summary', icon: 'stats-chart', color: '#F59E0B' },
                            { label: 'Reimbursement History', icon: 'receipt', color: '#3B82F6' }
                        ].map((report, index) => (
                            <TouchableOpacity key={index} style={[styles.reportCard, { backgroundColor: theme.card, borderColor: theme.border }]}>
                                <View style={[styles.reportIcon, { backgroundColor: report.color + '20' }]}>
                                    <Ionicons name={report.icon as any} size={24} color={report.color} />
                                </View>
                                <Text style={[styles.reportLabel, { color: theme.text }]}>{report.label}</Text>
                                <Ionicons name="download-outline" size={16} color={theme.subtext} style={{ marginTop: 8 }} />
                            </TouchableOpacity>
                        ))}
                    </ScrollView>
                </View>

                {/* Payslip History */}
                <View style={styles.historySection}>
                    <Text style={[styles.historyTitle, { color: theme.text }]}>Payslip History</Text>
                    {payslips.map((slip, index) => (
                        <PayslipCard
                            key={index}
                            month={slip.month}
                            year={slip.year}
                            amount={slip.amount}
                            status={slip.status}
                            onPress={() => openDetails(slip)}
                            onDownload={() => handleDownload(slip.month, slip.year)}
                            theme={theme}
                            delay={300 + (index * 100)}
                        />
                    ))}
                </View>

            </ScrollView>

            {/* Payslip Detail Modal */}
            <Modal
                animationType="fade"
                transparent={true}
                visible={isModalVisible}
                onRequestClose={() => setIsModalVisible(false)}
            >
                <Pressable
                    style={styles.modalOverlay}
                    onPress={() => setIsModalVisible(false)}
                >
                    <Animated.View
                        entering={FadeInDown}
                        style={[styles.modalContent, { backgroundColor: theme.card }]}
                    >
                        <View style={styles.modalHeader}>
                            <View>
                                <Text style={[styles.modalTitle, { color: theme.text }]}>
                                    {selectedPayslip?.month} {selectedPayslip?.year} Breakdown
                                </Text>
                                <Text style={[styles.modalSubtitle, { color: theme.subtext }]}>Net Pay: ৳{selectedPayslip?.amount.toLocaleString()}</Text>
                            </View>
                            <TouchableOpacity onPress={() => setIsModalVisible(false)}>
                                <Ionicons name="close-circle" size={28} color={theme.subtext} />
                            </TouchableOpacity>
                        </View>

                        <View style={styles.modalBody}>
                            <DetailRow label="Basic Salary" value={selectedPayslip?.basic} theme={theme} />
                            <DetailRow label="House Rent (HRA)" value={selectedPayslip?.hra} theme={theme} />
                            <DetailRow label="Medical Allowance" value={selectedPayslip?.medical} theme={theme} />
                            <DetailRow label="Transport" value={selectedPayslip?.transport} theme={theme} />
                            <View style={[styles.modalDivider, { backgroundColor: theme.border }]} />
                            <DetailRow label="Tax Deduction" value={selectedPayslip?.tax} theme={theme} isNegative />
                            <View style={[styles.modalDivider, { backgroundColor: theme.border }]} />
                            <DetailRow label="Net Amount" value={selectedPayslip?.amount} theme={theme} isBold />
                        </View>

                        <TouchableOpacity
                            style={[styles.modalDownloadBtn, { backgroundColor: theme.primary }]}
                            onPress={() => {
                                handleDownload(selectedPayslip?.month, selectedPayslip?.year);
                                setIsModalVisible(false);
                            }}
                        >
                            <Ionicons name="download" size={20} color="white" />
                            <Text style={styles.modalDownloadText}>Download Payslip</Text>
                        </TouchableOpacity>
                    </Animated.View>
                </Pressable>
            </Modal>
        </SafeAreaView>
    );
}

// --- Styles ---
const styles = StyleSheet.create({
    container: { flex: 1 },
    scrollContent: { paddingBottom: 100 },
    titleRow: { padding: 16, flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
    header: { padding: 20, borderBottomWidth: 1 },
    headerTitle: { fontSize: 24, fontWeight: '700' },

    // Summary Card
    summaryCard: { margin: 20, padding: 20, borderRadius: 20 },
    summaryTitle: { color: 'white', fontSize: 16, fontWeight: '600', marginBottom: 16 },
    summaryContent: { flexDirection: 'row', alignItems: 'center' },
    summaryItem: { flex: 1 },
    summaryLabel: { color: 'rgba(255,255,255,0.7)', fontSize: 12 },
    summaryDivider: { width: 1, height: 40, backgroundColor: 'rgba(255,255,255,0.3)', marginHorizontal: 16 },
    netPayRow: { marginTop: 16, paddingTop: 16, borderTopWidth: 1, borderTopColor: 'rgba(255,255,255,0.2)', flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
    netPayLabel: { color: 'rgba(255,255,255,0.9)', fontSize: 14, fontWeight: '600' },
    amountValue: { fontSize: 24, fontWeight: '700' },

    // Breakdown
    breakdownCard: { marginHorizontal: 20, padding: 16, borderRadius: 16, borderWidth: 1 },
    breakdownTitle: { fontSize: 15, fontWeight: '700', marginBottom: 12 },
    breakdownRow: { flexDirection: 'row', justifyContent: 'space-between', paddingVertical: 8 },
    breakdownLabel: { fontSize: 13 },
    breakdownValue: { fontSize: 13, fontWeight: '600' },
    breakdownDivider: { height: 1, marginVertical: 8 },

    // History
    historySection: { paddingHorizontal: 20, marginTop: 24 },
    historyTitle: { fontSize: 15, fontWeight: '700', marginBottom: 12 },
    payslipCard: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 14, borderRadius: 14, borderWidth: 1, marginBottom: 12 },
    payslipLeft: { flexDirection: 'row', alignItems: 'center', gap: 12 },
    monthBadge: { width: 48, height: 48, borderRadius: 12, alignItems: 'center', justifyContent: 'center' },
    monthText: { fontSize: 12, fontWeight: '700' },
    yearText: { fontSize: 10 },
    payslipInfo: {},
    payslipTitle: { fontSize: 14, fontWeight: '600' },
    payslipAmount: { fontSize: 12, marginTop: 2 },
    payslipRight: { flexDirection: 'row', alignItems: 'center', gap: 12 },
    chartContainer: { marginTop: 20 },
    sectionTitle: { fontSize: 15, fontWeight: '700' },
    statusBadge: { paddingHorizontal: 8, paddingVertical: 4, borderRadius: 8 },
    statusText: { fontSize: 10, fontWeight: '600' },

    // Modal Styles
    modalOverlay: { flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', alignItems: 'center', padding: 20 },
    modalContent: { width: '100%', borderRadius: 24, padding: 24, shadowColor: '#000', shadowOffset: { width: 0, height: 10 }, shadowOpacity: 0.25, shadowRadius: 10, elevation: 10 },
    modalHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 20 },
    modalTitle: { fontSize: 18, fontWeight: '700' },
    modalSubtitle: { fontSize: 14, marginTop: 4 },
    modalBody: { marginBottom: 24 },
    detailRow: { flexDirection: 'row', justifyContent: 'space-between', paddingVertical: 10 },
    detailLabel: { fontSize: 14 },
    detailValue: { fontSize: 14, fontWeight: '600' },
    modalDivider: { height: 1, marginVertical: 8 },
    modalDownloadBtn: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 10, paddingVertical: 16, borderRadius: 16 },
    modalDownloadText: { color: 'white', fontSize: 16, fontWeight: '700' },

    // Reimbursement Claims
    claimCard: { padding: 12, borderRadius: 12, borderWidth: 1, alignItems: 'center' },
    claimLabel: { fontSize: 11, marginBottom: 4 },
    claimValue: { fontSize: 15, fontWeight: '700' },

    // Analytics Header & Toggle
    chartHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginHorizontal: 20, marginBottom: 10 },
    chartToggle: { flexDirection: 'row', borderRadius: 8, padding: 2 },
    toggleBtn: { paddingHorizontal: 12, paddingVertical: 6, borderRadius: 6 },
    toggleText: { fontSize: 12, fontWeight: '600' },

    // Reports
    reportCard: { width: 140, padding: 16, borderRadius: 16, borderWidth: 1, alignItems: 'flex-start' },
    reportIcon: { width: 40, height: 40, borderRadius: 12, alignItems: 'center', justifyContent: 'center', marginBottom: 12 },
    reportLabel: { fontSize: 13, fontWeight: '600', marginBottom: 4 },
});

