import {LogEvent} from "./log_event";

/**
 * Define the response data structure for the DAU endpoint
 */
export interface DAUResponse {
  sessions: number;
  locales: { [key: string]: number };
  logs: LogEvent[];
}
