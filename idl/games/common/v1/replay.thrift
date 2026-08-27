namespace go pam.games.common.v1
namespace js pam.games.common.v1

// 回放公共契约。仅放置所有游戏语义与字段编号一致的结构。

struct EventInfo {
  1: required i32 seq,
  2: required string playerID,
  3: required string cmdType,
  4: optional string payload, // 原始 JSON
}

struct Snapshot {
  1: required i32 seq,
  2: required i32 totalEvents,
  3: optional EventInfo currentEvent,
  4: required string roomData,
  5: required string playersData,
  6: required string result,
}

struct SnapshotReq {
  1: required i64 id (api.path = "id"),
  2: optional string game_type (api.query = "game_type"),
  3: optional i32 seq (api.query = "seq"), // 回放到第几步，-1 表示初始状态
}

struct SnapshotResp {
  1: required i32 status_code,
  2: required string message,
  3: required Snapshot data,
}

struct SnapshotsReq {
  1: required i64 id (api.path = "id"),
}

struct SnapshotsData {
  1: required i32 totalEvents,
  2: required list<Snapshot> snapshots,
}

struct SnapshotsResp {
  1: required i32 status_code,
  2: required string message,
  3: required SnapshotsData data,
}
