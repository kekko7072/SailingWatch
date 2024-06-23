import {Timestamp} from "firebase-admin/firestore";

/**
 * Define the data structure for the log event
 */
export interface LogEvent {
  sessionId: string;
  event: string;
  timestamp: Timestamp;
  // data: any;
  deviceLocalization: string;
}
