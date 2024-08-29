CREATE TABLE IF NOT EXISTS "todos" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"task" varchar(255) NOT NULL,
	"description" text,
	"due_date" timestamp,
	"is_done" boolean DEFAULT false,
	"done_ate" timestamp,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now()
);
