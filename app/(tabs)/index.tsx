import React, { useState, useEffect, useRef } from 'react';
import { View, Text, TouchableOpacity, ScrollView, StyleSheet, Image, Dimensions } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
  withTiming,
  withSequence,
  interpolate,
  Easing
} from 'react-native-reanimated';
import { useTheme } from '../../context/ThemeContext';
import AppHeader from '../../components/AppHeader';

const { width } = Dimensions.get('window');



// --- Main Dashboard Component ---
export default function Dashboard() {
  const router = useRouter();
  const { isDark } = useTheme();
  const dynamicStyles = getStyles(isDark);

  // Biometric/Timer State
  const [isPunchedIn, setIsPunchedIn] = useState(false);
  const [timer, setTimer] = useState(0); // in seconds
  const intervalRef = useRef<any>(null);

  // Animation Values
  const fingerprintScale = useSharedValue(1);

  // Timer Logic
  useEffect(() => {
    if (isPunchedIn) {
      intervalRef.current = setInterval(() => {
        setTimer(t => t + 1);
      }, 1000);
    } else {
      if (intervalRef.current) clearInterval(intervalRef.current);
    }
    return () => { if (intervalRef.current) clearInterval(intervalRef.current); };
  }, [isPunchedIn]);

  const formatTime = (seconds: number) => {
    const h = Math.floor(seconds / 3600);
    const m = Math.floor((seconds % 3600) / 60);
    const s = seconds % 60;
    return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
  };

  const handleBiometricPress = () => {
    // Pop Animation
    fingerprintScale.value = withSequence(
      withTiming(1.2, { duration: 150, easing: Easing.ease }),
      withSpring(1, { damping: 10 })
    );

    setIsPunchedIn(!isPunchedIn);
  };

  const fpStyle = useAnimatedStyle(() => ({
    transform: [{ scale: fingerprintScale.value }]
  }));

  const QUICK_ACTIONS = [
    { id: 'lunch', label: 'Apply Lunch', icon: 'fast-food-outline', route: '/(tabs)/lunch-request', color: '#EF4444' },
    { id: 'leave', label: 'Apply Leave', icon: 'airplane-outline', route: '/(tabs)/leave-request', color: '#F59E0B' },
    { id: 'expense', label: 'Expense Reimbursement', icon: 'receipt-outline', route: '/(tabs)/expense-request', color: '#10B981' },
    { id: 'documents', label: 'HR Documents', icon: 'document-text-outline', route: '/(tabs)/payslip-download', color: '#8B5CF6' },
  ];

  const handleActionPress = (action: any) => {
    router.push(action.route);
  };

  return (
    <SafeAreaView style={dynamicStyles.container} edges={['top']}>
      {/* Header: Center Logo + Logout */}
      <AppHeader showLogout={true} showLogo={true} />

      <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={{ paddingBottom: 100 }}>

        {/* Greeting Section with Avatar (Restored) */}
        <View style={dynamicStyles.greetingContainer}>
          <View>
            <Text style={dynamicStyles.greetingText}>Good Morning,</Text>
            <Text style={dynamicStyles.userName}>Rahim Ahmed</Text>
          </View>
          <TouchableOpacity onPress={() => router.push('/(tabs)/profile')}>
            <Image
              source={{ uri: 'https://cdn.usegalileo.ai/sdxl10/68175782-9905-4dcf-8848-f2b7a97fd22f.png' }}
              style={dynamicStyles.avatar}
            />
          </TouchableOpacity>
        </View>

        {/* Biometric Punch Card */}
        <View style={dynamicStyles.biometricCard}>
          <View style={dynamicStyles.shiftInfo}>
            <Ionicons name="time-outline" size={16} color={isDark ? '#9CA3AF' : '#6B7280'} />
            <Text style={dynamicStyles.shiftText}>Shift: 09:00 AM - 06:00 PM</Text>
          </View>

          <TouchableOpacity onPress={handleBiometricPress} activeOpacity={0.7} style={dynamicStyles.fingerprintBtnWrapper}>
            <Animated.View style={[
              dynamicStyles.fingerprintContainer,
              { borderColor: isPunchedIn ? '#10B981' : (isDark ? '#374151' : '#E5E7EB') },
              fpStyle
            ]}>
              <Ionicons
                name="finger-print"
                size={48}
                color={isPunchedIn ? '#10B981' : (isDark ? '#60A5FA' : '#2563EB')}
              />
            </Animated.View>
            {isPunchedIn && (
              <View style={dynamicStyles.rippleRing} />
            )}
          </TouchableOpacity>

          <Text style={dynamicStyles.timerText}>
            {isPunchedIn ? formatTime(timer) : 'Not Punched In'}
          </Text>
          <Text style={dynamicStyles.statusText}>
            {isPunchedIn ? 'Regular Shift • On Time' : 'Tap fingerprint to start'}
          </Text>
        </View>

        {/* NEW: Overview Section */}
        <View style={dynamicStyles.section}>
          <Text style={dynamicStyles.sectionTitle}>Overview</Text>
          <View style={{ flexDirection: 'row', gap: 12 }}>
            {/* Attendance % Card */}
            <View style={[dynamicStyles.overviewCard, { flex: 1, backgroundColor: isDark ? '#1F2937' : '#EFF6FF' }]}>
              <View style={[dynamicStyles.overviewIcon, { backgroundColor: '#3B82F6' }]}>
                <Ionicons name="stats-chart" size={18} color="white" />
              </View>
              <View>
                <Text style={dynamicStyles.overviewValue}>92%</Text>
                <Text style={dynamicStyles.overviewLabel}>Attendance</Text>
              </View>
            </View>

            {/* Leave Balance Card */}
            <View style={[dynamicStyles.overviewCard, { flex: 1, backgroundColor: isDark ? '#1F2937' : '#FEF3C7' }]}>
              <View style={[dynamicStyles.overviewIcon, { backgroundColor: '#F59E0B' }]}>
                <Ionicons name="briefcase" size={18} color="white" />
              </View>
              <View>
                <Text style={dynamicStyles.overviewValue}>9 Days</Text>
                <Text style={dynamicStyles.overviewLabel}>Leave Bal.</Text>
              </View>
            </View>
          </View>
        </View>

        {/* Quick Actions */}
        <View style={dynamicStyles.section}>
          <Text style={dynamicStyles.sectionTitle}>Quick Actions</Text>
          <View style={dynamicStyles.grid}>
            {QUICK_ACTIONS.map((action) => (
              <TouchableOpacity
                key={action.id}
                style={dynamicStyles.gridItem}
                onPress={() => handleActionPress(action)}
              >
                <View style={[dynamicStyles.gridIcon, { backgroundColor: isDark ? 'rgba(255,255,255,0.1)' : '#EFF6FF' }]}>
                  <Ionicons name={action.icon as any} size={24} color={action.color} />
                </View>
                <Text style={dynamicStyles.gridLabelCenter}>{action.label}</Text>
              </TouchableOpacity>
            ))}
          </View>
        </View>

        {/* Recent Activity */}
        <View style={dynamicStyles.section}>
          <Text style={dynamicStyles.sectionTitle}>Recent Activity</Text>
          {[
            { id: '1', title: 'Punched In', time: '09:02 AM', date: 'Today', icon: 'log-in-outline', color: '#22C55E' },
            { id: '2', title: 'Leave Approved', time: '04:30 PM', date: 'Yesterday', icon: 'checkmark-circle-outline', color: '#3B82F6' },
          ].map((item) => (
            <View key={item.id} style={dynamicStyles.activityItem}>
              <View style={[dynamicStyles.activityIcon, { backgroundColor: isDark ? 'rgba(255,255,255,0.05)' : '#F5F5F5' }]}>
                <Ionicons name={item.icon as any} size={20} color={item.color} />
              </View>
              <View style={{ flex: 1 }}>
                <Text style={dynamicStyles.activityTitle}>{item.title}</Text>
                <Text style={dynamicStyles.activityDate}>{item.date}</Text>
              </View>
              <Text style={dynamicStyles.activityTime}>{item.time}</Text>
            </View>
          ))}
        </View>

      </ScrollView>


    </SafeAreaView>
  );
}

// Global Styles
const styles = StyleSheet.create({
  fabContainer: {
    position: 'absolute',
    bottom: 30,
    right: 24,
    alignItems: 'center',
    zIndex: 999,
  },
  fabButton: {
    backgroundColor: '#2563EB',
    width: 64,
    height: 64,
    borderRadius: 32,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: '#3B82F6',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.4,
    shadowRadius: 8,
    elevation: 8,
  },
  menuItemContainer: {
    position: 'absolute',
    alignItems: 'center',
    width: 60,
    height: 60,
    bottom: 0,
  },
  menuItem: {
    width: 44,
    height: 44,
    borderRadius: 22,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 4,
    elevation: 6,
    marginBottom: 4,
  },
  menuLabel: {
    fontSize: 10,
    fontWeight: 'bold',
    textAlign: 'center',
    width: 80,
  },
});

const getStyles = (isDark: boolean) => StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: isDark ? '#111827' : '#F9FAFB',
  },
  greetingContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingTop: 20,
    paddingBottom: 10,
  },
  greetingText: {
    fontSize: 14,
    color: isDark ? '#9CA3AF' : '#6B7280',
  },
  userName: {
    fontSize: 24,
    fontWeight: 'bold',
    color: isDark ? '#F9FAFB' : '#111827',
  },
  avatar: {
    width: 48,
    height: 48,
    borderRadius: 24,
    borderWidth: 2,
    borderColor: isDark ? '#374151' : '#E5E7EB',
  },
  // Biometric Card
  biometricCard: {
    margin: 20,
    backgroundColor: isDark ? '#1F2937' : 'white',
    borderRadius: 24,
    padding: 24,
    alignItems: 'center',
    shadowColor: 'black',
    shadowOpacity: 0.05,
    shadowRadius: 10,
    elevation: 5,
  },
  shiftInfo: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: isDark ? '#374151' : '#F3F4F6',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 20,
    gap: 6,
    marginBottom: 24,
  },
  shiftText: {
    fontSize: 12,
    fontWeight: '600',
    color: isDark ? '#D1D5DB' : '#4B5563',
  },
  fingerprintBtnWrapper: {
    position: 'relative',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 20,
  },
  fingerprintContainer: {
    width: 100,
    height: 100,
    borderRadius: 50,
    borderWidth: 4,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: isDark ? '#1F2937' : '#EFF6FF',
  },
  rippleRing: {
    position: 'absolute',
    width: 120,
    height: 120,
    borderRadius: 60,
    borderWidth: 1,
    borderColor: '#10B981',
    opacity: 0.3,
  },
  timerText: {
    fontSize: 32,
    fontWeight: 'bold',
    fontVariant: ['tabular-nums'],
    color: isDark ? '#F9FAFB' : '#111827',
    marginBottom: 4,
  },
  statusText: {
    fontSize: 14,
    color: isDark ? '#9CA3AF' : '#6B7280',
  },
  // Grid
  section: {
    paddingHorizontal: 20,
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: isDark ? '#F9FAFB' : '#171717',
    marginBottom: 16,
  },
  grid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
  },
  gridItem: {
    width: '48%',
    backgroundColor: isDark ? '#1F2937' : 'white',
    padding: 16,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.05,
    shadowRadius: 4,
    elevation: 2,
  },
  gridIcon: {
    width: 48,
    height: 48,
    borderRadius: 24,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 12,
  },
  gridLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: isDark ? '#F9FAFB' : '#171717',
  },
  // Activity
  activityItem: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: isDark ? '#1F2937' : 'white',
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    gap: 12,
  },
  activityIcon: {
    width: 36,
    height: 36,
    borderRadius: 18,
    alignItems: 'center',
    justifyContent: 'center',
  },
  activityTitle: {
    fontSize: 14,
    fontWeight: '600',
    color: isDark ? '#F9FAFB' : '#171717',
  },
  activityDate: {
    fontSize: 12,
    color: isDark ? '#9CA3AF' : '#737373',
  },
  activityTime: {
    fontSize: 14,
    fontWeight: '600',
    color: isDark ? '#F9FAFB' : '#171717',
  },
  // Overview
  overviewCard: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    borderRadius: 16,
    gap: 12,
  },
  overviewIcon: {
    width: 40,
    height: 40,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  overviewValue: {
    fontSize: 18,
    fontWeight: 'bold',
    color: isDark ? '#F9FAFB' : '#1F2937',
  },
  overviewLabel: {
    fontSize: 12,
    color: isDark ? '#9CA3AF' : '#6B7280',
    fontWeight: '500',
  },
  gridLabelCenter: {
    fontSize: 12,
    fontWeight: '600',
    color: isDark ? '#F9FAFB' : '#171717',
    textAlign: 'center',
    marginTop: 4,
  },
});
