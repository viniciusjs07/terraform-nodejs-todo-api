import "dotenv/config";
import { Pool } from "pg";
import { drizzle } from "drizzle-orm/node-postgres";
import { faker } from "@faker-js/faker";

import * as schema from "./schema";
import { count } from "drizzle-orm";

const pool = new Pool({
  connectionString: process.env.DATABASE_URL!,
});
const db = drizzle(pool, { schema });

const main = async () => {
  const { todos } = schema;

  try {
    console.log("Seeding database");

    // Verifica o número de registros na tabela 'todos'
    const counts = await db.select({ count: count(todos.id) }).from(todos);
    // Delete all data
    // await db.delete(todos);

    if (counts[0].count === 0) {
      // create 20 records
      const todoSeed = new Array(20).fill({}).map((e, i) => {
        return {
          id: faker.string.uuid(),
          task: faker.lorem.sentence({ min: 3, max: 5 }),
          description: faker.lorem.paragraph(),
          dueDate: faker.date.anytime(),
          isDone: faker.datatype.boolean(),
          doneAt: faker.date.anytime(),
          createdAt: faker.date.anytime(),
          updatedAt: faker.date.anytime(),
        };
      });

      await db.insert(todos).values(todoSeed);
      console.log("Seeding complete");
    }

    pool.end();
  } catch (error) {
    console.error(error);
    throw new Error("Failed to seed database");
  }
};

main();
