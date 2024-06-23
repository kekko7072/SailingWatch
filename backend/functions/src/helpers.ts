import {Timestamp} from "firebase-admin/firestore";

// Function to check if 6 months have passed since the given timestamp
export const isOlderThanSixMonths = (timestamp: Timestamp): boolean => {
  const sixMonthsInMillis = 6 * 30 * 24 * 60 * 60 * 1000;
  const now = Date.now();
  return now - timestamp.toMillis() > sixMonthsInMillis;
};

export const isLastTwentiFowHours = (timestamp: Timestamp): boolean => {
  const twentyFourHoursInMillis = 24 * 60 * 60 * 1000;
  const now = Date.now();
  return now - timestamp.toMillis() < twentyFourHoursInMillis;
};
