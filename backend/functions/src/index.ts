import {onRequest} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as express from "express";
import * as bodyParser from "body-parser";
import {Timestamp} from "firebase-admin/firestore";

admin.initializeApp();
const db = admin.firestore();

const app = express();
app.use(bodyParser.json());

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
    await db.collection("sessions").doc(log.sessionId).set({
      deviceLocalization: log.deviceLocalization,
      lastEvent: log.timestamp,
    });

    // Add the event to the logs subcollection
    await db
      .collection("sessions")
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
