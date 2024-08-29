import { Response } from "express";
import { logger } from "./logger";

class ErrorHandler {
  public async handleError(
    err: Error,
    responseStream: Response
  ): Promise<void> {
    logger.error({
      message: err.message || "An unexpected error occurred",
      err,
    });

    if (err instanceof Error) {
      const error = err as Error & { statusCode?: number };
      responseStream.status(error.statusCode ?? 400).json({
        message: err.message,
      });
      return;
    }

    responseStream.status(500).json({
      message: "Internal server error",
    });
  }
}

export const errorHandler = new ErrorHandler();
