const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const { validateRepository } = require('./validator');

test('accepts js_conv on i64 ID fields and non-ID i64 values', t => {
  const root = repository(t, `
struct Request {
  1: required i64 userID (api.js_conv = "true"),
  2: optional i64 created_at_unix,
}
`);
  const first = validateRepository(root);
  const second = validateRepository(root);
  assert.deepEqual(first.errors, []);
  assert.deepEqual(second.errors, []);
});

test('rejects i64 ID fields without js_conv', t => {
  const root = repository(t, `
struct Request {
  1: required i64 game_id,
}
`);
  const result = validateRepository(root);
  assert.ok(result.errors.some(error =>
    error.includes('i64 ID field game_id must declare api.js_conv = "true"'),
  ));
});

test('does not require js_conv for non-ID i64 fields', t => {
  const root = repository(t, `
struct Request {
  1: required i64 sequence,
  2: optional i64 expires_at_unix,
  3: optional i64 valid,
}
`);
  const result = validateRepository(root);
  assert.deepEqual(result.errors, []);
});

test('validates typedef names instead of primitive targets', t => {
  const root = repository(t, `
typedef string GameType
typedef string Visibility

struct Request {
  1: required GameType game_type,
  2: required Visibility visibility,
}
`);
  const result = validateRepository(root);
  assert.deepEqual(result.errors, []);
});

function repository(t, requestFields) {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'pam-idl-validator-'));
  t.after(() => fs.rmSync(root, { recursive: true, force: true }));
  const directory = path.join(root, 'idl', 'demo', 'v1');
  fs.mkdirSync(directory, { recursive: true });
  fs.writeFileSync(path.join(directory, 'service.thrift'), `
namespace go demo.v1

${requestFields}

struct Response {
  1: required string status,
}

service DemoService {
  Response Get(1: Request req) (
    api.get = "/demo",
    api.auth_required = "false"
  )
} (
  pam.schema_version = "1",
  pam.psm = "pam.demo.rpc",
  pam.description = "validator fixture",
  pam.client.go.module = "github.com/example/demo-client",
  pam.client.go.repository = "example/demo-client",
  pam.client.go.base_ref = "main"
)
`);
  return root;
}
