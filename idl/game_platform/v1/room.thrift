namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "types.thrift"

struct RoomPlayer {
  1: optional string userID,
  2: required string playerID,
  3: required string displayName,
  4: optional string avatar,
  5: required i32 seatIndex,
  6: required bool online,
  7: required bool ai,
  8: required bool ready,
  9: optional string gameRole,
}

struct AcquireRoomMetrics {
  1: required i32 emptyTileCount,
  2: required i32 progressCurrent,
  3: required i32 progressTotal,
}

struct DavinciRoomMetrics {
  1: required i32 boardCardCount,
  2: required i32 progressCurrent,
  3: required i32 progressTotal,
}

struct SplendorRoomMetrics {
  1: required i32 maxScore,
  2: required i32 progressCurrent,
  3: required i32 progressTotal,
}

struct YinshRoomMetrics {
  1: required i32 ringsRemoved,
  2: required i32 progressCurrent,
  3: required i32 progressTotal,
}

struct OthelloRoomMetrics {
  1: required i32 occupiedCount,
  2: required i32 progressCurrent,
  3: required i32 progressTotal,
}

struct FugitiveRoomMetrics {
  1: required i32 highestRevealed,
  2: required i32 hiddenHideoutCount,
  3: required i32 progressCurrent,
  4: required i32 progressTotal,
}

struct WarChestRoomMetrics {
  1: required i32 maxControlledLocations,
  2: required i32 progressCurrent,
  3: required i32 progressTotal,
}

struct QuoridorRoomMetrics {
  1: required i32 turnCount,
}

struct LoveLetterRoomMetrics {
  1: required i32 currentRound,
  2: required i32 maxFavor,
  3: required i32 targetFavor,
  4: required i32 progressCurrent,
  5: required i32 progressTotal,
}

struct SixNimmtRoomMetrics {
  1: required i32 maxPenalty,
  2: required i32 targetPenalty,
  3: required i32 progressCurrent,
  4: required i32 progressTotal,
}

struct HexRoomMetrics {
  1: required i32 turnCount,
}

union RoomMetrics {
  1: AcquireRoomMetrics acquire,
  2: DavinciRoomMetrics davinci,
  3: SplendorRoomMetrics splendor,
  4: YinshRoomMetrics yinsh,
  5: OthelloRoomMetrics othello,
  6: FugitiveRoomMetrics fugitive,
  7: WarChestRoomMetrics warchest,
  8: QuoridorRoomMetrics quoridor,
  9: LoveLetterRoomMetrics loveletter,
  10: SixNimmtRoomMetrics sixnimmt,
  11: HexRoomMetrics hex,
}

struct RoomInfo {
  1: required string roomID,
  2: required types.GameType gameType,
  3: required string status,
  4: required types.Visibility visibility,
  5: required string ownerUserID,
  6: required string ownerPlayerID,
  7: required i32 maxPlayers,
  8: required i32 playerCount,
  9: required string currentMatchID,
  10: required string currentMatchStatus,
  11: required i32 nextRoundNo,
  12: required types.ISODateTime createdAt,
  13: required types.ISODateTime updatedAt,
  14: required list<RoomPlayer> players,
  15: required RoomMetrics metrics,
  16: optional string displayName,
  17: optional i32 turnTimeoutSeconds,
}

struct CreateRoomReq {
  1: required types.GameType game_type (api.body = "gameType"),
  2: optional types.Visibility visibility (api.body = "visibility"),
  3: optional i32 max_players (api.body = "maxPlayers"),
  4: required string request_id (api.body = "requestID"),
  5: optional string display_name (api.body = "displayName"),
  6: optional i32 turn_timeout_seconds (api.body = "turnTimeoutSeconds"),
}

struct ListRoomsReq {
  1: required types.GameType game_type (api.query = "gameType"),
}

struct GetRoomReq {
  1: required string room_id (api.path = "room_id"),
  2: required types.GameType game_type (api.query = "gameType"),
}

struct CloseRoomReq {
  1: required string room_id (api.path = "room_id"),
  2: required types.GameType game_type (api.query = "gameType"),
  3: required string request_id (api.body = "requestID"),
}

struct StartNextMatchReq {
  1: required string room_id (api.path = "room_id"),
  2: required types.GameType game_type (api.body = "gameType"),
  3: required string request_id (api.body = "requestID"),
}

struct RoomResp {
  1: required i32 status_code,
  2: required string message,
  3: required RoomInfo data,
}

struct RoomListData {
  1: required list<RoomInfo> rooms,
}

struct RoomListResp {
  1: required i32 status_code,
  2: required string message,
  3: required RoomListData data,
}

struct StartNextMatchData {
  1: required RoomInfo room,
  2: required string matchID,
  3: required i32 roundNo,
}

struct StartNextMatchResp {
  1: required i32 status_code,
  2: required string message,
  3: required StartNextMatchData data,
}
