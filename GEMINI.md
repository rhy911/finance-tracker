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

## Current Problem

- (Fixed) Màn welcome không thân thiện người dùng lắm, cần cải thiện. nút Get Started bị che, nếu ai không quen thì thì sẽ không biết lướt xuống dưới. Các chỉ dẫn ngoài 2 cái đầu không tự động tích xanh khi hoàn thành, phải để đến cuối khi xong hết và bấm reload thì nó mới hiện tích xanh.
- (Fixed) Vì vẫn có những trường hợp khiến app bị miss thông báo, vậy nên hãy thêm feature đọc lại tất cả thông báo trong một khoảng thời gian mà người dùng nhập (phút). Việc đọc lại thông báo này sẽ thực hiện ở native bởi vì app bị miss thì chắc chắn thông báo sẽ không có ở trong log. Tất nhiên là hãy đánh giá tính khả thi trước khi thực hiện.
- (Fixed) Ở phần manual add transaction, feature hiện tại đang là add những transaction ngoài phạm vi ngân hàng, những transaction này sẽ không tính vào số dư còn lại. Nhưng sẽ có những transaction trong ngân hàng nhưng notification không tuân theo parse form mà chúng ra đã code, vậy nên cần một feature để add những transaction mà sẽ tính vào số dư còn lại bằng cách user sẽ nhập amount và balance left, không cần tính toán. (fixed)

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
