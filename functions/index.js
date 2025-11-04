const {onCall, HttpsError} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const {defineString} = require("firebase-functions/params");
const FormData = require("form-data");
const Mailgun = require("mailgun.js");

admin.initializeApp();

// Environment Variables definieren
const mailgunApiKey = defineString("MAILGUN_API_KEY");
const mailgunDomain = defineString("MAILGUN_DOMAIN");

exports.sendLoginEmail = onCall(
    {
      region: "europe-west3",
      // App Check erzwingen
      consumeAppCheckToken: true,
    },
    async (request) => {
      // Optional: Prüfen ob App Check Token gültig ist
      if (request.app === undefined) {
        throw new HttpsError(
            "failed-precondition",
            "App Check Token fehlt oder ist ungültig",
        );
      }

      const {email} = request.data;

      if (!email || !email.includes("@")) {
        throw new HttpsError("invalid-argument", "Ungültige Email");
      }

      try {
        // Firebase Link generieren
        const link = await admin.auth()
            .generateSignInWithEmailLink(email, {
              url: "https://snuz.app/auth/verify",
              handleCodeInApp: true,
            });

        // Mailgun Client
        const mailgun = new Mailgun(FormData);
        const mg = mailgun.client({
          username: "api",
          key: mailgunApiKey.value(),
          url: "https://api.eu.mailgun.net",
        });

        // Email versenden
        const emailHtml = `
          <div style="font-family: Arial; padding: 20px;">
            <h2 style="color: #4A90E2;">Willkommen bei Snuz 😴</h2>
            <p>Klicke hier um dich anzumelden:</p>
            <a href="${link}" 
               style="background: #4A90E2; 
                      color: white; 
                      padding: 12px 30px; 
                      text-decoration: none; 
                      border-radius: 5px; 
                      display: inline-block;">
              Jetzt anmelden
            </a>
            <p style="color: #666; margin-top: 20px;">
              Link ist 1 Stunde gültig.
            </p>
          </div>
        `;

        await mg.messages.create(
            mailgunDomain.value(),
            {
              from: "Snuz <login@mg.snuz.app>",
              to: email,
              subject: "Dein Login-Link für Snuz",
              html: emailHtml,
            },
        );

        return {success: true};
      } catch (error) {
        console.error("Error:", error);
        throw new HttpsError("internal", error.message);
      }
    },
);
