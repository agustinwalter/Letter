const functions = require('firebase-functions');
let admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.sendMessageNotification = functions.https.onRequest((request, response) => {
  admin.messaging().sendToDevice(
    request.body.token,
    {
      notification: {
        title: request.body.name,
        body: request.body.message,
        sound: 'default',
        badge: '0',
        color: '#00ddff',
        clickAction: 'FLUTTER_NOTIFICATION_CLICK'
      }
    }
  );
  response.send("Notificación enviada, o no...");
});
