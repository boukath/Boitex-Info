// File: notify-script.js
const admin = require('firebase-admin');
const axios = require('axios');

const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_KEY);
const ONESIGNAL_APP_ID = process.env.ONESIGNAL_APP_ID;
const ONESIGNAL_API_KEY = process.env.ONESIGNAL_API_KEY;

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function sendNotification(userIds, intervention) {
  const notification = {
    app_id: ONESIGNAL_APP_ID,
    include_external_user_ids: userIds,
    headings: { en: "New Intervention Assigned" },
    contents: { en: `Ticket #${intervention.code} for '${intervention.clientName}' has been assigned.` },
    data: { "page": "intervention_details", "id": intervention.id },
  };

  // The 'try/catch' block now only handles sending the notification
  await axios.post("https://onesignal.com/api/v1/notifications", notification, {
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": `Basic ${ONESIGNAL_API_KEY}`,
    },
  });
  console.log("Notification sent successfully to:", userIds);
}

async function checkInterventions() {
  console.log("Checking for interventions needing notification...");

  const interventionsRef = db.collection('interventions');
  const snapshot = await interventionsRef
    .where('notificationSent', '==', false)
    .where('assignedTechnicianIds', '!=', [])
    .get();

  if (snapshot.empty) {
    console.log('No new interventions to notify.');
    return;
  }

  for (const doc of snapshot.docs) {
    const intervention = { id: doc.id, ...doc.data() };
    const techIds = intervention.assignedTechnicianIds;

    if (techIds && techIds.length > 0) {
      console.log(`Found intervention ${intervention.code} for technicians ${techIds.join(', ')}.`);
      try {
        // We try to send the notification...
        await sendNotification(techIds, intervention);

        // ...and ONLY if it succeeds, we update the database.
        await doc.ref.update({ notificationSent: true });
        console.log(`Marked intervention ${intervention.code} as notified.`);
      } catch (error) {
        // If sending fails, we log the error and do NOT mark it as sent.
        console.error(`Error processing intervention ${intervention.code}:`, error.response ? error.response.data : error.message);
      }
    }
  }
}

checkInterventions().catch(console.error);