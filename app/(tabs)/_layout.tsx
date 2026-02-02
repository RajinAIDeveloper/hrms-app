import { Tabs } from 'expo-router';
import React from 'react';
import CustomTabBar from '@/components/CustomTabBar';

export default function TabLayout() {
  return (
    <Tabs
      tabBar={(props) => <CustomTabBar {...props} />}
      screenOptions={{
        headerShown: false,
      }}>
      <Tabs.Screen
        name="index"
        options={{
          title: 'Home',
        }}
      />
      <Tabs.Screen
        name="attendance"
        options={{
          title: 'Attendance',
        }}
      />
      <Tabs.Screen
        name="payroll"
        options={{
          title: 'Payroll',
        }}
      />
      <Tabs.Screen
        name="profile"
        options={{
          title: 'Profile',
        }}
      />
      {/* Hidden screens - still accessible but not in tab bar */}
      <Tabs.Screen name="lunch-request" options={{ href: null }} />
      <Tabs.Screen name="leave-request" options={{ href: null }} />
      <Tabs.Screen name="payslip-download" options={{ href: null }} />
      <Tabs.Screen name="notifications" options={{ href: null }} />
      <Tabs.Screen name="explore" options={{ href: null }} />
    </Tabs>
  );
}
