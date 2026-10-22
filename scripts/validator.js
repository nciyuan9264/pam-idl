#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

function validateRepository(root = path.resolve(__dirname, '..')) {
  const repositoryRoot = path.resolve(root);
  const idlRoot = path.join(repositoryRoot, 'idl');
  const errors = [];
  const reachable = new Set();
  const routes = new Map();
  const serviceNames = new Set();
  const namespaces = new Set();
  const psms = new Set();
  const clientModules = new Set();
  const clientRepositories = new Set();
  const definitions = new Map();
  const allowedServiceAnnotations = new Set([
    'pam.schema_version',
    'pam.psm',
    'pam.description',
    'pam.client.go.module',
    'pam.client.go.repository',
    'pam.client.go.base_ref',
  ]);
  let serviceCount = 0;
  let rpcMethodCount = 0;
  let internalMethodCount = 0;

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

  function stripComments(source) {
    return source
      .replace(/\/\*[\s\S]*?\*\//g, '')
      .replace(/(^|\s+)\/\/.*$/gm, '')
      .replace(/(^|\s+)#.*$/gm, '');
  }

  function validateI64JSONSafety(source, filePath) {
    const result = [];
    const fieldPattern = /^\s*\d+\s*:\s*(?:(?:required|optional)\s+)?i64\s+([A-Za-z_]\w*)\s*(?:\(([^)]*)\))?\s*[,;]/gm;
    for (const match of stripComments(source).matchAll(fieldPattern)) {
      const fieldName = match[1];
      const fieldAnnotations = match[2] ?? '';
      const idLike = /^id$/i.test(fieldName) || /_id$/i.test(fieldName) || /(?:Id|ID)$/.test(fieldName);
      if (!idLike) continue;
      if (!/api\.js_conv\s*=\s*["']true["']/.test(fieldAnnotations)) {
        result.push(`${filePath}: i64 ID field ${fieldName} must declare api.js_conv = "true"`);
      }
    }
    return result;
  }

  function includes(source) {
    return Array.from(source.matchAll(/^\s*include\s+["']([^"']+)["']/gm), match => match[1]);
  }

  function closingDelimiter(source, start, open, close) {
    let depth = 0;
    let quote = '';
    let escaped = false;
    for (let index = start; index < source.length; index += 1) {
      const character = source[index];
      if (quote) {
        if (escaped) {
          escaped = false;
        } else if (character === '\\') {
          escaped = true;
        } else if (character === quote) {
          quote = '';
        }
        continue;
      }
      if (character === '"' || character === "'") {
        quote = character;
      } else if (character === open) {
        depth += 1;
      } else if (character === close) {
        depth -= 1;
        if (depth === 0) return index;
      }
    }
    return -1;
  }

  function annotations(raw, serviceName) {
    const result = new Map();
    const pattern = /([\w.]+)\s*=\s*(?:"((?:\\.|[^"])*)"|'((?:\\.|[^'])*)'|([^,\s)]+))/g;
    for (const match of raw.matchAll(pattern)) {
      const key = match[1];
      const value = match[2] ?? match[3] ?? match[4] ?? '';
      if (result.has(key)) errors.push(`${serviceName}: duplicate service annotation ${key}`);
      result.set(key, value);
    }
    return result;
  }

  function parseService(source, filePath) {
    const cleaned = stripComments(source);
    const pattern = /^\s*service\s+(\w+)(?:\s+extends\s+[\w.]+)?\s*\{/gm;
    const declarations = Array.from(cleaned.matchAll(pattern));
    if (declarations.length === 0) return null;
    if (declarations.length !== 1) {
      errors.push(`${filePath}: expected exactly one service declaration`);
      return null;
    }

    const declaration = declarations[0];
    const name = declaration[1];
    const bodyStart = declaration.index + declaration[0].lastIndexOf('{');
    const bodyEnd = closingDelimiter(cleaned, bodyStart, '{', '}');
    if (bodyEnd < 0) {
      errors.push(`${filePath}: service ${name} is not closed`);
      return null;
    }

    const trailing = cleaned.slice(bodyEnd + 1).trimStart();
    if (!trailing.startsWith('(')) {
      errors.push(`${name}: service metadata annotations are required`);
      return { name, body: cleaned.slice(bodyStart + 1, bodyEnd), annotations: new Map() };
    }
    const annotationsEnd = closingDelimiter(trailing, 0, '(', ')');
    if (annotationsEnd < 0) {
      errors.push(`${name}: service annotation block is not closed`);
      return { name, body: cleaned.slice(bodyStart + 1, bodyEnd), annotations: new Map() };
    }
    return {
      name,
      body: cleaned.slice(bodyStart + 1, bodyEnd),
      annotations: annotations(trailing.slice(1, annotationsEnd), name),
    };
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

  for (const file of thriftFiles(idlRoot)) {
    const filePath = relativeToRepository(file);
    const source = fs.readFileSync(file, 'utf8');
    const parsed = parseService(source, filePath);
    if (!parsed) continue;

    serviceCount += 1;
    const { name: serviceName, body: serviceBody, annotations: metadata } = parsed;
    if (!/^idl\/.+\/v[1-9][0-9]*\/service\.thrift$/.test(filePath)) {
      errors.push(`${serviceName}: service entrypoint must match idl/**/vN/service.thrift`);
    }
    if (serviceNames.has(serviceName)) errors.push(`duplicate service name: ${serviceName}`);
    serviceNames.add(serviceName);

    for (const key of metadata.keys()) {
      if (key.startsWith('pam.') && !allowedServiceAnnotations.has(key)) {
        errors.push(`${serviceName}: unsupported PAM annotation ${key}`);
      }
    }
    for (const key of allowedServiceAnnotations) {
      if (!metadata.get(key)) errors.push(`${serviceName}: missing service annotation ${key}`);
    }
    if (metadata.get('pam.schema_version') !== '1') {
      errors.push(`${serviceName}: pam.schema_version must be 1`);
    }

    const psm = metadata.get('pam.psm') ?? '';
    const module = metadata.get('pam.client.go.module') ?? '';
    const repository = metadata.get('pam.client.go.repository') ?? '';
    const baseRef = metadata.get('pam.client.go.base_ref') ?? '';
    if (!/^[a-z][a-z0-9_-]*\.[a-z][a-z0-9_-]*\.[a-z][a-z0-9_-]*$/.test(psm)) {
      errors.push(`${serviceName}: invalid PSM ${psm}`);
    }
    if (!/^[A-Za-z0-9.-]+(?:\/[A-Za-z0-9._-]+)+$/.test(module)) {
      errors.push(`${serviceName}: invalid Go client module ${module}`);
    }
    if (!/^[A-Za-z0-9._-]+\/[A-Za-z0-9._-]+$/.test(repository)) {
      errors.push(`${serviceName}: invalid Go client repository ${repository}`);
    }
    if (!/^[A-Za-z0-9._/-]+$/.test(baseRef) || baseRef.includes('..')) {
      errors.push(`${serviceName}: invalid Go client base ref ${baseRef}`);
    }
    if (psms.has(psm)) errors.push(`duplicate service PSM: ${psm}`);
    if (clientModules.has(module)) errors.push(`duplicate Go client module: ${module}`);
    if (clientRepositories.has(repository)) errors.push(`duplicate Go client repository: ${repository}`);
    psms.add(psm);
    clientModules.add(module);
    clientRepositories.add(repository);

    const namespace = source.match(/^\s*namespace\s+go\s+(\S+)/m)?.[1];
    if (!namespace) errors.push(`${serviceName}: Go namespace is required`);
    if (namespaces.has(namespace)) errors.push(`duplicate service namespace: ${namespace}`);
    namespaces.add(namespace);

    const methodMatches = Array.from(serviceBody.matchAll(
      /^\s*(?:oneway\s+)?[A-Za-z_][\w.<>, ]*\s+(\w+)\s*\([^)]*\)\s*(?:throws\s*\([^)]*\)\s*)?(?:\(|$)/gm,
    ));
    for (let index = 0; index < methodMatches.length; index += 1) {
      const method = methodMatches[index];
      const next = methodMatches[index + 1];
      const block = serviceBody.slice(method.index, next?.index ?? serviceBody.length);
      const httpAnnotations = Array.from(block.matchAll(/api\.(get|post|put|patch|delete)\s*=\s*"([^"]+)"/g));
      const internal = /api\.internal\s*=\s*"true"/.test(block);
      const authRequired = block.match(/api\.auth_required\s*=\s*"([^"]+)"/)?.[1];
      const machineAuthRequired = block.match(/api\.machine_auth_required\s*=\s*"([^"]+)"/)?.[1];
      const authRoles = block.match(/api\.auth_roles\s*=\s*"([^"]*)"/)?.[1]
        .split(',')
        .map(role => role.trim())
        .filter(Boolean) ?? [];
      rpcMethodCount += 1;
      if (internal) internalMethodCount += 1;
      if (httpAnnotations.length === 0 && !internal) {
        errors.push(`${serviceName}.${method[1]}: method must declare one HTTP annotation or api.internal = "true"`);
      }
      if (httpAnnotations.length > 1 || (httpAnnotations.length > 0 && internal)) {
        errors.push(`${serviceName}.${method[1]}: method has conflicting exposure annotations`);
      }
      if (httpAnnotations.length > 0 && authRequired === undefined) {
        errors.push(serviceName + '.' + method[1] + ': public method must declare api.auth_required');
      }
      if (authRequired !== undefined && authRequired !== 'true' && authRequired !== 'false') {
        errors.push(serviceName + '.' + method[1] + ': api.auth_required must be "true" or "false"');
      }
      if (machineAuthRequired !== undefined && machineAuthRequired !== 'true' && machineAuthRequired !== 'false') {
        errors.push(serviceName + '.' + method[1] + ': api.machine_auth_required must be "true" or "false"');
      }
      if (authRequired === 'true' && machineAuthRequired === 'true') {
        errors.push(serviceName + '.' + method[1] + ': api.auth_required and api.machine_auth_required cannot both be "true"');
      }
      if (authRoles.length > 0 && authRequired !== 'true') {
        errors.push(serviceName + '.' + method[1] + ': api.auth_roles requires api.auth_required = "true"');
      }
    }
    for (const match of serviceBody.matchAll(/^\s*\S+\s+(\w+)\s*\(\s*\)\s*\(/gm)) {
      errors.push(`${serviceName}.${match[1]}: HTTPThriftGeneric requires at least one argument`);
    }
    for (const match of serviceBody.matchAll(/api\.(get|post|put|patch|delete)\s*=\s*"([^"]+)"/g)) {
      const key = `${match[1].toUpperCase()} ${match[2]}`;
      const owner = routes.get(key);
      if (owner) errors.push(`HTTP route conflict ${key}: ${owner} and ${serviceName}`);
      routes.set(key, serviceName);
    }
    visit(file);
  }

  if (serviceCount === 0) errors.push('IDL repository must declare at least one service');

  for (const file of thriftFiles(idlRoot)) {
    if (!reachable.has(file)) {
      errors.push(`orphan thrift file is not reachable from a service entrypoint: ${relativeToRepository(file)}`);
    }
    const source = fs.readFileSync(file, 'utf8');
    errors.push(...validateI64JSONSafety(source, relativeToRepository(file)));
    const goNamespaces = Array.from(source.matchAll(/^\s*namespace\s+go\s+(\S+)/gm), match => match[1]);
    if (goNamespaces.length !== 1) {
      errors.push(`${relativeToRepository(file)}: expected exactly one Go namespace`);
      continue;
    }
    const namedDefinitions = [
      ...source.matchAll(/^\s*(?:struct|enum|union|exception|service)\s+(\w+)/gm),
      ...source.matchAll(/^\s*typedef\s+[A-Za-z_][\w.<>, ]*\s+(\w+)(?:\s*\([^)]*\))?\s*$/gm),
    ];
    for (const match of namedDefinitions) {
      const key = `${goNamespaces[0]}.${match[1]}`;
      const previous = definitions.get(key);
      if (previous) {
        errors.push(`duplicate generated Go definition ${key}: ${previous} and ${relativeToRepository(file)}`);
      } else {
        definitions.set(key, relativeToRepository(file));
      }
    }
  }

  const summary =
    `validated ${serviceCount} services, ${reachable.size} thrift files, ` +
    `${rpcMethodCount} RPC methods (${routes.size} HTTP, ${internalMethodCount} internal)`;
  return {
    errors,
    summary,
    serviceCount,
    thriftFileCount: reachable.size,
    rpcMethodCount,
    httpRouteCount: routes.size,
    internalMethodCount,
  };
}

module.exports = {
  validateRepository,
};
