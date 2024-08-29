import "dotenv/config";
import { Client } from "pg";
import { drizzle } from "drizzle-orm/node-postgres";
import { migrate } from "drizzle-orm/node-postgres/migrator";

const cliente = new Client({
  connectionString: process.env.DATABASE_URL!,
});

const main = async () => {
  try {
    console.log("Migration started");
    await cliente.connect();
    const db = drizzle(cliente);
    await migrate(db, { migrationsFolder: "drizzle" });
    console.log("Migration completed");
    await cliente.end();
  } catch (error) {
    console.error("Error during migration:", error);
    process.exit(1);
  }
};

main();
