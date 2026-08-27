#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const repositoryRoot = path.resolve(__dirname, '..');
const idlRoot = path.join(repositoryRoot, 'idl');
const manifestPath = path.join(idlRoot, 'manifest.json');
const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
const errors = [];
const reachable = new Set();
const routes = new Map();
const serviceNames = new Set();
const namespaces = new Set();
const definitions = new Map();

function relativeToRepository(absolutePath) {
  return path.relative(repositoryRoot, absolutePath).split(path.sep).join('/');
}

function thriftFiles(directory) {
  return fs.readdirSync(directory, { withFileTypes: true }).flatMap(entry => {
    const absolute = path.join(directory, entry.name);
    if (entry.isDirectory()) return thriftFiles(absolute);
    return entry.name.endsWith('.thrift') ? [absolute] : [];
  });
}

function includes(source) {
  return Array.from(source.matchAll(/^\s*include\s+["']([^"']+)["']/gm), match => match[1]);
}

function visit(filePath, stack = []) {
  const absolute = path.resolve(filePath);
  if (!absolute.startsWith(idlRoot + path.sep)) {
    errors.push(`include escapes idl root: ${relativeToRepository(absolute)}`);
    return;
  }
  if (stack.includes(absolute)) {
    errors.push(`cyclic include: ${[...stack, absolute].map(relativeToRepository).join(' -> ')}`);
    return;
  }
  if (!fs.existsSync(absolute)) {
    errors.push(`included file does not exist: ${relativeToRepository(absolute)}`);
    return;
  }
  if (reachable.has(absolute)) return;
  reachable.add(absolute);
  const source = fs.readFileSync(absolute, 'utf8');
  for (const include of includes(source)) {
    visit(path.resolve(path.dirname(absolute), include), [...stack, absolute]);
  }
}

if (manifest.schemaVersion !== 2) {
  errors.push('manifest.schemaVersion must be 2');
}
if (!Array.isArray(manifest.services) || manifest.services.length === 0) {
  errors.push('manifest.services must not be empty');
}

for (const service of manifest.services ?? []) {
  const entrypoint = service.entrypoint ?? service.idl;
  if (!service.name || !entrypoint || !service.namespace || !service.version || !service.owner) {
    errors.push(`invalid manifest service: ${JSON.stringify(service)}`);
    continue;
  }
  if (serviceNames.has(service.name)) errors.push(`duplicate service name: ${service.name}`);
  if (namespaces.has(service.namespace)) errors.push(`duplicate service namespace: ${service.namespace}`);
  serviceNames.add(service.name);
  namespaces.add(service.namespace);

  const absolute = path.resolve(repositoryRoot, entrypoint);
  if (!fs.existsSync(absolute)) {
    errors.push(`${service.name}: entrypoint does not exist: ${entrypoint}`);
    continue;
  }
  if (!entrypoint.endsWith(`/${service.version}/service.thrift`)) {
    errors.push(`${service.name}: entrypoint must end with /${service.version}/service.thrift`);
  }
  const source = fs.readFileSync(absolute, 'utf8');
  const namespace = source.match(/^\s*namespace\s+go\s+(\S+)/m)?.[1];
  if (namespace !== service.namespace) {
    errors.push(`${service.name}: manifest namespace ${service.namespace} != IDL namespace ${namespace}`);
  }
  const declaredServices = Array.from(source.matchAll(/^\s*service\s+(\w+)/gm), match => match[1]);
  if (declaredServices.length !== 1 || declaredServices[0] !== service.name) {
    errors.push(`${service.name}: entrypoint must declare exactly that service`);
  }
  for (const match of source.matchAll(/api\.(get|post|put|patch|delete)\s*=\s*"([^"]+)"/g)) {
    const key = `${match[1].toUpperCase()} ${match[2]}`;
    const owner = routes.get(key);
    if (owner) errors.push(`HTTP route conflict ${key}: ${owner} and ${service.name}`);
    routes.set(key, service.name);
  }
  visit(absolute);
}

for (const file of thriftFiles(idlRoot)) {
  if (!reachable.has(file)) {
    errors.push(`orphan thrift file is not reachable from manifest: ${relativeToRepository(file)}`);
  }
  const source = fs.readFileSync(file, 'utf8');
  const goNamespaces = Array.from(source.matchAll(/^\s*namespace\s+go\s+(\S+)/gm), match => match[1]);
  if (goNamespaces.length !== 1) {
    errors.push(`${relativeToRepository(file)}: expected exactly one Go namespace`);
    continue;
  }
  for (const match of source.matchAll(/^\s*(?:struct|enum|union|exception|typedef|service)\s+(\w+)/gm)) {
    const key = `${goNamespaces[0]}.${match[1]}`;
    const previous = definitions.get(key);
    if (previous) {
      errors.push(`duplicate generated Go definition ${key}: ${previous} and ${relativeToRepository(file)}`);
    } else {
      definitions.set(key, relativeToRepository(file));
    }
  }
}

if (errors.length > 0) {
  for (const error of errors) console.error(`ERROR: ${error}`);
  process.exit(1);
}

console.log(`validated ${manifest.services.length} services, ${reachable.size} thrift files, ${routes.size} HTTP routes`);
