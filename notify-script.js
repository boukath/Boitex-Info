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

async function sendNotification(userIds, intervention) {
  const notification = {
    app_id: ONESIGNAL_APP_ID,
    include_external_user_ids: userIds,
    headings: { en: "New Intervention Assigned" },
    contents: { en: `Ticket #${intervention.code} for '${intervention.clientName}' has been assigned.` },
    // THE FIX IS HERE: Changed intervention.data.id to intervention.id
    data: { "page": "intervention_details", "id": intervention.id },
  };

  try {
    await axios.post("https://onesignal.com/api/v1/notifications", notification, {
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": `Basic ${ONESIGNAL_API_KEY}`,
      },
    });
    console.log("Notification sent successfully to:", userIds);
  } catch (error) {
    console.error("Error sending notification:", error.response ? error.response.data : error.message);
  }
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
      await sendNotification(techIds, intervention);
      await doc.ref.update({ notificationSent: true });
      console.log(`Marked intervention ${intervention.code} as notified.`);
    }
  }
}

checkInterventions().catch(console.error);