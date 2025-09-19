// File: notify-script.js
const admin = require('firebase-admin');
const axios = require('axios');

// --- Configuration ---
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_KEY);
const ONESIGNAL_APP_ID = process.env.ONESIGNAL_APP_ID;
const ONESIGNAL_API_KEY = process.env.ONESIGNAL_API_KEY;

// Initialize Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function sendNotification(intervention) {
  const notification = {
    app_id: ONESIGNAL_APP_ID,
    // THIS LINE IS CHANGED: Instead of targeting specific users, we target everyone.
    included_segments: ["Subscribed Users"],
    headings: { en: "New Intervention Assigned" },
    contents: { en: `Ticket #${intervention.code} for '${intervention.clientName}' has been assigned.` },
    data: { "page": "intervention_details", "id": intervention.id },
  };

  try {
    await axios.post("https://onesignal.com/api/v1/notifications", notification, {
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": `Basic ${ONESIGNAL_API_KEY}`,
      },
    });
    console.log("Notification sent successfully to all users.");
  } catch (error) {
    console.error("Error sending notification:", error.response ? error.response.data : error.message);
  }
}

async function checkInterventions() {
  console.log("Checking for interventions needing notification...");

  const interventionsRef = db.collection('interventions');
  // We only need to find un-notified interventions now, not check if they are assigned.
  const snapshot = await interventionsRef
    .where('notificationSent', '==', false)
    .get();

  if (snapshot.empty) {
    console.log('No new interventions to notify.');
    return;
  }

  for (const doc of snapshot.docs) {
    const intervention = { id: doc.id, ...doc.data() };

    console.log(`Found intervention ${intervention.code} to notify all users.`);
    // We send the notification for the intervention...
    await sendNotification(intervention);

    // ...and then mark it as sent.
    await doc.ref.update({ notificationSent: true });
    console.log(`Marked intervention ${intervention.code} as notified.`);
  }
}

checkInterventions().catch(console.error);