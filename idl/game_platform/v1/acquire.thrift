namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "room.thrift"
include "types.thrift"

struct AcquireTile {
  1: required string id,
  2: required string belong,
}

struct AcquirePlayerState {
  1: required i32 money,
  2: required map<string, i32> stocks,
  3: required list<string> tiles,
}

struct AcquireCompanyState {
  1: required string name,
  2: required i32 stockPrice,
  3: required i32 stockTotal,
  4: required i32 tiles,
}

struct AcquireMergingSelection {
  1: required list<string> mainCompany,
  2: required list<string> otherCompany,
}

struct AcquireSettledHolding {
  1: required i32 holdingBefore,
  2: required i32 sellAmount,
  3: required i32 exchangeAmount,
}

struct AcquireSettleData {
  1: required list<string> hoders,
  2: required map<string, i32> dividends,
  3: optional map<string, AcquireSettledHolding> settled,
}

struct AcquireEndGameState {
  1: required bool eligible,
  2: required string condition,
  3: required string company,
  4: required i32 tileCount,
  5: required map<string, bool> votes,
}

struct AcquireRoomData {
  1: required map<string, AcquireCompanyState> companyInfo,
  2: required string currentPlayer,
  3: required string gameStatus,
  4: required map<string, AcquireTile> tiles,
  5: required map<string, room.RoomPlayer> players,
  6: required list<string> playerOrder,
  7: optional string turnDeadline,
  8: optional i64 turnTimeoutMs,
  9: optional AcquireEndGameState endGame,
}

struct AcquireTempData {
  1: required string last_tile_key,
  2: required map<string, AcquireSettleData> mergeSettleData,
  3: required string merge_main_company_temp,
  4: required AcquireMergingSelection merge_selection_temp,
}

struct AcquirePlayerResult {
  1: required i32 money,
  2: required i32 stocks,
  3: required i32 total,
}

struct AcquireRoomView {
  1: required string playerId,
  2: required string ownerID,
  3: required string visibility,
  4: required AcquirePlayerState playerData,
  5: required AcquireRoomData roomData,
  6: required AcquireTempData tempData,
  7: optional map<string, AcquirePlayerResult> result,
}

struct AcquireReplayRoomData {
  1: required map<string, AcquireCompanyState> companyInfo,
  2: required string currentPlayer,
  3: required string gameStatus,
  4: required map<string, AcquireTile> tiles,
  5: required map<string, room.RoomPlayer> players,
  6: optional AcquireEndGameState endGame,
}

struct AcquireReplaySnapshot {
  1: required i32 seq,
  2: required i32 totalEvents,
  3: optional types.ReplayEvent currentEvent,
  4: required AcquireReplayRoomData roomData,
  5: required map<string, AcquirePlayerState> playersData,
  6: required map<string, AcquirePlayerResult> result,
}

struct AcquirePlaceTilePayload {
  1: required string tileKey,
}

struct AcquireCreateCompanyPayload {
  1: required string company,
}

struct AcquireMergingSelectionPayload {
  1: required string mainCompany,
}

struct AcquireMergingSettleAction {
  1: required string company,
  2: required i32 sellAmount,
  3: required i32 exchangeAmount,
}

struct AcquireMergingSettlePayload {
  1: required list<AcquireMergingSettleAction> actions,
}

struct AcquireBuyStockPayload {
  1: required map<string, i32> stocks,
}

struct AcquireEndVotePayload {
  1: required bool allow,
}

union AcquireCommandPayload {
  1: AcquirePlaceTilePayload placeTile,
  2: AcquireCreateCompanyPayload createCompany,
  3: AcquireMergingSelectionPayload mergingSelection,
  4: AcquireMergingSettlePayload mergingSettle,
  5: AcquireBuyStockPayload buyStock,
  6: AcquireEndVotePayload endVote,
}
