# Codebase Index (HRMS App)

This repository is an Expo + Expo Router mobile app (React Native) with file-based routing under `app/`.

## Quick start

- Install deps: `npm install`
- Run dev server: `npm run start` (or `npm run android` / `npm run ios` / `npm run web`)
- Lint: `npm run lint`

## Tech stack (from `package.json`)

- Expo SDK: `~54.0.32`
- React / RN: `react@19.1.0`, `react-native@0.81.5`
- Routing: `expo-router@~6.0.22` (`"main": "expo-router/entry"`)
- Navigation: `@react-navigation/native`, `@react-navigation/bottom-tabs`
- Animation: `react-native-reanimated`, `react-native-gesture-handler`
- UI libs: `@expo/vector-icons`, `react-native-safe-area-context`, `react-native-screens`
- Charts: `react-native-chart-kit`, `react-native-svg`
- Date/time picker: `@react-native-community/datetimepicker`
- Styling (web): `tailwindcss@4` via `@tailwindcss/postcss` + `postcss.config.mjs` (`global.css` exists but is not imported anywhere yet)

## Routing / navigation map

### Root stack

Configured in `app/_layout.tsx`:

- Initial route: `app/splash.tsx` (redirects to `/auth/login`)
- Auth: `app/auth/login.tsx` (mock login → `router.replace('/(tabs)')`)
- Tabs group: `app/(tabs)/_layout.tsx`
- Modal: `app/modal.tsx` (presented as a modal screen)

### Tabs group

Configured in `app/(tabs)/_layout.tsx` with a custom tab bar (`components/CustomTabBar.tsx`):

- `app/(tabs)/index.tsx` — Home/dashboard (mock “punch in/out”, quick actions, stats, notifications)
- `app/(tabs)/attendance.tsx` — Attendance placeholder
- `app/(tabs)/payroll.tsx` — Payroll dashboard + payslip list + details modal (mock data)
- `app/(tabs)/profile.tsx` — Profile placeholder

Additional “hidden” screens that keep the bottom bar but have no tab button:

- `app/(tabs)/lunch-request.tsx`
- `app/(tabs)/leave-request.tsx`
- `app/(tabs)/payslip-download.tsx`
- `app/(tabs)/notifications.tsx`

## Key folders

- `app/` — Screens + layouts (Expo Router file-based routes)
- `components/` — Reusable UI (notably `components/CustomTabBar.tsx`, `components/themed-text.tsx`, `components/themed-view.tsx`)
- `hooks/` — Theme and color scheme hooks (`hooks/use-theme-color.ts` uses `constants/theme.ts`)
- `constants/` — Theme constants:
  - `constants/theme.ts` (richer “Recom” theme)
  - `constants/Colors.ts` (Expo template theme + `Fonts`)
- `assets/images/` — Icons/logos/splash assets (notably `assets/images/recom-logo.png`)
- `scripts/reset-project.js` — create-expo-app reset script (optional)

## Product spec / API reference

- `prd.md` — Product Requirements Document (last updated **January 27, 2026**) including proposed API endpoints (e.g. `/api/v1/auth/login`, `/api/v1/attendance/*`, `/api/v1/leave/*`, `/api/v1/payroll/*`, etc.).

## Handy repo searches

- Routes and navigation: `rg -n "router\\.(push|replace|back)" app -S`
- Theming usage: `rg -n "Colors\\[|useColorScheme\\(|useThemeColor\\(" -S`
- “Hidden” tab screens: `rg -n "tabBarButton: \\(\\) => null" app -S`

