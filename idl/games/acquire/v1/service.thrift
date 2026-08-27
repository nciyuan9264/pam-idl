namespace go pam.games.acquire.v1
namespace js pam.games.acquire.v1

include "types.thrift"
include "../../common/v1/room.thrift"
include "../../common/v1/history.thrift"
include "../../common/v1/leaderboard.thrift"
include "../../common/v1/replay.thrift"

service AcquireService {
  room.CreateRoomResp CreateRoom() (
    api.post = "/api/acquire/room/create",
    api.operation_id = "createRoom",
    api.summary = "创建房间",
    api.auth_required = "true"
  )

  room.RoomListResp GetRoomList() (
    api.get = "/api/acquire/room/list",
    api.operation_id = "getRoomList",
    api.summary = "获取房间列表",
    api.auth_required = "true"
  )

  types.GameStatusResp GetGameStatus(1: types.GameStatusReq req) (
    api.get = "/api/acquire/room/game_status",
    api.operation_id = "getGameStatus",
    api.summary = "获取房间游戏状态",
    api.auth_required = "true"
  )

  history.HistoryListResp ListHistoryGames(1: history.ListHistoryGamesReq req) (
    api.get = "/api/acquire/history/games",
    api.operation_id = "listHistoryGames",
    api.summary = "查询当前用户历史对局列表",
    api.auth_required = "true"
  )

  history.HistoryDetailResp GetHistoryGameDetail(1: history.HistoryDetailReq req) (
    api.get = "/api/acquire/history/game/:id",
    api.operation_id = "getHistoryGameDetail",
    api.summary = "查询单局历史详情",
    api.auth_required = "true"
  )

  replay.SnapshotResp GetHistoryGameSnapshot(1: replay.SnapshotReq req) (
    api.get = "/api/acquire/history/game/:id/snapshot",
    api.operation_id = "getHistoryGameSnapshot",
    api.summary = "查询单步回放快照",
    api.auth_required = "true"
  )

  replay.SnapshotsResp GetHistoryGameSnapshots(1: replay.SnapshotsReq req) (
    api.get = "/api/acquire/history/game/:id/snapshots",
    api.operation_id = "getHistoryGameSnapshots",
    api.summary = "查询整局所有回合快照",
    api.auth_required = "true"
  )

  history.HistoryStatsResp GetHistoryStats(1: history.HistoryStatsReq req) (
    api.get = "/api/acquire/history/stats",
    api.operation_id = "getHistoryStats",
    api.summary = "查询当前用户胜率统计",
    api.auth_required = "true"
  )

  leaderboard.LeaderboardResp GetLeaderboard(1: leaderboard.LeaderboardReq req) (
    api.get = "/api/acquire/ranking/leaderboard",
    api.operation_id = "getLeaderboard",
    api.summary = "查询全玩家排行榜"
  )
}
