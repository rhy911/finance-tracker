# Personal Finance Auto-Tracker (Android)

Auto-track 100% money. Listen bank push notifications. No API. No manual input.

## 1. Logic Loop

1. SYSTEM: Bank App ──> Push Notification
2. NATIVE (Kotlin): FinanceNotificationService catch ──> Write ISO8601 logs to Prefs
3. BRIDGE: MethodChannel (getBackgroundLogs)
4. FLUTTER (Dart): NotificationSyncService poll logs (10s) ──> TransactionRepository
5. DATABASE: Isar (Save Transaction + RawNotification) ──> Dashboard UI refresh

## 2. Core Architecture

- Native (Android): NotificationListenerService + ForegroundService. Must be native. Stable. No kill.
- Bridge: MethodChannel. Sync logs between Kotlin and Dart.
- Flutter: UI + Parsers + Database. Business logic only.

## 3. Directory Map

- lib/core/parsers/: Bank regex logic. Heart of app.
- lib/core/services/: NotificationSyncService. Poll native logs.
- lib/core/database/: Isar schemas + TransactionRepository.
- lib/features/: UI screens (Dashboard, Onboarding, Debug).
- android/app/src/main/kotlin/: FinanceNotificationService. Listen system events.

## 4. Parser Engine (Interface)

Each bank = one class. Implement BankParser.

```dart
abstract class BankParser {
  String get packageName;   // Bank app ID
  String get bankName;      // Display name
  int get parserVersion;    // Current regex version
  ParseResult? parse(String text);
}
```

VCB Status: Version 2 active. Robust regex for card number + balance. Handle Vietnamese encoding
(dư).

## 5. Sync & Dedup

- Polling: Flutter check native logs every 10s when foreground.
- DEDUP: SHA-256(text + timestamp) = contentHash. No double records.
- Sync: Parse log line -> Save to Transaction + RawNotification.

## 6. Database (Isar)

- Transaction: Parsed money data.
- RawNotification: Original text for status check/re-parse.
- CategoryRule: Keywords to auto-category.

## 7. Security (Strict)

- Offline: No INTERNET permission. Data stay on phone.
- No Tracking: No analytics. No Firebase.
- Local Auth: Use Fingerprint/PIN to open app.

## 8. Dev Workflow

1. Add Bank: Implement BankParser -> Register in BankParserRegistry.
1. Fix Regex: Update parserVersion -> Add test in test/parsers/.
1. Test: Run flutter test. Verify with real noti string.
