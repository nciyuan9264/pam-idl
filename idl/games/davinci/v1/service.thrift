namespace go pam.games.davinci.v1
namespace js pam.games.davinci.v1

include "types.thrift"
include "../../common/v1/room.thrift"
include "../../common/v1/history.thrift"
include "../../common/v1/leaderboard.thrift"

service DavinciService {
  room.CreateRoomResp CreateRoom(1: room.EmptyReq req) (
    api.post = "/api/davinci/room/create",
    api.operation_id = "createRoom",
    api.summary = "创建房间",
    api.auth_required = "true"
  )

  room.RoomListResp GetRoomList(1: room.EmptyReq req) (
    api.get = "/api/davinci/room/list",
    api.operation_id = "getRoomList",
    api.summary = "获取房间列表",
    api.auth_required = "true"
  )

  types.GameStatusResp GetGameStatus(1: types.GameStatusReq req) (
    api.get = "/api/davinci/room/game_status",
    api.operation_id = "getGameStatus",
    api.summary = "获取房间游戏状态",
    api.auth_required = "true"
  )

  history.HistoryListResp ListHistoryGames(1: history.ListHistoryGamesReq req) (
    api.get = "/api/davinci/history/games",
    api.operation_id = "listHistoryGames",
    api.summary = "查询当前用户历史对局列表",
    api.auth_required = "true"
  )

  history.HistoryDetailResp GetHistoryGameDetail(1: history.HistoryDetailReq req) (
    api.get = "/api/davinci/history/game/:id",
    api.operation_id = "getHistoryGameDetail",
    api.summary = "查询单局历史详情",
    api.auth_required = "true"
  )

  history.HistoryStatsResp GetHistoryStats(1: history.HistoryStatsReq req) (
    api.get = "/api/davinci/history/stats",
    api.operation_id = "getHistoryStats",
    api.summary = "查询当前用户胜率统计",
    api.auth_required = "true"
  )

  leaderboard.LeaderboardResp GetLeaderboard(1: leaderboard.LeaderboardReq req) (
    api.get = "/api/davinci/ranking/leaderboard",
    api.operation_id = "getLeaderboard",
    api.summary = "查询全玩家排行榜"
  )
} (
  pam.schema_version = "1",
  pam.psm = "game.davinci.rpc",
  pam.description = "Davinci 游戏房间、历史和排行榜契约",
  pam.client.go.module = "github.com/nciyuan9264/game-davinci-client",
  pam.client.go.repository = "nciyuan9264/game-davinci-client",
  pam.client.go.base_ref = "main"
)
