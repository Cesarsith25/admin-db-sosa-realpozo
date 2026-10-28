import 'dotenv/config';
import app from './app.js';
import { connect } from 'node:http2';
import { connectDatabase } from './config/db.js';

const PORT = process.env.PORT || 3000;

await connectDatabase();

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
