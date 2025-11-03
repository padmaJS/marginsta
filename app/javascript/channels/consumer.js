// app/javascript/channels/consumer.js
import { createConsumer } from "@rails/actioncable"

// For development - use WebSocket with the same origin
let consumer
try {
  consumer = createConsumer()
  console.log("Action Cable consumer created:", consumer)
} catch (error) {
  console.error("Action Cable connection failed:", error)
}

export default consumer