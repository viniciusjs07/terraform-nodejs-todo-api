import http from "k6/http";
import { check } from "k6";
import { randomString } from "https://jslib.k6.io/k6-utils/1.4.0/index.js";

//https://grafana.com/docs/k6/latest/testing-guides/api-load-testing/

export const options = {
  vus: 5, //5 usuarios simultaneos no teste
  duration: "10s",
  thresholds: {
    http_req_failed: ["rate<0.01"], // http errors should be less than 1%
    http_req_duration: ["p(95)<200"], // 95% of requests should be below 200ms
  },
};

export default function () {
  const BASE_URL = "http://localhost:3000";
  const headers = { "Content-Type": "application/json" };

  const payload = JSON.stringify({
    task: randomString(20),
    description: randomString(50),
    isDone: true,
  });

  const todos = http.get(`${BASE_URL}/api/v1/todos?limit=${5}`, {
    params: { headers },
  });
  check(todos, {
    "Get status is 200": (r) => r.status === 200,
  });

  const res = http.post(`${BASE_URL}/api/v1/todos`, payload, { headers });
  check(res, {
    "Post status is 201": (r) => r.status === 201,
  });
}
