namespace go pam.platform.control.v1
namespace js pam.platform.control.v1

struct RoomRecord {
  1: required string room_id,
  2: required string game_type,
  3: required string owner_user_id,
  4: required string owner_player_id,
  5: required string owner_node,
  6: required i64 epoch,
  7: required string status,
  8: required i32 max_players,
  9: required i32 player_count,
  10: required string engine_version,
  11: required i64 created_at_unix,
  12: required i64 updated_at_unix,
  13: optional i64 lease_expires_at_unix,
  14: optional string current_match_id,
  15: required i32 next_round_no,
}

struct CreateRoomReq {
  1: required string game_type,
  2: required string owner_user_id,
  3: required string owner_player_id,
  4: optional i32 max_players,
  5: optional string request_id,
}

struct CreateRoomResp {
  1: required RoomRecord room,
}

struct StartMatchReq {
  1: required string room_id,
  2: required string actor_user_id,
  3: optional list<string> actor_roles,
  4: optional string request_id,
}

struct StartMatchResp {
  1: required bool success,
  2: required RoomRecord room,
  3: required string match_id,
  4: required i32 round_no,
}

struct RoomActionReq {
  1: required string room_id,
  2: required string actor_user_id,
  3: optional string reason,
  4: optional string request_id,
  5: optional list<string> actor_roles,
}

struct RoomActionResp {
  1: required bool success,
  2: optional RoomRecord room,
}

struct DrainRoomHostReq {
  1: required string node_id,
  2: required string actor_user_id,
  3: optional string reason,
}

struct DrainRoomHostResp {
  1: required bool success,
  2: required i32 affected_rooms,
}

exception ControlError {
  1: required string code,
  2: required string message,
}
