namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "room.thrift"
include "types.thrift"

typedef string HiveSide
typedef string HivePieceKind
typedef string HiveActionKind

struct HiveHex {
  1: required i32 q,
  2: required i32 r,
}

struct HivePiece {
  1: required string pieceID,
  2: required HiveSide side,
  3: required HivePieceKind kind,
  4: required i32 number,
}

struct HiveStack {
  1: required HiveHex position,
  2: required list<HivePiece> pieces,
}

struct HiveMoveOption {
  1: required HiveActionKind kind,
  2: required string pieceID,
  3: required HiveHex to,
  4: required list<HiveHex> path,
}

struct HiveActionEntry {
  1: required i32 id,
  2: required HiveActionKind kind,
  3: required string playerID,
  4: required HiveSide side,
  5: optional string pieceID,
  6: optional HiveHex from,
  7: optional HiveHex to,
  8: required list<HiveHex> path,
  9: required bool automatic,
}

struct HivePlayerState {
  1: required HiveSide side,
  2: required i32 turnsTaken,
  3: required bool queenPlaced,
  4: required i32 queenPressure,
  5: required map<HivePieceKind, i32> reserveByKind,
}

struct HiveRoomData {
  1: required list<HiveStack> stacks,
  2: required string currentPlayer,
  3: required HiveSide currentSide,
  4: required string whitePlayerID,
  5: required string blackPlayerID,
  6: required string firstPlayerID,
  7: required i32 roundNo,
  8: required string gameStatus,
  9: required list<HiveMoveOption> legalActions,
  10: required list<HiveActionEntry> moveLog,
  11: optional HiveActionEntry lastAction,
  12: optional string turnDeadline,
  13: optional i64 turnTimeoutMs,
  14: required map<string, room.RoomPlayer> players,
  15: required list<string> playerOrder,
}

struct HiveResult {
  1: optional string winnerID,
  2: optional HiveSide winnerSide,
  3: required bool draw,
  4: required string reason,
  5: required i32 turnCount,
  6: required i32 placedPieceCount,
  7: required i32 maxStackHeight,
}

struct HiveRoomView {
  1: required string playerId,
  2: required string ownerID,
  3: required string visibility,
  4: required map<string, HivePlayerState> playerData,
  5: required HiveRoomData roomData,
  6: optional HiveResult result,
}

struct HiveReplaySnapshot {
  1: required i32 seq,
  2: required i32 totalEvents,
  3: optional types.ReplayEvent currentEvent,
  4: required HiveRoomData roomData,
  5: required map<string, HivePlayerState> playersData,
  6: optional HiveResult result,
}

struct HivePlacePiecePayload {
  1: required string pieceID,
  2: required HiveHex to,
}

struct HiveMovePiecePayload {
  1: required string pieceID,
  2: required HiveHex to,
}

union HiveCommandPayload {
  1: HivePlacePiecePayload placePiece,
  2: HiveMovePiecePayload movePiece,
  3: types.EmptyPayload resign,
}
