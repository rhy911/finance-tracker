package com.example.finance_app

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import java.util.Date
import java.text.SimpleDateFormat
import java.util.Locale

class FinanceNotificationService : NotificationListenerService() {

    companion object {
        var instance: FinanceNotificationService? = null
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
    }

    override fun onDestroy() {
        super.onDestroy()
        instance = null
    }

    fun reReadNotifications(minutes: Int) {
        val activeNotifications = getActiveNotifications() ?: return
        val now = System.currentTimeMillis()
        val windowMillis = minutes * 60 * 1000L

        for (sbn in activeNotifications) {
            val postTime = sbn.postTime
            if (now - postTime <= windowMillis) {
                processNotification(sbn)
            }
        }
    }

    private fun processNotification(sbn: StatusBarNotification?) {
        val packageName = sbn?.packageName ?: "unknown"
        val extras = sbn?.notification?.extras
        val title = extras?.getString("android.title") ?: ""
        val content = extras?.getCharSequence("android.text")?.toString() ?: ""
        val fullText = "$title: $content"

        Log.d("FinanceNotification", "Processing: $packageName - $fullText")
        saveToNativeLog(packageName, fullText, sbn?.postTime ?: System.currentTimeMillis())
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        super.onNotificationPosted(sbn)
        processNotification(sbn)
    }

    private fun saveToNativeLog(pkg: String, txt: String, timeMillis: Long = System.currentTimeMillis()) {
        val prefs = getSharedPreferences("background_logs", MODE_PRIVATE)
        val logs = prefs.getString("history", "") ?: ""
        
        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.US)
        val timestamp = sdf.format(Date(timeMillis))
        
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
