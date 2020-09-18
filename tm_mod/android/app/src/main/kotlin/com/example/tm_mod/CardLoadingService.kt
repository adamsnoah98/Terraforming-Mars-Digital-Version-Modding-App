package com.example.tm_mod

import android.app.*
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

//TODO stop service on swipe to dismiss
class CardLoadingService: Service() {
    private val ID = "com.example.tm_mod/service"

    companion object {

        fun start(context: Context) {
            val start = Intent(context, CardLoadingService::class.java)
            ContextCompat.startForegroundService(context, start)
        }

        fun stop(context: Context) {
            val stop = Intent(context, CardLoadingService::class.java)
            context.stopService(stop)
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        handleO()
        val close = intent?.getIntExtra("close", 0);
        if(close == 1)
            stopSelf()
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
                this, 0, notificationIntent, 0
        )

        val notification = NotificationCompat.Builder(this, ID)
                .setContentTitle("Card Loader")
                .setContentText("Press to load next gen's cards")
                .setSmallIcon(R.drawable.notif_icon_24)
                .setContentIntent(pendingIntent)
                //TODO make button display icon instead of title
                .addAction(R.drawable.pass_icon_48, "Pass", getPassIntent(baseContext))
                .build()
        startForeground(1, notification)
        return START_NOT_STICKY
    }

    private fun getPassIntent(context: Context) : PendingIntent? {
        val intent = Intent(this, ServiceCallback::class.java)
        return PendingIntent.getBroadcast(context, 1, intent, PendingIntent.FLAG_UPDATE_CURRENT);
    }

    //If >=Oreo must explicitly request channel
    private fun handleO() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(ID, "$ID Channel",
                    NotificationManager.IMPORTANCE_DEFAULT)
            val manager = getSystemService(NotificationManager::class.java)
            manager!!.createNotificationChannel(serviceChannel)
        }
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null;
    }

}

class ServiceCallback: BroadcastReceiver() {

    @Override
    override fun onReceive(p0: Context?, p1: Intent?) {
        MainActivity.methodChannel?.invokeMethod("inGamePass", null)
    }
}