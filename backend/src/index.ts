import { startServer } from './server';

startServer().catch((err) => {
  // eslint-disable-next-line no-console
  console.error('Fatal error starting server:', err);
  process.exit(1);
});

