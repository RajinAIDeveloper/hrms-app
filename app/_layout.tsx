import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import 'react-native-reanimated';

import { useColorScheme } from '@/hooks/use-color-scheme';
import SideDrawer from '../components/SideDrawer';
import { Colors } from '../constants/Colors';
import { DrawerProvider } from '../context/DrawerContext';
import { PrayerSettingsProvider } from '../context/PrayerSettingsContext';
import { ThemeProvider as AppThemeProvider, useTheme } from '../context/ThemeContext';

export const unstable_settings = {
  anchor: '(tabs)',
};

export default function RootLayout() {
  const colorScheme = useColorScheme();

  return (
    <AppThemeProvider>
      <PrayerSettingsProvider>
        <DrawerProvider>
          <ThemeProvider value={colorScheme === 'dark' ? DarkTheme : DefaultTheme}>
            <Stack>
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
        </DrawerProvider>
      </PrayerSettingsProvider>
    </AppThemeProvider>
  );
}

function AppStatusBar() {
  const { isDark } = useTheme();
  const theme = Colors[isDark ? 'dark' : 'light'];

  return <StatusBar style={isDark ? 'light' : 'dark'} backgroundColor={theme.background} translucent={false} />;
}
