import {Timestamp} from "firebase-admin/firestore";
import moment = require("moment-timezone");

export const timezone = "Europe/Rome";

/**
 * Check if a timestamp is older than six months
 *
 * @param {Timestamp} timestamp - The timestamp to compare
 * @return {boolean} - True if the timestamp is older than six months
 */
export const isOlderThanSixMonths = (timestamp: Timestamp): boolean => {
  const sixMonthsInMillis = 6 * 30 * 24 * 60 * 60 * 1000;
  const now = Date.now();
  return now - timestamp.toMillis() > sixMonthsInMillis;
};

/**
 * Check if a timestamp is from the last 24 hours
 *
 * @param {Timestamp} timestamp - The timestamp to compare
 * @return {boolean} - True if the timestamp is from the last 24 hours
 */
export const isLastTwentiFowHours = (timestamp: Timestamp): boolean => {
  const twentyFourHoursInMillis = 24 * 60 * 60 * 1000;
  const now = Date.now();
  return now - timestamp.toMillis() < twentyFourHoursInMillis;
};

/**
 * Get today's date at 0 a.m. in the Rome timezone
 *
 * @return {Timestamp} - The timestamp for today at 0 a.m.
 */
export const today = (): Timestamp => {
  const today = moment.tz(timezone).startOf("day").toDate();
  return Timestamp.fromDate(today);
};
