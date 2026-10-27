namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "room.thrift"
include "types.thrift"

typedef string ForSaleGameStatus
typedef string ForSaleActionSource

struct ForSaleTrade {
  1: required string playerID,
  2: required i32 property,
  3: required i32 amount,
}

struct ForSaleRoundRecord {
  1: required i32 round,
  2: required list<ForSaleTrade> trades,
}

struct ForSaleActionEntry {
  1: required i32 id,
  2: required i32 round,
  3: required string phase,
  4: required string kind,
  5: required string playerID,
  6: required ForSaleActionSource source,
  7: optional i32 amount,
  8: optional i32 property,
  9: optional i32 cheque,
  10: optional i32 paid,
}

struct ForSalePlayerState {
  1: required i32 seatIndex,
  2: required i32 bid,
  3: required bool passed,
  4: required i32 propertyCount,
  5: required i32 chequeCount,
  6: required bool locked,
  7: optional i32 coins,
  8: optional list<i32> properties,
  9: optional list<i32> cheques,
  10: optional i32 lockedProperty,
  11: optional i32 wonProperty,
  12: optional i32 roundCost,
  13: optional string actionDeadline,
  14: optional i64 actionTimeoutMs,
}

struct ForSaleRoomData {
  1: required ForSaleGameStatus gameStatus,
  2: required i32 round,
  3: required i32 totalRounds,
  4: required list<i32> propertyMarket,
  5: required list<i32> chequeMarket,
  6: required i32 highestBid,
  7: required string currentPlayer,
  8: required string starterPlayer,
  9: required i32 lockedCount,
  10: required list<ForSaleRoundRecord> purchases,
  11: required list<ForSaleRoundRecord> sales,
  12: required list<ForSaleActionEntry> actionLog,
  13: optional ForSaleActionEntry lastAction,
  14: optional string transitionDeadline,
  15: optional i64 transitionTimeoutMs,
  16: required map<string, room.RoomPlayer> players,
  17: required list<string> playerOrder,
}

struct ForSalePlayerResult {
  1: required i32 chequeTotal,
  2: required i32 coins,
  3: required i32 total,
  4: required i32 rank,
  5: required bool winner,
}

struct ForSaleRoomView {
  1: required string playerId,
  2: required string ownerID,
  3: required string visibility,
  4: required map<string, ForSalePlayerState> playerData,
  5: required ForSaleRoomData roomData,
  6: optional map<string, ForSalePlayerResult> result,
}

struct ForSaleReplaySnapshot {
  1: required i32 seq,
  2: required i32 totalEvents,
  3: optional types.ReplayEvent currentEvent,
  4: required ForSaleRoomData roomData,
  5: required map<string, ForSalePlayerState> playersData,
  6: required map<string, ForSalePlayerResult> result,
}

struct ForSaleBidPayload {
  1: required i32 amount,
}

struct ForSaleLockSalePayload {
  1: required i32 property,
}

union ForSaleCommandPayload {
  1: ForSaleBidPayload bid,
  2: types.EmptyPayload pass,
  3: ForSaleLockSalePayload lockSale,
  4: types.EmptyPayload revealSale,
  5: types.EmptyPayload nextRound,
  6: types.EmptyPayload startSelling,
}
