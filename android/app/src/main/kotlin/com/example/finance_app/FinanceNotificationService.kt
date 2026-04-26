package com.example.finance_app

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import java.util.Date
import java.text.SimpleDateFormat
import java.util.Locale

class FinanceNotificationService : NotificationListenerService() {

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        super.onNotificationPosted(sbn)
        val packageName = sbn?.packageName ?: "unknown"
        val extras = sbn?.notification?.extras
        val title = extras?.getString("android.title") ?: ""
        val content = extras?.getCharSequence("android.text")?.toString() ?: ""
        val fullText = "$title: $content"

        Log.d("FinanceNotification", "Capture: $packageName - $fullText")
        
        // Native logging for background check
        saveToNativeLog(packageName, fullText)
    }

    private fun saveToNativeLog(pkg: String, txt: String) {
        val prefs = getSharedPreferences("background_logs", MODE_PRIVATE)
        val logs = prefs.getString("history", "") ?: ""
        
        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.US)
        val timestamp = sdf.format(Date())
        
        val newEntry = "[$timestamp] $pkg: $txt\n"
        var combinedLogs = newEntry + logs
        
        // Limit to ~100 entries to prevent huge string issues
        val lines = combinedLogs.split("\n")
        if (lines.size > 100) {
            combinedLogs = lines.take(100).joinToString("\n")
        }
        
        prefs.edit().putString("history", combinedLogs).apply()

        // Send broadcast for real-time update
        val intent = android.content.Intent("com.example.finance_app.NEW_NOTIFICATION")
        intent.putExtra("package", pkg)
        intent.putExtra("text", txt)
        intent.putExtra("timestamp", timestamp)
        sendBroadcast(intent)
    }
}
