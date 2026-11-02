namespace go pam.game.admin.v1
namespace js pam.game.admin.v1

include "types.thrift"

service GameAdminService {
  types.OverviewResp GetOverview(1: required types.OverviewReq req) throws (1: types.GameAdminError err) (
    api.get = "/platform/admin/analytics/overview",
    api.operation_id = "getAdminAnalyticsOverview",
    api.summary = "查询平台数据总览",
    api.auth_required = "true",
    api.auth_roles = "admin"
  )

  types.UsersResp ListUsers(1: required types.ListUsersReq req) throws (1: types.GameAdminError err) (
    api.get = "/platform/admin/analytics/users",
    api.operation_id = "listAdminAnalyticsUsers",
    api.summary = "查询用户活跃列表",
    api.auth_required = "true",
    api.auth_roles = "admin"
  )

  types.UserActivityResp GetUserActivity(1: required types.GetUserActivityReq req) throws (1: types.GameAdminError err) (
    api.get = "/platform/admin/analytics/users/:user_id",
    api.operation_id = "getAdminAnalyticsUserActivity",
    api.summary = "查询单个用户活跃分析",
    api.auth_required = "true",
    api.auth_roles = "admin"
  )

  types.GamesResp ListGames(1: required types.EmptyReq req) throws (1: types.GameAdminError err) (
    api.get = "/platform/admin/analytics/games",
    api.operation_id = "listAdminAnalyticsGames",
    api.summary = "查询游戏活跃分析",
    api.auth_required = "true",
    api.auth_roles = "admin"
  )

  types.LiveResp GetLive(1: required types.EmptyReq req) throws (1: types.GameAdminError err) (
    api.get = "/platform/admin/analytics/live",
    api.operation_id = "getAdminAnalyticsLive",
    api.summary = "查询平台实时概况",
    api.auth_required = "true",
    api.auth_roles = "admin"
  )
} (
  pam.schema_version = "1",
  pam.psm = "game.admin.rpc",
  pam.description = "游戏平台只读运营数据分析契约",
  pam.client.go.module = "github.com/nciyuan9264/game-admin-client",
  pam.client.go.repository = "nciyuan9264/game-admin-client",
  pam.client.go.base_ref = "main"
)
