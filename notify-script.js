const admin = require('firebase-admin');
const axios = require('axios');

const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_KEY);
const ONESIGNAL_APP_ID = process.env.ONESIGNAL_APP_ID;
const ONESIGNAL_API_KEY = process.env.ONESIGNAL_API_KEY;

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// --- Function to check for new ASSIGNMENTS (for specific technicians) ---
async function checkAssignedInterventions() {
  console.log("Checking for new assignments...");
  const snapshot = await db.collection('interventions')
    .where('notificationSent', '==', false)
    .where('assignedTechnicianIds', '!=', [])
    .get();

  if (snapshot.empty) {
    console.log('No new assignments to notify.');
    return;
  }

  for (const doc of snapshot.docs) {
    const intervention = { id: doc.id, ...doc.data() };
    console.log(`Found assignment ${intervention.code} for technicians ${intervention.assignedTechnicianIds.join(', ')}.`);

    const notification = {
      app_id: ONESIGNAL_APP_ID,
      include_external_user_ids: intervention.assignedTechnicianIds,
      headings: { en: "New Intervention Assigned" },
      contents: { en: `Ticket #${intervention.code} for '${intervention.clientName}' has been assigned to you.` },
      data: { "page": "intervention_details", "id": intervention.id },
    };

    try {
      await axios.post("https://onesignal.com/api/v1/notifications", notification, { headers: { "Authorization": `Basic ${ONESIGNAL_API_KEY}` } });
      console.log(`Assignment notification sent for ${intervention.code}.`);
      await doc.ref.update({ notificationSent: true });
    } catch (error) {
      console.error(`Error sending assignment notification for ${intervention.code}:`, error.response ? error.response.data : error.message);
    }
  }
}

// --- Function to check for RESOLVED interventions (for all users) ---
async function checkResolvedInterventions() {
  console.log("Checking for resolved interventions...");
  const snapshot = await db.collection('interventions')
    .where('status', '==', 'Resolved')
    .where('resolvedNotificationSent', '==', false)
    .get();

  if (snapshot.empty) {
    console.log('No new resolved interventions to notify.');
    return;
  }

  for (const doc of snapshot.docs) {
    const intervention = { id: doc.id, ...doc.data() };
    console.log(`Found resolved intervention ${intervention.code}.`);

    const notification = {
      app_id: ONESIGNAL_APP_ID,
      included_segments: ["Subscribed Users"], // Send to everyone
      headings: { en: "Intervention Resolved" },
      contents: { en: `Ticket #${intervention.code} for client '${intervention.clientName}' has been resolved.` },
      data: { "page": "intervention_details", "id": intervention.id },
    };

    try {
      await axios.post("https://onesignal.com/api/v1/notifications", notification, { headers: { "Authorization": `Basic ${ONESIGNAL_API_KEY}` } });
      console.log(`Resolved notification sent for ${intervention.code}.`);
      await doc.ref.update({ resolvedNotificationSent: true });
    } catch (error) {
      console.error(`Error sending resolved notification for ${intervention.code}:`, error.response ? error.response.data : error.message);
    }
  }
}

// --- Run both checks when the script executes ---
Promise.all([
  checkAssignedInterventions(),
  checkResolvedInterventions()
]).then(() => {
  console.log("All checks complete.");
}).catch(console.error);