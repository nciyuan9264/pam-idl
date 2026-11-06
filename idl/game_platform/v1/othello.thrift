namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "room.thrift"
include "types.thrift"

typedef string OthelloSide
typedef string OthelloDisc

struct OthelloLegalMove {
  1: required i32 index,
  2: required list<i32> flips,
  3: required list<list<i32>> lines,
}

struct OthelloMoveEntry {
  1: required i32 id,
  2: required string kind,
  3: required string playerID,
  4: required OthelloSide side,
  5: optional i32 index,
  6: required list<i32> flips,
  7: required bool automatic,
}

struct OthelloPlayerState {
  1: required OthelloSide side,
  2: required i32 discCount,
}

struct OthelloPositionAnalysis {
  1: required string requestID,
  2: required string status,
  3: optional double blackWinRate,
  4: optional double drawRate,
  5: optional double whiteWinRate,
  6: optional i32 score,
  7: optional i32 depth,
  8: optional i64 elapsedMs,
  9: required bool exact,
  10: required string engineVersion,
}

struct OthelloRoomData {
  1: required list<OthelloDisc> board,
  2: required string currentPlayer,
  3: required OthelloSide currentSide,
  4: required string blackPlayerID,
  5: required string whitePlayerID,
  6: required i32 roundNo,
  7: required string gameStatus,
  8: required list<OthelloLegalMove> legalMoves,
  9: required list<OthelloMoveEntry> moveLog,
  10: optional OthelloMoveEntry lastData,
  11: optional string turnDeadline,
  12: optional i64 turnTimeoutMs,
  13: required map<string, room.RoomPlayer> players,
  14: required list<string> playerOrder,
  15: optional OthelloPositionAnalysis analysis,
}

struct OthelloResult {
  1: required i32 blackCount,
  2: required i32 whiteCount,
  3: optional string winnerID,
  4: optional OthelloSide winnerSide,
  5: required bool draw,
  6: required string reason,
}

struct OthelloRoomView {
  1: required string playerId,
  2: required string ownerID,
  3: required string visibility,
  4: required map<string, OthelloPlayerState> playerData,
  5: required OthelloRoomData roomData,
  6: optional OthelloResult result,
}

struct OthelloReplaySnapshot {
  1: required i32 seq,
  2: required i32 totalEvents,
  3: optional types.ReplayEvent currentEvent,
  4: required OthelloRoomData roomData,
  5: required map<string, OthelloPlayerState> playersData,
  6: required OthelloResult result,
}

struct OthelloPlaceDiscPayload {
  1: required i32 index,
}

union OthelloCommandPayload {
  1: OthelloPlaceDiscPayload placeDisc,
  2: types.EmptyPayload pass,
  3: types.EmptyPayload resign,
}
