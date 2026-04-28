package com.example.finance_app

import android.content.Intent
import android.os.Build
import android.app.ActivityManager
import android.content.Context
import android.provider.Settings
import android.content.BroadcastReceiver
import android.content.IntentFilter
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.finance_app/service"
    private var methodChannel: MethodChannel? = null

    private val notificationReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == "com.example.finance_app.NEW_NOTIFICATION") {
                val pkg = intent.getStringExtra("package")
                val text = intent.getStringExtra("text")
                val ts = intent.getStringExtra("timestamp")
                
                val data = mapOf(
                    "package" to pkg,
                    "text" to text,
                    "timestamp" to ts
                )
                methodChannel?.invokeMethod("onNotificationReceived", data)
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    startFinanceService()
                    result.success(null)
                }
                "stopService" -> {
                    stopFinanceService()
                    result.success(null)
                }
                "checkListenerPermission" -> {
                    result.success(isNotificationServiceEnabled())
                }
                "openListenerSettings" -> {
                    startActivity(Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS"))
                    result.success(null)
                }
                "isServiceRunning" -> {
                    result.success(isServiceRunning(FinanceForegroundService::class.java))
                }
                "openOtherPermissionsSettings" -> {
                    try {
                        val intent = Intent("miui.intent.action.APP_PERM_EDITOR")
                        intent.setClassName("com.miui.securitycenter", "com.miui.permcenter.permissions.PermissionsEditorActivity")
                        intent.putExtra("extra_pkgname", packageName)
                        startActivity(intent)
                    } catch (e: Exception) {
                        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                        intent.data = android.net.Uri.fromParts("package", packageName, null)
                        startActivity(intent)
                    }
                    result.success(null)
                }
                "openAutostartSettings" -> {
                    try {
                        val intent = Intent()
                        intent.setClassName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity")
                        startActivity(intent)
                    } catch (e: Exception) {
                        val intent = Intent(Settings.ACTION_SETTINGS)
                        startActivity(intent)
                    }
                    result.success(null)
                }
                "getBackgroundLogs" -> {
                    val prefs = getSharedPreferences("background_logs", Context.MODE_PRIVATE)
                    result.success(prefs.getString("history", ""))
                }
                "clearBackgroundLogs" -> {
                    val prefs = getSharedPreferences("background_logs", Context.MODE_PRIVATE)
                    prefs.edit().remove("history").apply()
                    result.success(null)
                }
                "reReadNotifications" -> {
                    val minutes = call.argument<Int>("minutes") ?: 60
                    FinanceNotificationService.instance?.reReadNotifications(minutes)
                    result.success(FinanceNotificationService.instance != null)
                }
                else -> result.notImplemented()
            }
        }

        // Register receiver
        val filter = IntentFilter("com.example.finance_app.NEW_NOTIFICATION")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(notificationReceiver, filter, Context.RECEIVER_EXPORTED)
        } else {
            registerReceiver(notificationReceiver, filter)
        }
    }

    override fun onDestroy() {
        unregisterReceiver(notificationReceiver)
        super.onDestroy()
    }

    private fun isNotificationServiceEnabled(): Boolean {
        val pkgName = packageName
        val flat = Settings.Secure.getString(contentResolver, "enabled_notification_listeners")
        if (flat != null) {
            val names = flat.split(":").toTypedArray()
            for (name in names) {
                val cn = android.content.ComponentName.unflattenFromString(name)
                if (cn != null) {
                    if (pkgName == cn.packageName) {
                        return true
                    }
                }
            }
        }
        return false
    }

    private fun isServiceRunning(serviceClass: Class<*>): Boolean {
        val manager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        for (service in manager.getRunningServices(Int.MAX_VALUE)) {
            if (serviceClass.name == service.service.className) {
                return true
            }
        }
        return false
    }

    private fun startFinanceService() {
        val intent = Intent(this, FinanceForegroundService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }

    private fun stopFinanceService() {
        val intent = Intent(this, FinanceForegroundService::class.java)
        stopService(intent)
    }
}
