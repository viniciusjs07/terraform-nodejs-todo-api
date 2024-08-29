import "dotenv/config";
import pino from "pino";

export const logger = pino({
  level: process.env.LOG_LEVEL,
  timestamp: pino.stdTimeFunctions.isoTime,
});
