#!/usr/bin/env node
/**
 * Example: Using temporary files in Node.js
 */

const fs = require('fs');
const path = require('path');
const os = require('os');
const { execSync } = require('child_process');

// Helper: Create unique filename
function createUniqueFilename(prefix = 'temp') {
    const timestamp = Date.now();
    const random = Math.random().toString(36).substring(7);
    return `${prefix}-${timestamp}-${random}`;
}

// Helper: Safe cleanup
function safeCleanup(filePath) {
    try {
        if (fs.existsSync(filePath)) {
            fs.unlinkSync(filePath);
        }
    } catch (e) {
        console.warn(`Cleanup failed for ${filePath}: ${e.message}`);
    }
}

// Example 1: Basic temporary file
console.log('✓ Example 1: Basic temporary file');
const tempDir = os.tmpdir();
const tempFile1 = path.join(tempDir, createUniqueFilename('example'));

try {
    console.log(`  Created: ${tempFile1}`);
    fs.writeFileSync(tempFile1, 'Sample data\nLine 1\nLine 2\n');

    const content = fs.readFileSync(tempFile1, 'utf-8');
    console.log(`  Content: ${content.split('\n')[0]}...`);
} finally {
    safeCleanup(tempFile1);
    console.log('  Cleaned up\n');
}

// Example 2: Temporary directory
console.log('✓ Example 2: Temporary directory');
const tempDir2 = path.join(os.tmpdir(), createUniqueFilename('tempdir'));
fs.mkdirSync(tempDir2);

try {
    console.log(`  Created: ${tempDir2}`);

    // Create multiple files
    for (let i = 0; i < 3; i++) {
        const filePath = path.join(tempDir2, `file${i}.txt`);
        fs.writeFileSync(filePath, `File ${i} content\n`);
    }

    const files = fs.readdirSync(tempDir2);
    console.log(`  Files created: ${files.join(', ')}`);
} finally {
    // Recursive cleanup
    fs.rmSync(tempDir2, { recursive: true, force: true });
    console.log('  Cleaned up\n');
}

// Example 3: Temporary script creation
console.log('✓ Example 3: Temporary script');
const tempScript = path.join(os.tmpdir(), createUniqueFilename('script'));

try {
    const scriptContent = `#!/usr/bin/env node
console.log('Temporary script running with args:', process.argv.slice(2));
process.exit(0);
`;

    fs.writeFileSync(tempScript, scriptContent);
    fs.chmodSync(tempScript, 0o755);

    const result = execSync(`node ${tempScript} arg1 arg2`, { encoding: 'utf-8' });
    console.log(`  ${result.trim()}\n`);
} finally {
    safeCleanup(tempScript);
}

// Example 4: Promise-based cleanup
console.log('✓ Example 4: Promise-based with cleanup');
async function processWithTemp() {
    const tempFile = path.join(os.tmpdir(), createUniqueFilename('async'));

    try {
        await fs.promises.writeFile(tempFile, 'Async operation\n');
        const content = await fs.promises.readFile(tempFile, 'utf-8');
        console.log(`  Created and read: ${content.trim()}`);
    } finally {
        await fs.promises.unlink(tempFile).catch(e =>
            console.warn(`Cleanup failed: ${e.message}`)
        );
        console.log('  Cleaned up\n');
    }
}

processWithTemp().then(() => {
    console.log('✓ All examples completed');
});
