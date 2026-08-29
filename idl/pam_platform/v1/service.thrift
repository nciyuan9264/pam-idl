namespace go pam.platform.v1
namespace js pam.platform.v1

include "types.thrift"

service PamPlatformService {
  types.HealthzResp Healthz(1: types.EmptyReq req) (
    api.get = "/healthz",
    api.operation_id = "healthz",
    api.summary = "健康检查"
  )

  types.SnapshotResp GetSnapshot(1: types.SnapshotReq req) (
    api.get = "/api/snapshot",
    api.operation_id = "getSnapshot",
    api.summary = "获取 IDL 平台快照",
    api.auth_required = "false"
  )

  types.ServiceCatalogResp ListServices(1: types.EmptyReq req) (
    api.get = "/api/services",
    api.operation_id = "listServices",
    api.summary = "获取轻量服务目录",
    api.auth_required = "false"
  )

  types.ServiceVersionsResp ListServiceVersions(1: required types.ListServiceVersionsReq req) (
    api.get = "/api/versions",
    api.operation_id = "listServiceVersions",
    api.summary = "获取服务的不可变 IDL 版本",
    api.auth_required = "false"
  )

  types.PipelineRunResp EnqueueIDLPipeline(1: required types.EnqueueIDLPipelineReq req) (
    api.post = "/api/idl/pipelines",
    api.operation_id = "enqueueIdlPipeline",
    api.summary = "创建精确 IDL commit 处理任务",
    api.auth_required = "true"
  )

  types.PipelineRunsResp ListPipelineRuns(1: required types.ListPipelineRunsReq req) (
    api.get = "/api/idl/pipelines",
    api.operation_id = "listPipelineRuns",
    api.summary = "查询 IDL 与客户端生成任务进度",
    api.auth_required = "false"
  )

  types.StatusResp SyncIDL(1: required types.SyncIDLReq req) (
    api.post = "/api/idl/sync",
    api.operation_id = "syncIdl",
    api.summary = "同步提交的 IDL 文件",
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
