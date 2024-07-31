package com.example.vania_music

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.vania_music";


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);
       var methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        );
        methodChannel.setMethodCallHandler { call, result ->
            if (call.method == "saveFileToPath") {
                val filePath = call.argument<String?>("filePath")
                val fileContent = call.argument<ByteArray?>("fileContent")
                if (fileContent != null && filePath != null) {

                    saveFileToPathViaMethodChannel(
                        this,
                        channel = methodChannel,
                        filePath = filePath,
                        fileContent = fileContent,
                    )

                    result.success(true);

                }
            }
        }

    }

    private fun saveFileToPathViaMethodChannel(
        context: Context,
        channel: MethodChannel,
        filePath: String,
        fileContent: ByteArray,
    ): Any? {
        val result = saveFileToPath(context, filePath, fileContent)
        channel.invokeMethod("saveFileToPathResult", result)
        return null
    }

    @SuppressLint("SetWorldReadable")
    private fun saveFileToPath(
        context: Context,
        filePath: String,
        fileContent: ByteArray
    ): Boolean {
        val file = File(filePath)
        val parentDir = file.parentFile
        if (!parentDir?.exists()!!) {
            parentDir.mkdirs()
        }
        return try {
            file.createNewFile();
            val fos = FileOutputStream(file)
            fos.write(fileContent)
            fos.flush()
            fos.close()
            file.setReadable(true, false);
            val intent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE)
            intent.setData(Uri.fromFile(file))
            context.sendBroadcast(intent)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false;

        }
    }
}

