import {
  pgTable,
  varchar,
  timestamp,
  boolean,
  text,
  uuid,
} from "drizzle-orm/pg-core";

export const todos = pgTable("todos", {
  id: uuid("id").defaultRandom().primaryKey(),
  task: varchar("task", { length: 255 }).notNull(),
  description: text("description"),
  dueDate: timestamp("due_date"),
  isDone: boolean("is_done").default(false),
  doneAt: timestamp("done_ate"),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});
