namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "room.thrift"
include "types.thrift"

struct SplendorDevelopmentCard {
  1: required i32 id,
  2: required i32 level,
  3: required string bonus,
  4: required i32 points,
  5: required map<string, i32> cost,
  6: required i32 state,
}

struct SplendorNoble {
  1: required string id,
  2: required map<string, i32> cost,
  3: required i32 points,
  4: required i32 state,
}

struct SplendorPlayerState {
  1: required list<SplendorDevelopmentCard> normalCard,
  2: required list<SplendorNoble> nobleCard,
  3: required map<string, i32> gem,
  4: required i32 score,
  5: required list<SplendorDevelopmentCard> reserveCard,
}

struct SplendorLastAction {
  1: required string action,
  2: required string playerID,
  3: optional string payloadJSON,
}

struct SplendorRoomData {
  1: required map<string, list<SplendorDevelopmentCard>> card,
  2: required map<string, i32> deckCounts,
  3: required map<string, i32> gems,
  4: required list<SplendorNoble> nobles,
  5: required string currentPlayer,
  6: required string gameStatus,
  7: optional SplendorLastAction lastData,
  8: optional string turnDeadline,
  9: optional i64 turnTimeoutMs,
  10: required map<string, room.RoomPlayer> players,
  11: required list<string> playerOrder,
}

struct SplendorPlayerResult {
  1: required i32 score,
  2: required i32 cards,
  3: required i32 nobles,
}

struct SplendorRoomView {
  1: required string playerId,
  2: required string ownerID,
  3: required string visibility,
  4: required map<string, SplendorPlayerState> playerData,
  5: required SplendorRoomData roomData,
  6: optional map<string, SplendorPlayerResult> result,
}

struct SplendorReplaySnapshot {
  1: required i32 seq,
  2: required i32 totalEvents,
  3: optional types.ReplayEvent currentEvent,
  4: required SplendorRoomView view,
}

struct SplendorGetGemPayload {
  1: required map<string, i32> take,
  2: optional map<string, i32> returns,
}

struct SplendorBuyCardPayload {
  1: required i32 cardID,
}

struct SplendorPreserveCardPayload {
  1: required i32 cardID,
  2: optional map<string, i32> returns,
}

union SplendorCommandPayload {
  1: SplendorGetGemPayload getGem,
  2: SplendorBuyCardPayload buyCard,
  3: SplendorPreserveCardPayload preserveCard,
}
