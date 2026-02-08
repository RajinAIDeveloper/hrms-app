# Codebase Index (HRMS App)

This repository is primarily an Expo + Expo Router mobile app (React Native) with file-based routing under `app/`.

There is also a `lib/` folder containing Dart/Flutter sources; the repo root does **not** contain a `pubspec.yaml`, so this Dart code is not buildable as a standalone Flutter app from this repo as-is.

## Quick start (Expo app)

- Install deps: `npm install`
- Run dev server: `npm run start` (or `npm run android` / `npm run ios` / `npm run web`)
- Lint: `npm run lint`

## Build APK (Android phone)

This repo is configured for EAS Build APK outputs (see `eas.json`, `build.preview.android.buildType: "apk"`).

- Build an installable APK: `eas build -p android --profile preview`
- Download latest APK: `eas build:download -p android --latest --output hrmsapp.apk`

## Tech stack (Expo app)

- Expo SDK: `~54.0.32`
- React / RN: `react@19.1.0`, `react-native@0.81.5`
- Routing: `expo-router@~6.0.22` (`package.json#main` is `expo-router/entry`)
- Navigation: React Navigation (`@react-navigation/native`, `@react-navigation/bottom-tabs`)
- State: Context providers in `context/`
- HTTP: `axios` (`services/api.ts`)
- Secure storage: `expo-secure-store` (JWT token + refresh token)
- Local storage: `@react-native-async-storage/async-storage` (cached `userData`, theme setting)
- Animations: `react-native-reanimated`, `react-native-gesture-handler`
- Charts: `react-native-chart-kit`, `react-native-svg`
- Date/time picker: `@react-native-community/datetimepicker`
- Web styling: Tailwind v4 (`tailwindcss`, `postcss.config.mjs`, `global.css`)

## App entrypoints / config

- App config: `app.json` (icons, splash, Android package id, typed routes)
- EAS build config: `eas.json` (development/preview/production profiles)
- Root navigation + providers: `app/_layout.tsx`
- Tabs group: `app/(tabs)/_layout.tsx` (uses `components/CustomTabBar.tsx`)
- TypeScript path alias: `tsconfig.json` defines `@/* -> ./*` (used as `@/...` imports)

## Providers / state

- `context/AuthContext.tsx`
  - Persists JWT in SecureStore (`token`, optional `refreshToken`)
  - Persists decoded user data in AsyncStorage (`userData`) with a 30-day password-expiry gate
  - Login calls `authApi.login()` and redirects to `/(tabs)`
  - Logout clears storage and redirects to `/auth/login`
- `context/ThemeContext.tsx`: `light`/`dark`/`system` theme stored in AsyncStorage (`user_theme`)
- `context/DrawerContext.tsx`: controls the slide-in drawer (`components/SideDrawer.tsx`)
- `context/PrayerSettingsContext.tsx`: toggles for showing upcoming prayer times + notifications (UI state)

## API layer (Expo app)

- `services/api.ts`
  - Axios client with Bearer token injector
  - Base URL currently hardcoded to `http://13.127.139.229:9088/api`
  - Auth endpoints:
    - `POST /controlpanel/access/LoginByMobile`
    - `POST /tokens/refresh`
    - `POST /controlpanel/access/ForgetPassword`
    - `POST /controlpanel/access/ForgetPasswordVerification`
- `services/attendance.ts`
  - Manual attendance endpoints:
    - `POST /HRMS/Attendance/ManualAttendance/SaveManualAttendanceApp`
    - `GET /HRMS/Attendance/ManualAttendance/GetEmployeeManualAttendances`
- Types live in `types/` (`types/auth.types.ts`, `types/attendance.types.ts`)

Note: currently, `app/auth/login.tsx` and `app/(tabs)/manual-attendance-request.tsx` are the main screens wired to the backend; many other screens use mock data / placeholders.

## Routes / navigation map (Expo Router)

### Root stack screens (configured in `app/_layout.tsx`)

- `/splash` -> `app/splash.tsx` (checks auth state; redirects to `/(tabs)` or `/`)
- `/` -> `app/index.tsx` (onboarding/welcome carousel -> `/auth/login`)
- `/auth/login` -> `app/auth/login.tsx`
- `/(tabs)` -> `app/(tabs)/_layout.tsx` (bottom tabs)
- `/modal` -> `app/modal.tsx` (presented as a modal)
- `/profile/personal-info` -> `app/profile/personal-info.tsx`
- `/profile/documents` -> `app/profile/documents.tsx`
- `/profile/bank-details` -> `app/profile/bank-details.tsx`
- `/profile/emergency` -> `app/profile/emergency.tsx`
- `/directory` -> `app/directory.tsx`
- `/shift-details` -> `app/shift-details.tsx`
- `/policies` -> `app/policies.tsx`
- `/events` -> `app/events.tsx`
- `/gallery` -> `app/gallery.tsx`
- `/islamic-library` -> `app/islamic-library.tsx`

### Tabs group (files in `app/(tabs)/`)

Primary tabs (configured in `app/(tabs)/_layout.tsx` + rendered via `components/CustomTabBar.tsx`):

- `/(tabs)/index` -> `app/(tabs)/index.tsx` (dashboard + quick actions)
- `/(tabs)/attendance` -> `app/(tabs)/attendance.tsx` (attendance UI; mock data)
- `/(tabs)/payroll` -> `app/(tabs)/payroll.tsx` (payslips + stats; mock data)
- `/(tabs)/profile` -> `app/(tabs)/profile.tsx` (profile + settings, including theme + prayer toggles)

Additional screens in the tabs group:

- `/(tabs)/manual-attendance-request` -> `app/(tabs)/manual-attendance-request.tsx` (submits manual attendance via API)
- `/(tabs)/expense-request` -> `app/(tabs)/expense-request.tsx` (mock)
- `/(tabs)/early-departure-request` -> `app/(tabs)/early-departure-request.tsx` (mock)
- `/(tabs)/lunch-request` -> `app/(tabs)/lunch-request.tsx` (mock)
- `/(tabs)/leave-request` -> `app/(tabs)/leave-request.tsx` (mock)
- `/(tabs)/payslip-download` -> `app/(tabs)/payslip-download.tsx` (mock)
- `/(tabs)/notifications` -> `app/(tabs)/notifications.tsx` (mock)

Known mismatch: `app/(tabs)/_layout.tsx` declares a hidden `explore` screen (`href: null`), but `app/(tabs)/explore.tsx` does not exist.

## UI components (Expo app)

- `components/AppHeader.tsx`: shared app header (drawer/menu, back, notifications, logout)
- `components/SideDrawer.tsx`: left drawer; navigation to Events/Gallery (currently "coming soon" alerts) and Islamic Library
- `components/CustomTabBar.tsx`: bottom tab bar with a FAB radial menu (Directory/WorkShift/Policies)
- `components/themed-text.tsx`, `components/themed-view.tsx`: themed primitives
- `components/ui/*`: small UI helpers (icons, collapsible)

## Styling / theming (Expo app)

- Theme tokens: `constants/Colors.ts`, `constants/theme.ts`
- Theme hooks: `hooks/use-theme-color.ts`, `hooks/use-color-scheme.ts`, `hooks/use-color-scheme.web.ts`
- Tailwind/web: `global.css`, `postcss.config.mjs` (note: `global.css` is not imported anywhere yet)

## Assets

- App icons/splash/onboarding images live in `assets/images/` (notably `assets/images/recom-logo.png`)

## Docs

- `prd.md` - Product Requirements Document (dated **January 27, 2026**)
- `APIS.md` - API notes/reference for the project

## Handy repo searches

- Routes and navigation: `rg -n "router\\.(push|replace|back)" app -S`
- API usage: `rg -n "services/" app -S`
- Theming usage: `rg -n "useTheme\\(|Colors\\[" -S`
