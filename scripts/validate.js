#!/usr/bin/env node

const path = require('path');

const { validateRepository } = require('./validator');

const result = validateRepository(path.resolve(__dirname, '..'));
if (result.errors.length > 0) {
  for (const error of result.errors) console.error(`ERROR: ${error}`);
  process.exitCode = 1;
} else {
  console.log(result.summary);
}
