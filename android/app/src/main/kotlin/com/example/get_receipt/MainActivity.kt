package com.get_receipt
import android.os.Bundle
import android.os.Build
import android.os.Debug
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.net.Socket

class MainActivity: FlutterActivity() {

    private val CHANNEL = "device_security"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "checkDeviceSecurity" -> {
                    result.success(isDeviceCompromised())
                }
                else -> result.notImplemented()
            }
        }
    }

    // =========================
    // SECURITY CHECKS
    // =========================

    private fun isDeviceCompromised(): Boolean {
        return isEmulator() ||
                isRooted() ||
                isMagiskPresent() ||
                isFridaRunning() ||
                detectFridaLibs() ||
                Debug.isDebuggerConnected()
    }

    private fun isEmulator(): Boolean {
        return (Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.lowercase().contains("emulator")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                || Build.MANUFACTURER.contains("Genymotion")
                || Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")
                || Build.PRODUCT == "google_sdk")
    }


    private fun isRooted(): Boolean {
        val paths = arrayOf(
                "/system/app/Superuser.apk",
                "/sbin/su",
                "/system/bin/su",
                "/system/xbin/su",
                "/data/local/xbin/su",
                "/data/local/bin/su",
                "/system/bin/failsafe/su",
                "/data/local/su"
        )

        return paths.any { File(it).exists() }
    }

    private fun isMagiskPresent(): Boolean {
        val paths = arrayOf(
                "/sbin/magisk",
                "/data/adb/magisk",
                "/system/bin/magisk"
        )
        return paths.any { File(it).exists() }
    }

    private fun isFridaRunning(): Boolean {
        return try {
            Socket("127.0.0.1", 27042).use { true }
        } catch (e: Exception) {
            false
        }
    }

    private fun detectFridaLibs(): Boolean {
        return try {
            val maps = File("/proc/self/maps").readText()
            maps.contains("frida") || maps.contains("gum-js-loop")
        } catch (e: Exception) {
            false
        }
    }
}
