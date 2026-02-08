import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import 'react-native-reanimated';

import SideDrawer from '../components/SideDrawer';
import { Colors } from '../constants/Colors';
import { AuthProvider } from '../context/AuthContext';
import { DrawerProvider } from '../context/DrawerContext';
import { PrayerSettingsProvider } from '../context/PrayerSettingsContext';
import { ThemeProvider as AppThemeProvider, useTheme } from '../context/ThemeContext';

export const unstable_settings = {
  anchor: '(tabs)',
};

export default function RootLayout() {
  return (
    <AuthProvider>
      <AppThemeProvider>
        <PrayerSettingsProvider>
          <DrawerProvider>
            <RootNavigation />
          </DrawerProvider>
        </PrayerSettingsProvider>
      </AppThemeProvider>
    </AuthProvider>
  );
}

function RootNavigation() {
  const { isDark } = useTheme();

  return (
    <ThemeProvider value={isDark ? DarkTheme : DefaultTheme}>
      <Stack>
        <Stack.Screen name="splash" options={{ headerShown: false }} />
        <Stack.Screen name="index" options={{ headerShown: false }} />
        <Stack.Screen name="auth/login" options={{ headerShown: false }} />

        <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
        <Stack.Screen name="modal" options={{ presentation: 'modal', title: 'Modal' }} />
        <Stack.Screen name="profile/personal-info" options={{ headerShown: false }} />
        <Stack.Screen name="profile/documents" options={{ headerShown: false }} />
        <Stack.Screen name="profile/bank-details" options={{ headerShown: false }} />
        <Stack.Screen name="profile/emergency" options={{ headerShown: false }} />
        <Stack.Screen name="directory" options={{ headerShown: false }} />
        <Stack.Screen name="shift-details" options={{ headerShown: false }} />
        <Stack.Screen name="policies" options={{ headerShown: false }} />
        <Stack.Screen name="events" options={{ headerShown: false }} />
        <Stack.Screen name="gallery" options={{ headerShown: false }} />
        <Stack.Screen name="islamic-library" options={{ headerShown: false }} />
      </Stack>
      <SideDrawer />
      <AppStatusBar />
    </ThemeProvider>
  );
}

function AppStatusBar() {
  const { isDark } = useTheme();
  const theme = Colors[isDark ? 'dark' : 'light'];

  return <StatusBar style={isDark ? 'light' : 'dark'} backgroundColor={theme.background} translucent={false} />;
}
