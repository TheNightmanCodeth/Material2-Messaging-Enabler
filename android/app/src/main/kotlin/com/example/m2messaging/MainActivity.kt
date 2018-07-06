package com.example.m2messaging

import android.os.Bundle
import android.os.AsyncTask

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import com.jaredrummler.android.shell.Shell
import com.jaredrummler.android.shell.CommandResult

class MainActivity(): FlutterActivity() {
  private val CHANNEL = "com.diragi.1337/shell"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    MethodChannel(flutterView, CHANNEL).setMethodCallHandler{ call, result ->
      checkForRoot()
    }

    GeneratedPluginRegistrant.registerWith(this)
  }

  private fun enableM2(root: Boolean): Boolean {
    if (root){
      // * First we kill massaging if it's running
      Shell.SU.run("am force-stop com.google.android.apps.messaging")
      // * Then we replace the first value in /data/data/com.google.apps.messaging/shared_prefs/PenotypePrefs.xml
      Shell.SU.run("sed -i '/<boolean name=\"bugle_phenotype__enable_m2\" value=\"false\" \/\>/c\    <boolean name=\"bugle_phenotype__enable_m2\" value=\"true\" \/\>' /data/data/com.google.android.apps.messaging/shared_prefs/PhenotypePrefs.xml")
      // * And lastly replace the next value
      Shell.SU.run("sed -i '/<boolean name=\"bugle_phenotype__enable_phenotype_override\" value=\"false\" \/\>/c\    <boolean name=\"bugle_phenotype__enable_phenotype_override\" value=\"true\" \/\>' /data/data/com.google.android.apps.messaging/shared_prefs/PhenotypePrefs.xml")
      return true
    } else {
      return false
    }
  }

  private fun disableM2(root: Boolean): Boolean {
    if (root){
      // * First we kill massaging if it's running
      Shell.SU.run("am force-stop com.google.android.apps.messaging")
      // * Then we replace the first value in /data/data/com.google.apps.messaging/shared_prefs/PenotypePrefs.xml
      Shell.SU.run("sed -i '/<boolean name=\"bugle_phenotype__enable_m2\" value=\"true\" \/\>/c\    <boolean name=\"bugle_phenotype__enable_m2\" value=\"false\" \/\>' /data/data/com.google.android.apps.messaging/shared_prefs/PhenotypePrefs.xml")
      // * And lastly replace the next value
      Shell.SU.run("sed -i '/<boolean name=\"bugle_phenotype__enable_phenotype_override\" value=\"true\" \/\>/c\    <boolean name=\"bugle_phenotype__enable_phenotype_override\" value=\"false\" \/\>' /data/data/com.google.android.apps.messaging/shared_prefs/PhenotypePrefs.xml")
      return true
    } else {
      return false
    }
  }

  private fun checkForRoot(enable: Boolean) {
    object : AsyncTask<Void, Void, Boolean>() {
      override fun doInBackground(vararg params: Void?): Boolean {
        return Shell.SU.available()
      }
      override fun onPostExecute(available: Boolean) {
        if (enable) {enableM2(available)}
        else {disableM2(available)}
      }
    }.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR)
  }
}
