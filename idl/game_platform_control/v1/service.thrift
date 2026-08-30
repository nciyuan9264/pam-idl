namespace go pam.platform.control.v1
namespace js pam.platform.control.v1

include "types.thrift"

service PlatformControlService {
  types.CreateRoomResp CreateRoom(1: types.CreateRoomReq req) throws (1: types.ControlError err) (
    api.internal = "true"
  )

  types.StartMatchResp StartMatch(1: types.StartMatchReq req) throws (1: types.ControlError err) (
    api.internal = "true"
  )

  types.RoomActionResp CloseRoom(1: types.RoomActionReq req) throws (1: types.ControlError err) (
    api.internal = "true"
  )

  types.RoomActionResp InterruptRoom(1: types.RoomActionReq req) throws (1: types.ControlError err) (
    api.internal = "true"
  )

  types.DrainRoomHostResp DrainRoomHost(1: types.DrainRoomHostReq req) throws (1: types.ControlError err) (
    api.internal = "true"
  )
} (
  pam.schema_version = "1",
  pam.psm = "game.platform.control",
  pam.description = "游戏平台内部 Control Plane RPC 契约",
  pam.client.go.module = "github.com/nciyuan9264/game-platform-control-client",
  pam.client.go.repository = "nciyuan9264/game-platform-control-client",
  pam.client.go.base_ref = "main"
)
