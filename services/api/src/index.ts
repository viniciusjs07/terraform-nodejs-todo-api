import "dotenv/config";

import express, { NextFunction, Request, Response } from "express";

import { createServer } from "http";

import { db, todos } from "./db";

import { errorHandler, logger as pino } from "utils";
import { eq } from "drizzle-orm";
import { randomUUID } from "crypto";
import pinoHttp from "pino-http";
import bodyParser from "body-parser";
import compression from "compression";
import cors from "cors";
import helmet from "helmet";

const app = express();

// iniciação do pino-http para logger
const logger = pinoHttp({
  logger: pino,
  genReqId: function (req: Request, res: Response) {
    const existingId = req.id ?? req.headers["x-request-id"];
    if (existingId) {
      return existingId;
    }
    const id = randomUUID();
    res.setHeader("x-request-id", id);
    return id;
  },
});
// essa configuração serve como um middleware que ocorre antes das request e
// converte o body da requisição para vários formatos, inclusive json.
app.use(bodyParser.json());

// essa configuração adiciona cabeçalhos (headers) de segurança nas rotas das requests
app.use(helmet());

// essa configuração comprime as respostas das requests
app.use(compression());

// essa configuração acessa a apis externas
app.use(cors());

app.use(logger);

// Api routes

app.get("/", (req: Request, res: Response) => {
  res.send("Hello World");
});

app.get("/healthCheck", (req: Request, res: Response) => {
  try {
    res.status(200).send("OK");
  } catch (error) {
    res.status(500).send("Internal Server Error: " + error);
  }
});

app.get(
  "/api/v1/todos",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const limit = Number(req.query.limit) ?? 10;
      const result = await db
        .select({
          id: todos.id,
          task: todos.task,
          description: todos.description,
          isDone: todos.isDone,
        })
        .from(todos)
        .limit(limit >= 1 && limit <= 50 ? limit : 10);
      // logger console pinoHttp
      req.log.info({ result });
      res.status(200).json(result);
    } catch (error) {
      next(error);
    }
  }
);

app.get(
  "/api/v1/todos/:id",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await db
        .select()
        .from(todos)
        .where(eq(todos.id, req.params.id));
      // logger console pinoHttp
      req.log.info({ result });
      res.status(result.length === 1 ? 200 : 404).json(result);
    } catch (error) {
      next(error);
    }
  }
);

app.post(
  "/api/v1/todos",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await db
        .insert(todos)
        .values({
          id: randomUUID(),
          task: req.body.task,
          description: req.body.description,
          ...(req.body.dueDate && { dueDate: new Date(req.body.dueDate) }),
        })
        .returning();
      //req.log vem do pinoHttp criado no início do serviço
      req.log.info({ result });
      res.status(201).json(result);
    } catch (error) {
      next(error);
    }
  }
);

app.patch(
  "/api/v1/todos/:id",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const today = new Date();
      const result = await db
        .update(todos)
        .set({
          task: req.body.task,
          description: req.body.description,
          isDone: req.body.idDone,
          doneAt: today,
          updatedAt: today,
        })
        .where(eq(todos.id, req.params.id))
        .returning();
      // logger console pinoHttp
      req.log.info({ result });
      res.status(201).json(result);
    } catch (error) {
      next(error);
    }
  }
);

app.delete(
  "/api/v1/todos/:id",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await db.delete(todos).where(eq(todos.id, req.params.id));
      // logger console pinoHttp
      req.log.info({ result });
      res.status(result.rowCount === 1 ? 200 : 404).json();
    } catch (error) {
      next(error);
    }
  }
);

app.use((error: any, req: Request, res: Response, next: NextFunction) => {
  // global errorHandler request
  errorHandler.handleError(error, res);
});
const server = createServer(app);

const port = process.env.PORT ?? 3000;
server.listen(3000, () => {
  pino.info(`Server is running on port ${port}`);
});

//captures rejection that is not being handled
process.on("unhandledRejection", (reason, promise) => {
  pino.error({ promise, reason }, "Unhandled Rejection");
});

//captures exception that is not being handled
process.on("uncaughtException", (error) => {
  pino.error({ error }, "Uncaught Exception");

  server.close(() => {
    pino.info("Server closed");
    process.exit(1);
  });

  // If the server hasn't finished in a reasonable time, give it 10 seconds and force exit
  setTimeout(() => process.exit(1), 10000).unref();
});
