import * as functions from "firebase-functions";
import * as OneSignal from "onesignal-node";

// Initialize the OneSignal client
const oneSignalAppId = functions.config().onesignal.appid;
const oneSignalRestApiKey = functions.config().onesignal.restkey;
const oneSignalClient = new OneSignal.Client(oneSignalAppId, oneSignalRestApiKey);

/**
 * Triggered when an intervention document is updated.
 * It sends a push notification to all users if the status changes to 'Resolved'.
 */
export const onInterventionResolved = functions.firestore
  .document("interventions/{interventionId}")
  .onUpdate(async (change) => {
    // Get the data before and after the change
    const beforeData = change.before.data();
    const afterData = change.after.data();

    // Check if the status was changed TO 'Resolved'
    if (beforeData.status !== "Resolved" && afterData.status === "Resolved") {
      const userName = afterData.technicianName || "A user";
      const code = afterData.code || "a ticket";
      const client = afterData.clientName || "a client";

      // Construct the notification message
      const notification = {
        contents: {
          en: `${userName} resolved Intervention #${code} for ${client}`,
        },
        headings: {
          en: "Intervention Resolved",
        },
        // Send to everyone
        included_segments: ["Subscribed Users"],
      };

      // Send the notification using the OneSignal client
      try {
        const response = await oneSignalClient.createNotification(notification);
        console.log("Notification sent successfully:", response.body.id);
      } catch (e: any) {
        console.error("Error sending notification:", e);
        if (e.response && e.response.body) {
          console.error("OneSignal Error Body:", e.response.body);
        }
      }
    }
  });