import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import 'react-native-reanimated';

import { useColorScheme } from '@/hooks/use-color-scheme';

export const unstable_settings = {
  anchor: '(tabs)',
};

import { ThemeProvider as AppThemeProvider } from '../context/ThemeContext';

export default function RootLayout() {
  const colorScheme = useColorScheme();

  return (
    <AppThemeProvider>
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
        </Stack>
        <StatusBar style="auto" />
      </ThemeProvider>
    </AppThemeProvider>
  );
}
