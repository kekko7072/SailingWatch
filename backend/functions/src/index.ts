import {onRequest} from "firebase-functions/v2/https";
import {onSchedule} from "firebase-functions/v2/scheduler";
import * as admin from "firebase-admin";
import * as express from "express";
import * as bodyParser from "body-parser";
import {Timestamp} from "firebase-admin/firestore";
import {isOlderThanSixMonths} from "./helpers";

admin.initializeApp();
const db = admin.firestore();

const app = express();
app.use(bodyParser.json());

export const sessionCollection = db.collection("sessions");

interface LogEvent {
  sessionId: string;
  event: string;
  timestamp: Timestamp;
  data: any;
  deviceLocalization: string;
}

// API endpoint to log events
app.post("/log-event", async (req, res) => {
  const log: LogEvent = {
    sessionId: req.body.sessionId,
    event: req.body.event,
    timestamp: Timestamp.now(),
    data: req.body.data,
    deviceLocalization: req.body.deviceLocalization,
  };

  try {
    // Update the session document with the last event timestamp
    await sessionCollection.doc(log.sessionId).set({
      deviceLocalization: log.deviceLocalization,
      lastEvent: log.timestamp,
    });

    // Add the event to the logs subcollection
    await sessionCollection
      .doc(log.sessionId)
      .collection("logs")
      .doc(`${log.timestamp.toMillis()}`)
      .set(log);
    res.status(200).send("Event logged successfully");
  } catch (error) {
    console.error("Error logging event:", error);
    res.status(500).send("Failed to log event");
  }
});

exports.api = onRequest(app);

// Scheduled function to run daily and delete old sessions
export const deleteOldSessions = onSchedule(
  {
    schedule: "every 24 hours",
    timeZone: "Europe/Rome",
  },
  async (context) => {
    try {
      const snapshot = await sessionCollection.get();
      const batch = db.batch();

      snapshot.forEach((doc) => {
        const data = doc.data();
        const timestamp = data.lastEvent as Timestamp;

        if (isOlderThanSixMonths(timestamp)) {
          batch.delete(doc.ref);
        }
      });

      await batch.commit();
      console.log("Old logs deleted successfully");
    } catch (error) {
      console.error("Error deleting old logs:", error);
    }
  }
);
