package com.example.m2messaging

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import com.jaredrummler.android.shell.Shell
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.experimental.*

class MainActivity : FlutterActivity() {
  private val CHANNEL = "com.diragi.1337/shell"
    override fun onCreate(savedInstanceState: Bundle?) {
      super.onCreate(savedInstanceState)
      //Here we listen for the MethodChannel call and do stuff
      MethodChannel(flutterView, CHANNEL).setMethodCallHandler { methodCall, result ->
        if (methodCall.method == "suCheck") {
          if (Shell.SU.available()) {
            result.success(true)
          }
        }
        var toggle: String = "";
        when (methodCall.method) {
          "enableM2" -> toggle = "enable"
          "disableM2" -> toggle = "disable"
        }
        // Ran as blocking asynchronous call to run the enable/disable script
        val script = async(CommonPool) { Shell.SU.run("sh /sdcard/Download/m2/m2_toggle.sh $toggle") }
        val await = async (CommonPool) { if (script.await().isSuccessful) result.success(true) 
        else result.error("UNAVAILABLE", "Script wasn't ran", null) }
      }
      GeneratedPluginRegistrant.registerWith(this)
    }
}
