namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "types.thrift"
include "room.thrift"
include "acquire.thrift"
include "davinci.thrift"
include "splendor.thrift"
include "yinsh.thrift"
include "othello.thrift"
include "fugitive.thrift"
include "warchest.thrift"
include "quoridor.thrift"
include "loveletter.thrift"
include "sixnimmt.thrift"
include "hex.thrift"
include "forsale.thrift"

struct MatchReadyPayload {
  1: required bool ready,
}

struct MatchSeatPayload {
  1: optional i32 seatIndex,
}

struct MatchRemovePlayerPayload {
  1: required string playerID,
}

struct RoomUpdateSettingsPayload {
  1: required types.Visibility visibility,
  2: optional string displayName,
  3: optional i32 turnTimeoutSeconds,
}

union CommonCommandPayload {
  1: MatchReadyPayload matchReady,
  2: MatchSeatPayload matchSeat,
  3: MatchRemovePlayerPayload removePlayer,
  4: RoomUpdateSettingsPayload roomSettings,
  5: types.EmptyPayload empty,
}

union ClientCommandPayload {
  1: CommonCommandPayload common,
  2: acquire.AcquireCommandPayload acquire,
  3: davinci.DavinciCommandPayload davinci,
  4: splendor.SplendorCommandPayload splendor,
  5: yinsh.YinshCommandPayload yinsh,
  6: othello.OthelloCommandPayload othello,
  7: fugitive.FugitiveCommandPayload fugitive,
  8: warchest.WarChestCommandPayload warchest,
  9: quoridor.QuoridorCommandPayload quoridor,
  10: loveletter.LoveLetterCommandPayload loveletter,
  11: sixnimmt.SixNimmtCommandPayload sixnimmt,
  12: hex.HexCommandPayload hex,
  13: forsale.ForSaleCommandPayload forSale,
}

struct ClientCommand {
  1: required i32 schemaVersion,
  2: required string commandID,
  3: required string matchID,
  4: required types.CommandType type,
  5: required ClientCommandPayload payload,
}

union MatchSetupView {
  1: warchest.WarChestMatchSetup warchest,
}

struct MatchSync {
  1: required i32 schemaVersion,
  2: required string type,
  3: required string roomID,
  4: required string matchID,
  5: required i64 seq,
  6: required string ownerID,
  7: required string status,
  8: required string playerID,
  9: required types.Visibility visibility,
  10: required i32 maxPlayers,
  11: required map<string, room.RoomPlayer> players,
  12: required list<string> playerOrder,
  13: optional MatchSetupView setup,
}

union RoomView {
  1: acquire.AcquireRoomView acquire,
  2: davinci.DavinciRoomView davinci,
  3: splendor.SplendorRoomView splendor,
  4: yinsh.YinshRoomView yinsh,
  5: othello.OthelloRoomView othello,
  6: fugitive.FugitiveRoomView fugitive,
  7: warchest.WarChestRoomView warchest,
  8: quoridor.QuoridorRoomView quoridor,
  9: loveletter.LoveLetterRoomView loveletter,
  10: sixnimmt.SixNimmtRoomView sixnimmt,
  11: hex.HexRoomView hex,
  12: forsale.ForSaleRoomView forSale,
}

struct RoomSync {
  1: required i32 schemaVersion,
  2: required string type,
  3: required string roomID,
  4: required string matchID,
  5: required i64 seq,
  6: required RoomView view,
  7: optional list<types.RealtimeEffect> effects,
}

struct CommandResult {
  1: required i32 schemaVersion,
  2: required string type,
  3: required string roomID,
  4: required string matchID,
  5: required i64 seq,
  6: required string commandID,
  7: required bool accepted,
  8: optional string errorCode,
  9: optional string message,
  10: optional bool retryable,
}

struct ErrorMessage {
  1: required i32 schemaVersion,
  2: required string type,
  3: required string roomID,
  4: required string matchID,
  5: required i64 seq,
  6: optional string commandID,
  7: required string code,
  8: required string message,
}

union ServerMessage {
  1: MatchSync matchSync,
  2: RoomSync roomSync,
  3: CommandResult commandResult,
  4: ErrorMessage error,
}
