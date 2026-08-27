namespace go pam.auth.v1
namespace js pam.auth.v1

include "types.thrift"

service AuthService {
  types.BaseResp Register(1: required types.RegisterReq req) throws (1: types.AuthError err) (
    api.post = "/platform/auth/register",
    api.operation_id = "register",
    api.summary = "注册账号"
  )

  types.SendCodeResp SendCode(1: required types.SendCodeReq req) throws (1: types.AuthError err) (
    api.post = "/platform/auth/send-code",
    api.operation_id = "sendCode",
    api.summary = "发送验证码"
  )

  types.LoginResp LoginByPassword(1: required types.LoginByPasswordReq req) throws (1: types.AuthError err) (
    api.post = "/platform/auth/login/password",
    api.operation_id = "loginByPassword",
    api.summary = "密码登录"
  )

  types.LoginResp LoginByCode(1: required types.LoginByCodeReq req) throws (1: types.AuthError err) (
    api.post = "/platform/auth/verify-code",
    api.operation_id = "verifyCode",
    api.summary = "验证验证码并登录"
  )

  types.LoginResp RefreshToken(1: required types.RefreshTokenReq req) throws (1: types.AuthError err) (
    api.post = "/platform/auth/refresh",
    api.operation_id = "refresh",
    api.summary = "刷新 token"
  )

  types.VerifyTokenResp VerifyToken(1: required types.VerifyTokenReq req) throws (1: types.AuthError err) (
    api.post = "/platform/auth/verify-token",
    api.operation_id = "verifyToken",
    api.summary = "验证 token"
  )

  types.BaseResp Logout(1: required types.LogoutReq req) throws (1: types.AuthError err) (
    api.post = "/platform/auth/logout",
    api.operation_id = "logout",
    api.summary = "退出登录"
  )

  types.UserResp GetProfile(1: required types.GetProfileReq req) throws (1: types.AuthError err) (
    api.get = "/platform/auth/profile",
    api.operation_id = "getProfile",
    api.summary = "获取当前用户资料",
    api.auth_required = "true"
  )

  types.UserResp UpdateUser(1: required types.UpdateUserReq req) throws (1: types.AuthError err) (
    api.post = "/platform/auth/update",
    api.operation_id = "updateUser",
    api.summary = "更新用户资料",
    api.auth_required = "true"
  )

  types.UploadAvatarResp UploadAvatar(1: required types.UploadAvatarReq req) throws (1: types.AuthError err) (
    api.post = "/platform/auth/avatar/upload",
    api.operation_id = "uploadAvatar",
    api.summary = "上传头像",
    api.auth_required = "true",
    api.content_type = "multipart/form-data"
  )

  types.UserResp GetUser(1: required types.GetUserReq req) throws (1: types.AuthError err) (
    api.internal = "true"
  )

  types.ListUsersResp ListUsers(1: required types.ListUsersReq req) throws (1: types.AuthError err) (
    api.internal = "true"
  )

  types.JWKSResp GetJWKS(1: required types.JWKSReq req) throws (1: types.AuthError err) (
    api.get = "/.well-known/jwks.json",
    api.operation_id = "getJWKS",
    api.summary = "获取 JWKS"
  )
}
