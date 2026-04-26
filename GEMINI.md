# Kiến trúc tối ưu mới

(A) Native layer (Android)
- NotificationListenerService
- ForegroundService
- Xử lý background
(B) Bridge layer
- MethodChannel / EventChannel
(C) Flutter layer
- UI
- Business logic nhẹ

## ĐIỀU QUAN TRỌNG: **Đừng cố làm background logic bằng Flutter**
Sai lầm phổ biến là dùng plugin kiểu:
- flutter_background_service
- workmanager
→ vẫn bị kill, không stable bằng native

## Những thứ bắt buộc bạn phải viết native
- Notification listener → bắt buộc native
- Foreground service → native
- Boot receiver → native

## Status Report (April 2026)

### Features Fixed
- [x] **Transaction Display:** Home and History screens now show Date/Time as primary title, Category as subtitle. Description moved to detail screen.
- [x] **Recent Transactions:** Home page shows top 20 nearest transactions. "See all" redirects to full history.
- [x] **Statistics:** Fully functional with Expense/Income toggle, improved chart UI, and category breakdowns.
- [x] **Settings Consolidation:** Moved Native logs, Import/Export, Category Management, and Tracker Toggle into Settings.
- [x] **Wallet Screen:** New screen for bank tracking configuration and user guidance.
- [x] **Transaction Management:** Added manual entry with polished UI and ability to delete records.
- [x] **Category Management:** Split into Keywords (Rules) and Categories list for better control.

### Next Steps
- [x] Implement real bank tracking logic in `WalletScreen` (Fully functional with Isar and custom parsers).
- Add more bank parsers for regional banks.
- Improve data visualization with more chart types.
