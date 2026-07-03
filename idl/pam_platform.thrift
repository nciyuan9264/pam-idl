namespace go pam_platform
namespace js pam_platform

// ---------- 通用响应 ----------

struct ErrorResp {
  1: required string message,
}

struct HealthzResp {
  1: required string status,
}

struct StatusResp {
  1: required string status,
}

// ---------- IDL 同步 ----------

struct IDLFile {
  1: required string path,
  2: required string content,
}

struct SyncIDLReq {
  1: required string repository,
  2: required string ref,
  3: required string refName,
  4: required string commit,
  5: optional string event,
  6: required list<IDLFile> files,
}

struct SyncResult {
  1: required string repository,
  2: optional string ref,
  3: optional string commit,
  4: required i32 filesSynced,
  5: required i32 branchesScanned,
  6: required i32 branchesSynced,
  7: required i32 branchesSkipped,
  8: required i32 branchesDeleted,
}

struct SyncStatusResp {
  1: required bool running,
  2: optional SyncResult lastResult,
  3: optional string lastError,
  4: optional string lastRunAt,
}

// ---------- 平台快照 ----------

struct SnapshotReq {
  1: optional string repository (api.query = "repository"),
  2: optional string service (api.query = "service"),
  3: optional string branch (api.query = "branch"),
}

struct RepositorySummary {
  1: required string name,
  2: required list<string> branches,
  3: required list<string> versions,
}

struct ThriftField {
  1: required i32 id,
  2: required string name,
  3: required string type,
  4: required bool required,
  5: required map<string,string> annotations,
}

struct ThriftStruct {
  1: required string name,
  2: required list<ThriftField> fields,
}

struct Endpoint {
  1: required string name,
  2: required string operationId,
  3: required string method,
  4: required string path,
  5: required string summary,
  6: required string requestType,
  7: required string responseType,
  8: required string contentType,
  9: required bool authRequired,
}

struct ServiceSummary {
  1: required string repository,
  2: required string branch,
  3: required string version,
  4: required string ref,
  5: required string commit,
  6: required string filePath,
  7: required string name,
  8: required i32 endpointCount,
  9: required list<Endpoint> endpoints,
  10: required map<string,ThriftStruct> structs,
  11: required string rawIdl,
}

struct SnapshotResp {
  1: required list<RepositorySummary> repositories,
  2: required list<ServiceSummary> services,
}

// ---------- 轻量服务目录 ----------

struct ServiceBranchSummary {
  1: required string name,
  2: required string ref,
  3: required string commit,
  4: required string filePath,
  5: required i32 endpointCount,
}

struct ServiceCatalogItem {
  1: required string name,
  2: required string repository,
  3: required list<ServiceBranchSummary> branches,
}

struct ServiceCatalogResp {
  1: required list<ServiceCatalogItem> services,
}

service PamPlatformService {
  HealthzResp Healthz() (
    api.get = "/healthz",
    api.operation_id = "healthz",
    api.summary = "健康检查"
  )

  SnapshotResp GetSnapshot(1: SnapshotReq req) (
    api.get = "/api/snapshot",
    api.operation_id = "getSnapshot",
    api.summary = "获取 IDL 平台快照",
    api.auth_required = "true"
  )

  ServiceCatalogResp ListServices() (
    api.get = "/api/services",
    api.operation_id = "listServices",
    api.summary = "获取轻量服务目录",
    api.auth_required = "true"
  )

  SyncStatusResp GetOSSSyncStatus() (
    api.get = "/api/idl/oss-sync/status",
    api.operation_id = "getOssSyncStatus",
    api.summary = "获取 OSS IDL 同步状态"
  )

  StatusResp SyncIDL(1: required SyncIDLReq req) (
    api.post = "/api/idl/sync",
    api.operation_id = "syncIdl",
    api.summary = "同步提交的 IDL 文件",
    api.auth_required = "true"
  )

  StatusResp TriggerOSSSync() (
    api.post = "/api/idl/oss-sync",
    api.operation_id = "triggerOssSync",
    api.summary = "触发 OSS IDL 后台同步",
    api.auth_required = "true"
  )
}
