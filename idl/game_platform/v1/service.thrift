namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "types.thrift"
include "room.thrift"
include "history.thrift"
include "realtime.thrift"

service GamePlatformService {
  room.RoomResp CreateRoom(1: required room.CreateRoomReq req) throws (1: types.GamePlatformError err) (
    api.post = "/platform/rooms",
    api.operation_id = "createRoom",
    api.summary = "创建游戏房间",
    api.auth_required = "true",
    api.content_type = "application/json"
  )

  room.RoomListResp ListRooms(1: required room.ListRoomsReq req) throws (1: types.GamePlatformError err) (
    api.get = "/platform/rooms",
    api.operation_id = "listRooms",
    api.summary = "查询可见活动房间",
    api.auth_required = "true"
  )

  room.RoomResp GetRoom(1: required room.GetRoomReq req) throws (1: types.GamePlatformError err) (
    api.get = "/platform/rooms/:room_id",
    api.operation_id = "getRoom",
    api.summary = "按完整房间号查询房间",
    api.auth_required = "true"
  )

  room.RoomResp CloseRoom(1: required room.CloseRoomReq req) throws (1: types.GamePlatformError err) (
    api.delete = "/platform/rooms/:room_id",
    api.operation_id = "closeRoom",
    api.summary = "关闭房间",
    api.auth_required = "true",
    api.content_type = "application/json"
  )

  room.StartNextMatchResp StartNextMatch(1: required room.StartNextMatchReq req) throws (1: types.GamePlatformError err) (
    api.post = "/platform/rooms/:room_id/matches",
    api.operation_id = "startNextMatch",
    api.summary = "在现有房间开始下一局",
    api.auth_required = "true",
    api.content_type = "application/json"
  )

  history.HistoryListResp ListHistoryGames(1: required history.ListHistoryGamesReq req) throws (1: types.GamePlatformError err) (
    api.get = "/platform/history/games",
    api.operation_id = "listHistoryGames",
    api.summary = "查询当前用户历史对局",
    api.auth_required = "true"
  )

  history.HistoryDetailResp GetHistoryDetail(1: required history.GetHistoryDetailReq req) throws (1: types.GamePlatformError err) (
    api.get = "/platform/history/games/:id",
    api.operation_id = "getHistoryDetail",
    api.summary = "查询历史对局详情",
    api.auth_required = "true"
  )

  history.SnapshotResp GetSnapshot(1: required history.GetSnapshotReq req) throws (1: types.GamePlatformError err) (
    api.get = "/platform/history/games/:id/snapshot",
    api.operation_id = "getSnapshot",
    api.summary = "查询回放快照",
    api.auth_required = "true"
  )

  history.SnapshotListResp ListSnapshots(1: required history.ListSnapshotsReq req) throws (1: types.GamePlatformError err) (
    api.get = "/platform/history/games/:id/snapshots",
    api.operation_id = "listSnapshots",
    api.summary = "分页查询回放快照",
    api.auth_required = "true"
  )

  history.StatsResp GetStats(1: required history.GetStatsReq req) throws (1: types.GamePlatformError err) (
    api.get = "/platform/history/stats",
    api.operation_id = "getStats",
    api.summary = "查询当前用户游戏统计",
    api.auth_required = "true"
  )

  history.LeaderboardResp GetLeaderboard(1: required history.GetLeaderboardReq req) throws (1: types.GamePlatformError err) (
    api.get = "/platform/rankings",
    api.operation_id = "getLeaderboard",
    api.summary = "查询全局排行榜",
    api.auth_required = "false"
  )
} (
  pam.schema_version = "1",
  pam.psm = "game.platform.rpc",
  pam.description = "游戏平台房间、历史、回放、统计、排行与实时契约",
  pam.client.go.module = "github.com/nciyuan9264/game-platform-client",
  pam.client.go.repository = "nciyuan9264/game-platform-client",
  pam.client.go.base_ref = "main"
)
