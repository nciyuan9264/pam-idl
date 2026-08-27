namespace go pam.platform.v1
namespace js pam.platform.v1

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
  7: optional string generatedAt,
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
  4: optional string commit (api.query = "commit"),
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
  12: optional map<string,string> includedIdl,
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

// ---------- 不可变版本与生成客户端 ----------

struct ClientArtifactSummary {
  1: required string language,
  2: required string modulePath,
  3: optional string clientCommit,
  4: optional string clientTag,
  5: required string status,
  6: optional string error,
  7: required string updatedAt,
}

struct IDLVersionSummary {
  1: required string repository,
  2: required string service,
  3: required string branch,
  4: required string ref,
  5: required string commit,
  6: required string shortCommit,
  7: optional string tag,
  8: required string checksum,
  9: required string generatedAt,
  10: required bool isHead,
  11: required string filePath,
  12: required i32 endpointCount,
  13: optional ClientArtifactSummary clientArtifact,
}

struct ListServiceVersionsReq {
  1: optional string repository (api.query = "repository"),
  2: optional string service (api.query = "service"),
  3: optional string branch (api.query = "branch"),
}

struct ServiceVersionsResp {
  1: required list<IDLVersionSummary> versions,
}

struct ReportClientBuildReq {
  1: required string repository,
  2: required string commit,
  3: optional string language,
  4: required string status,
  5: optional string modulePath,
  6: optional string clientCommit,
  7: optional string clientTag,
  8: optional string error,
}

// ---------- Gateway 环境版本控制 ----------

struct PromoteGatewayVersionReq {
  1: required string environment,
  2: required string service,
  3: required string repository,
  4: required string commit,
  5: optional string entryPath,
}

struct RollbackGatewayVersionReq {
  1: required string environment,
  2: required string service,
}

struct GatewayConfigReq {
  1: required string environment,
}

struct GatewayRoute {
  1: required string method,
  2: required string path,
}

struct GatewayServiceBinding {
  1: required string service,
  2: required string repository,
  3: required string commit,
  4: required string entryPath,
  5: required list<IDLFile> files,
  6: required list<GatewayRoute> routes,
}

struct GatewayConfigResp {
  1: required string environment,
  2: required string revision,
  3: required list<GatewayServiceBinding> bindings,
}

struct ReportGatewayStatusReq {
  1: required string environment,
  2: required string gatewayId,
  3: required string revision,
  4: required string status,
  5: optional string error,
  6: required map<string,string> applied,
}
