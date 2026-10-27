namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "room.thrift"
include "types.thrift"

typedef string OnitamaSide
typedef string OnitamaPieceKind
typedef string OnitamaActionKind

struct OnitamaCell {
  1: required i32 row,
  2: required i32 column,
}

struct OnitamaPiece {
  1: required string id,
  2: required OnitamaSide side,
  3: required OnitamaPieceKind kind,
  4: required OnitamaCell cell,
}

struct OnitamaLegalMove {
  1: required string cardID,
  2: required string pieceID,
  3: required OnitamaCell to,
  4: optional string capturedPieceID,
  5: required bool winning,
}

struct OnitamaActionEntry {
  1: required i32 id,
  2: required OnitamaActionKind kind,
  3: required string playerID,
  4: required OnitamaSide side,
  5: optional string cardID,
  6: optional string pieceID,
  7: optional OnitamaCell from,
  8: optional OnitamaCell to,
  9: optional string capturedPieceID,
  10: optional OnitamaPieceKind capturedKind,
  11: optional string receivedCardID,
  12: required bool automatic,
}

struct OnitamaPlayerState {
  1: required OnitamaSide side,
  2: required i32 pieceCount,
  3: required bool masterAlive,
}

struct OnitamaRoomData {
  1: required list<OnitamaPiece> pieces,
  2: required map<OnitamaSide, list<string>> hands,
  3: required string transitCardID,
  4: required string currentPlayer,
  5: required OnitamaSide currentSide,
  6: required string bluePlayerID,
  7: required string redPlayerID,
  8: required string firstPlayerID,
  9: required i32 roundNo,
  10: required string gameStatus,
  11: required list<OnitamaLegalMove> legalMoves,
  12: required bool canPass,
  13: required list<OnitamaActionEntry> moveLog,
  14: optional OnitamaActionEntry lastAction,
  15: optional string turnDeadline,
  16: optional i64 turnTimeoutMs,
  17: required map<string, room.RoomPlayer> players,
  18: required list<string> playerOrder,
}

struct OnitamaResult {
  1: optional string winnerID,
  2: optional OnitamaSide winnerSide,
  3: required string reason,
  4: required i32 turnCount,
  5: required i32 winnerPieceCount,
}

struct OnitamaRoomView {
  1: required string playerId,
  2: required string ownerID,
  3: required string visibility,
  4: required map<string, OnitamaPlayerState> playerData,
  5: required OnitamaRoomData roomData,
  6: optional OnitamaResult result,
}

struct OnitamaReplaySnapshot {
  1: required i32 seq,
  2: required i32 totalEvents,
  3: optional types.ReplayEvent currentEvent,
  4: required OnitamaRoomData roomData,
  5: required map<string, OnitamaPlayerState> playersData,
  6: optional OnitamaResult result,
}

struct OnitamaMovePiecePayload {
  1: required string cardID,
  2: required string pieceID,
  3: required OnitamaCell to,
}

struct OnitamaPassPayload {
  1: required string cardID,
}

union OnitamaCommandPayload {
  1: OnitamaMovePiecePayload movePiece,
  2: OnitamaPassPayload pass,
  3: types.EmptyPayload resign,
}
