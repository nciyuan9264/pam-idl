namespace go pam.platform.v1
namespace js pam.platform.v1

include "types.thrift"

service PamPlatformService {
  types.HealthzResp Healthz() (
    api.get = "/healthz",
    api.operation_id = "healthz",
    api.summary = "健康检查"
  )

  types.SnapshotResp GetSnapshot(1: types.SnapshotReq req) (
    api.get = "/api/snapshot",
    api.operation_id = "getSnapshot",
    api.summary = "获取 IDL 平台快照",
    api.auth_required = "true"
  )

  types.ServiceCatalogResp ListServices() (
    api.get = "/api/services",
    api.operation_id = "listServices",
    api.summary = "获取轻量服务目录",
    api.auth_required = "true"
  )

  types.ServiceVersionsResp ListServiceVersions(1: required types.ListServiceVersionsReq req) (
    api.get = "/api/versions",
    api.operation_id = "listServiceVersions",
    api.summary = "获取服务的不可变 IDL 版本",
    api.auth_required = "true"
  )

  types.SyncStatusResp GetOSSSyncStatus() (
    api.get = "/api/idl/oss-sync/status",
    api.operation_id = "getOssSyncStatus",
    api.summary = "获取 OSS IDL 同步状态"
  )

  types.StatusResp SyncIDL(1: required types.SyncIDLReq req) (
    api.post = "/api/idl/sync",
    api.operation_id = "syncIdl",
    api.summary = "同步提交的 IDL 文件",
    api.auth_required = "true"
  )

  types.StatusResp TriggerOSSSync() (
    api.post = "/api/idl/oss-sync",
    api.operation_id = "triggerOssSync",
    api.summary = "触发 OSS IDL 后台同步",
    api.auth_required = "true"
  )

  types.StatusResp ReportClientBuild(1: required types.ReportClientBuildReq req) (
    api.post = "/api/client-builds/report",
    api.operation_id = "reportClientBuild",
    api.summary = "回报生成客户端构建状态",
    api.auth_required = "true"
  )

  types.StatusResp PromoteGatewayVersion(1: required types.PromoteGatewayVersionReq req) (
    api.post = "/api/gateway/bindings/promote",
    api.operation_id = "promoteGatewayVersion",
    api.summary = "将指定 IDL 版本晋级到 Gateway 环境",
    api.auth_required = "true"
  )

  types.StatusResp RollbackGatewayVersion(1: required types.RollbackGatewayVersionReq req) (
    api.post = "/api/gateway/bindings/rollback",
    api.operation_id = "rollbackGatewayVersion",
    api.summary = "回滚 Gateway 环境中的服务版本",
    api.auth_required = "true"
  )

  types.GatewayConfigResp GetGatewayConfig(1: required types.GatewayConfigReq req) (
    api.internal = "true"
  )

  types.StatusResp ReportGatewayStatus(1: required types.ReportGatewayStatusReq req) (
    api.internal = "true"
  )
}
