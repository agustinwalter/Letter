const functions = require('firebase-functions');
const cors = require('cors')({origin: true})

exports.sendNotificationEmail = functions.https.onRequest((request, response) => {
  cors(request, response, () => {
    response.sendStatus(200)
    const mailgun = require("mailgun-js")
    const mg = mailgun({
      apiKey: 'e28f9abc70961c15d26a12d5d463388b-73ae490d-3b38f93c', 
      domain: 'sandboxf870e01660854c60b39f0b7782a27afb.mailgun.org'
    })
    const data = {
      from: 'Agustín Walter <agustin@letter.com>',
      to: 'letterlibros@gmail.com',
      subject: 'Recibiste un nuevo email',
      text: `Hola Agustín, una nueva persona quiere que le avises cuando Letter esté disponible:\n\n${request.query.email}`
    }
    mg.messages().send(data, (error, body) => {
      console.log(`Email de notificación enviado`)
    })
  });
})
