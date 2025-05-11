// src/tools/index.ts
// This file imports all tool modules to ensure their registration logic runs.

import './research-manager/index.js';
import './rules-generator/index.js';
import './prd-generator/index.js';
import './user-stories-generator/index.js';
import './task-list-generator/index.js';
import './fullstack-starter-kit-generator/index.js';
import './code-refactor-generator/index.js';
import './git-summary-generator/index.js';
import './workflow-runner/index.js'; // Add this line
import './job-result-retriever/index.js'; // Added import for the job result retriever tool

// Note: process-request is currently registered in src/services/request-processor/index.ts
// If it were moved to src/tools/, its import would go here too.
// import './process-request/index.js';

// Import other tools here as they are created and migrated...

import logger from '../logger.js';
logger.debug('All tool modules imported for registration.');
